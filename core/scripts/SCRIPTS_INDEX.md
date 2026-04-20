---
scope: shared
---

# Arcanian Ops — Scripts & Tools Index

> All reusable scripts and tools. Client-specific scripts stay in client directories.
> CAUTION: Never commit scripts containing API tokens, passwords, or client PII.

---

## Browser Scripts (Chrome DevTools — Phase 1 Audit)

Used via Chrome DevTools MCP during measurement audits.

| Script | Purpose | Phase |
|---|---|---|
| `capture-audit-state.js` | Capture full browser state (cookies, storage, network) | 1 |
| `capture-pre-purchase-state.js` | Snapshot state before purchase flow | 1 |
| `clear-browser-state.js` | Clean slate for audit (cookies, storage, cache) | 1 |
| `cross-format-consistency.js` | Verify data consistency across formats | 4 |
| `discover-add-to-cart.js` | Find add-to-cart tracking implementation | 1 |
| `discover-checkout-fields.js` | Map checkout form fields for EC | 1 |
| `discover-cookie-banner.js` | Detect CMP type and behavior | 1 |
| `discover-js-errors.js` | Capture JavaScript errors | 1 |
| `discover-non-gtm-tracking.js` | Find tracking scripts outside GTM | 1 |
| `discover-structured-data.js` | Extract JSON-LD / Schema.org | 1 |
| `discover-tracking-domains.js` | List all domains receiving tracking data | 1 |
| `event-funnel-check.js` | Verify event sequence (view→cart→checkout→purchase) | 1, 4 |
| `gcs-parameter-check.js` | Verify Google Consent State parameters | 1 |
| `schema-dedup-audit.js` | Find duplicate structured data | 1 |
| `schema-errors.js` | Validate structured data for errors | 1 |
| `validate-consent-state.js` | Test consent banner grant/deny behavior | 1 |
| `validate-datalayer.js` | Validate dataLayer structure and events | 1 |
| `validate-fb-pixel.js` | Verify Meta Pixel implementation | 1 |
| `validate-schema-vs-page.js` | Cross-check schema data vs visible page | 1, 4 |
| `validate-user-data.js` | Verify user data for Enhanced Conversions | 1 |

## CLI Scripts (Phase 0 Baseline)

Bash scripts for command-line audit checks. No browser needed.

| Script | Purpose | Phase |
|---|---|---|
| `audit-status.sh` | Check overall audit progress | All |
| `cli-structured-data.sh` | Fetch and validate structured data via curl | 0 |
| `feed-health-check.sh` | Validate product feed XML | 0 |
| `feed-item-count-log.sh` | Track feed item count over time | 0 |
| `health-check.sh` | General platform health check | 0 |
| `pipeline-trace.sh` | Trace data pipeline (site→GTM→sGTM→platform) | 0, 4 |
| `sgtm-health-check.sh` | Check sGTM endpoint health | 0 |

## Ops Scripts (System Utilities)

Operational scripts used by skills, rules, and hooks.

| Script | Purpose | Used by |
|---|---|---|
| `open-file.sh` | Open files with correct app per `APP_DEFAULTS.md` | All skills, deliverable-save rule |
| `auto-pull.sh` | Auto-pull all git repos (cron) | Cron |
| `git-auto-sync.sh` | Git auto-sync utility | Cron |
| `archive-originals.sh` | Archive original files after processing | Inbox processing |
| `sync-client-commands.sh` | Write missing slash command stubs across clients per `CLIENT_COMMAND_MANIFEST.md` (preserves customizations) | Manual / `/scaffold-project` |
| `sync-client-permissions.sh` | Merge baseline `permissions.allow` + `additionalDirectories` into client `settings.json` so non-interactive `claude -p` can read across the `core/` symlink | Manual / `/scaffold-project` |

## Analysis Scripts (Phase 3 Container + Phase 5 Diagnosis)

Python/bash for container analysis and data processing.

| Script | Purpose | Phase |
|---|---|---|
| `gtm-consent-audit.py` | Audit consent settings across all tags in GTM JSON | 3 |
| `gtm-disableAutoConfig.py` | Check disableAutoConfig on all Meta tags | 3 |
| `gtm-tag-inventory.py` | Generate tag inventory from GTM JSON export | 3 |
| `gtm-diff.sh` | Diff two GTM container versions | 3 |

## Document Tools

Utility scripts for document processing.

| Script | Purpose | Reusable? |
|---|---|---|
| `pdf_extract.py` | Extract text/data from PDFs | Yes |
| `pdf2txt.py` | Convert PDF to plain text | Yes |
| `generate_nda_docx.py` | Generate NDA documents from template | Yes (Arcanian NDA template) |
| `read_docx.py` | Read .docx files into text | Yes |
| `create_reference_docs.py` | Generate reference documents from data | Semi (needs adapting) |

## Report Generators

Scripts for generating PDF analysis reports. Currently client-derived — need genericizing.

| Script | Purpose | Status |
|---|---|---|
| `generate_pdf_final.py` | Generate final analysis PDF report | Needs genericizing |
| `generate_pdf_hu.py` | Generate Hungarian-language PDF report | Needs genericizing |

## Test Suite

Pre-release regression tests for the AOS GUI + per-client scoping. Auto-discovers test functions; safe to extend by appending new `test_NN_*` functions.

| Script | Purpose | When to run |
|---|---|---|
| `test/aos-pre-release-tests.sh` | 15 tests across file-level, HTTP routes, and security boundaries (`--full` adds claude -p sandbox checks). See `test/README.md` for usage + how to add tests. | Before every GUI commit (`--quick`); before every release (`--full`) |

---

## Security Rules for Scripts

1. **NEVER hardcode** API tokens, passwords, or client IDs in scripts
2. **Use environment variables** for all credentials (`os.environ['KEY']`)
3. **No client PII** in script output that gets committed
4. **Review before committing** any new script — `git diff` to verify no secrets
5. **Client-specific scripts** stay in `clients/{slug}/` — only REUSABLE scripts go here
6. **.venv directories** are NEVER committed (add to .gitignore)

## Competitive Analysis

SEMrush data analysis and visualization. Originally from Diego/JAF Holz project — needs genericizing.

| Script | Purpose | Status |
|---|---|---|
| `semrush_competitive_analysis.py` | 2-phase SEMrush pipeline: discover data → analyze competitors | **TODO: genericize** (replace "diego" with `{client}` param) |
| `highlight_brand_in_charts.py` | Generate charts with one brand highlighted vs competitors | **TODO: genericize** (parameterize brand name + colors) |

**Dependencies:** pandas, numpy, matplotlib, seaborn, reportlab, openpyxl, Pillow

## Proposal Tools

Generate client proposals as .docx files.

| Script | Purpose | Status |
|---|---|---|
| `generate_seo_proposal.py` | Generate SEO/Schema proposal docx with phases and timeline | **TODO: genericize** (template the content, keep structure) |

**Dependencies:** python-docx

---

## Scripts Needing Genericizing

All scripts marked **TODO: genericize** have a comment header. To genericize:
1. Replace hardcoded client names with `{client}` or CLI argument
2. Replace hardcoded file paths with `--data_path` argument
3. Replace hardcoded colors/branding with config dict
4. Test with a different client's data
5. Remove the TODO header when done

---

## Adding a New Script

1. Determine category: browser / cli / analysis / document-tools / report-generators
2. Check: is it reusable or client-specific? (Client-specific → stays in client dir)
3. Remove any hardcoded credentials or client data
4. Add to this index
5. Add a comment header: purpose, author, date, dependencies
