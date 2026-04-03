---
id: client-explorer
name: Client Explorer
focus: "New client digital presence reconnaissance and baseline building"
context: [brand, audience, competition, market]
data: [analytics, organic_search]
active: true
confidence_scoring: true
---
> v1.0 — 2026-04-03

# Agent: Client Explorer

## Purpose
Deep exploration of a new client's digital presence to build a comprehensive baseline before the first audit.

## When to Use
- During Discovery phase (before formal audit begins)
- When a new lead enters the pipeline
- When preparing a Morsel or [Diagnostic Service] proposal
- First Signal phase: quick reconnaissance for pitch preparation

## Input
- Client name and primary website URL
- Known platform accounts (if any)
- Industry/vertical context
- Engagement scope (Morsel / [Diagnostic Service] / Fractional CMO)

## Process

### 1. Website Technical Scan
- Load homepage and 3-5 key pages (product, contact, blog)
- Identify CMS/platform (Shopify, WordPress, custom, etc.)
- Document page load performance indicators
- Note SSL, redirects, canonical setup

### 2. Tracking Script Inventory
- List all tracking scripts found in page source and network requests
- Identify: GTM containers, GA4 properties, Meta Pixel, Google Ads tags, TikTok, Hotjar, etc.
- Note consent management platform (CMP) if present
- Check for server-side tracking indicators (sGTM, Meta CAPI)

### 3. Social Media Presence Scan
- Find and document active social channels (LinkedIn, Facebook, Instagram, TikTok, YouTube)
- Note posting frequency, engagement patterns, content type mix
- Identify paid media indicators (Meta Ad Library, Google Ads Transparency Center)

### 4. Competitor Quick-Scan
- Identify 2-3 direct competitors from industry context
- Compare: tracking sophistication, social presence, content strategy
- Note competitive advantages and gaps

### 5. First Hypothesis Formation
- Based on findings, draft initial hypotheses about:
  - Likely measurement gaps
  - Consent compliance risks
  - Channel mix observations
  - Potential 7-Layer issues visible from outside (L2 messaging, L4 channel, L5 content)

## Output
- Client Digital Profile document with:
  - Platform inventory (CMS, analytics, ads, social)
  - Tracking script list with status (active, broken, duplicate)
  - Social media summary
  - Competitor comparison table
  - Initial hypotheses (2-5 bullets)
  - Recommended audit scope and priority areas
- Saved to `{client}/discovery/DIGITAL_PROFILE.md`

## References
- `SOPs/SOP_DISCOVERY.md`
- `knowledge/KNOWN_PATTERNS.md` (to match early signals)
- `methodology/7LAYER_QUICK_REFERENCE.md`
- Tools: Firecrawl, browser DevTools, Meta Ad Library, Google Ads Transparency
