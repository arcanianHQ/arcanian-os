---
scope: shared
---

# Claude Code Instructions: GTM Debugging Framework

## Overview
This is the main entry point for debugging GTM implementations. This framework uses a layered approach combining universal methodology, platform-specific knowledge, and client-specific configuration.

## Step 1: Initialize and Load Context

### Task 1.1: Read Framework Structure
```
Read these files in order to understand the framework:
1. README.md (framework overview)
2. All files in methodology/ folder
3. Wait for platform identification before loading platform files
4. client_config/client_specific.md (last, contains overrides)
```

### Task 1.2: Identify the Platform
```
From client_config/client_specific.md, identify:
- E-commerce platform (WordPress/WooCommerce, Magento, Shopify, Shoprenter, Unas, or Other)
- Platform version
- Any relevant plugins/extensions

Then load the appropriate platform knowledge file:
- platforms/wordpress_woocommerce.md
- platforms/magento.md
- platforms/shopify.md
- platforms/shoprenter.md
- platforms/unas.md
```

### Task 1.3: Build Combined Knowledge Base
```
Create a mental model combining:
[Universal Methodology] + [Platform-Specific] + [Client-Specific]

Where conflicts exist, priority order is:
1. Client-Specific (highest priority - these are actual implementations)
2. Platform-Specific (medium priority - these are platform defaults)
3. Universal Methodology (base priority - general principles)
```

## Step 2: Pre-Analysis Setup

### Task 2.1: Locate Taggrs Templates
```
From client_config/client_specific.md, identify:
- taggrs_templates folder location
- Which files are client-side containers
- Which files are server-side containers
- Any custom templates or modifications

List all found files with:
- Filename
- Container type (client/server)
- Last modified date
- Purpose/description
```

### Task 2.2: Understand Client's Business Rules
```
From client_config/client_specific.md, document:
- Product ID format (SKU, variant ID, parent ID, custom format)
- Price rules (includes tax? currency? decimal places?)
- Custom data layer variables
- Special tracking requirements
- Known customizations
```

### Task 2.3: Create Analysis Context Document
```
Generate: analysis_context.md

Contents:
## Platform Information
- Platform: [identified platform]
- Version: [version]
- Key Extensions: [list]

## Client Business Rules
- Product ID format: [format]
- Price format: [format]
- Currency: [currency]
- Tax handling: [included/excluded]
- Custom variables: [list]

## Container Files
- Client-side: [path/filename]
- Server-side: [path/filename]
- Templates source: [location]

## Known Customizations
[List from client config]

## Platform-Specific Considerations
[Key points from platform knowledge file]
```

## Step 3: Execute Core Debugging Methodology

Now follow the debugging process from `methodology/01_core_debugging_process.md`, but apply it with:
- Platform-specific data layer expectations
- Client-specific business rules
- Client-specific variable names

### Task 3.1: Container Structure Analysis
For EACH container (client-side and server-side):

```
1. Parse JSON structure
2. Extract and categorize:
   - Tags (by type: GA4, Meta Pixel, Meta CAPI, custom)
   - Triggers (by event type)
   - Variables (by purpose: product data, event data, user data)

3. Create inventory:
   - Total tags: [count]
   - GA4 tags: [count]
   - Meta tags: [count]
   - Custom HTML tags: [count]
   - Total variables: [count]
   - Data layer variables: [count]
   - Custom JS variables: [count]

4. Map to platform expectations:
   - Does data layer structure match [platform] standards?
   - Are variable names following [platform] conventions?
   - Any platform-specific tags missing?
```

### Task 3.2: Product Data Flow Tracing
Apply the universal methodology BUT use platform-specific knowledge:

```
For the identified platform ([WordPress/Magento/Shopify/etc.]):

1. Expected product data structure on this platform:
   [Insert platform-specific structure from platforms/*.md]

2. Actual implementation in containers:
   [Extract from JSON files]

3. Comparison:
   - Matches platform standard: [Yes/No]
   - Deviations: [List]
   - Client customizations: [List]

4. Trace each product attribute through ALL events:

   Product ID:
   ├── PLP (Product List):
   │   ├── Client-side variable: [name]
   │   ├── Client-side value source: [data layer path]
   │   ├── Server-side receives: [how/from where]
   │   └── Consistency: [✓ / ✗ + explanation]
   ├── PDP (Product Detail):
   │   ├── Client-side variable: [name]
   │   ├── Client-side value source: [data layer path]
   │   ├── Server-side receives: [how/from where]
   │   └── Consistency: [✓ / ✗ + explanation]
   ├── Add to Cart:
   │   ├── Client-side variable: [name]
   │   ├── Client-side value source: [data layer path]
   │   ├── Server-side receives: [how/from where]
   │   └── Consistency: [✓ / ✗ + explanation]
   ├── Begin Checkout:
   │   └── [same structure]
   └── Purchase:
       └── [same structure]

   Repeat for:
   - Product Name
   - Product Price
   - Product Quantity
   - Product Category (if tracked)
   - Product Brand (if tracked)
```

