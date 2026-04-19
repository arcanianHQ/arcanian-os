---
scope: shared                              # shared | int-company | int-confidential | int-personal
argument-hint: "arg — short description"   # optional: hints what the user types after the slash command
allowed-tools:                             # optional: restrict tools available inside the skill
  - Read
  - Grep
  - Glob
# context: fork                            # optional: spawn in an isolated context (for reviewer-style skills)
---

# Skill: Human-Readable Name (`/skill-slug`)

## Purpose

One or two sentences. What it does, what it outputs, who it's for. Write it so the
router can decide whether to invoke this skill based on the Purpose alone.

## Trigger

Use this skill when:
- Concrete situation / user phrase that routes here
- Another concrete situation
- Exact slash invocation: `/skill-slug`

## Skip when

(Optional but recommended for skills that overlap with peers — prevents mis-routing.)
- The task is actually X (use `/other-skill` instead)
- The task is actually Y (use `/another-skill` instead)

## Input

| Input | Required | Default |
|---|---|---|
| `arg1` | Yes | — |
| `--flag` | No | auto-detect |

## Process

1. Step one — what to load, what to check
2. Step two — the core transformation or analysis
3. Step three — how to format output, where to save

## Output

- Output file location / naming convention (if any)
- Output sections the reader should expect

---

<!--
Authoring notes (remove before committing):

Hard requirements (enforced by the pre-commit hook):
  - YAML frontmatter
  - `scope:` field in frontmatter
  - A `# ` top-level title

Soft requirements (warnings only, surfaced in audit):
  - `## Purpose` OR `**BLUF:**` line near the top
  - `## Trigger` section (or `## When to Use`, `## When to invoke`, `## Mikor használd`)

Do NOT add a "File versioning" blockquote — that rule is enforced via the
path-scoped `.claude/rules/deliverable-save.md` rule. Adding it inline is
redundant and is flagged by the audit.

Audit script: core/scripts/test/check-skill-structure.sh
Rule references:
  - core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md — output posture
  - core/methodology/EVIDENCE_CLASSIFICATION_RULE.md — evidence tags for data skills
  - core/methodology/MODEL_ROUTING.md — which model tier to run in
-->
