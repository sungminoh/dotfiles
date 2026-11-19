# Claude Code config

`install.py` symlinks these entries into `~/.claude/`:

```
claude/
├── CLAUDE.md       # global instructions
├── settings.json   # model, effort, plugins, marketplaces, hooks, status line, attribution
├── hooks/          # hook scripts referenced from settings.json
├── rules/          # global rules, loaded with CLAUDE.md
│   └── python/     # path-scoped (`paths:`): load only when Python files are read or edited
└── skills/         # gitignored; whitelist personal skills to track them
```

Claude Code writes `settings.json` through the symlink (for example `/plugin` or `/config`), so UI changes land in this repo. Review `git diff` before committing.

## Plugins

Plugins come from the marketplaces in `extraKnownMarketplaces` and are turned on in `enabledPlugins`. Claude Code installs them on launch.

Some plugins are enabled per project rather than globally. Run this inside the project to enable one there (written to the project's `.claude/settings.local.json`, which the global gitignore excludes):

```bash
claude plugin enable vercel@claude-plugins-official --scope local
```

Local-directory marketplaces are registered per machine:

```bash
claude plugin marketplace add ~/Development/banana
claude plugin marketplace add ~/Development/specrail
```

## Skills

`claude/skills/` is gitignored. To track a personal skill, whitelist it in the root `.gitignore`:

```gitignore
claude/skills/
!claude/skills/my-skill/
```

## MCP servers

User-scope MCP servers live in `~/.claude.json`, which Claude Code rewrites constantly, so it is not symlinked. `bootstrap/setup-claude.sh` registers them (`context7`). Playwright and GitHub MCP servers come from their plugins.

## New machine setup

```bash
git clone <this-repo> ~/.dotfiles && cd ~/.dotfiles
./install.py                    # symlinks config entries into ~/.claude/
./bootstrap/setup-claude.sh     # user-scope MCP servers + ~/.zshrc.secret template
```

Or run `./bootstrap/setup-macos.sh`, which also applies macOS defaults and installs Homebrew packages.

## Model and effort

- `model` is `opus[1m]` (Opus 5.5 with the 1M-token context window).
- `effortLevel` is `high`; `modelSettings` raises Opus 5.5 to `xhigh`. `/effort` changes it for a session (`max` is session-only).
- `ultrathink` in a prompt requests deeper reasoning for that turn.
- Context: `/context` to inspect, `/clear` between unrelated tasks, `/compact <focus>` to summarize.

## Writing instructions

- Keep `CLAUDE.md` under 200 lines; it loads in every session.
- Put language-specific rules under `rules/<language>/` with `paths:` frontmatter so they load only for matching files.
- Describe the current setup only. Change history belongs in commit messages.

## Status line

`statusLine` runs the newest cached version of the `claude-hud` plugin and exits without output when the plugin is not installed. The command is a hardened form of what `/claude-hud:setup` generates (it never falls back to a relative path), so edit it in place instead of re-running the setup command.

## Hooks

- `hooks/block-destructive-git.sh` (`PreToolUse` on `Bash`) blocks git commands that discard uncommitted work: `checkout --`, `checkout .`, `restore <path>`, `reset --hard|--keep`, `clean -f`, and `stash`. Prefix a command with `ALLOW_DESTRUCTIVE_GIT=1` to override. Requires `jq`.
- iTerm2 status (`~/.config/iterm2/cc-status`) and the TermPilot monitor (`~/.termpilot/bin/cc-monitor-hook.sh`) run only when their helpers are installed. TermPilot's `PreToolUse` command uses `jq` to pass the tool name as `CLAUDE_TOOL_NAME`, falling back to `unknown`.
