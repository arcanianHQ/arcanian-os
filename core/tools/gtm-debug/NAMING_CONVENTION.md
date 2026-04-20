---
scope: shared
---

# GTM Framework - Naming Convention Guide

## Overview

Consistent naming conventions are critical for:
- **Organization**: Quickly find what you need
- **Clarity**: Understand file purpose at a glance
- **Version Control**: Track changes over time
- **Collaboration**: Multiple people can work efficiently
- **Automation**: Claude Code can parse files reliably

---

## Container JSON Files

### Client Actual Containers (Current Deployed)

**Location**: `containers/client_actual/`

**Naming Pattern**:
```
{environment}_{container_type}_{date}_{version}.json

Examples:
production_web_20251111_v1.json
production_server_20251111_v1.json
staging_web_20251015_v3.json
```

**Components**:
- `environment`: production | staging | dev
- `container_type`: web | server | app
- `date`: YYYYMMDD format
- `version`: v1, v2, v3 (increment for same-day exports)

**Full Examples**:
```
✅ production_web_20251111_v1.json
✅ production_server_20251111_v1.json
✅ staging_web_20251110_v2.json
✅ dev_web_20251015_v1.json

❌ my_container.json (too vague)
❌ GTM-12345.json (ID only, no context)
❌ web_container_latest.json (no date/version)
❌ production-web-container.json (no date)
```

### Taggrs Recommended Containers (Templates)

**Location**: `containers/taggrs_recommended/`

**Naming Pattern**:
```
taggrs_{container_type}_{template_name}_{date}.json

Examples:
taggrs_web_ecommerce_standard_20251101.json
taggrs_server_ga4_meta_20251101.json
taggrs_web_custom_client_20251015.json
```

**Components**:
- `taggrs_`: Prefix to identify as Taggrs template
- `container_type`: web | server
- `template_name`: Description of template purpose
- `date`: YYYYMMDD when received from Taggrs

**Full Examples**:
```
✅ taggrs_web_ecommerce_standard_20251101.json
✅ taggrs_server_ga4_meta_capi_20251101.json
✅ taggrs_web_woocommerce_custom_20251015.json

❌ taggrs_template.json (no type or date)
❌ recommended_container.json (missing taggrs prefix)
❌ web_container_taggrs.json (inconsistent format)
```

---

## Analysis & Report Files

### Analysis Output Files

**Location**: `analysis_outputs/` (create this folder)

**Naming Pattern**:
```
{date}_{analysis_type}_{client_name}.{ext}

Examples:
20251111_executive_summary_clientname.md
20251111_technical_analysis_clientname.md
20251111_issues_list_clientname.csv
20251111_fix_recommendations_clientname.md
```

**Components**:
- `date`: YYYYMMDD when analysis was performed
- `analysis_type`: Type of report
- `client_name`: Client identifier (lowercase, no spaces)
- `ext`: md | csv | pdf

**Common Analysis Types**:
- `executive_summary`
- `technical_analysis`
- `issues_list`
- `fix_recommendations`
- `variable_mapping`
- `testing_plan`

**Full Examples**:
```
✅ 20251111_executive_summary_acme_corp.md
✅ 20251111_issues_list_shopify_store.csv
✅ 20251111_fix_recommendations_webshop_hu.md

❌ analysis.md (no date, no type)
❌ summary_2024.md (ambiguous date, no client)
❌ Client Report Final.md (spaces, no date, vague)
```

---

## Client Configuration Files

**Location**: `client_config/`

**Naming Pattern**:
```
{client_name}_config_{date}.md

Examples:
acme_corp_config_20251111.md
webshop_hu_config_20251015.md
myshop_config_current.md (for active version)
```

**Special Case - Active Config**:
```
client_specific.md  (symlink or current version)
```

**Full Examples**:
```
✅ acme_corp_config_20251111.md
✅ client_specific.md (active/current)
✅ bigshop_config_20251015.md

❌ config.md (no identifier)
❌ my_config_file.md (inconsistent)
❌ ClientConfig_2024.md (wrong format)
```

---

## Platform-Specific Files

**Location**: `platforms/`

**Naming Pattern**:
```
{platform_name}.md

Examples:
wordpress_woocommerce.md
shopify.md
magento.md
shoprenter.md
unas.md
custom_platform.md
```

**Rules**:
- All lowercase
- Use underscores for spaces
- No version numbers (update file in place)
- Descriptive, not branded

