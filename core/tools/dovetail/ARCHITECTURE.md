---
scope: shared
---

# Dovetail Architecture & Workflow Documentation

## Overview

Dovetail is an **AI-native development workflow system** that enforces issue-driven development when using Claude Code. It ensures all code changes are linked to a Linear issue, tracked in git branches, and automatically committed with pull requests.

**Version:** 2.0.18
**Package:** `@lumberjack-so/dovetail`
**License:** MIT

---

## Core Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. User opens project in Claude Code                   │
│     → session-start hook shows project context          │
│                                                         │
│  2. User types a message                                │
│     → user-prompt-submit hook runs                      │
│     → Ensures a Linear issue exists (auto-creates one)  │
│                                                         │
│  3. Claude tries to write code                          │
│     → pre-tool-use hook validates workflow              │
│     → Blocks if no active issue, prompts for fix        │
│                                                         │
│  4. After code is written                               │
│     → post-tool-use hook detects changes                │
│     → Prompts to run dovetail-finalize agent            │
│     → Agent auto-commits, creates PR, updates Linear    │
└─────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
dovetail/
├── bin/
│   └── dovetail.js          # CLI entry point
├── src/
│   ├── commands/            # CLI command implementations
│   │   ├── init.js          # Project scaffolding
│   │   ├── adopt.js         # Adopt existing project
│   │   ├── start.js         # Start work on issue
│   │   ├── status.js        # Display project state
│   │   ├── check-issue.js   # Ensure active issue exists
│   │   ├── validate.js      # Pre-write validation
│   │   ├── auto-commit.js   # Post-write auto-commit
│   │   └── onboard.js       # Verify CLI installations
│   ├── cli/                 # Native CLI wrappers
│   │   ├── gh.js            # GitHub CLI wrapper
│   │   ├── linearis.js      # Linear CLI wrapper
│   │   ├── supabase.js      # Supabase CLI wrapper
│   │   ├── flyctl.js        # Fly.io CLI wrapper
│   │   └── linear-api.js    # Direct Linear API access
│   ├── utils/
│   │   ├── state.js         # State management
│   │   └── git.js           # Git operations
│   └── templates/
│       └── scaffold.js      # Project template generator
├── .claude-hooks/           # Claude Code hook scripts
│   ├── user-prompt-submit.sh
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   ├── session-start.sh
│   └── agent-complete.sh
└── test/                    # Test suite
```

---

## Key Components

### 1. CLI Entry Point (`bin/dovetail.js`)

The main executable that uses the `commander` framework to register all commands. Requires Node.js 18+ and uses ES modules.

### 2. Commands (`src/commands/`)

| Command | Description |
|---------|-------------|
| `dovetail init "name"` | Scaffold a new project with GitHub, Linear, Supabase, Fly.io |
| `dovetail adopt` | Add Dovetail to an existing project |
| `dovetail start <issue-key>` | Start working on a Linear issue (creates branch) |
| `dovetail status` | Show current project state (JSON or human-readable) |
| `dovetail check-issue` | Ensure an active issue exists |
| `dovetail validate` | Check if workflow is valid before writing code |
| `dovetail auto-commit` | Commit changes with conventional message |
| `dovetail onboard` | Verify CLI installations (gh, linearis, supabase, flyctl) |

### 3. CLI Wrappers (`src/cli/`)

Dovetail delegates to native CLIs instead of using API SDKs:

- **`gh.js`** - GitHub operations (repos, PRs, secrets)
- **`linearis.js`** - Linear issue management
- **`supabase.js`** - Database project management
- **`flyctl.js`** - Deployment operations
- **`linear-api.js`** - Direct API for operations linearis doesn't support

### 4. State Management (`src/utils/state.js`)

Two-level state system:

**Global state** (`~/.dovetail/state.json`):
- User preferences and configurations

**Project state** (`.dovetail/state.json`):
```json
{
  "name": "My Project",
  "slug": "my-project",
  "activeIssue": {
    "key": "PRJ-123",
    "id": "uuid",
    "title": "Add login form",
    "branch": "feat/prj-123-add-login-form",
    "url": "https://linear.app/..."
  },
  "github": { "owner": "...", "repo": "...", "url": "..." },
  "linear": { "teamId": "...", "projectId": "..." },
  "supabase": { "projectRef": "...", "url": "..." },
  "flyio": { "staging": "...", "production": "..." }
}
```

### 5. Git Utilities (`src/utils/git.js`)

Wraps `simple-git` library for:
- Branch management: `createBranch()`, `checkout()`, `deleteBranch()`
- Commit/push: `commit()`, `push()`, `pull()`
- Status: `getCurrentBranch()`, `isRepoClean()`, `getChangedFiles()`

---

## Hook System

Five bash scripts in `.claude-hooks/` intercept Claude Code lifecycle events:

### `user-prompt-submit.sh`
- **Trigger:** Before Claude sees the user's message
- **Action:** Calls `dovetail check-issue --auto`
- **Purpose:** Ensures an active Linear issue exists
- **Exit:** Always 0 (non-blocking)

### `pre-tool-use.sh`
- **Trigger:** Before Write/Edit/NotebookEdit operations
- **Action:** Validates workflow state via `dovetail status --json`
- **Purpose:** Blocks code changes if no active issue
- **Exit:** 0 (proceed) or 2 (block)

### `post-tool-use.sh`
- **Trigger:** After Write/Edit operations
- **Action:** Detects file changes, prompts for `dovetail-finalize`
- **Purpose:** Triggers auto-commit workflow
- **Exit:** 0 (proceed) or 2 (prompt user)

### `session-start.sh`
- **Trigger:** When project is opened in Claude Code
- **Action:** Displays project context and status
- **Purpose:** Orient the user/Claude to current state

### `agent-complete.sh`
- **Trigger:** After an agent finishes
- **Action:** Shows next workflow steps
- **Purpose:** Guide user to next action

**Exit Code Behavior:**
- `0` = Allow operation to proceed
- `2` = Block operation and show message

---

## Autonomous Agents

### `dovetail-sync`
Invoked by `pre-tool-use` hook:
- Validates task relevance to current issue
- Searches Linear for better matching issue if needed
- Creates new issues when necessary
- Ensures correct feature branch exists
- **Never asks the user** - fully autonomous

### `dovetail-finalize`
Invoked by `post-tool-use` hook:
- Analyzes code changes
- Commits with conventional message format
- Creates PR via `gh` CLI
- Updates Linear issue with commit/PR links
- Searches for TODOs and creates issues
- **Never asks for confirmation** - fully autonomous

---

## User Workflows

### Starting a New Project

```bash
dovetail init "my-app"
# Creates: GitHub repo, Linear team, Supabase project, Fly.io apps
# Scaffolds: React + Express + PostgreSQL structure
# Installs: Claude Code hooks

