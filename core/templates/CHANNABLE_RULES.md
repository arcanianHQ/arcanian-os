> v1.0 — 2026-04-03

# Channable Rules — {Client Name}

**Project:** {Channable project name}
**Documented:** YYYY-MM-DD
**Last updated:** YYYY-MM-DD

---

## Overview

| Property | Value |
|----------|-------|
| **Channable project** | {project name} |
| **Master rule set** | {rule set name} |
| **Rule type** | {Shared Rules / Master Rules / Mixed} |
| **Countries** | {HU, RO, SK, ...} |
| **Channels** | {Google Content API, Meta Online Products, ...} |

---

## Rules

<!-- Copy this block for each rule. Keep rules in execution order. -->

### Rule #{NN} — {Rule name}

**Type:** {Exclusion filter / Inclusion filter / Field mapping / Label assignment / Field transformation}

```
IF {condition}
THEN take {field(s)} and {action}
```

**Purpose:** {Why this rule exists — what problem it solves}

**Change log:**
- YYYY-MM-DD: {What changed and why}

---

<!-- END rule block template -->

## Rule Execution Summary

| # | Rule | Type | Scope |
|---|------|------|-------|
| {NN} | {name} | {type} | {what it affects} |

---

## Channel Attachment Status

| Country | Google Content API | Meta Online Products | Other Channels | Notes |
|---------|:------------------:|:--------------------:|:--------------:|-------|
| {CC} | {Yes/No} | {Yes/No} | {Yes/No} | {notes} |

---

## Feed Status

| Country | Feed version | Items | BUNDLE | Collisions | Notes |
|---------|:-----------:|------:|-------:|-----------:|-------|
| {CC} | {vN} | {n} | {n} | {n} | {notes} |

---

## Product Exclusion Analysis

<!-- Document WHY products are missing from the feed. This is critical for match rate diagnosis. -->

### Known Exclusion Causes

| Cause | Rule | Affected products | Example SKU | Impact |
|-------|------|------------------:|-------------|--------|
| {e.g., No image} | #07 | {count} | {SKU} | {match rate impact} |
| {e.g., Price = 0} | #21 | {count} | {SKU} | {match rate impact} |
| {e.g., Non-bundle in flooring category} | #22 | {count} | {SKU} | {match rate impact} |

### Unintended Exclusions

<!-- Products that SHOULD be in the feed but aren't. Cross-reference with Meta top 50 ViewContent reports. -->

| SKU | Product name | Why excluded | Should be in feed? | Action needed |
|-----|-------------|-------------|:------------------:|---------------|
| {SKU} | {name} | {reason} | Yes/No | {what to fix} |

---

## Magento Field Reference

<!-- Map Channable fields to Magento attributes for rule debugging -->

| Channable field | Magento attribute | Notes |
|----------------|-------------------|-------|
| `sku` | `sku` | {e.g., BUNDLE suffix added by Magento for bundle products} |
| `categories` | `category names` | {e.g., Internal to Channable, language-specific} |
| `is_bundle` | `type_id = bundle` | {e.g., true/false} |
| `type` | `type_id` | {simple, bundle, configurable, grouped} |
| `visibility` | `visibility` | {Not Visible Individually, Catalog, Search, Catalog/Search} |
| `active_category_ids` | `category_ids` | {comma-separated Magento category IDs} |
| `shipping_type` | {custom attribute} | {e.g., Vágatos, Kiscsomagos} |

---

## Magento Category ID Reference

| ID | Category name | Used in rule |
|:--:|--------------|:------------:|
| {id} | {name} | #{NN} |

---

**Template version:** 1.0
