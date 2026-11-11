#!/usr/bin/env python3
"""Run bounded tests; never run the helper watchdog or the main application."""
import argparse
import json
import plistlib
from pathlib import Path
import subprocess
import shutil

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--original-recovery', type=Path, help='Optional external recovery archive for original-framework differential tests')
args = parser.parse_args()
original_recovery = args.original_recovery.resolve(strict=True) if args.original_recovery else None
OUT = HERE / 'build'
if OUT.is_symlink():
    raise RuntimeError('Build output must not be a directory alias')
OUT.mkdir(exist_ok=True)
flags = ['xcrun', 'clang', '-mmacosx-version-min=12.3', '-fobjc-arc', '-fblocks', '-fmodules', '-Wall', '-Wextra',
         '-Wno-unused-parameter', '-Wno-deprecated-declarations',
         '-I', str(HERE / 'Dependencies')]
results = []
def prepare_original_frameworks(archive, output):
    """Recreate disposable differential fixtures, never the external archive."""
    if output.is_symlink():
        raise RuntimeError('Build output must not be a directory alias')
    # Differential fixtures are opt-in, outside the normal project inputs.
    original_frameworks = output / 'OriginalFrameworks'
    for name in ('PTHotKey', 'ShortcutRecorder'):
        framework = original_frameworks / (name + '.framework')
        # Recreate only generated fixtures: copytree cannot merge existing symlinks.
        if original_frameworks.is_symlink() or framework.is_symlink():
            raise RuntimeError('OriginalFrameworks fixtures must not be directory aliases')
        if framework.exists():
            shutil.rmtree(framework)
        shutil.copytree(archive / 'resources/Contents/Frameworks' / (name + '.framework'), framework, symlinks=True, dirs_exist_ok=True)
        shutil.copy2(archive / 'binaries' / (name + '.arm64'), framework / 'Versions/A' / name)
        if not (framework / name).is_symlink(): (framework / name).symlink_to('Versions/Current/' + name)
    return original_frameworks


if original_recovery:
    original_frameworks = prepare_original_frameworks(original_recovery, OUT)



def test(name, sources, libraries, arguments=(), linker=(), bundle=False):
    executable = OUT / name
    if bundle:
        contents = OUT / f'{name}.app' / 'Contents'
        (contents / 'MacOS').mkdir(parents=True, exist_ok=True)
        executable = contents / 'MacOS' / name
        resources = contents / 'Resources'
        if resources.is_symlink():
            resources.unlink()
        if not resources.exists():
            resources.symlink_to(OUT / 'iShot Lite.app/Contents/Resources', target_is_directory=True)
        (contents / 'Info.plist').write_bytes(plistlib.dumps({
            'CFBundleExecutable': name, 'CFBundleIdentifier': 'local.ishot.reconstruction.nibvalidation',
            'CFBundlePackageType': 'APPL', 'CFBundleName': name, 'LSUIElement': True}))
    command = flags + [str(ROOT / p) for p in sources]
    command += [arg for lib in libraries for arg in ('-framework', lib)]
    command += list(linker) + ['-o', str(executable)]
    subprocess.run(command, check=True)
    completed = subprocess.run([str(executable), *map(str, arguments)], capture_output=True, text=True, timeout=60)
    row = {'test': name, 'compile_command': command, 'run_arguments': list(map(str, arguments)),
           'returncode': completed.returncode, 'stdout': completed.stdout, 'stderr': completed.stderr}
    results.append(row)
    (OUT / 'test-results.json').write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')
    print(f'{name}: {"PASS" if completed.returncode == 0 else "FAIL"}')
    if completed.returncode:
        raise RuntimeError(completed.stdout + completed.stderr)


test('ApplicationFunctionTests', ['reconstruction/Sources/MainApplication/ApplicationFunctions.m',
     'reconstruction/Sources/MainApplication/LaunchAtLoginController.m',
     'reconstruction/Tests/ApplicationFunctionTests.m'], ['Cocoa', 'AVFoundation', 'ServiceManagement'])
test('CommonTests', ['reconstruction/Tests/CommonTests.m',
     'reconstruction/Sources/Common/CurveFunctions.m',
     'reconstruction/Sources/Common/KeyCodeFunctions.m',
     'reconstruction/Sources/Common/Utility.m'], ['Cocoa'])
