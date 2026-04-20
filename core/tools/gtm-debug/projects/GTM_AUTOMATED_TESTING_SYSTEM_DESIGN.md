---
scope: shared
---

# GTM/CAPI Automated Testing System Design

**Project:** Automated GTM & Meta CAPI Validation Platform
**Version:** 1.0
**Date:** 2025-11-18

---

## 1. Executive Summary

Build an automated system to validate GTM web containers, dataLayer integrity, and server-side GTM (sGTM) data transmission for Meta CAPI. The system will crawl 10-25 pages per client, simulate checkout flows, and detect inconsistencies in event_id, fbp, fbc, and other critical parameters.

### Key Goals
- Automated validation of GTM/CAPI implementations
- Detection of event_id deduplication failures
- fbp/fbc cookie consistency tracking
- Full checkout flow testing
- Multi-client management with scheduling

---

## 2. System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     FRONTEND (Lovable/TypeScript)                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Dashboard  │  │   Client    │  │   Test      │              │
│  │  Overview   │  │   Manager   │  │   Results   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────┬───────────────────────────────────┘
                              │ REST API
┌─────────────────────────────┴───────────────────────────────────┐
│                      BACKEND (Drupal 10)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Client    │  │    Test     │  │  Validation │              │
│  │   Entity    │  │  Scheduler  │  │    Rules    │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐                               │
│  │   Results   │  │    API      │                               │
│  │   Storage   │  │  Endpoints  │                               │
│  └─────────────┘  └─────────────┘                               │
└─────────────────────────────┬───────────────────────────────────┘
                              │ Queue/Webhook
┌─────────────────────────────┴───────────────────────────────────┐
│                    TEST RUNNER (Node.js Service)                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  Playwright │  │   Network   │  │  DataLayer  │              │
│  │   Browser   │  │ Interceptor │  │   Capture   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐                               │
│  │   Cookie    │  │  Validator  │                               │
│  │   Manager   │  │   Engine    │                               │
│  └─────────────┘  └─────────────┘                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Technology Stack

### 3.1 Backend: Drupal 10

**Why Drupal:**
- Robust entity system for client/test management
- Built-in REST API
- Queue system for test scheduling
- User management and permissions
- Extensible with custom modules

**Required Modules:**
- `jsonapi` - REST API for frontend
- `queue_ui` - Queue management
- `entity_reference` - Relationships
- Custom module: `gtm_testing`

### 3.2 Frontend: Lovable (TypeScript)

**Components:**
- Dashboard with test status overview
- Client management CRUD
- Test configuration wizard
- Results viewer with diff highlighting
- Real-time test progress (WebSocket)
- Charts for historical trends

**State Management:** Zustand or Redux Toolkit
**UI Framework:** Tailwind CSS + shadcn/ui

### 3.3 Test Runner: Playwright (Recommended)

**Comparison:**

| Feature | Playwright | Puppeteer | Apify |
|---------|------------|-----------|-------|
| Browser support | Chrome, Firefox, Safari | Chrome only | Via actors |
| Network interception | Excellent | Good | Limited |
| Cookie handling | Native | Native | Actor dependent |
| Checkout simulation | Full control | Full control | Complex |
| Cost | Free (self-hosted) | Free | $49-499/mo |
| Maintenance | Medium | Medium | Low |

**Recommendation:** Playwright for full control over browser automation, network interception, and cookie management. Self-hosted for cost efficiency.

### 3.4 Database Schema

```sql
-- Clients
clients (
  id, name, website_url, gtm_web_id, gtm_server_id,
  meta_pixel_id, server_url, created, updated
)

-- Test Configurations
test_configs (
  id, client_id, name, pages_json, checkout_flow_json,
  validation_rules_json, schedule_cron, active
)

-- Test Runs
test_runs (
  id, config_id, status, started_at, completed_at,
  total_pages, passed, failed, warnings
)

-- Test Results (per page/event)
test_results (
  id, run_id, page_url, event_name,
  datalayer_snapshot_json, network_requests_json,
  cookies_json, validation_results_json,
  status, created_at
)

-- Issues
issues (
  id, result_id, severity, rule_id,
  expected_value, actual_value, message
)
```

