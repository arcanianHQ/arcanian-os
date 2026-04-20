---
scope: shared
created: 2026-04-18
type: methodology rule — append-only contribution pattern + daily housekeeping
status: Active — companion to `GIT_LFS_LOCKS.md`; composed, not alternative.
purpose: Coordinate parallel contributions from multiple practitioners without locks. Each practitioner appends a timestamped, named, signed file in a `contributions/` subdirectory. A daily (or rotating) housekeeping ritual merges contributions into the canonical file and archives what's been merged. Preserves every contributor's voice; avoids overwrite collisions entirely.
related:
  - core/methodology/GIT_LFS_LOCKS.md (the serialised-access pattern for canonical files)
  - core/skills/contribute.md
  - core/skills/housekeeping.md
  - core/agents/housekeeper.md
  - .claude/rules/contribution-files.md
---

# Contribution Files and Daily Housekeeping

## The pattern in one sentence

**Never overwrite a shared file. Create a new, timestamped, signed contribution. Merge daily.**

## Why this pattern exists

Locks serialise access: one practitioner edits at a time, others wait. That works for files where there is one right answer at any moment (the canonical `ACCOUNTABILITY_MAP.md`, the `LOOP_TRACKER.md`, the weekly scorecard).

But for files where **multiple perspectives are valuable** — a diagnosis with input from three practitioners; a pattern discussion; a quarterly retro with contributions from everyone who ran an engagement — serialising kills the collaboration. Forcing one person to "own the document" loses the other voices.

The contribution pattern keeps everyone's voice intact:
- Any practitioner can contribute any time — no waiting
- Every contribution is **signed and timestamped** — attribution permanent
- **Nothing is overwritten** — contributions sit alongside each other until housekeeping
- **Daily housekeeping** merges contributions into the canonical file, archives the sources, and keeps a trail

## Directory convention

For each canonical file that uses this pattern, create a sibling `contributions/` directory.

Examples:

| Canonical file | Contributions directory |
|---|---|
| `clients/{slug}/diagnoses/DIAGNOSIS_{date}.md` | `clients/{slug}/diagnoses/contributions/` |
| `internal/ACCOUNTABILITY_MAP.md` | `internal/accountability-map/contributions/` |
| `internal/patterns/{YYYY-MM}_pattern-log.md` | `internal/patterns/contributions/` |
| `clients/{slug}/LOOP_TRACKER.md` | `clients/{slug}/loop-tracker-updates/` |
| `internal/strategy/POSITIONING_2026.md` | `internal/strategy/positioning-contributions/` |

## Filename convention

```
YYYY-MM-DD_HHMM_initials_brief-description.md
```

- **YYYY-MM-DD_HHMM** — timestamp (date required; time optional but recommended for same-day contributions)
- **initials** — contributor's initials (lf for László, ee for Éva, dd for Dóra, etc. Use the initials from the team profile if in doubt)
- **brief-description** — 2–5 words, kebab-case, describing the substance

Examples:
- `clients/diego/diagnoses/contributions/2026-04-18_1430_lf_partner-psychology-evidence.md`
- `internal/accountability-map/contributions/2026-04-18_ee_ops-seat-transition-proposal.md`
- `internal/patterns/contributions/2026-04-19_dd_feed-bundle-suffix-observation.md`

## Contribution file structure

Every contribution has a frontmatter block identifying what it contributes to:

```yaml
---
scope: int-company
contributes_to: clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
contribution_type: evidence | observation | proposed-edit | pattern | dispute | note
signed_by: László Fazakas
signed_date: 2026-04-18
status: proposed | merged | archived | rejected
---
```

The body is the contribution itself — prose, a table, a list, a counter-argument, whatever the type demands.

## Contribution types (vocabulary)

- **evidence** — new data/observation that supports or contradicts the canonical claim
- **observation** — something the contributor saw that the canonical didn't capture
- **proposed-edit** — specific edit request, often with a proposed diff or full rewrite
- **pattern** — a named pattern observed during work on this artefact
- **dispute** — explicit disagreement with part of the canonical; must name what and why
- **note** — anything else; low-cost entry point for "I want to capture this but don't know where it fits"

## The workflow

### Practitioner contributes (anytime, any practitioner)

Use the skill:

```
/contribute <canonical-path> [--type proposed-edit] [--brief "two-three-words"]
```

This skill:
1. Resolves the canonical path
2. Creates `<canonical-dir>/contributions/YYYY-MM-DD_HHMM_{initials}_{brief}.md` with frontmatter populated from the user's git identity and the current timestamp
3. Opens the file for the practitioner to write
4. Does not touch the canonical file — zero collision risk

