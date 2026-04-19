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

6. **Templates:** `templates/` directory exists with key templates (FINDING, RECOMMENDATION, `SKILL_TEMPLATE.md`, etc.)

7. **Skill structure audit:** run `core/scripts/test/check-skill-structure.sh` and report:
   - Total skills scanned, pass / warn / fail counts
   - All hard failures (missing frontmatter, scope, or title) — these are blockers
   - First 5 soft warnings (missing Trigger, duplicated boilerplate) when pass rate is below 90%
   - If the script is missing, flag: "audit script not installed in this repo — copy from dev source at `core/scripts/test/check-skill-structure.sh`"

8. **Agent structure audit:** run `core/scripts/test/check-agent-structure.sh` and report:
   - Total agents scanned, pass / warn / fail counts
   - All hard failures (missing frontmatter, id/name or type, scope, or title) — blockers
   - First 5 soft warnings (missing Purpose/BLUF, missing When-to-use / Trigger) when pass rate is below 90%
   - If the script is missing, flag: "agent audit script not installed in this repo — copy from dev source at `core/scripts/test/check-agent-structure.sh`"

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 5

- Per required methodology file: 20/8 = 2.5 points each (20 total)
- SOP index: 20
- Skills presence: count/expected × 20
- Agents presence: count/expected × 20
- Templates: 20
- Skill structure audit: any hard failure → −20 from the Core Methodology score; warnings-only does not affect score
- Agent structure audit: any hard failure → −20 from the Core Methodology score; warnings-only does not affect score

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
| Agent structure audit | {pass}/{total} | {pass} | {ok / N warnings / N failures} |
| Skill structure audit | {pass}/{total} | {pass} | {ok / N warnings / N failures} |

Evidence: [OBSERVED: core directory check + check-skill-structure.sh, {date}]
```
