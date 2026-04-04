---
type: demo/databoard-design
date: 2026-04-04
account: ArcanianOS DEMO (748621)
---

# Databoard Designs — ArcanianOS Demo

> These Databoards serve two purposes:
> 1. In videos: "Here's what Databox shows you" → "Here's what the system TELLS you"
> 2. For leads: log into demo account, see real dashboards before installing Claude Code

---

## Databoard 1: "Sales Pulse Overview"

**Data sources:** GA4 Sessions, GA4 Conversions, Shopify Orders, CRM Contacts, CRM Email

**Layout: 4 rows**

### Row 1 — Hero KPIs (4 number widgets)

| Widget | Metric | Source | Period | Compare to |
|--------|--------|--------|--------|------------|
| Sessions | SUM sessions | GA4 Sessions | Last 30d | Prior 30d |
| Conversions | SUM conversions | GA4 Conversions | Last 30d | Prior 30d |
| Revenue | SUM revenue | Shopify Orders | Last 30d | Prior 30d |
| Conversion Rate | conversions / sessions × 100 | Calculated | Last 30d | Prior 30d |

Expected values: Sessions ~42K (+5%), Conversions ~262 (+28%), Revenue ~$180K (+28%), CR ~0.62%

### Row 2 — Trends (2 line charts)

| Widget | Type | Metrics | Granularity |
|--------|------|---------|-------------|
| Sessions Trend | Line chart | Total sessions | Daily, last 60d |
| Revenue & Orders | Dual-axis line | Shopify revenue + GA4 conversions | Daily, last 60d |

**Key visual:** Sessions should show the Week 2 peak then decline. Revenue/conversions should show the +28% growth.

### Row 3 — Channel Breakdown (1 bar chart + 1 pie)

| Widget | Type | Dimension | Notes |
|--------|------|-----------|-------|
| Sessions by Channel | Horizontal bar | channel (from GA4 Sessions) | Shows Cross-network #1, Paid Social #2 |
| Channel Share | Pie chart | channel (from GA4 Sessions) | Last 30d only |

**Key visual:** Email should be visibly tiny (0.6%). The anomaly the system catches.

### Row 4 — Email Health (3 widgets)

| Widget | Metric | Source | Notes |
|--------|--------|--------|-------|
| Email Sends | SUM sends | CRM Email | Last 30d vs prior — should show -55% |
| Open Rate | AVG open_rate | CRM Email | Last 30d |
| Contact Growth | total_contacts (latest) | CRM Contacts | Running total |

**Key visual:** Email sends should be dramatically lower in March. This is the story the system catches.

---

## Databoard 2: "Anomaly Investigation"

**Data sources:** Google Ads Daily, GA4 Ecommerce, Platform Changes

**Layout: 3 rows**

### Row 1 — The Anomaly (2 number widgets + 1 interval)

| Widget | Metric | Source | Notes |
|--------|--------|--------|-------|
| Conversion Value | SUM conversion_value | Google Ads Daily | Last 30d — highlight the drop |
| ROAS | AVG roas | Google Ads Daily | Last 30d |
| Date of Drop | — | Manual annotation | "Mar 19 — 74% drop" |

### Row 2 — The Comparison (2 line charts side by side)

| Widget | Type | Metrics | Notes |
|--------|------|---------|-------|
| Google Ads: Conversion Value | Line chart | conversion_value daily | Shows 74% drop on day 18, partial recovery |
| GA4: Revenue | Line chart | revenue daily | Shows only 40% drop — DIVERGENCE is the story |

**Key visual:** The two charts side by side show different drop magnitudes. This is what the council debates — is it a tracking issue (H3) or a real business issue (H1)?

### Row 3 — Context (1 table + 1 chart)

| Widget | Type | Data | Notes |
|--------|------|------|-------|
| Platform Changes Log | Table | Platform Changes dataset | Date, platform, description — shows campaign pause, GTM change, attribution window change |
| Google Ads: Spend vs Value | Dual-axis line | spend + conversion_value | Shows spend dropped same day (H1 evidence) |

**Key visual:** The changes log gives the council its evidence. Viewers see: "Oh, there are 3 plausible explanations, not just one."

---

## Databoard 3: "Multi-Client Health"

**Data sources:** Client Health, Weekend Anomaly

**Layout: 3 rows**

### Row 1 — Client Overview (5 number widgets, one per client)

| Widget | Client | Metric | Notes |
|--------|--------|--------|-------|
| NovaTech | sessions (latest day) | Green if normal |
| Greenfield | sessions (latest day) | Green if normal |
| Summit Fitness | sessions (latest day) | **RED — anomaly** |
| Coastal Living | sessions (latest day) | Green if normal |
| Apex Digital | sessions (latest day) | Green if normal |

**Key visual:** 4 green, 1 red. Instantly shows where to focus.

### Row 2 — Summit Fitness Deep Dive (3 widgets)

