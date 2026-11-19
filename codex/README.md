# Codex config

`install.py` symlinks these entries into `~/.codex/`:

```
codex/
├── AGENTS.md    # global instructions (mirrors claude/CLAUDE.md, with Codex tool names)
└── hooks.json   # TermPilot monitor hooks; skipped when the helper is not installed
```

`~/.codex/config.toml` is not tracked: Codex rewrites it with trust records, project entries, and model state. Manage plugins, marketplaces, and MCP servers with the CLI instead:

```bash
codex plugin list
codex plugin marketplace add <source>
codex mcp add <name> -- <command> [args...]
```

Codex asks once to trust `hooks.json` after it changes.
