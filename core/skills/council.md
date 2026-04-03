# Skill: Council Runner (`/council`)

## Purpose

> **File versioning:** When generating .md output files, include version + date.

Orchestrates a multi-agent council deliberation. Reads a council YAML definition, spawns subagents in parallel, runs the pipeline stages (collect → peer review → warning intel → ACH → synthesis → BLUF+OODA), and auto-saves the result.

**This is the runtime that makes agents, councils, and the Karpathy pipeline actually work.**

## Trigger

Use when:
- Running a full diagnostic that benefits from multiple perspectives
- User says `/council {type}` (e.g., `/council diagnostic`)
- User says "run the diagnostic council", "get multiple perspectives", "council review"
- Before a [Diagnostic Service] or Fixer deliverable (recommended)
- When a previous single-perspective analysis needs verification

## Input

| Input | Required | Example | Default |
|---|---|---|---|
| `council_type` | Yes | `diagnostic`, `measurement`, `delivery`, `discovery` | — |
| `--client` | Yes (for client councils) | `exampleretail`, `example-wash` | Current project slug |
| `--question` | Yes | `"Why is acquisition declining?"` | — |
| `--peer-review` | No | flag | `false` (overrides council YAML if set) |
| `--agents` | No | `[diagnostic-analyst],channel-analyst` | All council members |
| `--skip-stages` | No | `warning_intel,ach` | None |

## Prerequisites

1. Council YAML exists: `agents/councils/{council_type}.yaml` (accessible via symlink from any client)
2. Agent definitions exist: `agents/{agent-id}.md` for each council member
3. Client context exists: `brand/` directory with intelligence profile files (can be stubs)
4. **Confidence scoring:** Each agent's findings get a confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Consensus weighs positions by confidence — a HIGH-confidence finding outweighs a LOW-confidence one.
5. **Recommendation dedup:** Before the synthesis stage creates any REC, check `RECOMMENDATION_LOG.md`. Include "Previously recommended" status in output. After creating RECs, auto-append to the log. See `core/methodology/RECOMMENDATION_DEDUP_RULE.md`.

## Process

### Step 1: Load Council Configuration

Read `agents/councils/{council_type}.yaml`. Parse:
- Agent roster (`agents.council` list)
- Chairman (`agents.chairman`)
- Pipeline stages (`pipeline.stages` — which are enabled)
- Context categories (`context.categories`)
- Data categories (`data.categories`)

If `--agents` provided, filter roster to only those agents.
If `--peer-review` flag set, override `peer_review` stage to `enabled: true`.
If `--skip-stages` provided, disable those stages.

### Step 2: Load Foundational Framework (ALWAYS)

**Before loading any client-specific context, ALWAYS load the 7-Layer Marketing Control Framework.** This is the shared analytical language all agents use. Without it, agents cannot communicate findings in a way the synthesis step can integrate.

Read `core/skills/7layer.md` — specifically the **"The Framework"** section (L0-L7 layer definitions, the Direction Rule, cascade logic). Extract:
- All 7 layer definitions (L0 Source → L7 Market)
- The Direction Rule (problems flow outward L0→L7, fixes flow inward)
- "Symptoms appear 2-3 layers from their cause"
- The Unity Principle (sales + marketing = one system)

Include this framework summary in EVERY agent's prompt (Step 3). This ensures:
- All agents use the same layer terminology
- Findings reference specific layers (not vague "marketing problems")
- The synthesis step can map convergent/divergent findings by layer
- ACH hypotheses are structured as "which layer is the primary constraint"

### Step 3: Load Client Context

Determine client slug from `--client` or from current working directory (detect from path: `clients/{slug}/`).

Load client files based on the context category mapping (from `core/methodology/CLIENT_INTELLIGENCE_PROFILE.md`):

| Context Category | Files to Load |
|-----------------|---------------|
| `brand` | `brand/VOICE.md`, `brand/POSITIONING.md` |
| `audience` | `brand/TARGET_PROFILE.md` |
| `competition` | `brand/POSITIONING.md` (competitive sections) |
| `offerings` | Product/service docs in `docs/` if they exist |
| `market` | `brand/POSITIONING.md` (market sections), `brand/7LAYER_DIAGNOSTIC.md` (L7) |
| `culture` | `brand/.md`, `brand/7LAYER_DIAGNOSTIC.md` (L0-L1) |

