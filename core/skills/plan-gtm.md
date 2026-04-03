> v1.0 — 2026-04-03

# Skill: Plan GTM Actions (GTM Strategist Framework)

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.
Creates actionable Go-To-Market plans based on identified gaps. Takes the analysis from `/analyze-gtm` and transforms it into specific, executable steps with OKRs, experiments, and timelines.

**The Core Principle:**
> "The best plans are simple and understandable to everybody on the team."
> — Special Ops Principle from GTM Strategist

## Source Reference
From **"Go-To-Market Strategist" by Maja Voje** (Growth Lab)

## Trigger
Use this skill when:
- After running `/analyze-gtm` and identifying gaps
- Customer needs a concrete GTM action plan
- Creating OKRs for GTM initiatives
- Planning experiments to validate assumptions
- Building a GTM execution roadmap

## The Special Ops GTM Approach

### 6 Principles Applied to GTM

| Principle | Planning Phase | Execution Phase |
|-----------|----------------|-----------------|
| **Simplicity** | Limit objectives, simple plan | One page, everyone understands |
| **Good Intelligence** | Research before deciding | Proprietary insights |
| **Play on Strengths** | Know your advantages | Attack competitor weaknesses |
| **Innovation** | Unconventional tactics | 10x value, not 10% better |
| **Security** | Protect IP, plans | NDA, careful sharing |
| **Repetition** | Rehearse, stress test | Consistent execution |
| **Surprise** | Choose timing | Strike when ready |
| **Speed** | Agile planning | Fast iteration |
| **Purpose** | Clear mission | Everyone aligned |

---

## Planning Process

### Step 1: Define the Mission (NSM + OKRs)

**North Star Metric (NSM):**
The single metric that measures value delivered to customers.

```
NSM SELECTION:

What game are you playing?
□ Attention Game → Time captured (DAU, time in product)
□ Transaction Game → Commercial activity (purchases, bookings)
□ Productivity Game → Tasks completed (records created)

Your NSM: [Specific metric that shows value delivery]
```

**OKRs (Objectives + Key Results):**

```
OBJECTIVE: [Ambitious, qualitative goal]

Key Result 1: [Measurable outcome] → Target: [Number]
Key Result 2: [Measurable outcome] → Target: [Number]
Key Result 3: [Measurable outcome] → Target: [Number]

Timeline: [Quarter/Month]
```

**OKR Types:**
- **Commitment:** Must achieve (grade target: 1.0)
- **Aspirational:** Stretch goal (grade target: 0.4-0.7)
- **Learning:** Okay to fail if you learn (any grade acceptable)

---

### Step 2: Close Each Gap (Action Planning)

For each gap from `/analyze-gtm`, create specific actions:

#### Gap: MARKET

**If no Beachhead Segment:**
```
ACTIONS:
1. List all potential segments (brainstorm 10+)
2. Score each on:
   - Can win in 18 months? (1-5)
   - High pain for our solution? (1-5)
   - Willingness to pay? (1-5)
   - Market health & growth? (1-5)
3. Pick top 2-3 segments to validate
4. Run 5-10 discovery calls per segment
5. Select Beachhead based on data

DELIVERABLE: Beachhead Segment decision document
```

**If no market sizing:**
```
ACTIONS:
1. Calculate TAM (Total Addressable Market)
2. Calculate SAM (Serviceable Addressable Market)
3. Calculate SOM (Serviceable Obtainable Market)
4. Define early adopter size (realistic for 18 months)

SOURCES:
- Industry reports (free: Statista, IBISWorld free summaries)
- Government statistics
- LinkedIn Sales Navigator (estimate company counts)
- Competitor analysis (funding, customers, growth)

DELIVERABLE: TAM/SAM/SOM slide
```

**If weak competitive intelligence:**
```
ACTIONS:
1. Identify 3-10 direct competitors
2. For each, document:
   - Target audience
   - Pricing model
   - Key messaging
   - Top marketing channels
   - Strengths/weaknesses
3. Create competitive comparison table
4. Identify gaps/opportunities

TOOLS: SimilarWeb, Ahrefs, G2, customer interviews

DELIVERABLE: Competitive analysis spreadsheet
```

---

#### Gap: EARLY CUSTOMER PROFILE (ECP)

**If ECP not defined or too broad:**
```
ACTIONS:
1. Draft ECP hypothesis using framework:
   - Industry/Vertical: [specific]
   - Company size: [revenue or employees]
   - Role/Title: [decision maker]
   - Situation/Trigger: [why now]
   - Problem: [urgent pain point]

2. Narrow until you can:
   - Name 10 specific companies
   - Find them on LinkedIn
   - Describe their daily challenges

DELIVERABLE: 1-page ECP document
```