---

## 4. Core Components

### 4.1 Client Management (Drupal)

**Client Entity Fields:**
- Client name
- Website URL
- GTM Web Container ID
- GTM Server Container ID
- Server GTM URL
- Meta Pixel ID
- Test credentials (encrypted)
- Active/Inactive status

**Test Configuration Fields:**
- Pages to test (JSON array of URLs)
- Checkout flow steps (JSON)
- Custom validation rules
- Schedule (cron expression)
- Notification settings

### 4.2 Test Runner Engine

**Core Capabilities:**

```typescript
// Test Runner pseudocode
class GTMTestRunner {
  async runTest(config: TestConfig) {
    const browser = await playwright.chromium.launch();
    const context = await browser.newContext();

    // Enable network interception
    await context.route('**/*', this.interceptRequests);

    // Inject dataLayer capture script
    await context.addInitScript(this.dataLayerCapture);

    const page = await context.newPage();

    for (const url of config.pages) {
      await this.testPage(page, url);
    }

    if (config.checkoutFlow) {
      await this.testCheckoutFlow(page, config.checkoutFlow);
    }

    await browser.close();
  }
}
```

**Network Interception:**
```typescript
interceptRequests(route, request) {
  const url = request.url();

  // Capture GA4 requests
  if (url.includes('google-analytics.com/g/collect')) {
    this.captureGA4Request(request);
  }

  // Capture sGTM requests
  if (url.includes(this.serverGtmUrl)) {
    this.captureServerRequest(request);
  }

  // Capture Meta Pixel requests
  if (url.includes('facebook.com/tr')) {
    this.captureMetaRequest(request);
  }

  route.continue();
}
```

**DataLayer Capture:**
```typescript
// Injected into page
window.__gtmTestCapture = {
  events: [],
  init() {
    const original = window.dataLayer.push;
    window.dataLayer.push = (...args) => {
      this.events.push({
        timestamp: Date.now(),
        data: JSON.parse(JSON.stringify(args))
      });
      return original.apply(window.dataLayer, args);
    };
  }
};
window.__gtmTestCapture.init();
```

### 4.3 Data Validation Engine

**Validation Rules:**

```typescript
interface ValidationRule {
  id: string;
  name: string;
  event: string;           // 'purchase', 'add_to_cart', etc.
  severity: 'error' | 'warning';
  validate: (data: EventData) => ValidationResult;
}

// Example rules
const rules: ValidationRule[] = [
  {
    id: 'event_id_match',
    name: 'Event ID Deduplication',
    event: '*',
    severity: 'error',
    validate: (data) => {
      const clientEventId = data.clientPixel?.event_id;
      const serverEventId = data.serverCapi?.event_id;
      return {
        passed: clientEventId === serverEventId,
        expected: clientEventId,
        actual: serverEventId,
        message: 'Event ID must match between client and server'
      };
    }
  },
  {
    id: 'fbp_present',
    name: 'FBP Cookie Present',
    event: '*',
    severity: 'error',
    validate: (data) => ({
      passed: !!data.cookies.fbp,
      message: 'FBP cookie must be present for user matching'
    })
  },
  {
    id: 'purchase_value',
    name: 'Purchase Value Required',
    event: 'purchase',
    severity: 'error',
    validate: (data) => ({
      passed: data.datalayer.value > 0,
      message: 'Purchase must have value > 0'
    })
  }
];
```

### 4.4 Frontend Dashboard (Lovable)

**Key Views:**

1. **Dashboard Overview**
   - Client health status (green/yellow/red)
   - Recent test runs
   - Critical issues count
   - Trend charts

2. **Client Detail**
   - Configuration
   - Test history
   - Issue breakdown
   - Event flow visualization

