> v1.0 — 2026-04-03

# SOP-02: Discovery Call

> Standard discovery call structure and pre/post-call process.

---

## 1. Purpose

Extract maximum diagnostic signal from the first client conversation. Every discovery call must produce enough data for a first-draft 7-Layer diagnostic and at least 3 constraint signals. The call is a diagnostic instrument, not a sales pitch.

## 2. Trigger

- Qualified lead accepts a discovery call invitation
- Referral introduction leads to a scheduled call

## 3. RACI

| Activity | Founder | Research Lead | Delivery Lead | Analyst |
|----------|---------|---------------|---------------|---------|
| Pre-call homework | I | A, R | I | C |
| Call execution | A, R | I | I | I |
| Post-call write-up | A | R | I | C |
| Diagnostic first draft | A | R | I | C |

## 4. Systems & Tools

- e-cegjegyzek.hu (company registry -- ownership, legal structure)
- e-beszamolo.hu (financial filings -- revenue, trajectory)
- LinkedIn (key people, company page, content activity)
- web.archive.org (historical website changes -- positioning shifts, messaging evolution)
- `/7layer` skill (post-call diagnostic)

## 5. Steps

### 5.1 Pre-Call Homework (Gate -0.5)

**This is a gate. No call proceeds without completed homework.**

| Source | What to Extract |
|--------|----------------|
| e-cegjegyzek.hu | Ownership structure, founding date, registered activities, legal form |
| e-beszamolo.hu | Revenue (last 3 years), employee count, profit margin trajectory |
| LinkedIn | Key decision-makers, company content quality, follower engagement |
| web.archive.org | 3-5 historical snapshots of website -- track positioning shifts, messaging changes, brand evolution |

- Compile into a 1-page pre-call brief
- Flag initial hypotheses: which layers likely broken? KKV-origin pattern signals?
- Time budget: 30-45 minutes

### 5.2 Call Opening (3 min)

- Thank them for the time
- Set expectations: "This is a diagnostic conversation, not a pitch. I'll ask questions that might feel unusual -- they help me understand where the system breaks."
- Confirm: who are the decision-makers? Who else should be in this conversation eventually?

### 5.3 [Customer Need Framework] Questions (15 min)

- "What triggered this conversation? What happened that made you look for help NOW?"
- "What have you tried before? What did you hire it to do? Why did you fire it?"
- "If this engagement succeeds, what does your world look like in 6 months?"
- "What's the job your marketing is supposed to do for the business right now?"
- "Who internally owns marketing decisions today? How did that happen?"

Listen for: switching triggers, firing criteria, outcome expectations, implicit assumptions about what marketing IS.

### 5.4 System / Measurement Questions (10 min)

- "How do you know if marketing is working today? What do you measure?"
- "Walk me through: a lead comes in -- what happens next? Who touches it?"
- "Where does sales end and marketing begin in your company? Or is there a gap?"
- "What data do you trust? What data do you suspect is wrong?"

Listen for: measurement gaps, sales-marketing handoff friction, data trust issues, L3-L5 breaks.

### 5.5 Constraint Signals (5 min)

- "What's the one thing that, if it changed, would change everything?"
- "What have you been avoiding? What decision keeps getting postponed?"
- "Is there something you already know is broken but haven't been able to fix?"

Listen for: L0 signals (identity/pattern locks), L1 signals (capacity/structure), avoidance patterns.

### 5.6 Next Steps (2 min)

- Summarize 2-3 things you heard (pace, don't prescribe)
- Explain what happens next: "I'll put together an initial diagnostic. We'll walk through it together."
- Confirm timeline for follow-up
- Ask: "Is there anything I should have asked but didn't?"

### 5.7 Post-Call Write-Up (within 24h)

- Complete call notes with verbatim quotes where possible
- Draft `brand/7LAYER_DIAGNOSTIC.md` (first pass -- which layers show breaks?)
- List all constraint signals identified (minimum 3)
- Flag: Target Profile fit confirmed? KKV-origin pattern present? COACH or CRASH state?
- Note any follow-up questions for next conversation

## 6. Escalation

- If pre-call homework reveals the company is clearly outside Target Profile --> Founder decides before the call: proceed or gracefully decline
- If fewer than 3 constraint signals identified --> Schedule a follow-up call focused on gaps, do not proceed to proposal
- If call reveals the real decision-maker is not present --> Request a second call with decision-maker before proceeding

## 7. KPIs

| Metric | Target |
|--------|--------|
| Call duration | < 45 minutes |
| Post-call write-up completed | Within 24 hours |
| Constraint signals identified | >= 3 per call |
| Pre-call homework completed | 100% (gate -- no exceptions) |
| 7-Layer first draft started | Within 24h of call |

## 8. Review Cadence

- **Monthly:** Review last month's discovery calls -- what questions produced the best signals? Any patterns?
- **Quarterly:** Update question bank based on new patterns from KNOWN_PATTERNS.md

## 9. Related SOPs

- SOP-01: Client Onboarding
- SOP-03: Proposal Delivery
- SOP-06: Client Intelligence Profile
