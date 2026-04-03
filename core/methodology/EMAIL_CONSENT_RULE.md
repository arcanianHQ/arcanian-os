> v1.0 — 2026-03-24

# System Guardrail: Email Consent Verification

> **SYSTEM-WIDE RULE** — applies to ALL email-related tasks, proposals, and roadmaps.
> Learned from: ExampleLocal 2026-03-24 — [Team Member 1] flagged "2,114 emails — ezeknek mind van marketing consentjük?"
> The system proposed emailing 2,114 addresses without verifying consent. GDPR violation risk.

---

## The Rule

**Before ANY email campaign or automation is planned, verify:**

1. **Marketing consent exists** — does every email address have explicit opt-in for marketing?
2. **Consent is documented** — where is the consent record? (CRM field, checkbox, double opt-in?)
3. **Consent is current** — when was consent given? (> 2 years may need re-consent)
4. **Consent scope matches** — did they consent to THIS type of email? (newsletter ≠ promotional ≠ transactional)

## What Needs Verification

| Email type | Consent needed? | GDPR basis |
|---|---|---|
| **Abandoned cart recovery** | Debated — legitimate interest MAY apply | Art. 6(1)(f) — but risky |
| **Marketing blast to list** | YES — explicit consent required | Art. 6(1)(a) |
| **Transactional (order confirmation)** | NO — contract performance | Art. 6(1)(b) |
| **Re-engagement (dormant list)** | YES — original consent must still be valid | Art. 6(1)(a) |
| **Newsletter** | YES — explicit opt-in | Art. 6(1)(a) |

## In Proposals / Ajánlatok

When a proposal includes email campaigns:
- State the list size
- State: "marketing consent verified: YES / NO / TO BE VERIFIED"
- If not verified: "First step: verify consent status of {N} addresses"
- Show calculations with REALISTIC conversion rates (not optimistic only)
- Show pessimistic / realistic / optimistic scenarios

## In Roadmaps

Email activation tasks MUST include:
```markdown
- [ ] Verify email consent for {N} addresses
  - @next
  - P0 | Impact: hygiene (compliance)
  - GDPR: marketing consent must be confirmed before ANY send
  - Check: CRM consent field, opt-in records, consent date
```

This task is P0 and MUST come BEFORE any email send task.

## Connection to Discovery Not Pronouncement

When presenting email campaign projections:
```
❌ "Az első email kampány profitja fedezi az árát" (one scenario, no verification)
✓ "Ha a 2,114 címből mind rendelkezik marketing hozzájárulással (ellenőrizni kell!),
   és ha a megnyitási arány 25-40% között van (nem tudjuk még), akkor:
   - Pesszimista: 3-5 rendelés (~50-85K bevétel)
   - Reális: 15-25 rendelés (~255-425K bevétel)
   - Optimista: 40-60 rendelés (~680K-1M bevétel)
   Első lépés: ellenőrizzük a hozzájárulásokat."
```
