---
scope: shared
---

# /mckinsey-deck — McKinsey-Style Presentation Outline Generator

> Applies the 5 McKinsey structural rules to generate a strategy deck outline that reads correctly even without a presenter.
> A deck that only works when you're presenting is not a deck — it's a crutch.

## When to Use

- Client strategy presentations
- Board/investor decks
- Pitch decks (Deel, partnerships)
- Quarterly review / diagnostic delivery
- Any deck where the audience may read it BEFORE or WITHOUT you

## Input

| Parameter | Required | Description |
|-----------|----------|-------------|
| `brief` | Yes | What the presentation is about — context, audience, goal |
| `client` | No | Client slug — loads brand intelligence, tone, glossary |
| `audience` | No | Who reads this — CEO, board, marketing team, investor |
| `slides` | No | Target slide count (default: 10-15) |
| `language` | No | HU / EN (default: EN) |

## The Five Rules

### Rule 1: Pyramid Principle (Minto)

**The answer goes FIRST. Proof comes after.**

```
WRONG:                          RIGHT:
Slide 1: Market overview        Slide 1: We recommend entering DE market in Q3
Slide 2: Competitor analysis    Slide 2: Market is 3x larger than current
Slide 3: Our capabilities       Slide 3: Only 2 competitors serve this segment
Slide 4: Maybe we should...     Slide 4: We have the team and the product
Slide 5: Recommendation         Slide 5: Implementation timeline
```

Every section follows the same pattern: conclusion → supporting arguments → evidence.

**Test:** Can the CEO read slide 1 and know the recommendation? If not, restructure.

### Rule 2: SCQA (Situation → Complication → Question → Answer)

The narrative arc that makes every deck persuasive:

| Element | What it does | Example |
|---------|-------------|---------|
| **Situation** | What everyone agrees on | "We've grown 40% YoY for 3 years" |
| **Complication** | What changed or threatens | "But CAC doubled while LTV stayed flat" |
| **Question** | The strategic question this creates | "How do we restore unit economics without killing growth?" |
| **Answer** | Your recommendation (= Pyramid top) | "Shift 30% of paid budget to owned channels + raise prices 15%" |

SCQA appears at TWO levels:
1. **Deck-level:** slides 1-4 establish the full SCQA arc
2. **Section-level:** each major section can have its own mini-SCQA

**Test:** Remove the Answer. Does the Complication make the audience NEED to hear it?

### Rule 3: Action Titles

**Every slide heading is a complete sentence that states a thesis.**

```
WRONG:                              RIGHT:
"Market Overview"                   "The DE market is 3x our current TAM"
"Customer Segments"                 "Enterprise buyers convert 4x better than SMB"
"Financial Projections"             "We reach profitability in Q3 2027 at current growth"
"Next Steps"                        "Three actions in 90 days unlock the next phase"
```

**The Title Staircase Test:** Read ONLY the slide titles top to bottom. They should tell the complete story without seeing any slide content.

If you can't read titles alone and understand the argument → the deck fails.

### Rule 4: MECE (Mutually Exclusive, Collectively Exhaustive)

Every breakdown, every list, every analysis must be:
- **Mutually Exclusive:** no slide/point overlaps with another
- **Collectively Exhaustive:** no logical gap — nothing important is missing

```
NOT MECE:                           MECE:
- Marketing                         - Demand generation (awareness → lead)
- Social media ← overlaps           - Demand capture (lead → customer)
- Growth ← vague                    - Demand expansion (customer → advocate)
- Brand ← overlaps
```

**Test:** Can any point be deleted because another already covers it? → Not ME.
Could someone ask "but what about X?" and it's not covered? → Not CE.

### Rule 5: One Message Per Slide

Each slide makes exactly ONE point. That point is stated in the action title.

Everything on the slide (chart, bullet, image, table) exists ONLY to prove the title.

If a slide needs two charts that make different points → it's two slides.

**Test:** Cover the title. Can you guess it from the content? If the content could support multiple titles → the slide is unfocused.

## Execution Steps

### Step 1: Load Context

If `client` specified:
- Load `brand/BRAND_IDENTITY.md` (positioning, voice)
- Load `brand/CONSTRAINT_MAP.md` (what limits them)
- Load `PROJECT_GLOSSARY.md` (terminology, banned words)
- Load `CONTACTS.md` → resolve audience names, tone (tegező/magázó)

### Step 2: Extract SCQA from Brief

From the user's brief, identify:
- **S:** What's the agreed-upon starting point?
- **C:** What changed, threatens, or creates tension?
- **Q:** What strategic question does this raise?
- **A:** What's the recommendation? (This becomes slide 1's title)

