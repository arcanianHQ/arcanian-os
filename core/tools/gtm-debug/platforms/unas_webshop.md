---
scope: shared
---

# Unas Webshop - Platform Knowledge

## Platform Overview

**Platform Name:** Unas Webshop
**Market:** Primarily Hungarian e-commerce
**GTM Integration:** Non-standard data layer structure
**Last Updated:** 2024-11-11

---

## Critical Platform Differences

### ⚠️ Major Deviation from GA4 Standards

**Unas does NOT follow the standard GA4 ecommerce data layer structure.**

#### Standard GA4 Format (Most Platforms):
```javascript
dataLayer.push({
  event: 'view_item',
  ecommerce: {              // ✅ Wrapped in ecommerce object
    currency: 'HUF',
    value: 6490,
    items: [{
      item_id: 'M-241119-0046',
      item_name: 'Product Name',
      price: 6490
    }]
  }
});
```

#### Unas Actual Format:
```javascript
dataLayer.push({
  event: 'view_item',
  currency: 'HUF',          // ❌ At ROOT level (not in ecommerce)
  value: '6490',            // ❌ At ROOT level
  items: [{                 // ❌ At ROOT level
    item_id: 'M-241119-0046',
    item_name: 'Product Name',
    price: '6490'
  }],
  non_interaction: true
});
```

**Key difference:** `currency`, `value`, and `items` are pushed at the **root level**, NOT inside an `ecommerce` object.

---

## How GTM Processes Unas Data

### GTM's Internal Transformation

When Unas pushes data, GTM internally transforms it into `eventModel`:

```javascript
// After GTM processes the push:
{
  event: 'view_item',
  eventModel: {              // GTM creates this internally
    currency: 'HUF',
    value: '6490',
    items: [{
      item_id: 'M-241119-0046',
      item_name: 'Product Name',
      item_category: 'Category',
      price: '6490'
    }]
  }
}
```

### Why Standard Variables Fail

**Standard Data Layer Variables will return `undefined`:**

❌ `DLV - ecommerce.items` → **undefined** (no ecommerce object exists)
❌ `DLV - ecommerce.currency` → **undefined**
❌ `DLV - ecommerce.value` → **undefined**

---

## GTM Configuration for Unas

### Required Variables

To work with Unas, you must create variables that read from `eventModel`:

#### 1. Items Array

**Variable Name:** `DLV - eventModel.items`

**Type:** Data Layer Variable

**Configuration:**
- **Data Layer Variable Name:** `eventModel.items`
- **Data Layer Version:** Version 2

---

#### 2. Currency

**Variable Name:** `DLV - eventModel.currency`

**Type:** Data Layer Variable

**Configuration:**
- **Data Layer Variable Name:** `eventModel.currency`
- **Data Layer Version:** Version 2
- **Default Value:** `HUF`

---

#### 3. Transaction Value

**Variable Name:** `DLV - eventModel.value`

**Type:** Data Layer Variable

**Configuration:**
- **Data Layer Variable Name:** `eventModel.value`
- **Data Layer Version:** Version 2

---

#### 4. First Item Name

**Variable Name:** `DLV - eventModel.items.0.item_name`

**Type:** Data Layer Variable

**Configuration:**
- **Data Layer Variable Name:** `eventModel.items.0.item_name`
- **Data Layer Version:** Version 2

---

#### 5. Universal Items Array (with Fallback)

**Variable Name:** `CJS - Universal Items Array`

**Type:** Custom JavaScript

**Code:**
```javascript
function() {
  // Try eventModel first (Unas uses this)
  var eventItems = {{DLV - eventModel.items}};
  if (eventItems && Array.isArray(eventItems) && eventItems.length > 0) {
    return eventItems;
  }

  // Fallback to standard ecommerce.items (for compatibility)
  var items = {{DLV - ecommerce.items}};
  if (items && Array.isArray(items) && items.length > 0) {
    return items;
  }

  return undefined;
}
```

---

#### 6. Item IDs Array (for Meta content_ids)

**Variable Name:** `CJS - Array - Item IDs`

**Type:** Custom JavaScript

**Code:**
```javascript
function() {
  var items = {{CJS - Universal Items Array}};

  if (!items || !items.length) return undefined;

  var item_ids = [];
  for (var i = 0; i < items.length; i++) {
    var cur_item_id = items[i].item_id;
    if (typeof(cur_item_id) === 'number') {
      cur_item_id = cur_item_id.toString();
    }
    item_ids.push(cur_item_id);
  }

  return item_ids.length ? item_ids : undefined;
}
```

---

#### 7. Universal Currency (with Fallback)

**Variable Name:** `CJS - Universal Currency`

**Type:** Custom JavaScript

**Code:**
```javascript
function() {
  // Try eventModel first (Unas)
  var eventCurr = {{DLV - eventModel.currency}};
  if (eventCurr) return eventCurr;

  // Fallback to standard ecommerce.currency
  var curr = {{DLV - ecommerce.currency}};
  if (curr) return curr;

  // Final fallback for Hungarian market
  return 'HUF';
}
```

---

#### 8. Universal Value (with Fallback)

**Variable Name:** `CJS - Universal Value`

**Type:** Custom JavaScript

**Code:**
```javascript
function() {
  // Try eventModel first (Unas)
  var eventValue = {{DLV - eventModel.value}};
  if (eventValue !== undefined && eventValue !== null) {
    return eventValue;
  }

  // Fallback to standard ecommerce.value
  var value = {{DLV - ecommerce.value}};
  if (value !== undefined && value !== null) {
    return value;
  }

  return undefined;
}
```

---

#### 9. Facebook Contents Array

**Variable Name:** `CJS - FB Contents Array`

**Type:** Custom JavaScript

**Code:**
```javascript
function() {
  var items = {{CJS - Universal Items Array}};

  if (!items || !Array.isArray(items) || items.length === 0) {
    return undefined;
  }

  var contents = [];
  for (var i = 0; i < items.length; i++) {
    contents.push({
      id: items[i].item_id,
      quantity: items[i].quantity || 1
    });
  }

  return contents.length > 0 ? contents : undefined;
}
```

---

## Product Data Structure

### Product ID Format

**Unas Product ID Example:** `M-241119-0046`

**Format:** Alphanumeric with hyphens
**Type:** String
**Consistency:** Consistent across all events

### Product Data Fields

```javascript
{
  item_id: 'M-241119-0046',           // String, consistent format
  item_name: 'Mikan Adult Száraz Macskatáp (Marha) - 10 kg',
  item_category: 'Macska/Típus szerint',  // Hierarchical with /
  price: '6490',                      // String (not number!)
  quantity: 1                         // Optional, defaults to 1
}
```

### Data Type Notes

⚠️ **Important Data Type Differences:**

| Field | Expected Type | Unas Type | Fix Required |
|-------|---------------|-----------|--------------|
| `price` | Number | String | Convert with `parseFloat()` |
| `value` | Number | String | Convert with `parseFloat()` |
| `quantity` | Number | Number | ✓ Correct |
| `item_id` | String | String | ✓ Correct |

---

## Events Tracked

Unas implements these GA4 ecommerce events:

- ✅ `view_item_list` - Product listing pages
- ✅ `view_item` - Product detail page
- ✅ `add_to_cart` - Add to cart action
- ✅ `remove_from_cart` - Remove from cart
- ✅ `view_cart` - Cart page view
- ✅ `begin_checkout` - Checkout initiation
- ✅ `add_payment_info` - Payment method selection
- ✅ `add_shipping_info` - Shipping method selection
- ✅ `purchase` - Order completion

