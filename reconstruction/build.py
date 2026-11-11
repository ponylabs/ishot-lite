#!/usr/bin/env python3
"""Build only restored source. Never link the shipped iShot executable."""
import hashlib
import json
from pathlib import Path
import platform
import plistlib
import shutil
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
OUT = HERE / 'build'
commands = []
WEBP = HERE / 'Dependencies/webp'
MINIMUM_MACOS = '12.3'
flags = ['xcrun', 'clang', '-mmacosx-version-min=' + MINIMUM_MACOS, '-fobjc-arc', '-fno-common', '-fblocks', '-fmodules', '-Wall', '-Wextra',
         '-Wno-unused-parameter', '-Wno-deprecated-declarations', '-I', str(HERE / 'Dependencies')]


def run(command):
    command = [str(x) for x in command]
    commands.append(command)
    subprocess.run(command, check=True, cwd=ROOT)


def frameworks(*names):
    return [arg for name in names for arg in ('-framework', name)]


def build_framework(name):
    source = HERE / 'Sources' / name
    files = sorted(source.glob('*.m'))
    if not files:
        raise RuntimeError(f'No restored source: {name}')
    if name == 'ShortcutRecorder' and not (source / 'SRRecorderControl.m').exists():
        raise RuntimeError('ShortcutRecorder control is not yet restored; refusing to emit a partial framework')
    base = OUT / 'Frameworks' / f'{name}.framework'
    version = base / 'Versions/A'
    version.mkdir(parents=True, exist_ok=True)
    resources = HERE / 'Resources/ShortcutRecorder'
    (version / 'Resources').mkdir(exist_ok=True)
    if name == 'ShortcutRecorder':
        shutil.copytree(resources, version / 'Resources', dirs_exist_ok=True)
    else:
        shutil.copy2(HERE / 'Configuration/PTHotKey-Info.plist', version / 'Resources/Info.plist')
    headers = version / 'Headers'
    headers.mkdir(exist_ok=True)
    for header in source.glob('*.h'):
        shutil.copy2(header, headers / header.name)
    run(flags + ['-dynamiclib', *files, *frameworks('Cocoa', 'Carbon'),
                 '-install_name', f'@rpath/{name}.framework/Versions/A/{name}', '-o', version / name])
    for link, target in [(base / 'Versions/Current', 'A'), (base / name, f'Versions/Current/{name}'),
                         (base / 'Resources', 'Versions/Current/Resources'), (base / 'Headers', 'Versions/Current/Headers')]:
        if not link.is_symlink():
            link.symlink_to(target)
    run(['codesign', '--force', '--sign', '-', base])


# Fail before compiling or altering existing outputs if retained inputs drift.
run(['python3', '-B', HERE / 'audit.py', '--inputs-only'])
OUT.mkdir(exist_ok=True)

build_framework('PTHotKey')
build_framework('ShortcutRecorder')

run(flags + [HERE / 'Tools/PruneAssets.m', *frameworks('Foundation'), '-o', OUT / 'PruneAssets'])

helper = OUT / 'iShotHelper.app/Contents'
(helper / 'MacOS').mkdir(parents=True, exist_ok=True)
shutil.copy2(HERE / 'Configuration/Helper-Info.plist', helper / 'Info.plist')
shutil.copytree(HERE / 'Resources/Helper',
                helper / 'Resources', dirs_exist_ok=True)
helper_info = plistlib.loads((helper / 'Info.plist').read_bytes())
helper_info['LSMinimumSystemVersion'] = MINIMUM_MACOS
(helper / 'Info.plist').write_bytes(plistlib.dumps(helper_info))
run(flags + [HERE / 'Sources/iShotHelper/main.m', *frameworks('Cocoa', 'AVFoundation', 'CoreServices'),
             '-o', helper / 'MacOS/iShotHelper'])
run(['python3', HERE / 'package_icon.py', helper])
run(['codesign', '--force', '--sign', '-', helper.parent])

