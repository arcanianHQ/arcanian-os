---
scope: shared
---

# ArcFlux - Inspired By

This document tracks all projects, methodologies, and frameworks that inspired ArcFlux's design and features.

---

## Primary Inspirations

### Dovetail by Lumberjack
**GitHub:** https://github.com/lumberjack-so
**Blog:** https://lumberjack.so/building-in-public-1/#dovetail-making-me-a-better-engineer-without-being-one

An AI-native development workflow system that pioneered the integration of Claude Code hooks with issue tracking systems.

**Key concepts borrowed:**
- Claude Code hooks integration (user-prompt-submit, pre-tool-use, post-tool-use)
- CLI delegation pattern (using native CLIs like `gh`, `linearis` instead of API wrappers)
- Issue-driven workflow management
- Session state management
- Agent coordination hooks

**Files influenced:**
- `.claude-hooks/` directory structure
- CLI wrapper pattern in `src/cli/`
- State management in `src/utils/state.js`

---

### Jig Framework & ICAO Model
**Concept:** Database-backed workflow orchestration with intelligence-agnostic execution

The ICAO Framework (Intent, Context, Action, Output) provides a universal structure for describing any operation:

**The Assembly Line Insight:**
> "Henry Ford discovered his workers were pedestrians 40% of the time. In knowledge work, we don't have pedestrians—we have context switching. The cognitive assembly line flips it: context comes to you, not the other way around."

**ICAO Components:**
- **Intent**: What you want to achieve and why
- **Context**: What you need to know to do it
- **Action**: The specific thing you do
- **Output**: How you know it's done

