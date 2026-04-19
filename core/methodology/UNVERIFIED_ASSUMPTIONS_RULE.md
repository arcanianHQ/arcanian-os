---
scope: shared
---

# System Guardrail: Unverified Assumptions

> **SYSTEM-WIDE RULE** — applies to ALL skills, agents, SOPs, and diagnostics.
> Learned from: Mancsbazis 2026-03-24 — system assumed "no developer" because none was named. Developer existed. False constraint blocked the entire repair roadmap.

---

## The Rule

**"Not mentioned" ≠ "Doesn't exist."**

When analyzing incomplete information, the system MUST distinguish between:

| Evidence type | What it means | How to rate |
|---|---|---|
| **Stated** | Client explicitly said "we don't have X" | Constraint (verified) |
| **Observed** | We checked and confirmed X is absent | Constraint (verified) |
| **Inferred** | Language/behavior suggests X might be absent | **UNVERIFIED** — must ask |
| **Not mentioned** | X was never discussed | **UNVERIFIED** — must ask |

## The UNVERIFIED Rating

Any constraint, finding, or assumption based on ABSENCE of information gets:

```
Status: UNVERIFIED
Verification question: "{specific question to ask}"
Rating: Cannot be "Hard" or "Critical" until verified
```

An UNVERIFIED constraint:
- CANNOT be rated "Hard" or "BLOCKS ALL"
- CANNOT drive repair roadmap sequencing
- MUST be listed in a separate "Unverified Assumptions" section
- MUST include the verification question
- Becomes "Verified" only after client confirms

## Where This Applies

### Skills (all diagnostic skills)
| Skill | How it applies |
|---|---|
| Constraint mapping | Every resource-absence constraint → UNVERIFIED until client confirms |
| `/7layer` | Layer rated "Constraint" based on missing info → add "(unverified)" |
| Repair planning | Cannot sequence repairs based on UNVERIFIED constraints |
| Identity-pattern work | Inferred beliefs from language → flag as "inferred, not stated" |
| Signal extraction | 3 Constraint Signals — if a signal is inferred, not observed → flag |
| `/build-brand` | Voice assumptions from copy analysis → verify with client |
| Offer refinement | Pricing constraints inferred from behaviour → verify |

### Agents
| Agent | How it applies |
|---|---|
| `audit-checker` | Measurement issues found → distinguish "confirmed broken" vs "couldn't test" |
| `client-explorer` | New client scan → flag what was observed vs what was assumed |
| `knowledge-extractor` | New patterns → only extract VERIFIED patterns, not assumptions |

### SOPs
| SOP | How it applies |
|---|---|
| `arcanian/02-discovery-call.md` | Post-call: list what was NOT discussed (gaps) |
| `arcanian/06-client-intelligence-profile.md` | Each profile file must note verified vs unverified |
| `measurement-audit/06-phase-5-diagnosis.md` | Distinguish "confirmed absent" vs "couldn't access" |

### Client Intelligence Profile (brand/)
Every file in `brand/` should end with:

```markdown
## Unverified Assumptions
| Assumption | Based on | Verification question |
|---|---|---|
| No developer available | Not mentioned in calls | "Do you have a developer? Who?" |
```

## Common False Assumptions

| What we assumed | Why | Reality |
|---|---|---|
| "No developer" | Not named in conversation | Developer exists, just wasn't introduced |
| "No budget" | Price negotiation was hard | Budget exists, just allocated differently |
| "No marketing team" | Owner does everything | Part-time person exists, not mentioned |
| "No CRM" | Not discussed | Uses basic tool (Excel, Google Sheets) |
| "No content strategy" | Website looks empty | Strategy exists, execution is behind |
| "Doesn't understand brand" | Resisted brand terminology | Understands the concept, hates the word |

## Verification Protocol

When a constraint map or diagnostic has UNVERIFIED items:

1. **Before delivery:** Send verification questions to client
2. **In the document:** Mark clearly as UNVERIFIED with the question
3. **In the presentation:** Say "we noticed X wasn't discussed — is this the case?"
4. **After verification:** Update the document, change status to Verified or Removed
5. **Log in CAPTAINS_LOG:** "Verified: developer exists (Dóra confirmed)"

## Hook Enforcement

The post-tool-use hook checks:
- When a CONSTRAINT_MAP.md or 7LAYER_DIAGNOSTIC.md is written
- Scans for constraints without "verified" or "confirmed" evidence
- Flags: "⚠ X constraints appear to be based on absence of information. Run verification."
