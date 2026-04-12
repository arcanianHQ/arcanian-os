---
scope: shared
---

> v1.0 — 2026-04-12
> Scoring rubrics for health-check agents.

# Health Check Scoring Rubrics

## Status Thresholds

| Score | Status | Meaning |
|---|---|---|
| ≥90 | Healthy | No action needed |
| 70-89 | Needs attention | Should fix soon |
| <70 | Critical | Fix now |

---

## 1. Project Integrity (health-project-checker)

**Per-project score (0-100), then average across all projects:**

| Check | Points | Criteria |
|---|---|---|
| CLAUDE.md exists + <80 lines | 15 | Exists = 10, under 80 lines = 5 |
| TASKS.md with frontmatter | 15 | Exists = 10, has YAML frontmatter + priority sections = 5 |
| CAPTAINS_LOG.md with entries | 10 | Exists = 5, has dated entry = 5 |
| CONTACTS.md exists | 10 | Exists = 10 |
| brand/ directory (7 files) | 15 | Per file: +2 (max 14), directory exists = 1 |
| skills/ symlink resolves | 10 | Resolves correctly = 10 |
| sops/ symlink resolves | 10 | Resolves correctly = 10 |
| .gitignore blocks .env | 5 | Exists + blocks .env = 5 |
| DOMAIN_CHANNEL_MAP (if multi-domain) | 10 | Present if needed = 10, missing when needed = 0 (CRITICAL) |

---

## 2. MCP Connections (health-mcp-checker)

**Score = (connected / configured) × 100**

| Status | Points per server |
|---|---|
| Connected + responds | Full points |
| Configured but auth error | 0 (flag as CRITICAL) |
| Configured but timeout | 0 (flag as WARNING) |
| Not configured | Not counted |

**Bonus:** Databox connected = +10 (mandatory for data analysis)
**Penalty:** Databox not connected = CRITICAL flag regardless of score

---

## 3. Git Status (health-git-checker)

| Check | Points | Criteria |
|---|---|---|
| All repos clean (no uncommitted) | 40 | Each dirty repo: -10 |
| All repos pushed (no local-only commits) | 30 | Each unpushed: -10 |
| No merge conflicts | 20 | Any conflict: -20 |
| Submodule refs current | 10 | Each stale submodule: -5 |

---

## 4. Hooks (health-hooks-checker)

**Per-project score, then average:**

| Check | Points | Criteria |
|---|---|---|
| settings.json exists | 30 | Exists = 30 |
| Pre-tool-use hooks configured | 25 | At least 1 hook = 25 |
| Post-tool-use hooks configured | 25 | At least 1 hook = 25 |
| User-prompt-submit hook | 20 | Configured = 20 |

---

## 5. Core Methodology (health-core-checker)

| Check | Points | Criteria |
|---|---|---|
| TASK_SYSTEM_RULES.md exists | 20 | Exists = 20 |
| KNOWN_PATTERNS.md exists | 20 | Exists = 20 |
| PROJECT_REGISTRY.md exists | 20 | Exists = 20 |
| SOP_INDEX.md exists | 20 | Exists = 20 |
| Expected skills present | 20 | Count / expected × 20 |

---

## 6. Warning Intelligence (health-warning-intel)

This agent doesn't produce a numeric score. Instead it produces:
- **Convergent signals:** same issue across 2+ clients → systemic gap
- **Weak signal clusters:** minor issues that together predict a bigger problem
- **Blind spots:** areas no project covers
- **Contradictions:** conflicting data across sources

Severity flags: CRITICAL (convergent signal affecting 3+ clients), WARNING (2 clients), INFO (weak signal)

---

## Aggregation

```
overall = (
  project_integrity × 0.25 +
  mcp_connections × 0.20 +
  git_status × 0.15 +
  hooks × 0.10 +
  core_methodology × 0.15 +
  warning_intel_severity × 0.15
)
```

Warning intel severity scoring:
- No issues: 100
- INFO only: 90
- WARNING flags: 70
- CRITICAL flags: 40

## References
- `core/methodology/CONFIDENCE_ENGINE.md`
- `core/methodology/CONTACT_REGISTRY_STANDARD.md`
- `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`
