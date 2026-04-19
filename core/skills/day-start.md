---
scope: shared
---

> v1.0 — 2026-03-24

# Skill: Day Start (`/day-start`)

## Purpose

> **Output posture:** Present observations with questions. Help think, don't tell.

Morning routine: pull from [Task Manager], update local, show what needs attention. Run at the start of every work day.

## Trigger

- `/day-start` — run manually
- Session-start hook (auto-run when first session of the day opens)
- Scheduled: 8:00 AM on Mac mini

## Prerequisites

0. **HARD BLOCK — Databox MCP must be connected** for the anomaly detection steps. If not → WARN the user before proceeding. Task sync can proceed without Databox, but anomaly/metric sections must be SKIPPED. See `core/methodology/DATABOX_MANDATORY_RULE.md`.

## Process

### 1. Sync projects with [Task Manager] (bidirectional pull)

**SCOPE: Only sync projects that exist in THIS repo's `clients/` directory.** Do NOT pull tasks from the user's entire task manager account — that leaks real client data into the demo environment.

For EACH project in `clients/`:
1. Read TASKS.md frontmatter → get `sync_id`
2. If `sync_id` empty → flag: "Project {name} not mapped to [Task Manager] yet"
3. If `sync_id` exists → `[task-manager].find-tasks(projectId: sync_id, limit: 100)`
4. Compare timestamps: pull where [Task Manager] is newer
5. **NEVER query Todoist/task manager without a projectId filter** — unfiltered queries return ALL projects across ALL accounts
5. Tasks completed in [Task Manager] → move to TASKS_DONE.md locally
6. Tasks created in [Task Manager] → pull to TASKS.md (ask for Layer + Impact before adding)
7. Tasks updated in [Task Manager] → update local if [Task Manager] is newer
8. Update `ext:` + `synced:` on all synced tasks
9. Rate limited: 10/batch, 3s delay between projects

### 2. Run /task-oversight

Cross-project task health scan (calls task-overseer agent):
- Overdue tasks (grouped by project, your tasks first)
- Missing Layer / format violations (per TASK_FORMAT_STANDARD.md)
- Stale @waiting (>7 days, grouped by who)
- Sync drift (ext: but synced > 3 days ago)
- Cross-project convergent issues

### 3. Run /morning-brief

Cross-project summary (uses task-oversight data):
- P0 tasks across ALL projects
- Overdue tasks (grouped by project)
- Quick wins available (effort ≤ 1h, impact ≥ lever)

### 4. Databox Anomaly Detection

**Requires Databox MCP.** If not connected → skip this step entirely (see prerequisite 0).

For EACH project in `clients/`:
1. Read `DOMAIN_CHANNEL_MAP.md` → extract Databox data source IDs and dataset IDs
2. If no Databox mapping → skip this client
3. For each data source, query the last 30 days vs prior 30 days using `ask_genie`:
   - **Sessions by channel** → flag any channel with >30% drop (especially Email, Paid, Organic)
   - **Conversions** → compare GA4 conversions vs e-commerce platform orders → flag tracking gap >10%
   - **Ad spend & ROAS** → flag any single-day conversion value drop >50%
   - **Pipeline** → flag leads with `days_in_stage` > average deal cycle
4. For each anomaly found, output:

```
⚠ ANOMALY: {client} — {metric} {direction} {percent}%
  Period: {date range}
  Source: [DATA: Databox ds:{data_source_id}, {date}]
  Baseline: {previous period value}
  Current: {current value}
  Possible cause: {check PLATFORM_CHANGELOG.md if exists}
```

5. Cross-verify anomalies:
   - If conversion drop in ads BUT e-commerce orders stable → flag as **measurement break** (not performance)
   - If session drop in one channel BUT total sessions stable → flag as **channel shift** (not traffic loss)
   - If tracking gap >10% between platforms → flag as **data quality issue** (investigate before acting)

6. **Thresholds** (configurable per client in DOMAIN_CHANNEL_MAP.md):
   - Small business (e.g., MossTrail): alert on >15% change (every lead counts)
   - Mid-market (e.g., LoopForge): alert on >25% change
   - Enterprise/multi-domain (e.g., SolarNook): alert on >30% change (higher variance is normal)

