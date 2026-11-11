#!/usr/bin/env python3
"""Resolve archived class names and connector endpoints from decoded nib object IDs."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
import sys
from decode_nibs import decode
if len(sys.argv) != 3:
    raise SystemExit('usage: audit_nib_dependencies.py resources-root output.json')
resources = Path(sys.argv[1]).resolve()
paths = [p for p in sorted(resources.rglob('*.nib')) if p.is_file()]
if not paths:
    raise SystemExit('No nib resources found')
rows = []
for path in paths:
    row = decode(path)
    if not row['decoded']:
        raise SystemExit(f'Unsupported nib format: {path}')
    row['path'] = str(path.relative_to(resources))
    rows.append(row)
from current_contract import header_contract
project_classes, _, _ = header_contract(ROOT / 'reconstruction/Sources')
results=[]
for row in rows:
    if not row['decoded']:continue
    objects=row['objects']
    def field(i,k):
        return next((v['value'] for v in objects[i]['values'] if v['key']==k),None)
    def text(v):
        if isinstance(v,dict) and 'object' in v:
            return text(field(v['object'],'NS.bytes'))
        if isinstance(v,dict):return v.get('utf8')
        return None
    def cls(i):
        ref=field(i,'IBClassReference')
        name=text(field(i,'NSClassName'))
        if ref is not None:name=text(field(ref['object'],'IBClassName')) or name
        return name or objects[i]['class']
    names=set()
    connectors=[]
    for i,o in enumerate(objects):
        names.add(cls(i))
        if o['class']=='IBClassReference':names.add(text(field(i,'IBClassName')))
        if o['class'] in ('NSNibOutletConnector','NSNibControlConnector'):
            src=field(i,'NSSource');dst=field(i,'NSDestination')
            connectors.append({'object':i,'kind':o['class'],'label':text(field(i,'NSLabel')),
              'source':{'object':src['object'],'class':cls(src['object'])} if src else None,
              'destination':{'object':dst['object'],'class':cls(dst['object'])} if dst else None})
    results.append({'path':row['path'],'sha256':row['sha256'],'custom_classes':sorted(n for n in names if n and (n in project_classes or not n.startswith(('NS', 'IB')))),'connections':connectors})
Path(sys.argv[2]).write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
for row in results:print(Path(row['path']).parent.name+'/'+Path(row['path']).name,', '.join(row['custom_classes']),len(row['connections']))
