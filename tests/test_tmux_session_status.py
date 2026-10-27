import importlib.machinery
import importlib.util
from pathlib import Path
import unittest


path = Path(__file__).parents[1] / 'scripts/.local/bin/tmux-session-status'
loader = importlib.machinery.SourceFileLoader('session_status', str(path))
spec = importlib.util.spec_from_loader(loader.name, loader)
status = importlib.util.module_from_spec(spec)
loader.exec_module(status)


class SessionStatusTests(unittest.TestCase):
    # Codex runs below its Node launcher; the adjacent shell has the same cwd.
    processes = {10: (1, 'zsh'), 11: (10, 'node'), 12: (11, '/opt/bin/codex'),
                 20: (1, 'zsh'), 21: (20, 'node')}

    def pane(self, pid=10, title='', hook=''):
        return {'pid': pid, 'title': title, 'hook': hook}

    def test_working_without_hook_status(self):
        self.assertEqual(status.session_status(
            [self.pane(title='⠴ Fix a bug | project')], self.processes), '🤖 working')

    def test_idle_codex_is_visible_without_a_hook(self):
        self.assertEqual(status.session_status(
            [self.pane(title='Fix a bug | project')], self.processes), '✓ idle')

    def test_both_blink_phases_are_waiting(self):
        for title in ('[ ! ] Action Required | project', '[ . ] Action Required | project'):
            with self.subTest(title=title):
                self.assertEqual(status.session_status(
                    [self.pane(title=title)], self.processes), '💬 waiting')

    def test_unrelated_node_process_is_not_an_agent(self):
        self.assertEqual(status.session_status(
            [self.pane(pid=20, title='Web server')], self.processes), '')

    def test_native_activity_wins_over_stale_hook(self):
        self.assertEqual(status.session_status(
            [self.pane(title='⠋ Fix a bug', hook='✅')], self.processes), '🤖 working')

    def test_waiting_agent_has_priority_over_working(self):
        processes = self.processes.copy()
        processes[22] = (21, '/opt/bin/codex')
        self.assertEqual(status.session_status([
            self.pane(title='⠋ Fix a bug'),
            self.pane(pid=20, title='[ ! ] Action Required'),
        ], processes), '💬 waiting')

    def test_other_agents_keep_workmux_hook_status(self):
        self.assertEqual(status.session_status(
            [self.pane(pid=20, hook='✅')], self.processes), '✅')


if __name__ == '__main__':
    unittest.main()
