# Peer Review Protocol (Anonymous Multi-Perspective)

> Source: Andrej Karpathy's LLM Council → Marketing Council v12 Stage 2
> Added to Arcanian Ops: 2026-03-26
> Task: #31

## What This Is

An optional protocol that runs 3 independent diagnostic perspectives in parallel, anonymizes their outputs, and synthesizes without anchoring bias. The strongest anti-bias mechanism from the Karpathy Council — adapted for Claude Code Agent tool.

## When to Use (OPT-IN)

**Use when:**
- [Diagnostic Service] or Fixer engagement (paid diagnostic — worth the extra LLM cost)
- High-stakes client decision depends on the diagnosis
- Previous diagnostic produced a surprising or counterintuitive result — verify it
- Client explicitly asks for a second opinion
- User adds `--peer-review` or says "with peer review" when invoking a skill

**Skip when:**
- First Signal / Morsel (quick, free — not worth 3x cost)
- Routine health checks
- Single-layer drill (Mode 3) where the constraint is already known
- Time-constrained (peer review adds ~2-3 minutes)

**The trigger is always the user.** This protocol never runs automatically. Skills should mention it as an option in their output:

```
Peer review available: run `/7layer --peer-review` for 3 independent perspectives.
Recommended for [Diagnostic Service]/Fixer tier.
```

## How It Works

### Phase 1: Spawn Independent Perspectives

Launch 3 Agent subagents in parallel, each using a formal agent definition from `core/agents/`. They receive the SAME input data but different analytical lenses:

```
Agent A — [diagnostic-analyst] (core/agents/[diagnostic-analyst].md)
Focus: L0-L2 (Source, Core, Identity)
Lens: Owner patterns, [Communication Framework] meta-programs, identity patterns, constraint types.
Skills: , , , , 

Agent B — channel-analyst (core/agents/channel-analyst.md)
Focus: L4-L7 (Offer, Channels, Customer, Market)
Lens: ROAS, channel mix, [Framework Author] Value Equation, [Customer Need Framework], competitive position.
Skills: /analyze-gtm, , /[customer need framework], /[customer need framework]-map, /map-results

Agent C — copy-analyst (core/agents/copy-analyst.md)
Focus: Cross-layer messaging coherence
Lens: Does what they SAY match who they ARE (L2), what they OFFER (L4),
      and who they're talking TO (L6)? Voice consistency, copy-market fit.
Skills: /analyze-copy, /build-brand, /magyar-szoveg, /conversion-story
```

These are real agents with YAML frontmatter, context allocations, and defined skill sets — not ad-hoc prompts.

Each agent produces:
1. **Primary finding** (1-2 sentences)
2. **Top 3 observations** (evidence-based)
3. **Recommended constraint** (which layer to fix first)
4. **Confidence level** (HIGH/MED/LOW with reasoning)
5. **What they're most uncertain about**

### Phase 2: Anonymize

Strip agent identities. Label outputs as **Perspective A**, **Perspective B**, **Perspective C**. The mapping (which lens produced which perspective) is stored but NOT revealed to the synthesis step.

```
ANONYMIZED PERSPECTIVES:

Perspective A:
- Primary finding: [...]
- Observations: [...]
- Recommended constraint: L[X]
- Confidence: [...]
- Uncertainty: [...]

Perspective B:
[same structure]

Perspective C:
[same structure]
```

### Phase 3: Synthesis (without identity)

A synthesis prompt receives ALL three anonymized perspectives and must:

1. **Identify convergence** — where do 2+ perspectives agree? (HIGH confidence signal)
2. **Identify divergence** — where do they disagree? (the interesting part)
3. **Rank perspectives** — which perspective is most consistent with the evidence?
4. **Produce integrated finding** — synthesize, don't average
5. **Flag the disagreement** — divergence = genuine uncertainty, not error

```
SYNTHESIS PROMPT:

You have received 3 independent analyses of the same business,
produced by analysts who could not see each other's work.

Your task:
1. Where do 2+ perspectives converge? These are high-confidence findings.
2. Where do they diverge? These are genuine uncertainties — do NOT average them.
   Instead, explain WHY they might differ (different data emphasis, different
   assumptions, different frameworks).
3. Which perspective is most internally consistent with its own evidence?
4. Produce a single integrated diagnosis that:
   - Leads with convergent findings (high confidence)
   - Presents divergent findings as competing hypotheses (feeds into ACH)
   - Flags what you're still uncertain about
   - Does NOT reveal which perspective you favored

You do not know which analytical lens produced which perspective.
Judge on evidence quality, not authority.
```