cd my-app
# Open in Claude Code and start coding
```

### Adopting an Existing Project

```bash
cd my-existing-app
dovetail adopt
# Links to existing GitHub, Linear, Supabase, Fly.io
# Installs hooks
# Creates .dovetail/state.json
```

### Development Session

```
1. Open project in Claude Code
2. Type: "Build a login form"
3. Hook auto-selects/creates Linear issue
4. Claude writes code
5. Hook prompts for dovetail-finalize
6. Agent commits, creates PR, updates Linear
7. Done - PR ready for review
```

### Switching Tasks

```
1. Type: "Now let's add dark mode"
2. dovetail-sync agent detects mismatch
3. Searches Linear for matching issue
4. Switches to correct branch
5. Proceeds with new task
```

---

## Technology Stack

### Production Dependencies

| Package | Purpose |
|---------|---------|
| `commander` | CLI argument parsing |
| `inquirer` | Interactive prompts |
| `execa` | Execute native CLIs safely |
| `chalk` | Terminal colors |
| `ora` | Spinners and progress |
| `listr2` | Task lists |
| `simple-git` | Git operations |
| `fs-extra` | File operations |
| `slugify` | URL-safe slugs |
| `conventional-commits-parser` | Parse commit messages |
| `dotenv` | Environment variables |
| `node-fetch` | HTTP requests |

### External CLI Dependencies

- `gh` - GitHub CLI
- `linearis` - Linear CLI
- `supabase` - Supabase CLI
- `flyctl` - Fly.io CLI

---

## Design Principles

### 1. CLI Delegation over API SDKs
Uses native CLIs instead of API wrappers, resulting in:
- 52% smaller codebase
- Less maintenance burden
- Full feature access
- Industry standard tooling

### 2. Stateful + Stateless Symmetry
Every hook behavior is available as a CLI command:
- `user-prompt-submit` → `dovetail check-issue --auto`
- `pre-tool-use` → `dovetail validate`
- `post-tool-use` → `dovetail auto-commit`

### 3. Autonomous Agent Design
Agents never ask the user:
- Make decisions automatically
- Keep Linear workspace clean
- Handle errors gracefully
- Idempotent - can be invoked repeatedly

### 4. Hook-Level Integration
Doesn't modify Claude Code directly:
- Uses exit codes to control flow
- Compatible with any Claude Code version
- Non-invasive and debuggable
- User maintains control

---

## Configuration

### Environment Variables

```bash
LINEAR_API_KEY=lin_api_xxx    # Linear API authentication
GITHUB_TOKEN=ghp_xxx          # GitHub token (or use gh auth login)
SUPABASE_ACCESS_TOKEN=xxx     # Supabase authentication
FLY_API_TOKEN=xxx             # Fly.io authentication
```

### Project Configuration

Located in `.dovetail/state.json` - automatically managed by Dovetail commands.

---

## Troubleshooting

### Verify Setup
```bash
dovetail onboard
```

### Check Project State
```bash
dovetail status
dovetail status --json
```

### Manual Issue Start
```bash
dovetail start PRJ-123
```

### Validate Workflow
```bash
dovetail validate
```
