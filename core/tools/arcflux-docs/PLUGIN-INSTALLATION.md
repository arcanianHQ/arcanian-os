---
scope: shared
---

# ArcFlux Plugin Installation

This guide explains how to install ArcFlux as a Claude Code plugin.

---

## Overview

ArcFlux uses a **hybrid approach**:
- **Plugin commands** (`/arcflux:init`, `/arcflux:start`, etc.) - Claude reads these
- **CLI commands** (`arcflux init`, `arcflux start`, etc.) - Claude runs these
- **Claude** provides guidance and context around CLI execution

This means you need **both**:
1. The ArcFlux CLI installed on your system
2. The ArcFlux plugin installed in Claude Code

---

## Step 1: Install ArcFlux CLI

### Option A: From Source

```bash
# Get the source
git clone https://github.com/your-org/arcflux.git
cd arcflux

# Install dependencies
npm install

# Link globally
npm link

# Verify
arcflux --version
```

### Option B: From npm (when published)

```bash
npm install -g arcflux
arcflux --version
```

---

## Step 2: Install Claude Code Plugin

### Option A: Symlink (Development)

Best for development - changes to source are immediately available:

```bash
# Create plugins directory if needed
mkdir -p ~/.claude/plugins

# Symlink the plugin
ln -s /path/to/arcflux ~/.claude/plugins/arcflux

# Verify
ls -la ~/.claude/plugins/
```

### Option B: Copy (Stable)

For stable installations:

```bash
# Create plugins directory
mkdir -p ~/.claude/plugins

# Copy plugin
cp -r /path/to/arcflux ~/.claude/plugins/arcflux
```

### Required Files

The plugin needs these files in `~/.claude/plugins/arcflux/`:

```
arcflux/
├── .claude-plugin/
│   └── plugin.json        # Plugin metadata (REQUIRED)
├── commands/               # Command definitions
│   ├── init.md
│   ├── start.md
│   ├── phase.md
│   ├── status.md
│   └── ...
├── agents/                 # Agent definitions
│   ├── code-explorer.md
│   ├── code-reviewer.md
│   └── ...
├── hooks/                  # Hook definitions
│   ├── session-start.md
│   └── ...
├── skills/                 # Skill definitions
│   ├── issue-workflow.md
│   └── ...
└── templates/              # Project templates
    └── ...
```

---

## Step 3: Verify Installation

### Check CLI

```bash
arcflux --version
# Should show: 0.1.0 (or similar)

arcflux --help
# Should list commands: init, start, phase, status, etc.
```

### Check Plugin

Start a new Claude Code session:

```bash
claude
```

Then try:
```
/arcflux:status
```

If working, Claude will run `arcflux status` and show results.

---

## How It Works

When you type `/arcflux:init` in Claude Code:

```
1. Claude Code finds plugin at ~/.claude/plugins/arcflux/
2. Loads command definition: commands/init.md
3. Reads that it should run: arcflux init
4. Executes the CLI command
5. Shows output and provides guidance
```

### Hybrid Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ User types: /arcflux:init                                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ Claude Code reads: ~/.claude/plugins/arcflux/commands/init.md│
│                                                             │
│ Sees: mode: hybrid                                          │
│       cli_command: arcflux init                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ Claude runs: arcflux init                                   │
│                                                             │
│ CLI handles:                                                │
│   - Interactive prompts                                     │
│   - File creation                                           │
│   - State management                                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ Claude provides:                                            │
│   - Pre-execution checks                                    │
│   - Post-execution guidance                                 │
│   - Error handling help                                     │
│   - Context and suggestions                                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Updating the Plugin

### If Using Symlink

Changes to source are automatically available. Just restart Claude Code session.

### If Using Copy

```bash
# Remove old version
rm -rf ~/.claude/plugins/arcflux

# Copy new version
cp -r /path/to/arcflux ~/.claude/plugins/arcflux

# Restart Claude Code session
```

---

## Troubleshooting

### "arcflux: command not found"

The CLI isn't installed or not in PATH:

```bash
# Check if installed
which arcflux

# If not found, re-link
cd /path/to/arcflux
npm link
```

### Plugin commands not recognized

Claude Code may not have loaded the plugin:

1. Check plugin exists: `ls ~/.claude/plugins/arcflux/`
2. Check plugin.json exists: `cat ~/.claude/plugins/arcflux/.claude-plugin/plugin.json`
3. Restart Claude Code session

### "Not an ArcFlux project"

You're in a directory without `.arcflux/`:

```bash
# Initialize first
arcflux init

# Or use full path
cd /path/to/your/project
arcflux init
```

---

## Plugin vs CLI: When to Use What

| Scenario | Use |
|----------|-----|
| Inside Claude Code session | `/arcflux:init`, `/arcflux:start` |
| Directly in terminal | `arcflux init`, `arcflux start` |
| Scripts/automation | `arcflux` CLI commands |
| With Claude guidance | `/arcflux:` plugin commands |

Both do the same thing - the plugin just adds Claude's guidance layer.

---

## Uninstalling

### Remove Plugin

```bash
rm -rf ~/.claude/plugins/arcflux
```

### Remove CLI

```bash
# If installed with npm link
cd /path/to/arcflux
npm unlink

# If installed globally
npm uninstall -g arcflux
```

---

*Last updated: 2026-01-09*
