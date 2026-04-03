# Skill: Claude Code Guide (`/claude-code-guide`)

> **Version:** v1.0 (2026-02-26) | **Patterns:** 21 | **Common Mistakes:** 8
> **Companion docs:** `arcanian/team/CLAUDE_CODE_BEST_PRACTICES.md` (HU), `arcanian/team/SCAFFOLDING_INSTRUCTION.md` (copy-paste)

## Purpose

Interactive guidance on Claude Code usage, CLAUDE.md writing, prompt engineering, and skill creation. Helps users (internal team or clients) set up and optimize their Claude Code workflow. Can audit existing configurations, build new ones from scratch, optimize prompts, or design custom skills.

**Core Principle:**
> "The best CLAUDE.md is the shortest one that makes Claude behave exactly right."

## Source References
- Claude Code documentation (Anthropic)
- Claude Code Masterclass (best practices article)
- Arcanian internal experience: 264-line memory → 80-line focused config
- 25+ production skills built and tested

## Trigger

Use this skill when:
- Someone asks "help me write a CLAUDE.md"
- Someone asks about Claude Code best practices
- Someone wants to create a new skill
- Someone wants to optimize their prompts for Claude Code
- Someone asks "how do I set up Claude Code for my project?"
- Someone's Claude Code setup isn't working well (following wrong conventions, forgetting rules)
- A new team member needs onboarding on Claude Code workflow

## Modes

This skill operates in 4 modes. Ask which mode is needed, or infer from context.

---

### Mode 1: CLAUDE.md Audit

