---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
argument-hint: client slug
---

# Skill: Repair Roadmap (`/repair-roadmap`)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

Builds a layer-by-layer repair plan from a completed 7-Layer diagnosis and Constraint Map. Follows the Direction Rule (repair deepest broken layer first), applies exit criteria per layer, and accounts for locked layers using constrained repair strategies. Outputs an actionable roadmap with WHO does WHAT by WHEN, measured by WHAT PROOF.

**The Core Principle:**
> "A layer is not repaired when the action is taken. A layer is repaired when the proof confirms it holds."

## Source References
- **Repair Framework** — `methodology/REPAIR_FRAMEWORK.md`
- **Constrained Repair Framework** — `methodology/REPAIR_FRAMEWORK_CONSTRAINED.md`
- **7-Layer Marketing Control Framework** — `methodology/7LAYER_SUMMARY.md`
- **Constraint Map** — from `/identify-constraints`

## Trigger

Use this skill when:
- 7-Layer diagnosis is complete and the client asks "now what?"
- Building a Prism deliverable — the repair roadmap IS the action plan
- Starting a Fixer engagement — this becomes the operating plan
- Client has a previous diagnosis but nothing was implemented
- Re-scoping after constraints changed (90-day review)

## Prerequisites

Before running this skill, you need:
1. **7-Layer diagnosis** (Mode 1 or Mode 2) — from `/7layer`
2. **Constraint Map** (recommended) — from `/identify-constraints`
3. If no Constraint Map: assume all layers are unlocked (standard repair)

## Process

### Step 1: Identify Broken Layers

From the 7-Layer diagnosis, list all layers with status "Needs Attention" or "Constraint":

```
BROKEN LAYERS: [Company Name]

| Layer | Status | Primary Finding | Locked? |
|-------|--------|-----------------|---------|
| L0 | [status] | [finding] | [yes/no + type] |
| L1 | [status] | [finding] | [yes/no + type] |
| ... | | | |
```

### Step 2: Determine Repair Sequence (Direction Rule)

**Standard (unconstrained):** Repair deepest broken layer first, move outward.

```
L0 → L1 → L2 → L3 → L4 → L5 → L6 → L7
(deepest first)
```

**Constrained:** Skip locked layers. Repair deepest UNLOCKED broken layer first. Apply locked-layer strategies in parallel.

```
Example: L0 locked, L1 broken, L2 broken, L5 broken

Repair sequence:
1. L1 (deepest unlocked broken layer)
2. L2 (next)
3. L5 (next)
+ L0 strategy running in parallel (buffer / prove / side door)
```

### Step 3: Define Exit Criteria Per Layer

For each broken layer, define what "fixed" means — measurable, observable, testable.

**L0: Source — Exit Criteria**
- Owner can name their own belief pattern
- Delegation test: one decision delegated and stands for 30 days
- Owner's language shifts from "I can't" to "I haven't yet"
- First L1 change implemented without owner reversal

**L1: Core — Exit Criteria**
- Measurement dashboard exists and shows last 30 days of data
- Someone owns marketing/sales strategy (name, not title)
- Average decision turnaround < X days (set per client)
- Tasks assigned vs. tasks completed ratio > 70%

**L2: Identity — Exit Criteria**
- One identity sentence everyone can say consistently
- Website reflects actual identity (not generic template)
- Decoded check: 5 external people describe company correctly
- Brand voice guide exists AND is used (including AI tools)

**L3: Product — Exit Criteria**
- Product differentiation visible above the fold on product pages
- Guidance system exists and is used (X uses/week)
- Customer feedback mentions differentiation
- Conversion rate on product pages improved (before/after)

**L4: Offer — Exit Criteria**
- At least one guarantee or risk reversal exists
- Average order value increased measurably
- Conversion rate increased measurably
- Offer has clear value framing (not just price)

**L5: Channels — Exit Criteria**
- Every active channel speaks in L2 voice with L4 offer
- At least one channel has proven ROI with new positioning
- Email generates measurable revenue (from dormant to active)
- Sales pitch matches marketing message (Unity Principle verified)

**L6: Customer — Exit Criteria**
- 2-4 segments defined with specific JTBD
- Customer identity articulated
- L2↔L6 Identity Bridge verified
- Segmented communication exists

**L7: Market — Exit Criteria**
- Competitive matrix completed (L2-L6 per competitor)
- Market position is a stated, conscious choice
- Strategic response defined: compete, differentiate, or exit