objects = []
for directory in ('Startup', 'Camera', 'MainApplication', 'Imaging', 'Library', 'Common', 'Transcode', 'Dependencies', 'Preferences', 'Global', 'Shell', 'Pin', 'Editor', 'Capture'):
    for source in sorted(p for p in (HERE / 'Sources' / directory).iterdir() if p.suffix in ('.m', '.mm')):
        obj = OUT / f'{directory}-{source.stem}.o'
        compiler_flags = [*flags]
        if source.suffix == '.mm':
            compiler_flags[1] = 'clang++'
        run(compiler_flags + ['-c', source, '-o', obj])
        objects.append(obj)
run(['xcrun', 'libtool', '-static', '-o', OUT / 'libRecoveredMainComponents.a', *objects])

# Assemble the complete application only from recovered main code and shipped resources.
app = OUT / 'iShot Lite.app/Contents'
(app / 'MacOS').mkdir(parents=True, exist_ok=True)
info = plistlib.loads((HERE / 'Configuration/App-Info.plist').read_bytes())
info['LSMinimumSystemVersion'] = MINIMUM_MACOS
info['CFBundleName'] = 'iShot Lite'
info['CFBundleDisplayName'] = 'iShot Lite'
(app / 'Info.plist').write_bytes(plistlib.dumps(info))
if (app / 'Resources').exists():
    shutil.rmtree(app / 'Resources')
shutil.copytree(HERE / 'Resources/App', app / 'Resources',
                ignore=shutil.ignore_patterns('BuyFromAppStore.*', 'OCRAndTranslate.*', 'webp'))
shutil.copytree(HERE / 'Dependencies/ffmpeg/ARM', app / 'Resources/ARM', symlinks=True)
run(['python3', HERE / 'prune_resources.py', app / 'Resources'])
run(['python3', HERE / 'package_icon.py', app])
run(['python3', ROOT / 'scripts/audit_nib_dependencies.py', app / 'Resources', OUT / 'lite-nib-dependencies.json'])
if (app / 'Frameworks').exists():
    shutil.rmtree(app / 'Frameworks')
shutil.copytree(OUT / 'Frameworks', app / 'Frameworks', symlinks=True)
shutil.copytree(helper.parent, app / 'Library/LoginItems/iShotHelper.app', dirs_exist_ok=True, symlinks=True)
link_flags = [*flags]
link_flags[1] = 'clang++'
webp = WEBP / 'libs'
run(link_flags + [HERE / 'main.m', '-Wl,-all_load', OUT / 'libRecoveredMainComponents.a',
    webp / 'libwebp.a', webp / 'libsharpyuv.a', '-F', OUT / 'Frameworks',
    *frameworks('PTHotKey', 'ShortcutRecorder', 'Cocoa', 'Carbon', 'AVFoundation', 'CoreMedia',
                'AudioToolbox', 'CoreAudio', 'CoreImage', 'QuartzCore', 'ScreenCaptureKit', 'Vision',
                'WebKit', 'IOKit', 'CoreServices', 'ServiceManagement', 'Security'),
    '-Wl,-rpath,@executable_path/../Frameworks', '-o', app / 'MacOS/iShot'])
run(['codesign', '--force', '--sign', '-', app.parent])
products = [app / 'Resources/AppIcon.icns', app / 'Resources/icon_512x512.png', app / 'Resources/Assets.car', app / 'MacOS/iShot', OUT / 'iShotHelper.app/Contents/MacOS/iShotHelper', OUT / 'libRecoveredMainComponents.a']
products += [OUT / f'Frameworks/{n}.framework/Versions/A/{n}' for n in ('PTHotKey', 'ShortcutRecorder')]
manifest = {
    'host_architecture': platform.machine(),
    'minimum_macos': MINIMUM_MACOS,
    'main_application_compiled': True,
    'validation_results': ['test-results.json', 'nib-validation.json', 'workflow-result.json', 'runtime-validation.json'],
    'validation_note': 'Build success does not establish behavioral equivalence; consult scoped validation results.',
    'commands': commands,
    'products': [{'path': str(p.relative_to(ROOT)), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in products],
    'sources': [{'path': str(p.relative_to(ROOT)), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
                for p in sorted((HERE / 'Sources').rglob('*')) if p.suffix in ('.m', '.mm', '.h', '.inc') and 'tests' not in p.parts],
}
(OUT / 'build-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
run(['python3', HERE / 'audit.py'])
run(['python3', HERE / 'check_compatibility.py', app.parent])
print('Built recovered main application, helper and frameworks. Runtime validation remains a separate check.')
