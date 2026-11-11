#!/usr/bin/env python3
"""Decode shipped NIBArchive tables without instantiating archived classes."""
import hashlib
import json
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[1]

def decode(path):
    data = path.read_bytes()
    if not data.startswith(b'NIBArchive'):
        return {'path': str(path.relative_to(ROOT)), 'decoded': False, 'magic': data[:16].hex()}
    version, coder, no, oo, nk, ok, nv, ov, nc, oc = struct.unpack_from('<10I', data, 10)
    assert version == 1 and coder == 10
    pos = 50
    def varint():
        nonlocal pos
        value = shift = 0
        while True:
            b = data[pos]; pos += 1
            value |= (b & 127) << shift
            if b & 128: return value
            shift += 7
            assert shift < 64
    def take(n):
        nonlocal pos
        v = data[pos:pos+n]; assert len(v) == n; pos += n
        return v
    assert pos == oo
    objects = [(varint(), varint(), varint()) for _ in range(no)]
    assert pos == ok
    keys = [take(varint()).decode('utf8') for _ in range(nk)]
    assert pos == ov
    values = []
    for _ in range(nv):
        key = varint(); typ = take(1)[0]
        assert key < nk
        if typ in (0, 1, 2, 3, 6, 7, 10):
            fmt = {0:'<B',1:'<H',2:'<I',3:'<Q',6:'<f',7:'<d',10:'<I'}[typ]
            value = struct.unpack(fmt, take(struct.calcsize(fmt)))[0]
            if typ == 10:
                assert value < no
                value = {'object': value}
        elif typ in (4,5): value = typ == 5
        elif typ == 9: value = None
        elif typ == 8:
            raw = take(varint())
            value = {'bytes_hex':raw.hex()}
            try: value['utf8'] = raw.decode('utf8')
            except UnicodeDecodeError: pass
        else: raise ValueError((path,pos,typ))
        values.append({'key':keys[key], 'type':typ,'value':value})
    assert pos == oc
    classes = []
    for _ in range(nc):
        length = varint(); count = varint()
        extra = [struct.unpack('<I',take(4))[0] for _ in range(count)]
        raw = take(length); assert raw.endswith(b'\0')
        classes.append({'name':raw[:-1].decode('utf8'),'extra':extra})
    assert pos == len(data)
    rows = []
    for cid,start,count in objects:
        assert cid < nc and start + count <= nv
        rows.append({'class':classes[cid]['name'],'values':values[start:start+count]})
    return {'path':str(path.relative_to(ROOT)), 'sha256':hashlib.sha256(data).hexdigest(),
            'decoded':True,'counts':{'objects':no,'keys':nk,'values':nv,'classes':nc},
            'classes':classes,'objects':rows}

if __name__ == '__main__':
    rows = [decode(p) for p in sorted((ROOT/'reconstruction/Resources').rglob('*.nib')) if p.is_file()]
    out = ROOT/'reconstruction/build/nib-decoded.json'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
    print(f'Decoded {sum(x["decoded"] for x in rows)} of {len(rows)} nib files with all table bounds checked.')
