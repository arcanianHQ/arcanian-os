---
scope: shared
---

# WordPress / WooCommerce Platform Knowledge

## Platform Overview

**Platform Name**: WordPress + WooCommerce  
**Version Coverage**: WooCommerce 5.0+ (WordPress 5.8+)  
**Market**: Global, most popular e-commerce platform  
**Typical Use Cases**: Small to medium businesses, highly customizable

## Platform-Specific Data Layer

### Standard WooCommerce Data Layer

WooCommerce **does not** have a native GA4 data layer. Implementation depends on:
1. **Manual implementation** (custom code in theme)
2. **Plugin-based** (GTM4WP, WooCommerce Google Analytics Integration, etc.)
3. **Taggrs or similar services**

⚠️ **Key Point**: Data layer structure varies significantly based on implementation method!

### Common Plugin Implementations

#### GTM4WP (GTM for WordPress)
Popular free plugin that adds GA4 data layer:

```javascript
// Product page view (GTM4WP format)
dataLayer.push({
  event: 'view_item',
  ecommerce: {
    currencyCode: 'USD',
    detail: {
      products: [{
        id: '12345',  // Can be ID or SKU, configured in plugin
        name: 'Product Name',
        price: '29.99',  // Often string, not number!
        brand: 'Brand Name',
        category: 'Category',
        variant: 'Color'
      }]
    }
  }
});
```

#### Enhanced E-commerce for WooCommerce (Taggrs/PixelYourSite)
```javascript
// More GA4-compliant structure
dataLayer.push({
  event: 'view_item',
  ecommerce: {
    currency: 'USD',
    value: 29.99,
    items: [{
      item_id: 'SKU-123',  // SKU preferred
      item_name: 'Product Name',
      price: 29.99,  // Number
      quantity: 1
    }]
  }
});
```

## Product ID Standards

### Default Product ID Options
WooCommerce has TWO identifiers:
1. **Post ID**: Numeric, auto-increment (e.g., 12345)
2. **SKU**: Alphanumeric, user-defined (e.g., "SHIRT-BLUE-M")

**Important**: **Post ID changes** if product is deleted and recreated. **SKU is stable**.

**Recommendation**: Use SKU for tracking (more stable, business-friendly)

### Configuration Location
WooCommerce → Products → Edit Product → Product Data → General → SKU field

### Variant Handling
**Variable Products** in WooCommerce:
- Parent product has ID + SKU
- Each variation has own ID + SKU

**Common Patterns**:
1. **Parent SKU only**: "SHIRT-BASIC" for all variants
2. **Variant SKU**: "SHIRT-BASIC-BLUE-M", "SHIRT-BASIC-RED-L"
3. **No SKU**: Falls back to variation ID (bad practice)

**Example**:
```
Parent Product: T-Shirt (Post ID: 100, SKU: "SHIRT-001")
Variants:
- Red, Small (Variation ID: 101, SKU: "SHIRT-001-RED-S")
- Red, Medium (Variation ID: 102, SKU: "SHIRT-001-RED-M")
- Blue, Small (Variation ID: 103, SKU: "SHIRT-001-BLUE-S")
```

**Tracking Recommendation**: 
- PLP: Use parent SKU
- PDP (after variant selected): Use variant SKU
- Cart/Checkout/Purchase: Use variant SKU

### Common ID Issues on WooCommerce

1. **Issue: Mixed Post ID and SKU**
   - Symptom: PLP shows Post IDs, PDP shows SKUs
   - Cause: Different variables used in different contexts
   - Fix: Standardize on SKU everywhere

2. **Issue: Missing SKUs**
   - Symptom: Some products tracked with ID, some with SKU
   - Cause: Store admin didn't populate SKU field
   - Fix: Populate SKUs for all products, or consistently use Post ID

3. **Issue: Variation ID vs Parent ID**
   - Symptom: Same product appears as different IDs
   - Cause: Not handling variation selection properly
   - Fix: Track variation ID/SKU after selection, parent before

## Price Handling

### Default Price Format
**Type**: String in WooCommerce database, but plugins vary  
**Decimal Places**: 2 (configurable, but 2 is default)  
**Tax Inclusion**: **Configurable** (critical to check!)  
**Currency Symbol**: Stored separately from price

**Database**: Prices stored as decimal(10,2) - numeric format  
**Frontend**: Can be formatted as string with symbol

### Tax Configuration
**Location**: WooCommerce → Settings → Tax  
**Options**:
- "Prices entered with tax included"
- "Prices entered with tax excluded"
- "Display prices in shop: Including tax / Excluding tax"

