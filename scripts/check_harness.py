#!/usr/bin/env python3
"""检查固定文档骨架、Agent Notes 路径/格式/冻结封存、Skill 元数据和活跃 Markdown 文件链接，不访问网络。"""
from __future__ import annotations

import argparse
import os
import hashlib
import json
import subprocess
from datetime import date
import re
from pathlib import Path
from urllib.parse import unquote, urlsplit

REQUIRED_DOCUMENTS = ('README.md', 'AGENTS.md', 'docs/AGENTS.md',
                      'docs/architecture.md', 'docs/development.md', 'docs/testing.md')
NOTE_LIFECYCLES = {'proposed', 'implemented', 'rejected', 'archived'}
NOTE_CLASSES = {'feature', 'bug-fix', 'simplification', 'architecture', 'process', 'testing'}

# iShot 生成产物不是活跃项目文档；只排除精确路径。
PROJECT_GENERATED_ROOTS = {'reconstruction/build', 'reconstruction/dist'}

IGNORED = {'.git', 'node_modules', '.venv', '__pycache__', '.cache', 'vendor'}
def inline_targets(line: str) -> list[str]:
    """读取同一行内联链接目标，支持转义、括号和尖括号目标。"""
    # 屏蔽同一行成对反引号代码段，避免把代码示例当链接。
    pieces = list(line)
    index = 0
    while index < len(line):
        if line[index] != '`':
            index += 1
            continue
        end = index
        while end < len(line) and line[end] == '`':
            end += 1
        marker = line[index:end]
        close = line.find(marker, end)
        while close >= 0 and ((close > 0 and line[close - 1] == '`') or
                              (close + len(marker) < len(line) and line[close + len(marker)] == '`')):
            close = line.find(marker, close + 1)
        if close >= 0:
            pieces[index:close + len(marker)] = ' ' * (close + len(marker) - index)
            index = close + len(marker)
        else:
            index = end
    line = ''.join(pieces)
    targets = []
    for match in re.finditer(r'(?<!!)\[[^\]\n]*\]\(|!\[[^\]\n]*\]\(', line):
        start = match.end()
        if start < len(line) and line[start] == '<':
            end = line.find('>', start + 1)
            if end >= 0:
                targets.append(line[start + 1:end])
            continue
        depth, value, escaped = 0, [], False
        for char in line[start:]:
            if escaped:
                value.append(char)
                escaped = False
            elif char == chr(92):
                escaped = True
            elif char == '(':
                depth += 1
                value.append(char)
            elif char == ')':
                if depth == 0:
                    break
                depth -= 1
                value.append(char)
            elif char.isspace() and depth == 0:
                break
            else:
                value.append(char)
        if value:
            targets.append(''.join(value))
    return targets

def check_note_path(relative: Path) -> list[str]:
    """仅约束记录的路径；控制文档不当作记录，不推断决策内容是否正确。"""
    parts = relative.parts
    if parts[:2] != ('.agents', 'notes'):
        return []
    note = parts[2:]
    if note == ('INDEX.md',):
        return [f'Agent Notes 不使用集中式 INDEX.md：{relative}']
    if (len(note) == 1 or (len(note) == 2 and note[0] in NOTE_LIFECYCLES)) and note[-1] in {'README.md', 'AGENTS.md'}:
        return []
    if len(note) != 3 or note[0] not in NOTE_LIFECYCLES or note[1] not in NOTE_CLASSES:
        return [f'Agent Note 路径应为合法状态/类别/日期主题.md：{relative}']
    match = re.fullmatch(r'(\d{4}-\d{2}-\d{2})-[a-z0-9]+(?:-[a-z0-9]+)*\.md', note[2])
    if not match:
        return [f'Agent Note 文件名应为 yyyy-mm-dd-kebab-case-topic.md：{relative}']
    try:
        date.fromisoformat(match.group(1))
    except ValueError:
        return [f'Agent Note 首次提出日期无效：{relative}']
    return []

def prose_lines(content: str) -> list[str]:
    """排除围栏中的格式示例，不把示例标题/状态当成记录结构。"""
    result, fence, length = [], '', 0
    for line in content.splitlines():
        marker = re.match(r'^ {0,3}(`{3,}|~{3,})(.*)$', line)
        if marker:
            if not fence:
                fence, length = marker[1][0], len(marker[1])
            elif marker[1][0] == fence and len(marker[1]) >= length and not marker[2].strip():
                fence = ''
            continue
        if not fence:
            result.append(line)
    return result


