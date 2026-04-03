---
project: "project-name"
sync: todoist
sync_id: ""
updated: 2026-03-23T00:00
---

# Project Name — Tasks

> Local source of truth. Syncs to `sync:` system via timestamp-based conflict resolution.
> `Updated:` vs external `updatedAt` vs `synced:` — newer wins. Both changed = conflict → flag.
> Done tasks → `TASKS_DONE.md`

---

## P0 — Critical

- [ ] Fix dead GTM message bus — link gaawe tags to Google Tag
  - @next @computer
  - P0 | Owner: [Owner] | Due: ASAP | Effort: 2h | Impact: unlock
  - Created: 2026-03-08 | Updated: 2026-03-23
  - FND: FND-039 | REC: REC-039
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 3 Container Fix
  - Goal: Q1-exampleretail-measurement-health
  - Meeting: 2026-03-11 ExampleRetail weekly review
  - ext: 000000000000 | synced: 2026-03-23T14:30
  - ROOT CAUSE of ALL post-init event failures across all 3 countries

---

## P1 — High

- [ ] Remove duplicate JSON-LD block (price "0")
  - @waiting
  - P1 | Owner: ITG (Jenő) | Effort: 30m | Impact: hygiene
  - Created: 2026-03-04 | Updated: 2026-03-23
  - FND: FND-006 | REC: REC-006
  - Email: Jenő 2026-03-04 "JSON-LD duplicate block törlés"
  - Meeting: 2026-03-11 ExampleRetail weekly — follow up if no reply
  - ext: 8234567890 | synced: 2026-03-23T14:30

- [ ] Wire user data into SGTM Google Ads conversion tags
  - @next @computer
  - P1 | Owner: [Owner] | Effort: 15m | Impact: lever
  - Created: 2026-03-08 | Updated: 2026-03-23
  - FND: FND-045 | REC: REC-045
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 3 → Enhanced Conversions
  - Goal: Q1-exampleretail-measurement-health

- [ ] Check Meta catalogue match rate post-fix
  - @monitor
  - P1 | Owner: [Owner] | Due: 2026-03-14 | Effort: 15m | Impact: lever
  - Created: 2026-03-08 | Updated: 2026-03-23
  - Check: Meta Commerce Manager → HU → Match Rate
  - Baseline: 60.6% (2026-03-07)
  - Target: 75%+
  - Frequency: weekly until stable
  - FND: FND-002, FND-007
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 2 → Dashboard Verification
  - Goal: Q1-exampleretail-measurement-health

- [ ] Fix GAds conversion action priorities — only Purchase as Primary
  - @decision
  - P1 | Owner: [Owner] | Effort: 15m | Impact: lever
  - Created: 2026-03-08 | Updated: 2026-03-23
  - FND: FND-012
  - Options: (a) set only Purchase as Primary (b) keep ATC as Secondary
  - ATC, Begin Checkout, Page view all set as Primary → confuses Smart Bidding

---

## P2 — Medium

- [ ] Add consent gating to all Google tags
  - @next @computer
  - P2 | Owner: [Owner] | Effort: 2h | Impact: hygiene
  - Created: 2026-03-08 | Updated: 2026-03-23
  - FND: FND-002, FND-003, FND-011
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 1 → Consent Check
  - Email: [Name] 2026-03-17 developer changes confirmed
  - 7 cookies pre-consent. GDPR.

- [ ] [Agency A] contract ends
  - @reminder
  - P2 | Date: 2026-03-31 | Impact: hygiene
  - Created: 2026-03-03 | Updated: 2026-03-23
  - SOP: 01-AGENCY-COORDINATION
  - Meeting: 2026-04-02 09:30 átadási call

- [ ] ExampleBrand — end of Month 2
  - @milestone
  - P2 | Date: 2026-04-23 | Impact: breakthrough
  - Created: 2026-03-03 | Updated: 2026-03-23
  - Goal: Q1-examplebrand-transition
  - Review: agency transition complete? measurement baseline set?

---

## P3 — Low

