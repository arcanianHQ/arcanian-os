---
scope: shared
argument-hint: monthly output quality review
---

# Skill: Output Review (`/output-review`)

## Purpose

Monthly analysis of deliverable quality and engagement to identify which input contexts, enrichment levels, and deliverable types produce the best outcomes. This is the feedback loop that turns output archival into compound learning.

> **Discovery, not pronouncement:** Present findings as observations with questions. Show all calculations. End with "What did we get wrong?"

## Trigger

Use when: user says `/output-review`, "review outputs", "deliverable quality check", "what's working in our content", or monthly on the first Monday.

## Input

| Input | Required | Default |
|---|---|---|
| `--period` | No | Last 30 days |
| `--client` | No | All (hub-wide scan) |
| `--type` | No | All deliverable types |

## Execution Steps

### Step 1: Scan Deliverables

Scan for files with ontology blocks across:
1. `internal/content/linkedin/posts/` — LinkedIn posts
2. `internal/content/linkedin/comments/` — LinkedIn comments
3. `internal/leads/*/sent/` — Lead materials
4. `clients/*/takeover/correspondence/` — Client emails
5. `clients/*/docs/` — Client reports and analyses
6. `clients/*/reports/` — Client reports
7. `internal/correspondence/` — Internal emails
8. `internal/analyses/` — Hub-level analyses

For each file with an `## Ontology` block, extract:
- `input_context` (what triggered it)
- `quality_rating` (1-5, if populated)
- `engagement` (metrics, if populated)
- File type (from `> Type:` header)
- Date (from `> v{N} — {date}` header)
- Client (from ontology)

### Step 2: Classify by Input Context

Group deliverables by `input_context` category:
- **signal-triggered** — created in response to a signal detection
- **meeting-triggered** — created from meeting action items
- **task-triggered** — fulfilling a specific task
- **brief-triggered** — responding to a brief or enrichment stage
- **freeform** — ad-hoc user request

### Step 3: Compute Quality Metrics

For each input context category:
- Count of deliverables
- Average `quality_rating` (exclude unrated)
- Median `quality_rating`
- Count with engagement data populated

For deliverables with engagement data:
- Average impressions (LinkedIn posts)
- Average opens/clicks (emails)
- Top 3 performers by engagement

### Step 4: Cross-Tabulate

Create a matrix: **input_context × deliverable_type**

| | Email | LinkedIn Post | Memo | Report | Analysis |
|---|---|---|---|---|---|
| Signal-triggered | avg rating | avg rating | — | — | — |
| Meeting-triggered | avg rating | — | avg rating | — | avg rating |
| Task-triggered | avg rating | — | avg rating | avg rating | avg rating |
| Brief-triggered | avg rating | — | avg rating | avg rating | — |
| Freeform | avg rating | avg rating | avg rating | — | avg rating |

### Step 5: Identify Patterns

Look for:
1. **Context quality correlation:** Do deliverables with richer input_context (signal + enrichment) score higher?
2. **Type performance:** Which deliverable types consistently score highest/lowest?
3. **Engagement outliers:** What made the top 3 performers different?
4. **Rating gaps:** Which categories have no ratings? (→ prompt to backfill)
5. **Enrichment effect:** Do deliverables created after Stage 2+ enrichment (per ENRICHMENT_WATERFALL.md) outperform those from Stage 0-1?

### Step 5b: Dismissed Pattern Analysis (Learning Loop)

Scan `clients/*/RECOMMENDATION_LOG.md` for dismissed RECs (status = `no effect` or `invalidated`):
1. Extract all `detected_pattern` + `dismissed_reason` pairs
2. Group by `detected_pattern` across all clients
3. If the same pattern has been dismissed **3+ times** across different clients:
   - Flag as **systematic false positive**
   - Identify which agent/skill generates this pattern (from `Created By` column)
   - Recommend prompt improvement for that agent/skill
4. Include in output under `── FALSE POSITIVE PATTERNS ──`

```
── FALSE POSITIVE PATTERNS ────────────
| Pattern | Dismissed Count | Clients | Agent/Skill | Action |
|---|---|---|---|---|
| "missing enhanced conversions" | 4 | wellis, diego, mancsbazis, deluxe | audit-checker | Improve: check if EC is applicable before flagging |
| "ROAS below threshold" | 3 | wellis (3 domains) | channel-analyst | Improve: account for seasonal baselines |
```