**Input:** An existing CLAUDE.md file (or the user's current setup)

**Process:**

1. **Count instructions** — Total instruction count. Flag if >100 (remember: system prompt uses ~50, leaving ~100-150 for user instructions).

2. **Apply the 80% Rule** — For each section, ask: "Is this relevant to 80%+ of sessions?" Categorize:
   - ✅ KEEP — Relevant to most sessions (voice rules, Target Profile, conventions)
   - ⚠️ MOVE — Useful but session-specific (reference data, tool configs, lead details)
   - ❌ REMOVE — Redundant, outdated, or discoverable from code

3. **Check for anti-patterns:**
   - Declarations vs. instructions ("This is a React project" vs. "Use functional components with hooks")
   - Redundancy with what Claude can see in code (don't describe the tech stack if package.json exists)
   - Missing progressive disclosure (everything in one file vs. reference pointers)
   - Missing current phase/priority
   - Vague instructions ("write good code" vs. "use early returns, max 20 lines per function")

4. **Score** (1-10):
   - **Focus** (1-10): How well does it stay within the 80% rule?
   - **Clarity** (1-10): Are instructions specific and actionable?
   - **Structure** (1-10): Is it organized for quick scanning?
   - **Completeness** (1-10): Does it cover what Claude needs to know?

**Output:** Score card + specific line-by-line recommendations + suggested restructured version.

---

### Mode 2: CLAUDE.md Builder

**Input:** Conversation with the user about their project.

**Process:**

1. **Gather context** — Ask about:
   - What is this project? (1 sentence)
   - Tech stack? (languages, frameworks, key tools)
   - Team conventions? (naming, formatting, git workflow)
   - Voice/tone? (formal, casual, technical, client-facing)
   - Directory structure? (key folders and their purpose)
   - Current phase? (building, maintaining, scaling, pivoting)
   - What does Claude get wrong most often? (this reveals missing instructions)

2. **Draft CLAUDE.md** — Following these principles:
   - **Under 100 lines.** Aim for 60-80.
   - **Instructions, not descriptions.** "Use TypeScript strict mode" not "This project uses TypeScript."
   - **Specific over general.** "Max 20 lines per function" not "Keep functions short."
   - **Progressive disclosure.** Reference separate docs for detailed standards.
   - **Current phase first.** What matters NOW, not the project's history.

3. **Review with user** — Walk through each section, confirm accuracy.

**Output:** Ready-to-use CLAUDE.md file.

**Template structure:**
```markdown
# [Project Name] — Project Instructions

## What This Is
[1-3 lines: what, who, why]

## Conventions
[Language/framework rules, naming, formatting]

## Voice (if content project)
[Tone rules, what to avoid]

## Key Directories
[Where things live]

## Current Phase
[What we're building/fixing now]

## Reference
[Pointers to detailed docs, loaded on demand]
- memory/tasks.md — open tasks (single source of truth)
- memory/[topic].md — reference data by topic
```

---

### Mode 2B: CLAUDE.md Transit (Existing Project Migration)

**Input:** An existing project with a bloated CLAUDE.md, scattered configs, or no CLAUDE.md at all (instructions living in READMEs, memory files, or team knowledge).

**Process:**

1. **Inventory current state:**
   - Read existing CLAUDE.md (if any) — count instructions, identify sections
   - Check for memory files, README instructions, .cursorrules, other AI config files
   - Scan project structure: key directories, package.json/requirements.txt, existing docs
   - Total up: how many lines of instruction exist across all files?

2. **Categorize every instruction** using the 80% rule:
   - ✅ **CORE** (80%+ sessions) → stays in CLAUDE.md
   - 📁 **REFERENCE** (useful but <80%) → moves to reference file (memory/, docs/)
   - ❌ **REMOVE** (redundant, stale, discoverable from code) → delete

3. **Design the new structure:**
   ```
   CLAUDE.md (≤100 lines)           ← Core instructions only
   memory/MEMORY.md (≤50 lines)     ← Index pointing to reference files
   memory/tasks.md                  ← Single source of truth for action items
   memory/[topic].md                ← Reference files by topic
   [main-dir]/inbox/                ← Unprocessed inputs (triage weekly)
   [subdir]/CLAUDE.md               ← Directory-specific instructions (optional)
   ```

4. **Create reference files FIRST** — Extract all REFERENCE content into topic files before touching the main config. This ensures nothing is lost.

5. **Consolidate tasks** — Search the entire project for scattered TODOs, "(TO DO)" markers, status items, "needs to", "not completed", checkbox patterns. Collect ALL actionable items into a single `memory/tasks.md` file. Structure by priority/deadline, not by topic. Remove duplicates from source files, replace with pointer.

6. **Rewrite CLAUDE.md** — Fresh file following the template from Mode 2. Don't edit the old one line-by-line — start clean. Include `memory/tasks.md` in the reference section.

7. **Rewrite MEMORY.md** — Slim index pointing to reference files (including tasks.md). No inline status items — those live in tasks.md now.

8. **Directory cleanup** — For any directory with >50 flat files:
   - Propose semantic subdirectories based on filename patterns
   - Create subdirectory CLAUDE.md with structure guide and naming conventions
   - Move files in batches, count before and after (must match)
   - Clean the project root: only CLAUDE.md, README.md, config files, utility scripts, named directories

9. **Verify nothing lost:**
   - Every line from the old config exists in either new CLAUDE.md, new MEMORY.md, or a reference file
   - Every TODO/action item exists in tasks.md
   - File counts match before and after for every moved directory
   - Cross-reference checklist: old sections → new locations

**Output:** Complete new file structure + migration checklist + before/after comparison.

**Arcanian example (our own migration):**
```
BEFORE:
  MEMORY.md        264 lines  (everything in one file, 63 lines over limit)
  arcanian/        294 flat files
  Project root      28 items
  Tasks scattered across 3 files with no single source

AFTER:
  CLAUDE.md         67 lines  (core instructions — always loaded)
  MEMORY.md         42 lines  (slim index — always loaded)
  memory/tasks.md   30 lines  (single task source of truth)
  memory/leads.md   38 lines  (on demand)
  memory/tools.md  137 lines  (on demand)
  memory/events.md  23 lines  (on demand)
  arcanian/          4 root files + 10 semantic folders
  Project root       5 items

Always-loaded: 109 lines (was 264) — 59% reduction
```

---

### Mode 3: Prompt Optimization

**Input:** A prompt the user wants to improve for Claude Code.

**Process:**

1. **Analyze current prompt** for:
   - Specificity — Is the desired output clear?
   - Context — Does Claude have what it needs?
   - Structure — Is it scannable? Clear sections?
   - Constraints — Are boundaries defined?
   - Examples — Are there examples of desired output?

2. **Optimize using these principles:**
   - **Front-load the intent.** What do you want? Say it first.
   - **Provide context, not history.** Claude doesn't need the story of how you got here.
   - **Specify the output format.** "Output a markdown table with columns X, Y, Z."
   - **Use constraints, not wishes.** "Max 3 paragraphs" not "Keep it short."
   - **Include anti-examples.** "Do NOT include X" is surprisingly effective.
   - **Reference existing files.** "Follow the pattern in `skills/7layer.md`" — Claude can read it.

3. **Show before/after** with explanation of each change.

**Output:** Optimized prompt + explanation of changes + general tips for the user's prompt style.

---

### Mode 4: Skill Design

**Input:** An idea for a new skill.

**Process:**

1. **Define the skill:**
   - What problem does it solve?
   - Who uses it? (internal team, clients, both)
   - What triggers it? (phrases, situations)
   - What input does it need?
   - What should the output look like?

2. **Design the structure** (following Arcanian skill patterns):
   ```
   # Skill: [Name] (`/skill-name`)
   ## Purpose — What it does + core principle
   ## Source References — Methodology/knowledge base
   ## Trigger — When to use
   ## Input Required — What Claude needs from the user
   ## Process — Step-by-step methodology
   ## Output Format — What gets delivered
   ## Integration — How it connects to other skills
   ## Edge Cases — What to watch for
   ```

3. **Check integration:**
   - Does it overlap with existing skills?
   - Where does it fit in the workflow? (before/after which skills?)
   - Does it feed into or receive from other skills?
   - See `skills/INTEGRATED_BUSINESS_WORKFLOW.md` for the current skill map.

4. **Draft the skill file** — Full, production-ready skill following the pattern.

**Output:** Complete skill file + integration notes.

---

## Operational Patterns

### Project Suspend & Resume

When pausing work (end of day, switching projects, or stepping away mid-task):

**Before suspending:**
1. **Capture state** — Write a brief status note to `memory/MEMORY.md` under "Active Status Items":
   - What you were doing
   - What's done vs. what remains
   - Any blockers or decisions needed
2. **Captain's Log entry** — Add a timestamped entry to `CAPTAINS_LOG.md`:
   - Date + what was decided/done
   - Why (the reasoning, not just the action)
   - What's next
3. **Todo list** — If mid-task with multiple steps, leave a TODO list in the relevant file or create a task list

**When resuming:**
1. Read `CAPTAINS_LOG.md` (last 2-3 entries) for context
2. Read `memory/MEMORY.md` for active status items
3. Check any TODO lists or task files
4. Claude Code can also read its own session transcripts from `.claude/` if needed

### Computer Reboot / Session Recovery

Claude Code sessions are ephemeral — when the terminal closes, context is lost. The safety nets:

1. **CLAUDE.md** — Always reloaded automatically. This is why core instructions must live here.
2. **memory/MEMORY.md** — Always reloaded automatically. Active status items survive reboots.
3. **Session transcripts** — Stored in `.claude/projects/[project]/[session-id].jsonl`. Can be searched with Grep if you need to recover a specific conversation.
4. **Captain's Log** — The human-readable record of decisions. Read this to re-orient after a break.
5. **Git history** — `git log` and `git diff` show what changed in the last session.

**Recovery protocol after unexpected shutdown:**
```
1. Claude reads CLAUDE.md (automatic)
2. Claude reads MEMORY.md (automatic)
3. User says: "I was working on X, check the captain's log for context"
4. Claude reads CAPTAINS_LOG.md → understands where things stand
5. Resume work
```

### Session Logging

**What to log and where:**

| Event | Where to log | When |
|-------|-------------|------|
| Strategic decision | `CAPTAINS_LOG.md` | When making choices that affect direction |
| New action item / TODO | `memory/tasks.md` | Immediately when discovered — single source of truth |
| Completed task | `memory/tasks.md` | Move from open to completed with date |
| New learning/pattern | `memory/MEMORY.md` or topic file | When discovering something reusable |
| Published content | `PUBLICATION_DIRECTORY.md` | After every publication |
| Lead interaction | `memory/leads.md` | After meetings, emails, status changes |
| Tool/setup change | `memory/tools-and-setup.md` | When adding/changing tools |

**Task file rules:**
- ONE file for all tasks. Never scatter TODOs across multiple files.
- Group by priority/deadline, not by topic.
- Check at session start. Update at session end.
- If you find a TODO in another file, move it to tasks.md and replace with a pointer.

**Captain's Log format:**
```markdown
## 2026-02-26

### [Topic]
- **Decision:** What was decided
- **Why:** The reasoning
- **Next:** What follows from this
```

The Captain's Log is the project's institutional memory. It answers "why did we do X?" months later. Write it for your future self who has zero context.

### Best Practice: The "4-File Recovery" Test

If Claude Code starts fresh with ONLY these 4 files loaded, can it do useful work?
1. `CLAUDE.md` — knows how to behave
2. `memory/MEMORY.md` — knows where everything lives
3. `memory/tasks.md` — knows what needs doing
4. `CAPTAINS_LOG.md` — knows recent decisions and why

If yes → your documentation structure is healthy.
If no → something critical is missing from one of these files.

---

## Scaffold Patterns (Learned from Production Use)

These patterns come from running 25+ skills on a real project. Apply them when building or migrating any Claude Code project.

### Pattern 1: Skills Are Executable Instructions, Not Docs
A skill file is a recipe Claude follows step-by-step. Structure: Purpose → Trigger → Input → Process → Output → Integration. Each skill must be **self-contained** — loadable without reading other files. Test: can a new Claude instance load ONLY this skill and produce useful output?

### Pattern 2: Captain's Log = Decision Journal
Don't log WHAT you did. Log **WHY.** Format: Decision + Reasoning + Important Nuance + Next Steps. The nuance field is critical — "we stopped building SaaS" vs. "we stopped building SaaS because mid-market won't adopt tools" are completely different signals months later.

### Pattern 3: Apply the Framework to Yourself
If you sell a diagnostic framework, run it on your own business first. Document the results. This creates authenticity AND serves as a teaching case for new team members. ("Here's how we'd analyze a client like us.")

### Pattern 4: Terminology Consistency Across All Surfaces
Define key terms in CLAUDE.md. Use them identically everywhere: code comments, content, pitches, internal docs. If your diagnostic report is called "[Diagnostic Service]" — it's ALWAYS "[Diagnostic Service]", never "report" or "analysis." Claude will follow this if instructed.

### Pattern 5: Publication Tracking as Accountability
Maintain a `PUBLICATION_DIRECTORY.md` with Status / Date / File Reference for all published content. This creates a real-time map of shipped vs. promised. Gap visibility drives prioritization.

### Pattern 6: Belief Work Before Strategy (Content/Marketing Projects)
For projects involving founder-led businesses or personal brands: identify founder patterns BEFORE building strategy. "My value is in being personally needed" will sabotage a scalability project every time. Document patterns explicitly. Create check-back schedules.

### Pattern 7: The KKV-Origin Cascade (Domain-Specific but Generalizable)
In any domain, identify the **common origin pattern** of your target clients. For HU mid-market: companies that grew in revenue but kept small-company operations. The equivalent exists in tech (startup culture in a 500-person company), consulting (one partner doing everything), etc. Define this cascade in CLAUDE.md so Claude recognizes it on every new client.

### Pattern 8: Inbox as Triage Buffer
Raw inputs (articles, screenshots, PDFs, ideas, voice note transcripts) need a landing zone. Without one, they clutter the project root or get lost. Create an `inbox/` folder with rules: name files `YYYY-MM-DD_SHORT_DESCRIPTION.md`, process or archive within 1 week. Weekly inbox triage = weekly prioritization. The inbox is a buffer, not storage.

### Pattern 9: Multi-Model Routing
Not every task needs the most expensive model. Route by task type: Haiku for formatting/extraction/simple queries, Sonnet for drafts/summaries/translations, Opus for strategy/diagnosis/nuanced writing. Rule of thumb: if the output is copy-paste (formatting, listing) → cheap model. If the output requires judgment or interpretation → expensive model. In Claude Code, use `/model` to switch mid-session.

### Pattern 10: Weekly Self-Review
Have Claude run a periodic health check on project state: stale tasks (>1 week), unprocessed inbox items, overdue content calendar entries, inactive leads. This surfaces forgotten items without replacing human judgment. Prompt template: "Review tasks.md, inbox/, content calendar, and leads.md — flag anything that needs attention."

### Pattern 11: Sensitive Data Safety File
For client projects under NDA or with GDPR-protected data, create `memory/sensitive-context.md` with explicit filtering rules Claude must follow. Not encryption — a runtime filter: what must NEVER appear in client-facing docs (margins, unit costs, employee salaries), which data is GDPR-protected, what can be used in aggregated form only. Reference in CLAUDE.md as "SAFETY-CRITICAL." Example from production: financial numbers, AC contacts, Shopify customer data all had explicit filtering rules that prevented accidental disclosure.

### Pattern 12: Hard Rules (Identity Separation)
Some instructions, if violated, cause real damage — legal, relationship, or financial. These are **Hard Rules**: identity separation ("act as client employee, NEVER as consultant toward agency X"), email domain rules, NDA-specific number restrictions, GDPR data generation bans. Hard Rules go at the TOP of CLAUDE.md, visually separated. Test: "If Claude violates this, would I need to send an apology email or call a lawyer?" If yes → Hard Rule.

### Pattern 13: Client Project vs Internal Project
Client projects need different CLAUDE.md structure than internal projects. Key differences: Hard Rules (almost always needed), sensitive data file (mandatory), stakeholder list in memory, identity separation, agency coordination docs. Client CLAUDE.md template: What This Is → Current Phase → Hard Rules → Key Contacts (→ memory) → Directories → Sensitive Data (→ memory) → Reference → Tasks (→ memory). Less voice rules, more operational rules.

### Pattern 14: Time-Bound Priorities → Tasks File, Not CLAUDE.md
Anti-pattern: "This Week's Priorities: 1. Fix email, 2. Terminate vendor" in CLAUDE.md. These go stale in days but CLAUDE.md loads every session. Claude will think stale priorities are still active. Fix: keep only phase-level info in CLAUDE.md ("Current Phase: TAKEOVER — [Former Team Member] departed, [Owner] coordinating"), point to `memory/tasks.md` for current priorities. Tasks change daily. Phases change monthly.

### Pattern 15: Numbered Sequential Files
When file order matters (SOPs, processes, quick wins), use prefix numbering: `00-OVERVIEW.md`, `01-FIRST-PROCESS.md`, ..., `10-QUICK-WIN-x.md`. Rules: 00 = always the overview/index, 01-09 = stable core processes, 10+ = supplementary/changing items. The number is reading order, not priority. If you need to insert between 10 and 11, use `10b-` rather than renumbering everything.

### Pattern 16: Voice Rules as Hard Constraints
Voice isn't a "nice to have" section. It's a **filter**. Define what Claude must NEVER write (specific words, phrases, tones) and what to use instead. Anti-examples are more effective than examples. "Never write 'honestly'" is clearer than "be authentic."

### Pattern 17: Index Files for Large Codebases
When inheriting or auditing an unfamiliar directory (500+ files, no clear structure), create a `general_index.md` navigation file. Map key files with 1-line descriptions, group by category, and include a "may not be up to date — verify against actual files" caveat. Not a substitute for proper directory restructuring, but a critical first step for orientation. Especially useful for client handovers, inherited codebases, and audit preparation.

### Pattern 18: Context Swapping (Multiple CLAUDE.md Variants)
For projects that operate in distinct modes (audit vs. content writing vs. client delivery), maintain variant CLAUDE.md files: `.claude/CLAUDE.audit.md`, `.claude/CLAUDE.content.md`, `.claude/CLAUDE.client-facing.md`. Swap with `cp .claude/CLAUDE.audit.md CLAUDE.md`. Use when behavioral rules differ so much between modes that a single CLAUDE.md would be cluttered with conditionals. If 3-4 short conditional blocks suffice, use Conditional Instructions (Pattern 19) instead.

### Pattern 19: Conditional Instructions (Directory-Dependent Rules)
A lighter alternative to Context Swapping: directory-dependent rules within a single CLAUDE.md. Format: "When working in `content/linkedin/`: use Pattern Drop voice, bilingual EN+HU" / "When working in `leads/`: professional HU, never mention methodology details." Use when mode differences can be expressed in 3-5 lines per directory. If more complex, use subdirectory CLAUDE.md files or Context Swapping.

### Pattern 20: Workflow Definitions in CLAUDE.md (vs. Skills)
Workflows are step-by-step processes Claude should ALWAYS follow (5-10 lines, in CLAUDE.md). Skills are on-demand, loaded by trigger (50-300 lines, separate files). Example workflow: "Adding a New Lead: 1. Check leads/, 2. Create COMPANYNAME_LEAD.md, 3. Update memory/leads.md, 4. Update tasks.md, 5. Log in CAPTAINS_LOG.md." If the process is under 10 lines and relevant every time → CLAUDE.md workflow. If longer or specialized → skill file.

### Pattern 21: Hooks + CLAUDE.md = Rule + Enforcement
CLAUDE.md states the rule; hooks enforce it automatically. Don't ask Claude to remember to lint, format, or run checks — set up hooks in `.claude/settings.json` that run on events (PreToolUse, PostToolUse, pre-commit). CLAUDE.md just states: "A pre-commit hook handles formatting. Don't worry about style." Division of labor: instruction file + automation > instruction file + hoping Claude remembers. Rule: if you write "always run X after Y" in CLAUDE.md, that's a hook candidate.

---

## Common Mistakes

### 1. Instruction Bloat
**Problem:** CLAUDE.md grows to 300+ lines because every new discovery gets added.
**Fix:** Apply the 80% rule quarterly. Move reference data to separate files.

### 2. Descriptions Instead of Instructions
**Problem:** "This project uses React 18 with TypeScript and Tailwind CSS."
**Fix:** "Use React 18 functional components. TypeScript strict mode. Tailwind for all styling — no inline styles or CSS modules."

### 3. No Progressive Disclosure
**Problem:** Every API endpoint, every database schema, every config option in CLAUDE.md.
**Fix:** Put detailed references in separate files. CLAUDE.md just points: "API specs: see `docs/api.md`."

### 4. Missing Voice/Tone (for content projects)
**Problem:** Claude writes generic corporate content.
**Fix:** Add specific voice rules with examples and anti-examples. "Write like [example]. Never write like [anti-example]."

### 5. Stale Instructions
**Problem:** CLAUDE.md says "we're building the MVP" but you shipped 6 months ago.
**Fix:** Update "Current Phase" whenever the project phase changes. Set a quarterly review reminder.

### 6. Over-Engineering Prompts
**Problem:** 500-word prompt for a simple task.
**Fix:** Start simple. Add detail only where Claude gets it wrong. The best prompt is the shortest one that produces the right result.

### 7. Time-Bound Tasks in CLAUDE.md
**Problem:** "This Week's Priorities: 1. Fix email, 2. Terminate vendor" in CLAUDE.md. Stale in 3 days, Claude still follows them weeks later.
**Fix:** CLAUDE.md holds phase ("Current Phase: TAKEOVER"). Time-bound tasks go in `memory/tasks.md` with a pointer from CLAUDE.md.

### 8. Missing Sensitive Data Rules (Client Projects)
**Problem:** Claude includes exact margins, internal costs, or employee names in a document that goes to the client.
**Fix:** Create `memory/sensitive-context.md` with explicit filtering rules. Reference as SAFETY-CRITICAL in CLAUDE.md.

## Integration

This skill works standalone or as part of the Arcanian workflow:
- **For internal team:** Use Modes 1-4 as needed for our own projects
- **For clients:** Use Mode 2 to help clients set up Claude Code for their marketing teams
- **For skill development:** Use Mode 4 when building new diagnostic skills
- **Feeds into:** Any project setup, team onboarding, methodology development
- **Teaching companion:** `arcanian/CLAUDE_CODE_BEST_PRACTICES.md` (Hungarian, for [Team Member 2] & [Team Member 1])

## Edge Cases

- **Multi-language projects:** Create separate voice rules sections for each language (as we do: HU content + EN code/docs)
- **Multiple team members:** Use `CLAUDE.local.md` for personal preferences, `CLAUDE.md` for shared conventions
- **Evolving projects:** Update "Current Phase" whenever priorities shift. Stale phase info = stale Claude behavior.
- **Skill conflicts:** If two skills seem to apply, ask the user which lens they want. Don't blend methodologies silently.
