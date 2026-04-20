---
scope: shared
---

# Meta Event ID Deduplication Guide

## Critical Importance

Meta (Facebook) Conversions API (CAPI) allows sending conversion events from your server in addition to the client-side pixel. Without proper `event_id` matching, Meta will count events twice, leading to:

❌ Inflated conversion numbers  
❌ Incorrect ROAS (Return on Ad Spend)  
❌ Poor campaign optimization  
❌ Wasted ad budget  

## How Deduplication Works

Meta uses the `event_id` parameter to identify duplicate events:

```
Same User Action:
├── Client-side Pixel sends: {event: 'Purchase', event_id: 'abc123', value: 50}
└── Server-side CAPI sends: {event: 'Purchase', event_id: 'abc123', value: 50}

Meta's Deduplication Logic:
- Same event_id? → Count as ONE event
- Different or missing event_id? → Count as TWO events
```

## Event ID Requirements

### Format Requirements
✅ Alphanumeric characters  
✅ Hyphens (-)  
✅ Underscores (_)  
✅ Length: reasonably short (e.g., 36 chars for UUID)  
❌ No special characters (!, @, #, etc.)  
❌ Not empty or null  
❌ Not "undefined" (as a string)  

### Uniqueness Requirements
- Each user action gets a UNIQUE event_id
- The SAME action gets the SAME event_id on client and server
- Different actions get DIFFERENT event_ids (even by same user)

Example:
```
User views Product A:
- Client: event_id = "uuid-1234"
- Server: event_id = "uuid-1234" ✓

User views Product A again (new page load):
- Client: event_id = "uuid-5678" (NEW, different from uuid-1234) ✓
- Server: event_id = "uuid-5678" ✓

User adds Product A to cart:
- Client: event_id = "uuid-9999" (NEW, different from view events) ✓
- Server: event_id = "uuid-9999" ✓
```

## Implementation Patterns

### Pattern 1: Generate on Client, Store in Data Layer
**Recommended for GTM implementations**

```javascript
// Website code (before GTM tags fire)
window.dataLayer = window.dataLayer || [];
window.dataLayer.push({
  event: 'add_to_cart',
  event_id: generateUUID(), // Generate unique ID
  ecommerce: {
    // ... product data
  }
});

function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}
```

Client GTM:
```
Variable: {{DL - event_id}}
Type: Data Layer Variable
Data Layer Variable Name: event_id
```

Server GTM:
```
Variable: {{Event Data - event_id}}
Type: Event Data
Key Path: event_id
```

### Pattern 2: Generate in Client GTM, Pass to Server
**Alternative if website code can't be modified**

Client GTM Variable:
```
Name: {{Generate Event ID}}
Type: Custom JavaScript
Value:
function() {
  // Generate or retrieve existing event ID for this event
  var eventId = 'evt_' + Date.now() + '_' + Math.random().toString(36).substring(7);
  
  // Store in dataLayer for server to access
  window.dataLayer = window.dataLayer || [];
  window.dataLayer.push({
    'eventId': eventId
  });
  
  return eventId;
}
```

⚠️ **Important**: This variable must be evaluated BEFORE both:
- Client-side Meta Pixel tag
- Server-side data forwarding

### Pattern 3: Use Existing Unique Identifier
**When available**

Some e-commerce platforms generate unique IDs for user actions:
```javascript
// Example: Shopify checkout
{
  event: 'purchase',
  event_id: '{{checkout_token}}', // Unique per transaction
  transaction_id: '1234',
  // ...
}
```

Requirements:
- Must be available at event time
- Must be unique per user action
- Must be accessible both client and server

## GTM Configuration

### Client-Side Meta Pixel Tag

Tag Type: Meta Pixel (or Custom HTML with pixel code)

Object Properties:
```
event_id: {{Event ID Variable}}
```

This sends event_id to Meta's client-side pixel.

### Server-Side Meta CAPI Tag

Tag Type: Meta Conversions API

Event Parameters:
```
event_id: {{Server Event ID Variable}}
```

**CRITICAL**: The server variable must read the SAME value that the client sent.

## Verification Checklist

### Client-Side Verification
1. Open GTM Preview mode
2. Trigger an event (e.g., Add to Cart)
3. Check the Meta Pixel tag
4. Confirm `event_id` parameter exists and has a value
5. Note the exact event_id value

### Server-Side Verification
1. Open Server GTM Preview (or check server logs)
2. For the SAME user action from above
3. Check the Meta CAPI tag
4. Confirm `event_id` parameter exists
5. **Verify it's the EXACT SAME value as client**

### Meta Events Manager Verification
1. Go to Meta Events Manager
2. Select your Pixel
3. Click "Test Events"
4. Trigger event with test_event_code if available
5. Check "Event Deduplication" status
6. Should show "1 event received" (not 2) if working correctly

## Common Mistakes & Fixes

### Mistake 1: Event ID Generated on Server
```
❌ WRONG:
Client: event_id = "client-123"
Server: event_id = generateNewID() → "server-456"
Result: Counted as 2 events
```

```
✅ CORRECT:
Client: event_id = "client-123" → passed to server
Server: event_id = receivedFromClient() → "client-123"
Result: Counted as 1 event
```

### Mistake 2: Event ID Not Passed to Server
```
❌ WRONG:
Client GTM: Generates event_id, sends to pixel
Server GTM: Has no access to that event_id
Result: Server generates own ID or omits it → double counting
```

```
✅ CORRECT:
Client GTM: Generates event_id, sends to pixel AND includes in data layer
Server GTM: Reads event_id from event data
Result: Both use same ID
```

### Mistake 3: Event ID Reused Across Different Events
```
❌ WRONG:
User views product: event_id = "123"
User adds to cart: event_id = "123" (reused!)
Result: Meta sees duplicate, might suppress one event
```

```
✅ CORRECT:
User views product: event_id = "uuid-view-1"
User adds to cart: event_id = "uuid-cart-2" (unique!)
Result: Both events tracked properly
```

### Mistake 4: Wrong Parameter Name
```
❌ WRONG:
Client sends: event_id = "123"
Server sends: eventId = "123" (different parameter name!)
Result: Meta doesn't recognize as same event
```

```
✅ CORRECT:
Both use: event_id = "123"
Result: Properly deduplicated
```

### Mistake 5: Event ID is "undefined" String
```
❌ WRONG:
Variable fails to generate, tag sends: event_id = "undefined"
Result: Invalid event_id, deduplication fails
```

```
✅ CORRECT:
Variable has fallback logic, only sends event_id if valid
Result: Better to omit event_id than send invalid one
```

## Testing Procedure

### Step 1: Setup Test Environment
1. Enable GTM Preview mode (client)
2. Enable Server GTM Preview (if available)
3. Open browser DevTools → Network tab
4. Filter for "facebook.com" requests
5. Have Meta Events Manager open in another tab

### Step 2: Test Single Event
1. Clear cookies/cache
2. Trigger test event (e.g., Add to Cart)
3. In GTM Preview:
   - Check client Meta Pixel tag fired
   - Check event_id parameter value
4. In Network tab:
   - Find pixel request (tr/ or pixel/track)
   - Check query string or payload for event_id
5. In Server GTM Preview:
   - Check Meta CAPI tag fired
   - Check event_id matches client value
6. In Meta Events Manager:
   - Check "Test Events" or "Events" tab
   - Should see 1 event (not 2)
   - Check deduplication status

### Step 3: Test Multiple Events
Repeat for:
- [ ] View Content (PDP)
- [ ] Add to Cart
- [ ] Initiate Checkout
- [ ] Purchase

Each should have UNIQUE event_id within session, but MATCHING between client/server.

### Step 4: Test Across Page Loads
1. View product page → event_id = "A"
2. Navigate away
3. Return to same product page → event_id should be "B" (NEW)

Ensure event_ids are unique across page loads.

## Debugging Tools

### GTM Preview Console
```javascript
// Check event_id in data layer
dataLayer.filter(e => e.event_id).forEach(e => {
  console.log(e.event, e.event_id);
});
```

### Browser Console
```javascript
// Check last pushed data layer event
console.log(dataLayer[dataLayer.length - 1]);
```

### Meta Pixel Helper (Chrome Extension)
- Shows all pixel events
- Displays parameters including event_id
- Indicates if events are being deduplicated

### Server-Side Logging
```javascript
// In server GTM, add logging tag (Custom HTML or logs)
const Logger = require('logToConsole');
const eventId = eventModel.event_id;
Logger('Event ID:', eventId);
```

## Advanced: Event ID Storage

For single-page apps or complex flows:

### Option 1: Session Storage
```javascript
// Store event_id temporarily
sessionStorage.setItem('last_event_id_' + eventName, eventId);

// Retrieve on server
// (if server has access via cookie or API)
```

### Option 2: Cookie
```javascript
// Set short-lived cookie
document.cookie = 'eventId=' + eventId + '; max-age=60'; // 60 seconds

// Server reads cookie
// GTM Server variable: {{Cookie - eventId}}
```

### Option 3: URL Parameter
```javascript
// Client includes in server request
fetch('/api/track?event_id=' + eventId);

// Server GTM reads from event data
```

## Meta API Reference

### Event ID in Pixel Code
```javascript
fbq('track', 'AddToCart', {
  content_ids: ['SKU123'],
  value: 29.99,
  currency: 'USD'
}, {
  eventID: 'unique-event-id-123' // Second parameter object
});
```

### Event ID in CAPI Request
```json
{
  "data": [{
    "event_name": "AddToCart",
    "event_time": 1234567890,
    "event_id": "unique-event-id-123",
    "user_data": { ... },
    "custom_data": {
      "content_ids": ["SKU123"],
      "value": 29.99,
      "currency": "USD"
    }
  }]
}
```

## Success Criteria

✅ **Event ID generated once per user action**  
✅ **Same Event ID sent to client pixel and server CAPI**  
✅ **Event ID is unique per action (not reused)**  
✅ **Event ID format is valid**  
✅ **Meta Events Manager shows deduplicated events**  
✅ **Conversion counts match user actions (not doubled)**  

## Monitoring & Maintenance

### Regular Checks
- Weekly: Review Meta Events Manager for duplicate events
- Monthly: Audit GTM containers for event_id configuration
- After any website/GTM changes: Re-test event_id flow

### Red Flags
🚩 Sudden doubling of conversion events  
🚩 Meta shows "0% deduplicated" in Events Manager  
🚩 ROAS metrics suddenly worsen  
🚩 Server-side events show different event_ids than client  

## Documentation Requirements

For every Meta implementation, document:
1. How event_id is generated (code/variable)
2. Where it's stored (dataLayer/cookie/sessionStorage)
3. How it's passed to server (event data/cookie/API)
4. Testing results proving deduplication works
5. Last verification date

Keep this documentation updated with any changes to implementation.
