---
scope: shared
argument-hint: canonical-path OR --all (sweep everything) OR --client slug (per-client sweep)
---

# `/housekeeping` — Merge pending contributions into a canonical file

## Purpose

Process the backlog of contributions sitting in a `contributions/` directory adjacent to a canonical file. For each pending contribution: **merge** into the canonical, **archive** without merging, or **reject** with reason. Preserve every contribution in `merged/` or `archived/` subdirectories so nothing is ever lost.

This is the daily (or weekly) ritual that keeps the append-only contribution pattern honest. See `core/methodology/CONTRIBUTION_FILES_AND_HOUSEKEEPING.md`.

## When to invoke

- **Before a client-facing touchpoint** — run housekeeping on that client's canonical files so the document reflects the latest team input.
- **Weekly Pulse (Monday)** — ops lead runs `/housekeeping --all` to sweep agency-wide backlogs.
- **Per-client monthly** — account lead runs `/housekeeping --client {slug}` to clear per-client backlog.
- **When the `lock-auditor` or `housekeeper` agent flags a backlog** (>10 unmerged contributions or any contribution older than 14 days).

## Three invocation modes

```
/housekeeping <canonical-path>         # one file at a time
/housekeeping --client <slug>          # all canonicals for that client
/housekeeping --all                    # full-repo sweep (Weekly Pulse scale)
```

## What the skill does

For a single canonical file:

1. **Acquire the lock** on the canonical — use `git lfs lock <canonical-path>` (same as `/lock-edit`). If lock is held by someone else and they're not doing housekeeping, abort with a clear message.
2. **Scan the contributions directory** for files with `status: proposed` in their frontmatter.
3. **For each proposed contribution, present to the user:**
   - Contribution metadata (who signed, when, type, brief from filename)
   - Full body text of the contribution
   - Current state of the target section in the canonical (if the contribution is scoped to a section)
   - Three options: **merge / archive / reject**
4. **Execute the user's choice:**
   - **merge:** integrate the contribution's content into the canonical at the right location; update contribution's frontmatter `status: merged` + `merged_date`; move the contribution file to `contributions/merged/YYYY-MM/`
   - **archive:** leave canonical untouched; update contribution's `status: archived` + `archive_reason`; move to `contributions/archived/YYYY-MM/`
   - **reject:** same as archive but with a `status: rejected` + `rejection_reason`; prompt for the reason (required)
5. **Commit the changes** (canonical + moved contribution files) as a single commit with a descriptive message.
6. **Release the lock** on the canonical.
7. **Report what happened** — N merged, N archived, N rejected, with paths.

For `--all` or `--client` modes: loop over every canonical that has a non-empty `contributions/` directory, doing the above for each. Per-canonical, still one commit (so the history stays readable).

## Output format (single file)

```
Housekeeping — clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md

  Scanning contributions/ ...
  Found 3 proposed contributions:

  [1/3] 2026-04-18_1430_ee_orsi-profile-observed.md
        Type: observation | By: Éva Erdei | Age: 2 days
        --- Content preview ---
        Orsi exhibits mixed FF + QS preferences in her emails; leads with
        evidence but shifts to metaphor when exhausted. Suggests presenting
        diagnosis with evidence-first, narrative-second ordering.
        --- End preview ---
        Action? [m]erge / [a]rchive / [r]eject / [s]kip: m
  ✓ Merged — integrated into § "Presenting to" section of canonical.
    Moved to contributions/merged/2026-04/.

  [2/3] 2026-04-18_1515_dd_meta-locations-pilot-logistics.md
        ... (continues)

  Summary:
  • Merged: 2
  • Archived: 1
  • Rejected: 0
  Commit created: "Housekeeping 2026-04-18 on DIAGNOSIS_2026-04-18.md"
  Lock released.
```

## Merge strategy — how contributions go into the canonical

The skill isn't fully automatic; the housekeeper (human) makes judgement calls on how to integrate. Heuristics the skill offers as suggestions:

- **Type `evidence`** → append to the canonical's "Evidence" section, with the contributor's source tag
- **Type `observation`** → if it belongs in a specific section, suggest that section; otherwise add to a general "Observations" or "Notes" section
- **Type `proposed-edit`** → show the user the diff between the current canonical and the proposed edit; accept/reject per section
- **Type `pattern`** → route to the adjacent pattern log rather than the canonical itself (pattern contributions belong in `internal/patterns/...`, not in client diagnoses)
- **Type `dispute`** → add a "Counter-perspective" block in the canonical with the contribution's text quoted and attributed; do not replace existing content
- **Type `note`** → housekeeper decides; usually either archive or merge into an "Other notes" section

The skill shows the suggestion; the human chooses. Automation here is assistance, not autonomy.

## Contribution frontmatter updates (merge/archive/reject)

After processing, the contribution file's frontmatter is updated (before moving to `merged/` or `archived/`):

```yaml
---
scope: int-company
contributes_to: clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
contribution_type: observation
signed_by: Éva Erdei
signed_date: 2026-04-16
status: merged                           # was: proposed
merged_date: 2026-04-18                  # added
merged_into_section: "Presenting to"     # added
merged_by: László Fazakas                # added — who ran housekeeping
---
```

For archive/reject, the analogous fields are `archived_date`, `archive_reason`, `rejected_date`, `rejection_reason`.

## Edge cases

- **Contribution has no frontmatter** — warn; skip; flag the filename to the user as malformed.
- **Canonical file doesn't exist yet** — if contributions exist but canonical doesn't, offer to create the canonical from scratch using the contributions as seed material.
- **Two contributions conflict (different proposed edits to the same section)** — present both to the user; human resolves.
- **Lock held by someone else for >4h** — surface this to the user; suggest `/lock-steal` only if blocking.
- **Contribution references a canonical that has been renamed** — warn; propose either moving the contribution to the new canonical's directory or archiving it with a "canonical renamed" reason.

## Skill implementation notes

Implementation is substantial (reads, parses, edits, commits). This skill coordinates with:
- `/lock-edit` under the hood (for the lock)
- `/lock-release` at the end
- The file-move operations via `git mv` (preserves history)

For `--all` mode, run sequentially per canonical (not parallel) to avoid git tree conflicts. Each canonical gets its own commit.

A companion `housekeeper` agent (`core/agents/housekeeper.md`) can do this semi-autonomously for specific simple cases (pattern contributions that clearly belong in the pattern log, `evidence` contributions that clearly belong in a well-formed canonical); see that agent's spec for what it handles vs. what it escalates.

## Never do

- **Never delete a contribution file.** Every contribution is preserved (merged or archived). Deletion erases attribution and history.
- **Never merge without the contributor's signed name attached.** If a contribution has no `signed_by`, archive it with a "unsigned contribution — attribution missing" reason.
- **Never housekeep across a release boundary without a commit.** Each canonical gets its own commit so `git log` tells the housekeeping story.
- **Never assume automatic merges are safe.** The skill suggests; the human decides. Full autonomy belongs to the agent for narrow well-defined cases only.