def check_note_format(relative: Path, content: str) -> list[str]:
    """改编上游 verify-agent-note-format；单语言中文章节，无产品历史豁免。"""
    if relative.parts[:2] != ('.agents', 'notes') or len(relative.parts) != 5:
        return []
    lifecycle = relative.parts[2]
    if lifecycle not in {'proposed', 'implemented', 'rejected'}:
        return []
    errors, lines = [], content.splitlines()
    def fail(message):
        errors.append(f'Agent Note 格式：{relative}：{message}')
    if not lines or not re.match(r'^# Agent Note: \S', lines[0]):
        fail('首行必须为 # Agent Note: <主题>')
    if len(lines) < 4 or lines[1] != '' or lines[3] != '':
        fail('第 2、4 行必须为空行')
    expected = {'proposed': r'Status: proposed', 'implemented': r'Status: implemented',
                'rejected': r'Status: rejected — \S.*'}[lifecycle]
    if len(lines) < 3 or not re.fullmatch(expected, lines[2]):
        fail('第 3 行状态必须与目录匹配；拒绝状态须有原因')
    prose = prose_lines(content)
    if len([line for line in prose if line.startswith('Status:')]) != 1:
        fail('全篇必须只有一条 Status 行')
    headings = [line.rstrip() for line in prose if line.startswith('## ')]
    if not headings or headings[0] != '## 问题':
        fail('正文首个二级标题必须为 问题')
    required = {'proposed': ('提案', '验收条件', '风险'),
                'implemented': ('决策', '后果'), 'rejected': ('提案',)}[lifecycle]
    for heading in (*required, '考虑过的替代方案'):
        if f'## {heading}' not in headings:
            fail(f'缺少必要章节：{heading}')
    if lifecycle == 'implemented':
        for heading in headings:
            if re.match(r'^## (?:提案|计划|迁移计划|验收条件|Proposal\b|Plan\b|Migration plan\b|Acceptance criteria\b)', heading, re.I):
                fail(f'已实现记录不保留提案期标题：{heading}')
    if any('XXX: legacy ADR/' in line for line in prose):
        fail('不保留旧格式债务标记')
    return errors


ARCHIVE_MANIFEST = '.agents/notes/archived/manifest.json'


def parse_manifest(content: str) -> dict[str, str]:
    value = json.loads(content)
    if not isinstance(value, dict) or set(value) != {'version', 'files'} or type(value['version']) is not int or value['version'] != 1 or not isinstance(value['files'], dict):
        raise ValueError('manifest 必须只含 version: 1 与 files 对象')
    for path, digest in value['files'].items():
        if not isinstance(digest, str) or not re.fullmatch(r'sha256:[0-9a-f]{64}', digest):
            raise ValueError(f'manifest 哈希无效：{path}')
    return value['files']


