# Hooks

## How hooks work

- `matcher` matches the **tool name** only. Letters, digits, `_`, `-`, spaces, `,` and `|` form an exact name or list (`Bash`, `Edit|Write`). Any other character makes it an unanchored JavaScript regex. It never matches command content.
- To condition on tool arguments, use the handler's `if` field with permission-rule syntax, for example `"if": "Bash(git *)"`. It takes a single rule (no `&&`, `||`, or lists). For anything more complex, inspect `tool_input` from the stdin JSON inside the script.
- Hooks receive JSON on stdin. `read` inside a hook does not wait for the user, so a hook cannot ask for confirmation.
- Exit codes: `0` is success. `2` blocks the action; for `PreToolUse`, stderr is shown to Claude. Any other non-zero code is a non-blocking error and the action proceeds.
- JSON alternative for `PreToolUse`: print one object with `hookSpecificOutput.permissionDecision` set to `allow`, `deny`, `ask`, or `defer`, plus `permissionDecisionReason`.
- `SessionStart` and `UserPromptSubmit`: plain stdout on exit 0 is added to Claude's context. Stderr is not. JSON alternative: `hookSpecificOutput.additionalContext`.
- Edits to `settings.json`, including `hooks`, are picked up automatically. `/hooks` is a read-only browser.

## Registered hooks (`~/.claude/settings.json`)

| Event | Command | Purpose |
|---|---|---|
| `PreToolUse` (`Bash`) | `~/.claude/hooks/block-destructive-git.sh` | Blocks git commands that discard uncommitted work. Override with `ALLOW_DESTRUCTIVE_GIT=1`. |
| `SessionStart`, `PreToolUse`, `PostToolUse`, `Stop` | `~/.termpilot/bin/cc-monitor-hook.sh` | TermPilot session monitoring. Skipped if not installed. |
| All lifecycle events | `~/.config/iterm2/cc-status` | iTerm2 status indicator. Skipped if not installed. |

Hook scripts live in `~/.claude/hooks/`, symlinked from `~/.dotfiles/claude/hooks/`.
