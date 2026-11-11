"""Run the production fixture setup twice without executing AppKit tests."""
import ast
from pathlib import Path
import tempfile
import unittest

class FixtureRepeatability(unittest.TestCase):
    def test_rebuild_preserves_source_and_replaces_generated_symlinks(self):
        script = Path(__file__).resolve().parents[1] / 'reconstruction/test.py'
        tree = ast.parse(script.read_text())
        function = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'prepare_original_frameworks')
        namespace = {'shutil': __import__('shutil')}
        exec(compile(ast.Module(body=[function], type_ignores=[]), str(script), 'exec'), namespace)
        prepare = namespace['prepare_original_frameworks']
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'reconstruction').mkdir()
            binaries = root / 'recovery/binaries'
            binaries.mkdir(parents=True)
            for name in ('PTHotKey', 'ShortcutRecorder'):
                framework = root / 'recovery/resources/Contents/Frameworks' / (name + '.framework')
                (framework / 'Versions/A/Resources').mkdir(parents=True)
                (framework / 'Versions/Current').symlink_to('A')
                (framework / 'Resources').symlink_to('Versions/Current/Resources')
                (binaries / (name + '.arm64')).write_bytes(b'fixture-original')
            for _ in range(2):
                prepare(root / 'recovery', root / 'reconstruction/build')
            for name in ('PTHotKey', 'ShortcutRecorder'):
                fixture = root / 'reconstruction/build/OriginalFrameworks' / (name + '.framework')
                self.assertEqual((fixture / name).read_bytes(), b'fixture-original')
                self.assertEqual((binaries / (name + '.arm64')).read_bytes(), b'fixture-original')
                self.assertTrue((fixture / 'Resources').is_symlink())
                original = root / 'recovery/resources/Contents/Frameworks' / (name + '.framework')
                self.assertEqual((original / 'Resources').readlink().as_posix(), 'Versions/Current/Resources')
                self.assertEqual((original / 'Versions/Current').readlink().as_posix(), 'A')
                self.assertEqual(list((original / 'Versions/A/Resources').iterdir()), [])

    def test_directory_aliases_cannot_delete_external_content(self):
        script = Path(__file__).resolve().parents[1] / 'reconstruction/test.py'
        tree = ast.parse(script.read_text())
        function = next(node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'prepare_original_frameworks')
        namespace = {'shutil': __import__('shutil')}
        exec(compile(ast.Module(body=[function], type_ignores=[]), str(script), 'exec'), namespace)
        prepare = namespace['prepare_original_frameworks']
        for target in ('build', 'build/OriginalFrameworks', 'build/OriginalFrameworks/PTHotKey.framework'):
            with self.subTest(target=target), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                reconstruction = root / 'reconstruction'
                reconstruction.mkdir()
                external = root / 'external'
                external.mkdir()
                sentinel = external / 'sentinel'
                sentinel.write_text('must survive')
                alias = reconstruction / target
                alias.parent.mkdir(parents=True, exist_ok=True)
                alias.symlink_to(external, target_is_directory=True)
                with self.assertRaisesRegex(RuntimeError, 'alias'):
                    prepare(root / 'recovery', reconstruction / 'build')
                self.assertEqual(sentinel.read_text(), 'must survive')
