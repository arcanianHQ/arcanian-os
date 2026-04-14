---
scope: shared
---

# Skill: GEO Content Optimization (`/geo-optimize`)

> v1.0 — 2026-04-14

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-04-14`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Apply proven GEO optimization tactics to specific pages or content pieces to improve their visibility in AI-generated responses. Takes a page URL and produces concrete, line-level recommendations (or direct content rewrites) based on the 9 research-backed GEO tactics.

This is the "do the work" skill — it takes the findings from `/geo-audit` or `/geo-visibility` and turns them into optimized content.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

## Trigger

Use this skill when:
- `/geo-audit` identified specific pages needing optimization
- `/geo-visibility` revealed queries where client isn't cited in AI responses
- Client wants to optimize a specific page for AI search
- New content is being created and needs GEO treatment before publishing
- A key landing page or cornerstone article needs AI visibility boost

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Target page URL(s) | Yes | User specifies (1-5 pages per run) |
| Target queries for each page | Recommended | GSC data or user input |
| Page content | Yes | Scrape via Firecrawl or user provides |
| `/geo-audit` output | Optional | Previous audit results |
| Client industry/domain | Yes | brand/ directory or user |
| Competitor pages that ARE cited by AI | Optional | `/geo-visibility` output |

## GEO Optimization Tactics (Ordered by Impact)

### Tier 1: High Impact (30-40% visibility improvement)

**1. Cite Sources**
- Add credible external references to support claims
- Link to research papers, industry reports, government data, authoritative publications
- Format: inline citations with linked source names
- Target: 3-5 citations per 1000 words minimum
- Example: "According to a [Gartner report](url), 65% of organizations now use generative AI regularly."

**2. Add Statistics**
- Support arguments with quantitative data
- Include percentages, growth figures, market data, research findings
- Present in impactful formats (callout boxes, bold figures, comparison tables)
- Target: 2-4 data points per major section
- Example: "organic search traffic is expected to decrease by over 50% as consumers embrace AI-powered search."

**3. Include Quotations**
- Add expert quotes from industry authorities
- Use direct quotes with attribution (name + role/organization)
- Adds depth, authority, and diverse perspectives
- Target: 1-2 expert quotes per article
- Example: "As [Expert Name], [Role] at [Organization], notes: '[quote].'"

### Tier 2: Medium Impact (15-25% improvement)

**4. Fluency Optimization**
- Ensure smooth, error-free reading flow
- Fix grammar, awkward transitions, run-on sentences
- Improve logical progression between paragraphs
- Use clear transitions and well-structured paragraphs

**5. Technical Terms**
- Include domain-specific vocabulary appropriate to the topic
- Balance technical depth with accessibility
- Helps AI categorize content for niche queries
- Don't over-stuff — use naturally where they add precision

**6. Authoritative Tone**
- Write with confidence and expertise
- Use active voice, definitive statements backed by evidence
- Demonstrate E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness)
- Include author credentials/bio section

### Tier 3: Baseline (5-15% improvement)

**7. Easy-to-Understand Language**
- Simplify complex concepts without dumbing down
- Explain jargon on first use
- Short sentences for key points, longer for nuance
- Aim for broad accessibility

**8. Unique Words**
- Replace generic terms with specific, precise vocabulary
- Avoid filler phrases and cliches
- Use descriptive language that differentiates content

**9. Keyword Enhancement**
- Integrate target keywords naturally
- Include long-tail and conversational query variants
- Add semantic keywords and related entities
- DO NOT keyword-stuff — the research shows this HURTS GEO performance

### Structural Optimizations (AI Parsing)

**10. Direct Answer Positioning**
- Place direct answers to the target query in the first 1-2 sentences
- AI systems favor content that quickly addresses the user's question
- Follow with detail, not the other way around

**11. Content Structure for AI**
- Clear H1-H5 hierarchy with descriptive headers
- Bullet points and numbered lists for scannable information
- Tables for comparative data
- Short paragraphs (3-4 sentences max)

**12. FAQ Section**
- Add explicit question-answer pairs at the end of content
- Use the exact conversational queries users ask AI
- Implement FAQ or QandA schema markup

**13. Entity Optimization**
- Name specific entities (people, companies, products, places)
- Provide context for each entity
- Link to authoritative sources about entities

**14. Structured Data**
- Implement appropriate schema: Article, FAQ, QandA, HowTo, Product, Review, Organization
- Use JSON-LD format
- Validate with Google Rich Results Test

## Execution Steps

1. **Scrape target page** — Use Firecrawl or provided content. Record current state as baseline.

2. **Identify target queries** — From GSC data or user input. For each query, determine:
   - Intent type (informational, transactional, navigational, commercial investigation)
   - Whether AI Overviews trigger for this query
   - Current SERP position

3. **Score current GEO state** — Evaluate the page against all 14 optimization points above. Score each 0-3. Calculate current GEO score.

4. **Domain-specific tactic selection** — Based on client's industry, prioritize tactics:
   | Domain | Priority Tactics | Deprioritize |
   |--------|-----------------|-------------|
   | Science/Tech | Technical terms, citations, authoritative | Easy-to-understand may conflict with depth |
   | Business/Finance | Statistics, citations, authoritative | Quotations less critical |
   | Arts/Humanities | Quotations, citations, fluency | Statistics less relevant |
   | Health/Wellness | Citations (medical), easy-to-understand | Technical terms can alienate |
   | E-commerce | Product schema, entity optimization, reviews | Academic citations less relevant |
   | Legal | Citations, factual accuracy, statistics | Casual tone inappropriate |

5. **Generate optimization recommendations** — For each tactic, produce:
   - Specific location in content (section/paragraph)
   - What to add, change, or restructure
   - Example of the optimized version where possible
   - Priority (P1/P2/P3)

6. **Schema markup recommendations** — Identify which schema types to add/improve:
   - Article schema (for blog posts, guides)
   - FAQ schema (for pages with Q&A content)
   - Product + AggregateRating schema (for product pages)
   - Organization schema (for about pages)
   - HowTo schema (for tutorial/guide content)

7. **Content structure improvements** — Recommend:
   - Header restructuring for clear hierarchy
   - Where to add bullet points, tables, or lists
   - Where to insert FAQ section
   - Direct answer positioning

## Output Template

```markdown
# GEO Optimization Plan — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: pages optimized, biggest improvement opportunities, expected impact}