### Task 3.3: Meta Event ID Verification
Apply methodology from `methodology/03_meta_event_id_guide.md`:

```
For each Meta event (ViewContent, AddToCart, InitiateCheckout, Purchase):

1. Client-side implementation:
   - Event ID generation method: [describe]
   - Where it's generated: [tag/variable name]
   - Storage method: [cookie/sessionStorage/dataLayer]
   - Format: [UUID/timestamp/custom]

2. Transfer to server-side:
   - How it's passed: [dataLayer/cookie/URL parameter]
   - Server-side variable that receives it: [name]
   - Any transformation: [Yes/No + details]

3. Server-side Meta CAPI tag:
   - Does it use the received event_id: [Yes/No]
   - Parameter name: [event_id / eventID / other]
   - Any regeneration happening: [Yes/No - RED FLAG if Yes]

4. Verification:
   [✓] Event ID generated once on client
   [✓] / [✗] Event ID passed to server unchanged
   [✓] / [✗] Server uses same event ID for CAPI
   [✓] / [✗] No regeneration occurs
   [✓] / [✗] Format is valid for Meta

   Issues found: [list any problems]
```

### Task 3.4: Platform-Specific Issue Detection
From `platforms/{identified_platform}.md`, check for common issues:

```
For [Platform Name]:

Common Issue Checklist:
[Insert platform-specific issues from the platform file]

For each issue:
[✓] Checked - Not present
[✗] FOUND - [Description of issue in this implementation]
[⚠] Potential - [Needs verification]

Example for WordPress/WooCommerce:
[✗] FOUND - Product IDs include "product-" prefix in client but not server
[✓] Checked - Price includes tax consistently
[⚠] Potential - Variable product parent ID vs variant ID usage unclear
```

## Step 4: Data Consistency Analysis

### Task 4.1: Create Cross-Event Consistency Matrix
```
Generate a table tracking each product attribute across all events:

| Attribute | PLP | PDP | Add to Cart | Begin Checkout | Purchase | Consistent? |
|-----------|-----|-----|-------------|----------------|----------|-------------|
| Product ID (Client) | [value/variable] | [value/variable] | [value/variable] | [value/variable] | [value/variable] | [✓/✗] |
| Product ID (Server) | [value/variable] | [value/variable] | [value/variable] | [value/variable] | [value/variable] | [✓/✗] |
| Product Name (Client) | ... | ... | ... | ... | ... | [✓/✗] |
| Product Name (Server) | ... | ... | ... | ... | ... | [✓/✗] |
| Product Price (Client) | ... | ... | ... | ... | ... | [✓/✗] |
| Product Price (Server) | ... | ... | ... | ... | ... | [✓/✗] |

Inconsistencies Found: [count]
Critical Issues: [list]
```

### Task 4.2: Create Client-Server Consistency Matrix
```
For each event type, compare client vs server:

| Event Type | Client Variable | Server Variable | Data Match | Issues |
|------------|----------------|-----------------|------------|--------|
| view_item_list | ecommerce.items[].item_id | server_items[].id | ✗ | Client uses SKU, server uses product-[SKU] |
| view_item | ecommerce.items[0].price | server_item.price | ✓ | Both use 2 decimal float |
| add_to_cart | ... | ... | ... | ... |

Total mismatches: [count]
```

## Step 5: Generate Platform & Client-Aware Reports

### Task 5.1: Executive Summary Report
```
Generate: EXECUTIVE_SUMMARY.md

# GTM Debugging Executive Summary

## Project Context
- Client: [from client config]
- Platform: [identified platform + version]
- Analysis Date: [date]
- Containers Analyzed: [count]

## Critical Findings
[P0 issues - data consistency breaks]

## High Priority Findings  
[P1 issues - potential tracking breaks]

## Summary Statistics
- Total issues found: [count]
- Data consistency issues: [count]
- Meta event ID issues: [count]
- Platform-specific issues: [count]
- Client customization issues: [count]

## Impact Assessment
- Revenue tracking accuracy: [affected/not affected]
- Meta CAPI deduplication: [working/broken]
- GA4 data quality: [good/poor/mixed]

## Next Steps
[Prioritized action items]
```

