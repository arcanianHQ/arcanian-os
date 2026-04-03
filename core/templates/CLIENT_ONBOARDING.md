> v1.0 — 2026-04-03

# Client Onboarding Checklist

> Use this checklist when onboarding a new measurement audit client.
> Copy this file into the client directory and check off items as completed.

## Pre-Setup

- [ ] Confirm engagement scope (initial audit, ongoing weekly, incident-only)
- [ ] Receive platform access credentials or invitations
- [ ] Identify primary contact and escalation chain

## Directory & Config

- [ ] Create client directory: `clients/{slug}/`
- [ ] Fill `CLIENT_CONFIG.md` from template (domains, feed URLs, GTM IDs, CMP type, contacts)
- [ ] Fill `ACCESS_REGISTRY.md` from template (all users, property IDs, API keys, ESP connections)
- [ ] Set up `ESCALATION_CONTACTS.md` (who fixes what, communication protocol)
- [ ] Create `TASKS.md` (initial task list from onboarding)

## Data Collection

- [ ] Document Channable rules → `data/channable/CHANNABLE_RULES.md` (from template, if client uses Channable)
- [ ] Export GTM containers (Web + SGTM) → `data/gtm-exports/{slug}/`
- [ ] Document all Meta Pixel IDs and Catalogue IDs → `ACCESS_REGISTRY.md`
- [ ] Document all GA4 Property IDs → `ACCESS_REGISTRY.md`
- [ ] Document all Google Ads Account IDs and Conversion Action IDs → `ACCESS_REGISTRY.md`
- [ ] Document ESP/email service connections (Klaviyo, Mailchimp, etc.) → `ACCESS_REGISTRY.md`
- [ ] Log all access requests and their status → `ACCESS_REGISTRY.md`
- [ ] Identify CMP type and document consent group mapping
- [ ] Identify platform (Magento/Shopify/WooCommerce) and version

## Baseline

- [ ] Run Phase 0 (CLI baseline): SGTM health, feed item counts, pixel status
- [ ] Take feed snapshots (product feed URLs → save raw XML/CSV)
- [ ] Select 10 test products (mix of simple, configurable, bundle, grouped if applicable)
- [ ] Document test product IDs, SKUs, and URLs in `CLIENT_CONFIG.md`

## Multi-Country (if applicable)

- [ ] Initialize `REPLICATION_MATRIX.md` (list all countries/domains)
- [ ] Document per-country container IDs, pixel IDs, feed URLs
- [ ] Verify SGTM endpoints per country

## Audit Kickoff

- [ ] Create initial audit directory: `audits/YYYY-MM-DD_initial/`
- [ ] Copy `AUDIT_REPORT.md` template into audit directory
- [ ] Begin Phase 0 execution

## Finalize

- [ ] Git commit baseline (all config files, exports, snapshots)
- [ ] Schedule first weekly check date
- [ ] Send client confirmation with scope summary

---

**Template version:** 1.0
**Last updated:** 2026-03-07
