---
id: "REC-{NNN}"
client: "{client}"
title: ""
priority: "P0|P1|P2|P3"
status: "proposed|approved|in-progress|implemented|verified"
related_findings: []
owner: ""
estimated_effort: ""
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
---

# REC-{NNN}: {Title}

## What

<!-- One-paragraph summary of the recommendation -->

## Why

<!-- Why this matters. Link to the business impact from the related findings. -->

**Related findings:**
- FND-XXX — {title}: {brief impact}
-

**Business justification:**

**Risk of NOT implementing:**

## How

<!-- Step-by-step implementation guide. Detailed enough for the implementer to execute without guessing. -->

### Prerequisites

- [ ]
- [ ]

### Steps

1. **Step 1 title**

   ```
   <!-- Code, config, or detailed instruction -->
   ```

   Expected result:

2. **Step 2 title**

   ```
   ```

   Expected result:

3. **Step 3 title**

   ```
   ```

   Expected result:

### Platform-Specific Notes

<!-- Magento / Shopify / WooCommerce specifics if applicable -->

### Multi-Country Considerations

<!-- If fix needs replication across countries, note differences per country -->

| Country | Variation | Notes |
|---------|----------|-------|
| HU      | | |
| RO      | | |

## Code Artifact

<!-- INCLUDE THIS SECTION only if the recommendation involves code changes (JS variables, HTML tags, templates).
     Link to the artifact file with full before/after code. Delete this section if not applicable. -->

> **Full code:** [`data/artifacts/REC-{NNN}_{slug}.md`](../data/artifacts/REC-{NNN}_{slug}.md)

## Verification

<!-- How to confirm the fix worked. Must be testable. -->

### Verification Steps

1. **Before implementing** (baseline):
   -

2. **After implementing** (expected change):
   -

3. **Verification method:**
   - [ ] Tag Assistant check
   - [ ] Meta Pixel Helper check
   - [ ] Network tab inspection
   - [ ] GA4 DebugView
   - [ ] GA4 Realtime report
   - [ ] Google Ads conversion status
   - [ ] Feed validation
   - [ ] CLI script check
   - [ ] Console log check

### Success Criteria

| Metric | Before | Expected After |
|--------|--------|---------------|
| | | |

### Monitoring Period

- Check again after: 24h / 48h / 1 week
- Confirm data in: GA4 / Meta / Google Ads

## Dependencies

<!-- What must be true or done before this can be implemented? -->

| Dependency | Status | Notes |
|-----------|--------|-------|
| | | |

**Blocks:** REC-XXX (cannot proceed until this is done)
**Blocked by:** REC-XXX (waiting on this)

## Risks

<!-- What could go wrong during or after implementation? -->

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| | Low/Med/High | Low/Med/High | |

**Rollback plan:**

---

## Implementation Log

| Date | Action | By | Notes |
|------|--------|----|-------|
| YYYY-MM-DD | Recommendation created | | |
| | | | |

---

**Template version:** 1.0
**Last updated:** 2026-03-07
