---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
argument-hint: "client — Client slug (e.g., wellis, diego)"
---

# Skill: Analyze GTM Gaps (GTM Strategist Framework)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.
Analyzes a business's Go-To-Market strategy against the complete GTM Strategist framework to identify gaps, weaknesses, and opportunities. Provides a clear diagnosis of what's missing or underperforming before action planning.

> **Multi-domain prerequisite:** If `CLIENT_CONFIG.md` lists 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Filter all channel/ROAS/spend queries by domain. Never use account-level totals as domain metrics. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. Only DATA and OBSERVED can be CC in ACH. Split confidence: data confidence ≠ causal confidence. GA4 alone is insufficient for causal diagnosis — always check platform-side data (Meta Ads Manager, Google Ads, etc.). See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Attribution windows:** Before comparing conversion metrics across platforms, load `core/methodology/ATTRIBUTION_WINDOWS.md`. Google Ads (30d click) ≠ Meta (7d click) ≠ GA4 (data-driven). Flag window mismatches. Never sum platform conversions. Use GA4 as cross-platform arbitrator.

> **Currency normalization:** Before summing monetary values across domains/markets, load `core/methodology/CURRENCY_NORMALIZATION.md`. Convert to client's reporting currency. State conversion rate and source.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`.

**The Core Principle:**
> "A go-to-market strategy is the difference between a hope and a plan."
> — J.P. Eggers, NYU Stern School of Business

## Source Reference
From **"Go-To-Market Strategist" by Maja Voje** (Growth Lab)

## Trigger
Use this skill when:
- Customer is launching a new product/service
- Current GTM isn't producing results
- Customer feels "stuck" in growth
- Before creating a GTM action plan
- Customer is unsure where to focus GTM efforts
- Pivoting to a new market or segment

## The GTM Framework

### The 6 Core GTM Decisions

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         GTM STRATEGIST FRAMEWORK                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. MARKET          "What terrain should we win?"                       │
│     └── Beachhead segment, TAM/SAM/SOM, competition, timing             │
│                                                                          │
│  2. EARLY CUSTOMER  "Who do we serve FIRST?"                            │
│     └── ECP (not ICP), niche down, validation                           │
│                                                                          │
│  3. PRODUCT         "What value do we deliver?"                         │
│     └── MVP, value proposition, PMF signals                             │
│                                                                          │
│  4. PRICING         "How do we capture value?"                          │
│     └── Value-based pricing, WTP, business model                        │
│                                                                          │
│  5. POSITIONING     "How do we stand out?"                              │
│     └── Differentiation, messaging, branding                            │
│                                                                          │
│  6. GROWTH          "How do we acquire customers?"                      │
│     └── Channels, growth loops, demand gen vs capture                   │
│                                                                          │
│  + GTM SYSTEM       "How do we execute?"                                │
│     └── OKRs, North Star Metric, experimentation, team                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Gap Analysis Framework

### 1. MARKET Analysis

**Key Questions:**
- Have you selected a Beachhead Segment?
- Can you win this segment in 18 months or less?
- Does this segment have high pain for your solution?
- Is there adequate willingness to pay?
- Is the market healthy enough to support growth?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "We can serve everyone" | No Beachhead Strategy |
| "We're competing with giants" | Wrong market selection |
| No TAM/SAM/SOM numbers | No market sizing |
| "We don't have competitors" | Market doesn't exist OR poor research |
| "Timing feels off" | Market not ready or too late |

**What Good Looks Like:**
- Clear Beachhead Segment (can win 30-50% in 18 months)
- Segment has urgent, painful problem
- Segment has budget and willingness to pay
- Clear expansion path to adjacent segments
- Competition exists (validates demand) but is beatable

---

### 2. EARLY CUSTOMER PROFILE (ECP) Analysis

**Key Questions:**
- Do you have a specific ECP defined (not just "demographics")?
- Have you validated ECP assumptions with real conversations?
- Is your ECP narrow enough to create critical mass?
- Do you know their decision-making process?
- Can you easily find and reach this ECP?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "Our target is SMBs" | Too broad, no niche |
| Never talked to prospects | ECP is assumption, not validated |
| Multiple conflicting ECPs | Scattered focus |
| "We built first, now finding customers" | Product-first, not customer-first |
| Can't describe ECP's daily challenges | Surface-level understanding |

**What Good Looks Like:**
- ECP is specific: industry, company size, role, situation
- Validated through 15-25+ discovery conversations
- You know their alternatives and decision criteria
- You know WHERE to find them (channels, communities)
- ECP is narrow enough to dominate, big enough to matter

**ECP vs ICP:**
- **ECP (Early Customer Profile):** For GTM - who to target FIRST
- **ICP (Ideal Customer Profile):** For Growth - who to target at SCALE

---

### 3. PRODUCT Analysis

