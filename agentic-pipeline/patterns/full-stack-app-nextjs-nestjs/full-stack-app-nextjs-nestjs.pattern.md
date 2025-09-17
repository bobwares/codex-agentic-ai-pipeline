# Project Level AI Coding Agent Context

This document provides guidelines for AI coding agents (e.g., Codex, Copilot, LangChain) to generate high-quality code project.

These instructions ensure consistency, adherence to project conventions, and efficient code generation.

Generate maintainable, type-safe, and modular code that aligns with the existing structure and conventions.

| Item                  | Value                                                             |
| --------------------- |-------------------------------------------------------------------|
| **GitHub repository** | https://github.com/bobwares/full-stack-app-nextjs-nestjs-baseline |
| **Application name**  | Baseline Full-Stack Application                                   |
| **Author**            | Bobwares CodeBot                                                  |

**Directory summary**

| Path       | Purpose                                                       |
| ---------- | ------------------------------------------------------------- |
| `ui/`      | Next.js front-end (server-rendered React + client navigation) |
| `api/`     | NestJS back-end (TypeScript REST APIs)                        |
| `db/`      | PostgreSQL migrations and seed scripts                        |
| `schemas/` | JSON schemas shared between UI and API                        |

---

## Versioning Rules

* Use **semantic versioning** (`MAJOR.MINOR.PATCH`).
* Track changes each "AI turn" in the file `project_root/version.md`.
* Start at **0.1.0**; update only when code or configuration changes.
* Record just the sections that changed.

```markdown
# Version History

### 0.0.1 – 2025-06-08 06:58:24 UTC (main)

#### Task 
<Task>

#### Changes

- Initial project structure and configuration.

### 0.0.2 – 2025-06-08 07:23:08 UTC (work)

#### Task 
<Task>

#### Changes
- Add tsconfig for ui and api
- Create src directories with unit-test folders
- Add e2e test directory for Playwright
```

---

## Git Workflow Conventions

### 1. Branch Naming

```
<type>/<short-description>-<Task-id?>
```

| Type       | Purpose                                | Example                           |
| ---------- | -------------------------------------- | --------------------------------- |
| `feat`     | New feature                            | `feat/profile-photo-upload-T1234` |
| `fix`      | Bug fix                                | `fix/login-csrf-T5678`            |
| `chore`    | Tooling, build, or dependency updates  | `chore/update-eslint-T0021`       |
| `docs`     | Documentation only                     | `docs/api-error-codes-T0099`      |
| `refactor` | Internal change w/out behaviour change | `refactor/db-repository-T0456`    |
| `test`     | Adding or improving tests              | `test/profile-service-T0789`      |
| `perf`     | Performance improvement                | `perf/query-caching-T0987`        |

**Rules**

1. One branch per Task or atomic change.
2. **Never** commit directly to `main` or `develop`.
3. Re-base on the target branch before opening a pull request.

---

### 2. Commit Messages (Conventional Commits)

```
AI Coding Agent Change:
<type>(<optional-scope>): <short imperative summary>
<BLANK LINE>
Optional multi-line body (wrap at 72 chars).
<BLANK LINE>
Refs: <Task-id(s)>
```

Example:

```
feature(profile-ui): add in-place address editing

Allows users to update their address directly on the Profile Overview
card without navigating away. Uses optimistic UI and server-side
validation.

Refs: T1234
```
---

### 3. Pull-Request Summary Template

Copy this template into every PR description and fill in each placeholder.

```markdown
# Summary
<!-- One-sentence description of the change. -->

# Details
* **What was added/changed?**
* **Why was it needed?**
* **How was it implemented?** (key design points)

# Related Tasks
- T1234 Profile Overview – In-place editing
- T1300 Validation Rules

# Checklist
- [ ] Unit tests pass 
- [ ] Integration tests pass
- [ ] Linter passes
- [ ] Documentation updated

# Breaking Changes
<!-- List backward-incompatible changes, or “None” -->

# Codex Task Link

```


## ADR (Architecture Decision Record) Folder

### Purpose

The `/adr` folder captures **concise, high-signal Architecture Decision Records** whenever the AI coding agent (or a human) makes a non-obvious technical or architectural choice. Storing ADRs keeps the project’s architectural rationale transparent and allows reviewers to understand **why** a particular path was taken without trawling through commit history or code comments.

### Location

```
project_root/adr/
```

### When the Agent Must Create an ADR

| Scenario                                                     | Example                                                        | Required? |
|--------------------------------------------------------------|----------------------------------------------------------------|-----------|
| Selecting one library or pattern over plausible alternatives | Choosing Prisma instead of TypeORM                             | **Yes**   |
| Introducing a new directory or module layout                 | Splitting `customer` domain into bounded contexts              | **Yes**   |
| Changing a cross-cutting concern                             | Switching error-handling strategy to functional `Result` types | **Yes**   |
| Cosmetic or trivial change                                   | Renaming a variable                                            | **Yes**   |

### Naming Convention

```
adr/YYYYMMDDnnn_<slugified-title>.md
```

* `YYYYMMDD` – calendar date in UTC
* `nnn` – zero-padded sequence number for that day
* `slugified-title` – short, lowercase, hyphen-separated summary

Example: `adr/20250611_001_use-prisma-for-orm.md`.

### Minimal ADR Template

```markdown
# {{ADR Title}}

**Status**: Proposed | Accepted | Deprecated  

**Date**: {{YYYY-MM-DD}}  

**Context**  
Briefly explain the problem or decision context.  

**Decision**  
State the choice that was made.  

**Consequences**  
List the trade-offs and implications (positive and negative).  
```

### Agent Workflow

1. Before implementing a change that meets the criteria above, the agent must:
    * Evaluate alternatives and decide.
    * Generate a new ADR file using the template.
2. Commit the ADR **in the same pull request** as the code change so reviewers can assess both simultaneously.
3. If a later change supersedes an ADR, create a new ADR that references and deprecates the original.

### Human Review

* Reviewers should treat ADRs as first-class documentation and request clarifications when the **Context** or **Consequences** sections are vague.
* Once accepted, ADRs are **never edited**, only superseded, to preserve historical context.


### Automated Task-Run Logs

After every Codex turn save the reasoning thoughts to the file project_root/reasoning.md


---
# Tasks

tasks are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/{{selected pattern}}/tasks

# Tools

tools are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/{{selected pattern}}/tools

# Agentic Pipeline Flow

execute tasks

1. TASK 01 - Create DB from Schema.md