All events follow the same pattern: **data at root level, GTM processes into eventModel**.

---

## Meta/Facebook Pixel Configuration

### Object Properties for Unas

Use these variables in your Meta Pixel tags:

| Property | Variable | Notes |
|----------|----------|-------|
| `content_ids` | `{{CJS - Array - Item IDs}}` | Array of product IDs |
| `content_type` | `product` | Hardcoded constant |
| `content_name` | `{{DLV - eventModel.items.0.item_name}}` | First item name |
| `currency` | `{{CJS - Universal Currency}}` | With HUF fallback |
| `value` | `{{CJS - Universal Value}}` | Transaction value |
| `contents` | `{{CJS - FB Contents Array}}` | Full contents array |

### Example Meta Pixel Tag Configuration

```javascript
// Meta - view_item tag
{
  Event Name: "ViewContent",
  Object Properties: [
    {name: "content_ids", value: {{CJS - Array - Item IDs}}},
    {name: "content_type", value: "product"},
    {name: "content_name", value: {{DLV - eventModel.items.0.item_name}}},
    {name: "currency", value: {{CJS - Universal Currency}}},
    {name: "value", value: {{CJS - Universal Value}}},
    {name: "contents", value: {{CJS - FB Contents Array}}}
  ]
}
```

### User Data Configuration for Purchase Events

#### Unas User Data Structure

For purchase events, Unas also pushes **user data at root level**, which GTM transforms into `eventModel.user_data`:

```javascript
// Unas pushes:
dataLayer.push({
  event: 'purchase',
  transaction_id: '71755-103351',
  value: 8480,
  currency: 'HUF',
  items: [...],
  user_data: {                    // ❌ At ROOT level
    email: 'customer@example.com',
    phone_number: '+36301234567',
    address: {
      first_name: 'John',
      last_name: 'Doe',
      street: 'Main Street 123',
      city: 'Budapest',
      postal_code: '1111',
      country: 'hu'
    }
  }
});

// GTM transforms to:
{
  event: 'purchase',
  eventModel: {
    transaction_id: '71755-103351',
    value: 8480,
    currency: 'HUF',
    items: [...],
    user_data: {                   // ✅ Now in eventModel
      email: 'customer@example.com',
      phone_number: '+36301234567',
      address: {...}
    }
  }
}
```

#### Required User Data Variables

Create these Data Layer Variables to read user data:

| Variable Name | Data Layer Variable Name | Purpose |
|--------------|-------------------------|---------|
| `DLV - eventModel.user_data.email` | `eventModel.user_data.email` | Customer email |
| `DLV - eventModel.user_data.phone_number` | `eventModel.user_data.phone_number` | Customer phone |
| `DLV - eventModel.user_data.address.first_name` | `eventModel.user_data.address.first_name` | First name |
| `DLV - eventModel.user_data.address.last_name` | `eventModel.user_data.address.last_name` | Last name |
| `DLV - eventModel.user_data.address.city` | `eventModel.user_data.address.city` | City |
| `DLV - eventModel.user_data.address.postal_code` | `eventModel.user_data.address.postal_code` | Postal code |
| `DLV - eventModel.user_data.address.country` | `eventModel.user_data.address.country` | Country code |

#### Transaction ID Variable

For the `order_id` parameter, create:

| Variable Name | Data Layer Variable Name | Purpose |
|--------------|-------------------------|---------|
| `DLV - eventModel.transaction_id` | `eventModel.transaction_id` | Order/transaction ID |

### Meta Purchase Event Configuration

Complete configuration for Meta - purchase tag:

```javascript
// Meta - purchase tag
{
  Event Name: "Purchase",

  // Object Properties
  Object Properties: [
    {name: "value", value: {{CJS - Universal Value}}},
    {name: "currency", value: {{CJS - Universal Currency}}},
    {name: "order_id", value: {{DLV - eventModel.transaction_id}}},
    {name: "content_ids", value: {{CJS - Array - Item IDs}}},
    {name: "content_type", value: "product"},
    {name: "content_name", value: {{DLV - eventModel.items.0.item_name}}},
    {name: "contents", value: {{CJS - FB Contents Array}}}
  ],

  // Advanced Matching (User Data)
  Advanced Matching: [
    {name: "em", value: {{DLV - eventModel.user_data.email}}},
    {name: "ph", value: {{DLV - eventModel.user_data.phone_number}}},
    {name: "fn", value: {{DLV - eventModel.user_data.address.first_name}}},
    {name: "ln", value: {{DLV - eventModel.user_data.address.last_name}}},
    {name: "ct", value: {{DLV - eventModel.user_data.address.city}}},
    {name: "zp", value: {{DLV - eventModel.user_data.address.postal_code}}},
    {name: "cn", value: {{DLV - eventModel.user_data.address.country}}},
    {name: "st", value: {{EC - region}}},  // Optional: state/region
    {name: "external_id", value: {{External ID}}}  // Optional: customer ID
  ]
}
```

### Important: Data Hashing for Meta Pixel

#### How Hashing Works

**⚠️ DO NOT pre-hash user data in GTM variables**

The Meta Pixel template **automatically hashes** user data before sending to Facebook.

**Workflow:**
1. **Your variables:** Pass raw, unhashed data
2. **Meta Pixel template:** Normalizes and hashes data
3. **Facebook receives:** Only hashed values

**Example:**
```javascript
// In GTM variables (raw data):
email: "Customer@Example.COM"
phone: "+36 30 123 4567"

// Meta template normalizes:
email: "customer@example.com" (lowercase, trimmed)
phone: "36301234567" (remove +, spaces)

// Meta template hashes:
email: "5d8f9a3b2c1e..." (SHA-256 hash)
phone: "7a2d4c1b8e9f..." (SHA-256 hash)

// Facebook receives (hashed):
ud[em]: "5d8f9a3b2c1e..."
ud[ph]: "7a2d4c1b8e9f..."
```

#### Why Raw Data is Better

✅ **Pass raw data:**
- Template normalizes before hashing (ensures consistency)
- `John@Example.COM` and `john@example.com` → same hash
- `+36 30 123 4567` and `36301234567` → same hash

❌ **Don't pre-hash:**
- Different formats produce different hashes
- Reduces match rate with Facebook's catalog
- Template can't normalize pre-hashed data

#### Verification

**In GTM Preview - Data Layer:**
```javascript
// You should see RAW data:
user_data: {
  email: "customer@example.com",  // ✅ Raw
  phone_number: "+36301234567"    // ✅ Raw
}
```

**In GTM Preview - Meta Tag (Network Tab):**
```javascript
// Facebook receives HASHED data:
ud[em]: "5d8f9a3b2c1e..."  // ✅ Hashed by template
ud[ph]: "7a2d4c1b8e9f..."  // ✅ Hashed by template
```

**In Facebook Events Manager:**
- Customer Information section shows "Hashed" or count (e.g., "7 parameters")
- You won't see raw email/phone (privacy protection)
- Higher match rate = better data quality

---

### Critical: order_id and transaction_id Must Match

**⚠️ IMPORTANT for deduplication:**

The `order_id` sent to Meta Pixel **MUST be the same value** as the `transaction_id` sent to GA4.

**Why this matters:**
- Prevents double-counting between client-side and server-side tracking
- Enables proper event deduplication if using Meta CAPI (server-side)
- Allows cross-platform purchase attribution

**Configuration:**

Both should use the same variable: `{{DLV - eventModel.transaction_id}}`

