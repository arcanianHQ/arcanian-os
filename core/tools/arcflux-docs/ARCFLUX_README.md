---
scope: shared
---

# ArcFlux

AI-native development workflow with structured methodology.

## What is ArcFlux?

ArcFlux combines **issue-driven development** with **structured methodology** (inspired by SPARC) to create a complete AI-assisted development environment.

## Core Concepts

### 1. Issue-Driven Development
Every code change is tied to a tracked issue (Linear, GitHub Issues).

### 2. Development Phases
Structured phases for each task:
- **Research** - Understand the problem
- **Spec** - Define requirements
- **Design** - Architecture decisions
- **Implement** - TDD: Red → Green → Refactor
- **Complete** - Documentation, PR, deploy

### 3. Quality Gates
Enforced standards:
- File size limits
- Function complexity
- Test coverage targets
- Security scanning

### 4. Memory Bank
Persistent project context:
- Architecture decisions
- Code patterns
- Issue-specific context

## Installation

### Prerequisites

```bash
# Required: Node.js 18+, Git, jq
brew install node git jq   # macOS
# or: apt install nodejs git jq  # Ubuntu/Debian
```

### Install ArcFlux

```bash
npm install -g arcflux
# or
npx arcflux
```

## Quick Start

```bash
# Initialize new project
arcflux init "My Project"

# Adopt existing project
cd my-project && arcflux adopt

# Start work on an issue
arcflux start PROJ-123

# Check status
arcflux status
```

## Commands

| Command | Description |
|---------|-------------|
| `init` | Create new project with full stack |
| `adopt` | Link existing project to ArcFlux |
| `start` | Start work on an issue |
| `status` | Show current project state |
| `phase` | Move to next development phase |
| `validate` | Check workflow state |
| `commit` | Auto-commit with conventional message |
| `ready` | Run quality gates before merge |
| `sync` | Sync with main branch |
| `doctor` | Run diagnostics |

## Claude Code Integration

ArcFlux integrates with Claude Code via hooks:

```bash
arcflux update-hooks  # Install/update Claude Code hooks
```

## Configuration

Project config stored in `.arcflux/config.json`:

```json
{
  "phases": ["research", "spec", "design", "implement", "complete"],
  "quality": {
    "maxFileLines": 500,
    "maxFunctionLines": 50,
    "testCoverage": 80
  },
  "commitFrequency": "phase",
  "tdd": false
}
```

## License

MIT
