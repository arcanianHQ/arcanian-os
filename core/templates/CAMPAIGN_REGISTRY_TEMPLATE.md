---
scope: shared
type: template
---

<!--
TEMPLATE FILE. Scope: shared so it ships in all flavors.
When instantiating into a client directory, set the scope of the generated file to `int-confidential`.

Example instantiation frontmatter:
---
client: diego
scope: int-confidential
created: 2026-04-21
---

Below is the template body. Replace {{placeholders}} before saving.
-->

---
client: {{client_slug}}
scope: int-confidential
created: {{YYYY-MM-DD}}
---

# {{Client Name}} — Campaign Registry

Canonical registry of marketing campaigns. See `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md` for schema + rules.

## Active / upcoming

| id | name_short | start | end | status | entities | goal | managing |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

## Archive (recent — last 12 months)

| id | name_short | start | end | status | notes | retro |
|---|---|---|---|---|---|---|
| | | | | | | |

## Archive (older — 12+ months ago)

| id | name_short | start | end | status | notes |
|---|---|---|---|---|---|
| | | | | | |

## Alias resolution

When clients/team use short names that could match multiple campaigns, disambiguate here:

| short_name | default_to | disambiguation_rule |
|---|---|---|
| | | |

Example:
- `Glamour` → `glamour-2026-spring` (most recent) unless year specified

## Year-over-year pairs

For comparative analysis, explicit YoY mappings:

| current_campaign | previous_year_campaign | notes |
|---|---|---|
| | | |

## Changelog

| Date | Action | By |
|---|---|---|
| {{YYYY-MM-DD}} | Initial scaffold | {{initials}} |
