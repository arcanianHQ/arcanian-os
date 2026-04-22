---
client: "DEMO (Mosstrail)"
slug: "_demo"
scope: int-confidential
---

# DEMO Virtual Client — Campaign Registry

Pre-registered campaigns matching the synthetic data pushed to the DEMO Databox account (748621). Used by `/nexus-answer` hub-fallback to resolve user references like *"Glamour"*, *"akció"*, *"promo"* to specific date windows — without disambiguation ask-back.

## Active / upcoming

| id | name_short | start | end | status | entities |
|---|---|---|---|---|---|
| glamour-demo-2026-spring | Glamour | 2026-04-14 | 2026-04-21 | ended | mosstrail-demo |

## Archive (recent)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| (none yet) | | | | | |

## Alias resolution

When the user types one of these short names, the skill resolves to the canonical `id`:

| alias | resolves to (id) | notes |
|---|---|---|
| Glamour | glamour-demo-2026-spring | primary alias — VID-002 demo question |
| akció | glamour-demo-2026-spring | generic Hungarian "promo" |
| promo | glamour-demo-2026-spring | generic English "promo" |
| akciós időszak | glamour-demo-2026-spring | full Hungarian phrase |

## Year-over-year pairs

(None — DEMO is single-year synthetic data.)

## Notes

The Glamour DEMO campaign window (2026-04-14 → 2026-04-21) is hand-coordinated with the synthetic data push to the ArcanianOS DEMO Databox account. If you change either side, sync the other — desync produces the same kind of misleading analysis the four-phase resolution protocol is designed to prevent.
