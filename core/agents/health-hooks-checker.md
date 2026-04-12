---
id: health-hooks-checker
name: "Hooks Configuration Checker"
focus: "Claude Code hooks — settings.json, pre/post tool-use, prompt-submit hooks"
context: [infrastructure]
data: [filesystem]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.10
---

# Agent: Hooks Configuration Checker

## Purpose

Verifies that Claude Code hooks are properly configured for each project. Hooks enforce guardrails (directory guard, PII scanner, auto-logging, ontology check). Missing hooks mean guardrails are disabled.

## Process

For each project:

1. Check `.claude/settings.json` exists
2. If exists, check for hook configurations:
   - **pre-tool-use hooks:** directory guard, assumption guard
   - **post-tool-use hooks:** auto-log, registry update, changelog, task format, ontology check
   - **user-prompt-submit hooks:** PII/secrets warning
3. Score based on hook coverage

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 4

- settings.json exists: 30
- Pre-tool-use hooks: 25
- Post-tool-use hooks: 25
- User-prompt-submit hooks: 20

## Output

```markdown
### Hooks [Score: {0-100}/100]

| Project | settings.json | Pre-tool | Post-tool | Prompt-submit |
|---|---|---|---|---|
| {slug} | {yes/no} | {N hooks} | {N hooks} | {yes/no} |

Evidence: [OBSERVED: settings.json check, {date}]
```
