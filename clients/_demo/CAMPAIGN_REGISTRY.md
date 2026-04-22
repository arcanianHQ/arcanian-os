---
client: "DEMO (Mosstrail)"
slug: "_demo"
scope: int-confidential
---

# DEMO Virtual Client — Campaign Registry

Pre-registered campaigns matching the synthetic data pushed to the DEMO Databox account (748621). Used by `/nexus-answer` hub-fallback to resolve user references like *"akció"*, *"kampány"*, *"promo"* to specific date windows — without disambiguation ask-back.

**Window provenance**: dates are confirmed from the DEMO GA4 Ecommerce dataset (daily revenue spike pattern) and the Explanation dataset (weekly reports naming *"Akció alatt"* on 2026-03-23 week and *"Akció lezárult — mérleg"* on 2026-03-30). Not invented, not guessed — pulled from the data.

## Active / upcoming

| id | name_short | start | end | status | entities |
|---|---|---|---|---|---|
| akcio-demo-2026-spring | akció | 2026-03-23 | 2026-03-26 | ended | mosstrail-demo |

## Archive (recent)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| (none yet) | | | | | |

## Alias resolution

When the user types one of these short names, the skill resolves to the canonical `id`:

| alias | resolves to (id) | notes |
|---|---|---|
| akció | akcio-demo-2026-spring | primary alias (matches data language) |
| akciós időszak | akcio-demo-2026-spring | full Hungarian phrase |
| kampány | akcio-demo-2026-spring | generic "campaign" |
| promo | akcio-demo-2026-spring | generic English "promo" |
| Glamour | akcio-demo-2026-spring | cosmetic compat — the skill's illustrative docs use "Glamour" as an example campaign name; resolves to the actual DEMO promo here |

## Year-over-year pairs

(None — DEMO is single-year synthetic data.)

## Notes

**Isolated spike on 2026-03-30**: GA4 Ecommerce shows a separate one-day revenue spike (107,072 HUF / 16 transactions) on 2026-03-30, well after the main promo ended. This is NOT part of `akcio-demo-2026-spring`. If it represents a distinct event, register it separately as `akcio-demo-2026-03-30` or similar. For now: unregistered.

**Alias behaviour**: operator-typed HU phrases — *"véget ért az akciónk"*, *"hogyan teljesített a kampány"*, *"mi volt az akciós időszakban"* — all resolve through the aliases above to `akcio-demo-2026-spring` (2026-03-23 → 2026-03-26). The `Glamour` alias is retained for skill-docs compatibility (the skill's v1.7 changelog references an earlier id `glamour-demo-2026-spring`; the id was corrected here to match the data's vocabulary, but Glamour still resolves).
