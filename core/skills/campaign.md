---
scope: shared
context: fork
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - mcp__databox__get_current_datetime
argument-hint: "subcommand: add | list | show <name> | end <id> | update <id> | alias <short> → <id>"
---

> v1.0 — 2026-04-21

# Skill: `/campaign` — Campaign Registry CRUD

## Purpose

Manage the per-client `CAMPAIGN_REGISTRY.md` — add new campaigns, list active/recent, resolve short names, mark ended, update fields. Every client running marketing campaigns needs this registry so `/nexus-answer` and related skills can resolve short-name references like *"Glamour"* or *"Húsvét"* to precise time windows.

See: `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md` for the full schema + rules.

## Trigger

- `/campaign add` — interactive creation wizard
- `/campaign list` — show active + recent campaigns
- `/campaign show <id-or-name>` — detailed view of one campaign
- `/campaign end <id>` — mark as ended, sets end to today if blank
- `/campaign update <id> <field>=<value>` — patch a single field
- `/campaign alias <short_name> → <id>` — add an alias for disambiguation
- `/campaign resolve <short_name>` — look up which id a short name maps to (used by other skills, typically invisible to user)

Also auto-triggered when a user says in conversation: *"új kampány indul"*, *"kampányt zártunk le"*, *"mikor volt a {campaign name}?"*

## Prerequisites

### Load context

1. Determine current client from working directory: `clients/{slug}/` — if not in a client dir, ask the user which client to operate on (do NOT enumerate clients).
2. Check for `CAMPAIGN_REGISTRY.md`:
   - If exists → load its current content
   - If not → offer to scaffold from `core/templates/CAMPAIGN_REGISTRY_TEMPLATE.md`

### Load canonical doc

Read `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md` for schema + rules. Do not improvise field structures.

## Subcommands

### `/campaign add`

Interactive wizard. Ask the user for each required field in order:

1. **`name_short`** — "Hogy hívjátok röviden? (pl. Glamour)"
2. **`name_full`** — optional, *"Teljes marketing név? (enter = ugyanaz mint a short)"*
3. **`id`** — auto-generate as `{slug(name_short)}-{YYYY}-{season-or-month}`, confirm with user
4. **`start`** — *"Mikor indul? (YYYY-MM-DD)"*
5. **`end`** — *"Meddig megy? (YYYY-MM-DD, vagy hagyd üresen ha nincs fix vége)"*
6. **`entities`** — for multi-entity clients: *"Melyik entitásokon? (vesszővel elválasztva)"*. For single-entity: skip, auto-fill.
7. **`status`** — derive from dates: start in future = `scheduled`, today in range = `active`, end in past = `ended`
8. **`goal_metric`** + **`goal_value`** — optional, *"Mi a fő KPI és a célérték? (enter = kihagyás)"*
9. **`managing_team`** — optional, *"Ki futtatja? (belső / ügynökség neve)"*
10. **`notes`** — optional, *"1-2 mondat kontextus? (enter = semmi)"*

Render the new row as a preview, ask for confirmation, then append to the registry's "Active / upcoming" section.

If registry doesn't exist yet, scaffold it first from the template, then add.

### `/campaign list`

Read registry, render:

```
━━━ {Client} — Aktív / Közelgő ━━━
  [id]  name_short  start → end     status      entities
  glamour-2026-spring  Glamour  2026-04-14 → 04-21  active   diego-hu, sk, ro

━━━ Közelmúlt (utolsó 12 hónap, max 5) ━━━
  [id]  name_short  start → end     status
  easter-2026  Húsvét  2026-03-25 → 04-07  ended

(további archívumhoz: /campaign list --archive)
```

Sorted: active first by start date desc, then scheduled by start date asc, then ended by end date desc.

### `/campaign show <id-or-name>`

Resolve the argument:
- Exact id match → direct
- `name_short` exact match, unique → use it
- Alias match, unique → use it
- Multiple matches → list them (only within THIS client's registry), ask user to pick

Render full details:

```
━━━ Campaign: Glamour (glamour-2026-spring) ━━━

Full name:   Glamour Tavaszi Megújulás 2026
Short name:  Glamour
Status:      active
Window:      2026-04-14 → 2026-04-21 (7 days)

Entities:    diego-hu, diego-sk, diego-ro
Goal:        revenue ≥ 30M HUF (aggregated)
Managing:    BuenoSpa in-house + Growww Digital
Aliases:     —

Notes:       Nemzeti medence+spa tavaszi promo.

Retrospective: (none yet)
```

### `/campaign end <id>`

Set `status: ended` on the specified row. If the `end` date is still in the future, prompt: *"A megadott end dátum (2026-04-21) még nem érkezett el. Vagy (1) hagyd úgy és csak a status-t frissítsd, (2) írd át end-et ma (2026-04-21)-re, (3) mégse?"*

If user picks (2), update both. Move the row from "Active / upcoming" to "Archive (recent)".

### `/campaign update <id> <field>=<value>`

Patch a single field. Example: `/campaign update glamour-2026-spring goal_value=32M`

Validate the field is one of the defined schema fields (per standard). Save.

### `/campaign alias <short_name> → <id>`

Add an alias to an existing campaign. Useful when team members adopt a new shorthand.

### `/campaign resolve <short_name>`

Silent lookup — used by other skills (like `/nexus-answer`). Returns:
- `{id, start, end, entities}` on success
- `ambiguous: [list of matching ids]` if multiple matches
- `not_found` if no match

This subcommand does not render to the user unless invoked explicitly.

## Auto-trigger patterns

When the user types a message matching these patterns, ask: *"Ez egy kampány? Regisztráljam a CAMPAIGN_REGISTRY.md-be?"* (single ask, yes/no; don't belabor)

- *"új kampány indul {name} {date}"*
- *"kampányt zártunk le"*
- *"{campaign} véget ért"*
- *"mikor volt a {name}?"* (and registry can't resolve)

If yes → trigger `/campaign add` wizard pre-filled with what the user just said.

## Privacy rules

- **Never list campaigns from other clients.** Each client's registry is isolated by directory.
- If the user asks about a campaign and there's no match in the current client's registry, respond: *"Nincs ilyen néven regisztrált kampány ezen a kliensen. Lehet, hogy más kliens? (Váltsd át a munkakönyvtárat.)"* Do not enumerate other clients' campaigns.
- Aliases and registries never appear in shared-scope output.

## Voice rules (HU output)

Follow `core/brand/arcanian/VOICE.md`:
- Active verbs, no pedagogical tone
- *találkozó* not *ülés*, *adatforrás* not *csatorna*
- No EN-calque (*landol*, *drópol*)
- No *ágens*

## Related

- **Canonical standard:** `core/methodology/CAMPAIGN_REGISTRY_STANDARD.md`
- **Template:** `core/templates/CAMPAIGN_REGISTRY_TEMPLATE.md`
- **Consumed by:** `/nexus-answer`, `/morning-brief`, `/health-check`, `/map-results`
- **Skill privacy rule:** `feedback_skill_privacy_mcp_enumeration.md`

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — CRUD subcommands, auto-trigger patterns, privacy rules per real-data-readiness pass. |