If the brief doesn't contain a clear recommendation → ask. A deck without an answer is a report.

### Step 3: Build the Pyramid

1. **Top of pyramid** = The Answer (1 sentence)
2. **Level 2** = 3-5 supporting arguments (each becomes a section)
3. **Level 3** = Evidence per argument (each becomes a slide)

Map this to slides:

| Slide | Role | SCQA Element | Content |
|-------|------|-------------|---------|
| 1 | **Executive Summary** | Answer | Recommendation + 3 key reasons |
| 2 | Context | Situation | What everyone agrees on |
| 3 | The Problem | Complication | What changed / threatens |
| 4 | The Question | Question | Framed as strategic choice |
| 5-7 | Argument 1 | Supporting proof | Data, analysis, evidence |
| 8-10 | Argument 2 | Supporting proof | Data, analysis, evidence |
| 11-12 | Argument 3 | Supporting proof | Data, analysis, evidence |
| 13 | Implementation | How | Timeline, owners, milestones |
| 14 | Risks & Mitigations | What could go wrong | Top 3 risks + response |
| 15 | Ask / Next Steps | Action | What you need from the audience |

### Step 4: Write Action Titles

For each slide, write the title as a complete thesis sentence.

Then run the **Title Staircase Test**: read all titles in sequence. Do they tell the full story?

### Step 5: MECE Check

For each section:
- Are the slides mutually exclusive? (no overlap)
- Are they collectively exhaustive? (no gap)
- Could a skeptical reader say "but what about..."?

### Step 6: One-Message Audit

For each slide:
- State the ONE message in the title
- List what evidence/visual supports it
- If evidence could support a different title → refocus or split

### Step 7: Generate Output

Output format:

```markdown
# {Presentation Title}

## SCQA Arc
- **Situation:** {one sentence}
- **Complication:** {one sentence}
- **Question:** {one sentence}
- **Answer:** {one sentence — this IS slide 1}

## Title Staircase (read this alone — it should tell the full story)
1. {Slide 1 action title}
2. {Slide 2 action title}
...

## Slide-by-Slide Outline

### Slide 1: {Action Title}
**Role:** Executive Summary
**Message:** {the one point}
**Content:** {bullets, chart suggestion, key data}
**Speaker notes:** {what to say if presenting}

### Slide 2: {Action Title}
...

## MECE Verification
| Section | ME Check | CE Check | Gap? |
|---------|----------|----------|------|
| ... | ✓/✗ | ✓/✗ | {what's missing} |

## Pyramid Structure
{Visual of the argument hierarchy}
```

### Step 8: Save & Open

Auto-save to correct location:
- Client deck: `clients/{slug}/docs/presentations/YYYY-MM-DD_{topic}.md`
- Internal: `internal/pitches/YYYY-MM-DD_{topic}.md`
- Open in Typora: `open -a Typora "{path}"`

## Quality Checks

Before delivering:

- [ ] **Pyramid:** Slide 1 = the answer. Can skip to it and know the recommendation.
- [ ] **SCQA:** Complication creates tension. The audience NEEDS the answer.
- [ ] **Action titles:** Title staircase reads as a complete narrative.
- [ ] **MECE:** No overlap between slides. No logical gap.
- [ ] **One message:** Each slide proves exactly one point.
- [ ] **Glossary:** No banned terms (load PROJECT_GLOSSARY.md).
- [ ] **Tone:** Matches audience (tegező/magázó, HU/EN, formality level).
- [ ] **Discovery, not pronouncement:** Ends with "What did we miss?" if diagnostic.

## Hungarian Adaptation

For HU presentations:
- Action titles in Hungarian (complete mondatok, nem csak címkék)
- SCQA terminology: Helyzet → Bonyodalom → Kérdés → Válasz
- Tegező/magázó per audience (check CONTACTS.md)
- Number formatting: 1 000 000 Ft (not 1,000,000)
- "Kérdezz bátran" at the end if client-facing

## Anti-Patterns

| Don't | Do |
|-------|-----|
| "Overview of..." titles | Complete thesis sentences |
| Recommendation on the last slide | Recommendation on slide 1 |
| "Let me walk you through..." narrative | Self-reading document |
| 40 slides for a 30-min meeting | 10-15 slides, each earns its place |
| Charts without so-what annotation | Every chart has a takeaway callout |
| "Any questions?" ending | "Here's what we need from you" ending |

---

*"A good deck is an argument, not a tour." — Barbara Minto*