**Critical**: 
- **Database price** may include OR exclude tax
- **Display price** may differ from database price
- **Data layer** should reflect what customer sees

**Admin Path**: `wp-admin/admin.php?page=wc-settings&tab=tax`

### Example Scenarios
```
Scenario 1: Tax Included
- Base Price: $25.00
- Tax (20%): $5.00
- Database price: $30.00
- Display price: $30.00
- Data layer should send: 30.00

Scenario 2: Tax Excluded
- Base Price: $25.00
- Tax (20%): $5.00 (calculated at checkout)
- Database price: $25.00
- Display price: $25.00 (or "$25.00 + tax")
- Data layer should send: 25.00

Consistency Rule: Use displayed price consistently across all events!
```

### Multiple Currencies
**Native Support**: No (single currency)  
**Plugin Support**: Yes (WPML, WooCommerce Multilingual, currency switchers)  
**Tracking Impact**: Currency code must be dynamic if multi-currency

## Product Name Handling

### Character Limits
**Database**: VARCHAR(255) - but WordPress allows longer via post_title  
**Listing Page**: Theme-dependent, often truncated  
**Detail Page**: Full name displayed  
**Data Layer**: Should send full name (no truncation)

### Special Characters
**Encoding**: UTF-8 ✅  
**HTML**: WordPress stores HTML entities for special chars  
**Common Issues**:
- Apostrophes: "Men's Shirt" stored as "Men\&#039;s Shirt" or "Men's Shirt"
- Quotes: "12\" Widget" may be escaped
- Trademarks: ™, ®, © generally handled well

**Recommendation**: 
```javascript
// In GTM variable, decode HTML entities if needed
function() {
  var name = {{DL - Product Name}};
  var txt = document.createElement('textarea');
  txt.innerHTML = name;
  return txt.value;
}
```

## Checkout Flow

### Number of Checkout Steps
**Standard**: **Single page** checkout (WooCommerce default)  
**Customizable**: Yes, many themes/plugins modify this

**Default Steps on Single Page**:
1. Billing & Shipping Information (top of page)
2. Order Review (bottom of page)
3. Payment Method Selection
4. Place Order Button

### Events Fired Per Step
With proper GTM implementation:

```
Page Load: begin_checkout event

Field Interactions: (optional tracking)
- Email entered
- Shipping method selected
- Payment method selected

Button Click: "Place Order" → triggers backend processing
On Success: Redirect to Thank You page

Thank You Page: purchase event
```

**Important**: Purchase event should fire **server-side** to ensure reliability!

### Guest vs Registered Checkout
**Both Available**: User can checkout as guest or create account  
**Data Layer Difference**: 
- Registered: `user_id` may be available
- Guest: `user_id` is null or empty

**User ID Handling**:
```javascript
// Check if user is logged in
user_id: <?php echo is_user_logged_in() ? get_current_user_id() : 'null'; ?>
```

## Extensions & Plugins

### Commonly Used Extensions That Affect Tracking

#### WooCommerce Subscriptions
**What it does**: Recurring payment products  
**Impact on GTM**: 
- Different product types to track
- Subscription renewal events
- Subscription status changes  
**Compatibility**: Requires custom tracking for subscription-specific events

#### WooCommerce Bookings
**What it does**: Bookable products (appointments, rentals)  
**Impact on GTM**: Different product data structure, date/time parameters  

#### WPML / WooCommerce Multilingual
**What it does**: Multi-language and multi-currency  
**Impact on GTM**:
- Product IDs may differ per language
- Currency code must be dynamic
- Product names in different languages  
**Recommendation**: Use language-neutral ID (SKU), track language separately

#### WooCommerce Product Bundles
**What it does**: Bundle multiple products  
**Impact on GTM**: 
- Track bundle as single item OR individual items?
- Price calculation complexity
**Recommendation**: Document client's preference

### GTM-Specific Plugins

Popular GTM integration plugins:
- **GTM4WP** (DuracellTomi) - Free, popular
- **PixelYourSite** - Freemium, Facebook + GA4
- **WooCommerce Google Analytics Integration** - Official, basic
- **Enhanced E-commerce for WooCommerce** - Various developers

**Taggrs Approach**: Typically **replaces** these plugins with custom implementation

## Platform-Specific Variables

### WordPress/PHP Variables Available

For manual implementation, these PHP variables are available:

```php
<?php
// Product Data (single product page)
global $product;
$product->get_id();            // Post ID
$product->get_sku();           // SKU
$product->get_name();          // Product Name
$product->get_price();         // Current price
$product->get_regular_price(); // Regular price
$product->get_sale_price();    // Sale price (if on sale)
$product->get_type();          // simple, variable, grouped, etc.

// Cart Data
WC()->cart->get_cart();        // Array of cart items
WC()->cart->get_cart_contents_total();  // Cart total

// Order Data (thank you page)
$order = wc_get_order($order_id);
$order->get_total();           // Order total
$order->get_currency();        // Currency code
$order->get_items();           // Order items
?>
```

