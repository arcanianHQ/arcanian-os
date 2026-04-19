---
id: pii-scanner
name: PII Scanner
focus: "PII, API tokens, and secrets detection in files and commits"
context: []
data: []
active: true
scope: shared
---

# Agent: PII Scanner

## Purpose
Scan files for personally identifiable information, API tokens, and secrets before they enter version control or client deliverables.

## When to Use
- As a pre-commit check on any repository
- Before sharing files externally
- When importing raw data from client platforms
- During report preparation (before report-reviewer)

## Input
- File path(s) or directory to scan
- DATA_RULES.md (defines what counts as PII and handling rules)
- Optional: allowlist file for known-safe patterns (e.g., team emails in CLAUDE.md)

## Process

### 1. Email Address Detection
- Regex scan for email patterns (`[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`)
- Cross-reference against allowlist (team emails, public contact addresses)
- Flag any client-side or user-side emails

### 2. Phone Number Detection
- Scan for Hungarian formats: `+36`, `06`, `(06)` followed by digits
- Scan for international formats: `+[country code]`
- Flag any phone numbers not on allowlist

### 3. Personal Name Detection
- Check for name patterns in data files (CSV, JSON, spreadsheets)
- Flag columns/fields named: name, email, phone, user, customer, szemely
- Detect Hungarian name patterns (Familyname Givenname order)

### 4. Secret and Token Detection
- API keys: patterns like `sk-`, `pk_`, `AIza`, `ghp_`, `xoxb-`
- Connection strings: `postgres://`, `mysql://`, `mongodb://`
- Bearer tokens, JWT patterns
- `.env` file contents
- Google/Meta/platform credentials

### 5. File-Level Checks
- Raw analytics exports with user IDs or client IDs
- Unredacted screenshots
- Database dumps or CSV exports with row-level user data

## Output
- List of findings with: file, line number, pattern type, matched text (partially redacted)
- Severity: CRITICAL (secrets/tokens), HIGH (clear PII), MEDIUM (possible PII), LOW (suspicious pattern)
- BLOCK or PASS verdict
- If BLOCK: exact list of items to redact/remove before proceeding

## References
- `DATA_RULES.md`
- `.gitignore` (verify PII-risk files are excluded)
- `allowlist.txt` (if maintained per project)
