---
scope: shared
argument-hint: path "reason for stealing"
---

# `/lock-steal` — Force-release a lock held by someone else

## Purpose

When a lock is stale and the holder is unreachable, and the work is genuinely blocking, forcibly release their lock with an audit trail. This is the escape hatch for forgotten locks — not a routine action.

Rule: `core/methodology/GIT_LFS_LOCKS.md`.

## When to invoke

Only when all of these are true:
1. The lock is **> 4 hours old**.
2. The holder is **unreachable** (you've pinged Slack, no response within a reasonable window).
3. The work is **genuinely blocking** — you cannot proceed without this file.

If any of the three is false, do not steal. Ping the holder, wait, or work on something else.

## What the skill does

1. **Verify the lock exists** — confirm via `git lfs locks` that someone else actually holds the file. If not, redirect the user to `/lock-edit`.
2. **Require a reason** — the skill refuses to proceed without a reason string. Reasons should name the blocker (*"Orsi review scheduled in 2 hours, László unreachable since morning"*) — not be vague (*"need it"*).
3. **Check staleness** — warn if the lock is < 4 hours old. This is not a veto — there may be edge cases (holder went offline unexpectedly) — but requires explicit override: `/lock-steal <path> "reason" --young`.
4. **Force-unlock** — run `git lfs unlock --force <path>` on the remote.
5. **Re-lock under the current user** — immediately after the steal, lock the file for yourself so you can begin work without a race condition.
6. **Log to audit trail** — append an entry to `internal/lock-audit.md` capturing: who stole, from whom, when, path, reason.
7. **Notify** — surface a clear confirmation to the user + a reminder to inform the previous holder when they come back online.

## Output format

```
⚠ LOCK STEAL — audit-logged.

  File:           clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Previous holder: László Fazakas (held 6h 12m before steal)
  Stolen by:       Éva Erdei
  Reason:          "Orsi review at 16:00, László offline since noon"

Actions taken:
  ✓ Forcibly released the previous lock
  ✓ Re-locked under your name
  ✓ Logged to internal/lock-audit.md (entry #14)

Your responsibilities:
  1. Message László on Slack to let him know you stole the lock — he may
     have unpushed commits that will now conflict with whatever you save.
  2. If László had unpushed work, help reconcile. Your steal does not
     erase his local commits — they're still on his machine.
  3. Do not make a habit of this. The auditor agent flags repeat stealers.
```

## Refusing to steal when inappropriate

```
✗ Cannot steal — lock is only 45 minutes old.

  File:           clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
  Held by:        László Fazakas (45m ago)

The lock is not stale. The holder is almost certainly still working.
Options:
  1. Wait — 45 minutes is a normal working window.
  2. Message László on Slack directly.
  3. If you believe the holder has gone offline unexpectedly, retry with:
     /lock-steal <path> "reason" --young

  This override bypasses the staleness check but still logs to the audit.
```

## The audit trail

`internal/lock-audit.md` format (append-only log):

```markdown
# Lock Audit Trail

## Entry #14 — 2026-04-18 15:42
- **Path:** clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
- **Stolen by:** Éva Erdei (erdei.eva@arcanian.ai)
- **From:** László Fazakas
- **Held for:** 6h 12m before steal
- **Reason:** Orsi review at 16:00, László offline since noon
- **Override flag:** none (lock was >4h, normal stale threshold)
- **Notification sent to László:** pending — Éva to message on Slack

---
```

The lock-auditor agent reads this log weekly and flags:
- Any practitioner who has stolen more than 3 times in a month (over-stealing)
- Any entry where "Notification sent" is still "pending" after 48 hours (follow-through failure)

## Implementation notes

```bash
# Pseudocode
REASON="${REASON_ARG}"
if [ -z "${REASON}" ]; then
  echo "Refusing: /lock-steal requires a reason as second argument."
  echo "Example: /lock-steal clients/diego/diagnoses/... \"Orsi review at 16:00\""
  exit 2
fi

# Verify lock exists and is held by someone else
LOCK_INFO="$(git lfs locks --path="${REL_PATH}" --json)"
if [ "$(echo "${LOCK_INFO}" | jq '. | length')" = "0" ]; then
  echo "No lock on this path. Use /lock-edit instead."
  exit 0
fi
HOLDER="$(echo "${LOCK_INFO}" | jq -r '.[0].owner.name')"
CURRENT_USER="$(git config user.name)"
if [ "${HOLDER}" = "${CURRENT_USER}" ]; then
  echo "You hold this lock. Use /lock-release, not /lock-steal."
  exit 0
fi

# Check staleness
LOCKED_AT="$(echo "${LOCK_INFO}" | jq -r '.[0].locked_at')"
AGE_SEC="$(( $(date +%s) - $(date -d "${LOCKED_AT}" +%s 2>/dev/null || gdate -d "${LOCKED_AT}" +%s) ))"
AGE_HR=$(( AGE_SEC / 3600 ))
if [ "${AGE_HR}" -lt 4 ] && [ "${YOUNG_OVERRIDE:-no}" != "yes" ]; then
  echo "Lock is only ${AGE_HR}h old. Use --young to override."
  exit 2
fi

# Force unlock + re-lock
git lfs unlock --force "${REL_PATH}"
git lfs lock "${REL_PATH}"

# Append to audit
AUDIT_FILE="${REPO_ROOT}/internal/lock-audit.md"
cat >> "${AUDIT_FILE}" << EOF

## Entry #$(next_entry_number) — $(date '+%Y-%m-%d %H:%M')
- **Path:** ${REL_PATH}
- **Stolen by:** ${CURRENT_USER}
- **From:** ${HOLDER}
- **Held for:** ${AGE_HR}h before steal
- **Reason:** ${REASON}
- **Override flag:** ${YOUNG_OVERRIDE:-none}
- **Notification sent to ${HOLDER}:** pending

---
EOF

echo "✓ Steal complete. Entry logged."
```