3. **Test Results**
   - Page-by-page breakdown
   - Event timeline
   - Side-by-side comparison (expected vs actual)
   - Network request details

4. **Issue Explorer**
   - Filterable issue list
   - Severity sorting
   - Root cause analysis suggestions

---

## 5. Test Scenarios

### 5.1 Page View Tracking

**Capture:**
- dataLayer PageView event
- GA4 page_view request
- Meta PageView pixel

**Validate:**
- event_id consistency
- page_location accuracy
- fbp cookie present

### 5.2 E-commerce Events

**Add to Cart:**
```javascript
{
  event: 'add_to_cart',
  validate: ['item_id', 'item_name', 'price', 'quantity', 'currency']
}
```

**Begin Checkout:**
```javascript
{
  event: 'begin_checkout',
  validate: ['items', 'value', 'currency', 'event_id']
}
```

**Purchase:**
```javascript
{
  event: 'purchase',
  validate: [
    'transaction_id', 'value', 'currency', 'items',
    'user_data.email', 'user_data.phone',
    'event_id', 'fbp', 'fbc'
  ]
}
```

### 5.3 Checkout Flow Automation

```typescript
const checkoutFlow = {
  steps: [
    {
      name: 'add_product',
      action: 'click',
      selector: '.add-to-cart-button',
      waitFor: 'dataLayer.add_to_cart'
    },
    {
      name: 'view_cart',
      action: 'navigate',
      url: '/cart',
      waitFor: 'dataLayer.view_cart'
    },
    {
      name: 'begin_checkout',
      action: 'click',
      selector: '.checkout-button',
      waitFor: 'dataLayer.begin_checkout'
    },
    {
      name: 'fill_shipping',
      action: 'form',
      fields: {
        '#email': 'test@example.com',
        '#phone': '+36301234567',
        '#first_name': 'Test',
        '#last_name': 'User',
        '#address': 'Test Street 1',
        '#city': 'Budapest',
        '#postal_code': '1111'
      }
    },
    {
      name: 'complete_purchase',
      action: 'click',
      selector: '.place-order-button',
      waitFor: 'dataLayer.purchase'
    }
  ]
};
```

---

## 6. Data Collection Points

### Per Page/Event Capture:

| Data Point | Source | Format |
|------------|--------|--------|
| dataLayer snapshot | Page injection | JSON array |
| GA4 requests | Network intercept | URL + payload |
| sGTM requests | Network intercept | URL + payload |
| Meta Pixel requests | Network intercept | URL + payload |
| Cookies | Browser context | Object {fbp, fbc, _ga, etc.} |
| Console errors | Page events | Array of errors |
| Response codes | Network intercept | HTTP status codes |

### Cookie Tracking:

```typescript
{
  _fbp: 'fb.1.1731859200000.123456789',
  _fbc: 'fb.1.1731859200000.IwAR3abc...',
  _ga: 'GA1.1.123456789.1731859200',
  _ga_XXXXXX: 'GS1.1.1731859200.1.1.1731859300.0.0.0'
}
```

---

## 7. Validation Rules Library

### Critical Rules (Errors)

| Rule ID | Description | Check |
|---------|-------------|-------|
| `evt_id_match` | Event ID deduplication | client event_id === server event_id |
| `fbp_present` | FBP cookie exists | _fbp cookie not null |
| `purchase_value` | Purchase has value | value > 0 |
| `purchase_txn_id` | Transaction ID present | transaction_id exists |
| `items_array` | Items array valid | items.length > 0 |
| `currency_valid` | Currency code valid | ISO 4217 format |

### Warning Rules

| Rule ID | Description | Check |
|---------|-------------|-------|
| `fbc_present` | FBC cookie (click ID) | _fbc exists if from FB ad |
| `user_email` | Email for matching | email provided for purchase |
| `user_phone` | Phone for matching | phone provided for purchase |
| `content_ids` | Product IDs sent | content_ids array populated |

### Custom Rules Engine