For each agent, load ONLY the categories listed in the agent's `context:` frontmatter field. This keeps token usage efficient.

If a file doesn't exist (stub or missing), note it as a gap — don't fail.

### Step 4: Stage — COLLECT (parallel agent responses)

For each agent in the council roster, spawn an Agent subagent **in parallel** (single message, multiple Agent tool calls):

```
For each agent_id in council.agents:
  1. Read .claude/agents/{agent_id}.md — get subagent definition (model, tools, role)
  2. Read core/agents/{agent_id}.md — get full methodology reference
  3. Load matching client context files (from Step 3)
  4. Build prompt:
     ---
     FRAMEWORK: {7-Layer Marketing Control Framework summary from Step 2}
     ROLE: {agent role definition from .md file}
     CLIENT CONTEXT: {loaded context files, filtered to this agent's categories}
     QUESTION: {user's --question}
     ---
     Analyze this from your specific perspective.
     Produce:
     1. Primary finding (1-2 sentences)
     2. Top 3 observations (evidence-based, with confidence ratings)
     3. Recommended primary constraint or action (which layer/area to address first)
     4. Confidence level (HIGH/MED/LOW with reasoning)
     5. What you're most uncertain about
     6. What data would change your mind (falsification indicator)
  5. Spawn as Agent with subagent_type="general-purpose"
```

**IMPORTANT:** Spawn ALL agents in a SINGLE message with multiple Agent tool calls. This runs them in parallel.

Collect all responses. If an agent fails or times out, note it and continue with remaining responses.

### Step 4: Stage — PEER REVIEW (optional, if enabled)

Only runs if `peer_review` stage is enabled (via YAML or `--peer-review` flag).

Follow the full protocol in `core/methodology/PEER_REVIEW_PROTOCOL.md`:

1. **Anonymize:** Strip agent identities. Assign random labels (Perspective A, B, C...). Store mapping.
2. **Synthesize:** Spawn ONE Agent that receives all anonymized perspectives:
   ```
   You have received {N} independent analyses, produced by analysts
   who could not see each other's work. You do not know which analytical
   lens produced which perspective.

   For each perspective:
   {Perspective A: ... }
   {Perspective B: ... }
   ...

   Your task:
   1. Where do 2+ perspectives CONVERGE? (high confidence findings)
   2. Where do they DIVERGE? (genuine uncertainty — do NOT average)
   3. Which perspective is most internally consistent with its evidence?
   4. Produce an integrated finding that leads with convergence,
      presents divergence as competing hypotheses.
   ```
3. **Reveal:** After synthesis, append the lens mapping (which agent was which perspective).

### Step 5: Stage — WARNING INTEL (Grabo, if enabled)

Spawn ONE Agent that receives ALL collected responses (from Step 3, or peer review synthesis from Step 4):

```
You are an intelligence analyst using the Grabo Warning Intelligence framework.
You have received analyses from {N} independent specialists about: {question}

Analyze for:

1. CONVERGENT SIGNALS: Where do 2+ analysts independently flag the same issue?
   | Signal | Sources | Confidence | Implication |

2. WEAK SIGNAL CLUSTERS: Individually minor observations that together predict
   something bigger.
   [Obs 1] + [Obs 2] + [Obs 3] → Predicted outcome

3. BLIND SPOTS: Critical areas NO analyst addressed.

4. CONTRADICTIONS: Where analysts disagree — indicates genuine uncertainty.
   | Source A | Source B | Conflict | Investigation needed |

5. INTELLIGENCE GAPS: What data collection would reduce uncertainty?
```

### Step 6: Stage — ACH (Heuer, if enabled)

Spawn ONE Agent that receives ALL prior outputs:

```
You are applying Analysis of Competing Hypotheses (Heuer/CIA method).

From the specialist analyses, extract 3-5 alternative hypotheses about
the client's situation. Then build an inconsistency matrix:

For each piece of evidence, mark: Consistent (C), Inconsistent (I), Neutral (N)

| Evidence | H1 | H2 | H3 | H4 |
|----------|----|----|----|----|

Rank hypotheses by FEWEST inconsistencies (not most confirmations).

Output:
- Leading hypothesis with confidence %
- Falsification indicator ("if X, this hypothesis is wrong")
- Sensitivity analysis ("removing evidence Y shifts ranking to H...")
```

