# Arcanian Ops — Risk Register

> Cross-project risks and mitigations. Learned from [Workflow System] patterns + operational experience.
> Per-client risks go in client CAPTAINS_LOG. This is for SYSTEMIC risks.

---

## Active Risks

### R1: Single point of failure — [Owner]
- **Impact:** Critical — if [Owner] is unavailable, all client work stops
- **Likelihood:** Medium (illness, travel, overload)
- **Mitigation:** [Team Member 1] and [Team Member 2] trained on /tasks + /preflight. SOPs documented. Brand intelligence profiles enable handoff. Skills encode methodology.
- **Status:** Partially mitigated (team can run diagnostics, not yet strategy)
- **Layer:** L1

### R2: Client data in Git
- **Impact:** Critical — compliance violation, NDA breach
- **Likelihood:** Low (pre-commit hooks + GitHub push protection)
- **Mitigation:** Pre-commit PII hook, GitHub secret scanning, DATA_RULES.md training, .gitignore enforced
- **Status:** Mitigated (hooks installed, but need quarterly audit)
- **Layer:** L1

### R3: MCP token expiry
- **Impact:** High — sync stops, reports fail, morning brief blind
- **Likelihood:** Medium (tokens expire, OAuth refreshes fail)
- **Mitigation:** /health-check skill runs daily. #ops-alerts on failure. Token rotation quarterly.
- **Status:** Planned (health-check not built yet)
- **Layer:** L1

### R4: Knowledge stays in conversations, not in files
- **Impact:** High — insights lost when session ends
- **Likelihood:** High (natural tendency)
- **Mitigation:** CAPTAINS_LOG discipline. Mandatory knowledge extraction after audits. /preflight shows last log entry.
- **Status:** Partially mitigated (extraction task pre-populated, but discipline needed)
- **Layer:** L1

### R5: Scope creep across clients
- **Impact:** Medium — quality drops, deadlines missed
- **Likelihood:** High (10 clients, 1 person)
- **Mitigation:** TASKS.md with P0-P3 prioritization. /morning-brief surfaces P0s. Quick-wins view focuses effort.
- **Status:** Mitigated (task system live)
- **Layer:** L1

### R6: Skills drift from methodology
- **Impact:** Medium — skills give outdated advice
- **Likelihood:** Low-Medium (methodology evolves, skills don't auto-update)
- **Mitigation:** Skills in core/ (protected). Update skills when methodology changes. Version tracking.
- **Status:** Open (no automated drift detection)
- **Layer:** L1

### R7: dedicated server failure
- **Impact:** High — all sessions lost
- **Likelihood:** Low (hardware is reliable)
- **Mitigation:** UPS battery backup (planned). GitHub has all files. claude.ai/code as fallback. Caffeinate prevents sleep.
- **Status:** Partially mitigated (no UPS yet)
- **Layer:** L1

### R8: Stale @waiting tasks
- **Impact:** Medium — things fall through cracks
- **Likelihood:** High (waiting on external people)
- **Mitigation:** /morning-brief flags >7 day @waiting. Dashboard widget.
- **Status:** Planned (morning brief not built yet)
- **Layer:** L1

---

## Risk Review Cadence

Monthly — append new risks, update status, close resolved ones.
Log changes in CAPTAINS_LOG.md.