```typescript
// User-defined rules in Drupal
{
  "custom_rules": [
    {
      "name": "Check HUF currency",
      "condition": "event === 'purchase'",
      "assertion": "currency === 'HUF'",
      "severity": "warning",
      "message": "Hungarian store should use HUF"
    }
  ]
}
```

---

## 8. Implementation Phases

### Phase 1: MVP (4-6 weeks)

**Deliverables:**
- Drupal backend with client management
- Basic Playwright test runner
- dataLayer capture
- Simple validation (5 core rules)
- Basic results storage

**Scope:**
- Single page testing
- Manual test triggers
- JSON results output

### Phase 2: Network & Validation (4 weeks)

**Deliverables:**
- Full network interception
- GA4, sGTM, Meta request capture
- Cookie tracking
- 15+ validation rules
- Drupal queue scheduling

**Scope:**
- Multi-page testing
- Scheduled tests
- Email notifications

### Phase 3: Checkout Automation (4 weeks)

**Deliverables:**
- Checkout flow engine
- Form filling automation
- Session persistence
- Test data management
- Full purchase flow validation

**Scope:**
- Complete e-commerce funnel
- Multiple checkout types

### Phase 4: Dashboard & Alerting (4 weeks)

**Deliverables:**
- Lovable frontend dashboard
- Real-time test progress
- Historical trends
- Issue management
- Slack/email alerts
- PDF reports

### Phase 5: Scale & Optimize (Ongoing)

**Deliverables:**
- Multi-client parallel testing
- Performance optimization
- API for external integrations
- Custom rule builder UI
- Machine learning for anomaly detection

---

## 9. Technical Challenges & Solutions

### Challenge 1: Cookie Persistence

**Problem:** fbp/fbc cookies must persist across test runs for realistic testing.

**Solution:**
```typescript
// Save and restore browser state
await context.storageState({ path: 'state.json' });
const context = await browser.newContext({
  storageState: 'state.json'
});
```

### Challenge 2: Authentication for Checkout

**Problem:** Some checkouts require login.

**Solution:**
- Store encrypted credentials per client
- Pre-authenticate before checkout flow
- Support guest checkout option

### Challenge 3: Server Response Capture

**Problem:** Can't directly see sGTM to Meta responses.

**Solutions:**
1. Parse server container debug headers
2. Use Meta Events Manager API (if available)
3. Infer from subsequent requests

### Challenge 4: Dynamic Content/SPAs

**Problem:** React/Vue apps load content dynamically.

**Solution:**
```typescript
// Wait for specific dataLayer events
await page.waitForFunction(() =>
  window.dataLayer.some(e => e.event === 'purchase')
);
```

### Challenge 5: Rate Limiting

**Problem:** Too many requests may trigger blocking.

**Solution:**
- Randomized delays between actions
- Rotate user agents
- Respect robots.txt
- Use residential proxies if needed

---

## 10. Alternative Approaches

### Option A: Apify Cloud (Easiest)

**Pros:**
- Managed infrastructure
- Pre-built actors
- Easy scaling
- Proxy management included

**Cons:**
- Monthly cost ($49-499)
- Less control over browser
- Custom code in Apify format

**Best for:** Quick MVP, small scale

### Option B: Self-Hosted Playwright (Recommended)

**Pros:**
- Full control
- No per-run costs
- Complete network access
- Easy debugging

**Cons:**
- Infrastructure management
- Scaling complexity

**Best for:** Production system, multiple clients

### Option C: Hybrid Approach

**Setup:**
- Apify for crawling/page list
- Self-hosted Playwright for deep testing
- Best of both worlds

---

## 11. Cost Estimates

### Development Costs

| Phase | Effort | Rate | Cost |
|-------|--------|------|------|
| Phase 1 (MVP) | 160 hrs | $100/hr | $16,000 |
| Phase 2 (Network) | 120 hrs | $100/hr | $12,000 |
| Phase 3 (Checkout) | 120 hrs | $100/hr | $12,000 |
| Phase 4 (Dashboard) | 120 hrs | $100/hr | $12,000 |
| **Total Development** | **520 hrs** | | **$52,000** |

