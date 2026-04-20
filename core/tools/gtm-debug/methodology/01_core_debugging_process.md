---
scope: shared
---

# Core Debugging Methodology (Platform-Agnostic)

## Purpose
This document outlines the universal debugging process applicable to all GTM implementations regardless of e-commerce platform.

## Debugging Layers

```
Layer 1: Container Structure
Layer 2: Data Layer Analysis
Layer 3: Variable Mapping
Layer 4: Tag Configuration
Layer 5: Data Flow Verification
Layer 6: Cross-Container Consistency
```

## Layer 1: Container Structure Analysis

### 1.1 Parse Container JSON
For each container file:
```javascript
{
  "containerVersion": {
    "container": {},      // Container metadata
    "tag": [],           // All tags
    "trigger": [],       // All triggers
    "variable": [],      // All variables
    "folder": [],        // Organization folders
    "builtInVariable": [] // Built-in variables enabled
  }
}
```

### 1.2 Create Tag Inventory
Extract and categorize:
```
Tags by Type:
- Google Analytics 4 (GA4)
- Google Analytics Universal (deprecated but check)
- Meta Pixel (Facebook Pixel)
- Meta Conversions API (CAPI)
- Google Ads Conversion
- Google Ads Remarketing
- Custom HTML
- Custom Image
- Third-party tags

Tags by Purpose:
- Page view tracking
- Event tracking
- E-commerce tracking
- Conversion tracking
- Remarketing
```

### 1.3 Create Variable Inventory
Categorize variables:
```
By Type:
- Data Layer Variables
- JavaScript Variables
- Custom JavaScript
- Constant Variables
- 1st Party Cookie
- Lookup Table
- RegEx Table
- URL Variables
- HTTP Referrer

By Purpose:
- Product Data (ID, name, price, quantity, category, brand)
- Event Data (event names, parameters)
- User Data (user ID, email hashes, phone hashes)
- Page Data (page type, URL, title)
- Transaction Data (transaction ID, value, currency)
- Meta Data (event_id, fbp, fbc, external_id)
```

### 1.4 Create Trigger Inventory
Categorize triggers:
```
By Type:
- Page View
- DOM Ready
- Window Loaded
- Custom Event
- Form Submission
- Click
- Scroll Depth
- Timer
- History Change

By Event Name (for Custom Events):
- view_item_list
- view_item
- add_to_cart
- remove_from_cart
- view_cart
- begin_checkout
- add_payment_info
- add_shipping_info
- purchase
- [any custom events]
```

## Layer 2: Data Layer Analysis

### 2.1 Expected Data Layer Structure
Standard GA4 E-commerce:
```javascript
{
  event: 'view_item',
  ecommerce: {
    currency: 'USD',
    value: 29.99,
    items: [{
      item_id: 'SKU123',
      item_name: 'Product Name',
      affiliation: 'Online Store',
      coupon: '',
      currency: 'USD',
      discount: 0,
      index: 0,
      item_brand: 'Brand Name',
      item_category: 'Category',
      item_category2: '',
      item_category3: '',
      item_category4: '',
      item_category5: '',
      item_list_id: 'related_products',
      item_list_name: 'Related Products',
      item_variant: 'Blue',
      location_id: '',
      price: 29.99,
      quantity: 1
    }]
  }
}
```

Standard Meta Structure:
```javascript
{
  event: 'ViewContent',
  event_id: 'unique-12345',
  content_type: 'product',
  content_ids: ['SKU123'],
  content_name: 'Product Name',
  content_category: 'Category',
  currency: 'USD',
  value: 29.99
}
```

### 2.2 Identify Data Layer Variables
For each variable in the container:
- What data layer path does it read?
- What's the fallback/default value?
- Is there any transformation logic?
- What data type is expected?

### 2.3 Trace Data Sources
For critical data points:
```
Product ID:
- Client-side source: [data layer path or JS]
- Server-side source: [event data path]
- Transformations: [any modifications]

Product Price:
- Client-side source: [data layer path]
- Server-side source: [event data path]
- Transformations: [currency formatting, rounding]

Event ID:
- Generation: [where/how created]
- Storage: [cookie/localStorage/dataLayer]
- Transfer: [how passed to server]
```

## Layer 3: Variable Mapping

### 3.1 Create Variable Dependency Tree
For each tag, identify which variables it uses:
```
Tag: "GA4 - Purchase Event"
├── Event Name: {{Event}} [reads from dataLayer]
├── Transaction ID: {{DL - Transaction ID}}
├── Transaction Value: {{DL - Transaction Value}}
├── Currency: {{DL - Currency}}
└── Items Array: {{DL - Ecommerce Items}}
    ├── Item ID: {{DL - Item ID}}
    ├── Item Name: {{DL - Item Name}}
    └── Item Price: {{DL - Item Price}}
```

