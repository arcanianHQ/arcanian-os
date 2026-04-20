---
scope: shared
---

# Client Configuration Template

> Fill in this template with your specific implementation details. This file provides context that overrides platform defaults.

## Client Information

**Client Name**: [Company/Project Name]  
**Website URL**: [Production URL]  
**Staging URL** (if different): [Staging URL]  
**Analysis Date**: [Date]  
**Analyst**: [Your Name/Team]

## Platform Configuration

### E-commerce Platform
**Platform**: [WordPress/WooCommerce, Shopify, Magento, Shoprenter, Unas, Other]  
**Version**: [Specific version number]  
**Theme**: [Theme name and version]  
**Hosting**: [Hosting provider, if relevant]

### Key Extensions/Plugins Installed
List any extensions that might affect tracking:

1. **[Extension Name]** - [Version] - [Purpose/Impact on tracking]
2. **[Extension Name]** - [Version] - [Purpose/Impact on tracking]
3. **[Extension Name]** - [Version] - [Purpose/Impact on tracking]

## GTM Implementation Details

### Container Information

#### Client-Side Container
**Container ID**: [GTM-XXXXXXX]  
**Implementation Method**: [Direct/Via Plugin/Custom]  
**Location in Code**: [Where GTM snippet is placed]

#### Server-Side Container
**Container URL**: [Your server-side GTM URL]  
**Container ID**: [GTM-YYYYYYY]  
**Hosting**: [Google Cloud / Custom / Taggrs / Other]  
**Taggrs Integration**: [Yes / No]

### Taggrs Configuration
**Using Taggrs**: [Yes / No]  
**Template Folder Location**: `[path/to/taggrs_templates]`  
**Template Files**:
- Client Container: `[filename.json]`
- Server Container: `[filename.json]`
- [Any other relevant files]

**Last Template Update**: [Date]  
**Taggrs Contact**: [Contact person/email if applicable]

## Product Data Configuration

### Product ID Format

**What We Use**: [SKU / Product ID / Custom Format / Variant ID]  
**Format**: [Alphanumeric / Numeric / UUID / Other]  
**Example Product IDs**:
- Simple Product: `[example: "SHIRT-001"]`
- Variable Product (if applicable): 
  - Parent: `[example: "SHIRT-001"]`
  - Variant: `[example: "SHIRT-001-RED-M"]`

**Business Rule**: 
> [Explain which ID is used where - e.g., "We use parent SKU on listings, variant SKU everywhere else" or "We always use variant SKU even on listings"]

**Known Issues/Exceptions**:
- [Any products without SKUs? How are they handled?]
- [Any special cases?]

### Product Name Format

**Character Limit**: [Unlimited / Truncated at X chars / Varies]  
**Special Characters**: [How are they handled - e.g., "HTML entities decoded", "Kept as-is"]  
**Examples**:
- Standard Product: `[example: "Blue Cotton T-Shirt"]`
- Product with Special Chars: `[example: "Men's 12\" Widget™"]`

### Price Configuration

**Price Type in Data Layer**: [Number / String]  
**Decimal Places**: [2 / Other]  
**Tax Inclusion**: [Includes Tax / Excludes Tax]  
**Currency**: [USD / EUR / HUF / Other]  
**Multiple Currencies**: [Yes / No]

**Example Prices**:
```
Product A: 
- Database/Listed Price: $29.99
- Tax: $4.50 (15%)
- Total with Tax: $34.49
- What data layer sends: [specify which value]

Product B (if on sale):
- Regular Price: $50.00
- Sale Price: $35.00  
- What data layer sends: [specify which value]
```

**Tax Configuration**:
> [Explain exactly how tax is handled: "All prices in data layer include 27% VAT" or "Prices exclude tax, tax calculated at checkout"]

## Checkout Configuration

### Checkout Flow
**Number of Steps**: [1 (Single Page) / 2 / 3 / More]  
**Step Descriptions**:
1. [Step 1 name - e.g., "Cart Review"]
2. [Step 2 name - e.g., "Shipping Info"]
3. [Step 3 name - e.g., "Payment"]

### Events Per Step
**Which events fire at each step**:

```
Step 1 (Cart):
- view_cart [Yes / No]
- begin_checkout [Yes / No / Sometimes]

Step 2 (Shipping):
- add_shipping_info [Yes / No]

Step 3 (Payment):
- add_payment_info [Yes / No]

Complete (Thank You Page):
- purchase [Yes / No]
- [Any custom events]
```

### Guest Checkout
**Allowed**: [Yes / No]  
**User ID Tracking**: [Available for logged-in users only / Not implemented / Other]

## Custom Variables & Modifications

### Custom Data Layer Variables
List any custom variables not in standard e-commerce spec:

```javascript
{
  event: 'add_to_cart',
  // Standard fields
  ecommerce: { ... },
  // CUSTOM fields below:
  custom_field_1: '[description - e.g., membership_tier]',
  custom_field_2: '[description]',
  // ... etc
}
```

### Custom Events
**Non-standard events tracked**:
- `[event_name]` - [When it fires, what it tracks]
- `[event_name]` - [When it fires, what it tracks]

### Custom Transformations
**Any custom logic that modifies data**:

Example:
```
Product IDs are uppercase in database but we send lowercase to GTM:
- Database: "SHIRT-001"
- Data Layer: "shirt-001"
```

## Meta/Facebook Configuration

### Pixel Setup
**Pixel ID**: [123456789012345]  
**Installed via**: [GTM / Direct Code / Plugin]

### Event ID Implementation
**How event_id is generated**:
- Method: [UUID / Timestamp-based / Other]
- Where: [Client-side JS / GTM Variable / Data Layer]
- Variable Name: `[variable name in GTM]`

