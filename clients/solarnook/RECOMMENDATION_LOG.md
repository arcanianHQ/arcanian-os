# Recommendation Log — SolarNook

> Every REC created by any skill or agent is logged here.
> Outcome Tracker agent updates status weekly.

---

## Log

| REC ID | Date | Metric Targeted | Expected Impact | Created By | Executed By Task | Status | Outcome Date | Detected Pattern | Dismissed Reason | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| REC-001 | 2026-03-20 | Google Ads conversion value (EU) | Restore pre-drop conversion tracking (+74% recovery) | /council diagnostic | #1 | confirmed | 2026-03-28 | GTM config tag change broke GA4 purchase event on EU domain | — | Conversion value recovered within 5 days of tag fix. Agency was about to pause campaigns — would have been wrong action. |
| REC-002 | 2026-03-22 | GA4 consent mode compliance (EU) | Close 13% Shopify-vs-GA4 tracking gap | /measurement-audit | #2 | in_progress | — | Consent mode v2 not implemented on solarnook.eu — default "granted" violates GDPR, causes data quality gap | — | Gap between Shopify orders and GA4 conversions likely caused by unconsented users being dropped. |
| REC-003 | 2026-03-25 | Email sessions (all domains) | Recover 55% email session drop | /7layer diagnostic | — | open | — | Email automation flow broken after platform migration — no welcome sequence, no cart abandonment for 30 days | — | Needs AC automation rebuild. L5 channel issue but root cause is L3 (process broke during migration). |