### 3.2 Identify Transformation Points
Where data changes format:
```
Example 1: Price Formatting
Input: "29.99 USD"
Variable: {{Price Cleanup}} (Custom JavaScript)
Logic: parseFloat(value.replace(/[^0-9.]/g, ''))
Output: 29.99 (number)

Example 2: Product ID Normalization
Input: " SKU-123 "
Variable: {{Product ID Normalized}}
Logic: value.trim().toUpperCase()
Output: "SKU-123"
```

### 3.3 Map Client-to-Server Variable Flow
For critical data:
```
Product ID Flow:
1. Website → dataLayer.push({ecommerce: {items: [{item_id: "SKU123"}]}})
2. Client GTM Variable: {{DL - ecommerce.items.0.item_id}}
3. Client GTM Tag: Sends to GA4, Meta Pixel
4. Client GTM Tag: Sends event_data to server
5. Server GTM Variable: {{Event Data - item_id}}
6. Server GTM Tag: Uses in GA4 Server, Meta CAPI

Consistency Check:
Step 1 → Step 6: MUST BE IDENTICAL
```

## Layer 4: Tag Configuration Analysis

### 4.1 Examine Each Tag's Parameters
For GA4 tags:
```
- Measurement ID: [GA4 property ID]
- Event Name: [parameter or variable]
- Event Parameters:
  - currency: [variable]
  - value: [variable]
  - transaction_id: [variable]
  - items: [variable or array]
- User Properties: [any custom user properties]
- Configuration Tag: [if using configuration tag]
```

For Meta Pixel tags:
```
- Pixel ID: [Facebook Pixel ID]
- Event Name: [ViewContent/AddToCart/Purchase/etc]
- Object Properties:
  - content_ids: [variable]
  - content_type: [product/product_group]
  - value: [variable]
  - currency: [variable]
  - event_id: [CRITICAL - must match server]
```

For Meta CAPI tags:
```
- Pixel ID: [must match client pixel]
- API Access Token: [server-side token]
- Test Event Code: [if testing]
- Event Name: [must match client]
- Event ID: [MUST match client - deduplication]
- Event Source URL: [page URL]
- User Data:
  - em: [hashed email]
  - ph: [hashed phone]
  - client_user_agent: [from request]
  - client_ip_address: [from request]
  - fbp: [from cookie]
  - fbc: [from cookie/URL]
- Custom Data:
  - content_ids: [must match client]
  - value: [must match client]
  - currency: [must match client]
```

### 4.2 Identify Hardcoded Values
Look for tags with hardcoded data:
```
❌ BAD:
Event Parameter: value = "99.99" (hardcoded)

✅ GOOD:
Event Parameter: value = {{DL - Transaction Value}} (dynamic)
```

### 4.3 Check Conditional Logic
For tags with conditions:
```
Tag: "GA4 - Purchase"
Firing Triggers:
- Custom Event - purchase [Required]

Blocking Triggers:
- Debug Mode [Optional]

Exceptions:
- Check if conditions accidentally block valid events
- Check if multiple similar triggers cause duplicate fires
```

## Layer 5: Data Flow Verification

### 5.1 Trace Complete Event Flow
For each key event:
```
Example: Add to Cart Event

1. User Action
   └─> Clicks "Add to Cart" button

2. Website Code
   └─> Executes dataLayer.push({
        event: 'add_to_cart',
        ecommerce: {
          currency: 'USD',
          value: 29.99,
          items: [{
            item_id: 'SKU123',
            item_name: 'Blue Widget',
            price: 29.99,
            quantity: 1
          }]
        }
      })

3. Client GTM - Trigger Evaluation
   └─> Trigger "Custom Event - add_to_cart" fires

4. Client GTM - Tags Execute
   ├─> GA4 - Add to Cart
   │   └─> Sends to GA4: event='add_to_cart', items=[...]
   ├─> Meta Pixel - AddToCart
   │   └─> Sends to Meta Pixel: event='AddToCart', event_id='xyz'
   └─> Server Forwarder
       └─> Sends to Server GTM: all event data + event_id

5. Server GTM - Event Received
   └─> Event data available to server container

6. Server GTM - Tags Execute
   ├─> GA4 Server - Add to Cart
   │   └─> Sends to GA4 via Measurement Protocol
   └─> Meta CAPI - AddToCart
       └─> Sends to Meta CAPI: event_id='xyz' (same as client!)

Verification Points:
- [ ] Step 2 → 4: Product data intact?
- [ ] Step 4 → 5: Event_id passed correctly?
- [ ] Step 5 → 6: Product data intact?
- [ ] Step 4 & 6: Event_id MATCHES?
```

