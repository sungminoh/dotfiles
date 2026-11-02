# Claude Code config

`install.py` symlinks the entries below into `~/.claude/`. Layout:

```
claude/
├── CLAUDE.md       # global instructions (rules, agent workflow)
├── settings.json   # hooks, plugins, marketplaces, status line
├── commands/       # custom slash commands
├── hooks/          # reserved for custom hooks (currently empty)
└── skills/         # GITIGNORED — installed via marketplaces
```

## How skills are managed

Skills are **not** vendored in this repo. They come from two sources:

1. **Marketplaces** declared in `settings.json` → `extraKnownMarketplaces`.
   Claude Code installs and updates these automatically.
2. **External installers** (e.g. `gstack` clones itself into
   `~/.claude/skills/gstack/`). Run `../bootstrap/setup-claude.sh` on a
   fresh machine to handle these.

`claude/skills/` is fully gitignored. If you write a personal skill and
want it tracked, whitelist it in the root `.gitignore`:

```gitignore
claude/skills/
!claude/skills/my-skill/
```

## New machine setup

```bash
git clone <this-repo> ~/.dotfiles && cd ~/.dotfiles
./install.py                    # symlinks config entries into ~/.claude/
./bootstrap/setup-claude.sh     # gstack + ~/.zshrc.secret
```

Or run the umbrella `./bootstrap/setup-macos.sh` which also applies
macOS defaults and installs personal Homebrew packages.

Before launching Claude, check out the `banana` and `specrail` repositories
at the local directory paths in `settings.json` → `extraKnownMarketplaces`,
or update those paths to match your checkouts. The bootstrap script does
not install these local marketplaces.

On next `claude` launch, available marketplaces auto-register and plugins
in `enabledPlugins` are picked up. Run `/oh-my-claudecode:omc-setup` to
configure OMC and generate the HUD script used by `statusLine`.

## Hooks and verification

`settings.json` runs optional terminal integrations when their helpers
are executable:

- iTerm2 status: `~/.config/iterm2/cc-status`
- TermPilot monitor: `~/.termpilot/bin/cc-monitor-hook.sh`

Missing helpers are skipped. TermPilot's `PreToolUse` command uses `jq`
to pass the event's tool name as `CLAUDE_TOOL_NAME`; without `jq`, it uses
`unknown`. These helpers are installed separately from this repository.

The former custom lint, project-detection, GitNexus, and memory-persistence
hooks have been removed. Run the project's typecheck, lint, and tests
before committing, as required by `CLAUDE.md`.
