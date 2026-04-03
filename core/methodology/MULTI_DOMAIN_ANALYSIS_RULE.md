> v1.0 — 2026-03-27

# Multi-Domain Analysis Rule

> **MANDATORY for every client with 2+ domains.** Before ANY channel analysis, ROAS calculation, or performance query — load the client's `DOMAIN_CHANNEL_MAP.md` and filter by domain.

---

## The Problem

Many clients run multiple domains through shared ad accounts, analytics properties, or CRM instances. Without explicit domain→channel mapping:
- Google Ads queries return campaigns for ALL domains mixed together
- ROAS calculations attribute spend from domain A to revenue on domain B
- Meta ad accounts may serve multiple brands
- Databox data sources aggregate across domains
- "ExampleD2C ROAS dropped" becomes unanswerable when the same Google Ads account runs example-pool.com campaigns

**Not mentioned in the query ≠ not present in the data.**

## The Rule

### Before ANY query on a multi-domain client — Databox, MCP, or manual:

1. **Load `DOMAIN_CHANNEL_MAP.md`** from the client directory
2. **Identify which domain(s)** the question concerns
3. **Select the correct account/instance/property** for that domain from the map
4. **Filter every data query** by the campaign/account/property patterns listed for that domain
5. **When a data source is shared**, ALWAYS filter results — never use account-level totals as domain-level metrics
6. **Flag cross-domain contamination** — if a query returns data that spans multiple domains, call it out explicitly

### Applies to ALL tool queries — not just Databox:

| Tool / MCP | Domain question to answer FIRST | Example mistake |
|------------|--------------------------------|-----------------|
| **Databox** | Which data source ID? Is it shared? | Querying Google Ads source without campaign filter mixes example-d2c.com + example-ecom.com |
| **ActiveCampaign MCP** | Which AC instance? (`exampled2c.api-us1.com` vs `example-eu`) | Querying contact count on US instance when the question is about example-ecom.com contacts |
| **GA4** (Databox or direct) | Which GA4 property ID? | Using `385233609` (example-d2c.com) when analyzing example-ecom.com traffic |
| **Google Ads** (Databox) | Which account? Which campaign name patterns? | Account `695-132-7421` contains 3 domains — must filter by `domain_*` prefix |
| **Meta Ads** (Databox) | Which ad account? | "ExampleBrand" account = example-ecom.com, "ExampleBrand - ExampleD2C 2." = example-d2c.com |
| **Search Console** | Which property? | Each domain has its own SC property — never mix |
| **Shopify** | Which store? | ExampleD2C store ≠ Factory Store |
| **Google Merchant Center** | Which MC account? | ExampleD2C has TWO MC IDs (`646843372` US, `280763264` legacy HU) |
| **Asana / [Task Manager]** | Which project/section? | Tasks may span domains — check Domain field |

### The domain question comes BEFORE the data question:

```
User asks: "How many AC contacts do we have?"
                                    ↓
WRONG: list_contacts → get total count
RIGHT: Which domain? → example-d2c.com → use exampled2c.api-us1.com instance
       Which domain? → example-ecom.com → use example-eu instance
       Which domain? → "all" → query BOTH, report separately, then sum
```

```
User asks: "What's our Google Ads ROAS?"
                                    ↓
WRONG: load_metric_data(source: 4924545, metric: cost) → account total
RIGHT: Which domain? → example-d2c.com → source 4924545 + dimension: campaign + filter example-d2c.com_*
       Which domain? → example-ecom.com → source 4924545 + dimension: campaign + filter example-ecom.com_*
       Which domain? → "all" → break down by domain in output, show each separately
```

```
User asks: "Show me GA4 sessions"
                                    ↓
WRONG: Pick any GA4 property
RIGHT: Which domain? → example-d2c.com → property 385233609
       Which domain? → example-ecom.com → property 313221683
```

### What gets mapped (ALL of these):

| Layer | What to map | Example |
|-------|-------------|---------|
| **Ad accounts** | Google Ads, Meta, Bing, Criteo, Amazon | Account ID → which domains' campaigns run here |
| **Campaign patterns** | Name prefixes/patterns per domain | `example-d2c.com_*` → example-d2c.com, `example-ecom.com_*` → example-ecom.com |
| **Analytics** | GA4 properties, GTM containers | Property ID → domain |
| **E-commerce** | Shopify stores, WooCommerce sites | Store → domain |
| **CRM** | ActiveCampaign, HubSpot, GoHighLevel | Instance → which domain's contacts |
| **Databox sources** | Data source IDs | Source ID → what it actually measures |
| **Email/automation** | Klaviyo, AC automations | Account → domain |
| **SEO** | Search Console properties | Property → domain |
| **Marketplace** | Amazon, eBay storefronts | Storefront → domain/brand |
| **Reporting** | Dashboards, Windsor, Roivenue | Dashboard → which domains included |

### When a new channel or tool is discovered:

Add it to `DOMAIN_CHANNEL_MAP.md` immediately. An unmapped channel is an analysis blind spot.

## File Location

```
clients/{slug}/DOMAIN_CHANNEL_MAP.md
```

Template: `core/templates/DOMAIN_CHANNEL_MAP_TEMPLATE.md`

## Which Clients Need This

Any client with 2+ active domains. Check `CLIENT_CONFIG.md` — if the Domains table has more than one row, a map is required.

Current multi-domain clients (check PROJECT_REGISTRY.md for updates):
- **ExampleBrand** — 8+ domains, 4 Google Ads accounts, multiple Meta accounts
- Any future client with multiple brands/markets/domains