### Monthly Operating Costs

| Item | Cost/Month |
|------|------------|
| VPS (4 CPU, 8GB RAM) | $40-80 |
| Database hosting | $20-50 |
| Proxy service (optional) | $50-100 |
| Monitoring/logging | $20-50 |
| **Total Monthly** | **$130-280** |

### Apify Alternative

| Plan | Cost/Month | Included |
|------|------------|----------|
| Starter | $49 | 100 actor runs |
| Scale | $499 | 1000 actor runs |

---

## 12. Security Considerations

### Data Protection

- **Encryption:** All client credentials encrypted at rest (AES-256)
- **Isolation:** Each client's data in separate database schemas
- **Access control:** Role-based permissions in Drupal
- **Audit logging:** Track all access to sensitive data

### Test Data

- Use test/sandbox payment methods
- Never store real payment details
- Anonymize captured user data
- Auto-delete test results after retention period

### API Security

- JWT authentication for frontend
- API rate limiting
- HTTPS only
- CORS restrictions

---

## 13. Integration Points

### GTM API (Optional)

```typescript
// Fetch container configuration
const gtm = google.tagmanager('v2');
const container = await gtm.accounts.containers.get({
  path: `accounts/${accountId}/containers/${containerId}`
});
```

### Meta Events Manager API

```typescript
// Verify events received (requires access token)
const response = await fetch(
  `https://graph.facebook.com/v18.0/${pixelId}/events?access_token=${token}`
);
```

### Notifications

**Slack:**
```typescript
await fetch(webhookUrl, {
  method: 'POST',
  body: JSON.stringify({
    text: `Test failed for ${clientName}: ${issueCount} issues found`
  })
});
```

**Email:** Drupal's built-in mail system

### CI/CD Integration

```yaml
# GitHub Action example
- name: Run GTM Tests
  run: |
    curl -X POST https://your-api/test/run \
      -H "Authorization: Bearer ${{ secrets.API_TOKEN }}" \
      -d '{"client_id": "123"}'
```

---

## 14. Success Metrics

### System KPIs

- Test execution time < 5 minutes per client
- 99% uptime for scheduled tests
- < 1% false positive rate
- Support 50+ clients concurrently

### Client Value KPIs

- Issue detection rate (found vs missed)
- Time to detection (how quickly issues caught)
- Event Match Quality improvement
- CAPI success rate (200 vs 400 responses)

---

## 15. Roadmap Summary

| Quarter | Focus | Deliverable |
|---------|-------|-------------|
| Q1 | Foundation | MVP with basic testing |
| Q2 | Features | Full validation + checkout |
| Q2 | Frontend | Lovable dashboard |
| Q3 | Scale | Multi-client, optimizations |
| Q4 | Intelligence | Anomaly detection, predictions |

---

## 16. Recommendations

### Start With

1. **Playwright** for browser automation (free, powerful)
2. **Drupal 10** for backend (familiar, robust)
3. **PostgreSQL** for data storage (JSON support)
4. **Phase 1 MVP** to validate concept

### Key Success Factors

1. **Reliable network interception** - Core of the system
2. **Flexible validation rules** - Adapt to different setups
3. **Clear issue reporting** - Actionable insights
4. **Easy client onboarding** - Self-service configuration

### Avoid

- Over-engineering Phase 1
- Building custom crawler from scratch
- Ignoring dynamic/SPA sites
- Skipping error handling

---

## 17. Next Steps

1. **Validate requirements** with stakeholders
2. **Proof of concept** - Single client Playwright test
3. **Architecture review** - Finalize tech stack
4. **Phase 1 kickoff** - 4-6 week sprint

---

**Document Author:** Claude Code
**Created:** 2025-11-18
**Status:** Draft - Ready for Review
