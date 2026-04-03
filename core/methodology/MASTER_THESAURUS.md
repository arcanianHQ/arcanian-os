> v1.0 — 2026-03-24

# Arcanian Ops — Master Thesaurus & Dictionary

> System-wide definitions. When a term is used in any skill, SOP, hook, or deliverable — THIS is what it means.
> Per-client overrides go in PROJECT_GLOSSARY.md.

---

## System Concepts

| Term | Abbreviation | Definition |
|---|---|---|
| **UPD** | User Provided Data | Any data, file, export, or information the CLIENT provides to us. Must be tracked, verified, and stored in `upd/` per client. |
| **FND** | Finding | A documented issue discovered during audit. File: `FND-NNN_slug.md` |
| **REC** | Recommendation | A proposed fix for a finding. File: `REC-NNN_slug.md` |
| **PAT** | Pattern | A reusable bug pattern across clients. In `KNOWN_PATTERNS.md` |
| **SOP** | Standard Operating Procedure | A repeatable process. In `core/sops/` |
| **MCP** | Model Context Protocol | How Claude Code connects to external APIs |
| **GTD** | Getting Things Done | Task management methodology (Allen). Our labels: @next, @waiting, @someday, etc. |
| **[Customer Need Framework]** | Jobs To Be Done | Framework for understanding what customers "hire" a product to do |
| **SFM** | Success Factor Modeling | Dilts methodology for modeling excellence |
| **L0-L7** | Layer 0-7 | Arcanian Marketing Control Framework layers |
| **CMP** | Consent Management Platform | Cookie consent tool (CookieBot, Amasty, Unas native) |
| **sGTM** | Server-side GTM | Server-side Google Tag Manager |
| **CAPI** | Conversions API | Server-side event sending (Meta CAPI, Google EC) |
| **EC** | Enhanced Conversions | Google Ads user data matching for better attribution |
| **OCT** | Offline Conversion Tracking | Sending offline sales data back to ad platforms |
| **GTM export** | GTM container JSON | Full config snapshot. Named: `GTM-{ID}_workspace{N}.json`. Stored in `data/gtm-exports/`. |
| **UPD** | User Provided Data | Any data the client provides. Stored in `upd/` per client. |
| **ROAS** | Return On Ad Spend | Revenue ÷ ad cost |
| **AC** | ActiveCampaign | CRM/email platform (used by ExampleBrand) |

## File/Directory Concepts

| Term | Definition |
|---|---|
| **upd/** | User Provided Data directory — per client. Raw inputs from the client: exports, screenshots, docs, answers. |
| **inbox/** | Staging area for unprocessed inputs. Triage within 7 days. |
| **brand/** | Client intelligence profile (7 files: 7LAYER_DIAGNOSTIC, CONSTRAINT_MAP, REPAIR_ROADMAP, , VOICE, Target Profile, POSITIONING) |
| **meetings/** | Meeting transcripts + processed notes. `raw/` subdirectory for original Fireflies output. |
| **core/** | Protected shared resources (skills, SOPs, methodology). [Owner] only. |
| **ext:** | External system task ID ([Task Manager] task ID, Asana gid) |
| **synced:** | Timestamp of last sync with external system |

## Impact Scale

| Term | Definition | Question it answers |
|---|---|---|
| **noise** | Doesn't move anything meaningful | "Does anyone notice?" |
| **hygiene** | Prevents problems, avoids downside | "If we don't, what breaks?" |
| **lever** | Multiplies something already working | "What does this multiply?" |
| **unlock** | Removes a blocker, opens new capability | "What does this unblock?" |
| **breakthrough** | Changes the game | "Does this change everything?" |

## Task Types (GTD)

| Label | Type | Actionable? |
|---|---|---|
| **@next** | Ready to do now | Yes |
| **@waiting** | Blocked on someone else | No (them) |
| **@someday** | Not committed | Maybe later |
| **@reminder** | Awareness, trigger date | No |
| **@monitor** | Check periodically | Check, not do |
| **@decision** | Needs a choice | Think, not do |
| **@reference** | Stored context | No |
| **@milestone** | Point in time | No |

## Layers (L0-L7)

| Layer | Name (EN) | Name (HU) | Covers |
|---|---|---|---|
| **L0** | Source | Forrás | People's identity, patterns, mindset. WHY they can't change. |
| **L1** | Core | Mag | Organizational capability: team, processes, structure, decisions. |
| **L2** | Customer | Ügyfél | Who the customer is: Target Profile, personas, segments, identity. |
| **L3** | Value | Érték | What value is delivered: product-market fit, methodology. |
| **L4** | Offer | Ajánlat | How value is packaged: pricing, bundling, guarantees. |
| **L5** | Channels | Csatornák | Where marketing happens: SEO, ads, email, social, tracking, measurement. |
| **L6** | Conversion | Konverzió | How leads become customers: funnels, scoring, CRM, automation. |
| **L7** | Intelligence | Intelligencia | How you measure and learn: analytics, testing, competitive intel. |

## Delivery Phases

| Phase | Name | What happens |
|---|---|---|
| 1 | **EXPLORE** | Discovery call, /7layer, First Signal |
| 2 | **PLAN** | , /repair-roadmap, brand intelligence |
| 3 | **ARCHITECT** | Strategy design, SOP adaptation, dashboards |
| 4 | **IMPLEMENT** | Execute tasks, run audits, agency coordination |
| 5 | **REVIEW** | Knowledge extraction, pattern checking, quality |
| 6 | **MONITOR** | @monitor tasks, compliance, performance tracking |

## Guardrails

| # | Name | One-liner |
|---|---|---|
| 1 | Discovery Not Pronouncement | Help people think, don't tell them what's true |
| 2 | Unverified Assumptions | Not mentioned ≠ doesn't exist |
| 3 | File Versioning | v1.0 — date on every output |
| 4 | PII Guard | Warn on secrets in prompts |
| 5 | Directory Guard | Block cross-client writes |
| 6 | Ontology Check | Enforce bidirectional links |
| 7 | Inbox Aging | Flag files > 7 days |
| 8 | Glossary Enforcement | Warn on banned terms per client |
| 9 | Email Consent | GDPR before any email send |
| 10 | MCP Rate Limits | Batch + delay, never bulk |

## Hungarian Terms (Arcanian-specific)

| Hungarian | English | Context |
|---|---|---|
| **Térkép → Rendszer → Változás** | Map → System → Change | Arcanian core model |
| **Réteg** | Layer | L0-L7 framework |
| **Szűk keresztmetszet** | Constraint / bottleneck | Primary constraint in diagnostics |
| **Ajánlat** | Proposal / offer | Client proposal document |
| **Árrés** | Margin | Profit margin (typically 20-25% for e-commerce) |
| **Tegező** | Informal "te" address | Casual register |
| **Magázó / Önöző** | Formal "Ön" address | Formal register |
| **Navigátor szerep** | Navigator role | ExampleLocal-specific: [Name]'s positioning |
| **Kommunikációs Útmutató** | Communication guide | ExampleLocal-specific: NOT "brand kézikönyv" |