Single-domain clients (e.g., ExampleLocal, ExampleOrg) do NOT need this file.

## Integration Points

### Skills & workflows:
- **`/analyze-gtm`** — must load map before pulling Databox metrics
- **``** — domain separation is an audit finding if missing
- **`/morning-brief`** — domain-filtered KPIs, not account-level
- **`/health-check`** — flag unmapped channels
- **`/scaffold-project`** — create empty map for multi-domain clients
- **ACH/BLUF analysis** — filter hypotheses by domain

### MCP servers (every query must be domain-aware):
- **Databox MCP** — check if data source is shared → filter by dimension + campaign patterns
- **ActiveCampaign MCP** — identify which instance (US vs EU) before any contact/automation/campaign query
- **Asana MCP** — tasks may span domains; filter by Domain field or section
- **[Task Manager] MCP** — check domain label on tasks
- **Any future platform MCP** (GA4, Google Ads, Meta) — same rule applies: domain first, query second

## Domain Isolation in Analysis (v2.0 — 2026-03-31)

> Learned from: ExampleD2C Session Drop Analysis v4.0 — example-ecom.com campaign data was flagged "nem exampled2c" but remained in totals, ORIENT causal chain, and ACH table. Flagging is not isolating.

### The Problem

When analyzing a SHARED account (e.g., "Client - ExampleBrand (example-d2c.com)" Meta account contains both example-d2c.com AND example-ecom.com campaigns), other-domain data may appear in the query results. The v1.0 rule said "flag cross-domain contamination." This is insufficient.

**Flagging ≠ Isolating.** Writing "nem exampled2c" next to a row and keeping it in the analysis is like labeling poison and leaving it on the dinner table.

### The Rule: SEPARATE, DON'T FLAG

When an analysis has `Domain: X` in its header:

**1. EXCLUDE non-target domain data from all calculations**
```markdown
❌ "Összesen: $29,017 → $20,391 (-30% spend)"
   — includes example-ecom.com $3,599 in the Feb total

✓ "example-d2c.com összesen: $29,017 → $16,792 (-42% spend)"
   — example-ecom.com $3,599 excluded from total
   Note: example-ecom.com campaigns ($3,599 Feb) run in same account — see example-ecom.com analysis separately
```

**2. EXCLUDE non-target domain events from ORIENT / causal reasoning**
```markdown
❌ "Feb 4: example-ecom.com kampány indult — egyetlen döntés eredménye"
   — example-ecom.com campaign start is NOT a cause of example-d2c.com session drop

✓ If relevant as CONTEXT (budget was reallocated):
   "Context: $3.6K budget was redirected to example-ecom.com campaigns in Feb [DATA] —
   this may explain part of the example-d2c.com spend reduction, but the example-ecom.com
   campaign performance is NOT part of this analysis"
```

**3. EXCLUDE non-target domain rows from ACH evidence table**
```markdown
❌ | example-ecom.com campaigns appeared ($3.6K) | [DATA] | CC | — example-ecom.com data scoring example-d2c.com hypotheses

✓ example-ecom.com campaign data does not appear in ACH table at all.
   If budget reallocation is relevant, the EVIDENCE is:
   | example-d2c.com traffic spend dropped $8.5K→$3K (-65%) | [DATA] | CC |
   — the cause is the ExampleD2C spend drop, not the example-ecom.com campaign start
```

**4. SEPARATE domain data into clearly labeled sections if both must appear**
```markdown
✓ If the analysis needs to show the full account picture:

   ### example-d2c.com campaigns (TARGET DOMAIN)
   | Campaign | Jan | Feb | ... |
   [only example-d2c.com rows]
   example-d2c.com total: $29,017 → $16,792

   ### Other domains in same account (CONTEXT ONLY — excluded from analysis)
   | Campaign | Jan | Feb | ... |
   [example-ecom.com, example-pool.com rows]
   Note: These are shown for account-level context only.
   They are NOT included in totals, ORIENT, or ACH above.
```

**5. TOTALS must match the target domain, not the account**
Every "összesen" / "total" row in a domain-specific analysis MUST equal the sum of target-domain rows only. If the account total is relevant, show it separately as "Account total (all domains)."

### The Test

Before delivering a domain-specific analysis:

1. **Remove all non-target domain rows.** Do the totals still make sense? If they change, the analysis was contaminated.
2. **Read the ORIENT section.** Does any causal claim reference another domain? If yes, it belongs in that domain's analysis, not this one.
3. **Read the ACH table.** Does any evidence row contain another domain's data? If yes, remove it.
4. **Check the BLUF.** Does the conclusion depend on what happened on another domain? If yes, the conclusion is about the account, not the domain.

**"An analysis of example-d2c.com that includes example-ecom.com data is an analysis of the Meta account, not example-d2c.com."**

---

## Failure Mode

Without this rule, the system produces analyses like:
> "ExampleD2C ROAS dropped 54%"

When the real story is:
> "example-pool.com campaigns ate 32% of the shared Google Ads budget ($4.8K/week for $0 return), cannibalizing ExampleD2C's ad spend"

The first is misleading. The second is actionable.

Another failure mode (v2.0):
> "ExampleD2C Meta spend dropped 30% ($29K → $20K)"

When the real story is:
> "example-d2c.com Meta spend dropped 42% ($29K → $16.8K) — $3.6K was reallocated to example-ecom.com campaigns in the same account"

The first understates the drop. The second isolates the domain impact.