### Housekeeper merges (daily, per-artefact or per-agency)

Use the skill:

```
/housekeeping <canonical-path>
```

Or invoke the agent:

```
@housekeeper
```

The housekeeper:
1. Locks the canonical file (via the lock system)
2. Scans the adjacent `contributions/` directory for contributions with `status: proposed`
3. For each contribution, presents to the user (or decides per rules): **merge / archive / reject**
4. For `merge`: applies the contribution to the canonical file, updates the contribution's frontmatter to `status: merged`, and moves it to `contributions/merged/YYYY-MM/`
5. For `archive`: updates to `status: archived`, moves to `contributions/archived/YYYY-MM/`, leaves a one-line reason in the contribution's frontmatter
6. For `reject`: updates to `status: rejected`, moves to `contributions/archived/YYYY-MM/`, requires a reason
7. Releases the lock

The canonical file now reflects the merged consensus. Every contribution is preserved in `merged/` or `archived/` — nothing is ever lost.

## Cadence — when does housekeeping run?

Three natural cadences:

**Per-artefact, on-demand.** When a practitioner is about to present the canonical to a client or a decision, they run housekeeping first. Most common for diagnoses, scorecards, and commitments.

**Weekly, as part of the Weekly Pulse ritual.** The ops lead runs `/housekeeping --all` to merge any outstanding contributions across the whole repo. Prevents backlog.

**Per-client, monthly.** The account lead for each client reviews that client's contribution backlog monthly, independent of the agency-wide sweep.

If a contributions directory has >10 unmerged contributions or any contribution older than 14 days, the **housekeeper agent** flags it during the Weekly Pulse. Backlog is a signal the ritual is drifting.

## The layered model — how locks and contributions compose

| Situation | Use |
|---|---|
| One canonical file, one practitioner editing at a time | **Lock** (`/lock-edit`) |
| One canonical file, multiple practitioners contributing perspectives | **Contribute** (`/contribute`) + **Housekeeping** |
| Pure data that's machine-generated | Neither (plain git, merge conflicts fine) |
| Reference-only files (skills, agents, SOPs) | Neither |
| Strategic docs with significant team input needed | Both — contributions for input, locks on the canonical during housekeeping merge |

## Benefits (earned by the discipline)

- **No overwrites, ever.** Every practitioner's contribution is preserved with their name.
- **Parallel work.** Three practitioners can contribute to the same diagnosis simultaneously without stepping on each other.
- **Audit trail built in.** The `contributions/merged/` and `contributions/archived/` directories are the history of how the canonical file became what it is.
- **Attribution by default.** Habit 5 (carry lessons through people) is enforced at the file-system level — the signer's name is on the file before it's ever opened.
- **Low friction.** No locking ceremony; just write your contribution.

## Costs (acknowledged)

- **Housekeeping ritual required.** If nobody merges, contributions pile up and the canonical drifts from reality.
- **Directory sprawl.** Each canonical gets its own contributions/, merged/, archived/ subtree. Tolerable; git handles it fine.
- **Merge skill needed.** The housekeeper has to actually synthesise contributions, not just paste them in. This is real intellectual work.
- **Naming discipline.** If practitioners don't follow the filename convention, merging gets harder.

## When to prefer locks over contributions, and vice versa

**Prefer locks when:**
- The file is a single-canonical state artefact (the current scorecard, the current map)
- Updates are small and independent (fix a typo, update a number)
- Serialising is cheap (nobody actually needs to be editing right now)

**Prefer contributions when:**
- The file represents a conversation or decision
- Multiple perspectives genuinely matter
- Locking would bottleneck the team
- The file's final state emerges from discussion, not a single author

**In doubt? Use contributions.** The lock system has sharper teeth but contributions has gentler teeth and preserves more voice. If you're not sure which pattern the artefact needs, contributions is the safer default.

## Where the two systems share infrastructure

- **Git LFS locks** are the mechanism by which the housekeeper acquires exclusive write on the canonical file during the merge pass.
- **The lock-auditor agent** and the **housekeeper agent** both report into the Weekly Pulse ritual. They produce complementary reports.
- **`.gitattributes`** declares both "lockable" paths (for locks) and (soon) "contribution-target" paths (for housekeeping).

Together they give AOS a real distributed co-working story that works offline-first, ships today on any git remote, and costs zero extra infrastructure — until the amazee.io hosted hub arrives and builds real-time presence on top of the same backbone.
