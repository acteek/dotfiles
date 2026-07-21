# tmux-fzf-sessions actions

## Scope

Extend `scripts/.local/bin/tmux-fzf-sessions` with session deletion and creation actions while retaining its current Enter-to-switch behavior.

## Controls

- **Enter / Ctrl-Y:** switch the current tmux client to the highlighted session.
- **Ctrl-X:** immediately kill the highlighted session, then reload the fzf session list so the picker remains open.
- **Ctrl-N:** create a detached tmux session using the current fzf query as its name, then switch the current client to it.

## Constraints and errors

Ctrl-N requires a non-empty query. Existing tmux errors, including duplicate session names, are surfaced rather than ignored. The script will not change any other tmux helper behavior.

## Verification

No automated tests or verification commands will be added or run. The user will manually verify query propagation, session deletion and list reload, creation, and Ctrl-Y switching.
