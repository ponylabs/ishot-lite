#!/usr/bin/env python3
"""Check retained input bytes, current declared API and linked project classes."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / 'scripts'))
from current_contract import header_contract, emitted_methods, missing_methods


def check_retained_inputs():
    """Check the current retained bytes; historical source labels are never read."""
    manifest = HERE / 'retained-inputs.json'
    data = json.loads(manifest.read_text())
    rows = data.get('files')
    if not isinstance(rows, list) or not rows:
        raise ValueError('Retained input manifest must list files')
    roots = [HERE / name for name in ('Configuration', 'Resources', 'Dependencies')]
    expected = set()
    for row in rows:
        relative = Path(row['path'])
        if (relative.is_absolute() or '..' in relative.parts or len(relative.parts) < 3
                or relative.parts[0] != 'reconstruction'
                or relative.parts[1] not in ('Configuration', 'Resources', 'Dependencies')):
            raise ValueError(f'Invalid retained input path: {relative}')
        path = HERE.parent / relative
        if path in expected:
            raise ValueError(f'Duplicate retained input: {relative}')
        expected.add(path)
        if any((HERE.parent / Path(*relative.parts[:index])).is_symlink()
               for index in range(1, len(relative.parts) + 1)):
            raise ValueError(f'Retained input must not use symlinks: {relative}')
        if not path.is_file():
            raise ValueError(f'Missing retained input: {relative}')
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != row['sha256']:
            raise ValueError(f'Retained input SHA-256 mismatch: {relative}')
    present = {path for root in roots for path in root.rglob('*') if path.is_file() or path.is_symlink()}
    if present != expected:
        extra = sorted(str(path.relative_to(HERE.parent)) for path in present - expected)
        raise ValueError(f'Unlisted retained inputs: {extra}')
    print(f'Verified {len(expected)} retained inputs against retained-inputs.json')


def main():
    out = HERE / 'build'
    classes, expected, _ = header_contract(HERE / 'Sources')
    products = [out / 'libRecoveredMainComponents.a']
    products += [out / f'Frameworks/{n}.framework/Versions/A/{n}' for n in ('PTHotKey', 'ShortcutRecorder')]
    symbols = '\n'.join(subprocess.check_output(['nm', str(p)], text=True) for p in products)
    actual = emitted_methods(symbols)
    missing = missing_methods(expected, actual)
    defined, undefined = set(), set()
    for line in symbols.splitlines():
        match = re.search(r'\b([A-Za-z]) _OBJC_CLASS_\$_(\w+)$', line)
        if match:
            (undefined if match[1] == 'U' else defined).add(match[2])
    missing_classes = sorted(classes - defined)
    unresolved = sorted((undefined - defined) & classes)
    rows = [{'class': name, 'expected_count': len(selectors),
             'emitted_count': len(actual.get(name, set())), 'missing': missing.get(name, [])}
            for name, selectors in sorted(expected.items())]
    result = {'scope': 'Current source header API and linked project class definitions',
              'method_symbol_checks': rows, 'missing_project_classes': missing_classes,
              'unresolved_project_classes': unresolved,
              'limitations': ['Header declaration parsing covers repository syntax, not the full Objective-C language.',
                             'Symbol presence does not prove behavior; runtime nib connections are checked separately.',
                             'Helper belongs to a separate process and is excluded from the main API.']}
    (out / 'source-audit.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(f'Audited {len(rows)} class/category APIs; {len(missing)} missing-method groups; {len(missing_classes)} missing classes.')
    if missing or missing_classes or unresolved:
        raise SystemExit('Current source contract audit failed')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--inputs-only', action='store_true', help='Verify retained input bytes without reading or writing build outputs')
    args = parser.parse_args()
    check_retained_inputs()
    if not args.inputs_only:
        main()
