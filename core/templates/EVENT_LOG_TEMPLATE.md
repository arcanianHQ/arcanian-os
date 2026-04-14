---
scope: shared
---

# Event Log — {Display Name}

> Structured, append-only timeline of operational events that affect data interpretation.
> Every dated external change lives here. Analysis skills load this BEFORE querying data.
>
> v1.0 — {date}

## Event Types

| Code | Meaning | Examples |
|------|---------|----------|
| `budget` | Spend/budget change | Daily budget cut, increase, pause |
| `platform` | Platform/account change | New ad account, property created, pixel swapped |
| `agency` | Agency/team change | New agency started, handover, team restructure |
| `tracking` | Measurement change | GTM publish, sGTM migration, consent update, tag added/removed |
| `campaign` | Campaign launch/kill | New campaign live, campaign paused, creative rotation |
| `migration` | System migration | Domain change, CMS migration, feed switch, ESP migration |
| `legal` | Legal/compliance event | NDA signed, GDPR request, policy change |
| `personnel` | Contact/stakeholder change | New POC, account manager changed, team member left |
| `product` | Product/pricing change | New product line, price increase, SKU change |
| `market` | External market event | Competitor action, seasonality shift, regulation |

## Event Log

| EVT ID | Date | Type | What | Impact | Source | Layer | Related |
|--------|------|------|------|--------|--------|-------|---------|
| _EVT-YYYY-MM-DD-NNN_ | _YYYY-MM-DD_ | _type_ | _What happened (factual, 1 line)_ | _Observed or expected effect_ | _[DATA]/[STATED]/[OBSERVED]_ | _L0-L7_ | _FND/REC/Task refs_ |

## Rules

1. **One event per row.** If two things happened on the same day, two rows.
2. **Source is mandatory.** `[DATA: Databox]` = verified from data. `[STATED: client]` = client said it. `[OBSERVED: GA4]` = seen in platform. `[INFERRED]` = derived from data patterns (must be verified).
3. **EVT IDs are sequential per client per day.** First event on 2026-03-09 = EVT-2026-03-09-001.
4. **Never delete events.** If an event turns out to be wrong, add a correction event referencing it.
5. **Related field links to ontology objects.** FND-039, REC-012, #53 — bidirectional linking applies.
6. **Analysis skills MUST load this file before querying Databox/GA4/any data source.**
7. **Analysis skills MUST append discovered events after completing analysis.**
