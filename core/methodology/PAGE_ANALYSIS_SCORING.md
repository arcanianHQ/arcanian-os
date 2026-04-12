---
scope: shared
---

> v1.0 — 2026-04-12
> Scoring rubrics for page analysis agents. Derived from AI Content Analyzer V2 plugin scoring logic.

# Page Analysis Scoring Rubrics

## Purpose

Unified scoring reference for all `page-*-checker` agents. Every agent scores its dimension 0-100 using these rubrics. Scores feed into the `page-analysis` council aggregation.

## Status Thresholds

| Score | Status | Color | Meaning |
|---|---|---|---|
| ≥80 | Good | Green | No action needed |
| 60-79 | Needs work | Amber | Should fix, not urgent |
| <60 | Critical | Red | Fix immediately |

---

## 1. Schema / Structured Data (page-schema-checker)

**Base score:** 50

**Additions:**
- No schemas found → set to 20 (skip other additions)
- Per schema found: +5 (max +25)
- 3+ schema types: +10
- 2 schema types: +5
- Completeness >70%: + (completeness - 70) × 0.25
- Validity >80%: + (validity - 80) × 0.2

**Deductions:**
- Invalid JSON-LD (parse error): -15
- Missing `@context`: -10
- Completeness <70%: -10
- Validity <85%: -8

**Required schema types by page context:**

| Page Type | Required | Bonus |
|---|---|---|
| Homepage | Organization or WebSite | BreadcrumbList, SearchAction |
| Product page | Product | Offer, AggregateRating, BreadcrumbList |
| Article/blog | Article or BlogPosting | Author, BreadcrumbList |
| FAQ page | FAQPage | BreadcrumbList |
| Category/listing | CollectionPage or ItemList | BreadcrumbList |
| Contact page | ContactPoint or LocalBusiness | Organization |

**Key fields per schema type:**

| Schema Type | Required Fields | Optional but Recommended |
|---|---|---|
| Organization | name, url, logo | sameAs, contactPoint, address, foundingDate |
| Product | name, description, image, offers | brand, sku, gtin, aggregateRating |
| Article | headline, datePublished, author | dateModified, image, publisher |
| FAQPage | mainEntity (with Question+Answer) | — |
| BreadcrumbList | itemListElement with position+name | item (URL) |
| WebSite | name, url | potentialAction (SearchAction) |

---

## 2. Meta Tags (page-meta-checker)

**Scoring breakdown (100 points total):**

| Component | Points | Criteria |
|---|---|---|
| Title exists | 15 | `<title>` tag present |
| Title length optimal | 10 | 50-60 characters (too short <30, too long >65) |
| Description exists | 10 | `<meta name="description">` present |
| Description length optimal | 10 | 150-160 characters (too short <70, too long >170) |
| OpenGraph tags | 20 | Proportional: og:title + og:description + og:image + og:url + og:type = 20 |
| Twitter Cards | 15 | twitter:card + twitter:title + twitter:description + twitter:image = 15 |
| Canonical URL | 5 | `<link rel="canonical">` present |
| Viewport | 5 | `<meta name="viewport">` present |
| Charset | 5 | `<meta charset>` or Content-Type present |
| Language | 3 | `<html lang="">` present and valid |
| Robots | 2 | `<meta name="robots">` present |

**Title quality checks:**
- Contains primary keyword (if known): bonus context note
- Pipe or dash separator: standard, OK
- Brand at end: good practice
- All caps: flag as issue
- Duplicate of H1: note (not necessarily bad)

**Description quality checks:**
- Contains call-to-action words: good
- Contains primary keyword: good
- Truncated mid-sentence at 160 chars: flag

---

## 3. Heading Hierarchy (page-heading-checker)

**Scoring breakdown (100 points total):**

| Component | Points | Criteria |
|---|---|---|
| Exactly 1 H1 | 30 | 0 H1 = 0 points, >1 H1 = 10 points (penalty) |
| H1 position | 10 | H1 is the first heading on page = 10, H1 after other headings = 0 |
| H1 content quality | 10 | >3 words = 5, descriptive (not generic like "Home") = 5 |
| Logical nesting | 20 | No skipped levels = 20. Per skip (e.g., H1→H3): -10 |
| Heading count | 15 | 3-15 headings = 15, <3 = 5, 16-25 = 10, >25 = 5 |
| Heading depth | 10 | Uses H2+H3 = 10, only H1+H2 = 5, only H1 = 0 |
| No empty headings | 5 | All headings have visible text = 5 |

**Common issues to flag:**
- Multiple H1s (very common, significant SEO impact)
- H1 buried below other headings (like bankmonitor.hu)
- H3 used for styling instead of semantics (cards, buttons)
- Skipped levels (H1 → H3 without H2)
- Heading used for visual styling only (should be `<div>` with CSS)

---

## 4. Content Quality (page-content-checker)

**Word count benchmarks by page type:**

