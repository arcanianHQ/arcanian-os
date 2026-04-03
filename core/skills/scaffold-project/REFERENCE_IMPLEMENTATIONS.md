> v1.0 — 2026-04-03

# Scaffold — Reference Implementations

> Context for why the scaffold is structured this way. Load when you need to understand the reasoning, not during normal scaffolding.

## Gold Standards

### ExampleBrand (Client — all L0-L7 layers)
Full documentation: `../../reference-implementations/EXAMPLE_PATTERNS.md`

**Why it's the reference:** 944 files, only project touching all layers, most mature processes (21 SOPs), full audit coverage, 6 agencies, working Asana sync.

**Key patterns to replicate:**
- `processes/00-09` core + `10-18` quick wins + `19-21` dashboards
- `audit/ac/00-09` numbered sections + `AUDIT-REPORT.md` consolidated
- `takeover/correspondence/` with `{recipient}-{topic}-{status}.md` naming
- `agencies/{name}/` per-agency folders
- `newsletter/` with `MMDD-topic-market.html` naming

### [Audit Framework] (Diagnostic work — FND→REC→Task chain)
Full documentation: `../../reference-implementations/MEASUREMENT_AUDIT_PATTERNS.md`

**Why it's the reference:** The FND→REC→Task ontology chain that inspired the entire task system. Phase-gated methodology. 35+ known patterns. Evidence-based findings.

**Key patterns to replicate:**
- `findings/FND-NNN_slug.md` with frontmatter (severity, phase, layer, status)
- `recommendations/REC-NNN_slug.md` with implementation steps
- `audits/YYYY-MM-DD_name/phase0-5/` structure
- `CLIENT_CONFIG.md` + `ACCESS_REGISTRY.md`
- Session handoff pattern in CAPTAINS_LOG
- Knowledge extraction after every Phase 5

## Knowledge Flow
Every audit feeds the hub. The extraction task (#11 in AUDIT_TASKS.md) is MANDATORY.

Cycle: Client audit → Findings (client) → Patterns extracted (core) → Next client benefits.

Current: 35+ patterns. Growing ~3-5 per client. By client #10: Phase 0-1 auto-catches 80%+.
