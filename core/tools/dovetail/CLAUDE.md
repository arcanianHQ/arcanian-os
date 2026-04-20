---
scope: shared
---

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dovetail 2.0 is an AI-native development workflow system that enforces issue-driven development through deterministic hooks and native CLI delegation.

**Key Architecture Shift in 2.0**: Instead of wrapping APIs, Dovetail delegates to native CLIs (`gh`, `linearis`, `supabase`, `flyctl`). This makes the codebase 52% smaller, eliminates API wrapper maintenance, and gives full CLI power.

## Development Commands

### Running the CLI locally
```bash
npm run dev <command>              # Run dovetail CLI in development
# Example: npm run dev onboard
# Example: npm run dev status
```

### Local installation for testing
```bash
npm link                           # Install CLI globally from source
dovetail <command>                 # Use globally linked version
npm unlink -g @lumberjack-so/dovetail  # Uninstall global link
```

### Publishing
```bash
npm publish --access public        # Manual publish to npm
# Or update version in package.json - GitHub Actions will auto-publish
```

## Architecture (2.0)

### Core Design Principles

1. **CLI Delegation**: Delegate to native CLIs instead of wrapping APIs
2. **Deterministic Hooks**: Hooks enforce workflow state, not suggest actions
3. **Stateful**: Maintains project state in `.dovetail/state.json`
4. **Hook-Command Symmetry**: Every hook just calls a Dovetail command

### Module Organization

```
src/
├── commands/          # CLI command implementations
│   ├── init.js       # Project scaffolding (uses native CLIs)
│   ├── adopt.js      # Project adoption (uses native CLIs)
│   ├── start.js      # Issue selection and branch creation
│   ├── status.js     # Show current project state
│   ├── onboard.js    # Check CLI installations
│   ├── check-issue.js     # Ensure active issue (user-prompt-submit hook)
│   ├── validate.js        # Validate state (pre-tool-use hook)
│   └── auto-commit.js     # Auto-commit (post-tool-use hook)
├── cli/              # Native CLI wrappers
│   ├── linearis.js   # Linearis CLI wrapper
│   ├── gh.js         # GitHub CLI wrapper
│   ├── supabase.js   # Supabase CLI wrapper
│   └── flyctl.js     # Fly.io CLI wrapper
├── checks/           # Quality checks
│   ├── security-scan.js
│   └── test-runner.js
├── utils/            # Shared utilities
│   ├── state.js      # State management
│   ├── git.js        # Git operations
│   └── logger.js     # Logging
└── templates/
    └── scaffold.js   # Project template generation
```

### State Management

Dovetail maintains project state in `.dovetail/state.json`:

```json
{
  "name": "My Project",
  "slug": "my-project",
  "activeIssue": {
    "key": "PRJ-123",
    "title": "Add login form",
    "branch": "feat/prj-123-add-login-form",
    "url": "https://linear.app/..."
  },
  "github": {
    "owner": "username",
    "repo": "my-project",
    "url": "https://github.com/username/my-project"
  },
  "linear": {
    "teamId": "abc123"
  },
  "supabase": {
    "projectRef": "xyz789",
    "url": "https://xyz789.supabase.co"
  },
  "flyio": {
    "staging": "my-project-staging",
    "production": "my-project-production"
  }
}
```

### CLI Wrappers Pattern

All CLI wrappers follow this pattern:

```javascript
// src/cli/linearis.js
import { execa } from 'execa';

export async function execLinearis(command, action, args = [], options = {}) {
  try {
    const { stdout, exitCode } = await execa('linearis', [command, action, ...args], {
      reject: false,
      ...options
    });

    if (exitCode !== 0) {
      // Check for common errors and provide helpful messages
      if (stderr.includes('Unauthorized')) {
        throw new Error('Linearis not authenticated. Run: export LINEAR_API_KEY=<key>');
      }
      throw new Error(`Linearis failed: ${stderr}`);
    }

    return { stdout, success: true };
  } catch (error) {
    if (error.code === 'ENOENT') {
      throw new Error('Linearis not installed. Run: npm install -g linearis');
    }
    throw error;
  }
}

// Convenience methods
export async function listIssues(teamId, projectId, options = {}) {
  const { stdout } = await execLinearis('issue', 'ls', [
    '--team', teamId,
    '--project', projectId,
    '--json'
  ]);
  return JSON.parse(stdout);
}
```

### Hook Architecture

Hooks are **simple dispatchers** that call Dovetail commands:

