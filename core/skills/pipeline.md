---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Agent
argument-hint: "type --client — Pipeline type and client (e.g., diagnostic --client wellis)"
---

# Skill: Diagnostic Pipeline (`/pipeline`)

## Purpose

Auto-chains diagnostic skills in sequence, passing structured data between stages. Human intervenes only at gates (ACH falsification, unverified assumptions).

**Without pipeline:** You run /7layer, read the output, manually invoke /identify-constraints, copy findings, manually invoke /repair-roadmap.

**With pipeline:** One command runs all three, passing stage-result blocks between them, stopping at gates for your decision.

## Trigger

- `/pipeline diagnostic --client {slug}` — full diagnostic chain
- `/pipeline measurement --client {slug}` — measurement-focused chain
- `/pipeline discovery --client {slug}` — new client chain

## Pipelines Available

### `diagnostic` — Full 7-Layer Diagnosis → Constraints → Repair

```
Stage 1: /7layer Mode 2 (Pattern Map)
    │ produces: broken_layers, primary_constraint, findings
    │ output: stage-result block
    ▼
Stage 2: /council diagnostic (optional, if --council flag)
    │ produces: multi-agent perspectives, Grabo, ACH
    │ output: stage-result block
    ▼
  ┌─── GATE: ACH Falsification Check ───┐
  │ "The leading hypothesis is H1.       │
  │  Falsification: if [X], H1 is wrong. │
  │  Should we verify [X] before         │
  │  proceeding to constraints?"          │
  │                                       │
  │  [continue] [verify first] [stop]     │
  └───────────────────────────────────────┘
    ▼
Stage 3: /identify-constraints
    │ receives: broken_layers, findings from Stage 1/2
    │ produces: constraint_map, ach, ceiling
    │ output: stage-result block
    ▼
  ┌─── GATE: Unverified Assumptions ─────┐
  │ "Found N unverified constraints.      │
  │  These CANNOT be rated Hard or        │
  │  BLOCKS ALL until verified."          │
  │                                       │
  │  [continue anyway] [verify] [stop]    │
  └───────────────────────────────────────┘
    ▼
Stage 4: /repair-roadmap
    │ receives: constraint_map, ach, ceiling from Stage 3
    │ produces: repair_cards, timeline, milestones
    │ output: stage-result block + BLUF+OODA summary
    ▼
Stage 5: Auto-save + Open in Typora
```

### `measurement` — Audit → Analysis → Recommendations

```
Stage 1: /council measurement --client {slug}
    │ audit-checker + channel-analyst + data-rules + knowledge-extractor
    ▼
Stage 2: Measurement findings summary with Grabo cross-signals
    ▼
Stage 3: Auto-save + Open in Typora
```

### `discovery` — Explore → Scaffold → Profile

> **Enrichment gate:** Before proceeding past Stage 1, verify enrichment level per `core/methodology/ENRICHMENT_WATERFALL.md`. Discovery-stage enrichment (website scan, tracking inventory, social presence) must be complete before scheduling a call or sending materials.

```
Stage 0: Enrichment Gate Check
    │ Load ENRICHMENT_WATERFALL.md
    │ Verify: Is this a lead (internal/leads/) or new client?
    │ If lead: check current enrichment stage, flag gaps
    ▼
Stage 1: /council discovery --client {slug}
    │ client-explorer + project-architect
    ▼
Stage 2: Auto-create brand/ stub files if missing
    ▼
Stage 3: Auto-save Digital Profile + Open in Typora
```

## Input

| Input | Required | Example | Default |
|---|---|---|---|
| `pipeline_type` | Yes | `diagnostic`, `measurement`, `discovery` | — |
| `--client` | Yes | `diego`, `wellis` | Detect from cwd |
| `--council` | No | flag | `false` (skip council stage, just chain skills) |
| `--peer-review` | No | flag | `false` (passed to council if --council is set) |
| `--question` | No | `"Why is growth stalling?"` | Auto-generated from client context |
| `--skip-gates` | No | flag | `false` (DANGER: skips human checkpoints) |

## Process

### Step 1: Load Pipeline Definition

Based on `pipeline_type`, determine the stage sequence. Load client context (same as council runner Step 2-3).

### Step 2: Execute Stages Sequentially

For each stage in the pipeline:

1. **Check if prior stage produced a `stage-result` block**
   - If yes: parse YAML, pass structured data to current stage
   - If no: pass full prose output as context (backward compatible)

   **Stage-Result Validation:**
   After each stage produces its `stage-result` block, verify required fields:

   | Stage | Required Fields |
   |---|---|
   | /7layer | `broken_layers`, `primary_constraint`, `findings` |
   | /council | `perspectives`, `grabo_signals`, `ach_table` |
   | /identify-constraints | `constraint_map`, `ceiling`, `ach` |
   | /repair-roadmap | `repair_cards`, `timeline`, `milestones` |

   If required fields are missing:
   1. Log: "Stage {N} output incomplete. Missing: {fields}"
   2. Ask user: "Stage output is incomplete. Re-run stage, skip, or proceed with partial data? [rerun/skip/proceed]"
   3. If rerun → execute the same stage again with the prior stage's context
   4. If skip → mark stage as `incomplete` in final document
   5. If proceed → continue but flag missing data in the BLUF

2. **Run the skill/council for this stage**
   - Skill reads prior stage-result block for structured input
   - Skill produces its own output + stage-result block

3. **Check for gates**
   - If a gate is defined at this point, STOP and present to user
   - Wait for user decision: [continue] / [verify first] / [stop]
   - If user says "verify first" → pause pipeline, user does verification, then resume
   - If user says "stop" → save what we have so far, exit

4. **Collect output**
   - Append stage output to the growing document
   - Store stage-result for next stage

### Step 3: Compile Final Document

After all stages complete (or at a gate stop):

```markdown
# Diagnostic Pipeline: {client} — {question}

> v1.0 — {date}
> Type: Pipeline Diagnostic | Stages: {list of completed stages}
> Client: {slug} | Council: {yes/no} | Peer Review: {yes/no}
> Gates stopped at: {gate name, if any}

---

## BLUF
[From the final stage's BLUF, or synthesized from all stages]

---

## Stage 1: 7-Layer Diagnosis
[Full output from /7layer]

---

## Stage 2: Council Deliberation (if --council)
[Full output from /council]

--- GATE: ACH Falsification ---
[User decision recorded here]

---

## Stage 3: Constraint Map
[Full output from /identify-constraints]

--- GATE: Unverified Assumptions ---
[User decision recorded here]

---

## Stage 4: Repair Roadmap
[Full output from /repair-roadmap]

---

## Pipeline Stage Results (machine-readable)

```stage-result
stage_id: pipeline
pipeline_type: diagnostic
success: true
client: {slug}
stages_completed: [7layer, council, constraints, repair]
gates_passed: [ach_falsification, unverified_assumptions]
primary_constraint: L{X}
repair_sequence: [L{X}, L{Y}, L{Z}]
confidence: {%}
date: {YYYY-MM-DD}
```

---

## Ontology
- Client: {slug}
- Layer: {all layers touched}
- Pipeline: diagnostic
- Stages: {list}
```

### Step 4: Auto-Save + Open

Save to `clients/{slug}/docs/{CLIENT}_PIPELINE_{TYPE}_{DATE}.md`
Open in Typora.

## Gate Behavior

Gates are the human-in-the-loop checkpoints. They exist because:

1. **ACH Falsification Gate:** The leading hypothesis might be wrong. If verification is cheap (e.g., "pull Magento data, 2 hours"), it's worth pausing to check before building a repair plan on a potentially false premise.

2. **Unverified Assumptions Gate:** Constraints based on absence of information ("not mentioned" ≠ "doesn't exist") should not drive the repair roadmap without client verification.

**Default:** Gates are ON. User sees the question, decides to continue or pause.
**Override:** `--skip-gates` bypasses all gates (use only when re-running a pipeline with already-verified data).

When a gate fires:
```
═══════════════════════════════════════
GATE: ACH Falsification Check

Leading hypothesis: H1 — "L0 belief-driven promotional self-destruction"
Falsification: "If >60% of coupon users are first-time buyers,
coupons are incremental, not cannibalistic."

Verification cost: 4 hours (Shopify cohort export)

Options:
  1. Continue → build repair roadmap assuming H1 is correct
  2. Verify first → pause pipeline, verify, then resume
  3. Stop → save progress, exit pipeline

Your choice: [1/2/3]
═══════════════════════════════════════
```

## Examples

```bash
# Full diagnostic with council (richest output):
/pipeline diagnostic --client wellis --council --question "How to grow fast?"

# Quick diagnostic without council (faster, single-perspective):
/pipeline diagnostic --client diego

# Measurement pipeline:
/pipeline measurement --client wellis

# New client discovery:
/pipeline discovery --client heavytools --question "What do we know?"

# Re-run with verified data (skip gates):
/pipeline diagnostic --client wellis --skip-gates
```

## Integration

```
STANDALONE:
/pipeline diagnostic --client {slug}

WITH SCHEDULE (#39):
/schedule create --name "quarterly-diego-diagnostic" \
  --cron "0 9 1 */3 *" \
  --prompt "/pipeline diagnostic --client diego --council"

WITH TASK-OVERSIGHT:
/task-oversight flags "diego: no diagnostic in 90 days"
→ suggests: /pipeline diagnostic --client diego
```