### Step 7: Stage — SYNTHESIS (chairman)

Spawn ONE Agent as the chairman (the agent specified in `agents.chairman`):

```
ROLE: {chairman agent definition}

You are the Chairman of the {council_name}. You have received:
1. Individual specialist analyses (Step 3)
2. {If peer review ran: Peer review synthesis with convergent/divergent findings}
3. {If warning intel ran: Warning Intelligence brief}
4. {If ACH ran: Competing hypotheses with inconsistency matrix}

CLIENT CONTEXT: {full context for chairman's categories}
QUESTION: {original question}

Synthesize into a single integrated recommendation that:
- Addresses the leading ACH hypothesis
- Notes key convergent signals from warning intel
- Flags the falsification indicator prominently
- States confidence level honestly
- Identifies what would change the recommendation
- Proposes specific next actions with WHO/WHAT/WHEN
```

### Step 8: Stage — BLUF+OODA (format output)

Take the chairman's synthesis and format it using `core/templates/BLUF_OODA_TEMPLATE.md`:

```
## BLUF
[Chairman's conclusion, 2-3 sentences, confidence %]
[Falsification indicator]

## OBSERVE
[Top 5 findings from specialists, convergent signals]

## ORIENT
[Leading analysis + strongest challenge + unknowns]

## DECIDE
[Primary recommendation + alternatives]

## ACT
[WHO/WHAT/WHEN table from chairman's next actions]
[Each ACT item includes: `From: /council {type} {date}` for task extraction traceability]

## RISK ASSESSMENT
[From warning intel + ACH]

## SUCCESS METRICS
[Measurable outcomes]
```

### Step 9: Append Stage-Result Block

Add a machine-readable `stage-result` block at the end (per `core/methodology/PIPELINE_STAGE_PROTOCOL.md`):

````
```stage-result
stage_id: council
council_type: {type}
success: true
confidence: {from ACH leading hypothesis}
client: {slug}
question: "{question}"
agents_responded: {count}
peer_review: {true/false}
ach:
  leading: H{N}
  hypotheses:
    - id: H1
      description: "..."
      inconsistencies: {N}
      confidence: {%}
  falsification: "..."
convergent_signals:
  - signal: "..."
    sources: [A, C]
    confidence: HIGH
blind_spots:
  - "..."
metadata:
  council: {council_type}
  agents: [{list}]
  stages_run: [{list}]
  date: {YYYY-MM-DD}
```
````

### Step 10: Auto-Save & Open

1. Determine save location:
   - Client council: `clients/{slug}/docs/{CLIENT}_COUNCIL_{TYPE}_{DATE}.md`
   - Hub council: `internal/analyses/COUNCIL_{TYPE}_{DATE}.md`
2. Save with Write tool
3. Open in Typora: `open -a Typora "{path}"`
4. Report summary to user

### Step 11: Show Peer Review Details (if ran)

If peer review was active, append a collapsed details section showing:
- All anonymized perspectives
- Convergent vs divergent findings
- Lens reveal (which agent was which perspective)

## Output Format

