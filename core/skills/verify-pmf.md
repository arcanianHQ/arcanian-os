# Skill: PMF Verification (`/verify-pmf`)

> **Data Sufficiency Check applies.** Every signal must be tagged [DATA], [INFERRED], or [UNKNOWN].
> **Temporal Awareness applies.** Identify exact dates, check holidays/seasonality before flagging anomalies. See `core/methodology/TEMPORAL_AWARENESS_RULE.md`.
> **Discovery, not pronouncement.** PMF is not binary — it's a spectrum. Show where you are on it.
> **"We don't know yet" is the most common — and most honest — answer.**

## Purpose

Systematically checks Product-Market Fit signals for a product/offer by pulling real data from connected systems (AC pipeline, GitHub, Databox, Todoist, Asana, Fireflies) and scoring against a framework. Not theory — evidence-based PMF assessment.

## Trigger

Use when: "verify PMF", "product market fit", "is there PMF", "check if people want this", "are we getting traction", "PMF check"

## Input

| Input | Required | Default |
|---|---|---|
| `product` | Yes | Context from conversation |
| `period` | No | Since launch |
| `depth` | No | `full` (all 5 layers) or `quick` (demand + usage only) |

## The 5 PMF Layers

PMF is not one signal — it's five layers that build on each other. Each layer must be verified independently. A higher layer cannot be confirmed if the layer below it is unverified.

```
Layer 5: ADVOCACY — do they tell others? (organic pull)
Layer 4: REVENUE — will they pay? (willingness to pay)
Layer 3: RETENTION — do they come back? (repeated use)
Layer 2: ACTIVATION — do they use it? (first value moment)
Layer 1: DEMAND — do people want it? (inbound interest)
```

**Each layer depends on the one below.** You cannot have retention without activation. You cannot have advocacy without retention. Skipping layers = false PMF.

## Execution Steps

### Step 0: Data Sufficiency Check
> **Temporal Awareness applies.** Identify exact dates, check holidays/seasonality before flagging anomalies. See `core/methodology/TEMPORAL_AWARENESS_RULE.md`.

Before anything, identify what data sources are available:

| Source | What it tells us | How to query |
|---|---|---|
| **AC pipeline** | Registrations, lead tags, follow-up status | AC MCP or manual check |
| **GitHub** | Clones, stars, forks, issues opened, contributors | `gh` CLI |
| **Databox** | Product usage metrics (if instrumented) | Databox MCP |
| **Todoist/Asana** | @waiting follow-ups, partnership status | Todoist/Asana MCP |
| **Fireflies** | Meeting transcripts with leads — what did they say? | Fireflies MCP |
| **LinkedIn** | Post engagement, DMs, comments quality | Manual — screenshot or paste |
| **Email** | Direct inbound emails | Manual |
| **Revenue** | Stripe, invoices, bank | Manual — ask user |

Classify each as AVAILABLE / PARTIAL / MISSING. Proceed with warnings if needed.

### Step 1: Layer 1 — DEMAND

**Question:** Do people want this? Do they come to us, or do we go to them?

**Signals to check:**

| Signal | Where to find | Strong indicator | Weak indicator |
|---|---|---|---|
| Inbound requests | AC pipeline, DMs, email | Unsolicited — they found us | We had to push/promote |
| Quality of requests | DM content, Fireflies | "How do I get access?" (pull) | "Interesting" with no action (browse) |
| Source diversity | AC tags, LinkedIn | Multiple independent sources | All from one post/person |
| Request specificity | DM content | "Can this work for my [specific problem]?" | "This looks cool" |
| Unprompted sharing | LinkedIn reshares | Someone shares without us asking | Only we share |

**Scoring:**

| Score | Meaning | Evidence needed |
|---|---|---|
| 🔴 0 — No demand | No inbound, only outbound push | Zero unsolicited requests |
| 🟡 1 — Curiosity | Some inbound, but vague interest | "Interesting" comments, no action |
| 🟢 2 — Pull | Unsolicited requests with specific intent | "How do I get access?", "Can this work for X?" |
| 🟢 3 — Urgency | People push to get it faster | "Can I get early access?", DMs within hours |

### Step 2: Layer 2 — ACTIVATION

**Question:** Do they actually use it? Is there a "first value moment"?

**Signals to check:**

