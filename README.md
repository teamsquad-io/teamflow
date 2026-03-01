# TeamFlow

A Claude Code plugin for spec-driven development. Every feature follows a structured lifecycle: specification, planning, implementation, review, and production -- with all state on disk as Markdown and YAML.

<!-- token-count -->
**13.9k tokens** - 7% of context window
<!-- /token-count -->

## What It Does

TeamFlow gives Claude Code a structured workflow so that no feature gets built without a clear spec, no code ships without review, and no decision gets lost between sessions.

- **Spec-driven**: Define WHAT and WHY before writing any code.
- **Multi-component**: Works for single-repo apps and multi-component platforms alike.
- **Disk-first**: All state lives in `.workflow/` as human-readable files. No databases, no servers.
- **Adversarial review**: Code review is done by a separate agent that does not trust the implementer.
- **Session continuity**: Pick up exactly where you left off. State survives across sessions.

## Installation

```
/plugin marketplace add zeroToOneProjects/teamflow
/plugin install teamflow
```

## Quick Start

1. **Initialize** a new project:
   ```
   /init
   ```
   TeamFlow will ask about your project and create the `.workflow/` directory.

2. **Define** what to build:
   ```
   /spec
   ```

3. **Plan** how to build it:
   ```
   /plan
   ```

4. **Break it down** into tasks:
   ```
   /tasks
   ```

5. **Implement** task by task:
   ```
   /work
   ```

6. **Review** the implementation:
   ```
   /review
   ```

7. **Ship it** and update project knowledge:
   ```
   /done
   ```

## Commands

| Command | Description |
|---------|-------------|
| `/init` | Initialize TeamFlow in a project. Creates `.workflow/` structure. |
| `/spec` | Create or edit a feature specification (WHAT and WHY, no tech). |
| `/plan` | Generate a technical plan from an approved spec. |
| `/tasks` | Break a plan into atomic, dependency-ordered tasks. |
| `/work` | Implement the next available task with full context. |
| `/review` | Adversarial code review against the original spec. |
| `/done` | Mark a feature as production-ready. Archive and extract knowledge. |
| `/status` | See current project state, active features, and next actions. |
| `/resume` | Restore full context from a previous session. |
| `/quick` | Fast path for bug fixes and small changes. No spec required. |
| `/create-skill` | Create a new skill from a guideline or description. |

## Philosophy

**Spec-driven development.** The spec is the source of truth. Code conforms to the spec, not the other way around. No code without an approved spec (except `/quick` for fixes).

**Adversarial review.** The reviewer receives explicit instructions not to trust the implementer's report. This framing counteracts confirmation bias and produces better reviews.

**Platform knowledge extraction.** When a feature ships, permanent knowledge (architecture decisions, domain patterns, component conventions) is extracted and merged into platform specs. Feature specs are temporary; platform specs are the holy grail.

## Project Structure

When initialized, TeamFlow creates this in your project:

```
.workflow/
  state.md              # Current project state (~100 lines)
  constitution.md       # Project principles (optional)
  components.yaml       # Component registry (single or multi)
  specs/                # Feature specs (numbered: 001, 002, ...)
    001-feature-name/
      spec.md           # WHAT and WHY
      plan.md           # HOW
      tasks.md          # Atomic task breakdown
      state.yaml        # Feature lifecycle state
      review.md         # Review results
    _archive/           # Completed specs
  platform/             # Permanent project knowledge
    architecture.md
    decisions.md
    domains/
    components/
```

## Context Cost

Installing this plugin adds **~13.1k tokens** to your context window (7% of 200k).

| Component | Files | Tokens |
|-----------|------:|-------:|
| skills | 11 | 6,296 |
| agents | 4 | 3,340 |
| templates | 7 | 1,737 |
| commands | 11 | 853 |
| hooks | 4 | 789 |
| CLAUDE.md | 1 | 83 |
| **Total** | **38** | **13,098** |

Measured with [tiktoken](https://github.com/openai/tiktoken) (`cl100k_base`). Updated automatically via CI.

## Requirements

- [Claude Code](https://claude.ai/code)

## License

MIT
