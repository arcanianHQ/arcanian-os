---
scope: shared
---

> v1.0 — 2026-04-21

# Nexus Client Config

> **Canonical pattern** — every client directory that uses `/nexus-answer` (or any other Nexus-powered skill) has a `.nexus-config.md` file declaring account routing, entity topology, current campaign windows, and measurement caveats.

---

## Why this exists

The skill can't read a client's mind. Three recurring needs:

1. **Which Databox account belongs to this client?** (could be 1, could be 4 for multi-entity)
2. **What counts as "the current campaign" / "the last promo"?** (dates vary per client, not guessable)
3. **What known data caveats apply?** (consent mode issues, attribution quirks, ingestion lags)

The `.nexus-config.md` file lives in the client directory (`clients/{slug}/.nexus-config.md`) and encodes this so the skill doesn't hallucinate or ask the user every time.

---

## File location

```
clients/
├── diego/
│   ├── .nexus-config.md        ← here
│   ├── CLIENT_CONFIG.md
│   ├── CONTACTS.md
│   └── ...
├── wellis/
│   └── .nexus-config.md
└── ...
```

When `/nexus-answer` runs from a client subdir, it reads the local `.nexus-config.md`. When run from the hub, it falls back to `ArcanianOS DEMO` with a warning.

---

## File schema

```yaml
---
client_slug: diego
primary_currency: HUF
primary_timezone: Europe/Budapest
nexus_version: 1.3
---

# Nexus Config — Diego

## Entities

Diego is a multi-entity client. 4 legal entities × 3 countries.

| entity_id | legal_name | country | databox_account_id | primary_ga4_property | default_for |
|---|---|---|---|---|---|
| diego-hu | Diego Kft. | HU | 589623 | GA4 HU | general |
| vrsoft-kft | VR Software Kft. | HU | (tbd) | GA4 VR HU | vrsoft questions |
| vrsoft-srl | VR Software SRL | RO | 599447 | GA4 RO | vrsoft RO |
| deluxe | Deluxe Building | HU | (tbd) | (tbd) | deluxe only |

**Aggregation rules:**
- "Diego cégcsoport" / "összes Diego" → query all 4 entities, sum or weighted aggregate per metric
- "Diego HU" → entity `diego-hu` only
- Ambiguous ("Diego") → ask which, OR default to `diego-hu` if config says `default_for: general`

## Data sources (per entity)

### diego-hu (Databox account 589623)

Active sources:
- GA4 (OAuth) — property 12345678
- Google Ads (OAuth) — customer 123-456-7890
- Meta Ads (OAuth) — account act_999000111
- SEMrush (OAuth) — project ID

### vrsoft-srl (account 599447)
- GA4 (OAuth) — property 98765432
- Google Ads (OAuth) — customer 987-654-3210
- Meta Ads — not connected (flag)
- SEMrush — not connected (flag)

## Campaign windows

Recent campaigns with explicit dates. Skill uses these when user says "the promo" or "az akció":

| window_id | label | start | end | entities_active |
|---|---|---|---|---|
| glamour-2026-spring | Glamour tavaszi | 2026-04-14 | 2026-04-21 | diego-hu, diego-ro, diego-sk |
| easter-2026 | Húsvéti kampány | 2026-03-25 | 2026-04-07 | diego-hu, diego-ro |
| (future) | ... | | | |

## Measurement caveats

Known issues that affect confidence scoring and narrative composition. The skill should surface these in Block 3 footer.

- **GA4 HU consent mode:** ~30% undercounting on mobile. Revenue figures should be grossed up mentally by 1.4× for total-reality estimate. Surface as consent-gap flag.
- **Meta Ads 7d-click + 1d-view:** overcounts by ~15-25% vs GA4 conversion count. Expected.
- **SaleCortex CRM integration:** ETA Dec 2026. Until then, pipeline-value metrics not queryable via Nexus.
- **RO currency:** RON, not HUF. Convert before aggregating with HU data. Current rate: 1 RON = ~76 HUF (check `currency.md` for live rate).

## Data freshness expectations

- GA4: 4-24 hour lag (typical)
- Google Ads: near-real-time
- Meta Ads: 3-6 hour lag
- SEMrush: daily snapshot, 24 hour lag

Narrative output should flag when answering a "yesterday" question before the expected freshness window has passed.

## Ambiguity resolution defaults

When the user's question is ambiguous, apply these rules BEFORE asking them:

1. **No entity mentioned, generic question** → `default_for: general` entity (diego-hu)
2. **No time window** → last 14 days with 14-day PoP
3. **"Az akció" / "promo"** → most recent campaign end within 14 days → `glamour-2026-spring`
4. **Multiple matches possible** → ask once, short: "Melyik? (1) Diego HU (2) Cégcsoport összesen (3) VRSoft"

---

## Minimum config for a new client

If you don't know all the fields yet, this is the minimum to make `/nexus-answer` work:

```yaml
---
client_slug: wellis
primary_currency: HUF
primary_timezone: Europe/Budapest
nexus_version: 1.3
---

# Nexus Config — Wellis

## Entities

Single-entity client.

| entity_id | databox_account_id | default_for |
|---|---|---|
| wellis-primary | 742757 | general |

## Campaign windows

(none configured yet — skill will use last 14-day heuristic)

## Measurement caveats

(none identified yet)
```

The skill reads whatever is declared and falls back to generic behavior for anything missing. Do not over-specify early — let the file grow with actual client usage.

---

## When to update

- New campaign / promo launched → add to `## Campaign windows`
- New integration added on Databox → add to `## Data sources`
- Known data issue discovered → add to `## Measurement caveats`
- New entity acquired / spun off → add to `## Entities`

Every update is tracked in the client's CAPTAINS_LOG.md.

---

## Security + privacy

`.nexus-config.md` may contain account IDs and property IDs — not PII but not intended for public view. `scope: int-confidential` by default when inside a client directory (inherited from the client's own scope).

Never commit this file to a public-scope repo. Never include real client slugs or entity names in shared/company docs.

---

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-04-21 | Initial — file schema, location convention, ambiguity defaults, minimum-config template. Covers the 4 real-data gaps identified in VID-002 build. |