test('ImagingTests', ['reconstruction/Sources/Imaging/NSImage+Screenshot.m',
     'reconstruction/Sources/Imaging/NSScreen+PointConversion.m',
     'reconstruction/Tests/ImagingTests.m'], ['Cocoa', 'Quartz', 'Vision'])
test('StartupTests', ['reconstruction/Sources/Startup/AESEncryptUtil.m',
     'reconstruction/Sources/Startup/LCFreePlanManager.m', 'reconstruction/Tests/StartupTests.m'], ['AppKit'])
test('PTHotKeyTests', ['reconstruction/Sources/PTHotKey/PTHotKey.m',
     'reconstruction/Tests/PTHotKeyTests.m'], ['Cocoa', 'Carbon'])
if original_recovery:
    test('OriginalPTHotKeyTests', ['reconstruction/Tests/PTHotKeyTests.m', str(original_recovery / 'binaries/PTHotKey.arm64')],
         ['Cocoa', 'Carbon'], linker=[f'-Wl,-rpath,{original_frameworks}'])
test('CameraGeometryTests', ['reconstruction/Sources/Camera/CameraView.m',
     'reconstruction/Sources/Camera/NSValue+CGPoint.m',
     'reconstruction/Sources/Camera/tests/CameraGeometryTests.m'], ['Cocoa'])
camera_sources = [str(p.relative_to(ROOT)) for p in sorted((HERE / 'Sources/Camera').glob('*.m'))]
test('CameraControllerTests', camera_sources + ['reconstruction/Sources/Camera/tests/CameraControllerTests.m'],
     ['Cocoa', 'AVFoundation', 'QuartzCore'])
test('HelperJSONTests', ['reconstruction/Sources/iShotHelper/tests/json_decode.m'],
     ['Cocoa', 'AVFoundation', 'CoreServices'])
test('HelperAppKitTests', ['reconstruction/Sources/iShotHelper/tests/appkit_nib.m'],
     ['Cocoa', 'AVFoundation', 'CoreServices'],
     [OUT / 'iShotHelper.app/Contents/Resources'])
test('ShortcutRecorderTests', ['reconstruction/Tests/ShortcutRecorderTests.m'],
     ['Cocoa', 'Carbon', 'ShortcutRecorder'], ['-AppleLanguages', '(en)'],
     ['-F', str(OUT / 'Frameworks'), f'-Wl,-rpath,{OUT / "Frameworks"}'])
if original_recovery:
    test('OriginalShortcutRecorderTests', ['reconstruction/Tests/ShortcutRecorderTests.m',
         str(original_recovery / 'binaries/ShortcutRecorder.arm64')], ['Cocoa', 'Carbon'], ['-AppleLanguages', '(en)'],
         [f'-Wl,-rpath,{original_frameworks}'])
    assert results[-1]['stdout'] == results[-2]['stdout'], 'ShortcutRecorder differential output differs'
    print('ShortcutRecorder bounded differential comparison: PASS')
test('WebpConverterTests', ['reconstruction/Tests/WebpConverterTests.m',
     'reconstruction/Sources/Dependencies/WebpConverter.m',
     'reconstruction/Dependencies/webp/libs/libwebp.a',
     'reconstruction/Dependencies/webp/libs/libsharpyuv.a'], ['Cocoa'])
test('MoxtraColorTests', ['reconstruction/Sources/Common/NSColor+Moxtra.m',
     'reconstruction/Tests/MoxtraColorTests.m'], ['Cocoa'])
test('CounterTests', ['reconstruction/Sources/Capture/CircleCounterView.m',
     'reconstruction/Sources/Capture/CircleDownCounter.m',
     'reconstruction/Sources/Capture/KeyEventSettingPopoverViewController.m',
     'reconstruction/Sources/Capture/tests/CounterTests.m'], ['Cocoa', 'QuartzCore'])
test('MosaicTests', ['reconstruction/Sources/Imaging/MJMosaicUtil.m',
     'reconstruction/Sources/Imaging/tests/MosaicTests.m'], ['Cocoa', 'CoreImage', 'ImageIO'])