**Key concepts borrowed:**
- Fractal structure (task → workflow → business unit)
- Durable execution (if step 3 fails, fix and continue)
- Intelligence-agnostic execution (human, Claude, GPT—doesn't matter)
- Context compression and expansion
- Execution logging with token/cost tracking

**Files influenced:**
- Issue template structure (ICAO format)
- `.arcflux/execution/` logging system (AF-041)
- Context package generation
- Resumable workflow state

---

### SPARC Methodology by ruvnet
**GitHub:** https://github.com/ruvnet/sparc

A structured AI development methodology focusing on systematic progression through development phases.

**SPARC Phases:**
1. **S**pecification - Define requirements clearly
2. **P**seudocode - Plan logic before implementation
3. **A**rchitecture - Design system structure
4. **R**efinement - Iterate and improve
5. **C**ompletion - Finalize and verify

**Key concepts borrowed:**
- Phase-based development workflow
- Quality gates between phases
- Structured documentation requirements
- TDD London School approach
- Validation checkpoints

**Files influenced:**
- Phase tracking in issue templates
- Validation gates system (AF-035)
- Quality standards enforcement
- Progress dashboard design (AF-032)

---

### Claude-Flow by ruvnet
**GitHub:** https://github.com/ruvnet/claude-flow

An orchestration framework for Claude-based multi-agent systems.

**Key concepts borrowed:**
- Agent coordination patterns
- Parallel work tracking
- Workflow visualization
- State persistence across sessions

**Files influenced:**
- Parallel work tracking (AF-039)
- Workflow visualization (AF-038)
- Orchestrator script design (AF-040)

---

---

### Claude Code Official Plugins
**GitHub:** https://github.com/anthropics/claude-code/tree/main/plugins

Official plugins that extend Claude Code functionality through commands, agents, skills, and hooks.

**Plugins adopted:**

#### feature-dev
7-phase structured feature development workflow with specialized agents.

**Phases adopted for ArcFlux workflow:**
1. Explore - Understand codebase and requirements
2. Plan - Define scope and approach
3. Architect - Design solution structure
4. Implement - Write the code
5. Review - Quality and correctness check
6. Test - Verify functionality
7. Document - Update docs and complete

**Agents adopted:**
- `code-explorer` - Codebase analysis
- `code-architect` - Architecture design
- `code-reviewer` - Quality review

#### code-review
Multi-agent PR review with confidence-based scoring using 5 parallel Sonnet agents.

**Agent pattern adopted:**
- CLAUDE.md compliance checker
- Bug detector
- Historical context analyzer
- PR history reviewer
- Code commenter

#### hookify
Create custom hooks to prevent unwanted behaviors by analyzing conversation patterns.

**Used for:**
- Chrome DevTools MCP harness (AF-042)
- Behavior control rules
- Session safeguards

#### security-guidance
Pre-tool-use hook monitoring security patterns.

**Patterns monitored:**
- Command injection
- XSS vulnerabilities
- Dangerous eval usage
- Pickle deserialization
- os.system calls

#### commit-commands
Git workflow automation with `/commit`, `/commit-push-pr`, `/clean_gone`.

**Used for:**
- AF-010: Commit command design
- Streamlined git operations

#### frontend-design
**GitHub:** https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design
**Authors:** Prithvi Rajasekaran, Alexander Bricken (Anthropic)

Creates distinctive, production-grade frontend interfaces with high design quality. Avoids generic "AI slop" aesthetics.

**Key concepts adopted:**
- Skill-based design system loading
- Bold aesthetic direction choices (brutalist, luxury, minimal, etc.)
- Typography: distinctive fonts, NOT Arial/Inter/system fonts
- Color: dominant colors with sharp accents
- Motion: CSS animations, staggered reveals, scroll-triggering
- Spatial composition: asymmetry, overlap, grid-breaking

**Used for:**
- `skills/frontend-design/SKILL.md` - Direct adoption
- `skills/frontend-*` naming convention
- Issue type/style workflow integration
- AF-047: Brand Book Skill (customization)

**Naming convention established:**
```
skills/frontend-{style}/SKILL.md
```

Where `{style}` is: `design`, `brand-book`, `brutalist`, `luxury`, `minimal`, `playful`

---

## Secondary Inspirations

### plastic-card-designer (Internal Project)
**Source:** Local project analysis

An internal project that demonstrated effective orchestration patterns for Claude-based development.

**Key concepts borrowed:**
- Orchestrator shell script pattern
- Progress tracker with visual status
- Issue dependency management
- Risk register format
- Activity logging
- Parallel execution strategies
- Critical path identification

**Features inspired:**
- AF-032: Progress Dashboard
- AF-033: Visual Status System
- AF-034: Smart Status Detection
- AF-035: Validation Gates
- AF-036: Activity Logging
- AF-037: Risk Register
- AF-038: Workflow Visualization
- AF-039: Parallel Work Tracking
- AF-040: Orchestrator Script

---

## Technology References

### Amazee.io Lagoon
**Website:** https://www.amazee.io/
**GitHub:** https://github.com/uselagoon
**Docker Images:** https://hub.docker.com/u/uselagoon

Container orchestration platform for Drupal deployments.

**Influence:**
- Container specifications in `stacks/docker.md`
- Lagoon-compatible image selections
- Deployment workflow design

---

### Commander.js
**GitHub:** https://github.com/tj/commander.js

Node.js CLI framework.

**Influence:**
- CLI structure and command registration
- Option parsing patterns
- Help generation

---

### Chalk
**GitHub:** https://github.com/chalk/chalk

Terminal string styling.

**Influence:**
- Visual status system colors
- Terminal output formatting
- Progress indicators

---

## Design Philosophy

ArcFlux combines these inspirations with the following principles:

1. **Issue-Driven Development** (from Dovetail)
   - Every change tied to a tracked issue
   - Clear acceptance criteria
   - Dependency awareness

2. **Phased Progression** (from SPARC)
   - Structured workflow phases
   - Quality gates between phases
   - Documentation at each stage

3. **Visual Feedback** (from plastic-card-designer)
   - Real-time status visualization
   - Progress tracking
   - Clear next-step guidance

4. **Crash Recovery** (original)
   - Memory bank persistence
   - Session recovery commands
   - Context restoration

5. **Stack-Specific Knowledge** (original)
   - Technology-specific best practices
   - Version compatibility matrices
   - Container specifications

---

## Contributing Inspirations

If you find a project, methodology, or pattern that could improve ArcFlux, please:

1. Create an issue documenting the inspiration
2. Link to the source (GitHub, documentation, etc.)
3. Describe which aspects could be adopted
4. Propose specific features or improvements

---

## Acknowledgments

Special thanks to:
- The Lumberjack team for Dovetail's innovative Claude Code integration
- ruvnet for the SPARC methodology and Claude-Flow orchestration patterns
- Amazee.io for Lagoon and container standards
- The Claude Code team at Anthropic for enabling AI-native development workflows

---

*Last updated: 2026-01-09*
