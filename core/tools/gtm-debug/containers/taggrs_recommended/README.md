---
scope: shared
---

# Taggrs Recommended Containers

## Purpose

This folder contains **Taggrs' recommended/template GTM container JSON files** - the baseline configurations that Taggrs provides as best practice implementations.

These serve as reference templates and comparison points when analyzing your actual containers.

---

## What Goes Here

### Template Types

**Standard E-commerce Templates:**
- Generic e-commerce tracking setup
- GA4 + Meta Pixel + Meta CAPI standard configuration
- Best practices for product tracking

**Platform-Specific Templates:**
- WooCommerce optimized containers
- Shopify optimized containers
- Magento optimized containers
- Custom platform templates

**Client-Customized Templates:**
- Templates customized for your specific needs
- Configurations provided by Taggrs consultant
- Updated versions of standard templates

---

## Source of These Files

### Where They Come From

1. **Taggrs Consultant**
   - Provided during onboarding
   - Sent via email or file sharing
   - Part of Taggrs service package

2. **Taggrs Documentation**
   - Downloaded from Taggrs portal
   - Part of implementation guides
   - Reference materials

3. **Custom Templates**
   - Created by Taggrs for your project
   - Based on your platform and requirements
   - May include custom variables/tags

---

## Naming Convention

**Format:**
```
taggrs_{container_type}_{template_name}_{date}.json
```

**Components:**
- `taggrs_`: Prefix to identify as Taggrs template
- `container_type`: web | server
- `template_name`: Description of template purpose
- `date`: YYYYMMDD when received from Taggrs

**Examples:**
```
✅ taggrs_web_ecommerce_standard_20251101.json
✅ taggrs_server_ga4_meta_capi_20251101.json
✅ taggrs_web_woocommerce_custom_20251015.json
✅ taggrs_server_woocommerce_custom_20251015.json
```

See `NAMING_CONVENTION.md` for complete guide.

---

## Typical Setup

Most clients will receive **2 template containers**:

```
containers/taggrs_recommended/
├── taggrs_web_ecommerce_standard_20251101.json      (client-side)
└── taggrs_server_ga4_meta_20251101.json             (server-side)
```

Platform-specific setups:
```
containers/taggrs_recommended/
├── taggrs_web_woocommerce_custom_20251015.json
├── taggrs_server_woocommerce_custom_20251015.json
└── taggrs_documentation_20251015.pdf                (if provided)
```

---

## How Claude Code Uses These Files

### Comparison & Validation

1. **Baseline Comparison**
   - Compare your actual containers vs Taggrs templates
   - Identify deviations from best practices
   - Highlight missing tags or variables

2. **Best Practice Verification**
   - Check if recommended tags are implemented
   - Verify variable naming follows Taggrs conventions
   - Confirm proper trigger setup

3. **Gap Analysis**
   - Find tags present in template but missing in actual
   - Find custom tags not in template (may need review)
   - Identify configuration differences

4. **Documentation**
   - Use template structure in reports
   - Reference template as "correct" configuration
   - Explain deviations in analysis

---

## Version Management

### When Taggrs Updates Templates

Keep both versions for reference:
```
containers/taggrs_recommended/
├── taggrs_web_ecommerce_20251101.json    (original)
├── taggrs_web_ecommerce_20251115.json    (updated)
└── taggrs_changelog_20251115.txt         (notes on changes)
```

### Tracking Template Evolution
```
taggrs_web_ecommerce_20251001.json  (Oct 1 - initial)
taggrs_web_ecommerce_20251015.json  (Oct 15 - bug fix)
taggrs_web_ecommerce_20251101.json  (Nov 1 - new features)
```

---

## Important Notes

### These Are Templates, Not Your Containers

⚠️ **Don't confuse these with your actual containers!**

| Taggrs Templates | Your Actual Containers |
|------------------|------------------------|
| Folder: `containers/taggrs_recommended/` | Folder: `containers/client_actual/` |
| Reference/Baseline | Currently deployed |
| From Taggrs | Exported from your GTM |
| May not match exactly | Your real implementation |
| Starting point | What's actually running |

### Templates May Contain Placeholders

Taggrs templates might have:
- Placeholder IDs (e.g., "YOUR-GA4-ID-HERE")
- Generic variable names
- Example values
- Comments/notes

Your actual containers should have:
- Real measurement IDs
- Specific variable names
- Actual data values
- Client-specific customizations

