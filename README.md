> v1.1 — 2026-04-04 — GTM reframe, updated counts

# Arcanian OS

An open-source operating system for marketing operations — powered by Claude Code and Databox.

Built by a 4-person team running marketing for 17 clients across 30 markets. Now available as a starter kit.

---

## What This Is

Arcanian OS is a collection of skills, agents, SOPs, and guardrails that turn Claude Code into a marketing operations system. It connects to your data through Databox MCP, applies analytical frameworks to every query, and creates follow-up tasks when it finds something.

This is not a SaaS product. There's no backend, no database, no deployment pipeline. The entire system runs as Claude Code + CLAUDE.md + markdown files + MCP connections.

**"Development" means writing better instructions, smarter agents, tighter guardrails, and wiring them together.**

---

## What's Inside

| Component | Count | What It Does |
|---|---|---|
| **Skills** | 35+ | Slash commands: /7layer, /health-check, /analyze-gtm, /sales-pulse, /scaffold-project, /council |
| **Agents** | 14 | Audit checker, channel analysts (Google Ads, Meta, Shopify), PII scanner, report reviewer, outcome tracker |
| **SOPs** | 20+ | Marketing ops, client onboarding, campaign management, vendor access, financial controls |
| **Methodology** | 30+ | Task system, ontology, guardrails, confidence engine, currency normalization, attribution windows |
| **Templates** | 25+ | CLAUDE.md, TASKS.md, client config, domain channel map, baselines, recommendation log |
| **Guardrails** | 8+ | Data reliability, domain isolation, evidence classification, discovery-not-pronouncement, alarm calibration |
| **Council System** | 4 configs | Multi-agent deliberation — 6 hypotheses, evidence scoring, consensus |

---

## How It Works

```
You say: "Run my sales pulse"

Claude:
1. Loads the /sales-pulse skill (markdown instructions)
2. Reads DOMAIN_CHANNEL_MAP.md (which data sources, which domains)
3. Pulls 14+ metrics from Databox via MCP
4. Applies CONFIDENCE_ENGINE.md (scores each data point)
5. Checks BASELINES.md (is this normal or anomalous?)
6. Checks ALARM_CALIBRATION.md (is this client sensitive to this?)
7. Generates BLUF (conclusion first, confidence level)
8. Runs OODA analysis (observe, orient, decide, act)
9. Creates follow-up tasks if action needed
10. Saves report with ontology tags
```

When something looks wrong, the system doesn't just flag it. It generates competing hypotheses, scores each against available evidence, and tells you what could invalidate each finding.

When uncertain, it spawns multiple agents to analyze the same data from different angles and produce a consensus.

---

## Quick Start

### 1. Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Clone this repo

```bash
git clone https://github.com/your-org/arcanian-os.git
cd arcanian-os
```

### 3. Connect Databox

Copy the MCP config example:

```bash
cp .mcp.json.example .mcp.json
```

Edit `.mcp.json` and add your Databox API key.

### 4. Set up your first client

```bash
claude
# Then type:
/scaffold-project
```

This creates the full client directory structure with all required files.

### 5. Run your first analysis

```bash
# Health check across all clients
/health-check

# Sales pulse on a specific client
/sales-pulse

# 7-layer diagnostic
/7layer
```

---

## Directory Structure

```
arcanian-os/
├── CLAUDE.md                          <- The kernel. Start here.
├── .mcp.json.example                  <- MCP config (Databox)
├── core/
│   ├── skills/                        <- 35+ slash commands
│   ├── agents/                        <- 14 AI agents + 4 council configs
│   ├── sops/                          <- 20+ standard operating procedures
│   │   ├── marketing-ops/             <- Campaign, measurement, lead, email SOPs
│   │   └── arcanian/                  <- Client onboarding, quarterly review
│   ├── methodology/                   <- Rules, standards, guardrails
│   ├── templates/                     <- Scaffolds for all client files
│   ├── reference-implementations/     <- Gold standards and benchmarks
│   └── infrastructure/                <- Data rules
├── clients/
│   ├── example-ecom/                  <- Multi-domain e-commerce example
│   ├── example-saas/                  <- Single-domain SaaS example
│   └── example-local/                 <- Local services example
└── docs/
    ├── GETTING_STARTED.md
    └── DATABOX_SETUP.md
```

---

## Key Concepts

