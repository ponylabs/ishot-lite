#!/usr/bin/env python3
"""Static inventory of external-resource callsites; not a network-traffic audit."""
import json,re
from pathlib import Path
root=Path(__file__).resolve().parents[1]
rows=[]
pattern=re.compile(r'https?://[^\s"<>]+|macappstore://[^\s"<>]+|x-apple\.systempreferences:[^\s"<>]+')
for path in sorted((root/'reconstruction/Sources').rglob('*')):
    if path.suffix not in ('.m','.mm','.inc') or 'tests' in path.parts:continue
    for number,line in enumerate(path.read_text().splitlines(),1):
        urls=pattern.findall(line)
        operations=[name for name in ('openURL:','launchAppWithBundleIdentifier:','NSURLSession','loadRequest:','ContentsOfURL:','system(') if name in line]
        if urls or operations:rows.append({'file':str(path.relative_to(root)),'line':number,'urls':urls,'operations':operations})
# Inspect the already decoded shipped nibs without treating archived strings as active calls.
from decode_nibs import decode
archive=[decode(p) for p in (root/'reconstruction/build/iShot Lite.app/Contents/Resources').rglob('*.nib') if p.is_file()];archived=[]
def visit(value,path):
    if isinstance(value,dict):
        for k,v in value.items():visit(v,path+[str(k)])
    elif isinstance(value,list):
        for i,v in enumerate(value):visit(v,path+[str(i)])
    elif isinstance(value,str):
        for url in pattern.findall(value):archived.append({'json_path':'/'.join(path),'url':url})
visit(archive,[])
output={'scope':'Recovered production source and built Lite nib strings. External interaction boundaries are documented in docs/architecture.md. No live traffic capture or exhaustive third-party-library audit.','callsites':rows,'archived_nib_urls':archived}
(root/'reconstruction/build/external-content-audit.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
print(f'{len(rows)} source callsites; {len(archived)} archived nib URLs (not equivalent to active network requests)')
