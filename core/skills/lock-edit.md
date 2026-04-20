---
scope: shared
argument-hint: path to a lockable file
---

# `/lock-edit` — Lock a file via Git LFS before editing it

## Purpose

Claim exclusive edit rights on a lockable AOS file, open it for editing, and remind the user to unlock after their final push.

Wraps `git lfs lock` with:
1. Pre-flight check that the path is declared lockable in `.gitattributes`
2. Human-readable error when the lock is already held
3. Hand-off to Typora (via the app-defaults script) for editing
4. Clear reminder about unlock

Rule: `core/methodology/GIT_LFS_LOCKS.md`.

## When to invoke

Before editing any file declared lockable in `.gitattributes`, especially:
- Client diagnoses (`clients/*/diagnoses/*.md`)
- Loop trackers, event logs, access registries per client
- Agency-wide artifacts (`internal/ACCOUNTABILITY_MAP.md`, scorecards, commitments, patterns)
- Strategy docs (manifesto, learning path, business model, decision logs)
- Core methodology files
- Hub-level files (CAPTAINS_LOG.md, TASKS.md, CLAUDE.md)

If unsure whether a path is lockable, run `grep lockable .gitattributes` from the repo root or just invoke this skill — it will error clearly if the path is not lockable.

## What the skill does

1. **Resolve the path** — if relative, make absolute. Verify the file exists.
2. **Verify it's lockable** — match the path against patterns in `.gitattributes`. If not lockable, return a clean error: *"Path is not declared lockable. Edit freely without a lock."*
3. **Attempt to lock** — run `git lfs lock <path>`. Three outcomes:
   - **Success:** echo confirmation with user + timestamp.
   - **Already locked by someone else:** extract the holder's name + lock age from the error, surface a helpful message: *"{Path} is locked by {holder} since {time} ({age} ago). Options: (a) wait, (b) message {holder}, (c) `/lock-steal <path>` with reason."*
   - **Network or auth error:** surface the error clearly; suggest `git lfs env` to debug.
4. **Open the file for editing** — use `core/scripts/ops/open-file.sh` (respects the user's app defaults, usually Typora).
5. **Remind about unlock** — end the response with a one-line reminder: *"When you've pushed your final edit, run `/lock-release {path}`. Or let the pre-push hook prompt you."*

## Output format

```
✓ Locked: clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Holder: László Fazakas
  Since:  2026-04-18 14:32 (just now)
  Opened in Typora.

When you've pushed your final edit, run /lock-release on the same path.
(The pre-push hook will also prompt you.)
```

If already locked:

```
✗ Cannot lock — file is currently held by someone else.

  File:   clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Held by: Éva Erdei
  Since:   2026-04-18 12:05 (2h 30m ago)

Options:
  1. Wait — Éva may be finishing shortly.
  2. Message Éva in Slack #team to coordinate.
  3. If the lock looks stale (>4h and no response):
     /lock-steal clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md "reason"

Current lock state across the repo: /lock-status
```

## Edge cases to handle

- **Path not in `.gitattributes` as lockable** → inform user; offer to proceed without lock. Do not force a lock on a non-lockable path.
- **Git LFS not installed** → report the bootstrap command: `core/scripts/ops/setup-git-lfs-locks.sh`
- **No remote configured** → explain locks need a remote; ask user to check `git remote -v`.
- **File does not exist yet** — `git lfs lock` can still lock a path that will exist after commit. Proceed, but note the file needs to exist before edit.
- **Nested .gitattributes** — unusual, but if the pattern appears both in root `.gitattributes` and a subdirectory's, the subdirectory wins. Use `git check-attr lockable <path>` to verify.

## Skill implementation notes

Use Bash tool. The script:

```bash
# Resolve absolute path
ABS_PATH="$(realpath "${PATH_ARG}")"
REPO_ROOT="$(git rev-parse --show-toplevel)"
REL_PATH="${ABS_PATH#${REPO_ROOT}/}"

# Check if path is lockable (macOS-compatible check)
if ! git check-attr lockable "${REL_PATH}" | grep -q "lockable: set"; then
  echo "Path is not declared lockable in .gitattributes."
  echo "Edit freely without a lock. See core/methodology/GIT_LFS_LOCKS.md for the list of lockable paths."
  exit 0
fi

# Attempt lock
if git lfs lock "${REL_PATH}" 2>/tmp/lfs-lock-err; then
  echo "✓ Locked: ${REL_PATH}"
  core/scripts/ops/open-file.sh "${ABS_PATH}"
  echo "When you've pushed your final edit, run /lock-release ${REL_PATH}."
else
  # Parse the error to extract holder + timestamp
  ERR_MSG="$(cat /tmp/lfs-lock-err)"
  echo "${ERR_MSG}"
  echo ""
  echo "Run /lock-status to see all current locks."
fi
```
