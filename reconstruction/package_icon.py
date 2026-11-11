"""Package the approved artwork; remove old catalog icons so bundle lookup is unambiguous."""
import collections
import hashlib
import json
from pathlib import Path
import plistlib
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent
OUT = HERE / 'build'
SOURCE = HERE / 'Assets/LiteIcon.png'

def run(*args):
    return subprocess.check_output([str(x) for x in args])

def apply_icon(contents):
    resources = contents / 'Resources'
    iconset = OUT / 'LiteIcon.iconset'
    iconset.mkdir(exist_ok=True)
    for size in (16, 32, 128, 256, 512):
        for scale in (1, 2):
            name = f'icon_{size}x{size}' + ('@2x' if scale == 2 else '') + '.png'
            run('sips', '-z', size * scale, size * scale, SOURCE, '--out', iconset / name)
    run('iconutil', '-c', 'icns', iconset, '-o', resources / 'AppIcon.icns')
    # Preserve the archived preferences image name, with the approved replacement.
    shutil.copy2(SOURCE, resources / 'icon_512x512.png')
    catalog = resources / 'Assets.car'
    before = json.loads(run('xcrun', 'assetutil', '-I', catalog))
    names = {'AppIcon', 'icon_512x512'}
    removed = {r['Name']: r['NameIdentifier'] for r in before if r.get('Name') in names}
    selection = OUT / 'replaced-icon-assets.json'
    selection.write_text(json.dumps(removed))
    run(OUT / 'PruneAssets', catalog, selection)
    run('xcrun', 'assetutil', '-U', catalog)
    after = json.loads(run('xcrun', 'assetutil', '-I', catalog))
    def signatures(rows):
        return collections.Counter((r.get('Name'), r.get('SHA1Digest')) for r in rows)
    assert signatures([r for r in before[1:] if r.get('Name') not in names]) == signatures(after[1:])
    run('xcrun', 'assetutil', '-Z', catalog)
    info_path = contents / 'Info.plist'
    info = plistlib.loads(info_path.read_bytes())
    info['CFBundleIconFile'] = 'AppIcon.icns'
    info.pop('CFBundleIconName', None)
    info_path.write_bytes(plistlib.dumps(info))
    return {'bundle': str(contents.parent), 'artwork_sha256': hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            'icns_sha256': hashlib.sha256((resources / 'AppIcon.icns').read_bytes()).hexdigest(),
            'replaced_catalog_names': sorted(removed), 'other_renditions_unchanged': True}

if __name__ == '__main__':
    result = apply_icon(Path(sys.argv[1]))
    print(json.dumps(result))
    (OUT / (Path(sys.argv[1]).parent.stem + '-icon-validation.json')).write_text(json.dumps(result, indent=2) + '\n')
