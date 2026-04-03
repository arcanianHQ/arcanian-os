> v1.0 — 2026-04-03

# 02 — Lead Lifecycle

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 1 | Review: Monthly

## Purpose
Govern the end-to-end lead journey from capture to outcome, ensuring no lead is lost, every lead is enriched and scored, and sales receives qualified handoffs with full context.

## Trigger
- New lead enters the system (form submission, phone call, chat, import)
- Lead status changes (new → contacted → qualified → opportunity → won/lost)
- Nurture sequence triggered by inactivity or scoring threshold

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A |
| Marketing Director | R (capture, enrichment, scoring, nurture) |
| Sales Team Lead | R (follow-up, outcome) |
| Sales Representative | R (contact, qualify) |
| CRM Administrator | C |
| CEO / CMO (internal) | I |

## Systems
- CRM — lead records, lifecycle stages, assignment rules, activity logging
- Marketing automation platform — forms, welcome emails, nurture sequences, scoring
- E-commerce / website — lead capture forms, landing pages
- Calling / VoIP system — inbound call tracking, call outcome logging
- Dashboard / BI tool — lead funnel reporting

## Steps

### Lead Capture
1. All lead sources (website forms, phone, chat, offline events, imports) feed into CRM as the single source of truth
2. Every lead record must contain at minimum: name, contact method (email or phone), source, timestamp
3. Duplicate detection runs on capture — merge if match found
4. Welcome email (or SMS) fires automatically within 5 minutes of capture

### Lead Enrichment
1. CRM auto-enriches with available data (company size, industry, location) via integration or manual lookup
2. Marketing Director reviews unenriched leads weekly — manual enrichment for high-value sources
3. Target: 80%+ of leads have company name, industry, and estimated size within 48h

### Lead Scoring
1. Scoring model combines: demographic fit (company size, industry, role) + behavioral signals (pages visited, emails opened, content downloaded)
2. Scoring thresholds: Cold (0-30), Warm (31-60), Hot (61-100)
3. Hot leads auto-notify Sales Team Lead for immediate assignment
4. Scoring model reviewed quarterly — adjust weights based on closed-won correlation

### Lead Assignment
1. Hot leads assigned to Sales Representative within 1h (round-robin or territory-based)
2. Warm leads assigned within 24h
3. Cold leads enter nurture sequence (no sales assignment until score increases)
4. Assignment notification includes: lead score, source, enrichment data, activity history

### Sales Follow-Up
1. First contact attempt within 4h of assignment (phone preferred, email fallback)
2. Minimum 5 contact attempts over 10 business days before marking unresponsive
3. Every contact attempt logged in CRM with outcome (connected, voicemail, no answer, email sent)
4. If qualified: create opportunity with estimated value and expected close date
5. If disqualified: log reason (budget, timing, fit, competitor, spam) and move to appropriate status

### Nurture
1. Unresponsive leads enter automated nurture sequence (email cadence: weekly for 4 weeks, then biweekly)
2. Re-engagement trigger: if lead opens 2+ emails or revisits pricing page → re-score and re-assign
3. Nurture content: educational, not sales-heavy. Map to buyer journey stage.
4. After 90 days of zero engagement → move to dormant, suppress from active sequences

### Outcome Tracking
1. Every lead must reach a terminal status: Won, Lost (with reason), Disqualified, or Dormant
2. Auto-close rule: leads with no activity for 90 days auto-move to Lost (reason: unresponsive) — with false positive review
3. Monthly report: leads by source, conversion rate by stage, time-to-close, lost reasons
4. Closed-loop: won/lost data feeds back to scoring model and ad platform optimization (see `09-sales-marketing-loop.md`)

## Escalation
- If welcome email delivery rate drops below 95% → CRM Administrator investigates within 24h
- If lead-to-first-contact exceeds 4h consistently → Sales Team Lead restructures assignment rules
- If auto-lose false positive rate exceeds 10% → Fractional CMO adjusts auto-close rules

## KPIs

| Metric | Target |
|---|---|
| Welcome email delivery | 100% |
| Lead-to-first-contact time | < 4h |
| Deal win rate | Track and improve quarterly |
| Lead enrichment completeness | 80%+ |
| Auto-lose false positive rate | < 10% |

## Review Cadence
Monthly — Fractional CMO reviews funnel metrics, scoring accuracy, and lost-reason distribution. Quarterly scoring model recalibration.
