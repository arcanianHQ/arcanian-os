---
id: health-core-checker
name: "Core Methodology Checker"
focus: "Core files — methodology rules, SOPs, skills, templates completeness"
context: [infrastructure]
data: [filesystem]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.15
---

# Agent: Core Methodology Checker

## Purpose

Verifies that core methodology files, SOPs, skills, and templates are present and intact. Catches accidental deletions or drift in the protected core.

## Process

1. **Required methodology files:**
   - `methodology/TASK_SYSTEM_RULES.md`
   - `methodology/KNOWN_PATTERNS.md`
   - `methodology/PROJECT_REGISTRY.md`
   - `methodology/CONFIDENCE_ENGINE.md`
   - `methodology/EVIDENCE_CLASSIFICATION_RULE.md`
   - `methodology/DATABOX_MANDATORY_RULE.md`
   - `methodology/PAGE_ANALYSIS_SCORING.md`
   - `methodology/HEALTH_CHECK_SCORING.md`

2. **SOP index:** `sops/SOP_INDEX.md` exists

3. **Skills count:** count files in `skills/` — compare to expected (currently 47 with analyze-page)

4. **Agents count:** count files in `agents/` — compare to expected (currently 19 with page-* agents)

5. **Council configs:** count files in `agents/councils/` — compare to expected (currently 5)

6. **Templates:** `templates/` directory exists with key templates (FINDING, RECOMMENDATION, etc.)

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 5

- Per required methodology file: 20/8 = 2.5 points each (20 total)
- SOP index: 20
- Skills presence: count/expected × 20
- Agents presence: count/expected × 20
- Templates: 20

## Output

```markdown
### Core Methodology [Score: {0-100}/100]

| Category | Expected | Found | Status |
|---|---|---|---|
| Methodology rules | {N} | {N} | {ok/missing: list} |
| SOPs | index present | {yes/no} | {status} |
| Skills | {expected} | {found} | {ok/missing N} |
| Agents | {expected} | {found} | {ok/missing N} |
| Council configs | {expected} | {found} | {ok/missing N} |
| Templates | present | {yes/no} | {status} |

Evidence: [OBSERVED: core directory check, {date}]
```
