---
client: "MossTrail"
slug: "mosstrail"
scope: int-confidential
---

# MossTrail — Campaign Registry

Per `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md`. **Mirrors `clients/_demo/CAMPAIGN_REGISTRY.md`** — same `akcio-demo-2026-spring` campaign, same aliases, same window. Reason: `clients/mosstrail/` is demo-wired to the ArcanianOS DEMO Databox account (748621), so the campaign window must match the synthetic data that account actually holds. Any desync produces the exact failure mode the four-phase resolution protocol is designed to prevent.

**Window provenance**: confirmed from DEMO GA4 Ecommerce daily revenue spike (93-104k HUF vs ~50-75k baseline, 2026-03-23 → 2026-03-26) and Explanation dataset weekly reports ("Akció alatt" on 2026-03-23 week, "Akció lezárult — mérleg" on 2026-03-30). Not an inferred or invented date.

## Active / upcoming

| id | name_short | start | end | status | entities |
|---|---|---|---|---|---|
| akcio-demo-2026-spring | akció | 2026-03-23 | 2026-03-26 | ended | mosstrail-demo |

## Archive (recent)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| (none yet) | | | | | |

## Alias resolution

| alias | resolves to (id) | notes |
|---|---|---|
| akció | akcio-demo-2026-spring | primary alias (matches data language) |
| akciós időszak | akcio-demo-2026-spring | full phrase from VID-002 typed query |
| kampány | akcio-demo-2026-spring | generic "campaign" |
| promo | akcio-demo-2026-spring | generic English "promo" |
| Glamour | akcio-demo-2026-spring | cosmetic compat — illustrative skill-docs vocabulary |

## Year-over-year pairs

(None — DEMO is single-year synthetic data.)

## Script sync

This registry is kept in full alignment with the VID-002 script (`internal/video-production/VID-002_diego-welcome/SCRIPT.md`), specifically the Beat 1 typed query. If the script's campaign reference changes, update this registry AND `clients/_demo/CAMPAIGN_REGISTRY.md` together.

## Notes

**Isolated spike on 2026-03-30**: GA4 Ecommerce shows a separate one-day revenue spike (107,072 HUF / 16 transactions) on 2026-03-30, well after the main promo ended. NOT part of `akcio-demo-2026-spring`. Unregistered for now.
