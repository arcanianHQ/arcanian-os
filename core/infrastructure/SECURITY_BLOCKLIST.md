> v1.0 — 2026-04-03

# Security Blocklist

This file defines prohibited references that must not appear in committed file names or file contents for public export.

## Scope

- Applies to all tracked project files.
- Applies to both file paths and text content.
- Case-insensitive matching.

## Prohibited Terms (Client-Specific)

- `wellis`
- `diego`
- `hormizi`
- `jbtd`
- `avatar`
- `arcflux`

## Allowed Product Vocabulary (Do Not Block)

- `gtm`
- `ga4`
- `measurement audit`
- `linkedin`
- `substack`
- `belief`
- `nlp`
- `todoist`

## Data Protection Requirements

- No PII in committed content (names, emails, phone numbers, addresses, user identifiers).
- No client-identifying names unless explicitly approved placeholders.
- No API keys, tokens, passwords, or secrets in committed content.

## Enforcement

- Any prohibited client-specific term hit: BLOCK.
- Any PII or secret hit: BLOCK.
- Scanner output must include:
  - violated term
  - file path
  - line reference (if content match)
  - remediation action