| Signal | Where to find | Strong indicator | Weak indicator |
|---|---|---|---|
| First skill run | GitHub activity, user reports | Ran `/health-check` or `/sales-pulse` successfully | Cloned repo but never ran anything |
| Databox connected | User reports | Connected their own data | Using demo data only |
| Time to first value | Follow-up conversations | "It found something" within first session | Took weeks to set up |
| Setup completion | User reports | Finished CLAUDE.md + first client scaffold | Stalled at MCP configuration |
| Questions asked | GitHub issues, DMs | Specific usage questions ("how do I configure X?") | No questions (= not trying) |

**Scoring:**

| Score | Meaning | Evidence needed |
|---|---|---|
| 🔴 0 — No activation | Cloned/registered, never used | Zero usage reports, no issues opened |
| 🟡 1 — Attempted | Tried but got stuck | Setup questions, configuration issues |
| 🟢 2 — First value | Ran a skill, got a useful output | "It found something my dashboard missed" |
| 🟢 3 — Configured | Set up their own client, connected their data | Running on their own data, not demo |

### Step 3: Layer 3 — RETENTION

**Question:** Do they come back? Is this a one-time experiment or ongoing use?

**Signals to check:**

| Signal | Where to find | Strong indicator | Weak indicator |
|---|---|---|---|
| Repeat usage | User reports, GitHub commits | Using weekly for 2+ weeks | Used once, never returned |
| Workflow integration | Conversations | "This is part of my Monday morning now" | "I tried it that one time" |
| Feature requests | GitHub issues, DMs | "Can you add X?" (= using it enough to want more) | No requests (= not using) |
| Customization | GitHub forks, user reports | Modified CLAUDE.md, added own skills | Running stock version unchanged |
| Bug reports | GitHub issues | Found bugs (= actually using it) | No bugs reported (= not using) |

**Scoring:**

| Score | Meaning | Evidence needed |
|---|---|---|
| 🔴 0 — No retention | One-time use, abandoned | Zero engagement after first week |
| 🟡 1 — Occasional | Returns sporadically | Used 2-3 times over a month |
| 🟢 2 — Regular | Weekly use, part of workflow | 2+ weeks consistent use |
| 🟢 3 — Dependent | Can't work without it | "How did we do this before?" |

### Step 4: Layer 4 — REVENUE

**Question:** Will they pay? Is there willingness to exchange money for this?

**Signals to check:**

| Signal | Where to find | Strong indicator | Weak indicator |
|---|---|---|---|
| Installation bookings | AC pipeline, calendar | Booked and paid for setup session | "Maybe later" |
| Pricing questions | DMs, email | "How much for the full configuration?" | No pricing discussion |
| Unprompted budget | Conversations | "We have budget for this" | "Is it free?" only |
| Upgrade requests | Conversations | "Can you set it up for all our clients?" | Single-client testing only |
| Referral with context | DMs | "I told my colleague, they want it too" | "Cool project" share |

**Scoring:**

| Score | Meaning | Evidence needed |
|---|---|---|
| 🔴 0 — No revenue signal | Nobody asked about paying | Zero pricing conversations |
| 🟡 1 — Interest | Asked about pricing, no commitment | "How much?" without follow-through |
| 🟢 2 — First revenue | One paying customer | €250+ installation booked and paid |
| 🟢 3 — Repeatable | Multiple paying customers, pattern visible | 3+ installations, referral-driven |

### Step 5: Layer 5 — ADVOCACY

**Question:** Do they tell others without us asking?

**Signals to check:**

| Signal | Where to find | Strong indicator | Weak indicator |
|---|---|---|---|
| Organic mentions | LinkedIn, Twitter, blogs | Someone writes about it unprompted | Only we post about it |
| Referrals | AC pipeline (source tracking) | "X told me about this" | All leads from our own posts |
| Case studies | Conversations | "Can I share what we built with this?" | Only we write case studies |
| Community | GitHub stars/forks, discussions | Others contribute, open PRs | Only we maintain |
| Word of mouth | Fireflies, DMs | Third-degree connections reach out | Only first-degree connections |

**Scoring:**

| Score | Meaning | Evidence needed |
|---|---|---|
| 🔴 0 — No advocacy | Nobody talks about it | Zero organic mentions |
| 🟡 1 — Prompted | They share when asked | Reshares our posts but don't create their own |
| 🟢 2 — Organic | They create content about it | Blog post, LinkedIn post, tutorial — unprompted |
| 🟢 3 — Evangelical | They actively recruit others | "You HAVE to try this" in their own conversations |

