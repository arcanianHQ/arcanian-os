---
scope: shared
---

# Skill: Schema & Structured Data Analyzer (`/seo-schema`)

> v1.0 — 2026-04-14

## Purpose

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **File versioning:** When generating .md output files, include version + date in the file (e.g., `v1.0 — 2026-04-14`). When updating an existing file, bump the version and note what changed. Never overwrite without versioning.

Analyze a website's structured data (schema markup) implementation, assess its completeness, and evaluate how well it supports both traditional SEO rich results and AI engine discoverability. Compares content-to-schema ratio and identifies gaps where schema would improve visibility in AI Overviews, ChatGPT, and other generative search engines.

Schema markup is the bridge between content and AI understanding. Well-implemented schema makes content parseable, categorizable, and citable by AI systems. The correlation between proper schema and AI Overview inclusion is significant.

> **Multi-domain prerequisite:** If client has 2+ domains, load `DOMAIN_CHANNEL_MAP.md` FIRST. See `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Evidence classification:** Every evidence item MUST be tagged: `[DATA]`, `[OBSERVED]`, `[STATED]`, `[NARRATIVE]`, `[INFERRED]`, `[HEARSAY]`. See `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`.

## Trigger

Use this skill when:
- `/geo-audit` flagged schema as weak or missing
- Technical SEO audit for a new or existing client
- Client asks "do we have the right structured data?"
- Preparing for AI visibility push — schema is the foundation
- Site redesign or CMS migration — validate schema survived
- Competitor has rich results the client doesn't — schema may be the gap

## Input Required

| Input | Required? | Source |
|-------|-----------|--------|
| Client slug | Yes | Session context |
| Target domain | Yes | DOMAIN_CHANNEL_MAP.md or user |
| Pages to analyze | Yes | User specifies or top 10-20 from GSC |
| Page source/HTML | Yes | Firecrawl MCP (`firecrawl_scrape`) or Chrome DevTools |
| Page type classification | Recommended | User or auto-detect (homepage, product, blog, category, about, contact, FAQ) |
| Competitor pages (for comparison) | Optional | User specifies |

## Schema Types by Page Type

| Page Type | Required Schema | Recommended Schema | GEO Bonus Schema |
|-----------|---------------|-------------------|-----------------|
| **Homepage** | Organization, WebSite | SiteNavigationElement, SearchAction | — |
| **Blog/Article** | Article (or BlogPosting) | BreadcrumbList, Author (Person) | FAQPage, Speakable |
| **Product** | Product, Offer | AggregateRating, Review, Brand | FAQPage |
| **Category/Collection** | CollectionPage, BreadcrumbList | ItemList | — |
| **FAQ** | FAQPage | BreadcrumbList | QAPage |
| **How-To/Guide** | HowTo | BreadcrumbList, Article | FAQPage |
| **About** | Organization, Person(s) | BreadcrumbList | — |
| **Contact** | LocalBusiness or Organization | ContactPoint | — |
| **Service** | Service | Offer, Provider | FAQPage |
| **Review/Testimonial** | Review, AggregateRating | Organization | — |
| **Video** | VideoObject | BreadcrumbList | — |
| **Event** | Event | Offer, Place | — |

## Execution Steps

1. **Select pages** — Choose representative pages per page type. Minimum:
   - Homepage
   - 3-5 blog/article pages (mix of top performers and new)
   - Key product/service pages
   - FAQ page (if exists)
   - About page
   - Contact page

2. **Scrape pages** — Use Firecrawl MCP (`firecrawl_scrape`) to get full HTML. Extract:
   - All `<script type="application/ld+json">` blocks
   - All `itemscope`/`itemprop` microdata attributes
   - All RDFa attributes (rare but check)
   - Tag as `[DATA]`

3. **Parse and catalog schema** — For each page, record:
   - Schema types found (e.g., Organization, Article, Product)
   - Schema format (JSON-LD preferred, Microdata acceptable, RDFa legacy)
   - Required properties present vs missing per schema type
   - Nested schemas (e.g., Article > Author > Person)

4. **Content-to-schema ratio analysis** — For each page:
   - Count content elements: headings, paragraphs, images, videos, lists, tables, FAQs, reviews
   - Count schema-described elements: how many of these are represented in structured data?
   - **Ratio = schema-described elements / total content elements**
   - Interpret: < 20% = Poor, 20-50% = Basic, 50-80% = Good, > 80% = Excellent

5. **Validation check** — For each schema block:
   - Are required properties present? (Google Rich Results requirements)
   - Are recommended properties filled? (improves rich result quality)
   - Any deprecated schema types or properties?
   - JSON-LD syntax valid?
   - Note: Full validation should use Google Rich Results Test — flag for manual check

6. **GEO readiness assessment** — Evaluate schema for AI discoverability:
   - **FAQPage schema** on content pages? (AI systems use these for direct answers)
   - **Speakable schema** present? (voice search / AI reading optimization)
   - **Author/Organization schema** with E-E-A-T properties? (AI trusts attributed content)
   - **Entity linking** — do schemas reference known entities (Wikipedia, Wikidata)?
   - **Content hierarchy** — does schema reflect the page's heading structure?

7. **Competitor comparison** (if provided) — Scrape competitor pages, compare:
   - Which schema types competitor uses that client doesn't
   - Schema depth/completeness comparison
   - Rich result presence in SERPs (Semrush SERP Features data if available)

8. **Generate implementation plan** — Prioritize by:
   - Impact on rich results (immediate visibility boost)
   - Impact on AI discoverability (GEO readiness)
   - Implementation effort (JSON-LD is easiest to add)
   - Page importance (high-traffic pages first)

## Output Template

```markdown
# Schema & Structured Data Analysis — {CLIENT}
v1.0 — {DATE}

