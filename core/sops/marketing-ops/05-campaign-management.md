# 05 — Campaign Management

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 2 | Review: Monthly

## Purpose
Standardize the campaign lifecycle from brief to post-mortem, ensuring every campaign is properly briefed, named, tracked, approved, and reviewed against kill criteria.

## Trigger
- New campaign request from business or marketing team
- Scheduled campaign in content calendar
- Campaign reaches kill criteria threshold
- A/B test result ready for evaluation

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A (strategy, kill decisions) |
| Marketing Director | R (brief, coordination, reporting) |
| PPC Agency | R (execution, optimization) |
| Creative Team / Agency | R (assets) |
| Sales Team Lead | C (offer alignment) |
| CEO / CMO (internal) | I |

## Systems
- Project management tool — campaign briefs, approval workflows, timelines
- Ad platforms — campaign execution, naming, budget allocation
- Web analytics — performance tracking, attribution
- Shared drive — creative assets, brief archive
- UTM builder — standardized tracking URLs

## Steps

### Campaign Brief Template
1. Every campaign starts with a written brief containing:
   - **Objective:** specific, measurable goal (e.g., generate 200 leads at < 15 EUR CPA)
   - **Audience:** target segment(s) with sizing estimate
   - **Channels:** which platforms, why
   - **Budget:** total and per-channel allocation
   - **Timeline:** start date, end date, key milestones
   - **Creative requirements:** formats, sizes, messaging angle, brand constraints
   - **Success metrics:** primary KPI, secondary KPIs, kill criteria
   - **Landing page:** URL, expected conversion rate
2. Marketing Director drafts brief → Fractional CMO reviews and approves before any execution begins
3. Brief stored in shared project management tool — linked to all downstream tasks

### Naming Convention
1. All campaigns, ad sets, and ads follow a standardized naming pattern:
   - Campaign: `{YYYY-MM}_{channel}_{objective}_{audience}_{geo}`
   - Ad set: `{targeting-type}_{audience-detail}_{placement}`
   - Ad: `{format}_{message-angle}_{version}`
2. Naming convention document shared with all agencies during onboarding (see `01-agency-coordination.md`)
3. Marketing Director audits naming compliance weekly — non-compliant items flagged for correction

### UTM Standard
1. All paid and organic links use standardized UTM parameters:
   - `utm_source`: platform (e.g., google, meta, linkedin)
   - `utm_medium`: channel type (e.g., cpc, email, social)
   - `utm_campaign`: matches campaign naming convention
   - `utm_content`: ad or content variant identifier
   - `utm_term`: keyword (search only)
2. UTM builder tool used for all URL generation — no manual UTM creation
3. UTM parameters reviewed in analytics monthly for consistency

### Approval Workflow
1. **Creative approval:** Creative Team delivers assets → Marketing Director reviews brand compliance → Fractional CMO gives final go
2. **Launch approval:** PPC Agency sets up campaigns in draft → Marketing Director verifies naming, UTMs, targeting, budget → Fractional CMO approves launch
3. No campaign goes live without written approval from Fractional CMO (message in PM tool or email)
4. Approval turnaround target: 24h from submission

### Kill Criteria
1. Every campaign has predefined kill criteria set at brief stage:
   - **ROAS floor:** if ROAS drops below X for 7+ consecutive days → pause and review
   - **CPA ceiling:** if CPA exceeds target by >50% after learning phase → pause and review
   - **CTR floor:** if CTR < X% after 1,000+ impressions → refresh creative
   - **Zero-conversion rule:** if zero conversions after 3 days and significant spend → pause immediately
   - **Overspend rule:** if daily spend exceeds 150% of daily budget → pause and investigate
2. PPC Agency monitors kill criteria daily
3. When kill criteria triggered: PPC Agency pauses and notifies Marketing Director within 2h
4. Fractional CMO decides: optimize, pivot, or terminate

### A/B Testing Protocol
1. Every major campaign (>1,000 EUR budget) must include at least one structured A/B test
2. Test one variable at a time: creative, headline, audience, landing page, or offer
3. Minimum sample size and duration defined before launch (use statistical significance calculator)
4. Winner declared only when results are statistically significant (95% confidence)
5. Learnings documented and added to campaign playbook for future reference

## Escalation
- If brief-to-launch exceeds 5 business days → Marketing Director identifies bottleneck and escalates
- If kill criteria triggered on >50% of active campaigns simultaneously → Fractional CMO calls emergency review within 24h
- If naming or UTM compliance drops below 90% → Fractional CMO mandates retraining session with agencies

## KPIs

| Metric | Target |
|---|---|
| Brief compliance (all fields complete) | 100% |
| Naming convention compliance | 100% |
| Brief-to-launch time | < 5 business days |
| A/B tests per major campaign | Minimum 1 |

## Review Cadence
Monthly — Fractional CMO reviews active campaigns against KPIs and kill criteria. Post-mortem within 5 business days of campaign end. Quarterly playbook update with accumulated learnings.
