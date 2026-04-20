---
scope: shared
created: 2026-04-18
type: methodology rule — public-content guardrail
status: Active — enforced at write, review, and publish time.
purpose: Ensure that no proprietary third-party methodology names, narrative-arc stage names, or int-tagged skill references ever appear in public AOS materials. The guardrail exists because public content will grow and accidental leaks compound.
related:
  - core/tools/hooks/public-content-blocklist.txt (the actual list)
  - core/tools/hooks/check-public-content.sh (the enforcement script)
  - .claude/rules/public-content.md (path-scoped rule loaded in Claude sessions)
  - core/methodology/public-docs/governance/CONTRIBUTING.md (reviewer checklist)
---

# Public Content Guardrail

## The rule

**Nothing that Arcanian does not own the rights to distribute openly may appear in public AOS materials.**

This extends beyond copyright. It covers:

- **Personal names of proprietary-methodology authors** we have studied but do not own (the named list lives in `core/tools/hooks/public-content-blocklist.txt`).
- **Framework names** of copyrighted methodologies we apply internally but do not publish.
- **Narrative-arc stage names** when used in a framework-reference context (ordinary English uses of these words are fine; stage-reference uses are not).
- **Int-tagged skill names** — any skill tagged `int-personal`, `int-company`, or `int-confidential` may not be mentioned by name in any public material.

"Public AOS materials" means anything that leaves Arcanian's internal operations:

- Files in the public repo (`core/methodology/public-docs/**`, future `docs/**`)
- Client-facing deliverables (reports, diagnoses, emails, presentations)
- Marketing content (LinkedIn posts, Substack, newsletter, landing pages)
- Teaching videos and course materials
- Any artefact with `scope: shared` in its frontmatter

## Why the rule matters

**Legal:** Copyrights and trademarks belong to their owners. Naming a proprietary framework in a public derivative work can constitute infringement or trademark dilution even when the reference is meant as acknowledgment.

**Positioning:** Every named influence in Arcanian's public materials weakens the claim that AOS is Arcanian's own work. The open methodology (7+1 Layers, 7 Habits, 6 Components, rituals spec) is genuinely original; naming ancestors dilutes that claim and invites comparison rather than adoption.

**Practitioner discipline:** The rule matches standard consulting hygiene. Top-tier firms do not cite academic sources in client deliverables; they reframe the thinking as house IP. Arcanian applies the same discipline.

**Compounding risk:** One accidental reference in one document is recoverable. Ten references across fifty documents as public content grows is not. The guardrail is cheaper to enforce from day one than to retrofit at scale.

## What to do when you encounter a prohibited term

### In your own writing (before commit)

1. Run `core/tools/hooks/check-public-content.sh {path}` against the file or directory you are about to commit.
2. If violations appear, rewrite the prose to express the same insight in Arcanian's own vocabulary — never by citing the source.
3. Re-run the script. Commit only when clean.

### In a reviewer role

The guardrail is a blocking review gate. A PR with any prohibited term — even an acknowledged, attributed one — is rejected until rewritten. No exceptions for "well-meaning attribution."

### If you genuinely need to reference a proprietary methodology

Do so only in internal documents (`scope: int-*`). Example:

- `internal/strategy/` — where the decision log lives
- `core/skills/` files tagged `scope: int-personal` or `int-company`
- `clients/{slug}/` — engagement-internal notes

The reference never crosses into the public repo, public teaching material, or client-facing deliverable.

## Extending the blocklist

When Arcanian adds a new proprietary methodology to its internal toolkit:

1. Add the author name(s), framework name(s), and any distinctive phrasings to `core/tools/hooks/public-content-blocklist.txt`.
2. Add the new skill name(s) (if any) to the same blocklist.
3. Update this rule document's *examples* section to include the new entry.
4. Run the script against the full public-docs directory to catch any existing leaks.
5. Log the blocklist update in `CAPTAINS_LOG.md`.

The blocklist is a **living file** — maintained as Arcanian's proprietary toolkit grows. Every addition is versioned in git history, so the blocklist's evolution is itself inspectable.

## Narrative-arc stage names — soft rule

The six stage names **Situation, Challenge, Desire, Decision, Breakthrough, Epiphany** are common English words. The script cannot reliably distinguish "Decision stage" (framework reference, prohibited) from "the team made a decision" (ordinary English, fine).

**Rule of thumb:** if the word is capitalised as a stage label, or if the six appear together in sequence (even partially), rewrite. Otherwise use the word naturally. The reviewer catches this; the script does not.

## Related enforcement

- **Shell script:** `core/tools/hooks/check-public-content.sh` — run manually or wire into pre-commit.
- **Path-scoped Claude rule:** `.claude/rules/public-content.md` — loads automatically when editing any file matching public-docs or shared-scope patterns, so the rule is salient in every Claude session.
- **Reviewer checklist:** `core/methodology/public-docs/governance/CONTRIBUTING.md` includes a guardrail-check line in the review standard.

## Precedent

This rule is consistent with how large open-source projects handle upstream IP:

- Kubernetes does not cite individual research papers in public docs; it cites specifications.
- Linux kernel documentation references POSIX as a spec, not Unix as a trademark.
- Wikipedia's neutral-point-of-view policy requires describing frameworks without endorsing or promoting them.

Arcanian's public content does the same: describe the work, not the lineage.