test('EditorBehaviorTests', ['reconstruction/Sources/Editor/AnnotatedImageView.m',
     'reconstruction/Sources/Common/TextFunctions.m',
     'reconstruction/Sources/Common/CurveFunctions.m',
     'reconstruction/Sources/Common/ModifierFunctions.m',
     'reconstruction/Sources/Camera/NSValue+CGPoint.m',
     'reconstruction/Sources/Editor/tests/EditorBehaviorTests.m'], ['Cocoa'])
test('AnnotatedDrawingTests', ['reconstruction/Sources/Editor/tests/AnnotatedDrawingTests.m',
     'reconstruction/Sources/Camera/NSValue+CGPoint.m'], ['Cocoa'])
test('MainAppValidation', ['reconstruction/Tests/MainAppValidation.m',
     'reconstruction/build/libRecoveredMainComponents.a',
     'reconstruction/Dependencies/webp/libs/libwebp.a',
     'reconstruction/Dependencies/webp/libs/libsharpyuv.a'],
     ['PTHotKey', 'ShortcutRecorder', 'Cocoa', 'Carbon', 'AVFoundation', 'CoreMedia',
      'AudioToolbox', 'CoreAudio', 'CoreImage', 'QuartzCore', 'ScreenCaptureKit', 'Vision',
      'WebKit', 'IOKit', 'CoreServices', 'ServiceManagement', 'Security', 'StoreKit'],
     [ROOT, OUT / 'iShot Lite.app/Contents/Resources'],
     ['-Wl,-all_load', '-lc++', '-F', str(OUT / 'Frameworks'), f'-Wl,-rpath,{OUT / "Frameworks"}'],
     bundle=True)

test('ColorNamerTests', ['reconstruction/Sources/Common/tests/ColorNamerTests.m'], ['Cocoa'])
test('ColorPickerTests', ['reconstruction/Sources/Capture/tests/ColorPickerTests.m',
     'reconstruction/Sources/Common/ColorNamer.m', 'reconstruction/Sources/Common/NSColor+Moxtra.m',
     'reconstruction/Sources/Common/TextWidthFunction.m'], ['Cocoa', 'QuartzCore'])
test('ClipGeometryTests', ['reconstruction/Sources/Capture/tests/ClipGeometryTests.m',
     'reconstruction/Sources/Camera/NSValue+CGPoint.m'], ['Cocoa', 'QuartzCore'])
test('RecordClipTests', ['reconstruction/Sources/Capture/tests/RecordClipTests.m',
     'reconstruction/Sources/Common/TextWidthFunction.m'], ['Cocoa', 'QuartzCore'])
test('AspectRatioTests', ['reconstruction/Sources/Capture/tests/AspectRatioTests.m',
     'reconstruction/Sources/Common/AspectRatioFunction.m'], ['Cocoa'])
test('ScrollImageTests', ['reconstruction/Sources/Imaging/tests/ScrollImageTests.m',
     'reconstruction/Sources/Imaging/NSScrollView+ToImage.m', 'reconstruction/Sources/Common/LayerImageFunction.m'], ['Cocoa', 'QuartzCore'])
test('CropBorderTests', ['reconstruction/Sources/Common/tests/CropBorderTests.m',
     'reconstruction/Sources/Common/CurveFunctions.m', 'reconstruction/Sources/Camera/NSValue+CGPoint.m'], ['Cocoa', 'QuartzCore'])


test('MainWorkflowValidation', ['reconstruction/Tests/MainWorkflowValidation.m',
     'reconstruction/build/libRecoveredMainComponents.a',
     'reconstruction/Dependencies/webp/libs/libwebp.a',
     'reconstruction/Dependencies/webp/libs/libsharpyuv.a'],
     ['PTHotKey', 'ShortcutRecorder', 'Cocoa', 'Carbon', 'AVFoundation', 'CoreMedia',
      'AudioToolbox', 'CoreAudio', 'CoreImage', 'QuartzCore', 'ScreenCaptureKit', 'Vision',
      'WebKit', 'IOKit', 'CoreServices', 'ServiceManagement', 'Security', 'StoreKit'],
     [OUT],
     ['-Wl,-all_load', '-lc++', '-F', str(OUT / 'Frameworks'), f'-Wl,-rpath,{OUT / "Frameworks"}'],
     bundle=True)