**`.claude/hooks/user-prompt-submit.sh`**
```bash
#!/bin/bash
dovetail check-issue --auto --quiet
exit 0
```

**`.claude/hooks/pre-tool-use.sh`**
```bash
#!/bin/bash
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
[[ ! "$TOOL_NAME" =~ (Write|Edit) ]] && exit 0

dovetail validate
exit $?  # Pass through exit code (0 or 2)
```

**`.claude/hooks/post-tool-use.sh`**
```bash
#!/bin/bash
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
[[ ! "$TOOL_NAME" =~ (Write|Edit) ]] && exit 0

git diff --quiet && git diff --cached --quiet && exit 0
dovetail auto-commit --quiet
exit 0
```

### Command Flow Examples

**`dovetail start PRJ-123`:**
1. Load project state from `.dovetail/state.json`
2. Call `linearis issue show PRJ-123` to get issue details
3. Sync main branch via `simple-git`
4. Create feature branch: `feat/prj-123-issue-title`
5. Call `linearis issue update` to move to "In Progress"
6. Save active issue to state

**`dovetail check-issue --auto`:**
1. Load project state
2. If has active issue: exit 0
3. If no active issue:
   - Call `linearis issue ls` to search issues
   - If no issues: create placeholder via `linearis issue create`
   - If has issues: pick first one
   - Call `dovetail start <issue-key>`
   - Exit 0

**`dovetail validate`:**
1. Load project state
2. Check if `activeIssue` exists
3. If NOT: print error, exit 2 (blocks operation)
4. If YES: exit 0 (allows operation)

**`dovetail auto-commit`:**
1. Load project state
2. Check for uncommitted changes
3. Generate conventional commit: `feat(PRJ-123): update app.js`
4. Commit via `simple-git`
5. Push to remote
6. Call `linearis issue comment` to add commit link

## Important Implementation Details

### CLI Wrappers Not API Wrappers

**Old (1.x):**
```javascript
import { LinearClient } from '@linear/sdk';
const linear = new LinearClient({ apiKey: token });
const issues = await linear.issues({ filter: { ... } });
```

**New (2.0):**
```javascript
import { listIssues } from '../cli/linearis.js';
const issues = await listIssues(teamId, projectId, {
  stateType: ['unstarted', 'started']
});
// Internally calls: linearis issue ls --team ... --json
```

### Error Handling

CLI wrappers provide helpful error messages:

```javascript
if (error.code === 'ENOENT') {
  throw new Error(
    'GitHub CLI not installed.\n\n' +
    'Install it from: https://cli.github.com/\n' +
    '  macOS:   brew install gh\n' +
    '  Windows: winget install GitHub.cli'
  );
}
```

### No API Tokens Stored

Dovetail 2.0 does NOT store API tokens. Each CLI handles its own authentication:
- `gh`: OAuth via `gh auth login`
- `linearis`: API key via `LINEAR_API_KEY` env var or `~/.linearisrc.json`
- `supabase`: OAuth via `supabase login`
- `flyctl`: OAuth via `flyctl auth login`

### Hook-Command Symmetry

Every hook behavior is available as a standalone command:

| Hook | Command | Purpose |
|------|---------|---------|
| user-prompt-submit | `dovetail check-issue --auto` | Ensure active issue |
| pre-tool-use | `dovetail validate` | Block if invalid state |
| post-tool-use | `dovetail auto-commit` | Commit after writes |

This enables:
- **Testing**: Run commands directly to test hook logic
- **Debugging**: See exactly what hooks do
- **Manual Use**: Use commands without Claude Code
- **CI/CD**: Use commands in pipelines

### Dual-Mode Commands

Commands support both interactive and automated modes:

**Interactive (human use):**
```bash
$ dovetail check-issue
? Select an issue:
❯ [PRJ-123] Build login form
  [PRJ-124] Add dashboard
  ──────────────────────
  + Create new issue
```

**Auto (hook use):**
```bash
$ dovetail check-issue --auto
⚠️  No active issue - searching Linear...
✓ Auto-selected issue: PRJ-123
```

**JSON (script use):**
```bash
$ dovetail check-issue --json
{
  "hasActiveIssue": false,
  "issues": [...],
  "action": "selected"
}
```

## Working with Generated Projects

Projects created by Dovetail have this structure:

