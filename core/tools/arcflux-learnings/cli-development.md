---
scope: shared
---

# ArcFlux CLI Development Practices

> **Last Updated**: 2025-01-09
> **Review Frequency**: Monthly or when major dependency updates occur

This document captures best practices **for developing the ArcFlux CLI tool itself** (Node.js/JavaScript).

For project-specific technology stacks (Drupal, TypeScript, Docker), see `stacks/` directory.

---

## Node.js (v18+)

### ES Modules
- Use `"type": "module"` in package.json
- Use `.js` extension for imports (not `.mjs`)
- Use `import`/`export`, not `require`/`module.exports`

```javascript
// Good
import { readFileSync } from 'fs';
import chalk from 'chalk';

// Avoid
const fs = require('fs');
```

### Path Handling
```javascript
// For __dirname equivalent in ES modules
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
```

### Async/Await
- Prefer `async/await` over `.then()` chains
- Use `Promise.all()` for parallel operations
- Always handle errors with try/catch

```javascript
// Good
try {
  const [a, b] = await Promise.all([fetchA(), fetchB()]);
} catch (error) {
  // Handle error
}

// Avoid
fetchA().then(a => fetchB().then(b => ...))
```

---

## CLI Development

### Commander.js (v11+)
- Use `.action(async () => {})` for async handlers
- Use dynamic imports for commands (lazy loading)
- Define options before action

```javascript
program
  .command('status')
  .description('Show status')
  .option('--json', 'JSON output')
  .action(async (options) => {
    const { status } = await import('./commands/status.js');
    await status(options);
  });
```

### Exit Codes
- `0` = Success
- `1` = General error
- `2` = Workflow blocked (special for hooks)

```javascript
// For hook integration
if (blocked) {
  console.error('Blocked: reason');
  process.exit(2);
}
```

### CLI Execution with Execa (v8+)
```javascript
import { execa } from 'execa';

// Prefer object options
const { stdout, stderr, exitCode } = await execa('git', ['status'], {
  reject: false,  // Don't throw on non-zero exit
  cwd: projectRoot
});

// Check exit code manually
if (exitCode !== 0) {
  throw new Error(`Command failed: ${stderr}`);
}
```

---

## File System

### fs-extra (v11+)
- Use for complex operations (copy, move, ensure)
- Native `fs/promises` for simple read/write

```javascript
// Simple operations - use native
import { readFileSync, writeFileSync } from 'fs';

// Complex operations - use fs-extra
import { ensureDir, copy, remove } from 'fs-extra';
```

### JSON Files
```javascript
// Reading
const data = JSON.parse(readFileSync(path, 'utf8'));

// Writing (pretty print)
writeFileSync(path, JSON.stringify(data, null, 2));
```

---

## Git Operations

### simple-git (v3+)
```javascript
import simpleGit from 'simple-git';

const git = simpleGit(projectRoot);

// Common operations
const status = await git.status();
const branch = await git.branch();
const log = await git.log({ maxCount: 5 });

// Safe checkout
await git.checkout(['-b', branchName]);
```

### Branch Naming
```
feat/{issue-key}-{slug}     # Features
fix/{issue-key}-{slug}      # Bug fixes
chore/{issue-key}-{slug}    # Maintenance
```

### Commit Messages (Conventional)
```
{type}({scope}): {description}

Types: feat, fix, docs, refactor, test, chore
Scope: issue key (AF-007)

Example: feat(AF-007): add start command with dependency checking
```

---

## Logging & Output

### Chalk (v5+)
```javascript
import chalk from 'chalk';

// Semantic colors
chalk.green('✓')   // Success
chalk.yellow('⚠')  // Warning
chalk.red('✗')     // Error
chalk.blue('ℹ')    // Info
chalk.gray('...')  // Secondary

// Styling
chalk.bold('Important')
chalk.dim('Less important')
chalk.underline('Link')
```

### Progress Indicators
```javascript
import ora from 'ora';

const spinner = ora('Loading...').start();
// ... do work
spinner.succeed('Done');  // or .fail('Error')
```

---

## Testing

### Vitest (v2+)
```javascript
// vitest.config.js
export default {
  test: {
    globals: true,
    environment: 'node',
  }
};

// Test file
import { describe, it, expect, vi } from 'vitest';

describe('myFunction', () => {
  it('should work', () => {
    expect(myFunction()).toBe(expected);
  });
});
```

### Mocking
```javascript
// Mock modules
vi.mock('execa', () => ({
  execa: vi.fn()
}));

// Mock implementations
vi.mocked(execa).mockResolvedValue({ stdout: 'output', exitCode: 0 });
```

---

## Error Handling

### User-Facing Errors
```javascript
// Good - helpful message
throw new Error('GitHub CLI not authenticated.\nRun: gh auth login');

// Avoid - cryptic message
throw new Error('EAUTH');
```

### CLI Error Detection
```javascript
// Common patterns to detect
if (stderr.includes('not logged in')) {
  log.error('Not authenticated. Run: gh auth login');
}

if (error.code === 'ENOENT') {
  log.error('CLI not found. Install with: brew install gh');
}
```

---

## Security

### Never Commit
- `.env` files
- API keys/tokens
- Credentials

### Secret Storage
```
~/.arcflux/credentials.json  # Global credentials (gitignored)
Environment variables        # Runtime secrets
```

### Input Validation
- Always validate user input before shell execution
- Use parameterized commands, not string concatenation

```javascript
// Good - parameterized
await execa('git', ['checkout', branchName]);

// Bad - string concat (injection risk)
await execa('sh', ['-c', `git checkout ${branchName}`]);
```

---

## Performance

### Lazy Loading
```javascript
// Load commands only when needed
.action(async () => {
  const { command } = await import('./commands/command.js');
  await command();
});
```

### Parallel Operations
```javascript
// Good - parallel
const [gitStatus, config] = await Promise.all([
  git.status(),
  loadConfig()
]);

// Avoid - sequential when not needed
const gitStatus = await git.status();
const config = await loadConfig();
```

---

## Code Style

### File Organization
- One export per file for commands
- Related utilities grouped in utils/
- Max 500 lines per file (SPARC guideline)

### Function Size
- Max 50 lines per function (SPARC guideline)
- Extract helpers for complex logic

### Naming
```javascript
// Commands: verb or noun
export async function status() {}
export async function start() {}

// Utilities: descriptive
export function loadConfig() {}
export function parseIssueKey() {}

// Constants: UPPER_SNAKE
const DEFAULT_TIMEOUT = 5000;
```

---

## Updates & Review

### When to Update This Document
- New major dependency version
- New pattern discovered
- Bug caused by outdated practice
- Monthly review

### How to Update
1. Document the change
2. Update "Last Updated" date
3. Add decision to architecture.md if significant
