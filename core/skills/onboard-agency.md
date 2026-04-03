# Skill: Agency Onboarding (`/onboard-agency`)

## Purpose

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-04-03`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Onboard a new agency (or solo practitioner) onto Arcanian OS. Sets up their hub, first client, MCP connections, and runs a validation check — goal: "run your first /health-check in 30 minutes."

## Trigger

Use when: user says `/onboard-agency`, "set up AOS for a new agency", "onboard new agency", or a GitHub applicant is approved.

## Input

| Input | Required | Default |
|---|---|---|
| `agency_name` | Yes | — (slug, e.g., `acme-digital`) |
| `display_name` | Yes | Titlecase of `agency_name` |
| `first_client` | No | `example-client` |
| `databox_connected` | No | `false` |
| `sync_system` | No | `[task-manager]` |

## Prerequisites

- Claude Code installed and working
- GitHub access to `arcanian-os` repo (granted from access tracker)
- Databox account (recommended, not required for basic setup)

## Execution Steps

### Step 1: Clone and Verify Structure
```bash
git clone https://github.com/{repo}/arcanian-os.git {agency_name}-ops
cd {agency_name}-ops
```
Verify scaffold exists: `core/skills/`, `core/agents/`, `core/sops/`, `core/templates/`, `CLAUDE.md`.

### Step 2: Configure .mcp.json
Copy `.mcp.json.example` to `.mcp.json`. Guide the user through:

| MCP Server | Required? | Setup |
|---|---|---|
| Databox | Recommended | API key from Databox settings |
| [Task Manager] | Optional | OAuth via `/mcp` |
| Asana | Optional | OAuth via `/mcp` |
| ActiveCampaign | If used | API URL + key per instance |

**Remind:** MCP is frozen at session start. After editing `.mcp.json`, restart Claude Code.

### Step 3: Scaffold First Client
Run `/scaffold-project` with:
- `name`: `{first_client}`
- `type`: `client`
- `location`: `clients/{first_client}`

This creates: TASKS.md, CAPTAINS_LOG.md, CLIENT_CONFIG.md, CONTACTS.md, brand/, inbox/, data/, etc.

### Step 4: Configure CLIENT_CONFIG.md
Guide user to fill in:
- Company name, domains, team
- Tracking IDs (GA4, GTM, Google Ads, Meta)
- `reporting_currency`
- `alarm_sensitivity`
- Attribution window overrides (if known)

### Step 5: Create DOMAIN_CHANNEL_MAP.md (if multi-domain)
If client has >1 domain: create from template. Fill in:
- Domain → data source mapping
- Currency per source
- ActiveCampaign instance mapping

### Step 6: Connect Databox (if available)
If `databox_connected: true`:
1. Verify MCP connection: ask Databox for account list
2. Identify data sources for the client's domains
3. Note source IDs in DOMAIN_CHANNEL_MAP.md

### Step 7: Run First /health-check
Execute `/health-check` for the new client. Expected outcome:
- MCP connections verified
- Data sources identified
- Baselines: "no baseline yet" (expected — will populate after first week)
- Any tracking issues flagged

### Step 8: Validation Checklist

Output to user:

```markdown
## Onboarding Validation — {display_name}

- [ ] Repo cloned and CLAUDE.md loads correctly
- [ ] .mcp.json configured (Databox: {yes/no}, [Task Manager]: {yes/no})
- [ ] First client scaffolded at clients/{first_client}/
- [ ] CLIENT_CONFIG.md filled with domains and tracking IDs
- [ ] DOMAIN_CHANNEL_MAP.md created (if multi-domain)
- [ ] /health-check ran without errors
- [ ] User understands: /tasks, /health-check, /morning-brief, /analyze-gtm

## Next Steps
1. Run `/morning-brief` tomorrow morning — your first daily briefing
2. After 7 days of data: baselines will auto-populate
3. Add more clients with `/scaffold-project` or `/onboard-client`
4. Read `docs/GETTING_STARTED.md` for full skill index
```

## Common Issues

| Issue | Fix |
|---|---|
| MCP not connecting | Restart Claude Code after .mcp.json edit |
| Databox shows no data | Check data source IDs in DOMAIN_CHANNEL_MAP |
| /health-check errors on missing file | Run `/scaffold-project` again — some files may not have been created |
| Skills not loading | Verify `core/skills/` symlink or directory exists |

## References
- `core/skills/scaffold-project.md`
- `core/skills/onboard-client.md`
- `core/templates/DOMAIN_CHANNEL_MAP_TEMPLATE.md`
- `core/templates/CLIENT_CONFIG_TEMPLATE.md`
- `core/methodology/MCP_CONNECTIONS.md`
- `docs/GETTING_STARTED.md`