- [ ] Implement OCT (Offline Conversion Tracking)
  - @someday
  - P3 | Owner: [Owner] + ITG | Effort: 2w+ | Impact: breakthrough
  - Created: 2026-03-04 | Updated: 2026-03-23
  - FND: FND-028 | REC: REC-028
  - SOP: MEASUREMENT_HEALTH_SOP → Phase 5 → Advanced Attribution
  - Goal: Q2-exampleretail-offline-attribution
  - Meeting: needs kickoff with ExampleRetail sales team
  - 60% in-store pickup — huge offline gap

- [ ] Fix Snapchat click_id typo in SGTM
  - @someday
  - P3 | Owner: [Owner] | Effort: 15m | Impact: noise
  - Created: 2026-03-13 | Updated: 2026-03-23
  - Paused tag, fix before enabling

---

## Reference

- [ ] Asana boards
  - @reference
  - C:ExampleBrand Transition: `EXAMPLE-ID-001`
  - GD Asana: `EXAMPLE-ID-001`

- [ ] GTM container IDs
  - @reference
  - HU: GTM-EXAMPLE-001-005

---

> **Done tasks → `TASKS_DONE.md`** (separate file, append-only, newest first)

---

## Format Reference

### Task anatomy
```
- [ ] Task description
  - @type @context                          ← GTD labels (always first)
  - P# | Owner: X | Due: Y | Effort: T | Impact: V  ← core metadata
  - Created: YYYY-MM-DD | Updated: YYYY-MM-DD        ← timestamps (always present)
  - FND: / REC: / SOP: / Goal:             ← ontology edges (what applies)
  - Meeting: / Email:                       ← people/calendar edges
  - ext: ID | synced: YYYY-MM-DDTHH:MM     ← sync metadata (if synced)
  - Free text notes                         ← context
```

### Line order (fixed)
1. `@labels` — GTD type + context
2. `P# | Owner | Due | Effort | Impact` — core metadata
3. `Created: | Updated:` — timestamps (always present)
4. Ontology edges — FND, REC, SOP, Goal (what applies)
5. People edges — Meeting, Email (what applies)
6. Monitor fields — Check, Baseline, Target, Frequency (if @monitor)
7. Sync — ext, synced (if synced to external system)
8. Notes — free text context

### GTD labels
| Label | Type |
|---|---|
| `@next` | Ready to do now |
| `@waiting` | Blocked on someone |
| `@someday` | Not committed |
| `@reminder` | Awareness, no action |
| `@monitor` | Check periodically |
| `@decision` | Needs a choice |
| `@reference` | Stored context |
| `@milestone` | Point in time |
| `@computer` `@phone` `@email` | Context |
| `@deep` `@quick` | Energy/time |

### Impact scale
| Value | Meaning |
|---|---|
| `noise` | Doesn't move anything meaningful |
| `hygiene` | Prevents problems, avoids downside |
| `lever` | Multiplies something already working |
| `unlock` | Removes a blocker, opens new capability |
| `breakthrough` | Changes the game |

### Effort scale
`15m` `30m` `1h` `2h` `4h` `1d` `2d` `3d` `1w` `2w+`

### Sync systems
`todoist` `asana` `trello` `bitrix` `none`

### Priority
| P | Meaning |
|---|---|
| P0 | Critical — fix now |
| P1 | High — this week |
| P2 | Medium — within 2 weeks |
| P3 | Low — at convenience |

### Timestamps
- `Created:` YYYY-MM-DD — when task was first written (never changes)
- `Updated:` YYYY-MM-DD — last local edit (changes on every modification)
- `synced:` YYYY-MM-DDTHH:MM — last sync with external system (needs time precision for conflict resolution)

### Monitor extra fields
```
- Check: what to look at and where
- Baseline: starting value (date)
- Target: what "good" looks like
- Frequency: when to check
- Risk: what could go wrong
```

### Rules
- Only include metadata lines that apply (no empty fields)
- `Created:` and `Updated:` are ALWAYS present on every task
- Tasks live in the priority section matching their P level
- @reference items go in Reference section (no priority)
- Completed tasks move to TASKS_DONE.md (separate file, newest first)
- Update frontmatter `updated:` on every change
- Task numbers are sequential per project, never reused
- TASKS.md = active only (100-300 per project). TASKS_DONE.md = archive (append-only)
