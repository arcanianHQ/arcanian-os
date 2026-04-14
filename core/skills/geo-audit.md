---
scope: shared
---

# Skill: GEO Readiness Audit (`/geo-audit`)

> v1.0 — 2026-04-14

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-04-14`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Audit how well a client's website content is optimized for AI-driven search engines (ChatGPT, Perplexity, Gemini, Google AI Overviews). Evaluates content against the 9 proven GEO tactics from the Aggarwal et al. (2023) research: citations, statistics, quotations, fluency, technical terms, authoritative tone, easy-to-understand language, unique words, and keyword enhancement.

Traditional SEO rankings don't guarantee AI visibility. This skill assesses the gap between traditional SEO readiness and GEO readiness, producing a prioritized action plan.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. Select the correct domain for analysis. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

> **Confidence scoring:** Every finding gets a unified confidence score via `core/methodology/CONFIDENCE_ENGINE.md`.

## Trigger

Use this skill when:
- Client asks "are we visible in ChatGPT / AI search?"
- Content strategy review needs to include AI readiness
- Before a content overhaul or site redesign
- After `/seo-gaps` reveals opportunities that need GEO treatment
- Client's organic traffic is declining despite good rankings (AI Overviews may be absorbing clicks)

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Target domain | Yes | DOMAIN_CHANNEL_MAP.md or user |
| Top 10-20 pages to audit | Yes | User specifies or pull from GSC top pages |
| GSC data (top queries/pages) | Recommended | Databox MCP |
| Semrush SERP features data | Optional | Semrush MCP (AI Overview filter) |
| Competitor domains | Optional | brand/COMPETITIVE_LANDSCAPE.md |

## GEO Scoring Framework

Based on the Princeton/Georgia Tech/Allen AI/IIT Delhi research (Aggarwal et al., 2023), these tactics produce measurable visibility improvements in generative engine responses:

### High-Performing Tactics (30-40% relative improvement)
| Tactic | What to Check | Weight |
|--------|--------------|--------|
| **Cite Sources** | External citations, linked references, data attribution | 3x |
| **Quotation Addition** | Expert quotes, industry authority citations | 3x |
| **Statistics Addition** | Data points, percentages, research findings | 3x |

### Medium-Performing Tactics (15-25% improvement)
| Tactic | What to Check | Weight |
|--------|--------------|--------|
| **Fluency Optimization** | Smooth reading, no grammar issues, logical flow | 2x |
| **Technical Terms** | Domain-specific vocabulary, precise terminology | 2x |
| **Authoritative Tone** | Confident claims, expert positioning, E-E-A-T signals | 2x |

### Baseline Tactics (5-15% improvement)
| Tactic | What to Check | Weight |
|--------|--------------|--------|
| **Easy-to-Understand** | Clear language, jargon explained, accessible | 1x |
| **Unique Words** | Specific vocabulary, not generic filler | 1x |
| **Keyword Enhancement** | Natural keyword integration, semantic coverage | 1x |

### Structural & Technical Factors (not in original study, but critical for AI parsing)
| Factor | What to Check |
|--------|--------------|
| **Structured Data** | Schema markup (Article, FAQ, QandA, Organization, Product, Review) |
| **Content Structure** | Clear H1-H5 hierarchy, bullet points, tables, direct answers in first sentences |
| **Entity Optimization** | Named entities (people, places, products) with context |
| **FAQ Sections** | Explicit question-answer pairs that AI can extract |
| **Content Freshness** | Last updated date, current data references |
| **Internal Linking** | Topic cluster structure, clear content hierarchy |

## Execution Steps

1. **Identify audit scope** — Select top 10-20 pages. Priority: pages with high GSC impressions but declining clicks (potential AI Overview cannibalization), key money pages, and cornerstone content.

2. **Per-page GEO tactic scan** — For each page, evaluate all 9 research-backed tactics + 6 structural factors. Score each 0-3:
   - 0 = Absent
   - 1 = Minimal (1-2 instances, low quality)
   - 2 = Present (adequate coverage)
   - 3 = Strong (well-executed, multiple instances)

3. **Calculate GEO readiness scores:**
   - Per-page score = weighted sum of tactic scores / max possible (apply weights from framework above)
   - Site-wide score = average of per-page scores
   - Interpret: 0-30% = GEO-unaware, 31-60% = Partially ready, 61-80% = Good, 81-100% = Excellent

4. **Check AI Overview exposure** — If Semrush available, filter SERP Features for "AI Overview" to identify:
   - Which client queries trigger AI Overviews
   - Whether client is cited in those overviews
   - Which competitors are cited instead

5. **Content structure assessment** — Evaluate whether content provides direct answers in opening sentences, uses structured data, and formats information in ways AI can parse (lists, tables, FAQ sections).

6. **Domain-specific tactic mapping** — Based on client's industry, identify which tactics matter most:
   | Domain | Priority Tactics |
   |--------|-----------------|
   | Science/Technology | Technical terms, authoritative tone, citations |
   | Business/Finance | Statistics, data insights, authoritative tone |
   | Arts/Humanities | Quotations, citations, fluency |
   | Health/Wellness | Citations (medical sources), easy-to-understand, statistics |
   | E-commerce | Product schema, reviews schema, entity optimization |
   | Legal/Government | Citations, factual accuracy, statistics |

7. **Generate prioritized recommendations** — Rank by: effort (low/med/high) x impact (from research data). Quick wins first.

## Output Template

```markdown
# GEO Readiness Audit — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: overall GEO readiness level, biggest gaps, highest-impact quick win}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| Page content (scraped) | HIGH/MED/LOW | {issues} |
| GSC | HIGH/MED/LOW / NOT AVAILABLE | {issues} |
| Semrush SERP Features | HIGH/MED/LOW / NOT AVAILABLE | {issues} |

