---
scope: shared
argument-hint: optional path filter, e.g., clients/diego/
---

# `/lock-status` — Show current team locks across the repo

## Purpose

Answer the question *"who is working on what right now?"* by listing every active Git LFS lock, formatted with holder, time held, and staleness flag. This is the AOS equivalent of team presence — the closest thing we have to real-time visibility until the hub is live.

Rule: `core/methodology/GIT_LFS_LOCKS.md`.

## When to invoke

- At the start of your working session (`/day-start` already prompts this).
- Before beginning a new piece of work — check no one else has the file open.
- When considering a `/lock-steal` — confirm the lock is genuinely stale.
- When debugging "why can't I push?" — possibly a lock held by you from a prior session.
- Any time during the day you want the room's situational awareness.

## What the skill does

1. **Query the remote** — run `git lfs locks` to fetch the current lock list from origin.
2. **Filter if a path argument is given** — narrow to matches within the specified prefix (`clients/diego/`, `internal/`, etc.).
3. **Parse and categorise** — each lock becomes a row with holder, path, relative age, and staleness flag.
4. **Flag staleness by thresholds:**
   - **Fresh:** < 1 hour → no flag
   - **Active:** 1–4 hours → no flag (normal working session)
   - **Watch:** 4–24 hours → 🟡 *potentially stale — check with holder*
   - **Stale:** > 24 hours → 🔴 *very likely forgotten — candidate for `/lock-steal`*
5. **Highlight your own locks** — if the current git user holds any locks, list them first and flag them "→ you".
6. **Suggest next action** — if any stale locks exist, point at `/lock-steal`; if none, just confirm clean state.

## Output format

```
Current locks on arcanian-os — 2026-04-18 16:45

Your active locks (2):
  → you     clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md      (32m ago)
  → you     internal/commitments/2026-Q2_commitments.md          (1h 5m ago)

Team active locks (3):
            Éva Erdei      clients/wellis/LOOP_TRACKER.md        (48m ago)
            Dóra Diószegi  internal/scorecards/2026-W16.md       (2h 10m ago)
  🟡        László Fazakas  core/methodology/PUBLIC_CONTENT_GUARDRAIL.md  (5h ago — watch)

No stale locks (>24h). 5 active locks total.
```

If everything is clean:

```
No active locks across the repo. The team is either idle or working on
non-lockable files (skills, agents, data). Safe to start anywhere.
```

If there are stale locks:

```
⚠ 2 stale locks detected (>24h old). Candidates for /lock-steal if the
holder is unreachable:

  🔴   Éva Erdei      clients/wellis/LOOP_TRACKER.md     (31h ago)
  🔴   László Fazakas internal/ACCOUNTABILITY_MAP.md     (2 days ago)

Reach out to the holder first. If truly stuck:
  /lock-steal <path> "reason"
```

## Caching behaviour

`git lfs locks` hits the remote API. To avoid rate-limiting when called frequently:
- Cache responses for 30 seconds locally (write to `/tmp/aos-locks-cache.json` with a timestamp).
- On invocation, check cache age; if <30s, use cache; otherwise refetch.
- Force refresh with `/lock-status --fresh`.

## Skill implementation notes

```bash
# Pseudocode
REPO_ROOT="$(git rev-parse --show-toplevel)"
CACHE_FILE="/tmp/aos-locks-cache.json"
CACHE_AGE_SEC=30

# Refresh cache if stale or --fresh flag
if [ "${1:-}" = "--fresh" ] || [ ! -f "${CACHE_FILE}" ] || [ $(( $(date +%s) - $(stat -f %m "${CACHE_FILE}") )) -gt ${CACHE_AGE_SEC} ]; then
  git lfs locks --json > "${CACHE_FILE}"
fi

# Parse JSON, categorise by owner and age, render
# (Claude handles the formatting in the response)
```

## Edge cases

- **Remote unreachable** → show cached data with a timestamp; warn it may be stale.
- **Git LFS not installed** → direct user to `core/scripts/ops/setup-git-lfs-locks.sh`.
- **Current git user not configured** → warn; show all locks without "→ you" highlighting until user is set.
- **Lock held by a user whose name has changed** → display the username as stored; do not try to reconcile historical identities.

## Integration with other skills

- `/day-start` invokes this automatically and surfaces stale locks.
- `/lock-steal` runs this first to confirm the lock is actually stale.
- Pre-push hook runs this to remind about locks you hold on files you just pushed.
