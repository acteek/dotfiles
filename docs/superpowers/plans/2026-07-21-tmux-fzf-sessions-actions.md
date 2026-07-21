# tmux-fzf-sessions actions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Ctrl-X deletion, Ctrl-N query-named creation, and Ctrl-Y switching to the tmux session fzf picker.

**Architecture:** Keep the helper as one shell command. Use fzf action bindings that either become a tmux client switch, execute a session deletion and reload the list, or create a detached named session before switching to it.

**Tech Stack:** POSIX shell, tmux, fzf.

## Global Constraints

- Do not add or run automated tests or verification commands; the user will manually verify the behavior.
- Do not modify unrelated working-tree changes in `scripts/.local/bin/tmux-run` or `scripts/.local/bin/tmux-setup`.
- Ctrl-N requires a non-empty fzf query; tmux errors are not suppressed.

---

### Task 1: Extend the session picker bindings

**Files:**
- Modify: `scripts/.local/bin/tmux-fzf-sessions`

**Interfaces:**
- Consumes: `tmux list-sessions -F '#S'` output and fzf placeholders `{}` (selected session) and `{q}` (query).
- Produces: session switching on Enter/Ctrl-Y, immediate deletion plus picker reload on Ctrl-X, and named session creation plus switching on Ctrl-N.

- [ ] **Step 1: Replace the single Enter binding with the complete binding set**

```sh
tmux list-sessions -F '#S' | fzf \
  --bind 'enter:become(tmux switch-client -t {})' \
  --bind 'ctrl-y:become(tmux switch-client -t {})' \
  --bind 'ctrl-x:execute(tmux kill-session -t {})+reload(tmux list-sessions -F "#S")' \
  --bind 'ctrl-n:execute(if [ -n {q} ]; then tmux new-session -d -s {q}; tmux switch-client -t {q}; fi)' \
  --layout reverse --cycle
```

- [ ] **Step 2: Leave verification to the user**

Do not run tests, syntax checks, or tmux/fzf commands. The user will manually check each binding.

- [ ] **Step 3: Commit the script change**

```bash
git add scripts/.local/bin/tmux-fzf-sessions
git commit -m "Add tmux fzf session actions"
```
