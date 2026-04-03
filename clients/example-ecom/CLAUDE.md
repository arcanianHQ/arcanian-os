> v1.0 — 2026-04-03

# AquaLux — Project Instructions

## What This Is
Example multi-domain e-commerce client — premium wellness products (hot tubs, swim spas).
3 business units, 5 domains, 2 currencies, shared ad accounts.
**Owner:** You | **Team:** You | **Created:** 2026-04-03

This is a demo project showing how Arcanian OS handles multi-domain, multi-currency complexity.

## Business Unit Isolation (MANDATORY)
**These are SEPARATE BUSINESSES. NEVER blend in analysis, budgets, or recommendations.**

| Unit | Domain | Market | Model | Currency |
|---|---|---|---|---|
| **AquaLux US** | aqualux-us.com | US D2C | Shopify, $3K-$7K products | USD |
| **AquaLux EU** | aqualux.eu, aqualux.de | EU B2C | WooCommerce | EUR |
| **AquaLux Dealers** | dealers.aqualux.com | US B2B | WordPress, lead gen | USD |

## Multi-Domain
**Before ANY analysis:** load `DOMAIN_CHANNEL_MAP.md` and filter by domain AND business unit.
- Google Ads account is SHARED (US + EU) — always filter by campaign prefix
- Meta has separate accounts per business unit
- AC has 2 instances: US and EU

## Task System
- `TASKS.md` / `TASKS_DONE.md` / `/tasks`
- Rules: `../../core/methodology/TASK_SYSTEM_RULES.md`
- Layers: L0-L7

## SOP Auto-Surface (ALWAYS-ON)
Before executing any task, check if a relevant SOP exists and LOAD it.

## Data Analysis Output Standard (ALWAYS-ON)
Every data query MUST use BLUF + OODA + Data Reliability frameworks.
Multi-domain: ALWAYS specify business unit in output.