### Server-Side Data for Server GTM

WooCommerce REST API available for server-side enrichment:
- **Endpoint**: `/wp-json/wc/v3/products/{id}`
- **Authentication**: OAuth 1.0a or API keys
- **Use Case**: Enriching server-side data if needed

## Common Issues on WooCommerce

### Issue 1: Prices as Strings with Currency Symbols
**Severity**: P1  
**Description**: Data layer sends price as "$29.99" instead of 29.99  
**Symptoms**: 
- GA4 reports show incorrect revenue
- Meta conversion value incorrect  
**Cause**: WooCommerce's `wc_price()` function returns formatted HTML string  
**Fix**: Use `$product->get_price()` which returns numeric value  
**Code Example**:
```php
// ❌ WRONG
'price' => wc_price($product->get_price())  // Returns "$29.99"

// ✅ CORRECT
'price' => (float) $product->get_price()     // Returns 29.99
```

### Issue 2: Variable Product Parent vs Variation IDs
**Severity**: P0  
**Description**: Parent product SKU sent on listing, variation SKU on detail  
**Symptoms**: Same product appears as 2+ different products in reports  
**Cause**: Not detecting when variation is selected  
**Fix**: 
```javascript
// On product page, listen for variation selection
jQuery(document).on('found_variation', function(event, variation) {
  // Update data layer with variation SKU
  dataLayer.push({
    event: 'variation_selected',
    variation_id: variation.variation_id,
    variation_sku: variation.sku,
    variation_price: variation.display_price
  });
});
```

### Issue 3: AJAX Add to Cart Not Triggering Events
**Severity**: P1  
**Description**: Add to cart works but no GTM event fires  
**Symptoms**: `add_to_cart` events missing in GTM  
**Cause**: AJAX cart doesn't reload page, event not pushed to data layer  
**Fix**: Hook into WooCommerce AJAX success:
```javascript
jQuery(document.body).on('added_to_cart', function(e, fragments, cart_hash, button) {
  // Get product data from button
  var product_id = button.data('product_id');
  var product_sku = button.data('product_sku');
  // Push to data layer
  dataLayer.push({
    event: 'add_to_cart',
    ecommerce: {
      // ... product data
    }
  });
});
```

### Issue 4: Thank You Page Refresh Double-Counting
**Severity**: P0  
**Description**: Purchase event fires again if thank you page refreshed  
**Symptoms**: Duplicate transaction in GA4/Meta  
**Cause**: Purchase event fires on page load without check  
**Fix**: 
```php
// Set session flag after first fire
if (!isset($_SESSION['order_' . $order_id . '_tracked'])) {
    // Push purchase event
    $_SESSION['order_' . $order_id . '_tracked'] = true;
}
```

### Issue 5: Tax Inconsistency Between Events
**Severity**: P1  
**Description**: Some events include tax, others don't  
**Symptoms**: Revenue doesn't match across funnel  
**Cause**: Mixed use of `get_price()` vs `get_price_including_tax()`  
**Fix**: Standardize on one approach:
```php
// Choose one method and use everywhere:

// Option 1: Always include tax
$price = wc_get_price_including_tax($product);

// Option 2: Always exclude tax
$price = wc_get_price_excluding_tax($product);

// Document which approach is used!
```

## Platform-Specific Testing

### Required Test Products
Create these test products in WooCommerce:

- [ ] Simple product with SKU
- [ ] Simple product **without** SKU (test fallback)
- [ ] Variable product (e.g., shirt with size/color options)
- [ ] Product with special characters in name ("Men's 12\" Widget™")
- [ ] Product with very low price ($0.01)
- [ ] Product with high price ($9,999.99)
- [ ] Product on sale (regular $50, sale $30)
- [ ] Product with zero price (free)

### WooCommerce-Specific Test Scenarios

#### Scenario 1: Variable Product Selection
**Setup**: Variable product with 2+ variations  
**Steps**: 
1. Load product page
2. Select first variation (e.g., Red, Small)
3. Verify data layer updates with variation SKU
4. Change to different variation (Blue, Large)
5. Verify data layer updates again  
**Expected**: Each variation gets its own SKU in data layer  
**Common Failure**: Parent SKU remains, variation not tracked