**If ECP not validated:**
```
ACTIONS:
1. Identify 20-30 potential ECP matches
2. Reach out for discovery calls (target: 15-25 completed)
3. Use discovery interview script:
   - "Tell me about your role..."
   - "What's your biggest challenge with [problem area]?"
   - "How are you solving this today?"
   - "What would ideal solution look like?"
   - "What have you tried that didn't work?"
4. Synthesize patterns from calls
5. Refine ECP based on insights

DELIVERABLE: ECP validation report with quotes
```

---

#### Gap: PRODUCT

**If value proposition unclear:**
```
ACTIONS:
1. Complete Value Proposition Canvas:
   - Customer jobs (functional, emotional, social)
   - Customer pains
   - Customer gains
   - How product addresses each

2. Draft value prop statement:
   "We help [ECP] achieve [outcome] by [mechanism],
   unlike [alternative] which [limitation]."

3. Test with 5-10 ECP representatives
4. Refine based on feedback

DELIVERABLE: Value Proposition document
```

**If no MVP or overbuilding:**
```
ACTIONS:
1. Define core problem to solve (ONE)
2. List minimum features for that problem
3. Cut 50% of features from list
4. Build simplest version that delivers value
5. Launch to 10-50 beta users
6. Measure usage and gather feedback

RULE: Launch in weeks, not months

DELIVERABLE: Live MVP + beta user feedback
```

**If no North Star Metric:**
```
ACTIONS:
1. Identify your "game" (attention/transaction/productivity)
2. Define the moment customer receives value
3. Create metric that captures that moment
4. Set up tracking/dashboard
5. Review weekly with team

DELIVERABLE: NSM dashboard
```

---

#### Gap: PRICING

**If pricing not value-based:**
```
ACTIONS:
1. Calculate value delivered to customer:
   - Time saved × hourly rate
   - Revenue increased
   - Cost avoided
   - Risk reduced

2. Price at 10-20% of value delivered

3. Test willingness to pay (WTP):
   - "At what price is this too expensive?"
   - "At what price is this so cheap you'd doubt quality?"
   - "At what price is this expensive but worth it?"

DELIVERABLE: Value-based pricing model
```

**If WTP not tested:**
```
ACTIONS:
1. Select 10 ECP-matching prospects
2. Run WTP conversations (Van Westendorp method)
3. Analyze price sensitivity curve
4. Set price based on data, not feelings
5. A/B test if possible

DELIVERABLE: WTP analysis report
```

---

#### Gap: POSITIONING

**If positioning is generic:**
```
ACTIONS:
1. List what makes you different:
   - Technology/approach
   - Experience/expertise
   - Focus/specialization
   - Speed/quality
   - Guarantee/risk reversal

2. Ask: "Which difference matters MOST to ECP?"

3. Create positioning statement:
   "For [ECP] who [situation],
   [Product] is a [category]
   that [key benefit].
   Unlike [alternative],
   we [differentiator]."

4. Test with 5 ECP reps: "Does this resonate?"

DELIVERABLE: Positioning statement + proof points
```

**If messaging inconsistent:**
```
ACTIONS:
1. Audit all messaging touchpoints:
   - Website
   - Social media
   - Sales decks
   - Emails
   - Ads

2. Create messaging hierarchy:
   - Core message (one line)
   - Key benefits (3 max)
   - Proof points (for each benefit)

3. Create messaging guide for team

DELIVERABLE: Messaging guide document
```

---

#### Gap: GROWTH

**If channels scattered:**
```
ACTIONS:
1. Score each current channel (1-5):
   - ECP is there?
   - We can win?
   - Scalable?
   - Measurable?
   - Affordable?

2. Pick TOP 2 channels to focus on
3. Pause/reduce other channels
4. Double down on focus channels for 90 days
5. Measure and decide: scale or switch

DELIVERABLE: Channel focus decision + 90-day plan
```

**If no growth loops:**
```
GROWTH LOOP ARCHETYPES:

1. Viral Loop:
   User → Invites others → New users → Repeat
   Example: Referral program

2. Content Loop:
   Content → SEO traffic → Users → More content
   Example: User-generated content

3. Paid Loop:
   Revenue → Ads → New users → More revenue
   Example: Profitable ad spend

4. Sales Loop:
   Happy customers → Referrals → New customers
   Example: Partner programs

5. Product Loop:
   Usage → Data/features → Better product → More usage
   Example: Network effects

ACTIONS:
1. Identify which loop fits your model
2. Design the loop mechanism
3. Instrument tracking
4. Optimize friction points
5. Measure loop velocity

DELIVERABLE: Growth loop design document
```

---

#### Gap: GTM SYSTEM

**If no OKRs:**
```
ACTIONS:
1. Set company-level GTM objective
2. Break into team OKRs (3-5 objectives each)
3. Define Key Results (2-5 per objective)
4. Assign owners
5. Set weekly/monthly review cadence

DELIVERABLE: OKR document + review schedule
```