### Task 5.2: Detailed Technical Report
```
Generate: TECHNICAL_ANALYSIS.md

Structure:
1. Platform Analysis
   - Platform identified: [name]
   - Expected data structures: [from platform file]
   - Actual implementation: [from containers]
   - Deviations: [list with severity]

2. Container Structure Analysis
   - Complete tag inventory
   - Complete variable inventory
   - Trigger analysis
   - Custom code analysis

3. Product Data Consistency Analysis
   - Product ID tracing (full detail)
   - Product name tracing (full detail)
   - Product price tracing (full detail)
   - Cross-event consistency results

4. Meta Event ID Analysis
   - Event ID generation method
   - Transfer mechanism
   - Server-side handling
   - Deduplication status

5. Platform-Specific Issues
   - Issues from platform checklist
   - Client customization impacts
   - Integration quality assessment

6. Data Flow Diagrams
   [ASCII diagrams showing data flow]
```

### Task 5.3: Issues Database
```
Generate: ISSUES_DETAILED.csv

Columns:
- Issue_ID (unique identifier)
- Priority (P0/P1/P2/P3)
- Category (Product_ID/Price/Event_ID/Platform/Custom)
- Issue_Type (Consistency/Missing/Format/Logic)
- Location (Container + Tag/Variable name)
- Current_Behavior (what's happening)
- Expected_Behavior (what should happen)
- Platform_Standard (from platform file)
- Client_Rule (from client config)
- Impact (description)
- Affected_Events (list)
- Root_Cause (analysis)
- Recommended_Fix (specific instructions)
- Fix_Complexity (Easy/Medium/Hard)
- Testing_Steps (how to verify fix)

Sort by: Priority DESC, Impact DESC
```

### Task 5.4: Fix Recommendations with Platform Context
```
Generate: FIX_RECOMMENDATIONS.md

For each issue, provide:

## Issue #[ID]: [Short Description]

### Context
- Platform: [name]
- Affects: [client/server/both]
- Events: [list]

### Current Implementation
[Code/config excerpt showing the problem]

### Platform Standard
[What the platform normally does, from platform file]

### Client Business Rule
[Any client-specific requirement, from client config]

### Recommended Fix
[Specific, actionable fix that respects both platform and client rules]

### Implementation Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Code/Configuration Change
```json
// BEFORE
[current code]

// AFTER
[fixed code]
```

### Testing Verification
- [ ] GTM Preview shows [expected result]
- [ ] Server-side logs show [expected result]
- [ ] Data layer contains [expected values]
- [ ] Meta Events Manager shows [expected result]

### Risk Assessment
- Risk Level: [Low/Medium/High]
- Potential Side Effects: [list]
- Rollback Plan: [if needed]
```

### Task 5.5: Variable Mapping Documentation
```
Generate: VARIABLE_MAPPING.md

## Product ID Mapping

### Client-Side
- Variable Name: [name]
- Variable Type: [Data Layer / Custom JavaScript / etc]
- Source: [data layer path or JS code]
- Format: [description]
- Example Value: "[example]"

### Server-Side
- Variable Name: [name]
- Variable Type: [Event Data / Cookie / etc]
- Source: [how it receives data]
- Format: [description]
- Example Value: "[example]"

### Consistency Status
[✓] Formats match
[✗] Format mismatch: [details]
[⚠] Conditional logic creates variations: [details]

### Platform Standard
[What [Platform] typically uses]

### Client Customization
[Any client-specific handling]

[Repeat for all critical data points]
```

