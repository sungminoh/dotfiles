# Claude Code config

This directory is symlinked to `~/.claude/` by `install.py`. Layout:

```
claude/
├── CLAUDE.md       # global instructions (rules, agent workflow)
├── settings.json   # hooks, plugins, marketplaces, status line
├── commands/       # custom slash commands
├── hooks/          # PreToolUse / PostToolUse / Stop scripts
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
./install.py                    # symlinks ~/.claude → claude/
./bootstrap/setup-claude.sh     # installs gstack, creates ~/.zshrc.secret
```

On next `claude` launch, marketplaces auto-register and plugins in
`enabledPlugins` are picked up.