```javascript
// GA4 Configuration Tag
{
  event: "purchase",
  transaction_id: {{DLV - eventModel.transaction_id}}  // e.g., "71755-103351"
}

// Meta - purchase Tag (objectPropertyList)
{
  name: "order_id",
  value: {{DLV - eventModel.transaction_id}}  // Same value: "71755-103351"
}
```

**Result:**
```javascript
// Data Layer
eventModel.transaction_id: "71755-103351"

// GA4 receives:
transaction_id: "71755-103351" ✅

// Meta Pixel receives:
order_id: "71755-103351" ✅

// Same ID = Proper deduplication
```

---

### Verification Checklist for Meta - purchase

Before going live, verify in **GTM Preview Mode**:

#### 1. Variable Values Check

**In Variables tab, when purchase event fires:**

```javascript
✅ DLV - eventModel.transaction_id: "71755-103351" (not undefined)
✅ DLV - eventModel.items: [{item_id: "...", ...}] (array with items)
✅ DLV - eventModel.value: "8480" or 8480 (has value)
✅ DLV - eventModel.currency: "HUF" (has currency)
✅ DLV - eventModel.user_data.email: "customer@example.com" (not undefined)
✅ DLV - eventModel.user_data.phone_number: "+36301234567" (not undefined)
✅ CJS - Universal Items Array: [{...}] (has items)
✅ CJS - Universal Value: 8480 (number)
✅ CJS - Universal Currency: "HUF" (string)
✅ CJS - Array - Item id's: ["M-241119-0046"] (array of IDs)
✅ CJS - FB Contents Array: [{id: "...", quantity: 1}] (FB format)
```

#### 2. Meta - purchase Tag Check

**In Tags tab → Meta - purchase → objectPropertyList:**

```javascript
✅ value: 8480 (number, not undefined)
✅ currency: "HUF" (string, not undefined)
✅ order_id: "71755-103351" (string, not undefined) ← CRITICAL!
✅ content_ids: ["M-241119-0046"] (array of IDs, not URLs)
✅ content_type: "product" (static string)
✅ content_name: "Product Name..." (string, not undefined)
✅ contents: [{id: "...", quantity: 1}] (array, not undefined)
```

**In Tags tab → Meta - purchase → advancedMatchingList:**

```javascript
✅ em (email): "customer@example.com" (raw, not undefined)
✅ ph (phone): "+36301234567" (raw, not undefined)
✅ fn (first_name): "John" (raw, not undefined)
✅ ln (last_name): "Doe" (raw, not undefined)
✅ ct (city): "Budapest" (not undefined)
✅ zp (postal): "1111" (not undefined)
✅ cn (country): "hu" (not undefined)
```

#### 3. Network Request Check

**In Network tab, find fbq('track', 'Purchase') request:**

```javascript
// URL parameters should show:
✅ id=[pixel-id]
✅ ev=Purchase
✅ cd[value]=8480
✅ cd[currency]=HUF
✅ cd[order_id]=71755-103351  ← Must have value!
✅ cd[content_ids]=["M-241119-0046"]
✅ cd[content_type]=product
✅ cd[contents]=[{id:"...",quantity:1}]

// User data (hashed):
✅ ud[em]=[hash]  ← 64-character SHA-256 hash
✅ ud[ph]=[hash]  ← 64-character SHA-256 hash
✅ ud[fn]=[hash]  ← 64-character SHA-256 hash
✅ ud[ln]=[hash]  ← 64-character SHA-256 hash
```

#### 4. Facebook Events Manager Check

**Within 1-2 minutes, verify in Events Manager:**

```javascript
✅ Purchase event appears
✅ Event Match Quality: Good or Excellent (>7.0)
✅ Customer Information: 7 parameters (email, phone, name, city, postal, country)
✅ Purchase value: 8480 HUF
✅ Order ID: Present (shows in event details)
✅ Content IDs: Shows product ID (not URL)
```

#### 5. Common Failures and Fixes

**❌ order_id is undefined:**
- Check: Is `DLV - eventModel.transaction_id` configured correctly?
- Data Layer Variable Name should be: `eventModel.transaction_id` (not `DLV - eventModel.transaction_id`)

**❌ User data shows 0 parameters:**
- Check: Are all user_data variables using `eventModel.user_data.*` paths?
- Check: Is user_data present in data layer for purchase event?
- Look in Data Layer tab for `eventModel.user_data` object

**❌ content_ids shows URLs instead of IDs:**
- Check: Is using `{{CJS - Array - Item id's}}`?
- Check: Does CJS variable extract `item_id` field (not `item_url`)?

**❌ All objectPropertyList values are undefined:**
- Check: Are you using Universal variables (not `DLV - ecommerce.*`)?
- Check: Do Universal variables read from `eventModel` first?

---

## Common Issues and Solutions

### Issue 1: Variables Return Undefined

**Symptom:** All ecommerce variables show `undefined` in GTM Preview

**Cause:** Using standard `ecommerce.*` paths that don't exist in Unas

**Solution:** Use `eventModel.*` paths instead

**Before (Wrong):**
```
DLV - ecommerce.items → undefined
DLV - ecommerce.currency → undefined
```

**After (Correct):**
```
DLV - eventModel.items → [{...}]
DLV - eventModel.currency → "HUF"
```

---

### Issue 2: Data Layer Normalizer Doesn't Work

**Symptom:** Tried to intercept `dataLayer.push` to transform data, but it doesn't work

**Cause:** GTM's own code overrides `dataLayer.push` after your normalizer runs

**Solution:** Don't try to normalize. Instead, read from `eventModel` directly using Data Layer Variables.

**What doesn't work:**
```javascript
// ❌ This approach fails with Unas
window.dataLayer.push = function() {
  // Transform data here...
  // GTM will override this!
}
```

**What works:**
```javascript
// ✅ Read from eventModel directly
var items = {{DLV - eventModel.items}};
```

---

### Issue 3: Price Type Mismatch

**Symptom:** Prices are strings `"6490"` instead of numbers `6490`

**Cause:** Unas sends prices as strings

**Solution:** Convert in Custom JavaScript variables:

```javascript
function() {
  var value = {{DLV - eventModel.value}};
  if (typeof value === 'string') {
    return parseFloat(value.replace(/[^0-9.-]/g, ''));
  }
  return value;
}
```

---

### Issue 4: Meta content_ids Sending URLs

**Symptom:** Facebook Pixel `content_ids` contains product URLs instead of IDs

**Cause:** Variable reading from wrong data source or using wrong field

**Solution:**
1. Ensure using `{{CJS - Array - Item IDs}}`
2. Verify it reads from `{{CJS - Universal Items Array}}`
3. Verify Universal Items Array reads from `eventModel.items`
4. Check that `items[i].item_id` (not `items[i].url` or similar) is used

**Verify in console:**
```javascript
// Check what's in eventModel
dataLayer.filter(e => e.eventModel && e.eventModel.items)
  .map(e => e.eventModel.items[0].item_id)

// Should show: "M-241119-0046" (not a URL)
```

---

### Issue 5: Meta Purchase - order_id Missing or Undefined

**Symptom:** In Meta - purchase tag, `order_id` parameter shows no value or `undefined`

**Cause:** Using `{{DLV - ecommerce.transaction_id}}` which doesn't exist in Unas

**Solution:** Create and use `{{DLV - eventModel.transaction_id}}`

**Variable Configuration:**
```
Variable Name: DLV - eventModel.transaction_id
Type: Data Layer Variable
Data Layer Variable Name: eventModel.transaction_id
```