## BLUF
{2-3 sentences: schema health summary, biggest gap, highest-impact recommendation}

## Data Reliability
| Source | Confidence | Known Issues |
|--------|-----------|-------------|
| Page HTML (Firecrawl) | HIGH/MED/LOW | {issues} |
| Schema parsing | HIGH | Automated extraction |
| Content-to-schema ratio | MED | [INFERRED] from element counting |
| GEO impact | LOW | [INFERRED] — correlation not causation |

## Schema Health Overview

**Overall Schema Score: {N}/100**

| Metric | Value | Rating |
|--------|-------|--------|
| Pages with any schema | {N}/{N} ({N}%) | |
| Avg content-to-schema ratio | {N}% | Poor/Basic/Good/Excellent |
| JSON-LD format usage | {N}% | (preferred) |
| Required properties coverage | {N}% | |
| GEO-relevant schema (FAQ, Speakable, Author) | {N}/{N} pages | |

## Per-Page Analysis

### {Page Title} — {page type}
**URL:** {url}
**Schema found:** {types found, or "NONE"}
**Content-to-schema ratio:** {N}%

| Schema Type | Status | Required Props | Missing Props | Notes |
|------------|--------|---------------|--------------|-------|
| {type} | Present/Missing | {N}/{N} | {list} | |

**Content elements NOT in schema:**
- {list of unstructured content that should be marked up}

**GEO readiness:**
- [ ] FAQ schema for Q&A content
- [ ] Author/Person schema with credentials
- [ ] Speakable markup for key paragraphs
- [ ] Entity references linked

{Repeat for each page}

## Schema Gap Summary by Page Type
| Page Type | Pages | Has Required Schema | Has Recommended | Has GEO Schema | Priority |
|-----------|-------|-------------------|----------------|---------------|----------|
| Homepage | {N} | Yes/No | Yes/No | N/A | |
| Blog/Article | {N} | Yes/No | Yes/No | Yes/No | |
| Product | {N} | Yes/No | Yes/No | Yes/No | |
| FAQ | {N} | Yes/No | N/A | Yes/No | |

## Competitor Comparison
{If competitor data available:}
| Schema Type | Client | Competitor 1 | Competitor 2 | Gap |
|------------|--------|-------------|-------------|-----|
| Organization | | | | |
| Article/BlogPosting | | | | |
| Product | | | | |
| FAQPage | | | | |
| Review/Rating | | | | |
| BreadcrumbList | | | | |

**Rich results in SERPs:**
| Feature | Client Has | Competitor Has | Opportunity |
|---------|-----------|---------------|-------------|
| FAQ rich result | | | |
| Review stars | | | |
| Sitelinks | | | |
| How-To | | | |

## Implementation Plan

