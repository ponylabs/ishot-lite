"""Check production background paths without invoking packaging or system tools."""
import ast
from pathlib import Path
import tempfile
import unittest


class PackagingPaths(unittest.TestCase):
    def test_generated_backgrounds_stay_under_build(self):
        script = Path(__file__).resolve().parents[1] / 'reconstruction/package_dmg.py'
        tree = ast.parse(script.read_text())
        statements = []
        collecting = False
        for node in tree.body:
            if isinstance(node, ast.Assign) and any(
                isinstance(target, ast.Name) and target.id == 'background_dir'
                for target in node.targets
            ):
                collecting = True
            if collecting and isinstance(node, ast.Expr) and isinstance(node.value, ast.Call):
                func = node.value.func
                if isinstance(func, ast.Attribute) and func.attr == 'build_dmg':
                    break
            if collecting:
                statements.append(node)
        self.assertTrue(statements, 'production background generation block missing')
        code = compile(ast.Module(body=statements, type_ignores=[]), str(script), 'exec')
        with tempfile.TemporaryDirectory() as tmp:
            here = Path(tmp)
            assets = here / 'Assets'
            assets.mkdir()
            icon = assets / 'LiteIcon.png'
            icon.write_bytes(b'original-icon')
            calls = []
            namespace = {'HERE': here, 'run': lambda *args: calls.append(args)}
            exec(code, namespace)
            expected = here / 'build/packaging-assets'
            self.assertTrue(expected.is_dir())
            self.assertEqual(namespace['background'], expected / 'InstallerBackground.png')
            self.assertEqual(namespace['background_retina'], expected / 'InstallerBackground@2x.png')
            self.assertEqual(calls, [
                ('xcrun', 'swift', here / 'Tools/InstallerBackground.swift', expected / 'InstallerBackground@2x.png'),
                ('sips', '-z', '400', '640', expected / 'InstallerBackground@2x.png', '--out', expected / 'InstallerBackground.png'),
            ])
            self.assertEqual(list(assets.iterdir()), [icon])
            self.assertEqual(icon.read_bytes(), b'original-icon')