## Pages in Scope
| Page | URL | Target Query | Current GEO Score | Intent |
|------|-----|-------------|-------------------|--------|
| {title} | {url} | {query} | {N}% | Info/Trans/Nav |

---

## Page 1: {Title}
**URL:** {url}
**Target queries:** {list}
**Current GEO Score:** {N}% → **Target:** {N}%

### Current State Assessment
| Tactic | Score (0-3) | Notes |
|--------|------------|-------|
| Cite Sources | | |
| Statistics Addition | | |
| Quotation Addition | | |
| Fluency | | |
| Technical Terms | | |
| Authoritative Tone | | |
| Easy-to-Understand | | |
| Unique Words | | |
| Keyword Enhancement | | |
| Direct Answer | | |
| Content Structure | | |
| FAQ Section | | |
| Entity Optimization | | |
| Structured Data | | |

### Optimization Recommendations

#### P1: High Impact
| # | Tactic | Location | Current | Recommended | Example |
|---|--------|----------|---------|-------------|---------|
| 1 | Cite Sources | {section} | No citations | Add 3 citations | "According to [Source]..." |
| 2 | Statistics | {section} | No data | Add 2 data points | "{N}% of users..." |
| 3 | Direct Answer | Opening | Answer buried in para 3 | Move to sentence 1 | "{direct answer}" |

#### P2: Medium Impact
| # | Tactic | Location | Current | Recommended |
|---|--------|----------|---------|-------------|
| | | | | |

#### P3: Structural
| # | Type | Recommendation |
|---|------|---------------|
| | Schema | Add FAQ schema for Q&A section |
| | Headers | Restructure H2s to match query patterns |
| | FAQ | Add FAQ section with 5 conversational queries |

### Schema Markup to Add
```json
// Specific schema recommendation here
```

---
{Repeat for each page}

## Implementation Summary
| Page | P1 Changes | P2 Changes | P3 Changes | Estimated GEO Improvement |
|------|-----------|-----------|-----------|--------------------------|
| | {N} | {N} | {N} | +{N}% |

## Implementation Order
1. {Highest impact page + action first}
2. {Next priority}
3. ...

## AMIT NEM TUDUNK (What We Don't Know)
- {GEO research impact percentages are averages — actual results will vary}
- {AI algorithm changes can shift which tactics are most effective}
- {Content changes take time to be re-indexed and re-evaluated by AI systems}
- {Structured data alone doesn't guarantee AI citation}

## What Could Invalidate These Findings?
- {If the page has technical SEO issues, GEO optimization alone won't help}
- {Competitor content may be inherently stronger regardless of GEO tactics}
- {AI platforms may deprioritize the topic/niche regardless of optimization}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/geo-optimize-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **Do NOT keyword-stuff.** The Aggarwal et al. research explicitly shows keyword stuffing HURTS GEO performance (scores dropped below baseline). Natural integration only.
- **Lower-ranked sites benefit most.** Sites ranked 5th+ in SERP saw up to 115.1% visibility increase from GEO tactics. Prioritize pages that aren't already #1.
- **Cite Sources is the single highest-impact tactic.** If the client can only do one thing, adding credible citations is it.
- **Pairs with:** `/geo-audit` (assessment first, then optimize), `/geo-visibility` (check AI presence before and after), `/seo-gaps` (identify which content to optimize), `/seo-narrative` (report on GEO improvements)
- **Intent-specific optimization:**
  - Informational queries → citations, quotes, statistics boost visibility most
  - Navigational queries → fluency, easy-to-understand, direct answers matter
  - Transactional queries → authoritative tone, clear CTAs, easy-to-understand language
- **Firecrawl MCP** is available for scraping page content. Use `firecrawl_scrape` to get current page content for analysis.
