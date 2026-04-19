---
# ─── Schema A (system agents — the common case) ───
id: agent-slug                           # kebab-case, matches the filename
name: Human-Readable Name                # the name the router shows
focus: "One-line description of what the agent diagnoses or produces"
context: [culture, brand, audience]      # optional: which client context categories the agent reads
data: [analytics, google_ads, meta_ads]  # optional: which data sources the agent touches
active: true                             # true = the agent is wired up and usable
confidence_scoring: true                 # optional: does it emit confidence scores per finding
recommendation_log: true                 # optional: does it auto-log RECs to RECOMMENDATION_LOG.md
scope: shared                            # shared | int-company | int-confidential | int-personal
category: diagnostic                     # optional taxonomy: diagnostic | infrastructure | delivery | etc
weight: 0.15                             # optional: council weight if used in a council YAML
---

# Agent: Human-Readable Name

## Purpose

One or two sentences. What the agent diagnoses/produces, what lens it applies, and
how its output connects to the larger pipeline (7-layer, council, measurement audit, etc).
Write it so the router can decide whether to invoke this agent based on the Purpose alone.

## When to Use

- A concrete trigger or phase (e.g. "During /7layer diagnostic — L4-L7 deep dive")
- Another concrete situation (e.g. "When performance metrics are declining but internal factors seem healthy")
- As a council member (e.g. "Diagnostic council — provides the outside-in perspective")

## Input

- Client project path (or specific artifact the agent reads)
- Any required preconditions (e.g. "DOMAIN_CHANNEL_MAP.md must exist for multi-domain clients")
- The question/scope the invoker passes in

## Process

1. Step one — what the agent loads or pulls
2. Step two — the analytical transformation it performs
3. Step three — the output it emits (format, where it goes)

## Output

- Format (markdown block, stage-result, scored table, etc.)
- Required sections the invoker will rely on
- How the output hands off to the next step (council synthesis, repair planning, etc.)

---

<!--
Authoring notes (remove before committing):

Hard requirements (enforced by the pre-commit hook):
  - YAML frontmatter
  - `scope:` field in frontmatter
  - Either (`id:` AND `name:`) OR `type:` for identification
  - A `# ` top-level title

Soft requirements (warnings only, surfaced in audit):
  - `## Purpose` OR `**BLUF:**` (or `purpose:` in frontmatter for managed agents)
  - `## When to Use` / `## Trigger` section

Schema B (managed agents — e.g. housekeeper, lock-auditor):
  ---
  scope: int-company
  type: agent — slug
  model: sonnet
  tools: [Read, Grep, Glob, Bash, Edit]
  purpose: One-line purpose here (frontmatter, not ## section)
  frequency: triggered by /skill or scheduled
  ---
Use Schema A for analytic / council agents; Schema B for semi-autonomous
background agents (merging contributions, auditing locks, etc.).

Audit script: core/scripts/test/check-agent-structure.sh
Rule references:
  - core/methodology/PUBLIC_CONTENT_GUARDRAIL.md — if scope: shared, no proprietary names
  - core/methodology/MODEL_ROUTING.md — set model tier explicitly when spawning
-->
