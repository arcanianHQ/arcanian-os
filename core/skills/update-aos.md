---
scope: shared
context: fork
argument-hint: check for updates
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# Skill: Update AOS (`/update-aos`)

> v1.0 — 2026-04-16

## Purpose

Check for and apply updates to a local Arcanian OS installation. This is the **pull** counterpart to `/share-to-os` (which pushes from the dev source). Runs on the receiver's clone — not on `_arcanian-ops` itself.

## Trigger

Use when: user says `/update-aos`, "check for updates", "update the system", "is my AOS current".

## Execution Steps

### Step 1: Version Check

1. Read local `core/VERSION.json` → extract `version` field
2. Fetch upstream version: `git fetch origin` then `git show origin/main:core/VERSION.json`
3. Compare semver:
   - Same version → "Already up to date (v{version}). Nothing to do." → STOP
   - Local ahead of upstream → "Local version (v{local}) is ahead of upstream (v{upstream}). This is unusual — verify you're on the right branch." → STOP
   - Local behind → "Update available: v{local} → v{upstream}." → proceed to Step 2
4. If `core/VERSION.json` does not exist locally → "VERSION.json missing — your installation predates version tracking. Proceeding with git diff instead."

### Step 2: Diff Preview

1. Run `git diff HEAD..origin/main --name-only`
2. Group changed files by category and present:

```
UPDATE PREVIEW: v{local} → v{upstream}

── BEHAVIOR-AFFECTING (review these) ──
  core/methodology/  {N} files changed
    {list each file}
  core/tools/hooks/  {N} files changed
    {list each file}

── SKILLS ─────────────────────────────
  core/skills/       {N} new, {N} updated
    + {new skill files}
    ~ {modified skill files}

── TEMPLATES & SOPs ───────────────────
  core/templates/    {N} files
  core/sops/         {N} files

── OTHER ──────────────────────────────
  {remaining files}

Total: {N} files changed
```

3. Methodology and hook changes are flagged prominently — they affect system behavior across all skills and sessions.
4. Ask: "Proceed with update? (y/n)"
5. If user says no → STOP

### Step 3: Backup (conditional)

1. Check for local modifications that conflict with upstream: `git diff HEAD..origin/main --name-only` intersected with `git diff --name-only` (uncommitted local changes)
2. If conflicts exist:
   - Report: "{N} locally modified files also changed upstream: {list}"
   - Ask: "Create backup branch before updating? (y/n/skip)"
   - If yes: `git checkout -b backup/pre-update-{YYYY-MM-DD}` then `git checkout main`
   - If skip: proceed without backup (user accepts risk)
3. If no conflicts → proceed directly

### Step 4: Pull

1. `git pull origin main`
2. If merge conflicts arise:
   - List each conflicted file
   - Do NOT auto-resolve — surface the conflicts and let the user handle them
   - Suggest: "Resolve conflicts, then run `/update-aos` again to verify."
   - STOP

### Step 5: Verify

1. Re-read `core/VERSION.json` — confirm version matches expected upstream version
2. Count files in `core/skills/` before and after (from git diff) — report new skill count
3. If hooks were changed: remind user to re-run `bash core/tools/hooks/deploy-hooks.sh` if using hooks

### Step 6: Report

```
UPDATE COMPLETE
═══════════════
Local: v{old} → v{new}
Files updated: {N}
New skills: {list or "none"} ({count} new)
Updated skills: {list} ({count} updated)
Rule changes: {list of methodology files} — review these, behavior affected
Hook changes: {list or "none"}
  → Re-run: bash core/tools/hooks/deploy-hooks.sh
Backup branch: {branch name or "not created"}
═══════════════
```

## Notes

- This skill is safe — it is read-only until the user confirms at Step 2
- Methodology changes are highlighted more visibly than skill changes because they modify system behavior for every analysis
- This skill should NOT be run inside `_arcanian-ops` (the dev source) — it is designed for cloned distribution repos
- If `git fetch` fails (no remote, auth error), report the error and suggest checking `git remote -v`