## Output Template

```
===================================================================
PMF VERIFICATION — {Product}
Since {launch date} | {N} days | Depth: {full/quick}
===================================================================

DATA SUFFICIENCY
-----------------
AVAILABLE: {list}
PARTIAL: {list}
MISSING: {list}

===================================================================
PMF SCORE CARD
===================================================================

| Layer | Score | Evidence | Confidence |
|---|---|---|---|
| 1. DEMAND | {0-3} {emoji} | {key evidence} | [DATA/INFERRED/UNKNOWN] |
| 2. ACTIVATION | {0-3} {emoji} | {key evidence} | [DATA/INFERRED/UNKNOWN] |
| 3. RETENTION | {0-3} {emoji} | {key evidence} | [DATA/INFERRED/UNKNOWN] |
| 4. REVENUE | {0-3} {emoji} | {key evidence} | [DATA/INFERRED/UNKNOWN] |
| 5. ADVOCACY | {0-3} {emoji} | {key evidence} | [DATA/INFERRED/UNKNOWN] |

OVERALL PMF STATUS: {see below}

===================================================================
PMF STAGE
===================================================================

| Stage | Score Range | Meaning |
|---|---|---|
| ❌ NO PMF | All layers 0-1 | No evidence of fit |
| 🟡 PRE-PMF | Layer 1 = 2+, rest 0-1 | Demand exists, usage unproven |
| 🟠 APPROACHING | Layers 1-2 = 2+, rest 0-1 | People want AND use it, but don't pay/stay |
| 🟢 PMF DETECTED | Layers 1-3 = 2+ | Want + use + come back = fit confirmed |
| 🟢🟢 STRONG PMF | Layers 1-4 = 2+ | Fit + revenue = business model works |
| 🟢🟢🟢 PMF FLYWHEEL | All 5 layers = 2+ | Self-reinforcing growth |

Current stage: {stage}

===================================================================
LAYER DETAILS
===================================================================

### Layer 1: DEMAND
{detailed evidence per signal}

### Layer 2: ACTIVATION
{detailed evidence per signal}

### Layer 3: RETENTION
{detailed evidence per signal}

### Layer 4: REVENUE
{detailed evidence per signal}

### Layer 5: ADVOCACY
{detailed evidence per signal}

===================================================================
AMIT NEM TUDUNK (What We Don't Know)
===================================================================

| Question | Why we don't know | What we'd need | Impact |
|---|---|---|---|
| {question} | {reason} | {data needed} | {how it affects PMF assessment} |

===================================================================
NEXT ACTIONS TO ADVANCE PMF
===================================================================

Current bottleneck: Layer {N} — {name}

| # | Action | Purpose | Owner | Due |
|---|---|---|---|---|
| 1 | {action} | Advance from Layer {N} score {X} to {Y} | {owner} | {date} |

===================================================================
PMF TIMELINE
===================================================================

{Visual timeline of when each layer was first confirmed}

Week 1: Layer 1 confirmed (demand — Pete's post)
Week 2: Layer 2 TBD (activation — first user runs a skill)
Week ??: Layer 3 TBD (retention — weekly use)
Week ??: Layer 4 TBD (revenue — first payment)
Week ??: Layer 5 TBD (advocacy — organic mention)

What did we get wrong? What signals are we missing?
```

## PMF Check Cadence

| Frequency | When | What to check |
|---|---|---|
| **Weekly** (first month) | Every Monday | All 5 layers — things move fast early |
| **Bi-weekly** (month 2-3) | Every other Monday | Layers 2-5 (demand is established or not) |
| **Monthly** (after month 3) | First Monday | Full check — are layers holding or degrading? |

## Notes

- PMF is not permanent. It can degrade (product stales, market shifts, competition appears)
- Score 2 on Layer 1-3 = minimum viable PMF. Everything below is pre-PMF.
- The most dangerous state: Layer 1 = 3, Layer 2 = 0. "Everyone wants it, nobody uses it" = the product is a story, not a tool.
- Pete's endorsement is Layer 1 + Layer 5 simultaneously (he advocated without us asking). But Layer 2-4 are unverified.
- Pairs with: `/pipeline` (lead tracking), `/health-check` (system health), `/validate-idea` (pre-launch validation)
