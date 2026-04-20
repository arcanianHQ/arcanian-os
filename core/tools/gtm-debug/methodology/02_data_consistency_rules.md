---
scope: shared
---

# Data Consistency Rules (Universal)

## Overview

Data consistency means that the SAME data point has the SAME value regardless of:
- Where it's measured (client-side vs server-side)
- When it's measured (product list vs product page vs checkout)
- How it's transmitted (pixel vs API vs server container)

## Critical Data Points

### 1. Product ID

**Definition**: Unique identifier for a product or product variant.

**Requirements**:
- ✅ Must be IDENTICAL across all tracking points
- ✅ Must uniquely identify the product
- ✅ Must be consistent format (string or number)
- ✅ No leading/trailing whitespace
- ✅ Case sensitivity must be consistent

**Common Issues**:
- SKU vs Product ID vs Variant ID confusion
- Adding prefixes inconsistently (e.g., "product-" added on server only)
- Parent product ID on listing, variant ID on detail page
- Different encoding (URL encoding on client, plain on server)

**Verification**:
```
Product List Page:
  Client: item_id = "SKU123"
  Server: item_id = "SKU123" ✓

Product Detail Page:
  Client: item_id = "SKU123"
  Server: item_id = "SKU123" ✓

Add to Cart:
  Client: item_id = "SKU123"
  Server: item_id = "SKU123" ✓

Checkout:
  Client: item_id = "SKU123"
  Server: item_id = "SKU123" ✓

Purchase:
  Client: item_id = "SKU123"
  Server: item_id = "SKU123" ✓

ALL MUST MATCH!
```

**Example BAD Scenarios**:
```
❌ Client: "SKU123" → Server: "product-SKU123"
❌ Client: "SKU123" → Server: " SKU123 " (leading space)
❌ Client: "SKU123" → Server: "sku123" (case difference)
❌ Client: "SKU123" → Server: 123 (type difference)
❌ PLP: "PARENT123" → PDP: "VARIANT123-RED" (different IDs)
```

**Example GOOD Scenarios**:
```
✅ Client: "SKU123" → Server: "SKU123"
✅ Client: 12345 → Server: 12345
✅ All events: Same ID for same product
✅ Different products: Different IDs
```

### 2. Product Name

**Definition**: Human-readable product name/title.

**Requirements**:
- ✅ Must be IDENTICAL across tracking points
- ✅ Special characters must be preserved
- ✅ Encoding must be consistent (UTF-8)
- ✅ No truncation unless intentional and consistent
- ✅ HTML entities decoded or consistently encoded

**Common Issues**:
- HTML tags included on client, stripped on server
- Special characters encoded differently (& vs &amp;)
- Truncation at different lengths
- Extra whitespace or line breaks
- Localization differences (if multi-language)

**Verification**:
```
Test Product: "Blue Widget™ - 12" Size"

Client: item_name = "Blue Widget™ - 12\" Size"
Server: item_name = "Blue Widget™ - 12\" Size" ✓

NOT:
❌ Server: "Blue Widget - 12 Size" (trademark removed, quote changed)
❌ Server: "Blue Widget&trade; - 12&quot; Size" (HTML entities)
❌ Server: "Blue Widget™ - 12" (truncated)
```

### 3. Product Price

**Definition**: Monetary value of the product.

**Requirements**:
- ✅ Must be numeric (preferred) or consistently formatted string
- ✅ Must use same decimal separator (. not ,)
- ✅ Must have same decimal precision (typically 2 places)
- ✅ No currency symbols (store separately)
- ✅ Tax inclusion must be consistent

**Common Issues**:
- String with currency symbol: "$29.99" vs number: 29.99
- Different decimal places: 29.9 vs 29.90
- Tax included on client, excluded on server (or vice versa)
- Decimal separator differences: 29.99 vs 29,99
- Rounding differences

**Verification**:
```
Product: $29.99 USD (with tax)

✅ CORRECT:
Client: price = 29.99 (number)
Server: price = 29.99 (number)
Currency: "USD" (separate field)

❌ WRONG:
Client: price = 29.99 → Server: price = "29.99" (type mismatch)
Client: price = 29.99 → Server: price = 30 (rounded)
Client: price = 29.99 (incl. tax) → Server: price = 24.99 (excl. tax)
Client: price = "$29.99" (string with symbol)
```

