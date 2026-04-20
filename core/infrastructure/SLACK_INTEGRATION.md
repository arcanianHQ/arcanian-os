---
scope: shared
---

# Arcanian Ops — Slack Integration

## Channel Structure

```
#arcanian-internal    — company strategy, methodology, admin
#wellis-ops           — Wellis client work (Éva primary)
#diego-ops            — Diego measurement audit (László)
#mancsbazis-ops       — Mancsbazis (Dóra primary)
#deluxe-ops           — Deluxe Building (László)
#ops-alerts           — automated alerts, sync failures, P0 notifications
#ops-daily            — morning brief, daily standup
```

## Primary: Claude Code --channels

Claude Code has native `--channels` support. MCP servers push messages directly into Claude Code sessions and forward approval prompts to devices.

### Setup

```bash
# Start hub with channels enabled
claude remote-control --name "Arcanian Hub" --spawn worktree --capacity 32 --channels

# Each session can receive messages from its assigned Slack channel
# Approval prompts forward to connected phones/tablets
```

### How it works:
- Team posts in `#wellis-ops` → message routes to the Wellis Claude Code session
- Claude processes the request, posts response back to channel
- Approval prompts (for sensitive operations) forward to László's phone
- No third-party bots needed — native Claude Code feature

### Interactive Slack via claude.ai

Claude Code on the web (claude.ai) has native Slack connectors (MCP Apps):
- Team can draft and post Slack messages from within claude.ai
- No tab switching needed
- Works for Éva/Dóra without Terminal knowledge

## Secondary: Slack MCP Server

For more control, configure a Slack MCP server:

```bash
# 1. Create Slack App → api.slack.com/apps → New App
# Bot Token Scopes:
#   channels:history, channels:read, chat:write, files:write, reactions:write

# 2. Add token to .env
SLACK_BOT_TOKEN=xoxb-your-token-here

# 3. Add MCP server
claude mcp add slack
```

## Notification Rules

| Event | Channel | Urgency |
|---|---|---|
| P0 task created | #ops-alerts + project channel | Immediate |
| @waiting task older than 7 days | #ops-alerts | Daily morning brief |
| Sync failure | #ops-alerts | Immediate |
| Task completed | Project channel | Normal |
| Weekly report generated | Project channel | Normal |
| MCP connection down | #ops-alerts | Immediate |
| Pre-commit hook blocked a commit | #ops-alerts | Immediate |
| GitHub secret scanning alert | #ops-alerts | Immediate |

## Security

- Bot token: `.env` on Mac mini only, never in Git
- Private channels: only team members + bot
- No client PII in Slack messages — use references ("see TASKS.md #49")
- Slack Free: 90-day message retention. Key outputs → save to Git, Slack is ephemeral.
- GitHub push protection catches tokens that accidentally reach Slack→Git pipeline
