> v1.0 — 2026-04-03

# Getting Started with Arcanian OS

> From clone to first health check in 30 minutes.

---

## Prerequisites

- **Claude Code** installed and authenticated ([claude.ai/code](https://claude.ai/code))
- **Claude Max or API** subscription (Arcanian OS runs on Claude Code — it needs a model)
- **Databox** account (recommended — connects your marketing data. Free tier works for testing)
- **Git** installed

---

## Step 1: Clone the Repo

```bash
git clone https://github.com/arcanianHQ/arcanian-os.git my-agency-ops
cd my-agency-ops
```

---

## Step 2: Configure MCP Connections

Copy the example MCP config:

```bash
cp .mcp.json.example .mcp.json
```

Edit `.mcp.json` and add your credentials:

| MCP Server | Required? | What it does | How to get credentials |
|---|---|---|---|
| **Databox** | Recommended | Pulls marketing metrics for analysis | Databox Settings → API → Create token |
| **Todoist** | Optional | Task sync (bidirectional) | OAuth via `/mcp` in Claude Code |
| **Asana** | Optional | Task sync (alternative to Todoist) | OAuth via `/mcp` in Claude Code |
| **ActiveCampaign** | If you use AC | CRM/email data | Settings → Developer → API URL + Key |

**Important:** MCP connections are frozen at session start. After editing `.mcp.json`, you must restart Claude Code for changes to take effect.

For detailed Databox setup, see [DATABOX_SETUP.md](DATABOX_SETUP.md).

---

## Step 3: Start Claude Code

```bash
claude
```

Claude Code reads `CLAUDE.md` (the "kernel") and loads all skills, agents, methodology, and guardrails automatically. You should see the full system context load.

Test it works:

```
/health-check scope:core
```

This verifies the core files are in place. Expected output: all methodology files pass, skills directory found, templates present.

---

## Step 4: Scaffold Your First Client

```
/scaffold-project
```

When prompted:
- **name:** your client's slug (e.g., `acme-corp`)
- **type:** `client`
- **location:** `clients/acme-corp`

This creates the full project structure:

```
clients/acme-corp/
├── CLAUDE.md              ← Client-specific instructions
├── TASKS.md               ← Task board
├── CAPTAINS_LOG.md        ← Decision journal
├── CONTACTS.md            ← People registry
├── CLIENT_CONFIG.md       ← Domains, tracking IDs, platform access
├── brand/                 ← 7 intelligence profile files (stubs)
├── inbox/                 ← Unprocessed inputs
├── data/                  ← Analytics, exports, baselines
└── (symlinks to core/)    ← Skills, SOPs (read-only)
```

---

## Step 5: Configure CLIENT_CONFIG.md

Open `clients/acme-corp/CLIENT_CONFIG.md` and fill in:

- **Company:** legal name, industry, market
- **Domains:** all websites/shops this client operates
- **Reporting currency:** EUR, USD, HUF — for cross-domain analysis (see `core/methodology/CURRENCY_NORMALIZATION.md`)
- **Alarm sensitivity:** `low`, `normal`, or `high` — how aggressively anomaly detection flags changes (see `core/methodology/ALARM_CALIBRATION.md`)
- **Tracking IDs:** GA4, Google Ads, Meta Pixel, GTM containers
- **Platform access:** CRM, e-commerce, advertising accounts

---

## Step 6: Create DOMAIN_CHANNEL_MAP.md (Multi-Domain Clients)

If your client has 2+ domains (e.g., different shops, markets, or brands):

```
Copy core/templates/DOMAIN_CHANNEL_MAP_TEMPLATE.md to clients/acme-corp/DOMAIN_CHANNEL_MAP.md
```

Fill in:
- Which domain each ad account, GA4 property, and data source maps to
- Currency per source
- Typical sync lag per source (for anomaly detection)
- Databox source IDs (if connected)

**This is mandatory for multi-domain clients.** Without it, every analysis risks cross-domain data contamination.

---

## Step 7: Connect Databox (If Available)

If you have a Databox account with data sources connected:

```
Ask Claude: "List my Databox accounts and data sources"
```

Claude will query Databox MCP and show your connected sources. Map them to the correct domains in `DOMAIN_CHANNEL_MAP.md`.

For full Databox setup instructions, see [DATABOX_SETUP.md](DATABOX_SETUP.md).

---

## Step 8: Run Your First Health Check

```
/health-check
```

Expected first-run output:
- Project integrity: CLAUDE.md, TASKS.md, CONTACTS.md found
- MCP connections: shows which servers are connected
- Baselines: "no baseline yet" (normal — baselines populate after 7 days of data)
- Symlinks: core skills and SOPs accessible

---

## What to Do Next

### Day 1
- [ ] Run `/morning-brief` — your daily overview across all projects
- [ ] Create your first task: open `TASKS.md` and add a task, or use `/tasks add`
- [ ] Try `/analyze-gtm` on your client — GTM gap analysis

### Week 1
- [ ] Run `/health-check` daily to catch drift
- [ ] After 7 days: baselines auto-populate in `data/BASELINES.md`
- [ ] Try `/7layer` for a full diagnostic (needs brand/ files filled in)
- [ ] Set up `/task-sync` if using Todoist or Asana

### Week 2+
- [ ] Run `/council diagnostic --client acme-corp --question "Why is acquisition declining?"` — multi-agent deliberation
- [ ] Try `/measurement-audit` for a deep tracking health check
- [ ] Explore `/craft-offer`, `/jtbd`, `/plan-gtm` for strategy work

---

## Key Skills Reference

### Daily Operations
| Skill | What it does |
|---|---|
| `/morning-brief` | Daily cross-project summary (P0s, overdue, quick wins) |
| `/health-check` | System-wide integrity + anomaly detection |
| `/tasks` | Manage tasks with full ontology |
| `/task-sync` | Bidirectional sync with Todoist/Asana |
| `/inbox-process` | Triage unprocessed files |

### Diagnostics
| Skill | What it does |
|---|---|
| `/7layer` | Full marketing diagnosis (L0-L7 constraint mapping) |
| `/analyze-gtm` | Go-to-market gap analysis |
| `/measurement-audit` | 6-phase tracking/measurement audit |
| `/map-results` | Map business results to underlying beliefs |
| `/council` | Multi-agent deliberation (3-6 agents debate, consensus) |

### Strategy
| Skill | What it does |
|---|---|
| `/craft-offer` | Hormozi Value Equation offer construction |
| `/jtbd` | Jobs-to-be-Done analysis |
| `/plan-gtm` | Go-to-market action plan |
| `/build-brand` | Brand intelligence profile builder |
| `/repair-roadmap` | Constraint-based repair plan |

### Content
| Skill | What it does |
|---|---|
| `/linkedin-comment` | A.E.L.Q. framework LinkedIn comments |
| `/substack-post` | Long-form article writing |
| `/linkedin-comment` | Comment engagement |

For the full list (48 skills), see `core/skills/` or run `/help`.

---

## Architecture Overview

```
arcanian-os/
├── CLAUDE.md           ← THE KERNEL. Loads everything. Start here.
├── core/               ← Protected: methodology, skills, agents, SOPs, templates
│   ├── skills/         ← 48 slash commands
│   ├── agents/         ← 14 agents (channel analysts, audit, PII, outcome tracker)
│   ├── sops/           ← 27 standard operating procedures
│   ├── methodology/    ← Guardrails, standards, rules
│   └── templates/      ← Scaffolds for client files
├── clients/            ← Per-client working directories
│   └── {slug}/         ← Each client is its own workspace
├── .mcp.json           ← MCP server connections (Databox, Todoist, etc.)
└── docs/               ← You are here
```

**How it works:** Claude Code reads `CLAUDE.md` on session start. That file references skills, agents, SOPs, and methodology. When you type `/analyze-gtm`, Claude loads the skill definition, checks for relevant SOPs, loads the client's DOMAIN_CHANNEL_MAP, pulls data via Databox MCP, applies guardrails (confidence scoring, evidence classification, domain isolation), and produces analysis.

**There is no backend, no database, no deployment.** The entire system is Claude Code + markdown + MCP connections.

---

## Guardrails (Built-In)

The system includes guardrails that enforce analytical rigor automatically:

| Guardrail | What it prevents |
|---|---|
| **Confidence Engine** | Every finding gets a score (0-1). Low-confidence findings can't drive decisions. |
| **Evidence Classification** | DATA vs OBSERVED vs STATED vs NARRATIVE vs INFERRED vs HEARSAY. A story repeated 5x doesn't become data. |
| **Domain Isolation** | Multi-domain clients: non-target domain data is excluded, not just flagged. |
| **Attribution Windows** | Cross-platform comparisons flag that Google 30d click ≠ Meta 7d click. |
| **Currency Normalization** | Never sums HUF and EUR. Converts to reporting currency first. |
| **Alarm Calibration** | Per-client sensitivity. A 15% drop is noise for one client, crisis for another. |
| **Recommendation Dedup** | Checks if advice was given before. If it didn't work last time, says so. |
| **Discovery Not Pronouncement** | Presents observations with questions, not conclusions. Invites disagreement. |

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Skills not loading | Verify `core/skills/` directory exists and CLAUDE.md references it |
| MCP not connecting | Restart Claude Code after any `.mcp.json` edit |
| Databox returns "not found" | Check data source IDs in DOMAIN_CHANNEL_MAP match your Databox account |
| `/health-check` errors | Run `/scaffold-project` to regenerate missing files |
| Analysis missing confidence scores | The skill may not have been updated — check for CONFIDENCE_ENGINE reference |
| "No baseline yet" | Normal for first 7 days. Baselines populate after weekly refresh. |

---

## Support

- **Issues:** [github.com/arcanianHQ/arcanian-os/issues](https://github.com/arcanianHQ/arcanian-os/issues)
- **Questions:** hello@arcanian.com
- **Built by:** [Arcanian Consulting](https://arcanian.com) — marketing operations for multi-brand, multi-market businesses