**If no experimentation:**
```
EXPERIMENTATION LOOP:

1. HYPOTHESIS: "If we [action], then [result] because [reason]"
2. EXPERIMENT: Design minimum viable test
3. MEASURE: Define success metrics beforehand
4. LEARN: Document what happened
5. DECIDE: Double down, iterate, or kill

ACTIONS:
1. Create experiment backlog
2. Prioritize by: impact × confidence / effort
3. Run 1-3 experiments per week
4. Weekly experiment review meeting

DELIVERABLE: Experiment tracker spreadsheet
```

---

### Step 3: Create Timeline

**GTM Timeline Template:**

```
PHASE 1: FOUNDATION (Weeks 1-4)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Define/validate Beachhead Segment
□ Complete ECP validation (15+ calls)
□ Finalize value proposition
□ Set pricing based on WTP
□ Create positioning statement
□ Define NSM and OKRs

PHASE 2: LAUNCH PREP (Weeks 5-8)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Build/refine MVP
□ Create core messaging assets
□ Set up 2 focus channels
□ Design initial growth loop
□ Beta test with 10-50 users
□ Gather early testimonials

PHASE 3: LAUNCH (Weeks 9-12)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Public launch to Beachhead Segment
□ Run focused channel campaigns
□ Activate growth loop
□ Weekly experiment cycles
□ Measure PMF signals
□ Iterate based on data

PHASE 4: OPTIMIZE (Months 4-6)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Double down on what works
□ Kill what doesn't
□ Refine offer based on feedback
□ Strengthen growth loops
□ Expand within segment
□ Plan adjacent segment

PHASE 5: SCALE (Months 7-12+)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Achieve PMF in Beachhead
□ Document playbook
□ Enter adjacent segment
□ Scale winning channels
□ Build team
□ Systematize operations
```

---

## Output Template

```
═══════════════════════════════════════════════════════════════
                     GTM ACTION PLAN
                 (GTM Strategist Framework)
═══════════════════════════════════════════════════════════════

BUSINESS: [Name]
DATE: [Creation date]
PLAN DURATION: [X weeks/months]

───────────────────────────────────────────────────────────────
                    MISSION & METRICS
───────────────────────────────────────────────────────────────

MISSION STATEMENT:
"[Clear, simple statement of GTM goal]"

NORTH STAR METRIC:
[Specific metric] → Current: [X] → Target: [Y] by [date]

OKRs FOR THIS PERIOD:

OBJECTIVE 1: [Ambitious goal statement]
├── KR1: [Metric] from [current] to [target]
├── KR2: [Metric] from [current] to [target]
└── KR3: [Metric] from [current] to [target]

OBJECTIVE 2: [Ambitious goal statement]
├── KR1: [Metric] from [current] to [target]
└── KR2: [Metric] from [current] to [target]

───────────────────────────────────────────────────────────────
                    BEACHHEAD STRATEGY
───────────────────────────────────────────────────────────────

BEACHHEAD SEGMENT:
[Specific segment description]

WHY THIS SEGMENT:
• Pain level: [High/Med/Low] - [evidence]
• WTP: [High/Med/Low] - [evidence]
• Winnable in 18 mo: [Yes/No] - [reasoning]
• Access: [Easy/Med/Hard] - [how to reach]

EARLY CUSTOMER PROFILE (ECP):
• Industry: [specific]
• Company size: [range]
• Role: [title]
• Situation: [trigger/context]
• Pain: [urgent problem]
• Goal: [desired outcome]

───────────────────────────────────────────────────────────────
                    VALUE PROPOSITION
───────────────────────────────────────────────────────────────

CORE VALUE PROP:
"We help [ECP] achieve [outcome] by [mechanism]."

POSITIONING:
"For [ECP] who [situation], [Product] is the [category] that
[key benefit]. Unlike [alternative], we [differentiator]."

KEY PROOF POINTS:
1. [Proof/evidence]
2. [Proof/evidence]
3. [Proof/evidence]

───────────────────────────────────────────────────────────────
                    OFFER & PRICING
───────────────────────────────────────────────────────────────

OFFER SUMMARY:
[Brief description of what customer gets]

PRICING:
[Price] → Basis: [Value-based calculation]

VALUE-TO-PRICE RATIO: [X]:1

───────────────────────────────────────────────────────────────
                    GROWTH STRATEGY
───────────────────────────────────────────────────────────────

FOCUS CHANNELS (Pick 2):

Channel 1: [Name]
├── Why: [Why this channel for this ECP]
├── Goal: [Specific metric]
├── Actions: [Key activities]
└── Budget: [Amount/time]

Channel 2: [Name]
├── Why: [Why this channel for this ECP]
├── Goal: [Specific metric]
├── Actions: [Key activities]
└── Budget: [Amount/time]

GROWTH LOOP:
[Description of primary growth loop]

───────────────────────────────────────────────────────────────
                    ACTION ROADMAP
───────────────────────────────────────────────────────────────

WEEK 1-2: [Phase Name]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]

WEEK 3-4: [Phase Name]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]

WEEK 5-8: [Phase Name]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]

MONTH 3-6: [Phase Name]
□ [Action item] → Owner: [Name] → Due: [Date]
□ [Action item] → Owner: [Name] → Due: [Date]

───────────────────────────────────────────────────────────────
                    EXPERIMENTS BACKLOG
───────────────────────────────────────────────────────────────

| # | Hypothesis | Test | Metric | Priority |
|---|------------|------|--------|----------|
| 1 | [If X then Y] | [How to test] | [What to measure] | High |
| 2 | [If X then Y] | [How to test] | [What to measure] | High |
| 3 | [If X then Y] | [How to test] | [What to measure] | Med |
| 4 | [If X then Y] | [How to test] | [What to measure] | Med |
| 5 | [If X then Y] | [How to test] | [What to measure] | Low |

───────────────────────────────────────────────────────────────
                    RESOURCES NEEDED
───────────────────────────────────────────────────────────────

TEAM:
• [Role] - [Hours/week] - [Who]
• [Role] - [Hours/week] - [Who]

BUDGET:
• [Category]: $[Amount]
• [Category]: $[Amount]
• TOTAL: $[Amount]

TOOLS:
• [Tool] - [Purpose]
• [Tool] - [Purpose]

───────────────────────────────────────────────────────────────
                    SUCCESS CRITERIA
───────────────────────────────────────────────────────────────

PMF SIGNALS TO WATCH:
□ [Signal 1] - Target: [metric]
□ [Signal 2] - Target: [metric]
□ [Signal 3] - Target: [metric]

DECISION POINTS:
• Week 4: [What decision based on what data]
• Week 8: [What decision based on what data]
• Month 3: [What decision based on what data]

KILL CRITERIA:
"If [condition] by [date], we will [pivot/pause/change]"

───────────────────────────────────────────────────────────────
                    REVIEW CADENCE
───────────────────────────────────────────────────────────────

□ Daily: [What to check]
□ Weekly: [Team sync - when, agenda]
□ Monthly: [OKR review - when]
□ Quarterly: [Strategic review - when]

═══════════════════════════════════════════════════════════════
```