### Step 4: Validate Repair Direction via ACH

> Before committing to a repair sequence, verify the diagnosis using ACH from /identify-constraints.

If the Constraint Map includes an ACH section (competing hypotheses):

1. **Check the leading hypothesis** — does the repair sequence align with it?
2. **Check the falsification indicator** — build it into the first milestone as a validation gate
3. **Design for the alternative** — if the leading hypothesis is wrong, which repair card changes first?

```
REPAIR DIRECTION VALIDATION:

Leading hypothesis: H[X] — [name]
Repair sequence aligns: [yes/no — explain if no]

VALIDATION GATE (built into Month 1):
"If [falsification indicator] is observed by [date], STOP and reassess.
Switch to repair sequence for H[Y] instead."

ALTERNATIVE REPAIR SEQUENCE (if H[X] is wrong):
[different layer order or strategy]
```

If no ACH was done (e.g., First Signal engagement), note this as a limitation:
> "No competing hypotheses tested. Repair sequence based on single interpretation. Recommend ACH review at 90-day checkpoint."

### Step 5: Build the Repair Roadmap

For each broken layer (in sequence), define:

```
LAYER REPAIR CARD: L[X] — [Name]

CONSTRAINT (from diagnosis):
[What is broken at this layer]

EXIT CRITERIA:
[What "fixed" looks like — measurable]

MINIMUM FIX (smallest action that proves the layer can hold):
[The one thing to do first]

FULL REPAIR ACTIONS:
| # | Action | Who | Timeline | Depends on |
|---|--------|-----|----------|------------|
| 1 | [action] | [Arcanian / Client / Developer / Third party] | [week/month] | [prerequisite] |
| 2 | ... | ... | ... | ... |

PROOF (how we know it worked):
[Specific metric or observation]

WHAT BLOCKS THIS REPAIR:
[L0 pattern or constraint that might prevent it]

WHAT OPENS UP WHEN FIXED:
[Which outer layers improve]
```

### Step 6: Build the Timeline

Map all layer repairs onto a realistic timeline:

```
REPAIR TIMELINE: [Company Name]

         Month 1        Month 2        Month 3        Month 4-6      Month 6+
         ━━━━━━━        ━━━━━━━        ━━━━━━━        ━━━━━━━━━      ━━━━━━━
L0:      [action]       [action]       [ongoing]      [ongoing]      [ongoing]
L1:      [action]       [action]       [verify]       ✅
L2:                     [action]       [action]       [verify]       ✅
L3:                                    [action]       [action]       [verify]
L4:                                    [quick fix]    [full repair]  [verify]
L5:                                                   [activate]     [optimize]
L6:                                                   [segment]      [personalize]
L7:                                                                  [review]

MILESTONES:
□ Month 1: Measurement works (L1 gate)
□ Month 2: Identity visible on website (L2 gate)
□ Month 3: First channel shows improved results (L5 proof)
□ Month 6: Ceiling reached or constraints reassessed
```

### Step 7: Set Review Points

```
REVIEW CADENCE:

Weekly:    Which layer are we working on? What's stuck?
Monthly:   Layer status update. Any exit criteria met?
90 days:   Full constraint review. Did any walls move?
           Ceiling recalculation. Scope adjustment if needed.
```

## Output Format

