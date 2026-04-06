> v1.0 — 2026-04-03
> **Temporal Awareness applies.** Identify exact dates, check holidays/seasonality before flagging anomalies.

# Skill: Sales Pulse (`/sales-pulse`)

> **Data Reliability Framework applies.** Every metric must include [Confidence: HIGH/MED/LOW] and source tag [DATA]/[OBSERVED]/[INFERRED].
> **Temporal Awareness applies.** Identify exact dates, check holidays/seasonality before flagging anomalies.
> **Multi-domain prerequisite:** Load DOMAIN_CHANNEL_MAP.md before querying. Identify which CRM instance, which Databox data source.
> **Discovery, not pronouncement.** Present observations with competing explanations. End with "What did we get wrong?"

## Purpose

Reads CRM/pipeline data through Databox (and direct CRM MCPs as fallback) and delivers a plain-English analysis of pipeline health, activity velocity, lead flow, and deal sources. Analysis first, data second.

## Trigger

Use when: "run my sales pulse", "sales pulse", "pipeline health check", "how's the pipeline", "CRM pulse", "deal flow analysis"

## Input

| Input | Required | Default |
|---|---|---|
| `client` | Yes | Current client context |
| `domain` | No (multi-domain) | All domains |
| `period` | No | Last 30 days vs prior 30 days |
| `crm` | No | Auto-detect from DOMAIN_CHANNEL_MAP.md |

## Prerequisites

Before running, the client must have:
1. A CRM connected to Databox (ActiveCampaign, HubSpot, Salesforce, Pipedrive, Dynamics 365) OR
2. A direct CRM MCP connection (ActiveCampaign MCP, Asana MCP, etc.)
3. DOMAIN_CHANNEL_MAP.md with Databox data source IDs

## Execution Steps

### Step 1: Load context

1. Read `DOMAIN_CHANNEL_MAP.md` — identify CRM type, Databox data source ID
2. Read `CLIENT_CONFIG.md` — identify CRM instance, API details
3. If multi-domain client: ask "which domain?" before proceeding
4. Determine data source: Databox MCP → direct CRM MCP → ask_genie (in priority order)

### Step 2: Pull metrics silently (do NOT print raw data yet)

Pull the following metric categories. Adapt metric keys to the CRM type.

**A. Pipeline Overview (4 metrics)**
- Total pipeline value (open deals/opportunities)
- Deal count by stage
- Average deal size
- Pipeline velocity (days in stage)

**B. Input / Lead Flow (4 metrics)**
- New contacts/leads (period)
- New contacts/leads (prior period, for comparison)
- Lead source breakdown
- Lead-to-opportunity conversion rate

**C. Activity Velocity (3 metrics)**
- Emails sent / opened / clicked (campaigns or 1:1)
- Meetings/calls logged
- Tasks completed

**D. Conversion & Output (3 metrics)**
- Opportunities created
- Deals won / lost
- Revenue closed

**For Databox MCP:** Use `load_metric_data` with appropriate metric keys per CRM type:
- ActiveCampaign: `ActiveCampaign@contacts`, `ActiveCampaign@deals`, `ActiveCampaign@deals_value`, `ActiveCampaign@automations`, `ActiveCampaign@campaign_opens`, `ActiveCampaign@campaign_clicks`, `ActiveCampaign@campaign_sends`, `ActiveCampaign@lists`, `ActiveCampaign@unsubscribes`
- HubSpot: `HubSpot@contacts`, `HubSpot@deals`, `HubSpot@dealAmount`, etc.
- Salesforce: `Salesforce@opportunities`, `Salesforce@leads`, etc.
- Generic: Try `{CRM}@contacts`, `{CRM}@deals`, `{CRM}@revenue`

**If Databox MCP returns empty:** Fall back to `ask_genie` with natural language query. If Genie also fails, try direct CRM MCP (e.g., `mcp__activecampaign-*__authenticate` then query).

**If direct CRM MCP available:** Use it for granular data not available in Databox (deal stages, individual contact data, automation status).

### Step 3: Calculate derived metrics

From raw data, compute:
- Pipeline coverage ratio (pipeline value / quota or target, if known)
- Input trend: new leads this period vs prior period (% change)
- Activity trend: emails/meetings this period vs prior (% change)
- Mid-funnel conversion: leads → opportunities (%)
- Win rate: opportunities → closed won (%)
- Average sales cycle: days from lead creation to closed won
- Concentration risk: % of pipeline in top 3 deals

### Step 4: Generate BLUF (Bottom Line Up Front)

Write 2-4 sentences that capture the most important insight. Lead with the headline, not the data.

Pattern: "[Pipeline state]. But [the risk/opportunity]. [What needs attention]."

Examples:
- "Your pipeline looks healthy at $2.4M, but input dropped 36%. Meeting activity fell 46%. And your mid-funnel conversion is breaking - 22 SQLs produced only 7 opportunities."
- "Strong month: 12 deals closed, revenue up 28%. But pipeline replenishment is lagging - only 8 new opportunities vs 15 last month. You're eating the seed corn."
- "Activity is up across the board, but conversion is flat. More emails and meetings aren't producing more opportunities. The problem isn't effort - it's targeting."

### Step 5: Present the pulse report

Output the full report using the Output Template below.

### Step 6: Offer deep dives

After the main report, present 4 options for deeper analysis:

1. **Pipeline Deep Dive** — deals by stage, concentration risk, aging deals, stuck opportunities
2. **Activity Pulse** — outreach velocity trends, email performance, meeting frequency
3. **Lead Flow** — where the funnel breaks, source quality, conversion by channel
4. **Deal Sources** — where revenue comes from vs where leads come from, CAC by source

