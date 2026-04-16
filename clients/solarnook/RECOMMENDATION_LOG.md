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
| REC-004 | 2026-04-11 | Google Ads conversion value (US) | Restore -74% conversion tracking gap on solarnook-us.com | /council diagnostic | — | open | — | Consent-Gated Tag Failure Masked by Simultaneous Budget Event (compound: consent mode + Smart Bidding throttle + budget cut) | — | H5 compound failure at 62% confidence. GTM workspace 45 diff is critical path — resolves all hypotheses. Different domain from REC-001 (US, not EU). |
| REC-005 | 2026-04-11 | Shopify-GA4-GAds conversion gap (US) | Reduce cross-platform tracking gap to <10% | /council diagnostic | — | open | — | 13.1% gap between GA4 (172) and Shopify (198) over 30 days — measurement break confirmed | — | Weekly reconciliation check needed. Load-bearing evidence: if GA4/Shopify stability is wrong, H2 (budget cut) becomes viable. |
| REC-006 | 2026-04-11 | Smart Bidding signal health (US) | Return to pre-Mar 14 CPA level within 14 days of fix | /council diagnostic | — | open | — | Smart Bidding throttled — spending $294 vs $850/day cap. Signal pool degradation from consent mode change. | — | If ROAS <5x for 7+ days post-fix, switch to Manual CPC temporarily. |