**Tag Update:**
```javascript
// In Meta - purchase objectPropertyList:
{name: "order_id", value: {{DLV - eventModel.transaction_id}}}
```

**Verify in GTM Preview:**
```javascript
// Before fix:
order_id: undefined ❌

// After fix:
order_id: "71755-103351" ✅
```

---

### Issue 6: Meta Purchase - User Data Not Sent

**Symptom:** Customer information (email, phone, address) not being sent to Facebook

**Cause:** Using `{{EC - *}}` variables that read from `ecommerce.user_data.*` which doesn't exist in Unas

**Solution:** Create eventModel user data variables and update Advanced Matching list

**Variables Needed:**

| Variable Name | Data Layer Variable Name |
|--------------|-------------------------|
| `DLV - eventModel.user_data.email` | `eventModel.user_data.email` |
| `DLV - eventModel.user_data.phone_number` | `eventModel.user_data.phone_number` |
| `DLV - eventModel.user_data.address.first_name` | `eventModel.user_data.address.first_name` |
| `DLV - eventModel.user_data.address.last_name` | `eventModel.user_data.address.last_name` |
| `DLV - eventModel.user_data.address.city` | `eventModel.user_data.address.city` |
| `DLV - eventModel.user_data.address.postal_code` | `eventModel.user_data.address.postal_code` |
| `DLV - eventModel.user_data.address.country` | `eventModel.user_data.address.country` |

**Tag Updates in Meta - purchase:**

Replace all `{{EC - *}}` variables in advancedMatchingList:

```javascript
// Before (Wrong - returns undefined):
{name: "em", value: {{EC - email}}}
{name: "ph", value: {{EC - phone}}}
{name: "fn", value: {{EC - first_name}}}
{name: "ln", value: {{EC - last_name}}}
{name: "ct", value: {{EC - city}}}
{name: "zp", value: {{EC - postcode}}}
{name: "cn", value: {{EC - country}}}

// After (Correct - returns values):
{name: "em", value: {{DLV - eventModel.user_data.email}}}
{name: "ph", value: {{DLV - eventModel.user_data.phone_number}}}
{name: "fn", value: {{DLV - eventModel.user_data.address.first_name}}}
{name: "ln", value: {{DLV - eventModel.user_data.address.last_name}}}
{name: "ct", value: {{DLV - eventModel.user_data.address.city}}}
{name: "zp", value: {{DLV - eventModel.user_data.address.postal_code}}}
{name: "cn", value: {{DLV - eventModel.user_data.address.country}}}
```

**Important:** Pass raw, unhashed data. The Meta Pixel template automatically hashes data before sending to Facebook.

**Verify in GTM Preview:**

Before fix (Data Layer tab):
```javascript
// Data exists:
eventModel.user_data.email: "customer@example.com" ✅

// But tag shows:
advancedMatchingList → em: undefined ❌
```

After fix (Tags tab → Meta - purchase):
```javascript
advancedMatchingList:
  em: "customer@example.com" ✅
  ph: "+36301234567" ✅
  fn: "John" ✅
  ln: "Doe" ✅
  ct: "Budapest" ✅
  zp: "1111" ✅
  cn: "hu" ✅
```

**Verify in Facebook Events Manager:**
- Check "Customer Information" section
- Should show "7 parameters" or "Hashed" indicator
- Higher Event Match Quality score

---

### Issue 7: Low Event Match Quality and Event Coverage

**Symptoms in Facebook Events Manager:**
- Event Match Quality: 3.0-5.0/10 (should be >7.0)
- Event Coverage: 10-30% (should be >80%)
- "Event deduplication: Not meeting best practices"

**Cause 1: Using advancedMatchingList on events without customer data**

Unas only pushes `user_data` on the **purchase** event. All other events (view_item, add_to_cart, begin_checkout) do NOT have customer data available.

**Check in GTM Preview - Data Layer tab:**
```javascript
// For begin_checkout event:
{
  event: 'begin_checkout',
  eventModel: {
    items: [{...}],
    value: 6490,
    currency: 'HUF'
    // ❌ NO user_data object!
  }
}

// Only purchase has user_data:
{
  event: 'purchase',
  eventModel: {
    transaction_id: '12345',
    items: [{...}],
    value: 6490,
    currency: 'HUF',
    user_data: {           // ✅ Only on purchase!
      email: '...',
      phone_number: '...',
      address: {...}
    }
  }
}
```

**Problem:** If your Meta tags have advancedMatchingList with variables like `{{EC - email}}` or `{{DLV - eventModel.user_data.email}}`, they return `undefined` for non-purchase events.

**Impact:**
- Facebook receives empty customer parameters
- Events marked as low quality
- Many events discarded
- Poor attribution and reporting

**Solution:**

1. **Remove entire advancedMatchingList** from these Meta tags:
   - Meta - view_item
   - Meta - add_to_cart
   - Meta - begin_checkout
   - Meta - add_payment_info

2. **Keep advancedMatchingList ONLY in:**
   - Meta - purchase (with eventModel.user_data.* variables)

**Configuration:**
```javascript
// ❌ WRONG: begin_checkout with advancedMatchingList
{
  Event Name: "InitiateCheckout",
  Object Properties: [...],
  Advanced Matching: [
    {name: "em", value: {{EC - email}}},           // undefined!
    {name: "ph", value: {{EC - phone}}},           // undefined!
    {name: "fn", value: {{EC - first_name}}},      // undefined!
    // ... all undefined = hurts Event Match Quality
  ]
}

// ✅ CORRECT: begin_checkout WITHOUT advancedMatchingList
{
  Event Name: "InitiateCheckout",
  Object Properties: [
    {name: "content_ids", value: {{CJS - Array - Item IDs}}},
    {name: "currency", value: {{CJS - Universal Currency}}},
    {name: "value", value: {{CJS - Universal Value}}},
    {name: "contents", value: {{CJS - FB Contents Array}}}
  ]
  // NO Advanced Matching - improves Event Match Quality!
}
```

**Expected Results After Fix:**
- Event Match Quality: 3.0-4.5 → 7.0-8.5 ✅
- Event Coverage: 10-30% → 80%+ ✅
- Event deduplication: Improved (if SGTM event_id also fixed)

---

**Cause 2: Inconsistent event_id between client-side and server-side**

If using Server-Side GTM (SGTM), ensure:
- Client-side generates `event_id` (e.g., `fb.1.1699876543210.123456789`)
- Server-side forwards **same** `event_id` to Meta CAPI
- Both client and server send identical `event_id` for same event

**Check:**
1. GTM Preview → Client-side Meta tag → Check `event_id` value
2. SGTM Preview → Meta CAPI tag → Check `event_id` value
3. Values must match exactly for deduplication to work

**Solution:** Update SGTM Meta CAPI tag to use `{{Event Data - event_id}}` variable.

---

## Testing Checklist for Unas

### Data Layer Verification

**On product page, in Console:**

```javascript
// 1. Check eventModel exists
dataLayer.filter(e => e.event === 'view_item').map(e => ({
  hasEventModel: !!e.eventModel,
  hasItems: !!(e.eventModel && e.eventModel.items),
  items: e.eventModel ? e.eventModel.items : null
}))

// Should show: hasEventModel: true, hasItems: true

// 2. Check item structure
dataLayer.filter(e => e.eventModel && e.eventModel.items)
  .map(e => e.eventModel.items[0])

// Should show product with item_id, item_name, price, etc.

// 3. Verify currency and value
dataLayer.filter(e => e.eventModel).map(e => ({
  currency: e.eventModel.currency,
  value: e.eventModel.value
}))

// Should show: {currency: "HUF", value: "6490"}
```