**Full Examples**:
```
✅ wordpress_woocommerce.md
✅ shopify_plus.md
✅ magento_2.md
✅ custom_headless_commerce.md

❌ WooCommerce.md (capitalization)
❌ woo.md (too abbreviated)
❌ platform1.md (not descriptive)
❌ wordpress-woocommerce.md (use underscores)
```

---

## Documentation Files

**Location**: Root level or appropriate folders

**Naming Pattern**:
```
{PURPOSE_IN_CAPS}.md  (for major docs at root)
{descriptive_name}.md (for supporting docs)

Examples:
Root Level:
README.md
QUICK_START.md
FRAMEWORK_OVERVIEW.md
NAMING_CONVENTION.md (this file)
CHANGELOG.md

Folders:
methodology/01_core_debugging_process.md
methodology/02_data_consistency_rules.md
```

**Rules**:
- Major docs at root: ALL_CAPS (except README)
- Sequential docs: Use numbered prefixes (01_, 02_)
- Descriptive but concise
- Use underscores, not hyphens

---

## Variable & Tag Naming (in GTM Containers)

### GTM Variable Names

**Pattern**:
```
{prefix} - {description}

Prefixes:
- DL: Data Layer variable
- CJS: Custom JavaScript variable
- Const: Constant variable
- Cookie: 1st party cookie
- URL: URL variable
- Event: Event parameter

Examples:
DL - Product ID
DL - Ecommerce Items
CJS - Event ID Generator
Const - GA4 Measurement ID
Cookie - Facebook Pixel Cookie
Event - Transaction ID
```

**Full Examples**:
```
✅ DL - ecommerce.items.0.item_id
✅ CJS - Generate UUID for Event ID
✅ Const - GTM Container Version
✅ Cookie - _fbp

❌ productId (no prefix, camelCase)
❌ var1 (not descriptive)
❌ Data Layer - Product ID (wrong format)
```

### GTM Tag Names

**Pattern**:
```
{platform} - {event_type} - {destination}

Examples:
GA4 - Purchase - Web
GA4 - View Item - Server
Meta - AddToCart - Pixel
Meta - Purchase - CAPI
Custom - Data Layer Push - Cart Update
```

**Full Examples**:
```
✅ GA4 - Purchase - Web
✅ Meta - ViewContent - CAPI
✅ Google Ads - Conversion - Purchase
✅ Custom - Event ID Generator

❌ Google Analytics Tag (not specific)
❌ Tag 1 (not descriptive)
❌ Purchase (missing platform)
```

### GTM Trigger Names

**Pattern**:
```
{event_type} - {condition}

Examples:
Custom Event - add_to_cart
Page View - Product Detail Page
Click - Add to Cart Button
Form Submit - Checkout Form
```

**Full Examples**:
```
✅ Custom Event - purchase
✅ Page View - Homepage
✅ Click - CTA Button
✅ DOM Ready - All Pages

❌ Trigger1 (not descriptive)
❌ add to cart (inconsistent format)
❌ atc (too abbreviated)
```

---

## Folder Naming Conventions

**Rules**:
- All lowercase
- Use underscores for spaces
- Descriptive purpose
- No version numbers in folder names

**Examples**:
```
✅ containers/
✅ client_config/
✅ methodology/
✅ platforms/
✅ analysis_outputs/
✅ test_results/

❌ Containers/ (capitalized)
❌ client-config/ (use underscores)
❌ temp/ (not descriptive)
❌ folder1/ (not descriptive)
```

---

## Version Control Best Practices

### Git Commit Messages

**Format**:
```
{type}: {description}

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- refactor: Code refactoring
- test: Testing
- chore: Maintenance

Examples:
feat: Add Shopify platform knowledge
fix: Correct product ID mapping in WooCommerce
docs: Update naming convention guide
refactor: Reorganize container folder structure
```

### Branch Naming

**Format**:
```
{type}/{description}

Examples:
feature/add-magento-support
bugfix/event-id-mismatch
docs/update-readme
analysis/client-acme-2024-11
```

---

## File Organization Summary

### Complete Structure with Naming

