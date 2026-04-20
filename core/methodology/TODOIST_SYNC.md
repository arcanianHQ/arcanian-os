---
scope: shared
---

# Todoist Sync Standard

> Last updated: 2026-03-24
> Status: ACTIVE — migrated from Asana (Wellis) + Todoist Inbox triage

## Principle

**TASKS.md = source of truth.** Todoist = sync target + mobile capture layer.

- New tasks captured in Todoist → route to numbered project → sync to TASKS.md
- Tasks created in TASKS.md → create in Todoist with matching `#ID` prefix
- Conflicts: `Updated:` timestamp in TASKS.md vs Todoist `updatedAt` — newer wins

## Todoist Project Tree (600s = Clients)

### Active Clients

| # | Client | Todoist ID | TASKS.md | Notes |
|---|---|---|---|---|
| 601.1 | Diego Marketing | `6X3pHx76VjqWHwmV` | `clients/diego/TASKS.md` | |
| 601.2 | Diego Klubkártya | `6X3qrv42vQG6HwQ4` | `clients/diego/TASKS.md` | |
| 602 | Wellis | `6gFHC29R3ghhp525` | `clients/wellis/TASKS.md` | Migrated from Asana 2026-03-24 |
| 603.1 | DHORA Editoria | `6X3vPgvrQCVPmrpw` | `clients/dhora/TASKS.md` | |
| 603.2 | DHORA Academy | `6X3vPhXQR6pCHjq5` | `clients/dhora/TASKS.md` | Entello = tool, not client |
| 603.3 | DHORA Welcome | `6X3vPjJVF3R25C3j` | `clients/dhora/TASKS.md` | |
| 604.1 | Deluxe Marketing | `6X3pJ37g2ffPXxvg` | `clients/deluxe/TASKS.md` | |
| 604.2 | Deluxe ProcessDev | `6X3qwVW9RhVP3hRX` | `clients/deluxe/TASKS.md` | |
| 605.1 | VRSoft HU | `6X3pGR76h4wvPWHC` | `clients/vrsoft/TASKS.md` | |
| 605.2 | VRSoft SK | `6X3qvPRW6g23HFFp` | `clients/vrsoftsk/TASKS.md` | |
| 605.3 | VRSoft RO | `6X3qvGvXJX85JFF5` | — | |
| 605.4 | VRSoft Codeguru | `6X3qvVWWxfFR6c84` | — | |
| 605.5 | VRSoft DigitalSoft | `6X3qvcQJ6PvQqcV7` | — | |
| 606.1 | András CFH | `6X3pHrcv9HgQJjFP` | — | |
| 606.2 | András Cégalapító | `6X3qvp5r4wrWWVWC` | — | |
| 606.3 | András OffshoreMarket | `6X3qw6P7XR57wm85` | — | |
| 607.1 | Domy Fejlesztés | `6Wqjjmc9vCvj244h` | — | |
| 607.2 | Domy Marketing | `6X3qv7V72wW8VPRg` | — | |
| 608 | MancsBázis | `6X3pHvWMP9xHHXgM` | `clients/mancsbazis/TASKS.md` | |
| 612.1 | Visibility Puella | `6X3qwpgm5MwxF8VX` | — | |
| 612.2 | Visibility Namaximum | `6X3qwr7FwHMFJWr4` | — | |
| 613 | LindaFüggöny | `6X3qvwrw3WXmG5M8` | — | |
| 614 | Novossadi | `6X3qw42fxxPF7qxP` | — | |
| 615 | KPower | `6X3qwX4jhjHCqh65` | — | |
| 616 | Selet | `6X3vP9X9VhQPqXCr` | — | |
| 617 | VajneAPS | `6X3vmJ46JXGCWMch` | — | |
| 618 | Vital | `6X3qwwMQ8r2rwf3R` | — | |

### Archived Clients (grey)

| # | Client | Todoist ID |
|---|---|---|
| 609 | Caribú [ARCHIVE] | `6X3pJ24F5RgXJWQG` |
| 610.1-3 | MOTP [ARCHIVE] | Marketing/WP/Magento |
| 611.1-2 | Kmon [ARCHIVE] | Magento/Marketing |

### Non-Client Projects (unchanged)

| Range | Category |
|---|---|
| 11 | Personal Documents |
| 21-29 | Learning |
| 31-39 | Spiritual/Personal Dev |
| 41-48 | Home/Personal |
| 51-54 | Legal/HR/Company |
| 71-74 | Courses |
| 81-89 | Finance/Internal IT |
| 91-97 | Business Dev |

## TASKS.md Frontmatter

```yaml
---
project: "client-slug"
sync: todoist
sync_id: "todoist-project-id"
updated: 2026-03-24T16:00
---
```

For Wellis (legacy Asana reference):
```yaml
sync: todoist
sync_id: "6gFHC29R3ghhp525"
# Legacy Asana: 1213304520507935 (read-only, migrated 2026-03-24)
```

## Sync Rules

1. **Task ID prefix:** Todoist task content starts with `#ID` matching TASKS.md (e.g. `#112 Ákos egyeztetés`)
2. **Priority mapping:** TASKS.md P0→Todoist p1, P1→p2, P2→p3, P3→p4
3. **Todoist description:** Contains `P-level | Layer | dependencies`
4. **New capture flow:** Todoist Inbox → route to numbered project → sync to TASKS.md in next session
5. **Completion:** Complete in either system → sync the other
6. **Grouped tasks in Todoist:** Some P3 tasks are grouped (e.g. `#93-103 L1-L7 rendszer feladatok`) — individual items live in TASKS.md

## Migration Log

| Date | Action |
|---|---|
| 2026-03-24 | Todoist Inbox triage: 62 tasks enriched, named, routed to numbered projects |
| 2026-03-24 | Todoist project tree: all clients numbered 601-618 |
| 2026-03-24 | Wellis: 93 Asana tasks cross-referenced → 6 new added to TASKS.md, 80 created in Todoist 602 |
| 2026-03-24 | Wellis: Asana sync removed, Todoist is now sole sync target |
| 2026-03-24 | DHORA: `clients/dhora/` scaffolded with 7 tasks |
| 2026-03-24 | Hub TASKS.md: 15 ops tasks added (#40-#54) |
| 2026-03-24 | Diego TASKS.md: 5 tasks added (#55-#59) |
| 2026-03-24 | Deluxe TASKS.md: 2 tasks added (#19-#20) |
