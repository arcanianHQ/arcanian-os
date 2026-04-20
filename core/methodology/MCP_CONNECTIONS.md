---
scope: shared
---

# Arcanian Ops — MCP Server Inventory

> Which MCP servers are needed per project. Maintained here, applied per project in `.claude/settings.local.json`.

## Master Inventory

| MCP Server | Type | Auth | Projects Using |
|---|---|---|---|
| **Todoist** | Task sync | Bearer token | Arcanian, Diego, Mancsbazis, Deluxe, Measurement Audit |
| **Asana** | Task sync | PAT / OAuth | Wellis |
| **Databox** | Reporting | API key | Wellis, Diego (planned) |
| **Google Analytics 4** | Analytics | Service account | Wellis, Diego, Mancsbazis |
| **Google Ads** | Ads | OAuth | Wellis, Diego |
| **Meta Ads** | Ads | Access token | Wellis, Diego |
| **ActiveCampaign** | CRM | API key + URL | Wellis |
| **Shopify** | E-commerce | API key | Wellis |
| **Slack** | Communication | Bot token | All (Phase 2+) |
| **Fireflies.ai** | Transcription | API key | All client projects |
| **Firecrawl** | Web scraping | API key | Arcanian (diagnostics), Measurement Audit |
| **Chrome DevTools** | Browser | Local port | Measurement Audit |
| **Semrush** | SEO | API key | Wellis (via BP Digital) |
| **GitHub** | Version control | PAT | All (ops infrastructure) |

## Per-Project Map

| Project | Core | Marketing | Analytics | Communication |
|---|---|---|---|---|
| **Wellis** | Asana | GA4, GAds, Meta, AC, Shopify | Databox, Semrush | Slack, Fireflies |
| **Diego** | Todoist | GA4, GAds, Meta | Databox (planned) | Slack, Fireflies |
| **Mancsbazis** | Todoist | GA4 | — | Slack |
| **Deluxe** | Todoist | GAds, Meta | — | Slack |
| **Arcanian** | Todoist | — | — | Slack, Firecrawl |
| **Measurement Audit** | Todoist | Chrome DevTools | — | Slack, Firecrawl |

## Token Storage

ALL tokens in `~/.env.arcanian` on Mac mini. NEVER in Git.

```bash
# ~/.env.arcanian
TODOIST_API_TOKEN=
ASANA_ACCESS_TOKEN=
DATABOX_API_KEY=
GOOGLE_APPLICATION_CREDENTIALS=/path/to/sa.json
GOOGLE_ADS_DEVELOPER_TOKEN=
META_ACCESS_TOKEN=
AC_API_URL=https://buenospa.activehosted.com
AC_API_KEY=
SHOPIFY_ACCESS_TOKEN=
SLACK_BOT_TOKEN=
FIREFLIES_API_KEY=
FIRECRAWL_API_KEY=
SEMRUSH_API_KEY=
GITHUB_PAT=
```

## Adding a New MCP Server

1. Get API credentials (token/OAuth)
2. Add to `~/.env.arcanian`
3. Configure in Claude Code:
   ```bash
   # HTTP transport (Databox, ActiveCampaign, Asana):
   claude mcp add --transport http -s local {name} {url}
   # Example: claude mcp add --transport http -s local databox https://mcp.databox.com/mcp

   # Stdio transport (Firecrawl, local tools):
   claude mcp add -e API_KEY=xxx -s local {name} -- npx {package}
   # Example: claude mcp add -e FIRECRAWL_API_KEY=xxx -s local firecrawl -- npx -y firecrawl-mcp
   ```
4. Add permissions to project's `.claude/settings.local.json`
5. Test with a simple query
6. Update this file + project's ACCESS_REGISTRY.md
7. Document in CAPTAINS_LOG.md
