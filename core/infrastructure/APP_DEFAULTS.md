---
scope: shared
---

# App Defaults — File Extension to Application Mapping

> Single source of truth for which application opens which file type.
> All skills, rules, hooks, and agents must reference this config — never hardcode app names.
> Wrapper script: `core/scripts/ops/open-file.sh`

---

## Mapping

| Extension | Application | Bundle ID | Notes |
|---|---|---|---|
| `.md` | Typora | `abnerworks.Typora` | All markdown — deliverables, docs, analyses |
| `.pdf` | Preview | `com.apple.Preview` | Default macOS viewer |
| `.html` | Google Chrome | `com.google.Chrome` | Via Chrome MCP when possible |
| `.csv` | Numbers | `com.apple.iWork.Numbers` | Quick data inspection |
| `.xlsx` | Numbers | `com.apple.iWork.Numbers` | Spreadsheet review |
| `.json` | Cursor | `com.todesktop.230313mzl4w4u92` | Code/config files |
| `.js` `.ts` `.py` `.sh` | Cursor | `com.todesktop.230313mzl4w4u92` | Code files |
| `.png` `.jpg` `.svg` | Preview | `com.apple.Preview` | Image review |

## Fallback

If extension is not listed above: `open "{path}"` (let macOS decide).

## How to Change

1. Edit this file (one row change)
2. Done — `open-file.sh` reads this at runtime, no other files need updating

## Usage in Skills / Rules

Instead of:
```bash
open -a Typora "{path}"
```

Write:
```bash
core/scripts/ops/open-file.sh "{path}"
```

Or in Claude instructions, simply say:
> Open the file using `open-file.sh`
