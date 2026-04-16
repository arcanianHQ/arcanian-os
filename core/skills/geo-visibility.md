---
scope: shared
argument-hint: client slug or brand name
---

# Skill: AI Visibility & Brand Perception Check (`/geo-visibility`)

> v1.0 — 2026-04-14

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-04-14`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Track how a brand appears (or doesn't appear) in AI-generated responses across ChatGPT, Perplexity, Google AI Overviews, and Gemini. Identifies which queries surface the brand, which competitors get cited instead, and what content gaps prevent AI citation.

AI platforms now drive a growing share of discovery (ChatGPT: 180M+ MAU, Perplexity: 10M MAU, 79% of consumers expected to use AI search). Brands that aren't tracked in AI responses are flying blind.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`.

## Trigger

Use this skill when:
- Client asks "does ChatGPT / Perplexity recommend us?"
- Onboarding a new client — baseline AI visibility
- Quarterly GEO review
- Competitor launched aggressive content and may be stealing AI citations
- After `/geo-audit` reveals gaps — check current AI presence before optimizing
- Client reports "people say they found us through AI" — validate and expand

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Brand name(s) | Yes | brand/ directory or user |
| Target domain(s) | Yes | DOMAIN_CHANNEL_MAP.md or user |
| Top 15-25 target queries | Yes | GSC top queries, user input, or `/seo-gaps` output |
| Competitor brand names | Recommended | brand/COMPETITIVE_LANDSCAPE.md |
| Semrush organic data | Optional | Semrush MCP (SERP Features filter: AI Overview) |

## AI Platforms to Check

| Platform | How to Check | Evidence Type |
|----------|-------------|--------------|
| **Google AI Overviews** | Semrush SERP Features (AI Overview filter) + manual Google search | [DATA] for Semrush, [OBSERVED] for manual |
| **ChatGPT** | Query ChatGPT with target queries, record if brand is mentioned | [OBSERVED] — responses vary by session |
| **Perplexity** | Query Perplexity, check cited sources | [OBSERVED] — sources are linked |
| **Gemini** | Query Gemini with target queries | [OBSERVED] — responses vary |

**Important caveats:**
- AI responses are non-deterministic — the same query may produce different results
- Results are personalized and may vary by user/location/session
- Manual checks are snapshots, not stable rankings
- Tag ALL manual checks as `[OBSERVED]` with date/time

## Execution Steps

1. **Build query list** — Select 15-25 queries that matter most for the brand:
   - Top GSC queries by impressions (what people already search)
   - Core product/service queries (what the brand wants to be found for)
   - Conversational/long-tail variants (how people ask AI — "what is the best X for Y?")
   - Brand queries ("what is [brand]?", "[brand] reviews", "[brand] vs [competitor]")

2. **Semrush AI Overview scan** (if available):
   - Pull Organic Research > SERP Features > filter "AI Overview"
   - For each query with AI Overview: check if client domain appears in cited sources
   - Record: query, AI Overview present (Y/N), client cited (Y/N), competitors cited
   - Tag all as `[DATA]`

3. **Manual AI platform probing** — For the top 10 priority queries, manually check:
   - Google (AI Overview): search the query, record AI Overview content and cited sources
   - ChatGPT: ask the query, record if brand is mentioned, in what context, and what competitors appear
   - Perplexity: ask the query, record cited sources (Perplexity shows source links)
   - Tag all as `[OBSERVED]` with timestamp

4. **Brand perception analysis** — For brand-name queries ("what is [brand]?"), check:
   - How AI describes the brand (accurate? positive? outdated?)
   - What attributes AI associates with the brand
   - Whether competitors appear in brand queries (reputation leak)
   - Sentiment: positive / neutral / negative / inaccurate

5. **Competitor citation comparison** — Identify:
   - Which competitors appear most frequently across AI responses
   - For which query types competitors get cited (informational, transactional, comparison)
   - What content formats competitors use that get cited (lists, data tables, FAQs)

6. **Gap identification** — Cross-reference:
   - Queries where client ranks in Google top 10 BUT is NOT cited in AI responses
   - Queries where competitors ARE cited but client is NOT
   - Brand queries where AI information is inaccurate or outdated

7. **Score and prioritize** — Compute AI Visibility Rate = (queries where brand cited / total queries checked) x 100

## Output Template

