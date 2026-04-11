---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
argument-hint: "file_path — Path to the file to review"
---

# Skill: Independent Review (`/review`)

## Purpose

> **File versioning:** When generating .md output files, include version + date.

Spawns the report-reviewer agent in an ISOLATED context to review a deliverable, analysis, or any output file. The reviewer has NO access to the reasoning that produced the content — this prevents self-review bias.

> **Why isolation matters:** "A model that retains reasoning context from generation is less likely to question its own decisions." — Claude Architect best practice. Independent review instances catch issues that self-review misses.

## Trigger

Use when: user says `/review`, "review this", "check this deliverable", "quality check", or after any deliverable is finalized.

## Input

| Input | Required | Default |
|---|---|---|
| `file_path` | Yes | Path to the file to review |
| `--client` | No | Auto-detect from file path |
| `--strict` | No | `false` — if true, BLOCK on any WARNING-level finding |

## Execution Steps

### Step 1: Load the file
Read the file at the given path. Extract:
- Type (from header or ontology block)
- Client (from ontology block or path)
- Recipient (from `For:` header)

### Step 2: Load review context
- Read the client's `PROJECT_GLOSSARY.md` (if exists) — banned terms
- Read the client's `CONTACTS.md` — name validation
- Read `core/methodology/LINKEDIN_CONTENT_RULES.md` (if public content)
- Read `core/methodology/DATA_RELIABILITY_FRAMEWORK.md` (if analysis/report)

### Step 3: Spawn report-reviewer agent
Pass the file content + review context to the report-reviewer agent.
The agent runs in forked context — it does NOT see the conversation that produced the file.

### Step 4: Return verdict

## Output Format

```
REVIEW: {file_path}
═══════════════════════════════════════

VERDICT: APPROVED / NEEDS REVISION / BLOCKED

FINDINGS:
1. [severity] {finding} — {recommendation}
2. [severity] {finding} — {recommendation}

CHECKS:
☑ PII scan — clean / ☒ PII found: {details}
☑ Glossary — clean / ☒ Banned terms: {list}
☑ Data reliability — present / ☒ Missing framework
☑ Evidence tags — present / ☒ Missing tags
☑ Ontology block — present / ☒ Missing block
☑ Version header — present / ☒ Missing version

CONFIDENCE: [X%] | MOST UNCERTAIN: [one claim] | WOULD CHANGE IF: [one condition]

═══════════════════════════════════════
```

## Verdict Rules

- **APPROVED:** No CRITICAL findings. May have INFO-level notes.
- **NEEDS REVISION:** 1+ WARNING findings. List what to fix.
- **BLOCKED:** 1+ CRITICAL findings (PII detected, missing data reliability on analysis, banned terms in public content). MUST fix before sending.

## Notes

- This skill runs in `context: fork` — it won't pollute the main conversation.
- The report-reviewer agent has NO memory of how the content was generated. This is a feature, not a bug.
- For LinkedIn/public content, also check LINKEDIN_CONTENT_RULES.md compliance.
- After review, save the verdict as a comment in the file's ontology block: `review: APPROVED v1.0 2026-04-10`