### Phase 4: Reveal & Annotate

After synthesis, reveal the lens mapping:
- Perspective A was the [Deep Layer / Channel / Systems] analyst
- Perspective B was the [...]
- Perspective C was the [...]

This lets the reader understand WHY perspectives diverged — not to pick a winner, but to see which analytical frame produced which insight.

## Integration Points

### With /7layer

Add at the end of Mode 2 (Pattern Map) output:

```
---
### Peer Review

This diagnosis was produced from a single analytical perspective.
For [Diagnostic Service]/Fixer engagements, run with `--peer-review` to get 3
independent perspectives with anonymous synthesis.
```

When `--peer-review` is active, the standard /7layer analysis becomes the "seed" — the 3 agents receive the same input data but NOT the seed analysis. The synthesis step then compares the 3 perspectives AND the original seed.

### With 

Peer review runs BEFORE ACH (Step 5). The competing hypotheses in ACH become richer because they originate from genuinely independent analytical frames, not one analyst generating alternatives.

Flow with peer review:
```
/7layer (seed diagnosis)
    → Peer Review Phase 1-4 (3 perspectives, anonymized, synthesized)
    →  Step 1-4 (collect, classify, verify)
    →  Step 5 ACH (hypotheses now come from 3 lenses)
    →  Step 6-8 (ceiling, conversation, strategy)
```

### With /repair-roadmap

Not directly integrated — peer review feeds into the diagnosis, not the repair plan. The repair roadmap consumes the richer ACH output that peer review produces.

## Output Format

When peer review is active, the deliverable includes a collapsed section:

```markdown
---

<details>
<summary>Peer Review (3 independent perspectives)</summary>

### Convergent Findings (2+ perspectives agree)
| Finding | Perspectives | Confidence |
|---------|-------------|:----------:|
| [finding] | A + C | HIGH |
| [finding] | A + B + C | HIGH |

### Divergent Findings (genuine uncertainty)
| Question | Perspective A | Perspective B | Perspective C |
|----------|:------------:|:------------:|:------------:|
| Primary constraint | L[X] | L[Y] | L[X] |
| [specific disagreement] | [view] | [view] | [view] |

### Synthesis
[Integrated finding — convergence leads, divergence presented as hypotheses]

### Lens Reveal
- Perspective A: Deep Layer Analyst (L0-L2)
- Perspective B: Channel & Market Analyst (L4-L7)
- Perspective C: Systems & Constraint Analyst (cross-layer)

</details>
```

## Implementation (Claude Code)

```
# Pseudocode for peer review in a diagnostic skill:

if user requested --peer-review:
    # Phase 1: Spawn 3 agents in parallel
    spawn Agent("Deep Layer Analyst", input_data, lens_prompt_A)
    spawn Agent("Channel & Market Analyst", input_data, lens_prompt_B)
    spawn Agent("Systems & Constraint Analyst", input_data, lens_prompt_C)

    # Phase 2: Anonymize (strip agent names, assign A/B/C randomly)
    perspectives = shuffle_and_anonymize(results)

    # Phase 3: Synthesize (single agent, no identity knowledge)
    synthesis = synthesize(perspectives)

    # Phase 4: Reveal
    annotated = reveal_lenses(synthesis, mapping)

    # Feed into ACH
    hypotheses = extract_hypotheses(annotated)
    # These become the H1/H2/H3/H4 in ACH Step 5
```

## What This Does NOT Do

- **Not a vote.** 2-out-of-3 agreement doesn't make something true. Convergence increases confidence; divergence increases investigation.
- **Not a replacement for ACH.** Peer review produces richer input for ACH. ACH tests hypotheses against evidence. Different mechanisms, complementary.
- **Not automatic.** Always opt-in. The user decides when the extra cost and time is justified.
- **Not for every skill.** Only diagnostic skills (/7layer, ). Not for operational skills (/tasks, /scaffold-project, /health-check).

## Cost & Time

| | Without peer review | With peer review |
|---|---|---|
| Agent calls | 1 | 4 (3 perspectives + 1 synthesis) |
| Time | ~1-2 min | ~3-5 min |
| Token cost | ~1x | ~3-4x |
| When justified | First Signal, routine | [Diagnostic Service], Fixer, high-stakes |
