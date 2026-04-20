---
scope: shared
---

> v1.0 — 2026-04-15
> Per-client file location: `clients/{slug}/brand/COMPETITIVE_LANDSCAPE.md`

# {Client Name} — Competitive Landscape

> Monitor config for `/competitor-monitor`. Also loaded by `/seo-gaps`, `/geo-audit`, `/geo-visibility`.
> Update when new competitors emerge or client changes competitive focus.

---

## Competitor Registry

| # | Name | Domain | In SEMrush? | Priority | Notes |
|---|------|--------|-------------|----------|-------|
| 1 | | | yes/no | high/med/low | |
| 2 | | | | | |
| 3 | | | | | |

**Max 5 competitors.** Monitoring cost scales linearly with count. Start with 3.

## Monitored Pages Per Competitor

For each competitor, list key pages to watch for changes.
Homepage is mandatory. Others are optional — add whatever is strategically relevant.

### {Competitor 1 — Name}
- Homepage: `https://`
- Products/Services: `https://`
- Pricing (if public): `https://`
- About: `https://`
- Blog root: `https://`

### {Competitor 2 — Name}
- Homepage: `https://`
- Blog root: `https://`

### {Competitor 3 — Name}
- Homepage: `https://`
- Blog root: `https://`

## Monitor Schedule

```yaml
frequency: weekly       # daily / weekly / monthly
blog_lookback_days: 30  # how far back to scan for new blog posts each run
semrush_gap: false      # run SEMrush keyword gap analysis (requires SEMrush MCP)
```

## Known Positioning Notes

{Brief notes on how each competitor positions themselves. What are they known for? Where do they compete directly with us? [STATED] or [OBSERVED] evidence only — no narrative assumptions.}

## Change History

| Date | Change | By |
|------|--------|-----|
| YYYY-MM-DD | Initial setup | |