---

### GTM Preview Verification

**Variables Tab - Check These:**

| Variable | Expected Value | Status |
|----------|----------------|--------|
| `DLV - eventModel.items` | `[{item_id: "M-...", ...}]` | Must have value |
| `DLV - eventModel.currency` | `"HUF"` | Must have value |
| `DLV - eventModel.value` | `"6490"` | Must have value |
| `CJS - Universal Items Array` | Array with items | Must have value |
| `CJS - Array - Item IDs` | `["M-241119-0046"]` | Must have value |
| `CJS - Universal Currency` | `"HUF"` | Must have value |
| `CJS - Universal Value` | `"6490"` or number | Must have value |

**If ANY show `undefined`, the configuration is wrong.**

---

### Meta Pixel Tag Verification

**Tag: Meta - view_item**

**objectPropertyList should show:**

```javascript
[
  {name: "content_ids", value: ["M-241119-0046"]},          // ✅ Product ID
  {name: "content_type", value: "product"},                  // ✅ Constant
  {name: "content_name", value: "Mikan Adult Száraz..."},   // ✅ Product name
  {name: "currency", value: "HUF"},                          // ✅ Currency
  {name: "value", value: "6490"},                            // ✅ Price
  {name: "contents", value: [{id: "M-...", quantity: 1}]}  // ✅ Contents array
]
```

**❌ If content_ids is empty, undefined, or contains a URL → WRONG**

---

## Platform-Specific Best Practices

### 1. Always Use Universal Variables

Create "Universal" variables that check multiple locations:
- Primary: `eventModel.*` (for Unas)
- Fallback: `ecommerce.*` (for standard platforms)
- Final fallback: Default values (e.g., `'HUF'`)

This makes your GTM container **portable** across platforms.

---

### 2. Don't Try to Normalize Unas Data

**❌ Don't do this:**
- Custom HTML tags that intercept `dataLayer.push`
- JavaScript that tries to restructure data
- Transformation tags that run early

**✅ Do this instead:**
- Read from `eventModel` directly
- Use Data Layer Variables with correct paths
- Let GTM handle the internal transformation

---

### 3. Test with Console Before Building Tags

Always verify data structure in console first:

```javascript
// Quick test for Unas
console.log('Latest view_item:',
  dataLayer.filter(e => e.event === 'view_item').pop()
);
```

If you see `eventModel` in the output → it's Unas format.

---

### 4. Document Deviations

In `client_info.md` or `config.md`, note:

```markdown
## Platform: Unas Webshop

**Data Layer Structure:** Non-standard (eventModel)
**Variables Required:** eventModel.* paths
**Special Configuration:** See platforms/unas_webshop.md
```

---

### 5. Event ID Deduplication - Critical for Server-Side Tracking

**⚠️ CRITICAL:** When using Server-Side GTM (SGTM) with Meta Pixel, you MUST implement proper event_id synchronization to prevent double-counting.

#### The Problem: Different event_id Values

Without proper configuration:
```
Client-side Meta Pixel: event_id = "fb.1.1762885000.111111111"
Server-side FB CAPI:    event_id = "fb.1.1762885000.222222222"  ❌ DIFFERENT!

Result: Facebook counts as 2 separate events ❌
```

#### The Solution: Synchronized event_id Generation

**For PageView (Single event per page load):**

1. **Create Custom HTML Tag:** `INIT - Generate Page Event ID`
   - Trigger: Initialization - All Pages
   - Generates ONE event_id per page load
   - Stores in dataLayer as `page_event_id`

**Code:**
```javascript
<script>
(function() {
  'use strict';

  if (!window.__gtm_page_event_id) {
    var timestamp = new Date().getTime();
    var random = Math.floor(Math.random() * 1000000000);
    var eventId = 'fb.1.' + timestamp + '.' + random;

    window.__gtm_page_event_id = eventId;

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({
      'event': 'page_event_id_ready',
      'page_event_id': eventId
    });
  }
})();
</script>
```

2. **Create Data Layer Variable:** `DLV - page_event_id`
   - Type: Data Layer Variable
   - Data Layer Variable Name: `page_event_id`

3. **Use in PageView Tags Only:**
   - Meta - basetag - all pages: `{{DLV - page_event_id}}`
   - GA4 - Configuratietag: `{{DLV - page_event_id}}`

**For All Other Events (Unique event_id per event):**

1. **Create Custom JavaScript Variable:** `CJS - Event Specific event_id`

**Code:**
```javascript
function() {
  var eventName = {{Event}};

  // For PageView, use the shared page_event_id
  if (eventName === 'gtm.init' || eventName === 'gtm.js') {
    return {{DLV - page_event_id}};
  }

  // For all other events, check if already generated for this specific event
  var eventKey = '__event_id_' + eventName;

  if (!window[eventKey]) {
    var timestamp = new Date().getTime();
    var random = Math.floor(Math.random() * 1000000000);
    window[eventKey] = 'fb.1.' + timestamp + '.' + random;
  }

  return window[eventKey];
}
```

2. **Use in All Event Tags:**
   - Meta - view_item: `{{CJS - Event Specific event_id}}`
   - Meta - add_to_cart: `{{CJS - Event Specific event_id}}`
   - Meta - begin_checkout: `{{CJS - Event Specific event_id}}`
   - Meta - purchase: `{{CJS - Event Specific event_id}}`
   - GA4 Event tags: `{{CJS - Event Specific event_id}}`

#### Tag Sequencing for GA4 Config

**CRITICAL:** GA4 Configuration tag must fire AFTER event_id is generated.

**In GA4 - Configuratietag → Advanced Settings → Tag Sequencing:**
- ✅ Setup Tag: `INIT - Generate Page Event ID`
- ✅ Don't fire this tag if setup tag fails

#### Expected Result After Implementation

**PageView:**
```
Client-side: event_id = "fb.1.1762885000.111111111"
Server-side: event_id = "fb.1.1762885000.111111111"  ✅ SAME
→ Facebook deduplicates → Counts as 1 PageView ✅
```

**view_item (Different from PageView):**
```
Client-side: event_id = "fb.1.1762885005.222222222"  ← NEW ID
Server-side: event_id = "fb.1.1762885005.222222222"  ✅ SAME
→ Facebook deduplicates → Counts as 1 ViewContent ✅
```

**add_to_cart (Different from view_item):**
```
Client-side: event_id = "fb.1.1762885010.333333333"  ← NEW ID
Server-side: event_id = "fb.1.1762885010.333333333"  ✅ SAME
→ Facebook deduplicates → Counts as 1 AddToCart ✅
```

**Key Principle:** Each unique event occurrence gets a unique event_id, but the same event sent from client and server shares the same event_id.

#### Metrics Improvement

**Before Deduplication Fix:**
- Event Match Quality: 4.4/10 ❌
- Event Coverage: 9% ❌
- Event Deduplication: Not meeting best practices ❌
- Facebook sees: 2x events (browser + server counted separately)

**After Deduplication Fix:**
- Event Match Quality: 7.0-8.5/10 ✅
- Event Coverage: 80%+ ✅
- Event Deduplication: Meeting best practices ✅
- Facebook sees: 1x event (properly deduplicated)

---

### 6. Customer Data Availability - Critical for Meta Pixel

**⚠️ IMPORTANT:** Unas does NOT push `user_data` for all events.

