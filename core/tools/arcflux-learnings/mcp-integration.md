---
scope: shared
---

# MCP Integration Guide

Best practices for Model Context Protocol (MCP) integrations with Claude Code, including workarounds for known limitations.

---

## Chrome DevTools MCP

### Known Issue: Large Screenshots Break Sessions

**Problem:** When Chrome DevTools MCP captures a full-page screenshot or high-resolution image, it can exceed Claude Code's image processing limits, causing the session to fail or hang.

**Symptoms:**
- Session becomes unresponsive after screenshot
- Error messages about image size
- Claude cannot process the response

---

## Solutions

### Solution 1: Limit Viewport Before Capture (Recommended)

Set a maximum viewport size before taking screenshots:

```javascript
// Before capturing
await chrome.setViewport({
  width: 1280,
  height: 800,        // Keep height reasonable
  deviceScaleFactor: 1 // Use 1x, not 2x retina
});

// Then capture
await chrome.screenshot();
```

**Safe dimensions:**
| Scenario | Width | Height | Scale |
|----------|-------|--------|-------|
| Desktop | 1280 | 800 | 1x |
| Mobile | 375 | 667 | 1x |
| Tablet | 768 | 1024 | 1x |

**Avoid:**
- Full page captures (`fullPage: true`)
- Retina/2x scale factor
- Heights over 1000px

---

### Solution 2: Capture Visible Viewport Only

Instead of full page, capture only what's visible:

```javascript
// Good - visible viewport only
await chrome.screenshot({ fullPage: false });

// Bad - entire scrollable page
await chrome.screenshot({ fullPage: true });
```

---

### Solution 3: Element-Specific Capture

Capture only the element you're debugging:

```javascript
// Capture specific element
await chrome.screenshot({
  selector: '#main-content',
  // or
  clip: { x: 0, y: 0, width: 800, height: 600 }
});
```

---

### Solution 4: Compression Wrapper Hook

Create a post-processing hook to compress screenshots automatically:

**`.claude-hooks/compress-screenshot.sh`:**
```bash
#!/bin/bash
# Compress screenshots before Claude processes them

MAX_WIDTH=1200
QUALITY=70

for img in /tmp/claude-screenshots/*.png; do
  if [ -f "$img" ]; then
    # Get current dimensions
    width=$(identify -format "%w" "$img")

    if [ "$width" -gt "$MAX_WIDTH" ]; then
      # Resize and compress
      convert "$img" \
        -resize ${MAX_WIDTH}x\> \
        -quality $QUALITY \
        "$img"

      echo "Compressed: $img"
    fi
  fi
done
```

**Install ImageMagick:**
```bash
brew install imagemagick  # macOS
sudo apt install imagemagick  # Linux
```

---

### Solution 5: Text-First Debugging

For many issues, screenshots aren't necessary. Use text-based inspection:

**DOM Structure:**
```javascript
// Get element HTML
document.querySelector('#problem-element').outerHTML

// Get computed styles
getComputedStyle(document.querySelector('#element'))

// Get bounding box
document.querySelector('#element').getBoundingClientRect()
```

**Console Errors:**
```javascript
// Chrome DevTools Protocol - get console messages
await chrome.Runtime.evaluate({
  expression: 'console.error("test")'
});
```

**Accessibility Tree:**
```javascript
// Get accessibility info (great for layout debugging)
await chrome.Accessibility.getFullAXTree();
```

**Network Requests:**
```javascript
// Check failed requests
await chrome.Network.getResponseBody({ requestId });
```

---

### Solution 6: Chunked Screenshots

For full-page analysis, take multiple smaller screenshots:

```javascript
async function chunkScreenshot(page, chunkHeight = 800) {
  const fullHeight = await page.evaluate(() => document.body.scrollHeight);
  const chunks = Math.ceil(fullHeight / chunkHeight);

  const screenshots = [];
  for (let i = 0; i < chunks; i++) {
    await page.evaluate((y) => window.scrollTo(0, y), i * chunkHeight);
    await page.waitForTimeout(100); // Let content settle

    const screenshot = await page.screenshot({
      clip: {
        x: 0,
        y: 0,
        width: 1280,
        height: chunkHeight
      }
    });
    screenshots.push(screenshot);
  }

  return screenshots; // Process one at a time
}
```

---

## Recommended MCP Configuration

**For Chrome DevTools MCP, set these defaults:**

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["@anthropic/chrome-devtools-mcp"],
      "env": {
        "SCREENSHOT_MAX_WIDTH": "1280",
        "SCREENSHOT_MAX_HEIGHT": "800",
        "SCREENSHOT_SCALE": "1",
        "SCREENSHOT_FORMAT": "jpeg",
        "SCREENSHOT_QUALITY": "70"
      }
    }
  }
}
```

---

## Debugging Workflow (Screenshot-Safe)

When debugging web applications with Claude Code:

### Step 1: Text-Based First
```
1. Check console for errors
2. Inspect DOM structure
3. Check network requests
4. Review computed styles
```

### Step 2: Targeted Screenshots
```
1. Set viewport to 1280x800
2. Navigate to problem area
3. Capture visible viewport only
4. If needed, capture specific element
```

### Step 3: If Full Page Needed
```
1. Use chunked approach (top/middle/bottom)
2. Process one chunk at a time
3. Describe what to look for in each chunk
```

---

## Quick Reference

| Action | Safe | Unsafe |
|--------|------|--------|
| Viewport screenshot (800px height) | ✅ | |
| Element screenshot | ✅ | |
| Full page screenshot | | ❌ |
| 2x retina scale | | ❌ |
| Height > 1000px | | ⚠️ |
| PNG format | ⚠️ | |
| JPEG 70% quality | ✅ | |

---

## ArcFlux Integration

Future `arcflux screenshot` command will handle this automatically:

```bash
# Safe defaults
arcflux screenshot --url=http://localhost:3000

# Specific element
arcflux screenshot --url=http://localhost:3000 --element="#header"

# With size limit
arcflux screenshot --url=http://localhost:3000 --max-height=800

# Chunked full page (processes sequentially)
arcflux screenshot --url=http://localhost:3000 --full-page --chunked
```

See: AF-042 (Screenshot Handling)

---

*Last updated: 2026-01-09*
