---
scope: shared
---

# Platform Template - [PLATFORM NAME]

> Copy this template when adding a new platform. Replace all [PLACEHOLDERS] with platform-specific information.

## Platform Overview

**Platform Name**: [e.g., WordPress/WooCommerce, Magento, Shopify, etc.]  
**Version Coverage**: [e.g., WooCommerce 5.0+, Magento 2.4+]  
**Market**: [e.g., Global, Primarily Hungarian market (Shoprenter, Unas)]  
**Typical Use Cases**: [Small business, Enterprise, etc.]

## Platform-Specific Data Layer

### Standard Data Layer Events

[Platform] typically implements these e-commerce events:

```javascript
// Example: Product Page View
dataLayer.push({
  event: '[event_name]',
  ecommerce: {
    // Platform-specific structure
  }
});
```

List all standard events:
- [ ] Page View
- [ ] Product List View (view_item_list)
- [ ] Product Detail View (view_item)
- [ ] Add to Cart (add_to_cart)
- [ ] Remove from Cart (remove_from_cart)
- [ ] Begin Checkout (begin_checkout)
- [ ] Purchase (purchase)
- [ ] [Any platform-specific events]

### Data Layer Structure by Page Type

#### Product Listing Page (PLP)
```javascript
// Expected structure on [Platform]
dataLayer.push({
  event: 'view_item_list',
  ecommerce: {
    items: [{
      item_id: '[explain format]',
      item_name: '[explain format]',
      // ... all fields
    }]
  }
});
```

#### Product Detail Page (PDP)
```javascript
// Expected structure on [Platform]
dataLayer.push({
  event: 'view_item',
  ecommerce: {
    items: [{
      item_id: '[explain format]',
      item_name: '[explain format]',
      price: '[number or string?]',
      // ... all fields
    }]
  }
});
```

#### Cart Events
```javascript
// Add to cart structure
```

#### Checkout Events
```javascript
// Begin checkout structure
```

#### Purchase Event
```javascript
// Purchase structure
```

## Product ID Standards

### Default Product ID Format
**Format**: [e.g., "Numeric ID", "Alphanumeric SKU", "UUID"]  
**Type**: [e.g., String, Number]  
**Example**: [e.g., "12345", "SKU-ABC-123", "550e8400-e29b-41d4-a716-446655440000"]

### Variant Handling
**How variants are identified**:
- [ ] Separate variant ID
- [ ] Parent ID + variant attributes
- [ ] Single combined ID
- [ ] [Other approach]

**Example**:
```
Parent Product: T-Shirt (ID: 100)
Variants:
- Red, Small: [How is this identified?]
- Red, Medium: [How is this identified?]
- Blue, Small: [How is this identified?]
```

### Common ID Issues on This Platform
1. [Issue 1 - e.g., "Parent ID sent on listing, variant ID on detail page"]
2. [Issue 2]
3. [Issue 3]

## Price Handling

### Default Price Format
**Type**: [Number or String]  
**Decimal Places**: [2, 4, varies]  
**Tax Inclusion**: [Includes tax / Excludes tax / Configurable]  
**Currency Symbol**: [Included or Separate]

**Example**:
```javascript
// Product price: $29.99 USD with tax
dataLayer: {
  price: 29.99,  // or "29.99" or "$29.99" - document which
  currency: 'USD'
}
```

### Tax Configuration
**Default Behavior**: [Tax included by default / excluded by default]  
**Admin Setting Location**: [Where to find this setting in admin]  
**Impact on Tracking**: [Explain how tax settings affect data layer values]

### Multiple Currencies
**Support**: [Yes / No / Limited]  
**Implementation**: [How multi-currency is handled]

## Product Name Handling

### Character Limits
**Listing Page**: [e.g., Unlimited, 100 chars, varies by theme]  
**Detail Page**: [e.g., Unlimited]  
**Data Layer**: [e.g., Full name always sent]

### Special Characters
**Encoding**: [UTF-8, may have issues with...]  
**HTML**: [HTML tags in name / Plain text only]  
**Common Issues**: [e.g., "Trademark symbols stripped", "Quotes escaped incorrectly"]

## Checkout Flow

### Number of Checkout Steps
**Standard Configuration**: [e.g., Single page / Multi-step (3 steps) / Customizable]

**Steps**:
1. [Step 1 - e.g., "Cart Review"]
2. [Step 2 - e.g., "Shipping Information"]
3. [Step 3 - e.g., "Payment"]

### Events Fired Per Step
```
Step 1 (Cart): [Which events fire?]
Step 2 (Shipping): [Which events fire?]
Step 3 (Payment): [Which events fire?]
Complete (Purchase): [Which events fire?]
```

### Guest vs Registered Checkout
**Differences in Tracking**: [Any differences in how data is tracked?]  
**User ID Handling**: [How user_id is available or not]

## Extensions & Plugins

