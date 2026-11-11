"""Remove retired UI objects from shipped NIBArchive tables in the build copy."""
import sys, struct, json
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from decode_nibs import decode

def encode(row):
    def vint(n):
        b=bytearray()
        while n>127: b.append(n&127); n >>= 7
        b.append(n|128); return bytes(b)
    objects=row['objects']; classes=row['classes']; keys=list(dict.fromkeys(v['key'] for o in objects for v in o['values']))
    vals=[]; ob=bytearray()
    for o in objects:
        ob += vint(next(i for i,c in enumerate(classes) if c['name']==o['class']))+vint(len(vals))+vint(len(o['values']))
        vals+=o['values']
    kb=b''.join(vint(len(k.encode()))+k.encode() for k in keys); vb=bytearray()
    for v in vals:
        t=v['type']; x=v['value']; vb+=vint(keys.index(v['key']))+bytes([t])
        if t in (0,1,2,3,6,7,10): vb+=struct.pack({0:'<B',1:'<H',2:'<I',3:'<Q',6:'<f',7:'<d',10:'<I'}[t], x['object'] if t==10 else x)
        elif t==8:
            b=bytes.fromhex(x['bytes_hex']);vb+=vint(len(b))+b
    cb=b''
    for c in classes:
        b=c['name'].encode()+b'\0';cb+=vint(len(b))+vint(len(c['extra']))+b''.join(struct.pack('<I',n) for n in c['extra'])+b
    return b'NIBArchive'+struct.pack('<10I',1,10,len(objects),50,len(keys),50+len(ob),len(vals),50+len(ob)+len(kb),len(classes),50+len(ob)+len(kb)+len(vb))+ob+kb+vb+cb

def prune(path):
    row=decode(path);o=row['objects']
    def field(i,k): return next((v['value'] for v in o[i]['values'] if v['key']==k),None)
    def ref(i,k):
        v=field(i,k);return v.get('object') if isinstance(v,dict) else None
    def text(i):
        if i is None:return None
        v=field(i,'NS.bytes');return v.get('utf8') if isinstance(v,dict) else None
    def members(i): return [v['value']['object'] for v in o[i]['values'] if v['type']==10]
    dead=set()
    def view(i):
        if i is None or i in dead:return
        dead.add(i)
        for key in ['NSSubviews','NSItems']:
            a=ref(i,key)
            if a is not None:
                for child in members(a):view(child)
        for key in ['NSView','NSCell','NSMenu','NSContentView','NSDocumentView']:
            child=ref(i,key)
            if child is not None:view(child)
    tabs=[i for i,x in enumerate(o) if x['class']=='NSTabView' and len(members(ref(i,'NSTabViewItems')))==12]
    if 'Preferences.nib' in str(path):
        assert len(tabs)==1
        items=members(ref(tabs[0],'NSTabViewItems'))
        for index in [6,7,9,10,11]:view(items[index])
    for i,x in enumerate(o):
        if x['class']=='NSCustomResource' and text(ref(i,'NSResourceName')) in {'OCR','OCRDark_off','OCR_off','OCR_on','Resume purchase','Translation','buy_black','iBar_logo','needBuyWatermark'}:dead.add(i)
    for i,x in enumerate(o):
        if x['class']=='NSNibControlConnector' and text(ref(i,'NSLabel')) in ['buyButtonClick:','rateOnAppStore:']:
            view(ref(i,'NSSource'))
    for i,x in enumerate(o):
        if 'Connector' in x['class'] and any(ref(i,k) in dead for k in ['NSSource','NSDestination']):dead.add(i)
    # NSIBObjectData stores paired arrays; remove matching entries together.
    for a,b in [('NSObjectsKeys','NSObjectsValues'),('NSOidsKeys','NSOidsValues'),('NSAccessibilityOidsKeys','NSAccessibilityOidsValues')]:
        ai,bi=ref(1,a),ref(1,b)
        if ai is None or bi is None:continue
        av,bv=o[ai]['values'],o[bi]['values'];assert len(av)==len(bv)
        pairs=[(x,y) for x,y in zip(av,bv) if not any(v['type']==10 and v['value']['object'] in dead for v in (x,y))]
        o[ai]['values']=[x for x,y in pairs];o[bi]['values']=[y for x,y in pairs]
    for x in o:
        x['values']=[v for v in x['values'] if not (v['type']==10 and v['value']['object'] in dead)]
    reachable=set()
    def visit(i):
        if i in reachable:return
        reachable.add(i)
        for v in o[i]['values']:
            if v['type']==10:visit(v['value']['object'])
    visit(0); ids=sorted(reachable); mapping={old:new for new,old in enumerate(ids)}
    row['objects']=[o[i] for i in ids]
    for x in row['objects']:
        for v in x['values']:
            if v['type']==10:v['value']={'object':mapping[v['value']['object']]}
    path.write_bytes(encode(row));decode(path)
    return {'path':str(path),'removedObjects':len(o)-len(ids)}

if __name__=='__main__':
    resources=Path(sys.argv[1]);report=[prune(p) for p in resources.rglob('*.nib') if p.is_file() and ('Preferences.nib' in str(p) or p.name=='AnnotatedImage.nib')]
    print(json.dumps(report))
    import subprocess, collections, re
    asset=resources/'Assets.car'
    before=json.loads(subprocess.check_output(['xcrun','assetutil','-I',str(asset)]))
    names={'OCR','OCRDark_off','OCR_off','OCR_on','Resume purchase','Translation','buy_black','iBar_logo','needBuyWatermark'}
    removed={r['Name']:r['NameIdentifier'] for r in before if r.get('Name') in names}
    out=resources.parents[2]
    (out/'removed-assets.json').write_text(json.dumps(removed))
    subprocess.run([str(out/'PruneAssets'),str(asset),str(out/'removed-assets.json')],check=True)
    subprocess.run(['xcrun','assetutil','-U',str(asset)],check=True)
    after=json.loads(subprocess.check_output(['xcrun','assetutil','-I',str(asset)]))
    def signatures(rows): return collections.Counter((r.get('Name'),r.get('SHA1Digest')) for r in rows[1:])
    assert signatures([before[0]]+[r for r in before[1:] if r.get('Name') not in names])==signatures(after), 'Unexpected asset changes'
    subprocess.run(['xcrun','assetutil','-Z',str(asset)],check=True)
    removed_strings={}
    for path in resources.rglob('*.strings'):
        if path.name not in ['Localizable.strings','Preferences.strings']:continue
        raw=subprocess.check_output(['plutil','-convert','json','-o','-',str(path)])
        data=json.loads(raw)
        keys=[k for k,v in data.items() if re.search(r'purchase|translate|translation|购买|翻译|iBar|iCopy|needBuy|buy_black',k+' '+str(v),re.I)]
        if keys:
            removed_strings[str(path.relative_to(resources))]=keys
            for k in keys:del data[k]
            import plistlib
            path.write_bytes(plistlib.dumps(data,fmt=plistlib.FMT_BINARY))
    (out/'resource-removal.json').write_text(json.dumps({'nibs':report,'assetNames':sorted(removed),'survivingAssetDigestsUnchanged':True,'localizedKeys':removed_strings},ensure_ascii=False,indent=2)+'\n')