def archive_plan(root: Path, seal: bool = False, baseline_ref: str | None = None):
    """单语言移植上游 append-only archive verifier；校验成功后由调用者写入。"""
    archive = root / '.agents/notes/archived'
    manifest_path = root / ARCHIVE_MANIFEST
    errors, artifacts, existing = [], {}, {}
    if any(path.is_symlink() for path in (root / '.agents', root / '.agents/notes', archive)):
        return ['归档目录及其父目录不能是符号链接'], None
    if archive.exists():
        if not archive.is_dir():
            return ['归档路径必须为目录'], None
        for entry in sorted(archive.iterdir()):
            if entry.is_symlink():
                errors.append(f'归档不允许符号链接：{entry.relative_to(root)}')
            elif entry.is_file():
                if entry.name not in {'AGENTS.md', 'manifest.json'}:
                    errors.append(f'归档根目录文件无效：{entry.name}')
            elif not entry.is_dir() or entry.name not in NOTE_CLASSES:
                errors.append(f'归档类别无效：{entry.name}')
            else:
                for child in sorted(entry.iterdir()):
                    relative = child.relative_to(root)
                    if child.is_symlink() or not child.is_file():
                        errors.append(f'归档仅允许普通记录文件：{relative}')
                        continue
                    path_errors = check_note_path(relative)
                    if path_errors:
                        errors.extend(path_errors)
                        continue
                    try:
                        data = child.read_bytes()
                        lines = data.decode('utf-8').splitlines()
                    except (OSError, UnicodeError) as exc:
                        errors.append(f'无法读取归档 {relative}：{exc}')
                        continue
                    status = next((i for i, line in enumerate(lines) if line.startswith('Status:')), -1)
                    archived = re.fullmatch(r'Archived: (\d{4}-\d{2}-\d{2})', lines[status + 1]) if status >= 0 and status + 1 < len(lines) else None
                    valid = status >= 0 and lines[status] == 'Status: implemented' and archived is not None
                    if valid:
                        try:
                            date.fromisoformat(archived[1])
                            valid = archived[1] >= child.name[:10]
                        except ValueError:
                            valid = False
                    if not valid:
                        errors.append(f'归档元数据无效：{relative}（implemented 后须为有效且不早于首次日期的 Archived 日期）')
                    artifacts[child.relative_to(archive).as_posix()] = 'sha256:' + hashlib.sha256(data).hexdigest()
        if not (archive / 'AGENTS.md').is_file():
            errors.append('归档缺少 archived/AGENTS.md')
        if manifest_path.exists() and not manifest_path.is_symlink():
            try:
                existing = parse_manifest(manifest_path.read_text(encoding='utf-8'))
            except (OSError, UnicodeError, ValueError) as exc:
                errors.append(f'归档 manifest 无效：{exc}')
        elif not seal:
            errors.append('归档缺少 manifest.json；使用 --seal-archives 封存新文件')
    # 与可信变更前 Git 基准比较，防止同时篡改正文和 manifest。
    explicit = baseline_ref is not None or 'HARNESS_ARCHIVE_BASE_REF' in os.environ
    ref = baseline_ref if baseline_ref is not None else os.environ.get('HARNESS_ARCHIVE_BASE_REF', 'HEAD')
    def git(*args):
        result = subprocess.run(['git', *args], cwd=root, capture_output=True, text=True, check=False)
        if result.returncode:
            raise ValueError(result.stderr.strip() or 'Git 基准读取失败')
        return result.stdout
    try:
        if explicit and ref == '0' * 40:
            baseline = {}  # GitHub 首次 push 没有变更前提交。
        else:
            git('rev-parse', '--verify', f'{ref}^{{commit}}')
            baseline = parse_manifest(git('show', f'{ref}:{ARCHIVE_MANIFEST}')) if git('ls-tree', '--name-only', ref, '--', ARCHIVE_MANIFEST).strip() else {}
        for path, digest in baseline.items():
            if existing.get(path) != digest:
                errors.append(f'归档基准封存被改变或删除：{path}')
    except (OSError, ValueError) as exc:
        if explicit or artifacts or existing:
            errors.append(f'无法读取归档基准 {ref!r}：{exc}')
    for path, digest in existing.items():
        if path not in artifacts:
            errors.append(f'已封存归档文件缺失：{path}')
        elif artifacts[path] != digest:
            errors.append(f'已封存归档内容改变：{path}')
    added = {path: digest for path, digest in artifacts.items() if path not in existing}
    if not seal:
        errors.extend(f'归档尚未封存：{path}' for path in added)
    rendered = json.dumps({'version': 1, 'files': dict(sorted((existing | added).items()))}, ensure_ascii=False, indent=2) + '\n'
    return errors, rendered if archive.exists() else None