### 5. Check inboxes

For each project:
- Count inbox/ files
- Count upd/ unprocessed items
- Flag aging items (>7 days)

### 6. Check meetings

Pull today's meetings from meeting transcript tool (if configured and any recorded since yesterday):
```
# Example: fireflies.get_transcripts(fromDate: yesterday, limit: 5)
# Adapt to your meeting tool (Fireflies, Otter, Read.ai, etc.)
```
- New meetings → route to client meetings/ (or flag for classification)
- Extract action items → show for confirmation

### 7. Check .registry-updates

Read `.registry-updates` file — any stale registries flagged by hooks?

### 7b. Ticking Clock (consequence-driven escalation)

After task sync and oversight, scan ALL projects for tasks with `Consequence: costly` or `Consequence: irreversible`:
1. Calculate business days remaining until `Deadline:`
2. If ≤ 3 business days → auto-escalate to P0 (update TASKS.md + Todoist)
3. If ≤ 7 business days → flag as upcoming
4. Sort by deadline (soonest first)
5. Surface in a dedicated section ABOVE P0 tasks in the summary

### 8. Show Day Start Summary

```
☀️ DAY START — 2026-03-25

[TASK_MANAGER] SYNC:
  ExampleBrand: pulled 3 updates, 1 completed overnight
  ExampleRetail: no changes
  ExampleLocal: 2 new tasks from [Task Manager]

⏰ TICKING CLOCK:
  🔴 ExampleBrand #201: Cancel Stape subscription — €49/mo auto-renews (Deadline: Mar 27, 2 days) [irreversible]
  🟡 ExampleLocal #202: Submit AC certification exam (Deadline: Apr 2, 6 days) [costly]

📈 STREAKS:
  ✅ Büntetőjog 4 tanulás — 3 day streak (last: yesterday) [daily]
  ✅ LinkedIn posting + commenting — 5 day streak (last: Mar 24) [daily]
  🟡 Example habit — missed 4 days (last: Mar 20) [daily] ← gap growing

P0 TASKS: 2
  ExampleBrand #77: Roivenue BigQuery billing (Due: today)
  ExampleLocal #9: Consent gating (ASAP)

OVERDUE: 3
  ExampleRetail #53: GTM message bus (3 days)
  ExampleBrand #60: IT requests (2 days)
  Arcanian #10: [Retail Lead] follow-up (26 days!)

@WAITING > 7 DAYS: 2
  [Name]: 2 tasks (BigQuery, Windsor)
  [Contact Person] ([Retail Lead]): 1 task (follow-up)

QUICK WINS: 3
  🔑 Diego #56: Email lista számla (15m, hygiene) — blocks #5 SEO project (25h)
  SolarNook #49: Wire Enhanced Conversions (15m, lever)
  MossTrail #20: Fix GAds priorities (15m, lever)
  SolarNook #22: Add SGTM to referral exclusion (15m, hygiene)

DATABOX ANOMALIES:
  ⚠ SolarNook — Email sessions -63% (30-day vs prior 30-day) [DATA: Databox]
  ⚠ SolarNook — Shopify vs GA4 tracking gap: 12.5% (296 orders vs 259 conversions) [DATA: Databox]
  ⚠ SolarNook — Google Ads conversion value -75% on Mar 18 (€9,652→€2,420) [DATA: Databox]
    → Cross-check: Shopify orders stable → likely MEASUREMENT BREAK, not performance
  ⚠ LoopForge — 5 leads in pipeline >20 days (exceeds 21-day avg deal cycle) [DATA: Databox]

INBOX: 57 files in SolarNook, 4 in internal
UPD: nothing new
MEETINGS: 1 new transcript from yesterday

REGISTRIES: BRAND_INDEX needs update (brand/ changed in ExampleLocal)

What would you like to tackle first?
```

### 9. Log

Append to hub CAPTAINS_LOG:
```
## 2026-03-25 — Day start
- Synced: {N} projects, pulled {X} updates, {Y} completions
- P0: {count} | Overdue: {count} | Waiting: {count}
```
