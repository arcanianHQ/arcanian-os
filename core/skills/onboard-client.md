# Skill: Client Onboarding (`/onboard-client`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-03-24`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Full new client onboarding — wraps `/scaffold-project` and adds repo creation, hook setup, registry entries, and post-onboard validation.

## Trigger

Use when: user says `/onboard-client`, "onboard new client", "set up a new client", or "new client {name}".

## Input

| Input | Required | Default |
|---|---|---|
| `name` | Yes | — (slug, e.g., `heavytools`) |
| `display_name` | Yes | Titlecase of `name` |
| `type` | No | `client` |
| `sync_system` | No | `[task-manager]` |
| `owner` | No | `[Owner]` |
| `team` | No | `["[Owner]"]` |

## Execution Steps

### Step 1: Run /scaffold-project
Execute `/scaffold-project` with all inputs. Location: `_arcanian-ops/clients/{name}`.
Creates directories, files, symlinks, brand stubs, and .gitignore.

### Step 2: Create GitHub repo + git init
```bash
gh repo create arcanian-ops/client-{name} --private --description "{display_name} — Arcanian client project"
cd _arcanian-ops/clients/{name} && git init
git remote add origin git@github.com:arcanian-ops/client-{name}.git
git add -A && git commit -m "chore: scaffold {display_name} project"
git push -u origin main
```
If `gh` or push fails: WARN and continue — document for manual creation.

### Step 3: Configure hooks
Copy `.claude/settings.json` from `core/templates/settings.json` if available. Verify preflight hook is configured.

### Step 4: Document Slack channel
Output: `ACTION REQUIRED: Create Slack channel #arcanian-{name}-ops — Invite: [Owner] + team`

### Step 5: Add to registries
- **PROJECT_REGISTRY.md**: append `| {name} | {display_name} | client | clients/{name} | {sync_system} | {today} | active |`
- **BRAND_INDEX.md**: append `| {display_name} | clients/{name}/brand/ | 0/7 | Pending initial diagnostic |`

### Step 6: Create initial CAPTAINS_LOG entry
```
## {today}
- Project onboarded via /onboard-client
- Sync: {sync_system} | Owner: {owner} | Team: {team}
- Next: complete brand/ intelligence profile, create initial tasks
```

### Step 7: Run /validate
Execute `/validate` on `clients/{name}`. All checks should pass on a fresh scaffold.

## Output Format

```
/onboard-client — {display_name}
═══════════════════════════════════
Scaffold: ✓ | Repo: ✓ | Git: ✓ | Hooks: ✓ | Registry: ✓ | Log: ✓ | Validate: ✓

ACTION: Create Slack channel #arcanian-{name}-ops

Next steps:
1. Fill brand/ profile (run /7layer)
2. Create initial tasks
3. Set up MCP connections (GA4, Ads, etc.)
═══════════════════════════════════
```

## Notes

- This skill **wraps** `/scaffold-project` — never run both separately for the same client.
- If any step fails, continue with remaining steps and report all failures at the end.
- Reference: `core/skills/scaffold-project.md`, `core/skills/validate.md`
