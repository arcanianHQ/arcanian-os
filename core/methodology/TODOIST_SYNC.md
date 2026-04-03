# Todoist Sync Standard

> Last updated: 2026-03-24
> Status: ACTIVE — migrated from Asana (ExampleBrand) + Todoist Inbox triage

## Principle

**TASKS.md = source of truth.** Todoist = sync target + mobile capture layer.

- New tasks captured in Todoist → route to numbered project → sync to TASKS.md
- Tasks created in TASKS.md → create in Todoist with matching `#ID` prefix
- Conflicts: `Updated:` timestamp in TASKS.md vs Todoist `updatedAt` — newer wins

## Todoist Project Tree (600s = Clients)

### Active Clients

| # | Client | Todoist ID | TASKS.md | Notes |
|---|---|---|---|---|
| 601.1 | ExampleRetail Marketing | `{todoist-project-id}` | `clients/example-retail/TASKS.md` | |
| 601.2 | ExampleRetail Loyalty | `{todoist-project-id}` | `clients/example-retail/TASKS.md` | |
| 602 | ExampleBrand | `{todoist-project-id}` | `clients/example-ecom/TASKS.md` | Migrated from Asana 2026-03-24 |
| 603.1 | ExampleEdu Editoria | `{todoist-project-id}` | `clients/example-edu/TASKS.md` | |
| 603.2 | ExampleEdu Academy | `{todoist-project-id}` | `clients/example-edu/TASKS.md` | [Tool] = tool, not client |
| 603.3 | ExampleEdu Welcome | `{todoist-project-id}` | `clients/example-edu/TASKS.md` | |
| 604.1 | ExampleBuild Marketing | `{todoist-project-id}` | `clients/ExampleBuild/TASKS.md` | |
| 604.2 | ExampleBuild ProcessDev | `{todoist-project-id}` | `clients/ExampleBuild/TASKS.md` | |
| 605.1 | ExampleSoft HU | `{todoist-project-id}` | `clients/ExampleSoft/TASKS.md` | |
| 605.2 | ExampleSoft SK | `{todoist-project-id}` | `clients/ExampleSoftsk/TASKS.md` | |
| 605.3 | ExampleSoft RO | `{todoist-project-id}` | — | |
| 605.4 | ExampleSoft Codeguru | `{todoist-project-id}` | — | |
| 605.5 | ExampleSoft DigitalSoft | `{todoist-project-id}` | — | |
| 606.1 | ExampleClient1 | `{todoist-project-id}` | — | |
| 606.2 | ExampleClient2 | `{todoist-project-id}` | — | |
| 606.3 | ExampleClient3 | `{todoist-project-id}` | — | |
| 607.1 | ExampleDev | `{todoist-project-id}` | — | |
| 607.2 | ExampleMkt | `{todoist-project-id}` | — | |
| 608 | ExampleLocal | `{todoist-project-id}` | `clients/examplelocal/TASKS.md` | |
| 612.1 | ExampleVis1 | `{todoist-project-id}` | — | |
| 612.2 | ExampleVis2 | `{todoist-project-id}` | — | |
| 613 | ExampleCurtain | `{todoist-project-id}` | — | |
| 614 | ExampleNov | `{todoist-project-id}` | — | |
| 615 | ExamplePower | `{todoist-project-id}` | — | |
| 616 | ExampleSel | `{todoist-project-id}` | — | |
| 617 | ExampleAPS | `{todoist-project-id}` | — | |
| 618 | ExampleVital | `{todoist-project-id}` | — | |

### Archived Clients (grey)

| # | Client | Todoist ID |
|---|---|---|
| 609 | ExampleCarib [ARCHIVE] | `{todoist-project-id}` |
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

For ExampleBrand (legacy Asana reference):
```yaml
sync: todoist
sync_id: "{todoist-project-id}"
# Legacy Asana: EXAMPLE-ID-001 (read-only, migrated 2026-03-24)
```

## Sync Rules

1. **Task ID prefix:** Todoist task content starts with `#ID` matching TASKS.md (e.g. `#112 [Client Contact] egyeztetés`)
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
| 2026-03-24 | ExampleBrand: 93 Asana tasks cross-referenced → 6 new added to TASKS.md, 80 created in Todoist 602 |
| 2026-03-24 | ExampleBrand: Asana sync removed, Todoist is now sole sync target |
| 2026-03-24 | ExampleEdu: `clients/example-edu/` scaffolded with 7 tasks |
| 2026-03-24 | Hub TASKS.md: 15 ops tasks added (#40-#54) |
| 2026-03-24 | ExampleRetail TASKS.md: 5 tasks added (#55-#59) |
| 2026-03-24 | ExampleBuild TASKS.md: 2 tasks added (#19-#20) |
