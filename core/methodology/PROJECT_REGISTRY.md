> v1.0 — 2026-04-03

# Arcanian Ops — Project Registry

> All projects with paths, status, and discovery info.
> Updated: 2026-03-25

## Clients (13)

| # | Client | Hub path | Type | Findings | CLIENT_CONFIG | CLAUDE.md | Symlinks |
|---|---|---|---|---|---|---|---|
| 1 | ExampleAuto + ExampleHome | `clients/example-auto-examplehome/` | Audit + fix | 14 FND | Yes | Yes | Yes |
| 2 | ExampleFinance | `clients/example-finance/` | SEO consulting | — | No | Yes | Yes |
| 3 | ExampleOrg | `clients/ExampleOrg/` | Community (placeholder) | — | No | Yes | Yes |
| 4 | ExampleBuild Building | `clients/ExampleBuild/` | Strategic consulting | — | No | Yes | Yes |
| 5 | ExampleRetail | `clients/example-retail/` | Measurement audit | 48 FND + 48 REC | Yes | Yes | Yes |
| 5b | ExamplePress | `clients/ExamplePress/` | Client | — | No | Yes | Yes |
| 6 | ExampleBox | `clients/ExampleBox/` | Subscription box | — | No | Yes | Yes |
| 7 | ExampleWash | `clients/example-wash/` | Product/brand | — | No | Yes | Yes |
| 8 | JAF Holz | `clients/ExampleWood/` | Building materials | — | No | Yes | Yes |
| 9 | ExampleLocal | `clients/examplelocal/` | Audit + consulting | 13 FND + 1 REC | Yes | Yes | Yes |
| 10 | ExampleHome | `clients/examplehome/` | Audit (sister of ExampleAuto) | 8 FND | Yes | Yes | Yes |
| 11 | ExampleSoft | `clients/ExampleSoft/` | Measurement audit | 2 FND + 2 REC | Yes | Yes | Yes |
| 12 | ExampleSoft SK | `clients/ExampleSoftsk/` | GTM (sister of ExampleSoft) | — | No | Yes | Yes |

## Not in Hub

| Client | Location | Reason |
|---|---|---|
| ExampleBrand | `_example_full/` | Joins later (largest client, 944 files) |

## How Claude Code Discovers Files

When a session opens in `clients/{slug}/`:

1. **CLAUDE.md** loads automatically → tells Claude what this project is, where files are
2. **TASKS.md** → shows active work, each task has ontology edges (FND, REC, SOP, Goal, Layer, Meeting, Email)
3. **audit/findings/** → FND-NNN files (each has frontmatter with severity, phase, layer, status)
4. **audit/recommendations/** → REC-NNN files (linked to findings)
5. **brand/** → 7 intelligence profile files (diagnostic understanding of client)
6. **CLIENT_CONFIG.md** → tracking IDs, domains, containers (if audit client)
7. **ACCESS_REGISTRY.md** → platform access matrix (if audit client)
8. **CAPTAINS_LOG.md** → decision history, session handoffs
9. **skills/** → symlink to core (34+ skills available)
10. **sops/** → symlink to core (SOPs available)

Cross-project discovery (from hub session):
- `core/methodology/PROJECT_REGISTRY.md` → this file (all clients listed)
- `core/brand/BRAND_INDEX.md` → brand intelligence completion status
- `/morning-brief` skill → reads ALL clients/*/TASKS.md
- `core/methodology/KNOWN_PATTERNS.md` → patterns from ALL clients

## Internal

| Project | Hub path | Files | Key docs |
|---|---|---|---|
| Arcanian | `internal/` | ~560 | CAPTAINS_LOG (2,415 lines), PUBLICATION_DIRECTORY, CONTENT_CALENDAR |

## Core (protected — [Owner] only)

| Component | Path | Count | Discovery |
|---|---|---|---|
| Methodology | `core/methodology/` | ~10 | Task system, naming, MCP, client intel, risk register, project registry |
| Skills | `core/skills/` | 5+refs | /tasks, /scaffold-project, /validate, /preflight, /delivery-phase |
| Agents | `core/agents/` | 7 | audit-checker, report-reviewer, pii-scanner, data-rules-checker, project-architect, client-explorer, knowledge-extractor |
| SOPs | `core/sops/` | 12 | 9 marketing-ops + 1 audit knowledge-extraction + index + template |
| Templates | `core/templates/` | 6+16 | Project templates + [Workflow System] memory bank templates |
| Scripts | `core/scripts/` | 43 | SCRIPTS_INDEX.md lists all with purpose + phase |
| Tools | `core/tools/` | ~160 | GTM debug, [Workflow System], hooks, learning docs |
| Brand | `core/brand/arcanian/` | 8 | Our voice, Target Profile, positioning, identity sentence, content strategy |
| Infrastructure | `core/infrastructure/` | ~55 | BRIEF, SETUP, SLACK, REMOTE, DATA_RULES, IT systems |
| Ref. implementations | `core/reference-implementations/` | 3 | ExampleBrand patterns, [Audit Framework] patterns, dev brief |

## Stats

| Metric | Count |
|---|---|
| Total files | ~5,200 |
| Clients | 12 (+1 pending) |
| Findings across all clients | 85+ |
| Recommendations | 53+ |
| Skills | 5 |
| Agents | 7 |
| SOPs | 12 (target: 100+) |
| Scripts | 43 |
| Known patterns | 35+ (growing) |
