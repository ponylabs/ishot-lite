import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from current_contract import header_contract, emitted_methods, missing_methods
spec = importlib.util.spec_from_file_location('source_audit', ROOT / 'reconstruction/audit.py')
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class CurrentContractTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.here = Path(self.temp.name)
        (self.here / 'Sources').mkdir()
        (self.here / 'build').mkdir()
        (self.here / 'Sources/Example.h').write_text('''
@interface Example : NSObject
@property(getter=isReady) BOOL ready;
@property(readonly) NSString *title;
@property(copy) void (^complete)(void);
+ (double)distance:(CGPoint)a :(CGPoint)b;
- (void)perform:(id)sender;
@end
@interface Example (Extension)
- (void)extra;
@end
''')
        self.symbols = '''000 T _OBJC_CLASS_$_Example
000 t -[Example isReady]
000 t -[Example setReady:]
000 t -[Example title]
000 t -[Example complete]
000 t -[Example setComplete:]
000 t +[Example distance::]
000 t -[Example perform:]
000 t -[Example(Extension) extra]
'''

    def test_selector_and_property_contract(self):
        classes, expected, _ = header_contract(self.here / 'Sources')
        self.assertEqual(classes, {'Example'})
        self.assertEqual(len(expected['Example']), 8)
        self.assertEqual(missing_methods(expected, emitted_methods(self.symbols)), {})

    def run_audit(self, symbols):
        with patch.object(audit, 'HERE', self.here), patch.object(audit.subprocess, 'check_output', return_value=symbols):
            audit.main()
        return json.loads((self.here / 'build/source-audit.json').read_text())

    def test_real_audit_entry_accepts_current_api_without_recovery(self):
        self.assertEqual(self.run_audit(self.symbols)['missing_project_classes'], [])

    def test_real_audit_entry_rejects_removed_method(self):
        with self.assertRaises(SystemExit):
            self.run_audit(self.symbols.replace('000 t -[Example perform:]\n', ''))

    def test_real_audit_entry_rejects_entire_missing_class(self):
        with self.assertRaises(SystemExit):
            self.run_audit('')

    def test_empty_contract_cannot_pass(self):
        (self.here / 'Sources/Example.h').write_text('// empty')
        with self.assertRaises(ValueError):
            self.run_audit(self.symbols)

class NibManifestTests(unittest.TestCase):
    def run_manifest(self, decoded=None, create=True):
        import runpy
        with tempfile.TemporaryDirectory() as folder:
            resources = Path(folder) / 'Resources'
            resources.mkdir()
            if create:
                (resources / 'Test.nib').write_bytes(b'fixture')
            output = Path(folder) / 'manifest.json'
            with patch.object(sys, 'argv', ['audit_nib_dependencies.py', str(resources), str(output)]), \
                    patch('decode_nibs.decode', return_value=decoded):
                runpy.run_path(str(ROOT / 'scripts/audit_nib_dependencies.py'), run_name='__main__')
            return json.loads(output.read_text())

    def test_resource_relative_path_and_unknown_class_preserved(self):
        result = self.run_manifest({'decoded': True, 'sha256': 'fixture', 'objects': [
            {'class': 'MissingController', 'values': []}]})
        self.assertEqual(result[0]['path'], 'Test.nib')
        self.assertIn('MissingController', result[0]['custom_classes'])

    def test_no_nibs_is_failure(self):
        with self.assertRaises(SystemExit):
            self.run_manifest(create=False)

    def test_unsupported_format_is_failure(self):
        with self.assertRaises(SystemExit):
            self.run_manifest({'decoded': False})

    def test_outlet_endpoints_preserved(self):
        objects = [
            {'class': 'Owner', 'values': []}, {'class': 'Destination', 'values': []},
            {'class': 'NSNibOutletConnector', 'values': [
                {'key': 'NSSource', 'value': {'object': 0}},
                {'key': 'NSDestination', 'value': {'object': 1}},
                {'key': 'NSLabel', 'value': {'utf8': 'outlet'}}]}]
        result = self.run_manifest({'decoded': True, 'sha256': 'fixture', 'objects': objects})
        connection = result[0]['connections'][0]
        self.assertEqual(connection['source']['class'], 'Owner')
        self.assertEqual(connection['destination']['class'], 'Destination')
        self.assertEqual(connection['label'], 'outlet')


if __name__ == '__main__':
    unittest.main()