**Tax Handling Rule**:
```
Either BOTH include tax OR BOTH exclude tax.
Document which approach is used.

Example: If client includes tax:
Product base price: $25.00
Tax: $4.99
Client shows: $29.99 ✓
Server should use: $29.99 ✓

NOT:
Client: $29.99 (with tax)
Server: $25.00 (without tax) ❌
```

### 4. Product Quantity

**Definition**: Number of items.

**Requirements**:
- ✅ Must be numeric (integer)
- ✅ Must match across client and server
- ✅ Must update if quantity changes

**Common Issues**:
- String instead of number: "2" vs 2
- Quantity updated on one side, not propagated
- Multiple cart updates not tracked consistently

**Verification**:
```
User adds 2 items:
Client: quantity = 2 (number)
Server: quantity = 2 (number) ✓

User increases to 3:
Client: quantity = 3
Server: quantity = 3 ✓
```

### 5. Currency

**Definition**: Currency code for monetary values.

**Requirements**:
- ✅ Must be ISO 4217 code (USD, EUR, GBP, etc.)
- ✅ Must be consistent across all events
- ✅ Must match product price currency

**Common Issues**:
- Currency symbol instead of code: "$" vs "USD"
- Inconsistent case: "usd" vs "USD"
- Currency missing on some events
- Multiple currencies not handled properly

**Verification**:
```
✅ CORRECT:
All events: currency = "USD"

❌ WRONG:
Some events: currency = "$"
Some events: currency = "US Dollar"
Some events: currency missing
```

### 6. Transaction ID (for Purchase Events)

**Definition**: Unique identifier for a completed transaction.

**Requirements**:
- ✅ Must be unique per transaction
- ✅ Must be IDENTICAL between client and server
- ✅ Should not be reused for different transactions
- ✅ Should follow consistent format

**Common Issues**:
- Different IDs on client and server
- Order ID vs Transaction ID confusion
- ID regenerated on server side
- Format inconsistencies

**Verification**:
```
Purchase event:

Client: transaction_id = "ORDER-12345"
Server: transaction_id = "ORDER-12345" ✓

NOT:
❌ Client: "ORDER-12345" → Server: "TXN-12345"
❌ Client: "ORDER-12345" → Server: 12345 (different format)
```

### 7. Event ID (Meta/Facebook)

**Definition**: Unique identifier for deduplicating events between client pixel and server CAPI.

**Requirements**:
- ✅ Must be IDENTICAL between client pixel and server CAPI
- ✅ Must be unique per user action
- ✅ Generated ONCE (on client)
- ✅ Passed unchanged to server
- ✅ Valid format (alphanumeric, hyphens OK)

**See**: `03_meta_event_id_guide.md` for complete details.

**Verification**:
```
User adds to cart:

Client Pixel: event_id = "abc-123-def"
Server CAPI: event_id = "abc-123-def" ✓

Result in Meta: 1 event counted ✓

NOT:
❌ Client: "abc-123" → Server: "xyz-789" (different)
❌ Client: "abc-123" → Server: regenerated new ID
Result in Meta: 2 events counted ❌ (double counting!)
```

## Data Type Standards

### Standard Data Types
```
Product ID: String (preferred) or Number (if platform-specific)
Product Name: String
Price: Number (float/double, typically 2 decimal places)
Quantity: Number (integer)
Currency: String (ISO 4217 code, uppercase)
Transaction ID: String
Event ID: String
Category: String
Brand: String
```

### Type Consistency Rule
```
If client uses type X for field Y, server must use type X for field Y.

Example:
✅ Client: price (Number) → Server: price (Number)
❌ Client: price (Number) → Server: price (String)
```

## Cross-Event Consistency

### Rule: Same Product = Same Data

When tracking the same product across multiple events:

```
Product: Blue Widget (SKU123, $29.99)

Event: view_item_list (Product Listing)
- item_id: "SKU123"
- item_name: "Blue Widget"
- price: 29.99

Event: view_item (Product Detail)
- item_id: "SKU123" (SAME)
- item_name: "Blue Widget" (SAME)
- price: 29.99 (SAME)

Event: add_to_cart
- item_id: "SKU123" (SAME)
- item_name: "Blue Widget" (SAME)
- price: 29.99 (SAME)
- quantity: 1

Event: purchase
- item_id: "SKU123" (SAME)
- item_name: "Blue Widget" (SAME)
- price: 29.99 (SAME)
- quantity: 1 (SAME if not changed)
```

