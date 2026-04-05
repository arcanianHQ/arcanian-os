> v1.0 — 2026-04-05

# Arcanian OS — Changelog

All notable changes to the public repository.

---

## [1.2.0] — 2026-04-05

### Fixed
- **DATABOX_SETUP.md** — Removed incorrect npx/API token configuration. Databox MCP is a remote HTTP server authenticated via `/mcp` OAuth, not an npm package with an env token.
- **GETTING_STARTED.md** — Updated MCP connection table to reflect OAuth flow instead of API token.

### Added
- CHANGELOG.md — this file

---

## [1.1.0] — 2026-04-04

### Changed
- **CLAUDE.md** — Reframed as go-to-market diagnostic system
- **README.md** — Updated skill/agent counts
- **/os page** hero copy — GTM language, "View on GitHub" + "Getting Started Guide" buttons
- **DOMAIN_CHANNEL_MAP_TEMPLATE.md** — Added Business Units section as standard

### Added
- GTM Gap Analysis card in "What's inside"
- Roadmap section ("What's next") with Shipped / In progress / Coming next / Exploring
- GitHub link on /os page (repo went public)
- Partner signup link for Databox trials
- "Connect your data" section with Databox signup

---

## [1.0.0] — 2026-04-03

### Initial release
- 160 markdown files
- 37 skills, 14 agents, 4 council configs, 20+ SOPs
- 30+ methodology files (confidence engine, currency normalization, attribution windows, alarm calibration, recommendation tracking, domain isolation, evidence classification, data reliability)
- 28 templates (baselines, recommendation log, monitor log, dashboard, domain channel map, client config)
- 3 example clients (SaaS, multi-domain e-commerce, local services)
- docs/GETTING_STARTED.md + docs/DATABOX_SETUP.md
- .mcp.json.example for Databox connection
- MIT license