**Storage Method**: [Data Layer / Cookie / sessionStorage]  
**Cookie Name** (if using cookie): `[cookie_name]`

**Server-Side Event ID**:
- How passed to server: [Event data / Cookie / URL param]
- Server variable name: `[variable name in server GTM]`

## Google Analytics Configuration

### GA4 Property
**Measurement ID**: [G-XXXXXXXXXX]  
**Property Name**: [Property name for reference]  
**Data Stream**: [Web / iOS / Android - specify which]

### GA4 Events
**Standard E-commerce Events Tracked**:
- [ ] page_view
- [ ] view_item_list
- [ ] view_item
- [ ] add_to_cart
- [ ] remove_from_cart
- [ ] begin_checkout
- [ ] add_shipping_info
- [ ] add_payment_info
- [ ] purchase

**Custom GA4 Events**:
- `[event_name]` - [Description]

## Known Issues & Customizations

### Known Issues
Document any known problems:

1. **[Issue Description]**
   - Affects: [Which events/features]
   - Workaround: [Current workaround if any]
   - Priority: [P0/P1/P2/P3]

2. **[Issue Description]**
   - [Details]

### Intentional Deviations from Standard
Document any intentional differences from standard implementation:

**Example:**
> "We intentionally send parent SKU for variable products everywhere, including cart and purchase. This is because our reporting focuses on product lines, not individual variants."

### Custom Code Locations
**Where custom tracking code is located**:
- [ ] Theme files: [Specific files]
- [ ] Child theme: [files]
- [ ] Custom plugin: [plugin name]
- [ ] GTM Custom HTML tags: [tag names]
- [ ] Other: [specify]

## Testing Information

### Test Products
**Products to use for testing** (provide real examples from your store):

1. **Simple Product**
   - Name: [Product Name]
   - ID/SKU: [SKU-123]
   - Price: [$29.99]
   - URL: [Direct link]

2. **Variable Product** (if applicable)
   - Name: [Product Name]
   - Parent ID: [SKU-100]
   - Variant IDs: [SKU-100-RED-S, SKU-100-RED-M]
   - URL: [Direct link]

3. **Special Case Product** (edge case for testing)
   - Name: [Product with special chars or unique attributes]
   - ID/SKU: [SKU-SPECIAL]
   - Why special: [e.g., "Has special characters", "Very high price"]
   - URL: [Direct link]

### Test Payment Methods
**For completing test purchases**:
- [ ] Test credit card: [Card number if safe to share]
- [ ] Test gateway: [e.g., "Stripe test mode"]
- [ ] Test coupon codes: [TESTCODE10]
- [ ] Other test methods: [specify]

### Access Credentials
**For testing/debugging purposes**:

⚠️ **Security Note**: If including credentials, use a secure method!

- Admin Panel: [URL] - [username] - [Use password manager]
- GTM Access: [GTM account/container - specify permission level needed]
- GA4 Access: [GA4 property - specify permission level needed]
- Meta Events Manager: [Access details]

## Business Rules & Requirements

### Critical Requirements
**Must-have requirements for tracking**:

1. [Requirement 1 - e.g., "Product IDs must match our ERP system"]
2. [Requirement 2 - e.g., "Revenue must include tax for reporting"]
3. [Requirement 3]

### Data Privacy & Compliance
**Privacy Configuration**:
- GDPR Compliance: [Yes / No / N/A]
- Cookie Consent: [Tool used - e.g., "CookieYes"]
- Consent Mode: [Implemented / Not Implemented]
- PII Handling: [Rules about personal information]

### Reporting Requirements
**How data will be used**:
- Primary use case: [e.g., "ROAS calculation for Meta ads"]
- Key metrics: [e.g., "Revenue, transaction count, product-level performance"]
- Stakeholders: [e.g., "Marketing team, Finance"]

## Historical Context

### Previous Implementation
**What was here before** (if applicable):
- Previous system: [e.g., "Universal Analytics"]
- Migration date: [Date]
- Known migration issues: [Any data consistency issues from migration]

### Changes Made
**Recent changes to tracking**:

| Date | Change | Reason | Impact |
|------|--------|--------|---------|
| [Date] | [What changed] | [Why] | [Effect on tracking] |
| [Date] | [What changed] | [Why] | [Effect on tracking] |

## Contact Information

### Technical Contacts
**Who to contact for questions**:

- **Website Development**: [Name] - [Email]
- **GTM Management**: [Name] - [Email]  
- **Analytics**: [Name] - [Email]
- **Marketing/Ads**: [Name] - [Email]

### Vendor Contacts
**External partners**:

- **Taggrs**: [Contact name/email if applicable]
- **Agency**: [Agency name/contact if applicable]
- **Platform Support**: [Relevant support contacts]

## Additional Notes

**Any other relevant information**:

[Free-form notes about unique aspects of this implementation, special considerations, upcoming changes, etc.]

---

## Instructions for Claude Code

**Priority Rules**:
1. Information in this file **overrides** platform defaults
2. If something is explicitly stated here, trust this over general platform knowledge
3. If something is unclear or conflicting, flag it for clarification

**Critical Fields to Verify**:
- Product ID format and consistency
- Tax inclusion in prices
- Event ID generation and transfer method (for Meta)
- Currency configuration
- Custom variables and transformations

**How to Use This File**:
1. Read this FIRST to understand client context
2. Load relevant platform file based on platform specified here
3. Apply platform knowledge, but override with client-specific rules
4. Flag any conflicts or unclear configurations
5. Use test products listed here for validation

Last Updated: [Date]