def check(root: Path, *, seal_archives: bool = False, baseline_ref: str | None = None) -> list[str]:
    """返回错误列表；不读取仓库之外的符号链接目标。"""
    root = root.resolve()
    errors = []
    for legacy in ('docs/rfc', 'docs/rfcs'):
        if (root / legacy).exists():
            errors.append(f'旧 Notes 位置禁止使用：{legacy}')
    notes_root = root / '.agents/notes'
    if notes_root.is_dir() and not notes_root.is_symlink():
        for lifecycle in notes_root.iterdir():
            if lifecycle.is_dir() and not lifecycle.is_symlink():
                if lifecycle.name not in NOTE_LIFECYCLES:
                    errors.append(f'Agent Notes 未知状态目录：{lifecycle.name}')
                else:
                    for kind in lifecycle.iterdir():
                        if kind.is_dir() and kind.name not in NOTE_CLASSES:
                            errors.append(f'Agent Notes 未知类别目录：{kind.relative_to(root)}')
    for name in REQUIRED_DOCUMENTS:
        path = root / name
        if not path.is_file():
            errors.append(f'缺少必需入口：{name}')
    # 不递归符号链接目录，也不扫描依赖目录；先显式拒绝不支持的目录别名。
    markdown_paths = []
    for current, directories, files in os.walk(root, followlinks=False):
        current = Path(current)
        for name in list(directories):
            path = current / name
            if name in IGNORED or path.relative_to(root).as_posix() in PROJECT_GENERATED_ROOTS:
                directories.remove(name)
            elif path.is_symlink():
                errors.append(f'不支持文档扫描范围内的目录符号链接：{path.relative_to(root)}')
                directories.remove(name)
            elif name.endswith('.md'):
                markdown_paths.append(path)
        markdown_paths.extend(current / name for name in files if name.endswith('.md'))
    for path in sorted(markdown_paths):
        relative = path.relative_to(root)
        if any(part in IGNORED for part in relative.parts):
            continue
        try:
            resolved = path.resolve()
        except (OSError, RuntimeError) as exc:
            errors.append(f'无法解析文档路径 {relative}：{exc}')
            continue
        if not resolved.is_relative_to(root):
            errors.append(f'文档符号链接越过仓库边界：{relative}')
            continue
        if not path.is_file():
            errors.append(f'文档路径不是可达的普通文件：{relative}')
            continue
        errors.extend(check_note_path(relative))
        # 冻结历史可保留过时出链；活跃文档指向归档的入链仍在通常检查内。
        if relative.parts[:3] == ('.agents', 'notes', 'archived') and len(relative.parts) >= 5:
            continue
        try:
            content = path.read_text(encoding='utf-8')
        except (OSError, UnicodeError) as exc:
            errors.append(f'无法读取 {relative}：{exc}')
            continue
        errors.extend(check_note_format(relative, content))
        if path.name == 'SKILL.md' and relative.parts[:2] == ('.agents', 'skills'):
            header = re.match(r'\A---\n(.*?)\n---(?:\n|$)', content, re.S)
            fields = {}
            if header:
                for line in header.group(1).splitlines():
                    key, sep, value = line.partition(':')
                    if sep:
                        key = key.strip()
                        if key in fields:
                            errors.append(f'Skill 元数据字段重复：{relative}：{key}')
                        if key in {'disable-model-invocation', 'user-invocable'} and value.strip() not in {'true', 'false'}:
                            errors.append(f'Skill 调用元数据必须为 YAML 布尔值 true/false：{relative}：{key}')
                        fields[key] = value.strip().strip('\"\'').strip()
            name = fields.get('name', '')
            if name != path.parent.name or not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', name):
                errors.append(f'Skill 名称缺失、无效或与目录不一致：{relative}')
            if not fields.get('description'):
                errors.append(f'Skill 缺少 description：{relative}')
        # 仅检查围栏外的内联文件链接。参考式链接与锚点不在本检查器覆盖范围内。
        in_fence = False
        fence_char = ''
        fence_length = 0
        for number, line in enumerate(content.splitlines(), 1):
            marker = re.match(r'^ {0,3}(`{3,}|~{3,})(.*)$', line)
            if marker:
                char = marker.group(1)[0]
                if not in_fence:
                    in_fence, fence_char = True, char
                    fence_length = len(marker.group(1))
                elif char == fence_char and len(marker.group(1)) >= fence_length and not marker.group(2).strip():
                    in_fence = False
                continue
            if in_fence:
                continue
            for target in inline_targets(line):
                target = target.strip('<>')
                try:
                    url = urlsplit(target)
                except ValueError:
                    errors.append(f'无效链接：{relative}:{number} → {target}')
                    continue
                if url.scheme or url.netloc or not url.path:
                    continue
                try:
                    destination = (path.parent / unquote(url.path)).resolve()
                except (OSError, RuntimeError) as exc:
                    errors.append(f'无法解析链接：{relative}:{number} → {target}：{exc}')
                    continue
                if not destination.is_relative_to(root):
                    errors.append(f'链接越过仓库边界：{relative}:{number} → {target}')
                elif not destination.exists():
                    errors.append(f'失效文件链接：{relative}:{number} → {target}')
    archive_errors, rendered = archive_plan(root, seal_archives, baseline_ref)
    errors.extend(archive_errors)
    if seal_archives and not errors and rendered is not None:
        (root / ARCHIVE_MANIFEST).write_text(rendered, encoding='utf-8')
    return errors

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1], help='待检查的仓库根目录')
    parser.add_argument('--seal-archives', action='store_true', help='验证旧封存后，仅追加新归档文件哈希')
    args = parser.parse_args()
    if not args.root.is_dir():
        print(f'检查失败：目录不存在：{args.root}')
        return 1
    errors = check(args.root, seal_archives=args.seal_archives)
    if errors:
        print('\n'.join(errors))
        print(f'检查失败：共 {len(errors)} 项问题。')
        return 1
    print('检查通过：固定文档骨架、Agent Notes 格式/封存、Skill 元数据和活跃文件链接正常。')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
