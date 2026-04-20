---
scope: shared
argument-hint: path to release, or --all-mine for all of your locks
---

# `/lock-release` — Release a Git LFS lock after your final push

## Purpose

Hand the file back to the rest of the team by unlocking it after you've pushed your final edit. This is the other half of `/lock-edit` — without unlock, your lock hangs and blocks others indefinitely.

Wraps `git lfs unlock` with pre-flight checks that (a) the file was actually yours, and (b) you've committed and pushed your latest changes.

Rule: `core/methodology/GIT_LFS_LOCKS.md`.

## When to invoke

- Immediately after you've pushed the final edit to a file you locked.
- At end of day, clear any locks you still hold (`/lock-release --all-mine`).
- When the pre-push hook prompts you (easiest path — just run it).

## What the skill does

1. **Resolve path or batch** — single path, or `--all-mine` flag to release everything you hold.
2. **Verify ownership** — check the lock is held by the current git user. Refuse to unlock other people's locks (that's what `/lock-steal` is for).
3. **Check push state** — confirm the file's latest commit has been pushed to origin. If there are unpushed commits that touch this file, warn the practitioner — they may be about to release a lock before the final save reaches the remote.
4. **Unlock** — run `git lfs unlock <path>` (or loop over all-mine).
5. **Confirm** — one-line success per path, with a summary if batch.

## Output format

Single path:

```
✓ Released: clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Held: 2h 15m
  Last push: 3 minutes ago (all changes on remote ✓)
  File is now available for the team.
```

Batch (`--all-mine`):

```
Releasing 3 locks held by László Fazakas...

  ✓ clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md     (2h 15m held)
  ✓ internal/commitments/2026-Q2_commitments.md         (4h 30m held)
  ⚠ core/methodology/PUBLIC_CONTENT_GUARDRAIL.md — has 2 unpushed commits.
     NOT released. Push first, then re-run /lock-release on this path.

Summary: 2 locks released, 1 held (unpushed commits detected).
```

## Safety check — unpushed commits

If `git log origin/main..HEAD -- <path>` returns any commits, it means the practitioner has committed changes to this file but hasn't pushed them yet. Releasing the lock in this state means another practitioner could start editing before your commit reaches the remote, producing a conflict.

The skill refuses to release in this case and surfaces:

```
⚠ Cannot release — you have unpushed commits on this file.

  File: core/methodology/PUBLIC_CONTENT_GUARDRAIL.md
  Unpushed commits: 2
    • abc1234 "refine blocklist prose" (8 min ago)
    • def5678 "add node-based enforcement note" (just now)

Push first:
  git push

Then re-run /lock-release core/methodology/PUBLIC_CONTENT_GUARDRAIL.md.

Or override (not recommended — risks conflict):
  /lock-release <path> --force
```

## Refusing to release someone else's lock

```
✗ Cannot release — you do not hold this lock.

  File: clients/wellis/LOOP_TRACKER.md
  Held by: Éva Erdei (2h 30m ago)

If Éva is unreachable and the work is blocking:
  /lock-steal clients/wellis/LOOP_TRACKER.md "reason"

Otherwise message Éva in Slack.
```

## Skill implementation notes

```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
CURRENT_USER="$(git config user.name)"

# If --all-mine, enumerate locks held by current user
if [ "${PATH_ARG}" = "--all-mine" ]; then
  MY_LOCKS="$(git lfs locks --json | jq -r ".[] | select(.owner.name == \"${CURRENT_USER}\") | .path")"
  for lock in ${MY_LOCKS}; do
    release_one "${lock}"
  done
  exit 0
fi

# Single-path release
REL_PATH="${PATH_ARG#${REPO_ROOT}/}"
release_one "${REL_PATH}"

release_one() {
  local path="$1"

  # Check ownership
  OWNER="$(git lfs locks --path="${path}" --json | jq -r '.[0].owner.name // ""')"
  if [ "${OWNER}" != "${CURRENT_USER}" ]; then
    echo "✗ Cannot release ${path} — held by ${OWNER}"
    return 1
  fi

  # Check for unpushed commits on this path
  UNPUSHED="$(git log origin/HEAD..HEAD --oneline -- "${path}" | wc -l | tr -d ' ')"
  if [ "${UNPUSHED}" -gt 0 ] && [ "${FORCE:-no}" != "yes" ]; then
    echo "⚠ ${UNPUSHED} unpushed commit(s) on ${path}. Push first or use --force."
    return 1
  fi

  # Release
  if git lfs unlock "${path}"; then
    echo "✓ Released: ${path}"
  else
    echo "✗ Failed to release ${path}"
  fi
}
```

## Edge cases

- **Lock does not exist** — file has no lock, user got their paths wrong. Return friendly error, suggest `/lock-status`.
- **Network error** — can't reach remote. Report clearly; locks can only be released online.
- **User changed git config name mid-session** — the lock was held under the old name. Unlock still works (LFS goes by credentials, not display name), but warn if names differ.
