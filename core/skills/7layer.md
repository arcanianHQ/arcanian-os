---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Agent
argument-hint: "client — Client slug (e.g., wellis, diego)"
---

# Skill: Marketing Diagnosis (`/7layer`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

Diagnoses a business's marketing using the Arcanian Marketing Control Framework (L0–L7). Finds the PRIMARY CONSTRAINT — the deepest layer blocking growth — and shows how problems cascade across layers. Delivers a Pattern Map that makes the invisible visible.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. L5 (Channels) and L6 (Customer) diagnosis MUST be per-domain — channel performance and customer identity differ across domains. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data confidence ≠ causal confidence. GA4 alone is insufficient for causal diagnosis — always check platform-side data (Meta Ads Manager, Google Ads, etc.). See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every layer assessment and finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Recommendation dedup:** Before creating any REC, check `RECOMMENDATION_LOG.md` in the client directory. See `core/methodology/RECOMMENDATION_DEDUP_RULE.md`. After creating a REC, auto-append to the log.

**The Arcanian Principle:**
> "Every campaign result reveals the assumption that created it."
> *"Minden kampányeredmény feltárja azt a feltételezést, ami létrehozta."*

**The CONTROL Principle:**
> "You control marketing — not the other way around."

**The UNITY Principle:**
> Sales and marketing are ONE system. At the system level, they break at the same layers.
> A broken L2 (customer identity) damages both marketing messaging AND sales conversations equally.
> A broken L4 (offer) means marketing generates leads for an offer sales can't close.
> You cannot fix marketing without fixing sales, and vice versa — because they share the same layers.
> This framework diagnoses the SYSTEM, not "marketing" or "sales" as separate functions.

## Source References
- **The Arcanian Methodology** — Core framework document (Hermetic foundation)
- **7-Layer Marketing Control Framework** — Client guide
- **Identity overlay** — Person-level identity and values mapping at L1/L2 (how owner identity shapes the system)
- 22 years of marketing pattern recognition, systematized

## Architecture

> v2.0 — 2026-04-12 — Refactored to agent-council architecture.

This skill uses the **7layer council** (`core/agents/councils/7layer.yaml`):

| Agent | Layers | Weight | Focus |
|---|---|---|---|
| `layer-foundation` | L0 + L1 | 30% | Beliefs, identity, capability, process |
| `layer-value` | L2 + L3 | 25% | Brand identity, positioning, product, PMF |
| `layer-delivery` | L4 + L5 | 25% | Offer, pricing, channels, measurement |
| `layer-market` | L6 + L7 | 20% | Customer journey, market forces, competition |
| `layer-synthesizer` | All | — | PRIMARY CONSTRAINT + cascade map (chairman) |

Pipeline: 4 agents parallel → synthesis (constraint identification)
Scoring: `core/methodology/SEVEN_LAYER_SCORING.md`