#### When Customer Data IS Available:

✅ **purchase event** - Full customer data in `eventModel.user_data`:
```javascript
{
  event: 'purchase',
  eventModel: {
    user_data: {
      email: 'customer@example.com',
      phone_number: '+36301234567',
      address: {
        first_name: 'John',
        last_name: 'Doe',
        city: 'Budapest',
        postal_code: '1111',
        country: 'hu'
      }
    }
  }
}
```

#### When Customer Data is NOT Available:

❌ **view_item** - User just browsing, not logged in
❌ **add_to_cart** - User hasn't provided contact info
❌ **begin_checkout** - User hasn't filled checkout form yet
❌ **add_payment_info** - Customer data may not be captured yet

#### Best Practice for Meta Pixel Tags:

**DO NOT use advancedMatchingList for events without customer data.**

**Why:** Empty or `undefined` customer parameters **significantly hurt** your Event Match Quality score.

**Configuration Recommendations:**

```javascript
// ✅ CORRECT: Meta - purchase (has user_data)
{
  Event Name: "Purchase",
  Object Properties: [...],
  Advanced Matching: [
    {name: "em", value: {{DLV - eventModel.user_data.email}}},
    {name: "ph", value: {{DLV - eventModel.user_data.phone_number}}},
    {name: "fn", value: {{DLV - eventModel.user_data.address.first_name}}},
    // ... full user data available
  ]
}

// ✅ CORRECT: Meta - view_item (NO advancedMatchingList)
{
  Event Name: "ViewContent",
  Object Properties: [
    {name: "content_ids", value: {{CJS - Array - Item IDs}}},
    {name: "content_type", value: "product"},
    {name: "currency", value: {{CJS - Universal Currency}}},
    {name: "value", value: {{CJS - Universal Value}}},
    {name: "contents", value: {{CJS - FB Contents Array}}}
  ]
  // NO Advanced Matching - customer data not available
}

// ✅ CORRECT: Meta - begin_checkout (NO advancedMatchingList)
{
  Event Name: "InitiateCheckout",
  Object Properties: [...],
  // NO Advanced Matching - user hasn't filled form yet
}
```

#### Impact on Facebook Metrics:

**With undefined customer parameters:**
- Event Match Quality: 3.0-4.5/10 ❌
- Event Coverage: 10-30% ❌
- Many events discarded due to poor data quality

**Without advancedMatchingList (when data unavailable):**
- Event Match Quality: 7.0-8.5/10 ✅
- Event Coverage: 80%+ ✅
- All events processed with available product data

#### Exception: Enhanced Conversions with ProfitMetrics

If using **ProfitMetrics** or similar Enhanced Conversions solution:
- ProfitMetrics can capture email during browsing
- Pushes `email` to data layer on `enhanced_conversions` event
- Create `PM Email` variable (reads from `email` in data layer)
- Can use in advancedMatchingList for all events

**Example with ProfitMetrics:**
```javascript
// With ProfitMetrics enabled
advancedMatchingList: [
  {name: "em", value: {{PM Email}}}  // Available via ProfitMetrics
]
```

#### Summary Table:

| Event | Customer Data Available? | Use advancedMatchingList? |
|-------|-------------------------|---------------------------|
| view_item | ❌ No | ❌ No (unless using ProfitMetrics) |
| add_to_cart | ❌ No | ❌ No (unless using ProfitMetrics) |
| begin_checkout | ❌ No | ❌ No (unless using ProfitMetrics) |
| add_payment_info | ❌ No | ❌ No (unless using ProfitMetrics) |
| purchase | ✅ Yes (eventModel.user_data) | ✅ Yes (use eventModel variables) |

**Key Principle:** Only send customer data parameters when they're **reliably populated**. Empty parameters hurt more than omitting them.

---

## Currency and Market Notes

### Default Currency

**Unas Primary Market:** Hungary
**Default Currency:** HUF (Hungarian Forint)
**Currency Symbol:** Ft

### Price Display

Prices in Unas typically:
- Include VAT/tax
- Display with space separator for thousands: `6 490 Ft`
- Sent to dataLayer as string: `"6490"`

**Always convert to number for analytics:**
```javascript
parseFloat(price.replace(/[^0-9.-]/g, ''))
```

---

## Integration Notes

### Taggrs Templates Compatibility

Taggrs templates are designed for **standard GA4 format** (with `ecommerce` wrapper).

**When using Taggrs with Unas:**
1. Use the Universal variables approach documented here
2. Taggrs templates will work with the Universal variables
3. The Universal variables act as an "adapter layer"

```
Unas → eventModel → Universal Variables → Taggrs Templates → Tags
```

---

### Server-Side GTM

When forwarding to server-side GTM:

**Client → Server forwarding:**
- Data is in `eventModel` on client
- Use Universal variables to extract
- Forward using standard event data parameters
- Server-side can read from `event_data.*`

**Server-side variables:**
```
{{Event Data - items}}
{{Event Data - currency}}
{{Event Data - value}}
```

These will work because Universal variables normalize the data before forwarding.

---

## Troubleshooting Guide

### Symptom: All variables show undefined

**Check:**
1. Is data actually in `eventModel`?
   - Console: `dataLayer.filter(e => e.eventModel)`
2. Are variables reading from `eventModel.*`?
3. Is GTM Preview using latest container version?

**Fix:** Update variables to use `eventModel` paths.

---

### Symptom: Meta Pixel gets wrong data

**Check:**
1. What does `CJS - Array - Item IDs` return in Variables tab?
2. What does `CJS - Universal Items Array` return?
3. In Meta tag, what variables are used in objectPropertyList?

**Fix:** Ensure tag uses `{{CJS - Array - Item IDs}}`, not direct data layer variables.

---

### Symptom: Purchase value is 0 or wrong

**Check:**
1. Is `value` field a string? `"6490"` vs `6490`
2. Is variable converting string to number?
3. Is value in correct unit (not divided by 100)?

**Fix:** Add parseFloat conversion in Universal Value variable.

---

## Summary: Key Differences from Standard Platforms

| Aspect | Standard Platforms | Unas Webshop |
|--------|-------------------|--------------|
| **Data Structure** | `ecommerce.items` | `eventModel.items` |
| **Currency Location** | `ecommerce.currency` | `eventModel.currency` |
| **Value Location** | `ecommerce.value` | `eventModel.value` |
| **Price Type** | Number | String |
| **Value Type** | Number | String |
| **Normalization** | Not needed | Read from eventModel |
| **Standard DLV Variables** | Work directly | Return undefined |
| **Required Approach** | Direct reading | Universal variables with fallbacks |

---

## Quick Setup Guide for Unas

### Step 1: Create eventModel Variables (10 min)

**Product Data Variables:**
1. `DLV - eventModel.items` → reads `eventModel.items`
2. `DLV - eventModel.currency` → reads `eventModel.currency`
3. `DLV - eventModel.value` → reads `eventModel.value`
4. `DLV - eventModel.items.0.item_name` → reads first item name

**Transaction Data Variable (for purchase events):**
5. `DLV - eventModel.transaction_id` → reads `eventModel.transaction_id`

**User Data Variables (for purchase events with Meta Pixel):**
6. `DLV - eventModel.user_data.email` → reads `eventModel.user_data.email`
7. `DLV - eventModel.user_data.phone_number` → reads `eventModel.user_data.phone_number`
8. `DLV - eventModel.user_data.address.first_name` → reads `eventModel.user_data.address.first_name`
9. `DLV - eventModel.user_data.address.last_name` → reads `eventModel.user_data.address.last_name`
10. `DLV - eventModel.user_data.address.city` → reads `eventModel.user_data.address.city`
11. `DLV - eventModel.user_data.address.postal_code` → reads `eventModel.user_data.address.postal_code`
12. `DLV - eventModel.user_data.address.country` → reads `eventModel.user_data.address.country`

