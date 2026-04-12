---
id: health-mcp-checker
name: "MCP Connection Checker"
focus: "MCP server connectivity — auth, timeout, Databox mandatory check"
context: [infrastructure]
data: [mcp]
active: true
confidence_scoring: false
recommendation_log: false
scope: shared
category: infrastructure
weight: 0.20
---

# Agent: MCP Connection Checker

## Purpose

Verifies all configured MCP servers are connected and responding. Flags auth errors, timeouts, and missing connections. Enforces Databox mandatory rule.

## Process

1. Read `.mcp.json` or `.claude/settings.json` for configured servers
2. For each configured server, attempt a minimal query:
   - **Todoist:** `get-overview` or `user-info`
   - **Databox:** `list_accounts`
   - **ActiveCampaign:** `list_lists` (limit 1)
   - **Asana:** `asana_list_workspaces`
   - **Fireflies:** `fireflies_get_user`
   - **Chrome DevTools:** `list_pages`
   - **Canva:** `list-brand-kits`
   - Other: note as "configured, no ping available"
3. Record status: connected, auth error (401/403), timeout, not configured
4. **CRITICAL check:** Is Databox connected? Per `DATABOX_MANDATORY_RULE.md`, no Databox = no data analysis capability.

## Scoring

Reference: `core/methodology/HEALTH_CHECK_SCORING.md` → Section 2

Score = (connected / configured) × 100, with Databox bonus/penalty.

## Output

```markdown
### MCP Connections [Score: {0-100}/100]

| Server | Status | Note |
|---|---|---|
| {name} | {Connected/Auth error/Timeout/Not configured} | {detail} |

**Databox:** {Connected / NOT CONNECTED — CRITICAL}

Evidence: [OBSERVED: MCP ping, {date}]
```