---

## Integration with Other Skills

```
/analyze-gtm → Identify gaps
       ↓
/plan-gtm → Create this action plan
       ↓
Execute with support from:
├── /validate-idea → Test before building
├──  → Create [Premium Offer]
├── /build-brand → Fix positioning
└──  → Address blocks

       ↓
/analyze-gtm → Re-analyze after execution
       ↓
Iterate
```

---

## Key Quotes

> "Success consists of going from failure to failure without loss of enthusiasm." — Winston Churchill

> "A simple plan, carefully concealed, repeatedly rehearsed and executed with surprise, speed, and purpose." — William H. McRaven

> "If you don't have a competitive advantage, don't compete." — Jack Welch

> "Shoot for the moon. Even if you miss, you'll land among the stars." — Norman Vincent Peale

> "Move fast and fix things." — Anne Morriss

---

## One-Page GTM Checklist

From the GTM Strategist framework:

**MARKET**
- [ ] Beachhead Segment selected
- [ ] Can win 30-50% in 18 months
- [ ] TAM/SAM/SOM calculated
- [ ] Competition analyzed

**EARLY CUSTOMER**
- [ ] ECP defined (specific)
- [ ] Validated with 15+ conversations
- [ ] Know where to find them
- [ ] Know their alternatives

**PRODUCT**
- [ ] Value prop clear (one sentence)
- [ ] MVP live (not overbuilt)
- [ ] North Star Metric defined
- [ ] PMF signals tracked

**PRICING**
- [ ] Value-based pricing
- [ ] WTP tested
- [ ] Supports business model
- [ ] Simple to understand

**POSITIONING**
- [ ] Clear differentiator
- [ ] Passes "so what?" test
- [ ] Messaging consistent
- [ ] Resonates with ECP

**GROWTH**
- [ ] 2 focus channels max
- [ ] Channels match ECP
- [ ] Growth loop designed
- [ ] Experiments running

**SYSTEM**
- [ ] OKRs set
- [ ] NSM tracked weekly
- [ ] Experiment loop active
- [ ] Team aligned

---

## Notes

- GTM lifespan: 3-18 months - act with urgency
- Simple plans beat complex plans
- Speed > perfection - iterate fast
- Focus creates critical mass - don't scatter
- Beachhead first, then expand
- Experiment constantly - "failing is okay if you learn"
- Review OKRs monthly in GTM (not quarterly)