```markdown
# AI Visibility & Brand Perception — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: AI visibility rate, biggest gap, most cited competitor, top action}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| Semrush AI Overview | HIGH/MED/LOW / NOT AVAILABLE | {issues} |
| ChatGPT manual check | LOW (non-deterministic) | Snapshot only, {date} |
| Perplexity manual check | MED (shows sources) | Snapshot only, {date} |
| Google AI Overview manual | MED | Varies by location/user, {date} |

## AI Visibility Summary

**AI Visibility Rate: {N}%** ({N} of {N} queries checked)

| Platform | Queries Checked | Brand Cited | Visibility Rate |
|----------|----------------|-------------|----------------|
| Google AI Overviews | | | |
| ChatGPT | | | |
| Perplexity | | | |
| Gemini | | | |

## Query-Level Results
| Query | Type | Google AIO | ChatGPT | Perplexity | Competitors Cited | Gap |
|-------|------|-----------|---------|-----------|-------------------|-----|
| | Info/Trans/Nav | Cited/Not/N/A | Yes/No | Yes/No | {names} | |

## Brand Perception in AI
| Platform | Description Accuracy | Sentiment | Key Associations | Issues |
|----------|---------------------|-----------|-----------------|--------|
| ChatGPT | Accurate/Outdated/Wrong | Pos/Neu/Neg | | |
| Perplexity | Accurate/Outdated/Wrong | Pos/Neu/Neg | | |
| Gemini | Accurate/Outdated/Wrong | Pos/Neu/Neg | | |

{Flag any inaccurate AI descriptions that need content correction}

## Competitor Citation Analysis
| Competitor | Times Cited | Platforms | Query Types | Content Format |
|-----------|------------|-----------|-------------|---------------|
| | | | | |

**Most cited competitor:** {name} — appears in {N}% of checked queries

## Visibility Gaps (Google Ranks High, AI Doesn't Cite)
| Query | Google Position | AI Cited? | Likely Reason | Fix |
|-------|---------------|-----------|--------------|-----|
| | | No | {missing citations / weak structure / competitor content stronger} | |

## Action Plan
### Immediate (fix AI inaccuracies)
| # | Issue | Platform | Action |
|---|-------|----------|--------|
| | Brand described incorrectly | ChatGPT | Update website "About" page, add structured data |

### Content Optimization (get cited)
| # | Query Cluster | Current Gap | Action | Priority |
|---|--------------|-------------|--------|----------|
| | | Not cited despite ranking | Add citations + statistics + FAQ section | P1 |

### Monitoring Setup
| Action | Frequency | Tool |
|--------|-----------|------|
| Re-check top 10 queries across AI platforms | Monthly | Manual / Semrush |
| Track AI Overview presence via Semrush | Weekly | Semrush SERP Features |
| Monitor brand queries for perception drift | Quarterly | Manual |

## AMIT NEM TUDUNK (What We Don't Know)
- {AI responses are non-deterministic — today's result may differ tomorrow}
- {No reliable API for tracking AI citations at scale (manual checks don't scale)}
- {ChatGPT/Gemini don't show sources — we can only observe brand mentions, not confirm citation}
- {Perplexity shows sources but we cannot verify internal ranking factors}
- {AI response personalization means our check may differ from the client's users' experience}

## What Could Invalidate These Findings?
- {AI models update frequently — visibility can shift without content changes}
- {Manual checks are one-time snapshots, not stable measurements}
- {Competitor content changes can shift AI citations at any time}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/geo-visibility-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **AI visibility is NOT stable like rankings.** Set expectations with client: this is a snapshot, not a leaderboard.
- **Perplexity is the most transparent** — it shows source URLs. Prioritize Perplexity checks when source attribution matters.
- **99.5% of AI Overview citations match top 10 Google results** (seoClarity research) — so traditional SEO is still the foundation.
- **Pairs with:** `/geo-audit` (assess content readiness), `/geo-optimize` (fix gaps found here), `/seo-gaps` (content gaps driving AI visibility gaps), `/build-brand` (brand perception issues found here feed into brand strategy)
- **Repeat monthly.** AI responses shift. A quarterly `/geo-visibility` check should be standard for active SEO clients.
- **ChatGPT ranking factors** (NP Digital research): Brand Mentions (.87), Relevancy (.91), Reviews (.61), Authority (.52), Age (.46), Recommendations (.28). Focus on brand mentions and relevancy.
