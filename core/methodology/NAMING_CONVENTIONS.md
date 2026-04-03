# Arcanian Ops — File Naming Conventions

> Compiled from Arcanian (468 files) and ExampleBrand (944 files). Use these patterns in all projects.

## By Context

| Context | Pattern | Example |
|---|---|---|
| **Process/SOP** | `NN-DESCRIPTIVE-NAME.md` | `01-AGENCY-COORDINATION.md` |
| **Quick Win** | `NN-QUICK-WIN-descriptive.md` | `10-QUICK-WIN-welcome-email-fix.md` |
| **Dashboard spec** | `NN-PLATFORM-DASHBOARD-NAME.md` | `19-DATABOX-DASHBOARD-PLAN.md` |
| **Takeover strategy** | `NN-TITLE.md` | `10-SYSTEM-ACCESS-DICTIONARY.md` |
| **Correspondence** | `{recipient}-{topic}-{status}.md` | `gabor-budget-review-sent.md` |
| **Audit section** | `NN-name.md` | `01-automations.md` |
| **Audit report** | `AUDIT-REPORT.md` | `audit/ac/AUDIT-REPORT.md` |
| **Newsletter HTML** | `MMDD-topic-market-version.html` | `0226-tavasz-koszonto-hu.html` |
| **Newsletter strategy** | `EMAIL-BEST-PRACTICES.md` | `newsletter/EMAIL-BEST-PRACTICES.md` |
| **LinkedIn post** | `LINKEDIN_POST_NN_TITLE.md` | `LINKEDIN_POST_23_OPENCLAW.md` |
| **LinkedIn comment** | `LINKEDIN_COMMENT_NN_DESC.md` | `LINKEDIN_COMMENT_102_KOSZEGI.md` |
| **Substack post** | `SUBSTACK_POST_NN_TITLE.md` | `SUBSTACK_POST_24_AI_IDENTITY.md` |
| **Lead/client file** | `COMPANY_PHASE_DESCRIPTOR.md` | `EURONICS_DISCOVERY_CALL.md` |
| **Person analysis** | `ANALYSIS_LASTNAME_FIRSTNAME.md` | `ANALYSIS_GAZSI_ZOLTAN.md` |
| **Strategic analysis** | `ANALYSIS_PROJECT_TOPIC_DATE.md` | `ANALYSIS_ARCANIAN_SELF_DIAGNOSTIC_SFM.md` |
| **Brand versions** | `DOCUMENT_VN.md` | `CONVERSION_STORY_V3.md` |
| **Pitch deck** | `PITCH_DECK_TARGET.md` | `PITCH_DECK_EXAMPLE.md` |
| **Dev brief** | `DEV_BRIEF_TOPIC_DATE.md` | `DEV_BRIEF_TASK_SYSTEM_2026_03_23.md` |
| **Session log** | `SESSION_YYYY-MM-DD.md` | `SESSION_2026-01-20.md` |
| **Inbox item** | `YYYY-MM-DD_SHORT_DESC.md` | `2026-03-08_STRATEGIC_REVIEW.md` |
| **Finding** | `FND-NNN_slug.md` | `FND-001_gads-cart-data-stopped.md` |
| **Recommendation** | `REC-NNN_slug.md` | `REC-001_remove-hardcoded-gads.md` |
| **Known pattern** | `PAT-NNN` (in KNOWN_PATTERNS.md) | `PAT-035 Dead GA4 message bus` |
| **GTM export** | `GTM-{ID}_workspace{N}.json` | `GTM-EXAMPLE-001-005_workspace51.json` |
| **Feed snapshot** | `{provider}_{country}_YYYY-MM-DD.xml` | `channable_hu_2026-03-07.xml` |
| **Meeting transcript** | `YYYY-MM-DD_MEETING-TITLE.md` | `2026-03-16_AKOS-CALL.md` |
| **Team doc** | Descriptive | `KOLBE_STRATEGY_ALIGNMENT.md` |
| **Methodology** | Descriptive, versioned if needed | `ARCANIAN_METHODOLOGY.md` |

## Numbering Ranges (Processes)

| Range | Purpose | Example |
|---|---|---|
| 00-09 | Core operational processes | `01-AGENCY-COORDINATION.md` |
| 10-19 | Quick wins / one-time fixes | `10-QUICK-WIN-welcome-email-fix.md` |
| 20-29 | Dashboards and reporting | `19-DATABOX-DASHBOARD-PLAN.md` |
| 30+ | Ad-hoc / project-specific | As needed |

## Status Suffixes (Correspondence)

| Suffix | Meaning |
|---|---|
| `-sent` | Email/message sent |
| `-received` | Reply received |
| `-draft` | Not yet sent |

## Version Tracking

| Pattern | When |
|---|---|
| `_V1.md`, `_V2.md`, `_V3.md` | Major document revisions (brand stories, strategies) |
| `_v1.0.md`, `_v1.1.md` | Skills with semantic versioning |
| `workspace{N}` | GTM container versions |

## In-File Versioning (SYSTEM-WIDE)

Every .md output from a skill should include version + date:

```markdown
> v1.0 — 2026-03-24
```

When updating, bump version and note what changed:
```markdown
> v1.1 — 2026-03-25 — Fixed email profit calculation, added cart recovery
```

- Major (v2.0): structural change or complete rewrite
- Minor (v1.1): content updates, corrections, additions
- Enforced by: `post-tool-use-version-guard.sh` hook (warns if .md written without version)

## Supersession

When a file is replaced entirely:
1. Add `V{N+1}` to new filename
2. Add `> Superseded by V{N+1}` at top of old file
3. Or move to `archive/` with original name
4. Log decision in CAPTAINS_LOG.md
