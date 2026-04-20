---
scope: shared
type: getting-started guide — first-hour hands-on walkthrough for AOS
purpose: Gets a practitioner from "I cloned the repo" to "I've run my first diagnostic on a demo client" in about 60 minutes. Assumes minimal prior Claude Code experience; does not assume familiarity with AOS methodology.
license: CC BY-SA 4.0
related:
  - README.md (what AOS is, who it's for)
  - MANIFESTO.md (the operating thesis)
  - 7_HABITS.md (behaviours you'll apply while working)
  - governance/CONTRIBUTING.md (when you're ready to give something back)
---

# Getting Started with AOS

From zero to your first diagnostic in about an hour.

This guide assumes you have already read the **[README](README.md)** and know what AOS is. If you haven't, stop here and read that first — it's a ten-minute read and everything below will make more sense afterward.

---

## What you need before you start

**On your machine:**
- **Claude Code** installed and signed in. If you don't have it yet: [claude.com/download](https://claude.com/download) and follow Anthropic's setup instructions. You'll need a Claude account (Pro or Team — AOS skills run fine on either).
- **Git** installed. If `git --version` works in your terminal, you're set. If not: [git-scm.com/downloads](https://git-scm.com/downloads).
- **A terminal** you're comfortable opening (Terminal on macOS, PowerShell or Windows Terminal on Windows, any shell on Linux).

**Nice to have but not required for the first hour:**
- A text editor that handles markdown well (Typora, Obsidian, VS Code — any of them).
- A free account on any of the platforms AOS integrates with (Databox, Semrush, ActiveCampaign). You won't need these for demo-data practice, but you'll want them before pointing AOS at your own clients.

**Time budget:** 60 minutes, unhurried. Faster if you already use Claude Code.

---

## Step 1 — Clone the repo (3 minutes)

In your terminal, pick a directory where you want AOS to live and clone:

```bash
cd ~/Sites   # or wherever you keep projects
git clone https://github.com/arcanianHQ/arcanian-os-shared.git
cd arcanian-os-shared
```

You now have the full AOS Shared repo on your machine.

Take a look around:

```bash
ls
```

You should see: `README.md`, `MANIFESTO.md`, `7_HABITS.md`, `SIX_COMPONENTS.md`, `SEVEN_PLUS_ONE_LAYERS.md`, `GLOSSARY.md`, `WHY_AGENCIES_BREAK.md`, a `core/` directory, a `demo-data/` directory, and a `governance/` directory.

---

## Step 2 — Start a Claude Code session inside the repo (2 minutes)

Still in the `arcanian-os-shared` directory, run:

```bash
claude
```

Claude Code starts up and automatically reads a file called `CLAUDE.md` at the repo root. That file tells Claude what AOS is, what's in each folder, and how the skills work. From this moment, Claude Code has the full AOS context loaded.

You'll know it worked when Claude greets you and, if you ask it something like *"what is this repo?"*, it answers in AOS terms — it knows about the 7 Habits, the layers, the skills, the demo clients.

If Claude Code doesn't start or complains, check Anthropic's [docs on first-run setup](https://docs.claude.com). Most first-time issues are about authentication, not the repo.

---

## Step 3 — Walk through the demo clients (10 minutes)

The repo includes three demo clients in `demo-data/`:

- **`loopforge/`** — a B2B SaaS agency client (example data for diagnostic practice)
- **`mosstrail/`** — a D2C e-commerce brand (different channel mix, different constraints)
- **`solarnook/`** — a services business (a third shape for comparison)

Each folder has the kind of context an agency would normally build over months of working with a client: a `CLAUDE.md`, a `CONTACTS.md`, performance data, brand docs, task lists, decision logs. They're fake, but structured exactly like real Arcanian client folders.

Before you run any skill, spend ten minutes reading through **`demo-data/loopforge/CLAUDE.md`** and **`demo-data/loopforge/CONTACTS.md`**. Get a feel for the client: who they are, what they sell, who their stakeholders are, what their last quarter looked like. The more context you have, the more a skill has to work with.

---

## Step 4 — Run your first skill: `/health-check` (5 minutes)

`/health-check` is the lightest skill in the pack. It reads a client folder and produces a short, source-tagged summary of the client's current state. No diagnostics, no recommendations — just a structured read of what's in the folder.

In your Claude Code session, run:

```
/health-check loopforge
```

Claude will:

1. Read the `loopforge` demo-data folder
2. Identify the key files and recent entries
3. Return a summary that is evidence-tagged (e.g., `[STATED: CONTACTS.md]`, `[OBSERVED: TASKS.md]`)

Read what it produced. Notice how every claim points at a source. That is **Habit 2 — Show the trail** — the single most important discipline in AOS, enforced from the first skill you run.

**If something went wrong:** check whether the `demo-data/loopforge` folder actually exists in your clone. If it doesn't, pull the latest from the repo (`git pull`).

---

## Step 5 — Run your first diagnostic: `/7layer` (15 minutes)

Now a real diagnostic. `/7layer` reads a client folder through the lens of the 7+1 Layer framework and names which layer the constraint actually lives at.

```
/7layer loopforge
```

This will take longer than `/health-check` — Claude is reading more, cross-referencing, and producing a structured diagnostic. Expect 1–3 minutes of working time.

What you'll get back is a document shaped like the **One-Page Diagnosis** template (you'll find the blank in `core/templates/ONE_PAGE_DIAGNOSIS_TEMPLATE.md`):

- **The constraint we have named** — one sentence, which layer
- **Evidence** — five points, each source-tagged
- **Recommendations** — one to three actions with owners and dates
- **What we expect to change** — specific metric, from → to, by when
- **What could invalidate our diagnosis** — the honest line

Read it. Notice:

- The diagnosis names a *specific layer* (L0, L1, L2, ... or L7) and says why *that* layer, not another.
- Every claim has a source.
- The recommendations have named owners and dates, not vague suggestions.
- The *"what would invalidate"* section is honest about what would prove the diagnosis wrong.

This is **Habit 1 — Diagnose before you deliver** in action. Every real engagement with AOS starts with a document shaped exactly like this one.

---

## Step 6 — Try a second client for contrast (10 minutes)

Run the same skill against a different demo client:

```
/7layer mosstrail
```

Because `mosstrail` is a different shape of business (D2C e-commerce, not B2B SaaS), the constraint will almost certainly land at a different layer. Compare the two diagnostics side by side.

This is the part that surprises most practitioners: *the methodology doesn't produce the same answer for every client.* It produces the answer the client's actual context points at. Run `/7layer` on `solarnook` if you want a third for comparison.

---

## Step 7 — Look at what a skill actually is (5 minutes)

You've now run two skills. Take five minutes to see what a skill *is*.

Open `core/skills/7layer.md` in your text editor. It's just a markdown file with a frontmatter block, a prompt, a set of instructions, and some guidance on how to format the output.

That's the entire mechanism. A skill is a prompt-plus-instructions that Claude Code follows every time you invoke it. There's no hidden compiled code, no SaaS backend, no opaque engine. You can read every skill, understand exactly what it does, and — if you want — fork it, modify it, write your own.

This is also why the guardrail matters: *because* skills are just readable markdown, the discipline of what goes into the public pack has to be maintained by people, not enforced by a black box.

---

## Step 8 — Read the learning path (10 minutes)

You've just run the equivalent of Stage 1 on your own. To see the full curriculum AOS practitioners follow:

Open **[the learning path](docs/learning-path.md)** *(once the public repo is published; until then, read the manifesto and 7 Habits).*

It walks five stages:

- **Stage 1 — Migrate:** get comfortable with Claude Code + reading skills
- **Stage 2 — Configure:** write your agency's own `CLAUDE.md` and run skills on real folders
- **Stage 3 — Orchestrate:** spawn agents, run councils (multi-agent diagnostics)
- **Stage 4 — Connect:** wire MCP to live client data (Databox, Semrush, etc.)
- **Stage 5 — Enrich:** full-stack diagnostics, pattern contributions, first published case study

You've just done the first hour of Stage 1. The rest of the path is self-paced. Most practitioners complete Stages 1–3 in a few weeks of part-time work.

---

## Step 9 — What to do next (your pick)

**If you want to understand the system better before doing more:**
- Read **[the manifesto](MANIFESTO.md)** — the operating thesis in ~1,500 words
- Read **[the 7 Habits](7_HABITS.md)** — the behaviours every skill enforces
- Read **[the 7+1 Layer framework](SEVEN_PLUS_ONE_LAYERS.md)** — the diagnostic map

**If you want to start running AOS against your own work:**
- Pick one of your real clients (get their consent if you're going to touch live data)
- Create a folder under `clients/` in your local fork of AOS (or in your own repo)
- Write a `CLAUDE.md` modeled on the demo-client examples
- Start with `/health-check` and `/7layer`, same as you did for loopforge
- Use the findings to write a **One-Page Diagnosis** (template at `core/templates/ONE_PAGE_DIAGNOSIS_TEMPLATE.md`)

**If you want to contribute back:**
- Read **[CONTRIBUTING](governance/CONTRIBUTING.md)** — how to sign patterns, submit pull requests, join the practitioner community
- Read the **[Code of Conduct](governance/CODE_OF_CONDUCT.md)** — the community expectations

**If you want help installing AOS properly in your agency:**
- Contact Arcanian: `hello@arcanian.ai`
- Arcanian offers four engagement depths: Self (what you just did — always free), Guided (Onboarding), Embedded (ongoing collaboration), Partnership (strategic co-creation). Details in the README.

---

## Common first-hour issues

**"Claude Code doesn't see the skills."**
Check that you're running `claude` from *inside* the `arcanian-os-shared` directory. Claude Code loads `CLAUDE.md` from the current working directory; outside the repo, it won't know about AOS.

**"The skill ran but the output is vague / weird."**
Re-check the demo client folder has the files the skill expects. Run `/health-check` first to see what Claude can actually read. If `/health-check` looks sparse, the folder might not have been cloned properly.

**"I don't understand the framework the skill is applying."**
Stop running skills for a bit. Read the manifesto, the 7 Habits, the 7+1 Layer framework. Come back. The skills make much more sense once the mental model is in place — which is why we recommend reading the framework docs in Step 9 before running AOS against your own clients.

**"Can I run AOS without Claude Code — with a different AI tool?"**
In principle yes, in practice not really. The skills are prompt files that rely on Claude Code's ability to read project files, run tools, and chain operations. Porting them to another runtime is a project, not a config change. For now, AOS assumes Claude Code.

**"What does it cost?"**
AOS is free and open-source (dual license — Apache 2.0 for code, CC BY-SA 4.0 for prose). You pay for Claude Code (Anthropic's pricing). You pay for Arcanian's services only if you hire us. The software itself: zero.

---

## A last note

You are now one skill-run further along the AOS ladder than when you started this guide. You've seen what the system produces, what a skill is, and how a diagnostic is structured. You have enough context to decide whether AOS is worth deeper engagement.

If the answer is yes: read the manifesto, then the 7 Habits, then pick your next step from section 9.

If the answer is no: close the tab. AOS is not for everyone, and that is fine.

Either way — thank you for the hour.

---

*Getting started guide v1.0 — 2026. Published under CC BY-SA 4.0. © 2026 László Fazakas.*
