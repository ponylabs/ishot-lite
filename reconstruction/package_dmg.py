#!/usr/bin/env python3
"""Package the validated Lite build without launching or installing it."""
from pathlib import Path
import hashlib,json,plistlib,subprocess,sys
HERE=Path(__file__).resolve().parent
APP=HERE/'build/iShot Lite.app'
OUT=HERE/'dist';OUT.mkdir(exist_ok=True)
info=plistlib.loads((APP/'Contents/Info.plist').read_bytes())
version=info['CFBundleShortVersionString']
dmg=OUT/f'iShot-Lite-{version}-arm64.dmg'
def run(*args):return subprocess.check_output([str(x) for x in args])
run('codesign','--verify','--deep','--strict',APP)
run('python3', HERE/'check_compatibility.py', APP)
assert run('lipo','-archs',APP/'Contents/MacOS/iShot').decode().strip()=='arm64'
sys.path.insert(0, str(HERE / 'build/packaging-python'))
import dmgbuild
background_dir = HERE / 'build/packaging-assets'
background_dir.mkdir(parents=True, exist_ok=True)
background = background_dir / 'InstallerBackground.png'
background_retina = background_dir / 'InstallerBackground@2x.png'
run('xcrun', 'swift', HERE / 'Tools/InstallerBackground.swift', background_retina)
run('sips', '-z', '400', '640', background_retina, '--out', background)
dmgbuild.build_dmg(str(dmg), 'iShot Lite', settings={
    'format': 'UDZO',
    'files': [str(APP)],
    'symlinks': {'Applications': '/Applications'},
    'background': str(background),
    'window_rect': ((180, 140), (640, 480)),
    'icon_locations': {'iShot Lite.app': (170, 195), 'Applications': (470, 195)},
    'icon_size': 96, 'text_size': 14,
    'show_toolbar': False, 'show_sidebar': False,
    'show_status_bar': False, 'show_pathbar': False,
    'default_view': 'icon-view', 'arrange_by': None,
})
run('hdiutil','verify',dmg)
checksum=hashlib.sha256(dmg.read_bytes()).hexdigest()
(OUT/(dmg.name+'.sha256')).write_text(checksum+'  '+dmg.name+'\n')
print(json.dumps({'dmg':str(dmg),'bytes':dmg.stat().st_size,'sha256':checksum},indent=2))
