"""Fail packaging when Mach-O deployment targets exceed the advertised minimum."""
from pathlib import Path
import json,plistlib,re,subprocess,sys
app=Path(sys.argv[1]).resolve()
info=plistlib.loads((app/'Contents/Info.plist').read_bytes())
minimum=info['LSMinimumSystemVersion']
def version(s):return tuple((list(map(int,s.split('.')))+[0,0])[:3])
rows=[]
for p in app.rglob('*'):
    if not p.is_file() or p.is_symlink() or p.suffix == '.a':continue
    with p.open('rb') as f:magic=f.read(4)
    if magic not in [bytes.fromhex(x) for x in ['cffaedfe','cefaedfe','cafebabe','bebafeca','cafebabf']]:continue
    result=subprocess.run(['xcrun','vtool','-show-build',str(p)],capture_output=True,text=True,check=True)
    targets=re.findall(r'^\s*minos\s+(\d+(?:\.\d+)+)',result.stdout,re.M)
    if not targets:
        targets=re.findall(r'cmd LC_VERSION_MIN_MACOSX\s+cmdsize \d+\s+version (\d+(?:\.\d+)+)',result.stdout)
    assert targets, f'Missing deployment target: {p}'
    assert all(version(t)<=version(minimum) for t in targets), (p,targets,minimum)
    rows.append({'file':str(p.relative_to(app)),'deployment_targets':targets})
report={'advertised_minimum_macos':minimum,'architecture':subprocess.check_output(['lipo','-archs',str(app/'Contents/MacOS/iShot')],text=True).strip(),'checked_macho_files':len(rows),'all_targets_within_minimum':True,'files':rows,'limitations':'Static deployment-target verification; not a runtime test on every supported macOS release.'}
(app.parent/'compatibility-validation.json').write_text(json.dumps(report,indent=2)+'\n')
print(f'PASS: {len(rows)} Mach-O files; deployment targets <= macOS {minimum}')