test('RecordBorderTests', ['reconstruction/Sources/Common/tests/RecordBorderTests.m',
     'reconstruction/Sources/Camera/NSValue+CGPoint.m'], ['Cocoa', 'QuartzCore', 'IOKit'])
test('AppKitCategoryTests', ['reconstruction/Sources/Common/tests/AppKitCategoryTests.m',
     'reconstruction/Sources/Common/AppKitCategories.m'], ['Cocoa'])

test('LiteAccessTests', ['reconstruction/Tests/LiteAccessTests.m'], ['Cocoa', 'IOKit'])

# Bounded module contracts; their fixtures do not start capture or request permissions.
test('CaptureTests', ['reconstruction/Sources/Capture/tests/CaptureTests.m',
     'reconstruction/Sources/Capture/MenuView.m', 'reconstruction/Sources/Capture/MXRecordScreenManager.m',
     'reconstruction/Sources/Capture/RecordAudioController.m', 'reconstruction/Sources/Capture/CaptureAudioFunctions.m'],
     ['Cocoa', 'AVFoundation', 'CoreMedia', 'CoreAudio', 'AudioToolbox'])
test('VideoControlsTests', ['reconstruction/Sources/Capture/tests/VideoControlsTests.m',
     'reconstruction/Sources/Capture/CaptureAudioFunctions.m'],
     ['Cocoa', 'AVFoundation', 'CoreMedia', 'CoreAudio', 'AudioToolbox'])
test('ClipEventTests', ['reconstruction/Sources/Capture/tests/ClipEventTests.m'], ['Cocoa'])
test('SGCaptureSessionTests', ['reconstruction/Sources/Capture/tests/SGCaptureSessionTests.m'],
     ['Cocoa', 'AVFoundation', 'CoreMedia', 'ScreenCaptureKit', 'AudioToolbox'])
test('ClipScrollTests', ['reconstruction/Sources/Capture/tests/ClipScrollTests.m',
     'reconstruction/Sources/Common/TextWidthFunction.m'], ['Cocoa', 'QuartzCore'])
test('PreferenceTests', ['reconstruction/Sources/Preferences/tests/PreferenceTests.m',
     'reconstruction/Sources/Preferences/PreferenceControls.m', 'reconstruction/Sources/Preferences/PreferenceHelpers.m',
     'reconstruction/Sources/Preferences/LeftMenuTableHandler.m', 'reconstruction/Sources/Preferences/FreeAppsViewController.m',
     'reconstruction/Sources/Common/LCBox.m', 'reconstruction/Sources/Common/AppKitCategories.m'],
     ['Cocoa', 'Carbon', 'QuartzCore'])
test('PinBehaviorTests', ['reconstruction/Sources/Pin/tests/PinBehaviorTests.m',
     'reconstruction/Sources/Pin/CustomView.m', 'reconstruction/Sources/Pin/CustomScrollView.m',
     'reconstruction/Sources/Pin/PinWindow.m', 'reconstruction/Sources/Pin/Zoom.m',
     'reconstruction/Sources/Common/ModifierFunctions.m', 'reconstruction/Sources/Imaging/NSImage+Screenshot.m',
     'reconstruction/Sources/Imaging/NSScreen+PointConversion.m',
     'reconstruction/Sources/Dependencies/SnipUtil.m', 'reconstruction/Sources/Dependencies/WebpConverter.m',
     'reconstruction/Dependencies/webp/libs/libwebp.a', 'reconstruction/Dependencies/webp/libs/libsharpyuv.a'],
     ['Cocoa', 'QuartzCore', 'CoreImage', 'Vision', 'CoreServices'])
test('DependencyTests', ['reconstruction/Sources/Dependencies/tests/DependencyTests.m'] +
     [str(p.relative_to(ROOT)) for p in sorted((HERE / 'Sources/Dependencies').glob('*.m'))] +
     ['reconstruction/Dependencies/webp/libs/libwebp.a', 'reconstruction/Dependencies/webp/libs/libsharpyuv.a'],
     ['Cocoa', 'QuartzCore', 'IOKit', 'Security'])

print('Tests establish only the bounded assertions recorded above, not full application equivalence.')