```
project/
├── .claude/hooks/        # Claude Code hooks
├── .dovetail/
│   └── state.json        # Project state
├── apps/
│   ├── web/              # Vite + React
│   └── api/              # Express
├── migrations/           # Database migrations
├── tests/                # Playwright tests
└── fly.*.toml            # Fly.io configs
```

### Development workflow
```bash
npm run dev              # Start both web and api servers
npm run dev:web          # Start only frontend
npm run dev:api          # Start only backend
```

### Building
```bash
npm run build            # Build both apps
```

### Testing
```bash
npm test                 # Run Playwright tests
npm run test:api         # Run API tests
```

## Native CLIs Used

### Linearis (Linear CLI)
- **Purpose**: Linear issue management
- **Install**: `npm install -g linearis`
- **Auth**: `export LINEAR_API_KEY=<key>` or `~/.linearisrc.json`
- **Docs**: https://github.com/czottmann/linearis
- **Commands**: `linearis issue ls`, `linearis issue create`, `linearis issue update`

### GitHub CLI (gh)
- **Purpose**: Repository, PR, secrets management
- **Install**: `brew install gh` (macOS) or `winget install GitHub.cli` (Windows)
- **Auth**: `gh auth login`
- **Docs**: https://cli.github.com
- **Commands**: `gh repo create`, `gh pr create`, `gh secret set`

### Supabase CLI
- **Purpose**: Database and backend management
- **Install**: `brew install supabase/tap/supabase` (macOS)
- **Auth**: `supabase login`
- **Docs**: https://supabase.com/docs/guides/cli
- **Commands**: `supabase projects create`, `supabase projects api-keys`

### Fly.io CLI (flyctl)
- **Purpose**: Deployment
- **Install**: `curl -L https://fly.io/install.sh | sh`
- **Auth**: `flyctl auth login`
- **Docs**: https://fly.io/docs/flyctl/
- **Commands**: `flyctl apps create`, `flyctl deploy`

## Commit Message Convention

Dovetail enforces conventional commits:

- `feat(ISSUE-KEY): description` - New feature
- `fix(ISSUE-KEY): description` - Bug fix
- `chore(ISSUE-KEY): description` - Maintenance
- `docs(ISSUE-KEY): description` - Documentation
- `refactor(ISSUE-KEY): description` - Code refactoring

Example: `feat(PRJ-123): add login form component`

## Testing Strategy

**Unit Tests (CLI wrappers):**
```javascript
// test/cli/linearis.test.js
import { listIssues } from '../src/cli/linearis.js';
import { execa } from 'execa';

jest.mock('execa');

test('listIssues calls linearis with correct args', async () => {
  execa.mockResolvedValue({
    stdout: JSON.stringify([{ identifier: 'PRJ-1' }]),
    exitCode: 0
  });

  await listIssues('team-123', 'project-456');

  expect(execa).toHaveBeenCalledWith('linearis', [
    'issue', 'ls',
    '--team', 'team-123',
    '--project', 'project-456',
    '--json'
  ], expect.any(Object));
});
```

**Integration Tests (commands):**
```bash
# test/integration/check-issue.sh
#!/bin/bash
cd test-project
dovetail check-issue --auto
dovetail status | grep "Active issue"
```

## Key Files to Understand

1. **bin/dovetail.js** - CLI entry point, command registration
2. **src/commands/check-issue.js** - Core workflow enforcement (auto-select issues)
3. **src/commands/validate.js** - Pre-write validation
4. **src/commands/auto-commit.js** - Post-write automation
5. **src/cli/linearis.js** - Linearis CLI wrapper with error handling
6. **src/cli/gh.js** - GitHub CLI wrapper
7. **src/utils/state.js** - Project state management

## Dependencies (2.0)

**Core:**
- `commander` - CLI framework
- `inquirer` - Interactive prompts
- `execa` - Execute native CLIs
- `chalk` - Terminal colors
- `ora` - Spinners
- `listr2` - Task lists

**Utilities:**
- `simple-git` - Git operations
- `fs-extra` - File system operations
- `slugify` - URL-safe slugs
- `conventional-commits-parser` - Commit message parsing

**Removed in 2.0:**
- ❌ `@linear/sdk` - Replaced by linearis CLI
- ❌ `octokit` - Replaced by gh CLI
- ❌ `axios` - Replaced by supabase CLI
- ❌ `tweetnacl` - gh CLI handles secret encryption

## Node Version

Requires Node.js 18+ (see `package.json` engines field).

## Module System

Uses ES modules (`"type": "module"` in package.json). All imports must use `.js` extensions.
