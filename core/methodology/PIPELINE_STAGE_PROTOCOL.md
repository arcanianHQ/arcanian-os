---
scope: shared
---

# Pipeline Stage Protocol

> Source: Council v12 BaseStage pattern. Added 2026-03-26.
> Task: #34
> Status: Protocol defined. Skills adopt incrementally — not a big-bang rewrite.

## What This Solves

Currently, diagnostic skills hand off prose-to-prose:
```
/7layer outputs → human reads → constraint-mapping inputs manually
constraint-mapping outputs → human reads → repair-planning inputs manually
```

This works but loses structured data at each handoff. ACH hypotheses, confidence levels, constraint types — all rendered as markdown, then re-parsed from prose.

## The Protocol

### StageResult Block

Every diagnostic skill that produces output for another skill MUST include a machine-readable `StageResult` block at the end of its output, inside a fenced code block tagged `stage-result`:

````markdown
```stage-result
stage_id: 7layer
success: true
confidence: MED
primary_constraint: L5
broken_layers: [L1, L5, L7]
locked_layers: []
findings:
  - id: F1
    layer: L5
    severity: HIGH
    summary: "Channel mix 90% organic, no paid diversification"
  - id: F2
    layer: L7
    severity: MED
    summary: "No competitive monitoring in place"
  - id: F3
    layer: L1
    severity: HIGH
    summary: "No marketing owner — founder does everything"
metadata:
  mode: 2  # Pattern Map
  peer_review: false
  client: diego
  date: 2026-03-26
```
````

### Stage Types

| Stage ID | Skill | Produces | Consumed By |
|----------|-------|----------|-------------|
| `7layer` | /7layer | broken_layers, primary_constraint, findings | constraint-mapping stage |
| `constraints` | constraint-mapping stage | constraint_map, ach_hypotheses, ceiling | repair-planning stage |
| `repair` | repair-planning stage | repair_cards, timeline, milestones | execution / /delivery-phase |
| `health` | /health-check | project_statuses, warning_intel | /morning-brief |
| `peer_review` | PEER_REVIEW_PROTOCOL | perspectives, convergent, divergent | constraint-mapping stage (ACH) |

### Per-Stage Result Schemas

#### 7layer → constraints

```stage-result
stage_id: 7layer
success: true
confidence: HIGH|MED|LOW
primary_constraint: L[0-7]
broken_layers: [L1, L5, ...]
locked_layers: [L0, ...]  # if known at this stage
findings:
  - id: F[N]
    layer: L[0-7]
    severity: HIGH|MED|LOW
    summary: "one-line finding"
    evidence: "what supports this"
    confidence: HIGH|MED|LOW
metadata:
  mode: 1|2|3
  peer_review: true|false
  client: slug
  date: YYYY-MM-DD
```

#### constraints → repair

```stage-result
stage_id: constraints
success: true
confidence: HIGH|MED|LOW
ceiling: 75  # percentage
constraint_map:
  - id: C[N]
    statement: "what client said"
    type: 1|2|3  # Hard, Sacred Cow, L0 Block
    layer: L[0-7]
    verified: true|false
    cost: "business impact description"
ach:
  leading: H1
  hypotheses:
    - id: H1
      description: "hypothesis text"
      inconsistencies: 1
      confidence: 65
    - id: H2
      description: "hypothesis text"
      inconsistencies: 3
      confidence: 25
  falsification: "what would prove H1 wrong"
unverified:
  - constraint: "No developer"
    assumption: "Not mentioned in conversation"
    question: "Do you have a developer?"
metadata:
  peer_review: true|false
  client: slug
  date: YYYY-MM-DD
```

#### peer_review → constraints (ACH input)

```stage-result
stage_id: peer_review
success: true
perspectives:
  - label: A
    lens: "Deep Layer Analyst (L0-L2)"
    primary_finding: "one-line"
    recommended_constraint: L[0-7]
    confidence: HIGH|MED|LOW
    observations: ["obs1", "obs2", "obs3"]
  - label: B
    lens: "Channel & Market Analyst (L4-L7)"
    primary_finding: "one-line"
    recommended_constraint: L[0-7]
    confidence: HIGH|MED|LOW
    observations: ["obs1", "obs2", "obs3"]
  - label: C
    lens: "Systems & Constraint Analyst"
    primary_finding: "one-line"
    recommended_constraint: L[0-7]
    confidence: HIGH|MED|LOW
    observations: ["obs1", "obs2", "obs3"]
convergent:
  - finding: "what 2+ perspectives agree on"
    perspectives: [A, C]
    confidence: HIGH
divergent:
  - question: "where they disagree"
    a: "view"
    b: "view"
    c: "view"
metadata:
  client: slug
  date: YYYY-MM-DD
```

#### health → morning_brief

```stage-result
stage_id: health
success: true
projects:
  - slug: diego
    claude_md: true
    tasks_md: true
    symlinks: true
    brand_complete: 7  # out of 7
    issues: []
  - slug: mancsbazis
    claude_md: true
    tasks_md: true
    symlinks: true
    brand_complete: 3
    issues: ["brand profile incomplete"]
mcp:
  - server: todoist
    status: connected
  - server: asana
    status: auth_error
warning_intel:
  convergent:
    - signal: "description"
      clients: [diego, wellis]
      confidence: HIGH
  blind_spots:
    - "area not covered"
  weak_clusters:
    - "cluster description → predicted outcome"
metadata:
  scope: all
  date: YYYY-MM-DD
```

## How Skills Adopt This

### Incremental adoption — NOT a big-bang rewrite

1. **Phase 1 (now):** Protocol defined. Skills that already produce structured output (tables, maps) can optionally append a `stage-result` block.

2. **Phase 2 (when touching a skill):** Next time a skill is edited for any reason, add the `stage-result` block to its output format section. No separate task needed — piggyback on other work.

3. **Phase 3 (ArcOS port):** When skills are ported to ArcOS (#19), the `stage-result` block becomes mandatory. ArcOS pipeline runner consumes these blocks to chain stages automatically.

### Reading a StageResult

When a skill receives input that includes a `stage-result` block from a previous skill:
1. Parse the YAML block
2. Use structured data (broken_layers, constraint_map, ach) directly
3. Fall back to prose parsing if no block exists (backward compatible)

```
# Pseudocode for consuming a prior stage result:
if input contains ```stage-result block:
    data = parse_yaml(block)
    broken_layers = data.broken_layers
    primary_constraint = data.primary_constraint
else:
    # Legacy: parse from prose
    broken_layers = extract_from_markdown(input)
```

### Backward Compatibility

- Skills that DON'T produce a `stage-result` block still work — the next skill falls back to prose parsing
- Skills that DO produce a block also still produce the full prose output — the block is supplementary, not a replacement
- No skill is broken by this change — it's additive only

## Integration with Council YAML

Council definitions in `core/agents/councils/*.yaml` reference pipeline stages by ID. The `stage-result` block's `stage_id` matches the council's stage list:

```yaml
# councils/diagnostic.yaml
pipeline:
  stages:
    - id: collect        # agents produce findings
    - id: peer_review    # optional, stage_id: peer_review
    - id: warning_intel  # stage_id: health (grabo analysis)
    - id: ach            # stage_id: constraints (ACH section)
    - id: synthesis      # chairman integrates
    - id: bluf_ooda      # executive summary
```

When ArcOS pipeline runner chains these, each stage's `stage-result` output becomes the next stage's input. Until then, humans bridge the gap — but the data format is ready.
