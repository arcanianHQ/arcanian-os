---
project: "example-ecom"
sync: todoist
sync_id: ""
updated: 2026-04-03T00:00
---
> v1.0 — 2026-04-03

# SolarNook — Tasks

> Multi-domain example. Note Domain: field on every task.

---

## P0 — Critical

- [ ] #1 Google Ads conversion tracking — verify new EU account has purchase event configured
  - @next @computer
  - P0 | Owner: You | Due: 2026-04-07 | Effort: 2h | Impact: unlock
  - Created: 2026-04-03
  - Layer: L5
  - Domain: solarnook.eu
  - FND: EU Google Ads showing near-zero conversions despite Shopify orders stable
  - SOP: marketing-ops/04-measurement-reporting

- [ ] #2 Fix currency mismatch in cross-domain reporting
  - @next
  - P0 | Owner: You | Due: 2026-04-08 | Effort: 1h | Impact: lever
  - Created: 2026-04-03
  - Layer: L5
  - Domain: all (cross-domain)
  - Must normalize USD + EUR before any total. See core/methodology/CURRENCY_NORMALIZATION.md

---

## P1 — This Week

- [ ] #3 SolarNook US — Meta creative refresh (frequency >4x on top 3 creatives)
  - @next
  - P1 | Owner: You | Due: 2026-04-11 | Effort: 2h | Impact: lever
  - Created: 2026-04-03
  - Layer: L5
  - Domain: solarnook-us.com
  - FND: channel-analyst-meta flagged CTR decay on 3 creatives running >21 days

- [ ] #4 Dealer pipeline review — 15 leads @waiting >14 days
  - @waiting
  - P1 | Owner: You | Due: 2026-04-10 | Effort: 1h | Impact: lever
  - Waiting on: Dealer network — follow-up responses
  - Waiting since: 2026-03-25
  - Follow-up: 2026-04-10 — escalate stale leads
  - Created: 2026-04-03
  - Layer: L4
  - Domain: dealers.solarnook.com
