---
scope: shared
---

# Client GTM Configuration

> This is the technical configuration for GTM analysis. Fill this out completely.

## Client Identification

**Client ID**: [client_identifier]  
**Analysis Date**: [YYYY-MM-DD]  
**Configuration Version**: [1.0]

---

## Platform Configuration

### E-commerce Platform
**Platform**: [WordPress/WooCommerce, Shopify, Magento, Shoprenter, Unas, Other]  
**Version**: [Specific version number]  
**Theme**: [Theme name and version]  
**Hosting**: [Hosting provider, if relevant]

### Key Extensions/Plugins
1. **[Extension Name]** - [Version] - [Impact on tracking]
2. **[Extension Name]** - [Version] - [Impact on tracking]

---

## Container Files Location

### Client Actual Containers
**Location**: `clients/[client_id]/containers/actual/`  
**Latest Web Container**: [2025-11-15_production_web_v1.json]  
**Latest Server Container**: [2025-11-15_production_server_v1.json]

### Taggrs Recommended Templates
**Location**: `clients/[client_id]/containers/taggrs_recommended/`  
**Web Template**: [taggrs_web_ecommerce_20251101.json]  
**Server Template**: [taggrs_server_ga4_meta_20251101.json]

---

## Product Data Configuration

### Product ID Format
**What We Use**: [SKU / Product ID / Custom Format / Variant ID]  
**Format**: [Alphanumeric / Numeric / UUID / Other]  
**Example**: `[e.g., "SHIRT-001", "12345", "uuid-xxx"]`

**Variable Products**:
- Parent ID: `[example]`
- Variant ID: `[example]`

**Business Rule**: 
> [Explain which ID is used where - e.g., "We use parent SKU on listings, variant SKU everywhere else"]

### Product Name Format
**Character Limit**: [Unlimited / Truncated at X chars]  
**Special Characters**: [How handled]  
**Example**: `[e.g., "Blue Cotton T-Shirt"]`

### Price Configuration
**Price Type**: [Number / String]  
**Decimal Places**: [2 / Other]  
**Tax Inclusion**: [Includes Tax / Excludes Tax]  
**Currency**: [USD / EUR / HUF / Other]  
**Example Price**: `[e.g., 29.99 for $29.99 product]`

---

## Checkout Configuration

### Checkout Flow
**Number of Steps**: [1 (Single Page) / 2 / 3 / More]

**Events Per Step**:
- Cart: `[view_cart / begin_checkout]`
- Shipping: `[add_shipping_info]`
- Payment: `[add_payment_info]`
- Complete: `[purchase]`

### Guest Checkout
**Allowed**: [Yes / No]  
**User ID Tracking**: [Available / Not implemented]

---

## Meta/Facebook Configuration

### Event ID Implementation
**Generation Method**: [UUID / Timestamp / Other]  
**Generated Where**: [Client JS / GTM Variable / Data Layer]  
**Storage**: [Data Layer / Cookie / sessionStorage]  
**Transfer to Server**: [Event data / Cookie / URL param]

**Client Variable**: `[variable name]`  
**Server Variable**: `[variable name]`

---

## Google Analytics Configuration

### GA4 Setup
**Measurement ID**: [G-XXXXXXXXXX]  
**Events Tracked**:
- [x] page_view
- [x] view_item_list
- [x] view_item
- [x] add_to_cart
- [x] begin_checkout
- [x] purchase
- [ ] Other: `[list]`

---

## Custom Variables & Modifications

### Custom Data Layer Variables
```javascript
{
  event: 'add_to_cart',
  ecommerce: { ... },
  // CUSTOM fields:
  custom_field_1: '[description]',
  custom_field_2: '[description]'
}
```

### Custom Events
- `[event_name]` - [When it fires, what it tracks]

---

## Known Issues & Customizations

### Known Issues
1. **[Issue]** - Priority: [P0/P1/P2] - Status: [Open/Fixed]

### Intentional Deviations
> [Document any intentional differences from standard implementation]

---

## Testing Information

### Test Products
1. **Simple Product**
   - Name: [Product Name]
   - ID/SKU: [SKU-123]
   - URL: [Direct link]

2. **Variable Product** (if applicable)
   - Name: [Product Name]
   - Variants: [List]
   - URL: [Direct link]

---

**Last Updated**: [YYYY-MM-DD]  
**Updated By**: [Your name]
