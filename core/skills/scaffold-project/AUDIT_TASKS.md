# Scaffold — Pre-Populated Audit Tasks

> Added to TASKS.md when `project_type == audit`. These are starter tasks for the full Phase 0-5 audit + mandatory knowledge extraction.

---

## Tasks to Add (after #1 setup + #2 intelligence profile)

```markdown
- [ ] #3 Fill CLIENT_CONFIG.md with tracking IDs
  - @next @computer
  - P1 | Owner: {owner} | Effort: 30m | Impact: hygiene
  - Created: {today} | Updated: {today}
  - Layer: L7
  - SOP: [audit-framework]/01-phase-0-cli-baseline

- [ ] #4 Export GTM containers (Web + SGTM)
  - @next @computer
  - P1 | Owner: {owner} | Effort: 15m | Impact: hygiene
  - Created: {today} | Updated: {today}
  - Layer: L7
  - SOP: [audit-framework]/04-phase-3-container

- [ ] #5 Run Phase 0 — CLI baseline
  - @next @computer
  - P1 | Owner: {owner} | Effort: 2h | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L5, L7
  - SOP: [audit-framework]/01-phase-0-cli-baseline
  - SGTM health, feeds, structured data, robots.txt

- [ ] #6 Run Phase 1 — Browser verification
  - @next @computer
  - P1 | Owner: {owner} | Effort: 4h | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L5, L7
  - SOP: [audit-framework]/02-phase-1-browser
  - Consent, dataLayer, tracking inventory, JS errors

- [ ] #7 Run Phase 2 — Dashboard audit
  - @waiting
  - P2 | Owner: {owner} | Effort: 4h | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L7
  - SOP: [audit-framework]/03-phase-2-dashboards
  - Requires platform logins. Depends on: #3 CLIENT_CONFIG

- [ ] #8 Run Phase 3 — Container audit
  - @next @computer
  - P1 | Owner: {owner} | Effort: 4h | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L5
  - SOP: [audit-framework]/04-phase-3-container
  - Depends on: #4 GTM exports

- [ ] #9 Run Phase 4 — Cross-verification
  - @waiting
  - P2 | Owner: {owner} | Effort: 1d | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L5, L7
  - SOP: [audit-framework]/05-phase-4-cross-verify
  - 10-product end-to-end trace. Depends on: Phases 1-3

- [ ] #10 Run Phase 5 — Diagnosis
  - @waiting
  - P2 | Owner: {owner} | Effort: 4h | Impact: breakthrough
  - Created: {today} | Updated: {today}
  - Layer: L7
  - SOP: [audit-framework]/06-phase-5-diagnosis
  - Pattern matching vs KNOWN_PATTERNS, root causes, action playbooks. Depends on: Phase 4

- [ ] #11 Extract learnings to hub methodology
  - @waiting
  - P1 | Owner: {owner} | Effort: 1h | Impact: lever
  - Created: {today} | Updated: {today}
  - Layer: L7
  - SOP: [audit-framework]/07-knowledge-extraction
  - MANDATORY after Phase 5. Depends on: #10
  - Checklist:
    - [ ] New patterns → core/methodology/KNOWN_PATTERNS.md
    - [ ] Platform behaviors → core/methodology/PLATFORM_REFERENCE.md
    - [ ] Reusable scripts → core/scripts/
    - [ ] SOP improvements → core/sops/ + SOP_CHANGELOG.md
    - [ ] Update audit skill if needed → core/skills/audit.md
```
