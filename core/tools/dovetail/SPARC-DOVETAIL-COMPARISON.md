---
scope: shared
---

# SPARC + Dovetail Integration Analysis

## Current State Comparison

| Aspect | Dovetail | SPARC |
|--------|----------|-------|
| **Core Focus** | Issue-driven workflow + Git automation | Development methodology + Quality gates |
| **Execution** | Hooks + CLI commands | Mega-prompt with Claude |
| **Integrations** | GitHub, Linear, Supabase, Fly.io | None (pure methodology) |
| **Phases** | None (linear workflow) | 6 phases (Research → Completion) |
| **Quality** | quality-gate.js, security-scan.js | Standards in prompt (≤500 lines, 100% coverage) |
| **TDD** | Not enforced | London School TDD built-in |
| **Research** | None | Web research phase |
| **Task Tracking** | Linear issues only | memory_bank + subtasks folder |

---

## What SPARC Is

**SPARC** stands for:
- **S** - Specification
- **P** - Pseudocode
- **A** - Architecture
- **R** - Refinement (TDD)
- **C** - Completion

It's a structured development methodology designed for AI-assisted development, specifically built around Claude's capabilities.

### The 6 Phases

| Phase | Purpose | Key Activities |
|-------|---------|----------------|
| **0. Research** | Gather context | Market research, competitor analysis, tech stack selection |
| **1. Specification** | Define what to build | Requirements, user stories, technical specs, constraints |
| **2. Pseudocode** | High-level design | System architecture, data flow, algorithm design, test strategy |
| **3. Architecture** | Detailed design | Component specs, database schema, API design, infrastructure |
| **4. Refinement** | Implementation | TDD (London School), parallel dev tracks, integration testing |
| **5. Completion** | Ship it | System integration, documentation, deployment, monitoring |

### Notable SPARC Features

1. **TDD London School Approach**: Red → Green → Refactor cycle with 100% coverage target
2. **Parallel Execution Support**: BatchTool and dispatch_agent for concurrent work
3. **Configurable Development Modes**: full, backend-only, frontend-only, api-only
4. **Commit Frequency Control**: phase, feature, or manual
5. **Research Depth Levels**: basic, standard, comprehensive
6. **Quality Standards Enforcement**: Files ≤500 lines, functions ≤50 lines, no hardcoded secrets

---

## What Dovetail Is

Dovetail 2.0 is an **AI-native development workflow system** that enforces issue-driven development by integrating GitHub, Linear, Supabase, and Fly.io.

### Key Features

1. **Native CLI Delegation**: Uses `gh`, `linearis`, `supabase`, `flyctl` directly
2. **Hook System**: Integrates with Claude Code lifecycle events
3. **Issue-Driven Development**: Every code change tied to a Linear issue
4. **Auto-Commit**: Conventional commits with issue references
5. **PR Automation**: Creates PRs and updates Linear automatically

---

## Features to Integrate from SPARC → Dovetail

### 1. Development Phases System

**Add structured phases to issues:**

```
PHASES:
0. Research     → Understand problem, gather context
1. Spec         → Define requirements, acceptance criteria
2. Design       → Pseudocode, architecture decisions
3. Implement    → TDD: Red → Green → Refactor
4. Complete     → Documentation, cleanup, PR
```

**Implementation:** Add `dovetail phase` command + track phase in state

| Pros | Cons |
|------|------|
| Forces thinking before coding | More overhead for small tasks |
| Better commit history (phase-based commits) | Might slow down simple fixes |
| Clearer progress tracking | Linear doesn't have native phase support |

---

### 2. Quality Standards Enforcement

**Add quality gates to `dovetail validate`:**

```javascript
// Standards from SPARC
- Files ≤ 500 lines
- Functions ≤ 50 lines
- No hardcoded secrets
- Test coverage target (configurable)
- No console.log in production code
```

**Implementation:** Enhance `quality-gate.js` with SPARC rules

| Pros | Cons |
|------|------|
| Consistent code quality | Can block legitimate large files |
| Catches issues before PR | Rigid rules don't fit all projects |
| Teachable standards | May slow development |

