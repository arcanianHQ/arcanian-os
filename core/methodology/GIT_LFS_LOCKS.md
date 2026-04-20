---
scope: shared
created: 2026-04-18
type: methodology rule — distributed coordination via Git LFS file locks
status: Active — interim coordination primitive until the hub (amazee.io-hosted) comes online.
purpose: Turn AOS from single-session tool into a distributed co-working system for the Arcanian team and Founding Cohort agencies. File-level lock mechanism using Git LFS, visible to everyone on the remote. Zero extra infrastructure.
related:
  - .gitattributes (lockable path declarations — repo root)
  - core/scripts/ops/setup-git-lfs-locks.sh (one-time machine setup)
  - core/skills/lock-edit.md, lock-status.md, lock-release.md, lock-steal.md
  - core/tools/hooks/git/pre-commit-lock-check.sh (local git hook)
  - core/tools/hooks/git/pre-push-lock-verify.sh (local git hook)
  - core/agents/lock-auditor.md (periodic stale-lock audit)
  - .claude/rules/git-lfs-locks.md (path-scoped Claude-session rule)
---

# Git LFS Locks — Distributed Coordination for AOS

## The problem this solves

AOS is run by multiple practitioners (Arcanian team: László + Éva + Dóra; Founding Cohort agencies: multiple people per agency). Without coordination, two practitioners editing the same file at the same time produces merge conflicts, lost work, and confusion about who owns what.

The full solution is a hosted hub (Mac mini → amazee.io → eventually a proper SaaS backend). Until that is live, **Git LFS file locks** give us 80% of the coordination value for 5% of the effort.

## How it works

Git LFS (Large File Storage) is a Git extension with a **file locking** feature. It works like this:

1. A practitioner runs `git lfs lock clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md`.
2. The lock is registered on the Git remote (GitHub / GitLab / Bitbucket), visible to everyone.
3. Anyone else who tries to edit or push changes to that file sees the lock and is blocked (or warned).
4. When the first practitioner finishes and pushes, they run `git lfs unlock <path>` (or auto-unlock via hook).
5. The file is free again.

Locks are:
- **Visible on the remote** — `git lfs locks` from any machine shows who holds what.
- **Persistent across sessions** — locks survive machine restarts, session changes, sleep.
- **File-level granular** — match the natural unit of AOS work (one markdown file = one diagnosis, one scorecard, one accountability map).
- **Convention-based but enforced** — Git LFS refuses pushes to locked files by non-holders.

## What is lockable

Declared in `.gitattributes` at the repo root. Lockable = high contention risk, not merely "shared."

**Lockable:**
- Per-client active state: diagnoses, loop tracker, event log, config, domain map, ad-account registry
- Agency-wide state: accountability map, scorecards, commitments, pattern logs, CAPTAINS_LOG
- Strategy docs: business model, manifesto, learning path, positioning, decision logs
- Core methodology: framework docs, KNOWN_PATTERNS, client directory
- Hub-level: CLAUDE.md, TASKS.md

**Deliberately NOT lockable:**
- `core/skills/**` — each skill is independent; concurrent edits rare
- `core/agents/**` — same
- `core/sops/**` — mostly reference reading
- Client data files (feeds, exports) — machine-generated
- Transcripts — one file per meeting, no concurrent editing
- Inbox directories — append-only drop zones

The lock overhead is not free. Only paths where accidental concurrent editing would cause real damage are lockable. Everything else stays merge-mergeable.

## Core practitioner workflow

### Before editing a lockable file

Either use the `/lock-edit <path>` skill (recommended) or run manually:

```bash
git lfs lock clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
```

If the lock is already held by someone else, the command fails with their name and timestamp. Either wait, message them in Slack, or use `/lock-steal` with an explicit reason.

### While you have the lock

Edit normally. Commit normally. Push normally. The lock travels with the file.

### After you've pushed your final edit

Either use `/lock-release <path>` or run manually:

```bash
git lfs unlock clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
```

The `pre-push-lock-verify.sh` Git hook also prompts you to unlock any locks you hold for files you just pushed — so you can forget the manual step and still get reminded.

### Checking who's working on what

Use `/lock-status` or:

```bash
git lfs locks
```

Shows all current locks across the repo, who holds them, and when. The skill flags any lock older than 4 hours as **potentially stale** and > 24 hours as **definitely stale** (either escalate to the holder or run `/lock-steal`).

### Force-releasing someone else's lock

Only when the holder is unreachable and the work is blocking. Use `/lock-steal <path>` with a reason:

```bash
# via skill — prompts for reason, logs to audit trail
/lock-steal clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md "László unreachable, Orsi review scheduled in 2 hours"

# or raw:
git lfs unlock --force clients/diego/diagnoses/DIAGNOSIS_2026-04-18.md
```

Steals are logged to `internal/lock-audit.md` with reason + who stole from whom. Over-stealing is a behaviour pattern the lock-auditor agent flags.

## The four-layer enforcement

The system works as layers, each catching what the one above missed:

| Layer | Mechanism | What it catches |
|---|---|---|
| **1. `.gitattributes`** | Declares which paths are lockable | Server-side enforcement via Git LFS |
| **2. Claude-session rule** (`.claude/rules/git-lfs-locks.md`) | Auto-loads when editing lockable paths; reminds practitioner to lock before editing | Practitioner forgetting to lock |
| **3. Git pre-commit hook** (`core/tools/hooks/git/pre-commit-lock-check.sh`) | Refuses commits to lockable files the practitioner does not hold the lock for | Bypassing the skill and hitting `git commit` directly |
| **4. Lock-auditor agent** | Periodic audit of stale locks, over-stealing patterns, forgotten unlocks | Drift over time |

No single layer is bulletproof. Together they keep the system honest.

## Setup (one time per machine)

Run:

```bash
core/scripts/ops/setup-git-lfs-locks.sh
```

This script:
1. Installs `git-lfs` (via Homebrew on macOS, apt on Debian, etc.) if not present
2. Runs `git lfs install` to register LFS with your Git client
3. Links the Git hooks (pre-commit, pre-push) into `.git/hooks/`
4. Verifies `.gitattributes` is present
5. Confirms lock access against the remote (test lock + immediate unlock on a scratch path)

Run this once per machine. Takes about 60 seconds.

## When the hub is live (next phase)

Once the **amazee.io-hosted AOS backend** is online, the coordination story evolves:

- Locks stay as the first-touch coordination primitive (cheap, fast, offline-friendly).
- The hub adds: real-time presence, live state sync, role-gated client access.
- Locks remain visible in the hub's UI; practitioners see them alongside live presence indicators.
- The lock system does not retire — it becomes one signal among several, layered under the hub's richer coordination.

In other words: this system is not a hack to be replaced. It is the foundation the hub builds on.

## Open limitations (acknowledged)

- **Not real-time presence.** A lock appears when the practitioner locks, not the moment they open a file in an editor.
- **Stale locks.** If someone forgets to unlock and then their machine dies, the lock hangs. The auditor agent flags these; the `/lock-steal` skill clears them when necessary.
- **Requires Git LFS installed locally.** One-time setup per machine via the bootstrap script.
- **GitHub rate limits** apply to `git lfs locks` queries. The `/lock-status` skill caches for 30 seconds to avoid hammering the API.
- **No client-side visibility.** Clients cannot see the lock state (they do not have repo access). That layer waits for the hub.

These are known, named trade-offs. The alternative — no coordination at all, or a full SaaS rebuild — is strictly worse for where Arcanian is now.