| Page Type | Thin | Minimal | Optimal | Long | Excessive |
|---|---|---|---|---|---|
| Homepage | <100 | 100-300 | 300-1000 | 1000-2000 | >2000 |
| Product | <100 | 100-300 | 300-1000 | 1000-2000 | >2000 |
| Blog/Article | <300 | 300-800 | 800-2500 | 2500-5000 | >5000 |
| Landing page | <200 | 200-500 | 500-1500 | 1500-3000 | >3000 |
| Category/listing | <50 | 50-200 | 200-600 | 600-1200 | >1200 |
| FAQ | <200 | 200-500 | 500-2000 | 2000-4000 | >4000 |

**Scoring breakdown (100 points total):**

| Component | Points | Criteria |
|---|---|---|
| Word count in optimal range | 30 | Optimal = 30, Minimal/Long = 20, Thin = 5, Excessive = 15 |
| Paragraph structure | 20 | >5 paragraphs = 15, >10 = 20, <3 = 5 |
| Sentence variety | 15 | Mix of short+long sentences = 15, all same length = 5 |
| Content depth indicators | 20 | Lists, tables, images referenced in text = bonus |
| No boilerplate dominance | 15 | Main content > navigation/footer text = 15 |

**Page type detection heuristics:**
- URL contains `/product/`, `/p/`, or has price on page → Product
- URL contains `/blog/`, `/article/`, `/news/` → Article
- URL is root `/` or `/home` → Homepage
- URL contains `/category/`, `/collection/` → Category
- URL contains `/faq`, `/gyakran-ismetelt` → FAQ
- Otherwise → Landing page (default)

---

## 5. Readability (page-readability-checker)

**Flesch-Kincaid Reading Ease → Score mapping:**

| FK Score | Reading Level | Analysis Score |
|---|---|---|
| 90-100 | Very easy (5th grade) | 95 |
| 80-89 | Easy (6th grade) | 90 |
| 70-79 | Fairly easy (7th grade) | 85 |
| 60-69 | Standard (8th-9th grade) | 80 |
| 50-59 | Fairly difficult (10th-12th) | 70 |
| 30-49 | Difficult (college) | 55 |
| 0-29 | Very difficult (professional) | 40 |
| <0 | Formula breakdown | N/A |

**Language limitation:**
- Flesch-Kincaid is designed for **English text only**
- For Hungarian, German, and other agglutinative/inflected languages: **mark as N/A**
- Detect language from `<html lang="">` attribute
- If `lang` is not `en`, `en-US`, `en-GB` → score as N/A with note: "Readability formula not applicable for {language}"
- **Non-English languages:** fall back to sentence length metrics only

**Sentence length scoring (language-agnostic):**

| Avg Sentence Length | Score Adjustment |
|---|---|
| <15 words | +5 (easy to read) |
| 15-20 words | +0 (ideal) |
| 20-25 words | -5 (getting long) |
| >25 words | -10 (too complex) |

---

## 6. Technical HTML (page-html-checker)

**Scoring breakdown (100 points total):**

| Component | Points | Criteria |
|---|---|---|
| Semantic elements | 30 | +5 per element present: `<main>`, `<nav>`, `<article>`, `<section>`, `<header>`, `<footer>` (max 30) |
| Image alt coverage | 20 | 100% = 20, >80% = 15, >50% = 10, <50% = 5 |
| Lazy loading | 10 | >50% images lazy = 10, >25% = 7, 0% = 3 |
| Link health | 15 | No empty hrefs = 5, reasonable internal count = 5, external links present = 5 |
| Viewport meta | 10 | Present = 10 |
| Charset defined | 10 | Present = 10 |
| No inline styles | 5 | Bonus: minimal inline style usage |

**Image analysis details:**
- Missing alt: flag each image (accessibility + SEO)
- Empty alt (`alt=""`) on decorative images: OK
- Alt text too long (>125 chars): flag
- Missing dimensions (width/height): CLS risk, flag
- No lazy loading on below-fold images: performance flag

**Link analysis details:**
- Internal links: >10 is healthy for most pages
- External links: 0 is suspicious (no-outbound strategy?)
- Nofollow on internal links: flag as issue
- Broken/empty href: flag as P1

---

## Aggregation Formula

**Overall score = weighted average of all dimension scores:**

```
overall = (
  schema_score × 0.15 +
  meta_score × 0.25 +
  heading_score × 0.15 +
  content_score × 0.20 +
  readability_score × 0.10 +  (0 weight if N/A for language)
  html_score × 0.15
)
```

**If readability is N/A:** redistribute its 10% weight proportionally:
```
overall = (
  schema_score × 0.167 +
  meta_score × 0.278 +
  heading_score × 0.167 +
  content_score × 0.222 +
  html_score × 0.167
)
```

---

## Evidence Tagging

All page analysis findings use:
- `[OBSERVED: Chrome DevTools, YYYY-MM-DD]` — for extracted data
- `[DATA: {source}, YYYY-MM-DD]` — if cross-referenced with Databox/GSC
- `[INFERRED: from {what}]` — for page type detection, keyword guessing

## References

- AI Content Analyzer: `input/source/ai-content-analyzer/supabase/functions/analyze-webpage/plugins/`
- Confidence Engine: `core/methodology/CONFIDENCE_ENGINE.md`
- Evidence Classification: `core/methodology/EVIDENCE_CLASSIFICATION_RULE.md`
