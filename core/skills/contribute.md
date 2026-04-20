---
scope: shared
argument-hint: canonical-path [--type TYPE] [--brief "two-three-words"]
---

# `/contribute` — Append a contribution to a canonical file without overwriting it

## Purpose

Create a new timestamped, signed contribution file adjacent to a canonical AOS file — in its `contributions/` subdirectory — instead of editing the canonical directly. Preserves every practitioner's voice, avoids lock contention, and feeds the daily housekeeping ritual.

This is the companion pattern to `/lock-edit`. Locks serialise access to canonical files. Contributions parallelise perspectives. See `core/methodology/CONTRIBUTION_FILES_AND_HOUSEKEEPING.md`.

## When to invoke

Use `/contribute` (not `/lock-edit`) when:
- You want to add a perspective, evidence, observation, or proposed change
- The canonical file may have other parallel contributions from teammates
- You don't need to see the merged result right now — a housekeeper will merge later
- The file is flagged as a **contribution target** (many diagnoses, pattern logs, accountability proposals)

Use `/lock-edit` (not `/contribute`) when:
- You're the one running the housekeeping merge right now
- The edit is small and definitive (fixing a typo, updating a single number)
- You're updating machine-maintained state (scorecards, trackers) with a clear right answer

If unsure, default to `/contribute` — it's lower-risk and preserves more voice.

## What the skill does

1. **Resolve the canonical path** — verify it exists; warn if not.
2. **Determine the contributions directory** — for canonical `X.md`, contributions live at `X_contributions/` (directory sibling with `_contributions` suffix) OR an explicit path per the convention table in `CONTRIBUTION_FILES_AND_HOUSEKEEPING.md`. Create the directory if it doesn't exist.
3. **Look up the practitioner's initials** — read `core/methodology/USERS_ROSTER.md`, find the entry matching the current `git config user.name`, extract the initials. If not found, ask the user for initials and flag that the roster needs updating.
4. **Compose the filename** — `YYYY-MM-DD_HHMM_{initials}_{brief}.md` where `{brief}` is kebab-case from the `--brief` argument or prompted from the user if omitted.
5. **Create the file with frontmatter:**
   ```yaml
   ---
   scope: int-company
   contributes_to: {canonical-path}
   contribution_type: {type, default: note}
   signed_by: {full name from roster}
   signed_date: {today YYYY-MM-DD}
   status: proposed
   ---
   ```
6. **Open the file for editing** via `core/scripts/ops/open-file.sh`.
7. **Confirm** — one-line summary with path and next-step reminder.

## Output format

```
✓ Contribution file created.

  Target (canonical): clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Your contribution:  clients/diego/diagnoses/contributions/2026-04-18_1642_lf_partner-psych-evidence.md
  Contribution type:  evidence
  Signed by:          László Fazakas

Opened in Typora. When you're done:
  • Commit and push normally. No lock needed — new files don't collide.
  • The canonical file will be updated during the next housekeeping pass
    (/housekeeping clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md or at
    the Monday Weekly Pulse).
```

## Edge cases to handle

- **Canonical file does not exist** — warn the user; offer to create the canonical AND the first contribution in one shot (rare but useful for new diagnoses).
- **Contributions directory does not exist** — create it with a `.gitkeep` if empty.
- **Practitioner not in USERS_ROSTER** — fall back to asking for initials; flag that the roster needs updating (add task).
- **`--type` argument is an unknown contribution type** — list the valid types (evidence / observation / proposed-edit / pattern / dispute / note) and ask the user to pick.
- **Same minute, same initials, same brief already exists** — append a `-2`, `-3` suffix to the filename to disambiguate.

## Skill implementation notes

```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
CANONICAL="$(realpath "${CANONICAL_ARG}")"
CURRENT_USER="$(git config user.name)"
CONTRIB_TYPE="${TYPE:-note}"
TIMESTAMP="$(date '+%Y-%m-%d_%H%M')"

# Resolve initials from roster
INITIALS=$(grep -A1 "Full name | ${CURRENT_USER}" "${REPO_ROOT}/core/methodology/USERS_ROSTER.md" \
  | grep "Initials" | sed 's/.*\`\([a-z]*\)\`.*/\1/' | head -1)

# Derive contributions dir
CANONICAL_DIR="$(dirname "${CANONICAL}")"
CANONICAL_NAME="$(basename "${CANONICAL}" .md)"
CONTRIB_DIR="${CANONICAL_DIR}/${CANONICAL_NAME}_contributions"
# OR use per-canonical convention table — exceptions handled by lookup
mkdir -p "${CONTRIB_DIR}"

# Compose filename
BRIEF_SLUG="$(echo "${BRIEF:-note}" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
FILENAME="${TIMESTAMP}_${INITIALS}_${BRIEF_SLUG}.md"
FILEPATH="${CONTRIB_DIR}/${FILENAME}"

# Write frontmatter + empty body, open
cat > "${FILEPATH}" << EOF
---
scope: int-company
contributes_to: ${CANONICAL#${REPO_ROOT}/}
contribution_type: ${CONTRIB_TYPE}
signed_by: ${CURRENT_USER}
signed_date: $(date '+%Y-%m-%d')
status: proposed
---

# {Your title for this contribution}

{Your prose, evidence, observation, or proposed edit goes here.}
EOF

"${REPO_ROOT}/core/scripts/ops/open-file.sh" "${FILEPATH}"

echo "✓ Contribution file created: ${FILEPATH#${REPO_ROOT}/}"
```

## Contribution types (reminder)

- **evidence** — new data/observation supporting or contradicting the canonical claim
- **observation** — something the canonical didn't capture
- **proposed-edit** — specific edit request, often with a proposed diff or rewrite
- **pattern** — a named pattern observed during work on this artefact
- **dispute** — explicit disagreement; must name what and why
- **note** — anything else; the low-cost entry point

Full semantics in `core/methodology/CONTRIBUTION_FILES_AND_HOUSEKEEPING.md`.
