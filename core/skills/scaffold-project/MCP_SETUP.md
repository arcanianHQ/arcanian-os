# Scaffold — MCP Setup Per Project Type

> Which MCP servers to configure after scaffolding. Load post-scaffold.

## Client Projects

| MCP Server | Required? | What it does |
|---|---|---|
| **[Task Manager]** or **Asana** | Yes (per sync target) | Task sync |
| **Databox** | Yes | Dashboard read/write, metrics, goals |
| **Google Analytics 4** | Yes | Traffic, conversions, audiences |
| **Google Ads** | If client runs Ads | Campaign performance, conversions |
| **Meta Ads** | If client runs Meta | Ad performance, CAPI status |
| **ActiveCampaign** | If client uses AC | CRM, automations, email |
| **Shopify** | If client uses Shopify | Orders, products, customers |
| **Fireflies.ai** | Recommended | Meeting transcripts → CAPTAINS_LOG + TASKS |
| **Slack** | Yes (Phase 2+) | Team communication via --channels |

## Audit Projects

| MCP Server | Required? | What it does |
|---|---|---|
| **Chrome DevTools** | Yes | Phase 1 browser verification |
| **Firecrawl** | Recommended | Phase 0 website scraping |
| **[Task Manager]** | Yes | Task sync |

## Internal Projects

| MCP Server | Required? | What it does |
|---|---|---|
| **[Task Manager]** | Yes | Task sync |
| **Firecrawl** | Optional | Diagnostics, First Signal automation |
| **Slack** | Yes | Team coordination |

## Fireflies Integration Pattern

1. Fireflies auto-records meetings
2. Transcript → `inbox/YYYY-MM-DD_MEETING-TITLE.md`
3. Claude extracts: actions → TASKS.md, decisions → CAPTAINS_LOG.md, contacts → EXTERNAL-CONTACTS-TABLE.md
4. Archive transcript to `archive/`

## Databox Integration Pattern

1. Dashboard definitions in `processes/19-29` range
2. Metrics pulled via MCP for reports
3. Weekly/monthly reports → `reports/YYYY-WNN.md`
4. Goals tracked via Databox Goals API → TASKS.md `Goal:` edges