```markdown
# Council Deliberation: {question}

> v1.0 — {date}
> Type: Council Deliberation | Council: {name}
> Client: {slug} | Agents: {count}/{total} responded
> Peer Review: {yes/no} | Stages: {list of stages that ran}
> Engine: Arcanian Council Runner

---

## BLUF
[conclusion, confidence, falsification]

---

## OBSERVE
[top findings]

## ORIENT
[leading analysis + challenge + unknowns]

## DECIDE
[recommendation + alternatives]

## ACT
| # | Action | Who | By When | Success Metric | From |
|---|--------|-----|---------|----------------|------|
[Every row gets `From: /council {type} {date}` — this populates the task From: field when extracted via save-deliverable Step 7]

## RISK ASSESSMENT
| Risk | Probability | Impact | Mitigation | Decision Trigger |
|------|-------------|--------|------------|-----------------|

## SUCCESS METRICS
| Metric | Current | Target | Timeline | Owner |
|--------|---------|--------|----------|-------|

---

## Warning Intelligence (Grabo)

### Convergent Signals
| Signal | Sources | Confidence | Implication |

### Weak Signal Clusters
[cluster → predicted outcome]

### Blind Spots
- [area not covered]

### Contradictions
| Source A | Source B | Conflict |

---

## ACH — Competing Hypotheses

| # | Hypothesis | Inconsistencies | Confidence |
|---|-----------|:---------------:|:----------:|

**Leading:** H{N} — {description}
**Falsification:** {what would prove it wrong}
**Sensitivity:** {which evidence removal shifts ranking}

---

## Specialist Perspectives

### {Agent 1 Name} — {Focus}
{Primary finding, observations, confidence}

### {Agent 2 Name} — {Focus}
{Primary finding, observations, confidence}

[... all agents ...]

---

{if peer review ran:}
<details>
<summary>Peer Review Details (anonymized perspectives + synthesis)</summary>

### Convergent Findings (2+ perspectives agree)
| Finding | Perspectives | Confidence |

### Divergent Findings
| Question | Perspective A | Perspective B | Perspective C |

### Lens Reveal
- Perspective A: {agent name} ({focus})
- Perspective B: {agent name} ({focus})
- ...

</details>

---

```stage-result
{YAML block}
```

---

## Ontology
- Client: {slug}
- Layer: {layers touched}
- Task: {if linked}
- Council: {type}
- Agents: {list}

---

What did we get wrong? What's missing?
```

## Council Types Available

| Council | Agents | Best For |
|---------|--------|----------|
| `diagnostic` | [diagnostic-analyst], channel-analyst, copy-analyst, client-explorer, audit-checker, knowledge-extractor | /7layer, , [Diagnostic Service], Fixer |
| `measurement` | audit-checker, channel-analyst, data-rules-checker, knowledge-extractor | Measurement audits, GTM checks |
| `delivery` | report-reviewer, copy-analyst, pii-scanner, data-rules-checker | Pre-delivery quality gate |
| `discovery` | client-explorer, project-architect | New leads, onboarding |

## Examples

```
/council diagnostic --client exampleretail --question "Why is new customer acquisition declining?"
/council diagnostic --client example-wash --question "What's the primary constraint?" --peer-review
/council measurement --client examplebrand --question "Is the ExampleD2C tracking reliable?"
/council delivery --client examplelocal --question "Review the repair roadmap before sending to [Name]"
/council discovery --client heavytools --question "What can we learn before the first call?"
```

## Error Handling

- **Agent fails/times out:** Log which agent failed, continue with remaining. Note in output: "{agent} did not respond — {N}/{total} perspectives available."
- **No client context files:** Run anyway but note: "Warning: {file} not found. Analysis may be limited." Don't block — stubs are OK.
- **Council YAML not found:** Error: "Council '{type}' not found. Available: diagnostic, measurement, delivery, discovery."
- **No agents respond:** Error: "Council deliberation failed — no agents responded." Don't produce output.

## Integration

```
STANDALONE:
/council diagnostic --client exampleretail --question "..."

WITH PIPELINE (future #38):
/pipeline diagnostic --client exampleretail
  → /7layer Mode 2
  → /council diagnostic (reads 7layer stage-result as input context)
  →  (reads council stage-result)
  → /repair-roadmap (reads constraints stage-result)

WITH SCHEDULE (future #39):
/schedule create --name "weekly-measurement-council" \
  --cron "0 9 * * 1" \
  --prompt "/council measurement --client exampleretail --question 'Weekly tracking health check'"
```

## Key Principles

1. **Parallel, not serial.** Agents are spawned simultaneously. A 6-agent council takes ~1 agent's time, not 6x.
2. **Isolation.** Agents cannot see each other's responses until synthesis. This is what prevents anchoring.
3. **Convergence = confidence.** When 3+ agents independently flag the same issue, that's a HIGH confidence finding.
4. **Divergence = investigation.** When agents disagree, that's genuine uncertainty — don't average, investigate.
5. **Auto-save always.** Every council run produces a saved, versioned, ontology-tagged file. Never just print.
6. **Discovery, not pronouncement.** The output presents alternatives. The client/team decides.
