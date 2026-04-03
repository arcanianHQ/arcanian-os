---
id: pii-scanner
name: PII Scanner
focus: "PII, API tokens, and secrets detection in files and commits"
context: []
data: []
active: true
---
> v1.0 — 2026-04-03

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
- SECURITY_BLOCKLIST.md (prohibited names/terms in file names and contents)
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

### 6. Forbidden Term and Scope Checks (Mandatory)
- Scan both **file names** and **file contents** for prohibited references listed in `SECURITY_BLOCKLIST.md`
- Block only client-specific prohibited terms (for public export), including:
  - Any real client names, project codenames, or internal methodology names listed in `SECURITY_BLOCKLIST.md`
- Do **not** block core product vocabulary (e.g., GTM/GA4/measurement terminology) unless specifically overridden by policy
- Treat any match as **HIGH** severity (or **CRITICAL** if combined with PII/secrets)
- Flag direct client names in committed content unless they are approved placeholders

## Output
- List of findings with: file, line number, pattern type, matched text (partially redacted)
- Severity: CRITICAL (secrets/tokens), HIGH (clear PII), MEDIUM (possible PII), LOW (suspicious pattern)
- BLOCK or PASS verdict
- If BLOCK: exact list of items to redact/remove before proceeding
- Include a dedicated "Blocklist Violations" section with counts by term and by file

## References
- `DATA_RULES.md`
- `SECURITY_BLOCKLIST.md`
- `.gitignore` (verify PII-risk files are excluded)
- `allowlist.txt` (if maintained per project)
