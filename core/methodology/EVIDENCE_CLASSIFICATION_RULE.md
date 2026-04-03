# System Guardrail: Evidence Classification

> **SYSTEM-WIDE RULE** — applies to ALL data analysis, OODA, ACH, and causal reasoning.
> Learned from: ExampleD2C Session Drop Analysis 2026-03-31 — hearsay was treated as verified fact. A narrative repeated across 5 documents became "evidence" in an ACH table. Timeline didn't even match.
> "A story told five times doesn't become data."

---

## The Problem

The existing guardrails handle:
- **Discovery Not Pronouncement** — how to present (posture)
- **Unverified Assumptions** — what's missing (gaps)
- **Data Reliability Framework** — source system quality (GA4 vs manual)

**None of them handle:** the difference between a number from a system and a story from a conversation.

When an analysis mixes system data with narratives, meeting notes, and "someone once said," the result looks rigorous (tables, ACH, confidence ratings) but the foundation is sand.

**The ExampleD2C failure:**
- GA4 sessions data → HIGH confidence ✓
- "Benji caused the drop" → **narrative from meetings, not measured** → treated as CC (Consistently Consistent) in ACH
- "Criteo 9.4x ROAS" → **number from unknown source, never verified** → treated as fact
- "[Agency A] switched to lead forms" → **inferred from current state, not timestamped** → treated as causal explanation
- Timeline didn't match: drop started Feb 1, Benji left Feb 23. **Nobody checked.**

---

## The Rule

Every piece of evidence used in an analysis MUST be classified:

| Class | Definition | Can it be used as... | Marker |
|-------|-----------|---------------------|--------|
| **DATA** | Number from a system (GA4, Databox, CRM, platform API) with timestamp and source ID | Fact, ACH evidence (CC/C/N/I) | `[DATA: source, date]` |
| **OBSERVED** | Directly verified by us (Chrome DevTools, login, screenshot, audit) | Fact, ACH evidence | `[OBSERVED: method, date]` |
| **STATED** | Client explicitly said this, with date and who said it | Claim to verify, not fact | `[STATED: who, when, context]` |
| **NARRATIVE** | Repeated story across documents, meetings, conversations — NOT independently verified | Context only — CANNOT be ACH evidence | `[NARRATIVE: source files]` |
| **INFERRED** | We concluded this from other data or patterns | Hypothesis only — CANNOT be scored CC | `[INFERRED: from what]` |
| **HEARSAY** | Someone told us someone else said/did something | Context only — CANNOT drive decisions | `[HEARSAY: who said, about whom]` |

---

## Application Rules

### 1. ACH Evidence Column
Every row in an ACH table MUST be classified. Only **DATA** and **OBSERVED** items can receive CC (Consistently Consistent) scores.

```markdown
❌ Bad ACH:
| Benji távozása | CC | — the "evidence" is a narrative, not data

✓ Good ACH:
| facebook/cpc sessions -49% Jan→Feb [DATA: GA4 Databox, 2026-03-31] | CC |
| Benji left Feb 23 [STATED: HR, 2026-02-23] — but drop started Feb 1 [DATA] | I (inconsistent!) |
```

### 2. BLUF Confidence
A BLUF confidence rating CANNOT be HIGH if the causal explanation relies on NARRATIVE, STATED, or INFERRED evidence.

```markdown
❌ [Confidence: HIGH — GA4 source/medium bontás + Criteo spend data + timeline egyezés Benji departure-rel]
— the GA4 data is HIGH, but "timeline egyezés Benji departure-rel" is INFERRED and actually WRONG

✓ [Confidence: HIGH for session data, LOW for causal attribution — causes are hypotheses, not verified]
```

### 3. Causal Claims
Any statement of the form "X caused Y" or "the drop is because of X" MUST include:

1. **The evidence class** — is this DATA, OBSERVED, or NARRATIVE?
2. **The temporal test** — did X actually happen BEFORE Y?
3. **The counterfactual** — could Y have happened without X?

```markdown
❌ "A csökkenés oka: Benji távozása + Meta kampánytípus változás + Criteo leállás"
— presented as conclusion, no evidence classification, no temporal check

✓ "Három lehetséges ok (mind UNVERIFIED):
   1. Meta kampány típus változás — [INFERRED: current state is lead form, but start date unknown]
   2. Criteo leállás — [DATA: €0 spend from Feb, Databox] — but WHEN in Feb? Before or after session drop?
   3. Coordination gap — [NARRATIVE: attributed to Benji departure, but timeline doesn't match]"
```

### 4. The Repetition Trap
**A claim repeated across 5 documents is NOT stronger evidence.** It's the same claim echoing.

When you find the same explanation in CAPTAINS_LOG, meeting notes, emails, and task descriptions — this means the narrative has been accepted, not that it's been verified.

**Before using a narrative as evidence, ask:**
- Where did this story ORIGINATE? (First mention)
- Was it ever independently verified with data?
- Is the timeline consistent with the data?
- Could the story be wrong and the data still make sense?

### 5. The Timeline Test
Before any causal claim, plot both events on a timeline:

```markdown
❌ "Benji távozott → sessions dropped"
Timeline check: Drop started Feb 1. Benji left Feb 23.
→ The effect preceded the supposed cause by 22 days.
→ Causal claim FAILS timeline test.
```

---

## OODA Integration

### Observe
ONLY DATA and OBSERVED items. No narratives, no inferences.

### Orient
This is where STATED, NARRATIVE, and INFERRED items belong — as hypotheses to test, not facts to build on. Each must be classified.

### Decide
Decisions CANNOT be based on NARRATIVE or HEARSAY evidence. If the only evidence for a recommendation is narrative, the recommendation must be: "verify first, then decide."

### Act
Action items must distinguish:
- Actions based on DATA → execute
- Actions based on NARRATIVE → verify first, then execute

---

## ACH Integration

| Scoring rule | When to use |
|-------------|-------------|
| **CC** (Consistently Consistent) | ONLY for DATA and OBSERVED evidence |
| **C** (Consistent) | DATA, OBSERVED, or STATED (with caveat) |
| **N** (Neutral) | Any class |
| **I** (Inconsistent) | Any class — but if DATA contradicts NARRATIVE, DATA wins |

**If a hypothesis is supported ONLY by NARRATIVE evidence, it cannot be the leading hypothesis.** It's a story to test, not a conclusion.

---

## Hook Enforcement

Post-tool-use check when writing analysis files:
- Scan for causal language ("caused by", "because of", "due to", "the reason is", "oka:", "miatt")
- Check if evidence is classified (DATA/OBSERVED/STATED/NARRATIVE/INFERRED/HEARSAY)
- Flag: "⚠ Causal claim without evidence classification. What class is this evidence?"
- Check ACH tables for CC scores on non-DATA evidence
- Flag: "⚠ CC score on unverified evidence. Only DATA and OBSERVED items can be CC."

---

## The Test

Before delivering ANY analysis:

1. **Strip out all NARRATIVE and HEARSAY.** Does the analysis still hold? If not, the analysis is built on stories, not data.
2. **Check the timeline.** Does the supposed cause actually precede the effect?
3. **Check for the Repetition Trap.** Is a claim treated as strong because it appears in many documents, or because it's independently verified?
4. **Split the confidence.** Data confidence and causal confidence are different things. "Sessions dropped 38% [HIGH]" and "because Benji left [LOW]" are two separate statements with two separate confidence levels.

**"A story told five times doesn't become data. A correlation plotted on a chart doesn't become causation. A narrative that feels right doesn't become verified."**