### Priority 1: Quick Wins (add JSON-LD blocks)
| # | Page(s) | Schema to Add | Properties | Impact | Effort |
|---|---------|-------------|-----------|--------|--------|
| 1 | All blog posts | Article + Author | headline, datePublished, author, image | Rich results + AI attribution | Low (template) |
| 2 | Homepage | Organization | name, url, logo, sameAs, contactPoint | Brand knowledge panel | Low (one-time) |

### Priority 2: GEO Enhancement
| # | Page(s) | Schema to Add | Impact | Effort |
|---|---------|-------------|--------|--------|
| | Content pages with Q&A | FAQPage | AI direct answer citation | Med (content restructure) |
| | Key articles | Speakable | Voice search / AI reading | Low (add markup) |

### Priority 3: Competitive Parity
| # | Page(s) | Schema to Add | Why | Effort |
|---|---------|-------------|-----|--------|
| | | | Competitor has it, we don't | |

### Schema Templates (Ready to Implement)
```json
// Organization schema template
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "{BRAND}",
  "url": "{DOMAIN}",
  "logo": "{LOGO_URL}",
  "sameAs": ["{SOCIAL_URLS}"],
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "{PHONE}",
    "contactType": "customer service"
  }
}
```

```json
// Article + Author schema template
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "{TITLE}",
  "datePublished": "{DATE}",
  "dateModified": "{DATE}",
  "author": {
    "@type": "Person",
    "name": "{AUTHOR}",
    "url": "{AUTHOR_URL}"
  },
  "publisher": {
    "@type": "Organization",
    "name": "{BRAND}",
    "logo": {"@type": "ImageObject", "url": "{LOGO_URL}"}
  },
  "image": "{FEATURED_IMAGE}",
  "mainEntityOfPage": "{PAGE_URL}"
}
```

```json
// FAQPage schema template
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "{QUESTION}",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "{ANSWER}"
      }
    }
  ]
}
```

## AMIT NEM TUDUNK (What We Don't Know)
- {Schema presence ≠ schema indexing — Google must validate and accept the markup}
- {Content-to-schema ratio is a proxy metric — no industry benchmark exists}
- {GEO impact of schema is [INFERRED] from correlation data, not causal proof}
- {Schema validation requires Google Rich Results Test — automated check is not a substitute}
- {CMS-generated schema may differ from what's in the source template}

## What Could Invalidate These Findings?
- {CMS plugins may add/override schema dynamically (check rendered HTML, not template)}
- {Google may ignore schema that doesn't match visible page content}
- {Schema requirements change — check schema.org and Google docs for latest}

---
*What did we get wrong? What's missing?*
```

## Auto-Save

Save output to: `clients/{slug}/data/seo/seo-schema-{YYYY-MM-DD}.md`
Open file: `core/scripts/ops/open-file.sh "{path}"`

## Notes

- **JSON-LD is the preferred format.** Google recommends it, it's easiest to add (no HTML changes), and it's cleanest to maintain. If the site uses Microdata, recommend migrating to JSON-LD.
- **Content-to-schema ratio is our proprietary metric.** It measures how much of the page's content is described in structured data. Higher ratio = AI understands more of the page.
- **Use `/analyze-page` for per-page deep-dive.** This skill (`/seo-schema`) is the site-wide strategic view. For detailed per-page schema validation, run `/analyze-page --focus schema` which uses the `page-schema-checker` agent with Chrome DevTools extraction. This skill surveys the landscape; `/analyze-page` digs into individual pages.
- **Firecrawl MCP** (`firecrawl_scrape`) is the primary tool for getting page HTML. Use `firecrawl_crawl` for multi-page analysis. `/analyze-page` prefers Chrome DevTools with Firecrawl as fallback.
- **Google Rich Results Test** should be the final validation step — flag pages for manual testing. URL: `https://search.google.com/test/rich-results`
- **Pairs with:** `/analyze-page` (per-page deep schema + meta analysis), `/geo-audit` (schema is one component of GEO readiness), `/geo-optimize` (schema recommendations from this skill feed into page optimization), `/seo-diagnose` (missing schema can explain rich result loss)
- **CMS-specific notes:** WordPress (Yoast/RankMath add some schema), Shopify (Product schema built-in but often incomplete), [CMS] (needs manual implementation), custom CMS (usually needs everything added).
- **Schema and AI Overviews:** Pages with FAQ schema are more likely to be featured in AI Overview responses. Article schema with proper Author/Publisher helps AI attribute content correctly, which builds the trust signal AI systems use for citation decisions.