---

## What to Include

### Minimum Files
At minimum, include:
```
✅ Web container template (client-side)
✅ Server container template (server-side)
```

### Optional Files
If provided by Taggrs:
```
✅ Documentation PDFs
✅ Implementation guides
✅ Change logs
✅ Custom scripts
✅ Configuration notes
```

---

## When to Update

### Update These Files When:

1. **Taggrs Provides New Version**
   - New template released
   - Bug fixes issued
   - Feature updates

2. **Platform Updates**
   - WooCommerce updates require new template
   - GA4 changes necessitate updates
   - Meta API changes

3. **Client Requirements Change**
   - New tracking requirements
   - Custom implementations
   - Additional platforms

---

## Using Templates for Implementation

### If Starting Fresh

1. **Import Template to GTM**
   - GTM → Admin → Import Container
   - Select Taggrs template file
   - Choose "New" workspace

2. **Customize**
   - Replace placeholders with real IDs
   - Adjust variables for your platform
   - Add client-specific tags

3. **Test**
   - Use GTM Preview mode
   - Verify all tracking works
   - Test across all pages

4. **Publish**
   - Create version
   - Publish to production
   - Export actual container to `client_actual/`

---

## Comparison Workflow

### How to Compare Template vs Actual

1. **Visual Comparison**
   - Open both JSON files
   - Use diff tool (VS Code, Beyond Compare, etc.)
   - Identify differences

2. **Claude Code Analysis**
   - Reference both folders in analysis
   - Claude Code compares automatically
   - Generates deviation report

3. **Manual Review**
   - Tag count differences
   - Variable naming differences
   - Missing or extra components

---

## Security Note

⚠️ **Taggrs templates may be proprietary:**
- Intellectual property of Taggrs
- Licensed for your use
- Don't share publicly without permission
- Respect Taggrs terms of service

**If using Git:**
```gitignore
# .gitignore - if templates are proprietary
containers/taggrs_recommended/*.json
```

Or keep them if open for your team:
```gitignore
# Keep templates in repo for team reference
!containers/taggrs_recommended/*.json
```

---

## Checklist

Before analysis, ensure:

- [ ] Template files received from Taggrs
- [ ] Files named according to convention
- [ ] Both web and server templates included
- [ ] Files placed in `containers/taggrs_recommended/`
- [ ] Documentation included (if provided)
- [ ] Date reflects when received
- [ ] Know which version you have (if multiple exist)

---

## Common Questions

### "I don't have Taggrs templates"
If you're not using Taggrs:
- This folder is optional
- Analysis will focus on your actual containers only
- No baseline comparison performed

### "My Taggrs consultant didn't provide JSON files"
Ask your consultant for:
- Template container exports
- Reference configurations
- Implementation guides

### "Templates don't match my platform"
- Taggrs may customize per platform
- Request platform-specific templates
- Generic templates can still be useful reference

### "Should I modify these files?"
No! These are reference templates:
- Keep original templates intact
- Make changes in your actual GTM containers
- Export your customized containers to `client_actual/`

---

## Example Structure

### Complete Setup
```
containers/
│
├── client_actual/                        (Your actual containers)
│   ├── production_web_20251111_v1.json
│   └── production_server_20251111_v1.json
│
└── taggrs_recommended/                   (Taggrs templates)
    ├── taggrs_web_ecommerce_20251101.json
    ├── taggrs_server_ga4_meta_20251101.json
    ├── taggrs_implementation_guide_20251101.pdf
    └── README.md (this file)
```

---

## Getting Taggrs Templates

### If You Don't Have Them

1. **Contact Your Taggrs Consultant**
   - Email: [your consultant's email]
   - Request: Latest template containers
   - Specify: Your platform (WooCommerce, Shopify, etc.)

2. **Check Taggrs Portal**
   - May be available for download
   - Documentation section
   - Resources area

3. **Review Onboarding Materials**
   - May have been provided initially
   - Check emails from Taggrs
   - Look in shared folders

---

## Need Help?

- **Don't have templates**: Contact Taggrs
- **Naming questions**: See `NAMING_CONVENTION.md`
- **Comparison questions**: See `QUICK_START.md`
- **Template questions**: Ask Taggrs consultant

---

**Ready to analyze?** Place your Taggrs templates here, then proceed with container analysis!

Last Updated: November 11, 2025