```
gtm_debug_framework/
│
├── README.md
├── QUICK_START.md
├── FRAMEWORK_OVERVIEW.md
├── NAMING_CONVENTION.md          ← This file
├── CHANGELOG.md                  ← Track changes
├── CLAUDE_CODE_INSTRUCTIONS.md
│
├── methodology/
│   ├── 01_core_debugging_process.md
│   ├── 02_data_consistency_rules.md
│   └── 03_meta_event_id_guide.md
│
├── platforms/
│   ├── _PLATFORM_TEMPLATE.md
│   ├── wordpress_woocommerce.md
│   ├── shopify.md
│   └── magento.md
│
├── client_config/
│   ├── CLIENT_CONFIG_TEMPLATE.md
│   ├── client_specific.md        ← Active config
│   └── clientname_config_20251111.md  ← Archived version
│
├── containers/
│   ├── client_actual/
│   │   ├── production_web_20251111_v1.json
│   │   ├── production_server_20251111_v1.json
│   │   └── staging_web_20251110_v1.json
│   │
│   └── taggrs_recommended/
│       ├── taggrs_web_ecommerce_standard_20251101.json
│       ├── taggrs_server_ga4_meta_20251101.json
│       └── README.md
│
└── analysis_outputs/
    ├── 20251111_executive_summary_clientname.md
    ├── 20251111_technical_analysis_clientname.md
    ├── 20251111_issues_list_clientname.csv
    └── 20251111_fix_recommendations_clientname.md
```

---

## Quick Reference Cheat Sheet

### Container JSON Files
```
Client Actual:     {env}_{type}_{date}_{ver}.json
Taggrs Template:   taggrs_{type}_{template}_{date}.json

production_web_20251111_v1.json
taggrs_server_ga4_meta_20251101.json
```

### Analysis Reports
```
{date}_{type}_{client}.{ext}

20251111_executive_summary_acme.md
20251111_issues_list_webshop.csv
```

### Configuration Files
```
{client}_config_{date}.md

acme_corp_config_20251111.md
client_specific.md (active)
```

### GTM Elements
```
Variables:  {prefix} - {description}
Tags:       {platform} - {event} - {destination}
Triggers:   {event_type} - {condition}

DL - Product ID
GA4 - Purchase - Web
Custom Event - add_to_cart
```

---

## Naming Convention Validation

### Before Saving a File, Ask:

1. **Is it dated?** (if version-specific)
   - Container JSONs: ✅ YYYYMMDD
   - Analysis reports: ✅ YYYYMMDD
   - Platform knowledge: ❌ No date (updated in place)

2. **Is the type clear?**
   - Can you tell what it is from the name?
   - Is the container type specified? (web/server)

3. **Is the client/project identified?**
   - Client containers: ✅ Environment prefix
   - Analysis reports: ✅ Client name suffix
   - Templates: ❌ No client (reusable)

4. **Is versioning clear?**
   - Same-day updates: Increment version (v1, v2, v3)
   - Different days: New date

5. **Are you following the pattern?**
   - Check examples in this guide
   - Use underscores, not hyphens or spaces
   - Lowercase for files (except major docs)

---

## Common Mistakes to Avoid

### ❌ DON'T Do This:
```
Final_Version.json
client_container_latest.json
my_gtm_export.json
analysis_nov_2024.md
container (1).json
New Document.md
temp_file.json
```

### ✅ DO This Instead:
```
production_web_20251111_v1.json
production_server_20251111_v1.json
taggrs_web_ecommerce_20251101.json
20251111_executive_summary_acme.md
production_web_20251111_v2.json (if updated same day)
ANALYSIS_GUIDELINES.md
staging_web_20251110_v1.json
```

---

## Maintenance

### When to Update This Guide

- Adding new file types
- Changing folder structure
- Adding new platforms
- Client requests specific naming
- Team adopts new conventions

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-11 | Initial naming convention guide |

---

## Questions?

### "What if I have multiple clients?"

Use client identifier in filename:
```
client_acme_config_20251111.md
client_bigshop_config_20251111.md

Or use separate folders:
client_config/acme/
client_config/bigshop/
```

### "What if Taggrs updates templates?"

Keep dated versions:
```
taggrs_web_ecommerce_20251101.json (original)
taggrs_web_ecommerce_20251115.json (updated)
```

### "What about backup files?"

Use a `backups/` folder with same naming:
```
backups/
├── production_web_20251101_v1.json
└── production_web_20251105_v1.json
```

### "What if container IDs are important?"

Add as suffix before extension:
```
production_web_20251111_v1_GTM-ABC123.json
```

---

## Enforcement

### For Teams

1. **Code Review**: Check naming in PRs
2. **CI/CD**: Automated filename validation
3. **Documentation**: Reference this guide
4. **Onboarding**: Train new team members

### For Solo Work

1. **Checklist**: Review before committing
2. **Templates**: Use filename templates
3. **Consistency**: Stick to patterns

---

**Following these conventions makes your GTM debugging workflow organized, professional, and scalable!**

Last Updated: November 11, 2025  
Version: 1.0
