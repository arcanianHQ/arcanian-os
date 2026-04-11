---
id: "FND-001"
client: "solarnook"
title: "Google Ads conversion value dropped 74% — GTM tag change, not performance collapse"
severity: "Critical"
phase: 4
layer: "Platform"
status: "resolved"
created: "2026-03-19"
updated: "2026-03-28"
confidence: 0.85
---

# FND-001: Google Ads Conversion Value Dropped 74% on March 18

## Observation
Google Ads conversion value for the SolarNook EU domain (solarnook.eu) dropped 74% on 2026-03-18 compared to the 7-day trailing average. Ad spend dropped proportionally the same day as Smart Bidding reacted to the apparent performance collapse.

## Evidence
- Google Ads conversion value: €12,400 (Mar 11-17 avg) → €3,224 (Mar 18) [DATA: Google Ads, 2026-03-18]
- GA4 purchase events: showed different pattern — revenue dropped only 12%, consistent with normal daily variance [DATA: GA4, 2026-03-18]
- Shopify orders: stable at 47/day average, no drop [DATA: Shopify, 2026-03-18]
- GTM container version history: new GA4 config tag deployed Mar 17 at 16:42 CET [OBSERVED: GTM changelog, 2026-03-17]
- Agency recommended pausing all EU campaigns "until performance recovers" [STATED: agency email, 2026-03-19]
- Timing correlation: tag deployment (Mar 17 16:42) → conversion drop starts (Mar 18 00:00) [INFERRED: from timing correlation]

## Root Cause
The GTM container update on March 17 replaced the GA4 config tag with a new version that had an incorrect measurement ID for the EU property. The purchase event continued firing in GA4 (visible in GA4 real-time) but the Google Ads conversion linker lost the connection, causing Google Ads to report near-zero conversions.

**This is a measurement artifact, not a performance collapse.**

## Impact
- Google Ads Smart Bidding reduced spend by ~60% within 48 hours (reacting to false signal)
- Agency recommended pausing campaigns (would have compounded revenue loss)
- Estimated revenue impact if campaigns were paused: €35,000-50,000 over the recovery period
- Actual fix: correct measurement ID in GTM config tag → conversions recovered within 5 days

## Related
- REC-001 (fix GA4 Server tag — confirmed, +74% recovery)
- Task #1 in TASKS.md (verify EU Google Ads conversion tracking)
- PAT-046 (known pattern: GTM migration breaks conversion tracking)
