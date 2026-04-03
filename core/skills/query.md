# /query — Ontology Graph Traversal

> Traverse the Arcanian Ops ontology. Follow edges between objects to answer questions.

## Usage

```
/query FND-039          — finding + connected tasks, recs, patterns
/query PAT-035          — pattern + clients where seen + findings
/query lead euronics    — lead status + timeline + connected tasks
/query layer L5         — all tasks tagged L5 across all clients
/query waiting          — all @waiting tasks + who we're waiting on
/query client exampleretail     — task summary + findings + brand profile
/query REC-039          — recommendation + what it addresses + tasks
/query #53              — task + all edges (FND, REC, Lead, Layer)
```

## Process

### Step 1: Parse query target

| Input | Type | Primary file(s) |
|-------|------|-----------------|
| `FND-NNN` | Finding | `clients/*/findings/FND-NNN-*.md` |
| `REC-NNN` | Recommendation | `clients/*/findings/REC-NNN-*.md` |
| `PAT-NNN` | Pattern | `core/methodology/KNOWN_PATTERNS.md` |
| `lead <slug>` | Lead | `core/leads/LEAD_STATUS.md` |
| `layer L<N>` | Layer | all `clients/*/TASKS.md` |
| `waiting` | Status | all `clients/*/TASKS.md` (grep @waiting) |
| `client <slug>` | Client | `clients/<slug>/` (all files) |
| `#NNN` | Task | all `clients/*/TASKS.md` (grep #NNN) |

### Step 2: Read primary file

Read the primary file for the target object. Extract all metadata and edge references.

### Step 3: Follow edges

For each edge found in the primary file, follow it:

| From | Edge syntax found | Follow to |
|------|-------------------|-----------|
| Finding | `Tasks: #53, #54` | Search TASKS.md for those task numbers |
| Finding | `Related: REC-039` | Read the REC-039 file |
| Finding | `Pattern: PAT-035` | Read KNOWN_PATTERNS.md, find PAT-035 row |
| Task | `FND: FND-039` | Read the FND-039 file |
| Task | `Lead: euronics` | Read LEAD_STATUS.md, find euronics section |
| Pattern | `Seen in:` table | List all clients + finding refs |
| Lead | `Tasks: #12, #14` | Search TASKS.md for those tasks |
| Recommendation | `Addresses: FND-039` | Read FND-039 file |

Also search for **reverse edges** -- references TO this object from other files:
- For `FND-039`: grep all TASKS.md for `FND-039` (find tasks that reference it)
- For `lead euronics`: grep all TASKS.md for `Lead: euronics`
- For `PAT-035`: grep all findings for `Pattern: PAT-035`

### Step 4: Present connected graph

## Output Format

```
QUERY: <ID> (<client if known>)

<Type>: <ID> -- <title>
  <metadata line: severity, phase, layer, status, etc.>

  -> Tasks referencing this:
    #53 Fix dead GTM message bus (P0, @next) -- TASKS.md line 19
    #54 Validate GA4 event flow (P1, @later) -- TASKS.md line 42

  -> Recommendation:
    REC-039 -- Re-link gaawe tags to Google Tag
    Status: open | Addresses: FND-039

  -> Pattern match:
    PAT-035 -- Dead GA4 message bus (measurementIdOverride)
    Seen in: ExampleRetail (FND-039), ExampleLocal (FND-007 -- at risk)

  -> Lead:
    exampleretail -- Status: active-engagement

  ! Missing edges:
    - FND-039 has no Tasks: backlink (should list #53)
```

### Special queries

**`/query waiting`** -- show all @waiting tasks grouped by client:
```
WAITING TASKS (2026-03-24)

ExampleRetail (3):
  #55 Await GA4 property access from Jeno | @waiting | since 2026-03-15
  #58 CRM export from sales team | @waiting | since 2026-03-18

ExampleBrand (1):
  #12 Brand asset package from design | @waiting | since 2026-03-20
```

**`/query layer L5`** -- show all L5 tasks across clients:
```
LAYER L5 TASKS (Channel)

ExampleRetail (4):
  #53 Fix dead GTM message bus (P0, @next)
  #54 Validate GA4 event flow (P1, @later)

ExampleBrand (2):
  #30 Audit Meta pixel setup (P1, @next)
```

**`/query client exampleretail`** -- full client summary:
```
CLIENT: ExampleRetail

Task summary: 12 open (3 P0, 5 P1, 4 P2) | 8 done | 3 @waiting
Findings: 15 open, 22 resolved | 37 total
Top layers: L5 (12), L3 (8), L2 (6)
Lead status: active-engagement

Recent activity:
  #53 Fix dead GTM message bus -- moved to @next (2026-03-22)
  FND-041 discovered (2026-03-21)
```

## Edge integrity check

When presenting results, always flag missing edges:
- Finding with no `Tasks:` section
- Task with `FND:` but finding has no `Tasks:` backlink
- Task mentioning a lead name but no `Lead:` edge
- Recommendation with no `Addresses:` link

These appear as `! Missing edges:` in the output.