If the user selects one, pull additional metrics for that focus area and generate a mini-report.

### Step 7: Auto-save

Save the report to `{client}/data/analytics/sales-pulse_{YYYY-MM-DD}.md` with ontology header.

## Output Template

```
===================================================================
SALES PULSE — {Client} ({Domain})
{Date range} | CRM: {CRM type}
===================================================================

BLUF
----
{2-4 sentence plain-English summary — the headline, not the data}

[Confidence: {HIGH/MED/LOW} — {reason}]

===================================================================
PIPELINE SNAPSHOT
===================================================================

Total Pipeline Value:  {value}  ({change vs prior}%)
Open Deals:            {count}  ({change vs prior}%)
Average Deal Size:     {value}
Win Rate:              {%}

Stage Breakdown:
  {Stage 1}:  {count} deals | {value}  | avg {days} days
  {Stage 2}:  {count} deals | {value}  | avg {days} days
  {Stage 3}:  {count} deals | {value}  | avg {days} days

Concentration Risk:    Top 3 deals = {%} of pipeline
                       {deal 1 name}: {value}
                       {deal 2 name}: {value}
                       {deal 3 name}: {value}

===================================================================
INPUT / LEAD FLOW
===================================================================

New Contacts:          {count}  ({change}% vs prior period)
New Opportunities:     {count}  ({change}% vs prior period)
Lead → Opp Rate:       {%}

Source Breakdown:
  {Source 1}:  {count} leads → {count} opps ({conversion}%)
  {Source 2}:  {count} leads → {count} opps ({conversion}%)
  {Source 3}:  {count} leads → {count} opps ({conversion}%)

===================================================================
ACTIVITY VELOCITY
===================================================================

Emails Sent:           {count}  ({change}% vs prior)
Email Open Rate:       {%}
Email Click Rate:      {%}
Meetings Booked:       {count}  ({change}% vs prior)
Tasks Completed:       {count}  ({change}% vs prior)

===================================================================
CONVERSION & OUTPUT
===================================================================

Deals Won:             {count}  ({change}% vs prior)
Revenue Closed:        {value}  ({change}% vs prior)
Avg Sales Cycle:       {days} days
Deals Lost:            {count}  (top reason: {reason})

===================================================================
OODA
===================================================================

OBSERVE:  {key facts from the data}
ORIENT:   {interpretation — what does it mean? competing explanations}
DECIDE:   {recommended actions}
ACT:      {specific tasks with owner + due date}

===================================================================
DATA RELIABILITY
===================================================================

| Source | Confidence | Known Issues |
|--------|-----------|--------------|
| {source} | {HIGH/MED/LOW} | {issues} |

What Could Invalidate These Findings?
- {risk 1}
- {risk 2}

===================================================================
DEEP DIVES AVAILABLE
===================================================================

1. Pipeline Deep Dive — deals, stages, concentration risk
2. Activity Pulse — outreach velocity trends
3. Lead Flow — where the funnel breaks
4. Deal Sources — revenue vs lead source mismatch

Select a number for a focused mini-report.

What did we get wrong? What's missing?
```

## CRM-Specific Metric Keys

### ActiveCampaign (via Databox)
```
ActiveCampaign@contacts          — total contacts
ActiveCampaign@deals             — deal count
ActiveCampaign@deals_value       — total deal value
ActiveCampaign@lists             — list subscribers
ActiveCampaign@campaign_sends    — emails sent
ActiveCampaign@campaign_opens    — email opens
ActiveCampaign@campaign_clicks   — email clicks
ActiveCampaign@unsubscribes      — unsubscribes
ActiveCampaign@automations       — automation count
```

### ActiveCampaign (via direct MCP)
Use `mcp__activecampaign-{instance}__authenticate` then query contacts, deals, campaigns directly for granular data not available in Databox.

### HubSpot (via Databox)
```
HubSpot@contacts                 — total contacts
HubSpot@deals                    — deal count
HubSpot@dealAmount               — total deal value
HubSpot@sessions                 — website sessions
HubSpot@emailsSent               — emails sent
HubSpot@emailsOpened             — email opens
HubSpot@emailsClicked            — email clicks
```

### Salesforce (via Databox)
```
Salesforce@opportunities         — opportunity count
Salesforce@leads                 — lead count
Salesforce@amount                — total amount
Salesforce@wonOpportunities      — closed won
Salesforce@lostOpportunities     — closed lost
```

### GA4 (supplementary — website activity)
```
GoogleAnalytics4@sessions        — website sessions
GoogleAnalytics4@conversions     — goal completions
GoogleAnalytics4@newUsers        — new users
```

## Databox MCP Limitations

- **Known issue:** `list_metrics` often returns empty for native connectors (AC, FB Ads, Google Ads)
- **Workaround:** Use `load_metric_data` with known metric keys (listed above), or `ask_genie` for natural language queries
- **GA4 works reliably** via Databox MCP
- **For AC/FB/GAds:** Prefer `ask_genie` or direct MCP over `load_metric_data`

## Notes

- This skill produces a read-only report. It does not modify CRM data.
- Always compare to prior period — absolute numbers without context are meaningless.
- If a metric returns null/empty, note it as "[Data not available]" — do not skip the section.
- For multi-domain clients, run separately per domain unless explicitly asked for consolidated view.
- Skill #3 in the AI Marketing Automation Lab free skill series.
- Pairs with: `/analyze-gtm` (measurement), `/health-check` (project health), `` (performance mapping)