**Violation Example**:
```
❌ Product Listing: item_id = "PARENT123"
   Product Detail: item_id = "VARIANT123-BLUE"
   
This breaks product-level reporting and attribution!
```

### Rule: Cart Consistency

Product data in cart must match data from when added:

```
Add to Cart:
- item_id: "SKU123"
- price: 29.99

Begin Checkout:
- item_id: "SKU123" (SAME)
- price: 29.99 (SAME)

Purchase:
- item_id: "SKU123" (SAME)
- price: 29.99 (SAME unless price changed in cart)
```

If price changes (e.g., discount applied), this should be tracked explicitly:
```
Begin Checkout:
- price: 29.99
- discount: 5.00
- final_price: 24.99
```

## Platform-Specific Overrides

Platform-specific files may override these rules IF the platform has specific requirements.

Priority order:
1. **Client Config** (actual implementation for this client)
2. **Platform Standards** (what the platform typically does)
3. **Universal Rules** (these rules, as defaults)

Example:
```
Universal Rule: Product ID should be string
Shopify Standard: Product ID is numeric (bigint)
Client Config: We use Shopify's numeric IDs

Decision: Use numeric product IDs (Client config wins)
```

## Validation Rules

### Product ID Validation
```javascript
function validateProductId(clientId, serverId) {
  return {
    exactMatch: clientId === serverId,
    typeMatch: typeof clientId === typeof serverId,
    formatMatch: checkFormat(clientId, serverId),
    whitespaceIssue: clientId.trim() !== clientId || serverId.trim() !== serverId
  };
}
```

### Price Validation
```javascript
function validatePrice(clientPrice, serverPrice) {
  return {
    exactMatch: clientPrice === serverPrice,
    typeMatch: typeof clientPrice === 'number' && typeof serverPrice === 'number',
    decimalPrecision: checkDecimalPlaces(clientPrice, 2) && checkDecimalPlaces(serverPrice, 2),
    withinTolerance: Math.abs(clientPrice - serverPrice) < 0.01 // Allow tiny float differences
  };
}
```

### Event ID Validation
```javascript
function validateEventId(clientEventId, serverEventId) {
  return {
    exactMatch: clientEventId === serverEventId,
    validFormat: /^[a-zA-Z0-9\-_]+$/.test(clientEventId),
    notUndefined: clientEventId !== 'undefined' && serverEventId !== 'undefined',
    notNull: clientEventId && serverEventId
  };
}
```

## Reporting Format

When documenting consistency issues:

```markdown
### Issue: Product ID Mismatch

**Severity**: P0 - Critical
**Category**: Data Consistency - Product ID

**Location**: 
- Client: Variable {{DL - Product ID}}
- Server: Variable {{Event Data - product_id}}

**Current Behavior**:
- Client sends: "SKU123"
- Server receives: "product-SKU123"

**Expected Behavior**:
Both should send: "SKU123"

**Impact**:
- Breaks product-level reporting in GA4
- Breaks Meta catalog matching
- Prevents accurate attribution

**Root Cause**:
Server-side variable adds "product-" prefix in transformation logic

**Fix**:
Remove prefix logic from server variable or add same prefix to client

**Affected Events**:
- view_item
- add_to_cart
- begin_checkout
- purchase
```

## Testing Checklist

For each critical data point:

- [ ] Verify value on client-side (GTM Preview / DevTools)
- [ ] Verify value on server-side (Server GTM Preview / Logs)
- [ ] Confirm exact match (===)
- [ ] Confirm type match
- [ ] Test across all event types
- [ ] Test with edge cases (special characters, long strings, etc.)
- [ ] Verify in destination (GA4, Meta Events Manager)

## Success Criteria

✅ **All product IDs match exactly across client and server**  
✅ **All product names match exactly**  
✅ **All prices match with correct data type and format**  
✅ **Event IDs (Meta) match between client pixel and server CAPI**  
✅ **Currency codes consistent everywhere**  
✅ **No type mismatches**  
✅ **No format inconsistencies**  
✅ **Data consistent across all events in the funnel**  

When all criteria met → Data consistency achieved → Accurate tracking!
