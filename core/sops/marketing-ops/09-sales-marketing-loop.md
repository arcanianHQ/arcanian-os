# 09 — Sales-Marketing Feedback Loop

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 3 | Review: Monthly

## Purpose
Close the gap between marketing and sales by establishing structured feedback mechanisms, lead quality scoring from sales, and closed-loop data flow back to ad platforms for optimization.

## Trigger
- Weekly feedback standup cadence
- New lead quality data available from sales
- Monthly feedback report cycle
- OCT (Offline Conversion Tracking) data pipeline setup or failure

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A |
| Marketing Director | R (data flow, reporting, OCT setup) |
| Sales Team Lead | R (feedback, lead quality scoring) |
| Sales Representative(s) | R (call outcome logging, quality ratings) |
| PPC Agency | C (OCT integration, bid optimization) |
| CRM Administrator | C (data pipeline) |
| CEO / CMO (internal) | I |

## Systems
- CRM — lead records, call outcomes, quality scores, pipeline stages
- Ad platforms — offline conversion imports (Google Ads OCT, Meta Offline Events)
- Dashboard / BI tool — lead quality reporting, correlation analysis
- Communication platform — feedback standup channel
- Spreadsheet / shared doc — monthly feedback report

## Steps

### Weekly Feedback Standup
1. 15-minute standup every week (fixed day/time) — Sales Team Lead + Marketing Director + Fractional CMO
2. Agenda (fixed):
   - Sales: top 3 best leads this week (what made them good?)
   - Sales: top 3 worst leads this week (what was wrong?)
   - Sales: any pattern changes? (new objections, new competitor mentions, audience shift)
   - Marketing: what changed this week? (new campaigns, new channels, budget shifts)
   - Action items from prior week — status check
3. Marketing Director documents notes and action items in shared channel within 2h
4. Attendance is mandatory — if Sales Team Lead unavailable, designated backup attends

### Data Flow
1. Define the data handoff points between marketing and sales:
   - **Marketing → Sales:** lead record with source, score, enrichment data, activity history (via CRM)
   - **Sales → Marketing:** call outcome, quality rating, deal stage, won/lost reason (via CRM)
   - **Sales → Ad Platforms:** conversion events for won deals (via OCT pipeline)
2. CRM is the single system of record — no side spreadsheets or email-based tracking
3. Marketing Director audits data completeness weekly: % of leads with call outcomes logged, % with quality ratings

### Sales-Reported Lead Quality Scoring
1. Sales Representatives rate every contacted lead on a 1-5 scale:
   - **5 — Excellent:** right fit, right timing, budget confirmed, decision-maker
   - **4 — Good:** right fit, interested, but timing or budget uncertain
   - **3 — Average:** some fit, needs nurturing, not immediately actionable
   - **2 — Poor:** wrong fit or wrong timing, unlikely to convert
   - **1 — Junk:** spam, wrong number, competitor, irrelevant inquiry
2. Quality rating logged in CRM within 48h of first contact
3. If quality score requires explanation (score 1 or 2), Sales Representative adds a brief note (1-2 sentences)
4. Target: average quality score > 3.0 across all sources. If below 3.0 for any source for 2+ weeks → Marketing Director investigates

### Monthly Feedback Report
1. Marketing Director compiles monthly report (by 5th business day):
   - Lead volume by source and quality score distribution
   - Average quality score by source, campaign, and channel
   - Trend vs. prior month
   - Top 3 sales insights (recurring themes from weekly standups)
   - Recommended marketing adjustments based on feedback
2. Report shared with Fractional CMO, Sales Team Lead, and CEO / CMO
3. Fractional CMO translates insights into campaign or targeting changes — documented as action items

### Closed-Loop to Ad Platforms (OCT)
1. Define OCT pipeline: CRM won-deal events sent to ad platforms as offline conversions
2. Data flow: CRM (deal won + value + original click ID / lead source) → data pipeline → ad platform offline conversion API
3. Minimum data for OCT: click identifier (gclid, fbclid), conversion action (e.g., "qualified_lead", "deal_won"), conversion value, conversion timestamp
4. OCT data sent daily (automated) or weekly (manual upload if automation not yet built)
5. PPC Agency configures ad platform bidding to optimize toward OCT events (not just form fills)
6. Marketing Director monitors OCT data flow weekly — if data stops flowing for >48h, investigate and restore
7. Validation: compare OCT-reported conversions in ad platform vs. CRM source data — variance < 5%

## Escalation
- If call outcome logging drops below 80% → Sales Team Lead addresses with sales team within 1 week
- If average lead quality score drops below 2.5 for any channel → Fractional CMO pauses channel spend pending investigation
- If OCT pipeline breaks for >72h → Marketing Director escalates to CRM Administrator and PPC Agency
- If standup missed 2 consecutive weeks → Fractional CMO escalates to CEO / CMO

## KPIs

| Metric | Target |
|---|---|
| Call outcome logging rate | > 80% |
| Average lead quality score (sales-reported) | > 3.0 |
| Scoring accuracy (quality score vs. deal outcome correlation) | > 70% |
| Weekly standup attendance | 100% |
| OCT data flowing to ad platforms | Continuous (daily) |

## Review Cadence
Monthly — Fractional CMO reviews feedback report, quality score trends, and OCT pipeline health. Quarterly deep dive: recalibrate quality scoring criteria with Sales Team Lead based on actual win/loss data.