### Skills
Slash commands that Claude executes. Each is a markdown file with instructions, input/output format, and guardrail references. Type `/health-check` and Claude follows the instructions in `core/skills/health-check.md`.

### Agents
Specialized sub-processes that handle specific domains. The Google Ads channel analyst knows about Smart Bidding signals and Performance Max asset groups. The PII scanner checks every output before it reaches a client. Each agent has a markdown spec defining its role, tools, and constraints.

### Council System
When the system is uncertain, it spawns multiple agents to analyze the same data independently. Each agent argues from its own perspective. The council produces a consensus with dissent noted. This is how the system avoids single-point-of-failure reasoning.

### Confidence Engine
Every finding gets a confidence score: `[Confidence: 0.7 — 2 sources corroborate, 1 has 48h sync lag]`. Score = minimum of source confidence, evidence classification, and assumption status. The weakest link wins. This prevents the system from being more confident than the data supports.

### Domain Channel Map
Per-client file mapping every marketing channel, tool, and data source to the domain it serves. The system loads this before any analysis to prevent cross-domain data contamination. Critical for multi-domain clients.

### Alarm Calibration
Not every metric drop is a crisis. Each client has a sensitivity setting (low/normal/high) that adjusts anomaly thresholds. A 15% session drop is noise for one client and an emergency for another.

---

## Demo Data vs Production

This repo includes a demo dataset (`demo-data/`) and a pre-configured example client (`clients/example-ecom/`) with synthetic data loaded into a Databox demo account.

### How data flows differently:

| | Demo (included) | Your Production Setup |
|---|---|---|
| **Data source** | Synthetic CSVs pushed to Databox | Native connectors (GA4, Shopify, HubSpot, etc.) |
| **Query method** | `ask_genie` with dataset ID | `load_metric_data` with metric key (e.g., `GoogleAnalytics4@sessions`) |
| **Speed** | Slower (natural language) | Fast (structured API) |
| **Setup** | Already configured | Connect your accounts in Databox → auto-discovered |

### To try the demo:

1. Copy `.mcp.json.example` to `.mcp.json`
2. Run `claude` and authenticate with Databox when prompted
3. Type `/sales-pulse` → select `example-ecom` → select `AquaLux US`
4. The system queries the demo data and produces an analysis with planted anomalies

### To connect your own data:

1. Connect your GA4/Shopify/CRM in Databox (databox.com)
2. Run `/scaffold-project` to create a new client
3. Fill in `DOMAIN_CHANNEL_MAP.md` with your Databox data source IDs
4. Run `/sales-pulse` or `/health-check` — the system queries your live data via `load_metric_data`

The skills, agents, and guardrails work identically in both cases. The only difference is where the data comes from.

---

## Guardrails

The system includes several mandatory guardrails that apply to every analysis:

- **Data Reliability Framework** — every data source gets a confidence rating
- **Evidence Classification** — [DATA], [OBSERVED], [STATED], [NARRATIVE], [INFERRED], [HEARSAY]
- **Domain Isolation** — multi-domain analysis excludes non-target domain data
- **Discovery, Not Pronouncement** — present observations with questions, not conclusions
- **Unverified Assumptions** — "not mentioned" does not equal "doesn't exist"
- **Currency Normalization** — never sum HUF and EUR without conversion
- **Attribution Windows** — Google 30d click is not comparable to Meta 7d click

---

## What This Is NOT

- Not a SaaS product. There's no login, no dashboard, no subscription.
- Not a prompt library. These are structured operational procedures, not chat templates.
- Not plug-and-play. You need to configure it for your clients, your data sources, your methodology.
- Not a replacement for thinking. The system helps you think better — it doesn't think for you.

---

## Who It's For

- Marketing agencies running multiple clients across multiple channels
- In-house teams managing multi-domain, multi-market operations
- Databox customers who want AI-powered analysis on top of their data
- Anyone who believes marketing ops should be systematic, not ad hoc

---

## Requirements

- [Claude Code](https://claude.ai/code) (Claude Max or API key)
- [Databox](https://databox.com) account with MCP enabled
- Your marketing data connected to Databox (GA4, Google Ads, Meta, Shopify, CRM, etc.)

---

## License

MIT

---

## Built By

The Arcanian team. Powered by Claude Code + Databox MCP.

Questions? Open an issue or reach out at https://arcanian.com/os