**Why this matters:** A pattern dismissed 3+ times is a prompt defect, not a client issue. Fix the prompt, not the recommendation.

### Step 6: Generate Recommendations

Based on patterns, generate 3 actionable changes:
- "Signal-triggered LinkedIn comments average 4.2 quality vs freeform at 2.8 → prioritize signal-driven content"
- "Meeting-triggered emails have 0% engagement data → start tracking open rates"
- "Reports with brief-triggered context score 1.2 pts higher → always start reports from a brief"

### Step 7: Save Output

Save to `internal/reviews/YYYY-MM_output-review.md`

## Output Format

```
OUTPUT REVIEW — {period}
═══════════════════════════════════════

BLUF
{2-3 sentence summary of findings + confidence level}

── VOLUME ─────────────────────────────
Total deliverables scanned: {N}
With quality ratings: {N} ({%})
With engagement data: {N} ({%})

── QUALITY BY CONTEXT ─────────────────
| Input Context | Count | Avg Rating | Best Type |
|---|---|---|---|
| Signal-triggered | {N} | {X.X} | {type} |
| Meeting-triggered | {N} | {X.X} | {type} |
| Task-triggered | {N} | {X.X} | {type} |
| Brief-triggered | {N} | {X.X} | {type} |
| Freeform | {N} | {X.X} | {type} |

── TOP PERFORMERS ─────────────────────
1. {file} — Rating: {X} — Engagement: {metrics} — Context: {what made it work}
2. {file} — Rating: {X} — Engagement: {metrics} — Context: {what made it work}
3. {file} — Rating: {X} — Engagement: {metrics} — Context: {what made it work}

── RECOMMENDATIONS ────────────────────
1. {Actionable change with evidence}
2. {Actionable change with evidence}
3. {Actionable change with evidence}

── GAPS ───────────────────────────────
- {N} deliverables missing quality_rating → backfill prompt
- {N} deliverables missing engagement data → check if trackable
- {categories with <3 data points} → insufficient data, wait for next cycle

── DATA RELIABILITY ───────────────────
- Quality ratings: [STATED] — self-reported by author, subject to bias
- Engagement data: [DATA] — platform metrics, objective
- Pattern findings: [SYNTHESIZED] — from above, requires >10 data points for confidence
- Recommendations: [INFERRED] — based on current sample, may shift with more data

What did we get wrong? What patterns are we missing?
═══════════════════════════════════════
```

## Integration

- `save-deliverable.md` → populates the input_context, quality_rating, engagement fields
- `/morning-brief` → can reference latest output-review for content strategy decisions
- `ENRICHMENT_WATERFALL.md` → output-review validates whether deeper enrichment produces better deliverables
- `RECOMMENDATION_LOG.md` → if output-review generates RECs, they go into the log

## Examples

### Example: Monthly scan with mixed data

**Input:** 3 deliverables scanned from `internal/content/linkedin/posts/`:

| File | input_context | quality_rating | engagement |
|---|---|---|---|
| LINKEDIN_POST_12_MEASUREMENT.md | signal: P0 partner post | 4 | impressions: 2,340, comments: 18 |
| LINKEDIN_POST_13_FRAMEWORK.md | freeform: user request | 3 | impressions: 890, comments: 4 |
| LINKEDIN_POST_14_CASESTUDY.md | meeting: weekly sync | — | — |

**Output:**

```
── QUALITY BY CONTEXT ─────────────────
| Input Context | Count | Avg Rating | Best Type |
|---|---|---|---|
| Signal-triggered | 1 | 4.0 | LinkedIn Post |
| Freeform | 1 | 3.0 | LinkedIn Post |
| Meeting-triggered | 1 | — (unrated) | — |

── GAPS ───────────────────────────────
- 1 deliverable missing quality_rating → backfill: LINKEDIN_POST_14_CASESTUDY.md
- 1 deliverable missing engagement data → check: LINKEDIN_POST_14_CASESTUDY.md
- N < 10 for all categories → insufficient data, wait for next cycle
```

## Notes

- First run will likely have sparse data. That's expected — the loop needs 2-3 months to accumulate meaningful patterns.
- Don't over-index on small samples. Flag when N < 10 for any category.
- Quality ratings are self-reported and biased. Engagement data is objective. Weight engagement higher when both exist.
- This skill is read-only except for the save at Step 7.
