# Arcanian Ops Ontology Standard

> Canonical reference for how objects connect across the Arcanian Ops system.
> Palantir-style ontology: typed objects + typed edges + bidirectional linking.

## Object Types

| Object | ID Format | Lives In | Example |
|--------|-----------|----------|---------|
| **Task** | `#NNN` | `clients/<slug>/TASKS.md` | `#53 Fix dead GTM message bus` |
| **Finding** | `FND-NNN` | `clients/<slug>/findings/FND-NNN-*.md` | `FND-039-dual-ga4-config-tags.md` |
| **Recommendation** | `REC-NNN` | `clients/<slug>/findings/REC-NNN-*.md` | `REC-039-relink-gaawe-tags.md` |
| **Pattern** | `PAT-NNN` | `core/methodology/KNOWN_PATTERNS.md` | `PAT-035 Dead GA4 message bus` |
| **SOP** | `SOP-NN-name` | `core/sops/` | `SOP-05-campaign-launch.md` |
| **Goal** | shallow tag | task inline / project-level | `Q1-ship-prism` |
| **Layer** | `L0`..`L7` | Arcanian Marketing Control Framework | `L5` (Channel) |
| **Meeting** | date + label | task inline | `2026-03-10 IT` |
| **Email** | name + date | task inline | `Jeno 2026-03-04` |
| **Lead** | slug | `core/leads/LEAD_STATUS.md` | `euronics` |
| **Person** | name | contacts / inline | `Jeno Koller` |
| **Client** | slug | `clients/<slug>/` | `exampleretail`, `examplebrand` |

---

## Edge Types

All edges SHOULD be bidirectional. Forward = where you write it first. Backward = where you add the backlink.

### Task Edges

| Edge | Forward (in Task) | Backward | Bidirectional? |
|------|-------------------|----------|----------------|
| Task -> Finding | `FND: FND-039` in task line | `Tasks: #53` in finding file | YES - required |
| Task -> Recommendation | `REC: REC-039` in task line | `Tasks: #53` in recommendation file | YES - required |
| Task -> SOP | `SOP: 05-campaign` in task line | _(not tracked in SOP -- too many refs)_ | One-way |
| Task -> Goal | `Goal: Q1-ship-prism` in task line | _(tracked in goal definition if exists)_ | Soft |
| Task -> Layer | `Layer: L5` in task line | _(queryable via grep)_ | Queryable |
| Task -> Meeting | `Meeting: 2026-03-10 IT` in task line | _(text reference)_ | One-way |
| Task -> Email | `Email: Jeno 2026-03-04` in task line | _(text reference)_ | One-way |
| Task -> Lead | `Lead: euronics` in task line | `Tasks:` section in LEAD_STATUS.md | YES - required |

### Finding / Recommendation / Pattern Edges

| Edge | Forward | Backward | Bidirectional? |
|------|---------|----------|----------------|
| Finding -> Recommendation | `Related: REC-NNN` in finding | `Addresses: FND-NNN` in recommendation | YES - required |
| Finding -> Pattern | `Pattern: PAT-035` in finding | `Seen in:` table row in pattern | YES - required |
| Finding -> Task | `Tasks: #53, #54` in finding | `FND: FND-039` in task | YES - required |
| Pattern -> Client | `Seen in:` table in pattern | _(queryable)_ | Queryable |
| Lead -> Task | `Tasks:` section in LEAD_STATUS | `Lead: slug` in task | YES - required |

---

## Edge Syntax Examples

### In TASKS.md
```
#53 Fix dead GTM message bus | P0 @next
    FND: FND-039 | REC: REC-039 | Layer: L5 | Lead: exampleretail
    Meeting: 2026-03-10 IT | Email: Jeno 2026-03-04
```

### In a Finding file (FND-039)
```
## Links
- Tasks: #53, #54
- Related: REC-039
- Pattern: PAT-035
- Layer: L5
```

### In a Recommendation file (REC-039)
```
## Links
- Addresses: FND-039
- Tasks: #53
```

### In KNOWN_PATTERNS.md (PAT-035)
```
| PAT-035 | Dead GA4 message bus | L5 | ExampleRetail (FND-039), ExampleLocal (FND-007) |
```

### In LEAD_STATUS.md
```
## euronics
Status: analysis-complete
Tasks: #12, #14, #15, #22
```

---

## Rules

1. **Every required edge MUST be bidirectional.** When you write `FND: FND-039` in a task, also add `Tasks: #N` to the finding file.
2. **When completing a task that references a finding**, update the finding's status if the finding is now resolved.
3. **When creating a finding**, always include a `Tasks:` section -- even if empty (`Tasks: (none yet)`).
4. **When a task mentions a lead name** (euronics, heavy-tools, etc.), add a `Lead:` edge to the task.
5. **The `/query` skill can traverse these edges** -- correct linking makes querying possible.
6. **IDs are globally unique per type.** FND-039 exists once across all clients. The client is inferred from the file path.
7. **Soft edges** (Goal, Meeting, Email, SOP) are informational -- no backlink enforcement. They exist for context.

---

## Current Coverage (2026-03-24 baseline)

### What we have

| Edge Type | Count | Notes |
|-----------|-------|-------|
| Task -> Layer | ~201 | Most tasks tagged with layer |
| Task -> Finding | ~35 | FND references in task files |
| Finding -> Recommendation | ~35 | Most findings have matching recs |
| Finding -> Pattern | ~15 | Pattern matches documented |
| Pattern -> Client (`Seen in:`) | ~20 | Cross-client pattern table |

### What's missing

| Edge Type | Count | Gap |
|-----------|-------|-----|
| Task -> Lead | 0 | No `Lead:` edges in any TASKS.md |
| Lead -> Task | 0 | No `Tasks:` sections in LEAD_STATUS.md |
| Finding -> Task (backlinks) | 0 | Findings don't link back to tasks |
| Recommendation -> Task (backlinks) | 0 | Recs don't link back to tasks |
| Task -> Meeting | 0 | Meeting references not tracked |
| Task -> Email | 0 | Email references not tracked |
| Task -> Goal | 0 | Goal tags not used yet |

### Priority backfill order

1. **Finding <-> Task backlinks** -- highest value, enables `/query FND-NNN` to show related tasks
2. **Lead <-> Task edges** -- enables `/query lead euronics` to show all related work
3. **Task -> Goal** -- enables progress tracking against quarterly goals
4. **Meeting/Email references** -- lowest priority, informational only