## Site-Wide GEO Readiness Score: {N}%
Interpretation: {GEO-unaware / Partially ready / Good / Excellent}

### Score Breakdown by Tactic
| Tactic | Avg Score (0-3) | % of Pages with Score 2+ | Priority |
|--------|----------------|------------------------|----------|
| Cite Sources | | | HIGH |
| Statistics Addition | | | HIGH |
| Quotation Addition | | | HIGH |
| Fluency Optimization | | | MED |
| Technical Terms | | | MED |
| Authoritative Tone | | | MED |
| Easy-to-Understand | | | LOW |
| Unique Words | | | LOW |
| Keyword Enhancement | | | LOW |

### Structural & Technical Factors
| Factor | Coverage | Notes |
|--------|---------|-------|
| Structured Data (Schema) | {None / Partial / Good} | |
| Content Structure (H-tags, lists) | {Poor / Adequate / Strong} | |
| Entity Optimization | {None / Partial / Good} | |
| FAQ Sections | {None / Some / Comprehensive} | |
| Content Freshness | {Stale / Mixed / Current} | |
| Internal Linking | {Weak / Adequate / Strong} | |

## Per-Page Audit Results
| Page | GEO Score | Top Gap | Quick Win | Priority |
|------|-----------|---------|-----------|----------|
| {URL} | {N}% | {tactic} | {action} | P1/P2/P3 |

## AI Overview Exposure
{If Semrush data available:}
| Query | AI Overview? | Client Cited? | Competitors Cited | Action |
|-------|-------------|--------------|-------------------|--------|
| | Yes/No | Yes/No | {names} | |

{If not available: "Semrush SERP Features data not available. Manual check recommended for top 10 queries."}

## Domain-Specific Recommendations
Industry: {client industry}
Priority tactics for this domain: {list}

## Action Plan (Prioritized)
### Quick Wins (low effort, high impact)
| # | Action | Pages Affected | Tactic | Est. Impact |
|---|--------|---------------|--------|-------------|
| 1 | Add source citations to claims | {N} pages | Cite Sources | +30-40% visibility |
| 2 | Include relevant statistics | {N} pages | Statistics | +30-40% visibility |

### Medium Effort
| # | Action | Pages Affected | Tactic | Est. Impact |
|---|--------|---------------|--------|-------------|
| | | | | |

### Structural Improvements
| # | Action | Scope | Type |
|---|--------|-------|------|
| | Add FAQ schema to key pages | | Technical |
| | Implement Article schema | | Technical |

## AMIT NEM TUDUNK (What We Don't Know)
- {AI visibility is not directly measurable — no equivalent of "rankings" for AI responses}
- {Research data is from 2023 — AI algorithms evolve; tactic effectiveness may shift}
- {Without Semrush AI Overview data, competitor citation analysis is [UNKNOWN]}
- {Actual AI response inclusion depends on many factors beyond content optimization}

## What Could Invalidate These Findings?
- {AI algorithms may weight different factors than the research suggests}
- {Content quality assessment is partially [INFERRED] from surface-level analysis}
- {Domain-specific tactic priorities are based on general research, not client-specific data}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/geo-audit-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **This is an assessment skill, not an optimization skill.** Use `/geo-optimize` to apply fixes to specific pages.
- **Pairs with:** `/seo-gaps` (content gaps that need GEO treatment), `/geo-visibility` (check AI brand presence first), `/geo-optimize` (implement the recommendations), `/seo-diagnose` (traffic drops from AI Overview cannibalization)
- **Research basis:** Aggarwal et al. (2023) — "GEO: Generative Engine Optimization" (Princeton, Georgia Tech, Allen Institute of AI, IIT Delhi). Top tactics (Cite Sources, Quotations, Statistics) achieved 30-40% relative visibility improvement.
- **Lower-ranked sites benefit MORE from GEO.** The research found 115.1% visibility increase for sites ranked 5th in SERP — sites not on page 1 have the most to gain.
- **GEO and SEO are complementary.** A GEO audit does NOT replace traditional SEO audits. Both should be maintained.