#### Scenario 2: AJAX Add to Cart from Shop Page
**Setup**: Product listing page with "Add to Cart" buttons  
**Steps**:
1. Click "Add to Cart" (without navigating to product page)
2. Verify `add_to_cart` event fires
3. Check cart counter updates
4. Verify correct product data in event  
**Expected**: Event fires with correct product data  
**Common Failure**: No event fires, or wrong product data

#### Scenario 3: Coupon Application
**Setup**: Valid coupon code  
**Steps**:
1. Add product to cart
2. Go to cart page
3. Apply coupon
4. Proceed to checkout  
**Expected**: `begin_checkout` includes correct discounted price  
**Common Failure**: Full price sent, discount not reflected

### Debug Mode / Test Mode
**WooCommerce Logging**: 
- Enable: `WP_DEBUG` in wp-config.php
- Location: `/wp-content/debug.log`

**GTM4WP Debug**:
- Enable: Plugin settings → Integration → "Track debug/test mode"
- Adds `gtm4wp.` prefix to variables for easy identification

## Admin Panel Reference

### Key Settings Locations

**Product Settings**: Products → Edit Product  
**Tax Settings**: WooCommerce → Settings → Tax  
**Checkout Settings**: WooCommerce → Settings → Checkout  
**Currency Settings**: WooCommerce → Settings → General → Currency options  
**SKU Settings**: WooCommerce → Settings → Products → Enable SKU field

## Best Practices for WooCommerce

### Recommended Approach
1. ✅ **Use SKU as primary product ID** (more stable than Post ID)
2. ✅ **Populate SKUs for ALL products** before implementing tracking
3. ✅ **Handle variable products explicitly** (track variation SKU after selection)
4. ✅ **Implement server-side purchase tracking** (reliable even if JS fails)
5. ✅ **Standardize tax inclusion** across all events
6. ✅ **Use WooCommerce hooks** for data layer pushes (not theme code)

### What to Avoid
- ❌ Don't rely on Post IDs (they can change)
- ❌ Don't use formatted prices (`wc_price()`) in data layer
- ❌ Don't track parent ID for variable products once variation selected
- ❌ Don't implement purchase tracking client-side only
- ❌ Don't mix tax-included and tax-excluded prices across events

### Code Injection Points

**Best Locations** for data layer code:
1. **Child theme's** `functions.php` (not parent theme!)
2. **Custom plugin** (better for maintainability)
3. **WooCommerce hooks** (cleanest approach)

**Hook Examples**:
```php
// Add data layer on product page
add_action('woocommerce_after_single_product', 'push_product_datalayer');

// Add data layer on cart page
add_action('woocommerce_after_cart', 'push_cart_datalayer');

// Add data layer on thank you page
add_action('woocommerce_thankyou', 'push_purchase_datalayer');
```

## Version-Specific Notes

### WooCommerce 7.0+ (2022)
**Changes**: High-Performance Order Storage (HPOS)  
**Impact**: Orders stored in custom tables, not posts  
**GTM Impact**: None if using standard WooCommerce functions

### WooCommerce 8.0+ (2023)
**Changes**: Cart/Checkout blocks (block-based UI)  
**Impact**: Different DOM structure, JavaScript hooks  
**GTM Impact**: May need to update selectors for click triggers

## Documentation Links

**WooCommerce Docs**: https://woocommerce.com/documentation/  
**Developer Docs**: https://woocommerce.github.io/code-reference/  
**REST API**: https://woocommerce.github.io/woocommerce-rest-api-docs/  
**Hooks Reference**: https://woocommerce.com/document/introduction-to-hooks-actions-and-filters/

## WooCommerce-Specific Checklist

When debugging GTM on WooCommerce:

- [ ] Check if SKUs are populated for all products
- [ ] Verify SKU vs Post ID usage consistency
- [ ] Test variable product variation selection
- [ ] Confirm tax inclusion setting and data layer consistency
- [ ] Test AJAX add to cart from shop page
- [ ] Verify purchase event fires only once (refresh protection)
- [ ] Check currency code if using multi-currency
- [ ] Test coupon/discount code application
- [ ] Verify price format (number, not string with symbol)
- [ ] Confirm variation SKU tracking (not parent SKU)

## Notes for Claude Code

When analyzing a WooCommerce implementation:

1. **First check**: Are SKUs populated? If not, tracking may use Post IDs inconsistently
2. **Pay attention to**: Variable products - parent vs variation ID is common issue
3. **Don't assume**: Tax is included/excluded - this varies per store
4. **Always verify**: Price format in data layer (number vs formatted string)
5. **Check for**: AJAX cart issues - events may not fire without custom code
6. **Investigate**: Which plugin/method is used for GTM implementation (affects structure significantly)