### Task 5.6: Testing Plan with Platform-Specific Steps
```
Generate: TESTING_PLAN.md

## Testing Environment Setup
- Platform: [name]
- Testing Site URL: [from client config]
- GTM Preview Links: [generated]
- Test Products: [IDs from client config or suggest generic ones]

## Platform-Specific Setup
[Insert platform-specific testing notes]
Example for Shopify: "Ensure test mode, use Shopify admin to verify product data"
Example for WooCommerce: "Check WooCommerce → Status → Logs for debug data"

## Test Cases

### TC1: Product List Page (PLP)
**Platform Context:** [How this platform handles product lists]

Pre-conditions:
- [ ] Navigate to category page with multiple products
- [ ] Open GTM Preview (client-side)
- [ ] Open browser DevTools → Console
- [ ] [Platform-specific prep steps]

Steps:
1. Load product listing page
2. Check data layer for view_item_list event
3. Verify product data structure matches [platform] standard
4. Check each product item has:
   - [ ] item_id: [expected format per client config]
   - [ ] item_name: [check for encoding]
   - [ ] price: [verify format per client config]
5. Check server-side container receives data
6. Compare client vs server product data

Expected Results:
- Client data layer: [specific structure]
- Server receives: [specific structure]
- Match: [✓]

[Continue for all test cases: PDP, Add to Cart, Checkout, Purchase]

### TC-Meta: Event ID Deduplication Test
[Specific steps to verify event_id matching]

## Regression Testing
[After fixes, retest all scenarios]

## Sign-off Checklist
- [ ] All P0 issues resolved
- [ ] All P1 issues resolved or documented exceptions
- [ ] Data consistency verified across all events
- [ ] Meta event IDs matching correctly
- [ ] Platform-specific requirements met
- [ ] Client-specific requirements met
- [ ] Documentation updated
```

## Step 6: Client Communication Materials

### Task 6.1: Non-Technical Summary
```
Generate: CLIENT_SUMMARY.md

Write in plain language for non-technical stakeholders:

# GTM Implementation Review Summary

## What We Checked
[Explain in business terms]

## What We Found
[Issues explained without jargon]

## What This Means for Your Business
[Impact on conversion tracking, ad performance, attribution]

## What We Recommend
[Prioritized fixes with business justification]

## Timeline and Effort
[Estimated time for fixes]
```

## Step 7: Continuous Improvement

### Task 7.1: Update Platform Knowledge
```
If you discover platform behaviors not documented in platforms/*.md:

1. Note them in a section called "Additional Findings"
2. Suggest updates to the platform knowledge file
3. Document for future reference
```

### Task 7.2: Update Client Configuration
```
If client implementation differs from documentation:

1. Note discrepancies
2. Generate updated client_config/client_specific.md
3. Highlight what changed
```

## Output Checklist

By the end of analysis, these files should exist:

### Analysis Phase
- [ ] analysis_context.md (your understanding of context)
- [ ] container_inventory.md (all tags/variables/triggers)
- [ ] data_flow_diagrams.md (visual representations)

### Reports
- [ ] EXECUTIVE_SUMMARY.md (high-level for stakeholders)
- [ ] TECHNICAL_ANALYSIS.md (detailed findings)
- [ ] ISSUES_DETAILED.csv (structured issue list)
- [ ] FIX_RECOMMENDATIONS.md (actionable fixes)
- [ ] VARIABLE_MAPPING.md (complete data flow documentation)
- [ ] TESTING_PLAN.md (verification procedures)
- [ ] CLIENT_SUMMARY.md (non-technical summary)

### Optional
- [ ] CODE_SNIPPETS/ folder (with fixed code examples)
- [ ] BEFORE_AFTER_COMPARISON.md (visual diff of changes)

## Important Principles

1. **Always Load Context First**: Read methodology → platform → client config
2. **Platform Standards Are Defaults**: Client customizations override platform standards
3. **Be Specific**: Use actual variable names, not placeholders
4. **Show Your Work**: Include evidence (code excerpts, JSON paths)
5. **Respect Client Rules**: Their business logic takes precedence
6. **Think Holistically**: Product ID consistency affects attribution across all platforms
7. **Event ID Is Critical**: For Meta CAPI, event_id matching is non-negotiable
8. **Document Assumptions**: If you infer something, state the assumption

## Error Handling

If you encounter:
- **Unknown platform**: Use universal methodology only, note platform as "Custom"
- **Missing client config**: Ask for essential information before proceeding
- **Conflicting information**: Client config > Platform > Methodology (priority order)
- **Incomplete Taggrs templates**: Note what's missing, analyze what exists

## Next Steps After Analysis

1. Review all generated reports
2. Validate findings with client
3. Prioritize fixes based on business impact
4. Implement fixes with testing
5. Document final state
6. Update framework if needed

---

**Start by loading all context files, then proceed systematically through each step.**
**Your goal: Identify every data consistency issue with platform and client context.**
