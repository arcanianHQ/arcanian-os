---
client: "MossTrail"
slug: "mosstrail"
scope: int-confidential
---

# MossTrail — Campaign Registry

Per `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md`. **Mirrors `clients/_demo/CAMPAIGN_REGISTRY.md`** — same Glamour spring 2026 campaign, same aliases. Reason: `clients/mosstrail/` is demo-wired to the ArcanianOS DEMO Databox account (748621), so the campaign window must match the synthetic data that account holds. Any desync produces the exact failure mode the four-phase resolution protocol is designed to prevent.

## Active / upcoming

| id | name_short | start | end | status | entities |
|---|---|---|---|---|---|
| glamour-demo-2026-spring | Glamour | 2026-04-14 | 2026-04-21 | ended | mosstrail-demo |

## Archive (recent)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| (none yet) | | | | | |

## Alias resolution

Resolves team-colloquial short names to the canonical `id`:

| alias | resolves to (id) | notes |
|---|---|---|
| Glamour | glamour-demo-2026-spring | primary alias — VID-002 demo question |
| akció | glamour-demo-2026-spring | generic Hungarian "promo" |
| promo | glamour-demo-2026-spring | generic English "promo" |
| akciós időszak | glamour-demo-2026-spring | full Hungarian phrase from VID-002 typed query |

## Year-over-year pairs

(None — DEMO is single-year synthetic data.)

## Script sync

This registry is kept in full alignment with the VID-002 script (`internal/video-production/VID-002_diego-welcome/SCRIPT.md`), specifically the Beat 1 typed query. If the script's campaign reference changes, update this registry AND `clients/_demo/CAMPAIGN_REGISTRY.md` together.
