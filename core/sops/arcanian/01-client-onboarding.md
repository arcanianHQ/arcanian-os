# SOP-01: Client Onboarding

> End-to-end new client onboarding from first contact to kickoff.

---

## 1. Purpose

Ensure every new client engagement starts with a consistent, thorough diagnostic foundation and a smooth handoff from sales to delivery. No client enters active work without a completed [diagnostic profile], 7-Layer diagnostic, and constraint map.

## 2. Trigger

- Qualified lead confirms interest in an engagement (Morsel, [Diagnostic Service], or Fractional CMO)
- Referral introduction accepted by both parties

## 3. RACI

| Activity | Founder | Research Lead | Delivery Lead | Analyst |
|----------|---------|---------------|---------------|---------|
| Discovery call | A, R | C | I | I |
| [Diagnostic profile] | A | R | I | C |
| 7-Layer diagnostic | A | R | I | C |
| Constraint mapping | A, R | C | I | C |
| Proposal creation | A, R | C | I | I |
| Contract execution | A, R | I | I | I |
| Client scaffold (`/onboard-client`) | I | I | A, R | C |
| Kickoff meeting | A, R | R | R | I |
| First task assignment | A | I | R | I |

## 4. Systems & Tools

- `/onboard-client` skill (scaffolds client directory + 7-file intelligence profile)
- `/7layer`, ``, `` skills
- e-cegjegyzek.hu, e-beszamolo.hu (pre-call research)
- Contract template (standard engagement agreement)
- CLIENT_INTELLIGENCE_PROFILE.md (methodology standard)

## 5. Steps

### 5.1 Discovery Call
- Run pre-call homework (see SOP-02: Discovery Call)
- Conduct discovery call (max 45 min)
- Post-call write-up within 24h

### 5.2 Belief Profile
- Research Lead runs `` based on discovery call notes + public data
- Output: initial pattern landscape, readiness signals (COACH/CRASH)
- Founder reviews and annotates

### 5.3 7-Layer Diagnostic
- Research Lead runs `/7layer` diagnostic
- Output: `brand/7LAYER_DIAGNOSTIC.md` (first draft)
- Identify which layers are broken + cascade direction

### 5.4 Constraint Mapping
- Founder runs `` using diagnostic + [diagnostic profile]
- Output: `brand/CONSTRAINT_MAP.md`
- Identify primary constraint + downstream effects

### 5.5 Proposal
- Founder drafts proposal using diagnostic results (see SOP-03: Proposal Delivery)
- 3-tier offer structure: Morsel / [Diagnostic Service] / Fractional CMO
- Internal review before sending

### 5.6 Contract
- Standard engagement agreement sent
- Signed by both parties
- Payment terms confirmed

### 5.7 Client Scaffold
- Delivery Lead runs `/onboard-client` on contract signing day
- Scaffolds full client directory structure
- Populates initial files from diagnostic outputs

### 5.8 Kickoff Meeting
- All team members attend
- Walk through: diagnostic findings, engagement scope, timeline, communication cadence
- Client receives: what to expect, who does what, first deliverable date

### 5.9 First Task Assignment
- Delivery Lead assigns first concrete task within 24h of kickoff
- Task logged in client TASKS.md
- Delivery cadence established

## 6. Escalation

- If discovery call reveals the lead is outside Target Profile (tech problem, no budget, no leadership access) --> Founder decides: decline gracefully or redirect
- If proposal stalls beyond Day 14 --> Founder makes direct follow-up call (not email)
- If client scaffold fails or is incomplete --> Delivery Lead escalates to Founder same day

## 7. KPIs

| Metric | Target |
|--------|--------|
| Discovery call to proposal sent | < 5 business days |
| Proposal sent to contract signed | < 10 business days |
| Client scaffold complete | On contract signing day |
| Kickoff meeting scheduled | Within 3 days of contract |
| First task assigned | Within 24h of kickoff |

## 8. Review Cadence

- **Monthly:** Review onboarding pipeline (any bottlenecks?)
- **Quarterly:** Review full SOP against last 3 onboardings -- what broke, what needs updating?

## 9. Related SOPs

- SOP-02: Discovery Call
- SOP-03: Proposal Delivery
- SOP-06: Client Intelligence Profile