---

### 3. TDD Enforcement

**Add TDD mode to dovetail:**

```bash
dovetail start PRJ-123 --tdd    # Enables TDD enforcement
```

When enabled:
- `pre-tool-use` checks for test file changes
- Warns if implementation changes without test changes
- Tracks Red → Green → Refactor cycle

| Pros | Cons |
|------|------|
| Better test coverage | Slows initial development |
| Fewer bugs | Not all tasks need TDD |
| Self-documenting tests | Claude sometimes struggles with TDD discipline |

---

### 4. Research Phase Integration

**Add research command:**

```bash
dovetail research              # Interactive research mode
dovetail research --auto       # AI-driven research
```

Outputs to `.dovetail/research/{issue-key}.md`

| Pros | Cons |
|------|------|
| Better informed decisions | Web search costs (API calls) |
| Documented research | Can delay starting work |
| Avoids reinventing wheels | Research can be a rabbit hole |

---

### 5. Memory Bank / Context System

**Add project memory:**

```
.dovetail/
├── state.json
├── memory/
│   ├── architecture.md      # Project architecture notes
│   ├── decisions.md         # ADRs (Architecture Decision Records)
│   ├── patterns.md          # Code patterns used
│   └── issues/
│       └── PRJ-123.md       # Per-issue context
```

| Pros | Cons |
|------|------|
| Persistent context across sessions | More files to maintain |
| Better AI understanding | Can become stale |
| Knowledge doesn't get lost | Overhead for small projects |

---

### 6. Parallel Execution Support

**Add parallel task support:**

```bash
dovetail start PRJ-123 PRJ-124 --parallel
```

Track multiple active issues, auto-switch branches

| Pros | Cons |
|------|------|
| Work on multiple features | Complexity explosion |
| Better utilization | Merge conflicts |
| Handle blocked tasks | Context switching cost |

---

### 7. Commit Frequency Control

**Add commit frequency option:**

```bash
dovetail config set commit-freq phase   # After each phase
dovetail config set commit-freq feature # After each feature (current)
dovetail config set commit-freq manual  # No auto-commits
```

| Pros | Cons |
|------|------|
| User control over commit granularity | More config complexity |
| Cleaner history option | Risk of losing work (manual mode) |
| Flexibility | Inconsistent across team |

---

## Integration Priority Matrix

| Priority | Feature | Effort | Value |
|----------|---------|--------|-------|
| **P0** | Quality standards enforcement | Medium | High |
| **P1** | Memory bank / context system | Low | High |
| **P1** | Commit frequency control | Low | Medium |
| **P2** | Development phases | Medium | Medium |
| **P2** | TDD mode (optional) | Medium | Medium |
| **P3** | Research phase | High | Medium |
| **P3** | Parallel execution | High | Low |

---

## Overall Pros/Cons Summary

### Pros of Integration

1. **Better code quality** - Enforced standards
2. **Structured thinking** - Phases prevent cowboy coding
3. **Persistent context** - Memory bank helps AI
4. **Flexibility** - Commit frequency, TDD optional
5. **Best of both worlds** - Workflow + Methodology

### Cons of Integration

1. **Increased complexity** - More config, more commands
2. **Slower for simple tasks** - Overhead
3. **Steeper learning curve** - More concepts
4. **Maintenance burden** - More code to maintain
5. **Rigidity** - Some rules won't fit all projects

---

## Recommendation

### Start with P0 + P1 features:

1. **Quality standards** in `dovetail validate` (quick win)
2. **Memory bank** system (high value, low effort)
3. **Commit frequency config** (user preference)

### Skip for now:

- Full phase system (too heavy)
- Research phase (complex, questionable value)
- Parallel execution (complexity explosion)

### Make optional:

- TDD mode (`--tdd` flag) rather than mandatory

---

## References

- SPARC implementation: `plastic-card-designer/claude-sparc.sh`
- SPARC config: `plastic-card-designer/coordination/SPARC_CONFIG.md`
- Dovetail architecture: `dovetail/docs/ARCHITECTURE.md`
- Dovetail hooks: `dovetail/.claude-hooks/`