**Key Questions:**
- Is your product a painkiller or a vitamin?
- What is your core value proposition (in customer's words)?
- Do you have MVP or are you overbuilding?
- Are you tracking product-market fit signals?
- What is your North Star Metric?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "Nice to have" feedback | Vitamin, not painkiller |
| Features keep growing | No MVP discipline |
| "We need more features to sell" | Value prop unclear |
| No retention/engagement data | Not measuring PMF |
| "Our NPS is high but sales are low" | Wrong metric focus |

**What Good Looks Like:**
- Clear value prop: "We help [ECP] achieve [outcome] by [mechanism]"
- MVP is live and being tested with real users
- North Star Metric defined and tracked
- Early PMF signals: retention, referrals, willingness to pay
- Product solves urgent, painful problem (not "nice to have")

**North Star Metric by Game Type:**

| Game | Focus | NSM Examples |
|------|-------|--------------|
| **Attention** | Time captured | DAU, time in product |
| **Transaction** | Commercial activity | Purchases, bookings |
| **Productivity** | Tasks completed | Records created, workflows run |

---

### 4. PRICING Analysis

**Key Questions:**
- Is pricing based on value delivered (not cost or competition)?
- Have you tested willingness to pay?
- Does your pricing support a healthy business model?
- Is pricing simple enough to understand?
- Can customers easily see ROI vs. price?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "We're cheaper than competitors" | Racing to bottom |
| "We don't know what to charge" | No WTP research |
| High trial, low conversion | Price-value mismatch |
| "We're losing to cheaper alternatives" | Not differentiated enough |
| Complex pricing page | Confusion kills conversion |

**What Good Looks Like:**
- Price reflects value delivered (not cost)
- Tested with 5-10+ WTP conversations
- Price supports sustainable unit economics
- Clear packaging (good-better-best works)
- ROI justification ready (10x value vs price)

---

### 5. POSITIONING Analysis

**Key Questions:**
- Can you articulate what makes you different in 1 sentence?
- Do customers understand your value without explanation?
- Are you positioned against the right alternatives?
- Is your messaging consistent across channels?
- Does positioning resonate with your ECP's identity?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "We're better, faster, cheaper" | Generic positioning |
| Long explanations needed | Unclear value prop |
| Prospects compare you to wrong alternatives | Category confusion |
| Team describes product differently | No positioning alignment |
| "Yawn" response to pitch | Not differentiated |

**What Good Looks Like:**
- Clear differentiator that matters to ECP
- Positioned against relevant alternatives
- Messaging speaks to ECP's language and pain
- Consistent across all touchpoints
- Passes the "so what?" test

---

### 6. GROWTH Analysis

**Key Questions:**
- Which 1-3 channels are you focused on?
- Are channels matched to where your ECP actually is?
- Are you generating demand or capturing existing demand?
- Do you have growth loops (not just funnels)?
- What's your Hours-to-Data for testing?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "We're on all channels" | Scattered, no critical mass |
| "We tried [channel], didn't work" | Too early to quit |
| High traffic, low conversion | Wrong audience or message |
| "We need more content" | Output focus, not outcome |
| No referrals happening | Missing viral/word-of-mouth loop |

**7 Growth Channels for GTM:**

| Channel | Type | Best For |
|---------|------|----------|
| **Inbound** | Demand Gen | Thought leadership, SEO |
| **Paid Digital** | Demand Capture | Quick testing, scale |
| **Outbound** | Demand Gen | B2B, high-value deals |
| **ABM** | Demand Gen | Enterprise, key accounts |
| **Community** | Demand Gen | Loyalty, retention |
| **Partners** | Demand Capture | Distribution, credibility |
| **PLG** | Demand Gen/Capture | Self-serve, viral |

---

### 7. GTM SYSTEM Analysis

**Key Questions:**
- Do you have OKRs set for GTM?
- Is there a North Star Metric everyone knows?
- Are you running experiments with clear hypotheses?
- Is the team aligned and bought-in?
- Do you have a realistic timeline and budget?

**Gap Indicators:**

| Symptom | Likely Gap |
|---------|------------|
| "We're working on everything" | No OKRs/priorities |
| Team has different goals | Misalignment |
| "We don't have time to test" | Not experimenting |
| "It's the founder's job" | No GTM team/ownership |
| "We ran out of runway" | No budget planning |

**What Good Looks Like:**
- 3-5 OKRs with measurable Key Results
- North Star Metric visible and tracked weekly
- Experimentation loop: hypothesis → test → learn → iterate
- Cross-functional team (product + marketing + sales)
- 3-18 month realistic timeline with milestones

---

## Output Template

```
═══════════════════════════════════════════════════════════════
                     GTM GAP ANALYSIS
                 (GTM Strategist Framework)
═══════════════════════════════════════════════════════════════

BUSINESS: [Name]
DATE: [Analysis date]
STAGE: [Pre-launch / Launched / Pivoting]

───────────────────────────────────────────────────────────────
                    EXECUTIVE SUMMARY
───────────────────────────────────────────────────────────────

OVERALL GTM HEALTH: [🔴 Critical / 🟡 Gaps Present / 🟢 Solid]

TOP 3 GAPS:
1. [Most critical gap]
2. [Second gap]
3. [Third gap]

RECOMMENDED FOCUS: [Which area to address first and why]

───────────────────────────────────────────────────────────────
                    DETAILED GAP ANALYSIS
───────────────────────────────────────────────────────────────

┌─────────────────────────────────────────────────────────────┐
│ 1. MARKET                                         [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Description of current market approach]                    │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Evidence/Symptoms:                                          │
│ • [What indicates this gap]                                 │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 2. EARLY CUSTOMER PROFILE (ECP)                   [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Description of current ECP]                                │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Validation Status:                                          │
│ □ Not validated  □ Partially validated  □ Fully validated  │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 3. PRODUCT                                        [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Description of product/MVP status]                         │
│                                                             │
│ Value Proposition (current):                                │
│ "[Current value prop - or 'undefined']"                     │
│                                                             │
│ PMF Signals:                                                │
│ □ None  □ Early signs  □ Strong signals  □ PMF achieved    │
│                                                             │
│ North Star Metric:                                          │
│ [Current NSM - or 'not defined']                            │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 4. PRICING                                        [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Current pricing approach]                                  │
│                                                             │
│ Pricing Basis:                                              │
│ □ Cost-based  □ Competitor-based  □ Value-based            │
│                                                             │
│ WTP Tested: □ No  □ Partially  □ Yes                       │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 5. POSITIONING                                    [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Current positioning/messaging]                             │
│                                                             │
│ Differentiation:                                            │
│ □ None  □ Weak  □ Clear  □ Strong/Unique                   │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 6. GROWTH                                         [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Current growth/channel approach]                           │
│                                                             │
│ Active Channels: [List current channels]                    │
│                                                             │
│ Channel Focus:                                              │
│ □ Scattered (5+)  □ Moderate (3-4)  □ Focused (1-2)        │
│                                                             │
│ Growth Loops: □ None  □ In development  □ Active           │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 7. GTM SYSTEM                                     [🔴/🟡/🟢] │
├─────────────────────────────────────────────────────────────┤
│ Current State:                                              │
│ [Current execution approach]                                │
│                                                             │
│ OKRs: □ None  □ Informal  □ Defined                        │
│ NSM: □ None  □ Defined  □ Tracked                          │
│ Experimentation: □ None  □ Ad-hoc  □ Systematic            │
│ Team: □ Solo  □ Part-time  □ Dedicated                     │
│                                                             │
│ Gaps Identified:                                            │
│ • [Gap 1]                                                   │
│ • [Gap 2]                                                   │
│                                                             │
│ Impact if Not Addressed:                                    │
│ [What happens if ignored]                                   │
└─────────────────────────────────────────────────────────────┘

───────────────────────────────────────────────────────────────
                    GAP PRIORITY MATRIX
───────────────────────────────────────────────────────────────

| Gap | Severity | Urgency | Effort | Priority |
|-----|----------|---------|--------|----------|
| [Gap 1] | High/Med/Low | High/Med/Low | High/Med/Low | 1-7 |
| [Gap 2] | High/Med/Low | High/Med/Low | High/Med/Low | 1-7 |
| [Gap 3] | High/Med/Low | High/Med/Low | High/Med/Low | 1-7 |
| ... | ... | ... | ... | ... |

───────────────────────────────────────────────────────────────
                    BELIEF CHECK
───────────────────────────────────────────────────────────────

BELIEFS THAT MAY BE CAUSING GAPS:
• [Limiting belief affecting GTM decisions]
• [Fear or assumption blocking action]

(Use /trace-belief if deeper belief work needed)

───────────────────────────────────────────────────────────────
                    RECOMMENDED NEXT STEPS
───────────────────────────────────────────────────────────────

IMMEDIATE (Address This Week):
1. [Most critical action]
2. [Second action]

SHORT-TERM (This Month):
1. [Action 1]
2. [Action 2]

→ Use /plan-gtm to create detailed action plan

═══════════════════════════════════════════════════════════════
```

---

## Integration with Other Skills

```
/analyze-gtm → Identify GTM gaps
       ↓
/plan-gtm → Create action plan to close gaps
       ↓
/craft-offer → Build Grand Slam Offer (if offer gap)
/build-brand → Fix positioning (if positioning gap)
/validate-idea → Validate assumptions (if market/ECP gap)
       ↓
/belief-profile → Address beliefs blocking GTM
```

---

## Key Quotes

> "Over 95% of businesses fail in their first three years of existence."

> "If you are serving everybody, you are not doing a fantastic job for anybody."

> "A winning strategy is to create a critical mass of activities for success."

> "The best GTM strategies are simple yet proprietary."

> "In GTM, you need to be extremely careful to resist shiny objects and commit your limited resources to the mission."

---

## Notes

- This skill is for ANALYSIS - use `/plan-gtm` for action planning
- GTM has a 3-18 month lifespan - urgency matters
- "Beachhead Strategy" = focus on one segment before expanding
- ECP (Early Customer Profile) ≠ ICP (Ideal Customer Profile)
- Good GTM requires cross-functional team alignment
- Iterate fast, learn faster - speed is a competitive advantage
