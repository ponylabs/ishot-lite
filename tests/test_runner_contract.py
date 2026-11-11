"""Runner routing tests only; subprocesses are faked, not application validation."""
import contextlib
import io
from pathlib import Path
import runpy
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch


class TestRunnerContract(unittest.TestCase):
    def exercise(self, original=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / 'project'
            reconstruction = root / 'reconstruction'
            reconstruction.mkdir(parents=True)
            runner = reconstruction / 'test.py'
            shutil.copyfile(Path(__file__).resolve().parents[1] / 'reconstruction/test.py', runner)
            args = [str(runner)]
            if original:
                archive = Path(directory) / 'external-materials'
                (archive / 'binaries').mkdir(parents=True)
                for name in ('PTHotKey', 'ShortcutRecorder'):
                    (archive / f'resources/Contents/Frameworks/{name}.framework/Versions/A').mkdir(parents=True)
                    (archive / f'binaries/{name}.arm64').write_bytes(b'fixture')
                args += ['--original-recovery', str(archive)]
            commands = []
            def run(command, **kwargs):
                commands.append([str(part) for part in command])
                return subprocess.CompletedProcess(command, 0, 'same bounded output\n', '')
            with patch.object(sys, 'argv', args), patch('subprocess.run', side_effect=run), contextlib.redirect_stdout(io.StringIO()):
                runpy.run_path(str(runner), run_name='__main__')
            self.assertFalse((root / 'recovery').exists())
            return commands

    def test_default_does_not_access_original_materials(self):
        commands = self.exercise()
        runs = [command for command in commands if command[0] != 'xcrun']
        self.assertEqual(len(runs), 36)
        self.assertTrue({'CaptureTests', 'VideoControlsTests', 'ClipEventTests',
                         'SGCaptureSessionTests', 'ClipScrollTests', 'PreferenceTests',
                         'PinBehaviorTests', 'DependencyTests'}.issubset(
                             {Path(command[0]).name for command in runs}))
        flattened = '\n'.join(' '.join(command) for command in commands)
        self.assertNotIn('OriginalFrameworks', flattened)
        self.assertNotIn('recovery/', flattened)
        self.assertIn('build/iShotHelper.app/Contents/Resources', flattened)
        self.assertIn('reconstruction/Dependencies/webp/libs/libwebp.a', flattened)
        self.assertIn('reconstruction/Dependencies', flattened)

    def test_external_original_comparison_is_explicit(self):
        commands = self.exercise(original=True)
        runs = [command for command in commands if command[0] != 'xcrun']
        self.assertEqual(len(runs), 38)
        self.assertEqual(sum('OriginalPTHotKeyTests' in command[0] for command in runs), 1)
        self.assertEqual(sum('OriginalShortcutRecorderTests' in command[0] for command in runs), 1)
        self.assertTrue(any('external-materials/binaries/' in part for command in commands for part in command))

    def test_invalid_external_archive_fails_before_compilation(self):
        runner = Path(__file__).resolve().parents[1] / 'reconstruction/test.py'
        with patch.object(sys, 'argv', [str(runner), '--original-recovery', '/nonexistent/ishot-test-archive']), patch('subprocess.run') as run:
            with self.assertRaises(FileNotFoundError):
                runpy.run_path(str(runner), run_name='__main__')
            run.assert_not_called()


if __name__ == '__main__':
    unittest.main()
