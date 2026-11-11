"""Exercise the real audit/build entrances without compiling or altering user inputs."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class RetainedInputTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'project'
        self.here = self.root / 'reconstruction'
        self.here.mkdir(parents=True)
        (self.root / 'scripts').mkdir()
        for name in ('audit.py', 'build.py'):
            shutil.copyfile(ROOT / 'reconstruction' / name, self.here / name)
        shutil.copyfile(ROOT / 'scripts/current_contract.py', self.root / 'scripts/current_contract.py')
        self.rows = []
        for name in ('Resources', 'Configuration', 'Dependencies'):
            path = self.here / name / 'fixture'
            path.parent.mkdir()
            path.write_bytes(b'original input')
            self.rows.append({'source': 'historical/never-read',
                              'path': str(path.relative_to(self.root)),
                              'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
        self.write_manifest()

    def write_manifest(self):
        (self.here / 'retained-inputs.json').write_text(json.dumps({'files': self.rows}))

    def run_entry(self, build=False):
        command = [sys.executable, '-B', str(self.here / ('build.py' if build else 'audit.py'))]
        if not build:
            command.append('--inputs-only')
        return subprocess.run(command, text=True, capture_output=True, timeout=10)

    def assert_rejected(self, message):
        result = self.run_entry()
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertIn(message, result.stderr)
        self.assertFalse((self.here / 'build').exists())

    def test_valid_inputs_do_not_require_archive_or_build(self):
        result = self.run_entry()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('Verified 3 retained inputs', result.stdout)
        self.assertFalse((self.here / 'build').exists())

    def test_tampered_bytes_fail_real_build_before_output(self):
        (self.here / 'Resources/fixture').write_bytes(b'tampered')
        self.assert_rejected('SHA-256 mismatch')
        result = self.run_entry(build=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('SHA-256 mismatch', result.stderr)
        self.assertNotIn('xcrun', result.stderr)
        self.assertFalse((self.here / 'build').exists())

    def test_rejected_build_preserves_existing_outputs(self):
        output = self.here / 'build'
        output.mkdir()
        sentinel = output / 'existing-app'
        sentinel.write_bytes(b'working product')
        (self.here / 'Dependencies/fixture').write_bytes(b'tampered')
        result = self.run_entry(build=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('SHA-256 mismatch', result.stderr)
        self.assertEqual(list(output.iterdir()), [sentinel])
        self.assertEqual(sentinel.read_bytes(), b'working product')

    def test_missing_input_fails(self):
        (self.here / 'Resources/fixture').unlink()
        self.assert_rejected('Missing retained input')

    def test_unlisted_input_fails(self):
        (self.here / 'Resources/unlisted').write_bytes(b'new input')
        self.assert_rejected('Unlisted retained inputs')

    def test_symlink_input_fails_even_with_matching_bytes(self):
        path = self.here / 'Resources/fixture'
        target = self.root / 'elsewhere'
        path.rename(target)
        path.symlink_to(target)
        self.assert_rejected('must not use symlinks')

    def test_duplicate_row_fails(self):
        self.rows.append(self.rows[0])
        self.write_manifest()
        self.assert_rejected('Duplicate retained input')

    def test_empty_manifest_fails(self):
        self.rows = []
        self.write_manifest()
        self.assert_rejected('must list files')

    def test_external_manifest_path_fails(self):
        self.rows[0]['path'] = '../outside'
        self.write_manifest()
        self.assert_rejected('Invalid retained input path')


if __name__ == '__main__':
    unittest.main()
