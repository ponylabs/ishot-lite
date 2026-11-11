"""Read the project's explicit Objective-C header API (not recovery metadata).

This deliberately supports the declaration forms used by this repository, not a
complete Objective-C parser. Runtime nib validation remains the authority for KVC,
inherited AppKit behavior and responder-chain actions.
"""
import re
from pathlib import Path


def header_contract(source):
    classes, methods, bases = set(), {}, {}
    for path in sorted(Path(source).rglob('*.h')):
        if 'tests' in path.parts or 'iShotHelper' in path.parts:
            continue
        text = re.sub(r'/\*.*?\*/|//[^\n]*', '', path.read_text(), flags=re.S)
        for match in re.finditer(r'@interface\s+(\w+)(?:\s*\([^)]*\))?(?:\s*:\s*(\w+))?(.*?)@end', text, re.S):
            name, base, body = match.groups()
            if base:
                classes.add(name)
                bases[name] = base
            expected = methods.setdefault(name, set())
            for method in re.finditer(r'([+-])\s*\([^)]*\)\s*([^;{}]+);', body):
                kind, declaration = method.groups()
                # Remove argument names/types before reading selector components; unnamed components are valid.
                selector_text = re.sub(r':\s*\([^)]*\)\s*\w+', ':', declaration)
                keywords = re.findall(r'(\w*)\s*:', selector_text)
                selector = ''.join(k + ':' for k in keywords) if keywords else re.match(r'\w+', declaration).group()
                expected.add((kind, selector))
            for prop in re.finditer(r'@property\s*(?:\(([^)]*)\))?\s*([^;]+);', body):
                attributes, declaration = prop.groups()
                attributes = attributes or ''
                name_match = re.search(r'\(\s*\^\s*(\w+)\s*\)', declaration) or re.search(r'(\w+)\s*$', declaration)
                if not name_match:
                    raise ValueError(f'Unsupported property declaration in {path}: {declaration}')
                prop_name = name_match.group(1)
                kind = '+' if re.search(r'\bclass\b', attributes) else '-'
                getter = re.search(r'getter\s*=\s*(\w+)', attributes)
                expected.add((kind, getter.group(1) if getter else prop_name))
                if not re.search(r'\breadonly\b', attributes):
                    setter = re.search(r'setter\s*=\s*(\w+:)', attributes)
                    expected.add((kind, setter.group(1) if setter else 'set' + prop_name[0].upper() + prop_name[1:] + ':'))
    if not classes or not methods:
        raise ValueError('No current Objective-C header contracts found')
    return classes, methods, bases


def emitted_methods(symbols):
    result = {}
    for kind, name, selector in re.findall(r'([+-])\[(\w+)(?:\([^)]*\))? ([^\]]+)\]', symbols):
        result.setdefault(name, set()).add((kind, selector))
    return result


def missing_methods(expected, actual):
    return {name: sorted(selectors - actual.get(name, set())) for name, selectors in expected.items()
            if selectors - actual.get(name, set())}
