> v1.0 — 2026-04-03

# Databox MCP Setup Guide

> Connect Databox to Arcanian OS so Claude can pull marketing metrics, detect anomalies, and run analysis on demand.

---

## Why Databox

Arcanian OS uses Databox as its data layer. Databox aggregates metrics from Google Ads, Meta, GA4, Shopify, ActiveCampaign, Search Console, and 70+ other platforms into a single API. Claude reads this data through the Databox MCP server.

Without Databox, the system still works for diagnostics, task management, and strategy — but it can't pull live data or detect anomalies.

---

## Step 1: Get a Databox Account

- Sign up at [databox.com](https://databox.com)
- Free tier works for testing (limited data sources and history)
- Growth or Professional plan recommended for production use

---

## Step 2: Connect Your Data Sources in Databox

In Databox, connect the platforms you use:

| Platform | What AOS uses it for | Priority |
|---|---|---|
| **Google Analytics 4** | Sessions, conversions, revenue, engagement | HIGH — primary analytics |
| **Google Ads** | Cost, ROAS, conversions, CPA, impression share | HIGH — if running Google Ads |
| **Meta/Facebook Ads** | Spend, ROAS, creative performance, frequency | HIGH — if running Meta Ads |
| **Shopify** | Orders, revenue, AOV, product performance | HIGH — if e-commerce |
| **ActiveCampaign** | Contacts, email open/click rates, automations | MEDIUM |
| **Search Console** | Organic clicks, impressions, average position | MEDIUM |
| **Google Sheets** | Custom data, manual imports | OPTIONAL — for custom metrics |

Each connected platform becomes a "data source" with a unique ID.

---

## Step 3: Get Your Databox API Token

1. Log in to Databox
2. Go to **Account Settings** (gear icon, bottom left)
3. Click **Company Settings**
4. Find **API** section
5. Copy your API token (or create one if none exists)

Keep this token — you'll need it for the MCP configuration.

---

## Step 4: Configure `.mcp.json`

In your arcanian-os root directory, edit `.mcp.json`:

```json
{
  "mcpServers": {
    "databox": {
      "command": "npx",
      "args": ["-y", "@anthropic/databox-mcp"],
      "env": {
        "DATABOX_API_TOKEN": "your-token-here"
      }
    }
  }
}
```

Replace `your-token-here` with the API token from Step 3.

**Important:** After editing `.mcp.json`, restart Claude Code. MCP connections are frozen at session start.

---

## Step 5: Verify the Connection

Start Claude Code and run:

```
List my Databox accounts and data sources
```

You should see your accounts and their connected data sources with IDs. Example:

```
Accounts:
- My Agency (ID: 123456)

Data Sources:
- Client A - GA4 (ID: 1234567, type: Google Analytics 4)
- Client A - Google Ads (ID: 1234568, type: Google Ads)
- Client A - Meta Ads (ID: 1234569, type: Facebook Ads)
```

If you see your data sources, the connection works.

---

## Step 6: Map Data Sources to Domains

For each client, record the Databox source IDs in `DOMAIN_CHANNEL_MAP.md`:

```markdown
## Databox Data Sources

| Databox Source ID | Platform | Domain(s) | Shared? | Currency | Typical Lag | Filter by |
|---|---|---|---|---|---|---|
| 1234567 | GA4 | client.com | No | USD | ~4h | — |
| 1234568 | Google Ads | client.com + client.eu | YES | USD | ~4h | dimension: "campaign" |
| 1234569 | Meta Ads | client.com | No | USD | ~6h | — |
```

**Critical columns:**
- **Shared?** — If one data source covers multiple domains, you MUST filter by campaign name patterns. Otherwise, analysis mixes domain data.
- **Currency** — Native currency of the data source. Used by `CURRENCY_NORMALIZATION.md` for cross-domain totals.
- **Typical Lag** — How long it takes for this source to sync. The system checks lag before flagging anomalies, so it doesn't create false alerts from stale data.

---

## Step 7: Test a Data Query

Ask Claude:

```
Pull GA4 sessions for the last 30 days from data source 1234567, weekly granulation
```

You should get weekly data points. If this works, the full analysis pipeline is connected.

---

## How AOS Uses Databox

### On-Demand Analysis
When you run `/analyze-gtm`, `/health-check`, or ask a data question, Claude:
1. Loads `DOMAIN_CHANNEL_MAP.md` to identify the right data sources
2. Pulls metrics via `load_metric_data` from the Databox MCP
3. Applies guardrails (domain isolation, currency normalization, attribution window awareness)
4. Scores confidence via the Confidence Engine
5. Produces BLUF + OODA + data table + "What Could Invalidate"

### Scheduled Monitoring
Daily and weekly scheduled agents:
1. Pull key metrics for each client with `data/BASELINES.md`
2. Compare to rolling 30-day baselines
3. Check sync lag before flagging
4. Apply alarm sensitivity thresholds per client
5. Create tasks for confirmed anomalies

### Recommendation Tracking
The outcome-tracker agent:
1. Checks whether executed recommendations moved the target metric
2. Pulls before/after data from Databox
3. Updates recommendation status (confirmed / no effect / too early)
4. Pushes results to a Databox dataset for dashboard visibility

---

## Metric Key Reference

Databox uses platform-specific metric key prefixes:

| Platform | Prefix | Example Keys |
|---|---|---|
| Google Analytics 4 | `GoogleAnalytics4@` | `sessions`, `transactions`, `purchaseRevenue`, `bounceRate`, `activeUsers` |
| Google Ads | `GoogleAdwords@` | `cost`, `conversions`, `total_conv` (conversion value), `clicks`, `avg_cpc` |
| Meta/Facebook Ads | `FbAds@` | `spend`, `impressions`, `clicks`, `actions` |
| Shopify | `Shopify@` | `orders`, `total_sales`, `average_order_price` |
| Search Console | `GoogleSearchConsole@` | `clicks`, `impressions`, `ctr`, `position` |

To discover all available metrics for a source:

```
List all metrics for Databox data source 1234567
```

**Always use the exact metric key** returned by `list_metrics`. Do not modify, truncate, or guess keys.

---

## Multi-Account Setup

If you manage multiple clients, each may be a separate Databox account:

```
List my Databox accounts
```

Note the account IDs, then list data sources per account:

```
List data sources for Databox account 589623
```

The MCP token must have access to all accounts you want to query. If some sources return "not found," the token may be scoped to a single account — create a token with broader access or use account-specific tokens.

---

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| "metric resource not found" | Source ID doesn't match current token scope | Verify source ID with `list_data_sources`. Token may be scoped to different account. |
| Empty data points | Date range has no data, or source recently connected | Check Databox UI — data appears there first |
| Wrong currency in results | Querying a shared source without domain filter | Add `dimension: "campaign"` and filter by campaign name patterns |
| Stale data | Normal sync lag — Google Ads ~4h, Shopify ~24-48h | Check `Typical Lag` in DOMAIN_CHANNEL_MAP before investigating |
| Rate limit (429) | Too many requests in batch | System auto-handles via `MCP_RATE_LIMITS.md`: max 5 metrics/batch, 2s delay |

---

## Security Notes

- Your Databox API token is stored in `.mcp.json` locally — never commit this file to Git
- `.gitignore` should include `.mcp.json` (the repo ships `.mcp.json.example` without tokens)
- Data pulled from Databox is processed in your Claude Code session — it's not stored on Anthropic servers beyond the session context
- For client data handling rules, see `core/infrastructure/DATA_RULES.md`
