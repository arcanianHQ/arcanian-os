# SolarNook — Platform Change Log

> Track all platform changes that could affect measurement, attribution, or performance.
> Cross-reference with findings when anomalies appear.

---

| Date | Platform | Change | Who | Impact | Related |
|---|---|---|---|---|---|
| 2026-03-17 | GTM (EU) | New GA4 config tag deployed — replaced measurement ID | Agency (via GTM access) | **CRITICAL** — broke Google Ads conversion tracking for 5 days | FND-001, REC-001 |
| 2026-03-18 | Google Ads | Smart Bidding auto-reduced spend ~60% (reacting to false conversion drop) | Automated | Revenue impact — reduced ad exposure during high-intent period | FND-001 |
| 2026-03-23 | GTM (EU) | GA4 config tag measurement ID corrected | Arcanian (us) | Fix deployed — conversions recovering | REC-001 confirmed |
| 2026-03-25 | ActiveCampaign | Email automation flows paused during platform migration | SolarNook internal | 55% email session drop over 30 days — no welcome, no cart abandonment | REC-003 |
| 2026-02-15 | Consent platform | CMP updated but consent mode v2 not propagated to GA4 | SolarNook internal | 13% tracking gap (Shopify vs GA4) — unconsented users dropped from GA4 | REC-002 |
