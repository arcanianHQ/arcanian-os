# Arcanian Ops — Data Rules

> Every team member must read and acknowledge this document before accessing any client project.

---

## Rule 1: What Goes in Git

**YES — commit these:**
- `.md` files (analysis, reports, tasks, methodology, SOPs)
- `.csv` files with **aggregated** metrics only (campaign totals, weekly summaries)
- Skills, templates, CLAUDE.md, TASKS.md
- Process documentation
- Meeting notes (redacted if PII present)

**NO — never commit these:**
- Raw API exports (GA4, Ads, AC, Shopify)
- Customer PII: names, emails, phone numbers, addresses, order details
- API tokens, passwords, OAuth secrets, `.env` files
- Client contracts, NDAs, financial details
- Screenshots with visible PII
- Large binaries (videos, recordings, ZIP files)

## Rule 2: PII Handling

**PII = Personally Identifiable Information.** Any data that can identify a specific person.

| Data | PII? | In Git? | Where? |
|---|---|---|---|
| Customer email | Yes | NEVER | Local only, delete after use |
| Customer name | Yes | NEVER | Local only |
| Aggregated revenue | No | OK | Reports in Git |
| Campaign ROAS | No | OK | Reports in Git |
| Google Ads account ID | Sensitive | OK if authorized | Client config in Git |
| API token | Secret | NEVER | `.env` only |
| GTM container ID | Not PII | OK | Client config in Git |
| IP addresses | Yes (GDPR) | NEVER | Local only |

**When in doubt: don't commit. Ask [Owner].**

## Rule 3: Secrets Management

- All API tokens, passwords, OAuth credentials → `.env` file on Mac mini
- `.env` is in `.gitignore` — it WILL NOT be committed
- Never paste a token into a `.md` file, Slack message, or commit message
- If a token is accidentally committed: rotate it IMMEDIATELY, then clean Git history

## Rule 4: Client Isolation

- Each client has its own GitHub repo
- Team members only access repos for their assigned clients
- Never copy data between client repos
- Claude Code sessions are project-scoped — one session = one client
- Cross-client analysis (if needed) uses only aggregated, non-PII data

## Rule 5: Automated Enforcement (NOT optional)

### Pre-Commit Hook (local — every repo)
Installed on every repo on the Mac mini. Blocks commits containing:
- `.env` files
- API tokens/keys/secrets (pattern match)
- Email addresses in `.md` files (warning)

Script: `scripts/ops/pre-commit-pii-check.sh` — installed to every repo's `.git/hooks/pre-commit`.

### GitHub Security Features (remote — every repo)
Enable on EVERY repo from day 1 (all FREE on GitHub Free tier):

| Feature | What it does | Enable at |
|---|---|---|
| **Dependabot alerts** | Alerts on vulnerable dependencies | Settings → Code security |
| **Secret scanning** | Detects leaked tokens in code | Settings → Code security |
| **Push protection** | BLOCKS pushes containing secrets | Settings → Code security |

Push protection is the strongest guard — if someone accidentally commits an API token, GitHub rejects the push entirely.

### Rule: If a token is accidentally committed
1. **Rotate the token IMMEDIATELY** (revoke old, generate new)
2. Clean Git history: `git filter-branch` or BFG Repo-Cleaner
3. Log incident in CAPTAINS_LOG.md
4. Post to #ops-alerts

## Rule 6: Manual Pre-Commit Check

In addition to automated hooks, visually verify before committing:
- [ ] No raw exports (`.json.gz`, `.xlsx` with row-level data)
- [ ] No customer names, emails, or phone numbers in any file
- [ ] No screenshots with visible PII
- [ ] No NDA or contract documents

## Rule 7: Data Retention

- Raw data: delete after analysis is complete (keep max 30 days locally)
- Aggregated reports: keep in Git indefinitely
- Completed tasks: archived in TASKS_DONE.md (keep indefinitely)
- Client access credentials: update ACCESS_REGISTRY.md, rotate tokens quarterly

---

*If you see a data rule violation, report it immediately in #ops-alerts. No blame — just fix it.*