**Note:** Variables 5-12 are only needed if you're tracking purchase events with Meta Pixel and want to send customer data for better match rates.

---

### Step 2: Create Universal Variables (10 min)

1. `CJS - Universal Items Array` → checks eventModel, then ecommerce
2. `CJS - Universal Currency` → checks eventModel, then ecommerce, then "HUF"
3. `CJS - Universal Value` → checks eventModel, then ecommerce
4. `CJS - Array - Item IDs` → extracts IDs from Universal Items Array
5. `CJS - FB Contents Array` → creates FB format from items

---

### Step 3: Update Tags (5 min)

Update all ecommerce tags (GA4, Meta, etc.) to use Universal variables instead of direct data layer variables.

---

### Step 4: Test (10 min)

1. GTM Preview → Variables tab → verify all show values
2. Tags → Meta Pixel → verify objectPropertyList has all values
3. Console → verify no errors

**Total setup time: ~30 minutes**

---

---

## Issue 8: Meta CAPI Purchase Event - Missing Parameters

**Symptom:** Meta CAPI returns 400 error - "Missing value in purchase event"

**Root Cause:** Web container GA4 tag not forwarding purchase data to server container.

**What Was Missing:**
- ❌ `value` (purchase amount)
- ❌ `transaction_id` (order ID)
- ❌ `content_ids` (product IDs array)
- ❌ User data (email, phone, address)

**Why This Happens:**
GA4's server-side forwarding only sends parameters that are **explicitly configured** in the GA4 tag. By default, GA4 sends:
- Event name ✅
- Standard parameters (currency, language, page_location) ✅
- Event parameters you explicitly add ✅

But it does NOT automatically send:
- Purchase value ❌
- Transaction ID ❌
- Items array details ❌
- User properties ❌

### Solution: Configure GA4 Tag to Forward Required Data

**In Web Container (GTM-5F544SR3) - GA4 Purchase Tag:**

Add these **Event Parameters:**

| Parameter Name | Value Variable | What It Sends |
|----------------|----------------|---------------|
| `transaction_id` | `{{DLV - eventModel.transaction_id}}` | Order ID |
| `value` | `{{CJS - Universal Value}}` | Purchase total |
| `currency` | `{{CJS - Universal Currency}}` | Currency code |
| `tax` | `{{DLV - eventModel.tax}}` | Tax amount |
| `shipping` | `{{DLV - eventModel.shipping}}` | Shipping cost |
| `items` | `{{CJS - Universal Items Array}}` | Full items array |
| `content_ids` | `{{CJS - Array - Item id's}}` | Product IDs |

Add these **User Properties** (reading from root-level `user_data`):

| User Property Name | Value Variable | What It Sends |
|-------------------|----------------|---------------|
| `email` | `{{DLV - user_data.email}}` | Customer email |
| `phone_number` | `{{DLV - user_data.phone_number}}` | Customer phone |
| `first_name` | `{{DLV - user_data.address.first_name}}` | First name |
| `last_name` | `{{DLV - user_data.address.last_name}}` | Last name |
| `street` | `{{DLV - user_data.address.street}}` | Street address |
| `city` | `{{DLV - user_data.address.city}}` | City |
| `region` | `{{DLV - user_data.address.region}}` | Region/state |
| `postal_code` | `{{DLV - user_data.address.postal_code}}` | Postal code |
| `country` | `{{DLV - user_data.address.country}}` | Country code |

**Important Note:** Unas pushes `user_data` at the **root level** (not inside `eventModel`), so these variables must read from `user_data.*`, not `eventModel.user_data.*`.

---

### Critical: content_ids and contents Parameters

**⚠️ COUNTER-INTUITIVE BEHAVIOR:**

When trying to send arrays from client to server via GA4:

**What DOESN'T Work:**
```javascript
// In web GA4 tag:
Event Parameter: fb_contents = {{CJS - FB Contents Array}}
// Returns: [{id: "M-123", quantity: 1}]

// Server receives:
fb_contents: "[object Object]"  ❌ BROKEN!
```

**Why:** GA4 stringifies complex objects/arrays when forwarding them, resulting in useless `"[object Object]"` strings.

**What DOES Work:**

**Option 1: Send items array (works!):**
```javascript
// In web GA4 tag:
Event Parameter: items = {{CJS - Universal Items Array}}

// Server receives:
items: [{item_id: "M-123", quantity: 1, price: 385}]  ✅ WORKS!
```

**Option 2: Send content_ids as string (works!):**
```javascript
// In web GA4 tag:
Event Parameter: content_ids = {{CJS - Array - Item id's}}
// This variable should return comma-separated string: "M-123,M-456"

// Server receives:
content_ids: "M-241119-0036,M-241119-0034"  ✅ WORKS!
```

**Key Principle:**
- ✅ **Objects with nested properties** (like items array) forward correctly
- ❌ **Simple arrays of primitives or flat objects** get stringified
- ✅ **Comma-separated strings** work as alternative

---

### Server-Side CAPI Configuration

**In Server Container - FB conversion API Tag:**

**customDataList:**
```javascript
[
  {name: "currency", value: {{currency}}},
  {name: "value", value: {{value}}},
  {name: "order_id", value: {{transaction_id}}},
  {name: "content_ids", value: {{content_ids}}},
  {name: "content_type", value: "product"}
]
```

**⚠️ CRITICAL: Event Data Variable Key Paths**

**WRONG (common mistake):**
```
Variable Name: content_ids
Type: Event Data
Key Path: eventModel.content_ids  ❌
```

This tries to read `eventModel.eventModel.content_ids` (double nesting) and returns `undefined`.

**CORRECT:**
```
Variable Name: content_ids
Type: Event Data
Key Path: content_ids  ✅
```

**Why:** Server-side Event Data variables automatically read from `eventModel`. You should NOT include `eventModel.` in the Key Path.

**All server Event Data variables:**
- `content_ids` → reads `eventModel.content_ids` ✅
- `transaction_id` → reads `eventModel.transaction_id` ✅
- `value` → reads `eventModel.value` ✅
- `currency` → reads `eventModel.currency` ✅
- `email` → reads `eventModel.email` ✅
- `phone` → reads `eventModel.phone_number` ✅

---

### Meta CAPI content_ids Format

**Meta accepts multiple formats:**
- ✅ Array: `["M-241119-0036", "M-241119-0034"]`
- ✅ Comma-separated string: `"M-241119-0036,M-241119-0034"`
- ✅ Single ID: `"M-241119-0036"`

Since GA4 forwards `content_ids` as a comma-separated string, use it as-is. Meta's API accepts it.

**You do NOT need both content_ids AND contents.** Meta requires **either** `content_ids` **or** `contents`. The comma-separated string format for `content_ids` is sufficient.

---

### userDataList Configuration

**In Server Container - FB CAPI Tag:**

```javascript
[
  {name: "em", value: {{email}}},
  {name: "ph", value: {{phone}}},
  {name: "fn", value: {{first_name}}},
  {name: "ln", value: {{last_name}}},
  {name: "st", value: {{street}}},
  {name: "ct", value: {{city}}},
  {name: "zp", value: {{postal_code}}},
  {name: "country", value: {{country}}},
  {name: "client_ip_address", value: {{client_ip_address}}},
  {name: "client_user_agent", value: {{client_user_agent}}},
  {name: "fbc", value: {{fbc}}},
  {name: "fbp", value: {{fbp}}},
  {name: "external_id", value: {{external_id}}}
]
```

