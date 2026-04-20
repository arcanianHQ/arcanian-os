---
scope: shared
type: readme — public AOS repository entry point
purpose: The first document someone reads when they arrive at the AOS repo cold. Explains what AOS is, who it is for, where to start, and how everything in the repo fits together.
license: CC BY-SA 4.0 (prose) / Apache 2.0 (code) — see governance/LICENSE.md
---

# AOS — Arcanian Operating System

> An open-source operating system for running an agency in the LLM era.
> *The methodology is free. Our time is priced.*

---

## What AOS is

AOS is the methodology, skill library, agent system, template set, and pattern library for running an agency as an operating system — not as a labor pool.

The core thesis: large language models did not make knowledge cheap. They made the *delivery* of knowledge cheap. Agencies that were selling hours as a proxy for expertise are being commoditised in real time. The agencies that compound are the ones that move from "we execute campaigns" to "we run a system that sees what a client cannot see."

AOS is that system, published openly.

---

## Who this is for

- **Agency owners** at shops of 3–50 people, feeling the pressure of AI commoditisation.
- **Senior practitioners** who run client engagements and want to operate at the layer above execution.
- **Operations leads** responsible for how the agency actually functions day-to-day.

If you are a solo consultant, a mid-market brand running marketing in-house, or an enterprise procurement team — AOS may still be useful, but the frame is shaped for agencies.

---

## Start here

Read in this order. Total reading time: about an hour.

1. **[The manifesto](MANIFESTO.md)** — the operating thesis in under 1,500 words.
2. **[The 7 Habits of a Successful Agency in the LLM / AI Era](7_HABITS.md)** — behavioural principles; the habits a practitioner enacts at every layer.
3. **[The Six Components of an Agency Operating System](SIX_COMPONENTS.md)** — structural map; what the operating system is made of.
4. **[The 7+1 Layer Framework](SEVEN_PLUS_ONE_LAYERS.md)** — the diagnostic map used to name where in a client's business a problem actually lives.
5. **[Glossary](GLOSSARY.md)** — every term in one place, when you need a definition while reading the rest.

Once you have read those, the rest of the repo makes sense.

---

## What's in the rest of the repo

- **`core/methodology/`** — frameworks, standards, methodology documents, and public-facing methodology reference.
- **`core/skills/`** — the curated skill pack. Each skill is a markdown prompt file that runs in Claude Code (see below). Public skills carry `scope: shared`; internal skills that Arcanian uses during paid engagements are not in the public repo.
- **`core/agents/`** — specialised AI agents with named expertise (channel analyst, measurement audit checker, report reviewer, and others).
- **`core/templates/`** — blank templates for the six owner-facing artifacts: One-Page Diagnosis, Agency Scorecard, Quarterly Commitments, Client Loop Tracker, Pattern Log, Accountability Map.
- **`demo-data/`** — demo-client fixtures (loopforge, mosstrail, solarnook) you can practice on before running AOS against your own clients.
- **`governance/`** — licensing, contributing guidelines, code of conduct, changelog.

---

## Runtime

AOS is designed to run on **Claude Code**, the command-line interface to Claude (from Anthropic). The skills, agents, and MCP configurations all assume Claude Code as the execution environment.

- You need Claude Code installed locally. See Anthropic's documentation.
- The **Model Context Protocol (MCP)** — Anthropic's open protocol — is how AOS connects to live client data (analytics platforms, CRMs, ad platforms). MCP configurations for common platforms are in `core/methodology/` where integration patterns are described.
- Anthropic, Claude, and Claude Code are trademarks of Anthropic PBC. See `governance/NOTICE.md`.

You can read the methodology documents without Claude Code. To actually run AOS — skills, agents, councils, MCP-connected diagnostics — you need Claude Code as the runtime.

---

## License

AOS is published under a **dual open-source license**:

- **Code, skills, agents, configs, and Claude-executable markdown** → **Apache License, Version 2.0** (`governance/LICENSE-CODE.md`)
- **Prose, methodology, teaching materials, and all other content** → **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)** (`governance/LICENSE-CONTENT.md`)

In plain language: you can fork, modify, use commercially, and build on top of AOS. Attribution to László Fazakas as the original author is required. Derivatives of the prose content must stay open under the same license (share-alike). Derivatives of the code can be closed.

See `governance/LICENSE.md` for the full dual-license explanation.

---

## Commercial stance

**AOS is free. Always.** There is no paid tier. There is no certificate. The methodology is entirely in this repo.

Arcanian Consulting Kft. makes money from **services around AOS**, not from the software:

- **Onboarding** — we install AOS properly in your agency (custom `CLAUDE.md`, team training, first diagnostic on a real client with consent).
- **Connecting** — we wire MCP to your client platforms (Databox, Semrush, ActiveCampaign, HubSpot, custom).
- **Custom development** — we build skills, agents, and SOPs shaped to your niche.
- **Advisory / retainer** (optional, pending launch) — ongoing help when platforms change, new patterns emerge, strategic questions land.

If you want to self-teach from this repo and run AOS without ever hiring Arcanian, that is a fully supported path and always will be.

If you want to hire Arcanian for any of the above: `hello@arcanian.ai`.

---

## Contributing

AOS is a practitioner movement. Patterns, skills, agents, and methodology contributions come from practitioners running the system on real work. See **[CONTRIBUTING](governance/CONTRIBUTING.md)** for:

- How to sign a pattern with your name, the lens you observed through, and what would strengthen it
- The inbound=outbound license convention (no CLA required)
- The peer-review process and how patterns get promoted to the cross-agency pattern library
- What we will and will not merge

**Code of conduct:** see **[CODE_OF_CONDUCT](governance/CODE_OF_CONDUCT.md)**. The code is the manifesto's practices applied to the community — show your work, present findings clearly, close loops, write in accord with the machine, carry lessons through people, count on the people in the room, sharpen the instrument.

---

## A note on what this repo does not contain

AOS is Arcanian's own methodology. This repo publishes only content Arcanian authored (or to which rights permit open publication).

What is **not** in this repo, and never will be:
- Copyrighted methodologies by other authors that Arcanian practitioners have studied and apply during paid engagements
- Internal Arcanian skills, agents, and methodology that live in `scope: int-*` files in the source repository
- Client-specific patterns, diagnoses, or deliverables
- Any content that would infringe a third party's copyright or trademark

If you want capabilities AOS's public content doesn't cover, the available paths are: build it yourself, hire Arcanian, or license directly from the methodology's owner.

---

## Project home + contact

- **Repo:** [https://github.com/arcanianHQ/arcanian-os-shared](https://github.com/arcanianHQ/arcanian-os-shared)
- **Website:** [https://arcanian.ai](https://arcanian.ai)
- **Contact:** hello@arcanian.ai
- **Author:** László Fazakas, founder of Arcanian Consulting Kft. (Budapest, Hungary)

---

## If this is how you already think

Come build.

---

*AOS v1.0 — published 2026. Apache 2.0 + CC BY-SA 4.0. © 2026 László Fazakas.*