### Commonly Used Extensions That Affect Tracking

#### Extension 1: [Name]
**What it does**: [Description]  
**Impact on GTM**: [How it changes data layer, adds events, etc.]  
**Compatibility Issues**: [Any known conflicts]

#### Extension 2: [Name]
**What it does**: [Description]  
**Impact on GTM**: [How it changes data layer]

### GTM-Specific Extensions

List any popular GTM integration plugins for this platform:
- [Extension name + link]
- [Extension name + link]

**Recommendation**: [Use extension / Manual implementation / Depends on...]

## Platform-Specific Variables

### Built-In Data Layer Variables
[Platform] provides these in its default data layer:

- `[variable_name]`: [Description, data type, when available]
- `[variable_name]`: [Description]
- `[variable_name]`: [Description]

### Server-Side Data

Data available server-side (for server GTM):
- [Data point 1]: [How to access]
- [Data point 2]: [How to access]

## Common Issues on This Platform

### Issue 1: [Issue Title]
**Severity**: [P0 / P1 / P2 / P3]  
**Description**: [What happens]  
**Symptoms**: [How to detect]  
**Cause**: [Why it happens]  
**Fix**: [How to resolve]  
**Affected Versions**: [Which versions have this issue]

### Issue 2: [Issue Title]
[Same structure as above]

### Issue 3: [Issue Title]
[Same structure as above]

## Platform-Specific Testing

### Required Test Products
**Type of Products Needed**:
- [ ] Simple product
- [ ] Product with variants
- [ ] Grouped product (if supported)
- [ ] Bundle (if supported)
- [ ] Downloadable/Virtual product
- [ ] Product with special characters in name
- [ ] Product with very low price (e.g., $0.01)
- [ ] Product with high price (e.g., $9,999.99)

### Platform-Specific Test Scenarios

#### Scenario 1: [Scenario Name]
**Setup**: [How to set up this test]  
**Steps**: [What to do]  
**Expected**: [What should happen in data layer]  
**Common Failure**: [What often goes wrong]

#### Scenario 2: [Scenario Name]
[Same structure]

### Debug Mode / Test Mode
**How to Enable**: [Steps to enable platform's debug mode if available]  
**Where to Find Logs**: [Admin location or file location]  
**Useful Debug Tools**: [Any platform-specific debug tools]

## Admin Panel Reference

### Where to Find Key Settings

**Product Settings**: [Admin path]  
**Tax Settings**: [Admin path]  
**Checkout Settings**: [Admin path]  
**Currency Settings**: [Admin path]  
**GTM/Tracking Settings** (if built-in): [Admin path]

## API & Data Access

### Product Data API
**Endpoint**: [If relevant]  
**Authentication**: [How to authenticate]  
**Use Case**: [When to use API vs data layer]

### Order Data API
**Endpoint**: [If relevant]  
**Authentication**: [How to authenticate]  
**Use Case**: [When to use for server-side tracking]

## Best Practices for This Platform

### Recommended Approach
1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

### What to Avoid
- ❌ [Anti-pattern 1]
- ❌ [Anti-pattern 2]
- ❌ [Anti-pattern 3]

### Performance Considerations
[Any platform-specific performance notes for GTM implementation]

## Version-Specific Notes

### [Platform Version X.X]
**Changes from previous version**: [What changed in tracking]  
**Compatibility**: [GTM configuration changes needed]

### [Platform Version Y.Y]
**Changes from previous version**: [What changed]  
**Compatibility**: [GTM configuration changes needed]

## Documentation Links

**Official Documentation**: [Link]  
**Developer Documentation**: [Link]  
**E-commerce Tracking Guide**: [Link]  
**Community Forums**: [Link]  
**GitHub Repository** (if open source): [Link]

## Platform-Specific Checklist

When debugging GTM on [Platform]:

- [ ] Check [specific thing 1]
- [ ] Verify [specific thing 2]
- [ ] Confirm [specific thing 3]
- [ ] Test [specific scenario]
- [ ] Review [specific setting in admin]
- [ ] Validate [platform-specific data point]

## Example Client Configurations

### Configuration Example 1: [Use Case]
**Client Type**: [e.g., Small retailer, B2B, etc.]  
**Key Requirements**: [What they needed]  
**Implementation Notes**: [How it was set up]  
**Lessons Learned**: [Key takeaways]

### Configuration Example 2: [Use Case]
[Same structure]

## Updating This Document

**Last Updated**: [Date]  
**Updated By**: [Name/Team]  
**Changes**: [Summary of changes]

---

## Notes for Claude Code

When analyzing a [Platform] implementation:

1. **First check**: [Platform-specific check]
2. **Pay attention to**: [Common gotcha]
3. **Don't assume**: [Thing that varies on this platform]
4. **Always verify**: [Critical data point for this platform]
5. **Use this file to**: [How to use this information during debugging]

Remember: Client configuration overrides platform defaults documented here.