## Trigger
Use this skill when:
- Client says "marketing isn't working" but can't say why
- Declining ROAS, rising CPCs, flat growth — symptoms without diagnosis
- "We've tried everything" (they've tried everything at the WRONG layer)
- Agency changed, creatives refreshed, budget increased — same results
- Client needs a second opinion on their marketing direction
- Before any tactical work — diagnose first, execute second
- Running a Marketing Röntgen (48-hour diagnostic)
- Client has a specific question but you suspect deeper layers are involved

## The Framework

### The Layers (L0–L7, Inside Out)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   OUTERMOST (least control)                                     │
│                                                                 │
│   L7: Market ─────────────► Is this game changing under us?      │
│           │                                                     │
│   L6: Customer ───────────► Who are they — and what identity     │
│                               do they get by buying from us?    │
│           │                                                     │
│   L5: Channels ───────────► Where do we actually win?           │
│           │                                                     │
│   L4: Offer ──────────────► How is it packaged and priced?      │
│           │                                                     │
│   L3: Product ────────────► What do we actually deliver?        │
│           │                                                     │
│   L2: Identity ───────────► Who are we? What do we stand for?   │
│           │                 (Brand identity — includes value)    │
│   L1: Core ───────────────► Can we execute? Who owns the        │
│           │                   strategy?                          │
│   L0: Source ─────────────► Who are the people running this —   │
│                               and what do they believe?          │
│   INNERMOST (most control)                                      │
│                                                                 │
│   Problems flow outward (L0→L7).                                │
│   Fixes flow inward (L7→L0).                                    │
│   Symptoms appear 2-3 layers from their cause.                  │
│                                                                 │
│   SALES + MARKETING = ONE SYSTEM:                               │
│   • Every layer affects BOTH sales and marketing equally        │
│   • L6 broken = marketing targets wrong people AND sales        │
│     talks to wrong people                                       │
│   • L4 broken = marketing promises what sales can't deliver     │
│   • L1 broken = both teams lack structure and ownership         │
│   • Diagnose the SYSTEM, not the department                     │
│                                                                 │
│   L0↔L1 DISTINCTION:                                            │
│   • L0 = WHY they can't/won't change (identity, beliefs)        │
│   • L1 = WHAT they can't do right now (capacity, structure)      │
│   • L0 problems make L1 problems permanent                      │
│                                                                 │
│   OVERLAYS (not layers — they emerge from alignment):           │
│   • Brand = emerges from L3-L7 alignment                        │
│   • Position = emerges from L2 × L3 × L4 alignment             │
│     "Why us, not them?" = Identity + Product + Offer            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Reference

| Layer | Name | Core Question | Shadow (Hidden Assumption) | When It's the Constraint |
|-------|------|---------------|---------------------------|--------------------------|
| **L7** | Market | Is this game changing under us? | "We know our market" | Blindsided by shifts, new entrants reshaping rules, strategy invalidated by external forces |
| **L6** | Customer | Who are they — and what identity do they get? | "We serve everyone" | Product great but "people don't get it," identity clash blocks purchase, no tribal loyalty |
| **L5** | Channels | Where do we win? | "We're on all channels" | Spreading thin, exhausted team, spend up but results flat |
| **L4** | Offer | How is it packaged? | "Price is right" | "I'll think about it," high abandonment, no urgency |
| **L3** | Product | What do we deliver? | "Our product speaks for itself" | Product-market misfit, feature bloat, no differentiation |
| **L2** | Identity | Who are we? What do we stand for? | "We know who we are" | Inconsistent messaging, internal confusion about identity, value not communicated |
| **L1** | Core | Can we execute? Who owns the strategy? | "We just need better people" | No strategy owner, execution gaps, team at capacity, decision bottlenecks |
| **L0** | Source | Who are the people running this — and what do they believe? | "That's just how it is" | Great report, nothing changes. Third agency, same results. Owner overrides every hire. Identity-level resistance to change |

---

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--peer-review` | off | Run 3 independent diagnostic perspectives (anonymized) before synthesis. Adds ~3 min, ~3x tokens. Recommended for First Signal / The Fixer engagements. See `core/methodology/PEER_REVIEW_PROTOCOL.md`. |

When `--peer-review` is active: after the standard diagnosis completes, spawn 3 Agent subagents with different lenses (Deep Layer L0-L2, Channel/Market L4-L7, Systems/Constraint cross-layer). Anonymize outputs, synthesize without knowing which lens produced what, then reveal. Convergent findings become HIGH confidence; divergent findings feed into ACH as competing hypotheses. Full protocol: `core/methodology/PEER_REVIEW_PROTOCOL.md`.

---

## Modes

This skill operates in **three modes**.

```
┌─────────────────────────────────────────────────────────────────┐
│                    ANALYSIS MODES (L0–L7)                        │
│                                                                 │
│  MODE 1: RÖNTGEN (Quick Diagnostic)                             │
│  Input: Website + stated challenge                              │
│  Output: Top 5 problems, ranked, with primary constraint        │
│  Note: L0 is inferred from language markers, not directly       │
│        observable from website alone. Flag if signals present.   │
│  Time: Fast — the 48-hour product                               │
│                                                                 │
│  MODE 2: PATTERN MAP (Full Diagnosis)                           │
│  Input: All available data across all layers                    │
│  Output: Complete L0–L7 map with cascade connections            │
│  Note: L0 requires founder/owner conversation or deep context.  │
│        Include L0 assessment when data is available.             │
│  Time: Thorough — needs more context                            │
│                                                                 │
│  MODE 3: CONSTRAINT DRILL (Single Layer Deep Dive)              │
│  Input: Identified constraint layer + all related data          │
│  Output: Root cause analysis + action plan for that layer       │
│  Note: Always check if the constraint has an L0 root.           │
│  Time: Focused — after primary constraint is known              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## MODE 1: RÖNTGEN (Quick Diagnostic)

### Input Required
- Company website URL or description
- What they sell
- Their stated marketing challenge or goal
- Any available data (revenue, traffic, conversion, spend — optional)

### Process

**Step 0 (optional): Check Arcanum for conceptual context.** If `arcanum/wiki/index.md` exists, check for concept/entity pages relevant to this client's market or problem space. Include as background context, cited as `[Arcanum: {slug}]`. Skip silently if no relevant pages.

**Step 1: Scan All Layers (L0–L7)**

For each layer, look for signals of strength or weakness. Use linguistic markers, website copy, stated goals, and available data. For L0, look for language markers that reveal belief patterns (e.g., "we can't," "our market won't," "that's just how it is").

**Step 2: Identify Problems Per Layer**

Rate each layer:
- **Strong** — aligned, working, no red flags
- **Needs Attention** — misaligned or unclear, not yet critical
- **Constraint** — actively blocking growth, cascading into other layers

**Step 2b: Sales–Marketing Unity Check**

For each layer rated "Constraint" or "Needs Attention", ask:
- Does this layer break marketing, sales, or BOTH?
- If both: this is a SYSTEM-level break (highest priority — fixing one side won't help)
- If only marketing: check if sales has the same problem but calls it something different
- If only sales: check if marketing is compensating for a sales problem (or vice versa)

Common system breaks:
- L6: Marketing targets persona A, sales sells to persona B → both fail
- L4: Marketing promises value X, sales delivers value Y → trust breaks
- L1: Marketing team and sales team have no shared KPIs → blame loop
- L0: Owner believes "sales is different from marketing" → permanent L1 split

**Step 3: Trace Symptom to Cause**

The client's stated problem is almost never where the real problem lives. Trace it:

```
CLIENT SAYS:              →  SYMPTOM LAYER  →  ACTUAL CAUSE LAYER     →  POSSIBLE L0 ROOT
"Ads aren't working"         L5 (Channels)     L4 (Offer) or L3 (Product)
"Nobody buys"                L4 (Offer)        L2 (Identity) or L6 (Customer)
"We can't grow"              L7 (Market)       L4 (Offer) — underpriced    L0: "I'm not worth more"
"Price is too high"          L4 (Offer)        L2 (Identity) — value gap
"Wrong customers"            L6 (Customer)     L3 (Product) — wrong market
"Agency isn't delivering"    L5 (Channels)     L1 (Core) — no owner         L0: can't delegate
"Brand is weak"              Overlay           L7→L2→L3 cascade
"Great report, did nothing"  Implementation     L0 (Source) — identity-level resistance
```

**Step 4: Find the Primary Constraint**

The primary constraint is the **deepest layer** that, if fixed, would unlock multiple layers above it. This is the leverage point.

**Step 5: Rank Top 5 Problems**

### Output Format

```
## MARKETING RÖNTGEN: [Company Name]

### Business Context
[Brief summary]

---

### Layer Scan

| Layer | Status | Key Finding |
|-------|--------|-------------|
| L7: Market | ... | ... |
| L6: Customer | ... | ... |
| L5: Channels | ... | ... |
| L4: Offer | ... | ... |
| L3: Product | ... | ... |
| L2: Identity | ... | ... |
| L1: Core | [Strong/Attention/Constraint] | [One-line finding] |
| L0: Source | [Strong/Attention/Constraint/Inferred] | [One-line finding — may be inferred] |

---

### TOP 5 PROBLEMS (ranked by business impact)

1. **[Problem]** — Layer [X]
   Why it matters: [Impact on business]
   What to do: [Specific action]

2. ...

---

### PRIMARY CONSTRAINT
**Layer:** [X] — [Name]
**Why this layer:** [How fixing this unlocks other layers]

### CASCADE MAP
[Show how the primary constraint flows into other layer problems]

### THE EXPENSIVE MISTAKE
[What they'll likely try to fix instead — and why it won't work]

### WHAT TO DO FIRST
[One clear next step]
```

---

## MODE 2: PATTERN MAP (Full Diagnosis)

### Input Required
All available context:
- Website, landing pages, social profiles
- Stated marketing goals and challenges
- Revenue, traffic, conversion data
- Ad spend and ROAS data
- Customer descriptions and segments
- Competitor information
- Team structure and capacity
- What they've already tried

### Process

Analyze each layer thoroughly using the diagnostic questions below. Start from the outermost (most visible) and drill down to the deepest (most hidden). L0 (Source) is assessed last — it requires the most context and is often invisible until all other layers are mapped.

### Layer 7: Market (Macro Forces Only)

L7 is about the GAME ITSELF — not the players. Competitor analysis belongs in the Competitive Matrix (see below), not here. L7 captures forces that change the rules for everyone.

**Diagnostic Questions:**
1. Is this market growing, stable, or shrinking — and what's driving the trend?
2. What macro forces are reshaping this market? (regulation, technology, economy, culture)
3. Are new market entrants (Amazon, Temu, Allegro, EMAG) changing the competitive landscape?
4. What external disruptions could invalidate the current strategy? (currency shifts, supply chain, trade policy)
5. Are seasonal or political cycles affecting buyer behavior? (elections, weather extremes, holidays)
6. What do customers do instead of buying from ANYONE in this category? (the "do nothing" alternative)

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| "We know our market" | Blindsided by shifts | Not tracking macro forces |
| Shrinking market | Declining despite optimization | Market shift, not execution problem |
| New entrant disruption | Sudden price pressure, lost share | Platform/marketplace reshaping the game |
| Regulatory/economic blind spot | Strategy invalidated overnight | External forces not monitored |
| Ignoring "do nothing" alternative | Customers choose inaction | Category demand problem, not brand problem |

### Layer 6: Customer (Including Customer Identity)

L6 has two dimensions: WHO the customer is, and what IDENTITY they get (or project) by buying from you. The identity dimension is often invisible but overrides everything — a customer will choose worse options if those options align with their identity.

**Diagnostic Questions — Who They Are:**
1. Can they describe their ideal customer's typical Tuesday?
2. What keeps this person up at night about this problem?
3. What have they already tried that failed?
4. What would they type into Google at 11pm?
5. Who pays vs. who uses?

**Diagnostic Questions — Customer Identity:**
6. What identity does the customer get or project by buying from you?
7. What "tribe" does the customer join by choosing you? (Apple tribe, budget-smart tribe, rebel tribe...)
8. Does your brand/product CLASH with the customer's self-image? Would they feel embarrassed or proud buying from you?
9. What would the customer say about themselves if they recommend you to a friend?
10. Are you targeting the customer's current identity or their aspirational identity?

**The Identity Principle:**
Great brands don't sell products — they sell identity. Coca-Cola sells a feeling of belonging. Apple sells creative rebellion. Balázs Kicks sells "I'm in the tribe that knows." This runs whether you manage it or not. An identity clash blocks the sale even when offer, product, and channels are perfect. The company's Identity (L2) must align with the customer's desired identity (L6) — this is the L2↔L6 bridge.

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| Sales–marketing mismatch | Marketing brings leads, sales can't close | Sales and marketing target DIFFERENT customers (L6 split) |
| "We serve everyone" | Diluted messaging | No clear customer definition |
| Demographic-only targeting | Reach but no conversion | Missing psychographic depth |
| Customer ≠ User | Product loved, doesn't sell | Selling to wrong person |
| Assumed knowledge | "Obviously they know" | Gap between you and market |
| Identity clash | Perfect offer, no conversion | Customer's self-image conflicts with buying from you |
| No tribal signal | No word-of-mouth, no loyalty | Buying from you says nothing about the customer |
| Wrong identity targeted | Attracts price buyers only | L2 identity doesn't match aspirational customer identity |

### Layer 5: Channels

**Diagnostic Questions:**
1. Where do their best customers actually spend time?
2. Which ONE channel drives most real results?
3. Are they spreading thin or going deep?
4. Does channel match customer's buying journey?
5. What channels are they on because "should be" vs. because they work?

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| Spreading thin | Mediocre results everywhere | No channel mastery |
| Platform chasing | Always starting over | Shiny object syndrome |
| Wrong channel for offer | High spend, low return | Channel-offer mismatch |
| Channel-first strategy | Tactics without strategy | Putting L5 before L1-4 |

### Layer 4: Offer (The Package)

**Diagnostic Questions:**
1. Why should someone buy TODAY vs. next month?
2. What risk do they feel when considering purchase?
3. Can they understand pricing in 5 seconds?
4. Does pricing attract the customers they want?
5. What's the guarantee? Is it strong enough?

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| No urgency | "I'll think about it" | No reason to act now |
| No risk reversal | High abandonment | Too much perceived risk |
| Confusing options | Decision paralysis | Too many choices |
| Price-value mismatch | Wrong customers | Pricing signals wrong positioning |
| Marketing promise ≠ sales delivery | Lead-to-close gap | Marketing sells one offer, sales delivers another (L4 split) |
| Sales overrides pricing | Constant discounting | No offer structure — sales improvises every deal |

### Layer 3: Product (The Deliverable)

**Diagnostic Questions:**
1. What specifically does the customer receive?
2. How does the product/service compare to alternatives (direct and indirect)?
3. What do customers use most vs. what was built?
4. Is there a gap between what the product does and what the market needs?
5. Does the product create natural advocates (word of mouth)?
6. What would need to change in the product to charge 2× more?

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| "Our product speaks for itself" | No referrals, low awareness | Product-market misalignment |
| Feature bloat | Confused customers, long sales cycle | Building for everyone = useful for no one |
| Copy-paste of competitor | Price wars, no loyalty | No real product differentiation |
| Over-engineered solution | High price, low adoption | Built for wrong audience |
| Undifferentiated service | Clients leave for cheaper option | No unique deliverable |

### Layer 2: Identity (Brand Identity — includes Value)

**Diagnostic Questions:**
1. What do we stand for — in one sentence?
2. What's the gap between how we see ourselves and how customers see us?
3. What transformation are customers really buying?
4. What do their best customers love that they barely mention?
5. If they doubled their price, what would justify it?
6. Can every team member explain why the company exists — the same way?

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| "We do a bit of everything" | Inconsistent messaging | No clear identity |
| Feature-focused selling | Price objections | Value not communicated |
| "It's obvious what we offer" | Low conversion | Customers see it differently |
| Misaligned perception | High churn | Delivery ≠ expectation |
| Internal disagreement on identity | Mixed signals to market | No shared foundation |

### Layer 1: Core (Organizational Capability)

L1 is about what the organization CAN do — its structure, capacity, and decision-making architecture. Beliefs and identity belong at L0.

**Diagnostic Questions:**
1. Is there someone who owns the marketing direction? (Not does it, OWNS it.)
2. Does the team have the skills, time, and budget to execute what's planned?
3. How are marketing decisions made — and how fast?
4. Are departments/teams pulling in the same direction?
5. Is budget/energy going to the right places, or scattered?
6. Who's accountable when marketing fails?

**Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| No strategy owner | Agency guesses direction | Nobody owns the marketing system |
| Overcommitted team | Execution failures | No capacity for what's planned |
| Decision bottleneck | Everything waits for one person | Organizational structure prevents speed |
| Misaligned departments | Sales says one thing, marketing another | No internal alignment |
| Sales–marketing war | Blame loop: "leads are bad" / "sales can't close" | SYSTEM problem — both break at the SAME layer but blame each other |
| Budget scattered | Many initiatives, none funded properly | Resource allocation problem |
| No single owner | Marketing and sales report to different people | System has no integrator — the layer-level problem gets split across two departments |

**L0 check:** If L1 problems keep recurring after being "fixed" (e.g., hired a marketing director but still no one owns strategy), the root is likely at L0 — the owner's identity prevents the structural change from taking hold.

### Layer 0: Source (Identity & Beliefs — Deepest)

L0 is the force field. The founder/owner's identity and belief systems about business, money, markets, clients, and their own role create the environment in which the entire organization operates. L0 is often invisible — beliefs experienced as "reality" rather than as beliefs.

**Diagnostic Questions:**
1. What does the owner believe about delegation, control, and trust?
2. What identity would the owner need to give up to make this change?
3. Is the organization's operating model matching its revenue level, or is KKV-origin identity holding it back?
4. What beliefs does the owner hold as "just how things are"? (transparent beliefs)
5. Is there willingness to examine beliefs, or only willingness to change tactics?
6. What would they do differently if they knew it would work? (reveals the belief that blocks it)

**Identity Patterns to Detect:**

| Pattern | Symptom | Real Problem |
|---------|---------|--------------|
| Helper/Martyr | "I have to be involved in everything" | Identity = being needed |
| Expert/Imposter | Won't delegate because "nobody does it right" | Identity = being the expert |
| Visible/Invisible | Either over-present or hiding from the market | Identity conflict about visibility |
| Abundant/Scarce | "We can't charge more" / "the market won't pay" | Scarcity belief masking as market knowledge |
| Worthy/Unworthy | Underpricing, overdelivering, can't say no | Deep belief about not being worth more |

**The Hungarian Pattern (KKV-origin):**
Revenue is mid-market (1–15B Ft) but the operating model is still kisvállalkozás. The owner started small, scaled revenue, but their identity hasn't shifted. They still make every decision, distrust systems they didn't build, and treat delegation as risk rather than growth. This is L0 creating a permanent L1 problem.

**L0 Shadow:** "That's just how business works." The most dangerous L0 patterns are transparent — the owner doesn't experience them as beliefs at all. They experience them as reality.

**Tools for L0 diagnosis:**
- Belief tracing — surfaces transparent beliefs (beliefs experienced as reality, not as beliefs)
- Identity-pattern mapping — the 5 archetypes (Helper, Martyr, Visionary, Fixer, Architect)
- Person-level identity map — who the owner is across identity, values, capability, behaviour, environment
- COACH/CRASH state check — readiness to receive diagnosis

### Mapping Connections

After analyzing all layers, map the CASCADE — how problems flow from one layer to another:

```
PATTERN MAP: [Company]

[Deepest problem layer]
        │
        ▼ feeds into
[Next affected layer]
        │
        ▼ amplified by
[Next affected layer]
        │
        ▼
= SYMPTOM (what client reports)

PRIMARY BLOCKAGE: Layer [X]
```

### Output Format

```
## PATTERN MAP: [Company Name]

### Business Context
[Summary]

---

### Layer 7: Market
**Status:** [Strong / Needs Attention / Constraint]
**Findings:**
- [Key observations]
**Shadow (Hidden Assumption):**
- [What they believe that may not be true]
**Red Flags:**
- [Warning signs]

[Repeat for L6 down to L1]

### Layer 0: Source
**Status:** [Strong / Needs Attention / Constraint / Insufficient Data]
**Findings:**
- [Identity patterns observed, belief markers, delegation behavior]
**Identity Pattern:** [Helper/Martyr, Expert/Imposter, etc. — if identifiable]
**Shadow (Hidden Assumption):**
- [Transparent beliefs — what they experience as "reality"]
**L0→L1 Connection:**
- [How L0 beliefs create or perpetuate L1 problems]

---

### THE PATTERN MAP (Cascade)

[Visual cascade showing how problems connect across layers, including L0 root]

---

### PRIMARY CONSTRAINT
**Layer:** [X] — [Name]
**Why this layer:** [How fixing it unlocks everything above]
**L0 Root (if applicable):** [The belief/identity pattern underneath]

### SECONDARY CONSTRAINTS
[Other layers needing attention, in priority order]

---

### RECOMMENDED ACTIONS
1. [Most important — addresses primary constraint]
2. [Second action]
3. [Third action]

### WHAT NOT TO DO
[The expensive mistake — what they'll try instead and why it'll fail]

### THE DIRECTION RULE
Problems flow outward (L0→L7). Fixes flow inward.
[Explain the specific cascade in this business]
```

---

## MODE 3: CONSTRAINT DRILL (Single Layer Deep Dive)

For when the primary constraint is already identified and needs deeper analysis.

### Input Required
- Which layer to drill into
- All available data relevant to that layer
- What's already been tried at this layer
- How this layer connects to other layer problems

### Process

**Step 1: Map all problems within this layer**
Not just one issue — everything happening at this level.

**Step 2: Find the root within the layer**
Even within a single layer, there's a hierarchy. What's the deepest issue?

**Step 3: Check cross-layer connections**
Is this layer problem caused by a deeper layer? Or is it truly originating here?

**Step 4: Design the fix**
Specific, actionable, ordered steps to resolve the constraint.

### Output Format

```
## CONSTRAINT DRILL: Layer [X] — [Name]

### Current State
[What's happening at this layer]

### Root Cause (within layer)
[The deepest issue at this level]

### Cross-Layer Connections
- Caused by: [deeper layer issue, if any]
- Causing: [outer layer symptoms]

### Fix Sequence
1. [First action — addresses root within layer]
2. [Second action]
3. [Third action]

### Success Signals
[How to know when this constraint is resolved]

### What Opens Up
[Which outer layers improve when this is fixed]
```

---

## Key Principles

### 1. Symptoms ≠ Causes
A problem at one layer appears as a symptom 2-3 layers away. Never optimize the symptom layer.

### 2. The Expensive Mistake
Optimizing the wrong layer = money burned + time lost. The real constraint sits untouched.

**Classic example:**
- Declining ROAS → they test new ads, new audiences, new platforms (L5)
- Nothing works
- Real problem: offer has no urgency (L4) or product isn't differentiated (L3)

### 3. The Direction Rule
Problems flow outward (L0→L7). Fixes flow inward (L7→L0). Fix the deepest constraint first. Outer layer fixes are wasted if inner layers are broken. L0 problems make every other fix temporary.

### 4. Brand Is an Overlay, Not a Layer
Brand emerges from L3-L7 alignment. "Brand is weak" is always a symptom of layer misalignment, never a standalone problem.

### 5. Position Is an Overlay, Not a Layer
Position = the market's perception of where you stand. It emerges from the alignment of Identity (L2) × Product (L3) × Offer (L4). You don't "fix positioning" — you fix the underlying layers and position follows. The old question "Why us, not them?" is answered concretely: our identity is clear (L2), our product is different (L3), our offer is compelling (L4).

### 6. Layers Are Connected, Not Linear
Problems cascade, amplify, and interact. A Pattern Map shows the connections — not just a checklist of layer statuses.

### 7. The L2↔L6 Identity Bridge
Your company's Identity (L2) must align with your customer's desired Identity (L6). When these clash, nothing in between matters — the customer won't buy regardless of product, offer, or channel quality. Great brands build this bridge intentionally. Weak brands let it happen by accident — and are surprised when "perfect" campaigns fail.

### 8. The Competitive Matrix
Competitor analysis is NOT part of L7. L7 is macro market forces. Competitors are analyzed in a parallel matrix across L2–L6 — one column per competitor, one row per layer. L0 and L1 are internal — competitors' L0/L1 can only be inferred from language markers.

### 9. The Shadow
Every layer has a "shadow" — a hidden assumption the client holds that prevents them from seeing the real problem. Part of the diagnosis is making the shadow visible. L0's shadow is the most dangerous: transparent beliefs that the owner doesn't experience as beliefs at all.

### 10. The L0→L1 Cascade
L0 (Source) problems make L1 (Core) problems permanent. You can recommend hiring a marketing director (L1 fix), but if the owner's identity prevents delegation (L0), they'll hire one and override every decision. Always check: is this L1 problem structural, or is L0 creating it?

---

## Competitive Matrix (2D Analysis)

The 7-Layer model is one-dimensional by default — it analyzes one company. The Competitive Matrix makes it two-dimensional: the client in one column, major competitors in parallel columns, analyzed across L2–L6.

### Why This Exists

Competitor analysis does NOT belong in L7. L7 is macro market forces. When you stuff competitor details into L7, the client can't process it — everything becomes a wall of data.

The Competitive Matrix creates a visual, scannable view: where are the gaps? Where is the client blocked? Where is there an opening that no competitor has claimed?

### Structure

```
COMPETITIVE MATRIX: [Client] vs. Market

| Layer              | [Client]    | [Competitor A] | [Competitor B] | [Competitor C] | Gap/Opportunity |
|--------------------|-------------|----------------|----------------|----------------|-----------------|
| L6: Customer       | [findings]  | [findings]     | [findings]     | [findings]     | [where's the gap?] |
| L5: Channels       | [findings]  | [findings]     | [findings]     | [findings]     | [where's the gap?] |
| L4: Offer          | [findings]  | [findings]     | [findings]     | [findings]     | [where's the gap?] |
| L3: Product        | [findings]  | [findings]     | [findings]     | [findings]     | [where's the gap?] |
| L2: Identity       | [findings]  | [findings]     | [findings]     | [findings]     | [where's the gap?] |

L7 (Market) is the same for all — macro forces affect everyone equally.
L0 (Source) and L1 (Core) are internal — competitors' L0/L1 can only be inferred, not directly observed.
```

### When to Use

- **Mode 2 (Pattern Map):** Always include a Competitive Matrix for 3–6 major competitors. For large markets (retail, e-commerce), map 5–10+ including small emerging players.
- **Mode 3 (Constraint Drill):** When the constraint is at L3-L5, the matrix reveals whether it's a company problem or a market-wide pattern.
- **Strategic engagements (Wallis, Diego, Euronics scale):** The matrix IS the strategic tool — it shows where the client can win and where they're structurally blocked.

### Key Insight

When the matrix shows no gaps at ANY layer — no opening where the client beats competitors — the diagnosis shifts from "fix the marketing" to "change the game." Either find a new positioning angle that competitors can't follow, or accept that the market position is shrinking.

> "If you see your competitor analyzed across every layer, and there's no gap to exploit, the answer isn't better ads. The answer is: change something fundamental, or leave."

---

## Common Cascade Patterns

### "Third Agency, Same Results" Cascade
```
L0: Owner identity prevents delegation (Source)
    "If I don't control it, it fails"
        │
        ▼
L1: No internal strategy ownership (Core)
        │
        ▼
L2: Identity and value proposition unclear — agency guesses (Identity)
        │
        ▼
L5: Agency optimizes wrong metric at wrong layer (Channels)
        │
        ▼
SYMPTOM: "Third agency, same results"
```

### "We Can't Grow" Cascade
```
L0: Worthy/Unworthy identity pattern (Source)
    "I'm not worth more" → transparent belief
        │
        ▼
L2: Identity unclear, value not communicated (Identity)
        │
        ▼
L4: Offer underpriced, no urgency (Offer)
        │
        ▼
SYMPTOM: "We can't grow past this revenue ceiling"
```

### "Ads Aren't Working" Cascade
```
L1: No one owns marketing strategy (Core)
        │
        ▼
L3: Product isn't differentiated (Product)
        │
        ▼
L5: Ads compete on price because nothing else differentiates (Channels)
        │
        ▼
SYMPTOM: "Ads aren't working, ROAS declining"
```

### "Great Report, Nothing Changed" Cascade
```
L0: CRASH state — identity-level resistance (Source)
    Owner cannot SEE their beliefs as beliefs (transparent belief)
        │
        ▼
L1: Recommendations accepted but not executed (Core)
        │
        ▼
SYMPTOM: "Client got the diagnosis, nothing changed"
    Every fix stalls at implementation
```

### "Brand Doesn't Connect" Cascade
```
L0: "We're for everyone" belief (Source)
        │
        ▼
L6: No specific customer definition (Customer)
        │
        ▼
L3: Product tries to solve everything (Product)
        │
        ▼
L5: Scattered across all channels (Channels)
        │
        ▼
SYMPTOM: "Brand doesn't resonate"
```

---

## Real Examples

### Feldobox
**Client question:** "Can we scale spending outside Christmas?"

```
L7: "Christmas = gift season" (belief)
        │
        ▼
L6: Christmas-only customer focus ◄── PRIMARY BLOCKAGE
        │
        ▼
L1: No competitor tracking year-round
        │
        ▼
L2: Website too restrained — identity and value not visible (Identity)
        │
        ▼
L4: No urgency in offer (Offer)
        │
        ▼
SYMPTOM: "Can't scale outside Christmas"
```

### Euronics
**Client question:** "CPC rising, can't scale with ROAS"

```
L1: Targeting too broad (Core)
        │
        ▼
L3: Not differentiated from MediaMarkt/Alza (Product)
        │
        ▼
L5: Competing on price = high CPCs (Channels)
        │
        ▼
L4: No measurement of what works (Offer)
        │
        ▼
SYMPTOM: "Can't scale profitably"
```

---

## Integration with Other Skills

```
/7layer (Mode 1)  →  Entry point. Quick diagnosis. The Röntgen.
/7layer (Mode 2)  →  Full Pattern Map (L0–L7) for deep engagement.
/7layer (Mode 3)  →  Drill into specific constraint layer.

AFTER DIAGNOSIS → REPAIR PLANNING:
/7layer → Constraint mapping    Classify what can't change (Type 1/2/3), calculate ceiling
/7layer → Repair roadmap        Build layer-by-layer repair plan with exit criteria

REPAIR-SPECIFIC:
/7layer → Belief tracing        Find the L0 transparent belief creating the constraint
/7layer → Identity-pattern map  Map the L0 identity pattern (Helper/Martyr, etc.)
/7layer → Vevőkutatás           Map the customer's actual purpose (if L6 is constraint)
/7layer → /build-brand          Rebuild identity and positioning (if L2 is constraint)
/7layer → Offer refinement      Rebuild the offer (if L4 is constraint)
/7layer → /analyze-gtm          Check GTM alignment against Pattern Map
/7layer → /plan-gtm             Build execution plan from diagnosis
/7layer → Copy analysis         Check if messaging reflects the fix

L0 DIAGNOSTIC TOOLS:
/7layer finds WHERE the problem is (L0–L7)
Belief tracing finds the L0 belief creating it
Identity-pattern mapping surfaces the identity pattern at L0
COACH/CRASH state check = L0 readiness assessment before presenting findings

COMBINING WITH CUSTOMER RESEARCH:
Job 1 = diagnosis (WHERE) — /7layer
Job 2 = fix it (requires L0 shift if beliefs block implementation)
Job 3 = become capable (L0→L1 transformation — identity shift enables capability)
```

---

## The Fractional CMO Application

### Térkép (Map) — Months 1-2
Run `/7layer` Mode 1 (Röntgen) first. Then Mode 2 (Pattern Map) for the full L0–L7 picture. This IS the Térkép phase — making visible what's invisible. L0 often only surfaces during deeper engagement.

### Rendszer (System) — Months 2-4
Run the constraint-mapping step to classify what can and can't change. Then build a layer-by-layer repair plan with exit criteria per layer. Use Mode 3 (Constraint Drill) on each layer that needs fixing, in order of depth. Each layer fix is measured and validated before moving to the next. If L0 is the root, system work includes coaching through belief shifts. If layers are locked, apply constrained repair strategies (see `REPAIR_FRAMEWORK_CONSTRAINED.md`).

### Változás (Change) — Ongoing
The Pattern Map + Repair Roadmap become the operating system. Weekly: "Which layer are we working on? What proof do we have? What's the next constraint?" Every 90 days: review the Constraint Map — walls move, sacred cows die, L0 blocks soften. Marketing becomes controllable, not chaotic.

---

## If No Business Context Provided

Ask:
> "What business should I diagnose? I need:
> - What they sell
> - Who they sell to (if known)
> - Current marketing challenges or symptoms
> - Any data points (revenue, traffic, conversion, spend)
> - What they've already tried
>
> Or just share their website — I can start from there."
>
>
