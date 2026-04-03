# 04 — Measurement & Reporting

> Generic SOP. Adapt per client in `clients/{slug}/processes/`.
> Owner: Fractional CMO | Tier: 2 | Review: Monthly

## Purpose
Establish a single source of truth for marketing performance through a robust measurement stack, consistent reporting cadence, and clear data discrepancy protocols.

## Trigger
- Measurement stack audit or gap identified
- Weekly / monthly reporting cycle
- Data discrepancy detected (>10% variance between systems)
- New channel or platform added to the marketing mix

## Stakeholders (RACI)

| Role | R/A/C/I |
|---|---|
| Fractional CMO | A |
| Marketing Director | R (reporting, discrepancy investigation) |
| Analytics / Data Engineer | R (stack implementation, maintenance) |
| PPC Agency | C (platform-side data) |
| SEO Agency | C (organic data) |
| CEO / CMO (internal) | I |

## Systems
- Web analytics (e.g., GA4) — site behavior, conversions, attribution
- Server-side tag management (e.g., sGTM) — first-party data collection, resilient tracking
- Conversions API (e.g., Meta CAPI, Google Enhanced Conversions) — ad platform signal quality
- E-commerce platform — revenue, transactions, product data (source of truth for revenue)
- Dashboard / BI tool — unified reporting layer
- Data warehouse (optional) — raw data consolidation

## Steps

### Measurement Stack Target State
1. Define the target measurement architecture:
   - **Web analytics** (GA4 or equivalent): configured with enhanced e-commerce, custom events for key actions, consent-mode compliant
   - **Server-side tag management** (sGTM or equivalent): all conversion tags fire server-side, reducing client-side bloat and improving data resilience
   - **Conversions API** (CAPI / Enhanced Conversions): direct server-to-server connection to ad platforms for conversion data — bypasses browser limitations
   - **Enhanced Conversions / Advanced Matching**: hashed first-party data (email, phone) sent with conversion events for improved match rates
2. Analytics / Data Engineer audits current state against target state — document gaps
3. Fractional CMO prioritizes gap closure: sGTM first (foundation), then CAPI, then enhanced conversions
4. Each implementation validated with test conversions before going live

### Reporting Cadence
1. **Weekly report** (delivered by Marketing Director, every Monday):
   - Channel-level spend, revenue, ROAS / CPA
   - Week-over-week trend (traffic, conversion rate, revenue)
   - Top 3 wins, top 3 concerns, recommended actions
2. **Monthly report** (delivered by Fractional CMO, by 5th business day):
   - Full-funnel metrics: traffic → leads → opportunities → revenue
   - Budget vs. actual (link to `03-financial-controls.md`)
   - Channel attribution analysis
   - Recommendations for next month
3. **Quarterly business review**:
   - YTD performance vs. annual targets
   - Measurement stack health check
   - Strategic recommendations

### KPI Framework
1. Define KPIs per funnel stage:
   - **Awareness:** traffic, impressions, reach, brand search volume
   - **Consideration:** engagement rate, time on site, content consumption, email signups
   - **Conversion:** conversion rate, CPA, ROAS, revenue, average order value
   - **Retention:** repeat purchase rate, customer lifetime value, churn
2. Each KPI has: owner, data source, target, reporting frequency
3. KPI targets set quarterly, reviewed monthly

### Currency Normalization
1. If multi-currency operations: define reporting currency (e.g., EUR or HUF)
2. Ad platform spend reported in platform currency → converted at month-end average rate
3. Revenue reported in e-commerce platform currency → converted at same rate
4. Currency conversion method and rates documented in each report

### Data Discrepancy Protocol
1. Acceptable variance between analytics and e-commerce platform: < 10%
2. If variance > 10%: Marketing Director investigates within 48h
3. Common causes checklist: consent mode filtering, cross-domain tracking gaps, payment gateway redirects, bot traffic, timezone mismatches
4. Root cause and fix documented in discrepancy log
5. If unresolvable: e-commerce platform is the source of truth for revenue; analytics is the source of truth for behavior

## Escalation
- If sGTM goes down → Analytics / Data Engineer restores within 4h (critical: ad platform signals degrade immediately)
- If CAPI quality score drops below 5/10 → investigate within 24h (impacts ad delivery)
- If weekly report is missed → Fractional CMO follows up same day
- If data variance exceeds 20% → freeze reporting from affected source until resolved

## KPIs

| Metric | Target |
|---|---|
| sGTM operational | Live, <1h downtime/month |
| CAPI quality score | > 7/10 |
| GA4 vs. e-commerce revenue variance | < 10% |
| Weekly report delivery | 100% on time |

## Review Cadence
Monthly — Fractional CMO reviews measurement stack health, reporting accuracy, and open discrepancy items. Quarterly stack audit with Analytics / Data Engineer.