| Widget | Type | Metric | Notes |
|--------|------|--------|-------|
| Sessions Trend | Line chart | sessions for Summit Fitness only | 7 days — shows the weekend crater |
| Page Load Time | Line chart | page_load_time for Summit Fitness | 7 days — shows the spike correlating with sessions drop |
| Bounce Rate | Line chart | bounce_rate for Summit Fitness | 7 days — shows spike to 82% |

**Key visual:** Three correlated charts tell the story: page speed broke → bounce rate spiked → sessions cratered.

### Row 3 — Anomaly Detail (1 table)

| Widget | Type | Data | Notes |
|--------|------|------|-------|
| Weekend Anomaly Report | Table | Weekend Anomaly dataset | Date, metric, actual vs baseline, deviation%, severity |

**Key visual:** The raw anomaly data with CRITICAL/HIGH severity tags. This is what /day-start reads and translates into "Summit Fitness had a server issue this weekend."

---

## Video Flow: Dashboard → Analysis

The story in each video is the same:

1. **Open the Databoard** — "Here's what Databox shows you."
2. **Point at the data** — "You can see the numbers. But what do they mean?"
3. **Run the skill** — `/sales-pulse` or `/council` or `/day-start`
4. **Show the analysis** — "The system found 3 things the dashboard can't tell you."
5. **Show the contrast** — "The dashboard shows green. The analysis shows a problem underneath."

The Databoard is not the product. The Databoard is the SETUP for the product.

---

## Build Order

1. **Sales Pulse Overview** first (Video 1 = first video to record)
2. **Multi-Client Health** second (Video 4 = simplest to record)
3. **Anomaly Investigation** third (Video 3 = most complex, record last)

---

## Databox Genie Prompts

> Use these prompts in Databox Genie (app.databox.com → Genie) to auto-create the Databoards.
> Select the ArcanianOS DEMO account first.

### Databoard 1: Sales Pulse Overview

```
Create a Databoard called "Sales Pulse Overview" using these data sources:
- Video 1 — GA4 Sessions
- Video 1 — GA4 Conversions
- Video 1 — Shopify Orders
- Video 1 — CRM Contacts
- Video 1 — CRM Email

Layout:

Row 1 — 4 number widgets side by side:
- Total sessions (last 30 days vs prior 30 days)
- Total conversions (last 30 days vs prior 30 days)
- Total revenue from Shopify Orders (last 30 days vs prior 30 days)
- Conversion rate (conversions / sessions × 100, last 30 days vs prior 30 days)

Row 2 — 2 line charts:
- Daily sessions trend (last 60 days)
- Daily revenue + conversions overlay (last 60 days, dual axis)

Row 3 — Channel breakdown:
- Horizontal bar chart: sessions by channel (last 30 days), sorted descending
- Pie chart: channel share of sessions (last 30 days)

Row 4 — Email health:
- Number widget: total email sends (last 30 days vs prior 30 days)
- Number widget: average open rate (last 30 days)
- Number widget: latest total_contacts from CRM Contacts
```

### Databoard 2: Anomaly Investigation

```
Create a Databoard called "Anomaly Investigation" using these data sources:
- Video 3 — Google Ads Daily
- Video 3 — GA4 Ecommerce
- Video 3 — Platform Changes

Layout:

Row 1 — 3 number widgets:
- Total conversion_value from Google Ads Daily (last 30 days)
- Average ROAS from Google Ads Daily (last 30 days)
- Total spend from Google Ads Daily (last 30 days)

Row 2 — 2 line charts side by side:
- Left: Google Ads conversion_value per day (last 30 days) — title "Google Ads: Conversion Value"
- Right: GA4 Ecommerce revenue per day (last 30 days) — title "GA4: Revenue"

Row 3 — Context:
- Table widget showing Platform Changes: columns date, platform, change_description, change_type
- Dual-axis line chart: Google Ads spend + conversion_value per day (last 30 days)
```

### Databoard 3: Multi-Client Health

```
Create a Databoard called "Multi-Client Health" using these data sources:
- Video 4 — Client Health
- Video 4 — Weekend Anomaly

Layout:

Row 1 — 5 number widgets (one per client):
- Filter Client Health by client="NovaTech Solutions", metric="sessions", show latest value
- Filter Client Health by client="Greenfield Market", metric="sessions", show latest value
- Filter Client Health by client="Summit Fitness", metric="sessions", show latest value
- Filter Client Health by client="Coastal Living Co", metric="sessions", show latest value
- Filter Client Health by client="Apex Digital Agency", metric="sessions", show latest value

Row 2 — Summit Fitness deep dive (3 line charts):
- Sessions for Summit Fitness only, last 7 days (filter client="Summit Fitness", metric="sessions")
- Page load time for Summit Fitness only, last 7 days (filter client="Summit Fitness", metric="page_load_time")
- Bounce rate for Summit Fitness only, last 7 days (filter client="Summit Fitness", metric="bounce_rate")

Row 3 — Anomaly table:
- Table widget from Weekend Anomaly: columns date, client, metric, actual_value, baseline_value, deviation_pct, severity, note
- Sort by severity (CRITICAL first)
```
