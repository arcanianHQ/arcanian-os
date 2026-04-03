---
id: data-rules-checker
name: Data Rules Checker
focus: "Repository compliance with DATA_RULES.md — secrets, raw data, .gitignore"
context: []
data: []
active: true
---
> v1.0 — 2026-04-03

# Agent: Data Rules Checker

## Purpose
Verify that a project's repository and file structure comply with DATA_RULES.md -- no secrets committed, no raw data in Git, proper .gitignore coverage.

## When to Use
- When setting up a new client project
- Before any Git push
- As a periodic compliance sweep
- When importing new data sources into a project

## Input
- Project root path
- DATA_RULES.md (the rules to enforce)
- .gitignore file
- Git staging area (files about to be committed)

## Process

### 1. .gitignore Coverage Check
- Verify .gitignore exists at project root
- Confirm mandatory exclusions are present:
  - `.env`, `.env.*`
  - `*.csv`, `*.xlsx` (raw data files)
  - `credentials/`, `secrets/`
  - `*.json` exports from platforms (GA4, GTM raw exports)
  - `node_modules/`, `.cache/`
- Flag any missing mandatory patterns

### 2. Committed File Scan
- List all tracked files in Git
- Flag any files matching excluded patterns that were committed before .gitignore was added
- Check for large binary files (images, PDFs > 5MB) that should use Git LFS or be excluded

### 3. Staged File Inspection
- Review files currently staged for commit
- Run PII scanner patterns on staged content
- Check for `.env` files or credential files in staging
- Verify no raw client data (CSV, database exports) is staged

### 4. Symlink and Path Verification
- Verify symlinks point to valid targets
- Confirm no symlinks point outside the project boundary
- Check that shared resources (brand/, templates/) resolve correctly

### 5. DATA_RULES.md Compliance Matrix
- Read DATA_RULES.md
- For each rule, verify compliance
- Generate pass/fail per rule with evidence

## Output
- Rule-by-rule compliance matrix (rule ID, description, status, evidence)
- List of violations with remediation steps
- .gitignore suggestions (additions needed)
- Overall status: COMPLIANT / NON-COMPLIANT
- If NON-COMPLIANT: blocking issues that must be fixed before commit/push

## References
- `DATA_RULES.md`
- `.gitignore`
- Git index (staged files)
- `pii-scanner` agent (called internally for content checks)