### 5.2 Identify Data Loss Points
Common places data gets lost or corrupted:
```
1. Website → Data Layer
   - Missing properties
   - Wrong data types
   - Encoding issues

2. Data Layer → GTM Variable
   - Wrong path
   - Undefined handling
   - Type coercion issues

3. GTM Variable → Tag Parameter
   - Missing mapping
   - Wrong variable selected
   - Undefined not handled

4. Client → Server Transfer
   - Event data not included
   - Cookie not readable
   - URL parameter missing

5. Server Variable → Server Tag
   - Wrong source
   - Transformation error
   - Fallback value used
```

## Layer 6: Cross-Container Consistency

### 6.1 Create Comparison Matrix
```
| Data Point | Client Value | Client Source | Server Value | Server Source | Match? |
|------------|-------------|---------------|--------------|---------------|--------|
| Product ID | SKU123 | DL ecommerce.items.0.item_id | SKU123 | event_data.item_id | ✓ |
| Product Price | 29.99 | DL ecommerce.items.0.price | "29.99" | event_data.price | ✗ Type |
| Event ID | abc-123 | JS Generated | abc-123 | event_data.event_id | ✓ |
```

### 6.2 Consistency Rules
For each data point, verify:

**Product ID**
- [ ] Same value client and server
- [ ] Same format (no prefix added/removed)
- [ ] Same data type (string/number consistent)
- [ ] No encoding differences
- [ ] Consistent across ALL events for same product

**Product Name**
- [ ] Same value client and server
- [ ] No truncation
- [ ] Special characters preserved
- [ ] Encoding consistent (UTF-8)

**Product Price**
- [ ] Same value client and server
- [ ] Same decimal places
- [ ] Same data type (number preferred)
- [ ] No currency symbol in numeric value
- [ ] Tax handling consistent

**Event ID (Meta)**
- [ ] Generated ONCE on client
- [ ] Passed to server unchanged
- [ ] Used by server Meta CAPI tag
- [ ] Format: alphanumeric, hyphens OK, no special chars
- [ ] Unique per user action

### 6.3 Detect Common Mismatches

**Pattern 1: Type Mismatch**
```
Client: value = 29.99 (number)
Server: value = "29.99" (string)
Impact: May cause issues in some systems
```

**Pattern 2: Format Inconsistency**
```
Client: product_id = "SKU123"
Server: product_id = "product-SKU123"
Impact: Breaks product-level reporting
```

**Pattern 3: Missing Data**
```
Client: sends {item_id, item_name, price, quantity}
Server: receives {item_id, price} only
Impact: Incomplete server-side tracking
```

**Pattern 4: Event ID Regeneration**
```
Client: event_id = "abc-123" (generated, sent to pixel)
Server: event_id = "xyz-789" (regenerated - WRONG!)
Impact: Meta CAPI deduplication fails, double-counting
```

## Universal Verification Checklist

### Critical Data Points
- [ ] Product IDs identical across all events and containers
- [ ] Product names identical across all events and containers
- [ ] Product prices identical across all events and containers
- [ ] Event IDs (Meta) identical between client and server
- [ ] Currency codes consistent
- [ ] Transaction IDs unique and consistent

### Data Types
- [ ] Prices are numbers (not strings with currency symbols)
- [ ] Product IDs are consistent type (string or number, but consistent)
- [ ] Quantities are numbers
- [ ] Event IDs are strings

### Required Fields Present
- [ ] All GA4 events have required parameters
- [ ] All Meta events have required parameters
- [ ] Server-side tags receive all necessary data
- [ ] User data (for CAPI) properly hashed and present

### No Hardcoded Values
- [ ] No test/dummy product IDs in production tags
- [ ] No hardcoded prices
- [ ] No hardcoded event IDs
- [ ] All values dynamic from variables

### Trigger Logic
- [ ] No conflicting triggers
- [ ] No missing triggers for critical events
- [ ] Trigger conditions correctly exclude test traffic if needed
- [ ] Triggers fire in correct sequence

## Output Requirements

After completing all layers, document:

1. **Container Structure Document**
   - Complete inventory of tags, triggers, variables
   - Organization and naming conventions
   - Built-in variables enabled

2. **Data Flow Diagrams**
   - Visual representation of data flow
   - All transformation points marked
   - Client-to-server flow clearly shown

3. **Variable Mapping Table**
   - Every variable, its source, and its usage
   - Dependencies between variables
   - Transformation logic documented

4. **Consistency Report**
   - All matching/mismatching data points
   - Severity of each mismatch
   - Impact on tracking accuracy

5. **Issue List**
   - Every problem found
   - Severity and impact
   - Recommended fix
   - Testing procedure

## Key Principles

1. **Follow the Data**: Track every piece of data from source to destination
2. **Verify, Don't Assume**: Check actual values, not what should be there
3. **Document Everything**: Every finding needs evidence
4. **Think End-to-End**: One issue can cascade through entire tracking
5. **Prioritize by Impact**: Data consistency issues affect attribution

This methodology applies to ALL platforms. Platform-specific knowledge adds context but doesn't change the fundamental process.