All these variables are **Event Data** type reading from eventModel (without `eventModel.` prefix in Key Path).

**Important:** Meta Pixel template automatically hashes user data. Pass **raw** (unhashed) data from variables. The template normalizes and hashes before sending to Facebook.

---

### Expected Results After Configuration

**Server Container Event Data (purchase event):**
```javascript
{
  transaction_id: "71755-103518",
  value: 9795,
  currency: "HUF",
  content_ids: "M-241119-0036,M-241119-0034",
  tax: 1808.1496,
  shipping: 1290,
  items: [
    {item_id: "M-241119-0036", quantity: 1, price: 3675, ...},
    {item_id: "M-241119-0034", quantity: 1, price: 4830, ...}
  ],
  email: "customer@example.com",
  phone_number: "+36309831540",
  first_name: "Elek",
  last_name: "Test",
  street: "Kis u. 8.",
  city: "Budapest, XI.",
  postal_code: "1111",
  country: "hu"
}
```

**Meta CAPI Request:**
```json
{
  "custom_data": {
    "currency": "HUF",
    "value": 9795,
    "order_id": "71755-103518",
    "content_ids": "M-241119-0036,M-241119-0034",
    "content_type": "product"
  },
  "user_data": {
    "em": "[hashed]",
    "ph": "[hashed]",
    "fn": "[hashed]",
    "ln": "[hashed]",
    "st": "[hashed]",
    "ct": "[hashed]",
    "zp": "[hashed]",
    "country": "[hashed]",
    "client_ip_address": "37.76.23.242",
    "client_user_agent": "Mozilla/5.0...",
    "fbp": "fb.1.1761564447486.517257056883427575",
    "external_id": "d8e8e313-766e-4e7e-a620-84466dedd1b7"
  },
  "event_id": "fb.1.1763388921522.641019770"
}
```

**Meta Response:** 200 OK ✅

---

### Verification Checklist

**In Server GTM Preview - Variables Tab:**
```javascript
✅ {{transaction_id}}: "71755-103518"
✅ {{value}}: 9795
✅ {{currency}}: "HUF"
✅ {{content_ids}}: "M-241119-0036,M-241119-0034"
✅ {{email}}: "customer@example.com"
✅ {{phone}}: "+36309831540"
✅ {{first_name}}: "Elek"
✅ {{last_name}}: "Test"
✅ {{street}}: "Kis u. 8."
✅ {{city}}: "Budapest, XI."
✅ {{postal_code}}: "1111"
✅ {{country}}: "hu"
```

**Common Failures:**
- ❌ All variables `undefined` → Check Key Paths (remove `eventModel.` prefix)
- ❌ `content_ids` is `undefined` → Check web GA4 tag has event parameter
- ❌ User data all `undefined` → Check web GA4 tag has user properties
- ❌ 400 error "missing value" → `value` not forwarded from client

---

### Key Learnings - Counter-Intuitive Behaviors

1. **⚠️ GA4 doesn't auto-forward purchase data** - You MUST manually add event parameters and user properties in the web GA4 tag

2. **⚠️ Simple arrays don't forward correctly** - GA4 stringifies them to `"[object Object]"`. Use objects-with-properties (items array) or comma-separated strings instead

3. **⚠️ Server Event Data variables auto-read from eventModel** - Don't use `eventModel.` prefix in Key Path or you'll get double nesting

4. **⚠️ Comma-separated string works for content_ids** - Meta accepts it even though docs show array format

5. **⚠️ User data at root level, not eventModel** - Unas pushes `user_data` at root, web variables must read from `user_data.*` not `eventModel.user_data.*`

6. **⚠️ Items array forwards but content_ids doesn't** - Complex objects (items) work, simple arrays don't. Build arrays server-side from items if needed

7. **⚠️ Meta template auto-hashes** - Always pass raw user data, never pre-hash

---

## Version History

**v1.5** - 2025-11-17
- Added Issue 8: "Meta CAPI Purchase Event - Missing Parameters"
- Documented complete web-to-server data forwarding configuration
- Added counter-intuitive behaviors section
- Explained GA4 array stringification issues
- Documented Event Data variable Key Path gotcha (no eventModel. prefix)
- Added complete user data forwarding guide
- Explained content_ids comma-separated string format
- Added verification checklist and common failures
- Based on mancsbazis.hu CAPI purchase debugging session

**v1.4** - 2024-11-11
- Added Best Practice #6: "Event ID Deduplication - Critical for Server-Side Tracking"
  - Complete problem statement with double-counting examples
  - Two-tier event_id strategy (page_event_id vs event-specific)
  - Full implementation code for INIT tag and CJS variable
  - Tag sequencing instructions for GA4 Config
  - Before/after examples showing proper deduplication
  - Expected metrics improvements (EMQ, Coverage, Deduplication status)
  - Which tags use which event_id variable (detailed breakdown)
- Comprehensive solution for "Event deduplication: Not meeting best practices" warning

**v1.3** - 2024-11-11
- Added Best Practice #5: "Customer Data Availability - Critical for Meta Pixel"
  - When customer data IS available (purchase only)
  - When customer data is NOT available (view_item, add_to_cart, begin_checkout)
  - Impact on Event Match Quality and Event Coverage
  - Configuration recommendations with examples
  - ProfitMetrics exception for Enhanced Conversions
  - Summary table of event types and advancedMatchingList usage
- Added Issue 7: "Low Event Match Quality and Event Coverage"
  - Diagnosis of advancedMatchingList with undefined parameters
  - Before/after configuration examples
  - Expected metric improvements
  - Server-side event_id deduplication guidance

**v1.2** - 2024-11-11
- Added critical section: order_id and transaction_id must match for deduplication
- Added complete "Verification Checklist for Meta - purchase"
  - Variable values check (11 variables)
  - Tag configuration check (objectPropertyList + advancedMatchingList)
  - Network request verification
  - Facebook Events Manager verification
  - Common failures and fixes (5 scenarios)
- Comprehensive pre-launch testing guide

**v1.1** - 2024-11-11
- Added user data configuration for purchase events
- Added transaction_id variable documentation
- Added hashing explanation (raw data vs hashed)
- Added Issue 5 (order_id missing) troubleshooting
- Added Issue 6 (user data not sent) troubleshooting
- Updated Quick Setup Guide with user data variables

**v1.0** - 2024-11-11
- Initial documentation
- Based on debugging session with mancsbazis.hu client
- Documented eventModel structure and Universal variables approach

---

## Related Documentation

- `methodology/01_core_debugging_process.md` - Universal debugging steps
- `methodology/02_data_consistency_rules.md` - Data consistency requirements
- `platforms/wordpress_woocommerce.md` - Standard platform for comparison
- `client_config/CLIENT_CONFIG_TEMPLATE.md` - Client configuration template

---

## Contact & Support

**For Unas-specific questions:**
- Unas support: [Unas website]
- Platform documentation: [Unas developer docs]

**For GTM debugging:**
- Use this framework
- Follow Universal variables approach
- Test in console first

---

**Last Updated:** 2025-11-11
**Applies to:** Unas Webshop platform
**GTM Compatibility:** All versions
**Status:** Production-ready
**Documentation Version:** v1.3