```
## REPAIR ROADMAP: [Company Name]

### Date: [Date]
### Based on: 7-Layer Diagnosis ([date]) + Constraint Map ([date])
### Engagement: [First Signal / Prism / The Fixer]
### Ceiling: [X]% (based on [N] locked layers)

---

### Current State Summary

| Layer | Status | Primary Finding | Locked? |
|-------|--------|-----------------|---------|
| L0 | ... | ... | ... |
| L1 | ... | ... | ... |
| L2 | ... | ... | ... |
| L3 | ... | ... | ... |
| L4 | ... | ... | ... |
| L5 | ... | ... | ... |
| L6 | ... | ... | ... |
| L7 | ... | ... | ... |

**Primary constraint:** L[X]
**Repair sequence:** L[X] → L[X] → L[X] → ...
**Locked layers:** [list + strategies]

---

### Layer Repair Cards

[One card per broken layer, in repair sequence order]

#### L[X] — [Name] (REPAIR PRIORITY [N])

**Constraint:** [what's broken]
**Exit criteria:** [what "fixed" looks like]
**Minimum fix:** [smallest first action]

| # | Action | Who | Timeline | Proof |
|---|--------|-----|----------|-------|
| 1 | ... | ... | ... | ... |

**Blocked by:** [constraint or L0 pattern]
**Opens up:** [outer layers that improve]

---

### Timeline

[Month-by-month visual or table]

---

### Milestones & Gates

| # | Milestone | Layer | When | Gate condition |
|---|-----------|-------|------|----------------|
| 1 | Measurement works | L1 | Month 1 | Dashboard shows 30 days of data |
| 2 | Identity on website | L2 | Month 2 | Decoded check passes (3/5) |
| ... | | | | |

---

### Locked Layer Strategies (running in parallel)

| Locked layer | Strategy | First action | Review date |
|-------------|----------|-------------|-------------|
| L[X] | [buffer/prove/automate/side door] | [action] | [90-day review] |

---

### Review Cadence

- **Weekly:** [what to check]
- **Monthly:** [what to measure]
- **90-day:** Constraint Map review + ceiling recalculation

---

### What Success Looks Like

**At ceiling ([X]%):**
[Description of the best possible outcome given current constraints]

**If constraints unlock:**
[Description of what becomes possible]

---

### Anti-Patterns to Avoid

| Don't | Do instead |
|-------|-----------|
| Fix L5 first because it's "quick" | Fix deepest break first (Direction Rule) |
| Fix everything at once | One layer at a time, prove it holds |
| Skip L0 because "it's just beliefs" | At minimum: name the pattern, delegation test |
| Measure activity ("we sent 4 emails") | Measure outcomes ("email revenue increased") |
| Accept "persze, persze" as commitment | Require proof: delegated decision stands 30 days |
```

## Integration with Other Skills

```
FULL ARCANIAN WORKFLOW:

/7layer                  → Diagnose WHERE it's broken (L0-L7)
/identify-constraints    → Classify WHAT can't change (Type 1/2/3)
/repair-roadmap          → Plan HOW to fix it (this skill)
                         → EXECUTE (The Fixer engagement)

REPAIR-SPECIFIC INTEGRATIONS:

L0 repair needed → /trace-belief + /belief-profile
L2 repair needed → /build-brand
L3 repair needed → /jtbd (product differentiation via customer jobs)
L4 repair needed → /craft-offer (Hormozi Value Equation)
L5 repair needed → /analyze-gtm + /plan-gtm
L6 repair needed → /jtbd (customer jobs + identity)
L7 repair needed → Competitive Matrix (from /7layer Mode 2)

PRISM DELIVERABLE:
/7layer Mode 2 → /identify-constraints → /repair-roadmap
= The complete Prism package (diagnosis + constraints + repair plan)

THE FIXER OPERATING PLAN:
/repair-roadmap output = the month-by-month operating plan
Weekly check: "Which layer? What proof? What's next?"
```

## Key Principles

### 1. Direction Rule
Repair deepest broken layer first. Outer fixes are wasted if inner layers are broken. L0→L7.

### 2. Exit Before Advance
A layer is not repaired when the action is taken. It's repaired when the proof confirms it holds. Don't move outward until the current layer's exit criteria are met.

### 3. Minimum Fix First
Start with the smallest action that proves the layer CAN hold. Don't over-engineer the first repair. Text swap before rebrand. One email before automation. One delegated decision before org restructure.

### 4. Proof, Not Activity
"We updated the website" is not proof L2 is fixed. "5 out of 5 people described us correctly" is proof. Measure the exit criteria, not the task list.

### 5. Constraints Are Part of the Plan
Locked layers aren't failures — they're boundary conditions. The roadmap explicitly accounts for them. The ceiling is transparent. No surprises.

### 6. 90-Day Review
Constraints change. Sacred cows die. L0 blocks soften. Hard constraints expire. Review the map, recalculate the ceiling, adjust the roadmap. Every 90 days.

### Pattern Reference
This skill implements the **Constraint Cascade Pattern** — findings gate downstream phases via ACH validation. See `core/methodology/CONSTRAINT_CASCADE_PATTERN.md`.

### 7. The Unity Principle
Sales and marketing repair happens on the same layers. An outbound sales fix (L5) and a campaign fix (L5) share the same root cause. Don't create separate repair tracks for sales and marketing — they're one system.
