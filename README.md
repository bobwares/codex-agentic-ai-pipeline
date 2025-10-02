# Codex Agentic AI Pipeline


A structured framework for AI-driven code generation that orchestrates multi-turn development workflows using configurable patterns, tools, and governance policies.


## Overview

The **Codex Agentic AI Pipeline** provides infrastructure for running **trustworthy, auditable, and reproducible AI-assisted development workflows** inside the **ChatGPT Codex environment**.

Unlike one-off code snippets, tasks are executed as structured, traceable **turns**. Each turn produces required artifacts, is governed by explicit rules, and integrates with Git/CI. This elevates AI coding into a **professional-grade pipeline**.

---

## Key Features

### Agentic Workflow

* **Turn-based execution**: A **turn** = one atomic unit of work (plan, generate, refactor, test).
* **Artifacts per turn**:

    * `manifest.json` – authoritative index of task metadata, inputs, outputs, and validations
    * `changelog.md` – human-readable description of changes
    * `adr.md` – Architecture Decision Record for non-trivial choices
* **Git integration**: Each turn results in a commit, tag, and optional PR. CI enforces artifact presence and schema compliance.

### Codex Integration

* **AGENTS.md is the entrypoint**: Codex looks for this file at repository root to initialize the environment. It defines:

    * Container context and session context
    * Paths for project context, governance, and task patterns
    * Instructions for executing the task pipeline
* **Session Context**: Tracks globals like project name, implementation pattern, and turn ID.
* **Patterns**: Define implementation blueprints (e.g., AWS Serverless TypeScript, Full-Stack Next.js + NestJS).

### Governance & Standards

* **Governance.md** enforces coding discipline:

    * Required metadata headers in every file
    * Semantic versioning and change logs
    * ADR creation rules
    * Git workflow conventions (branches, commits, PR templates)
* **Turns_Technical_Design.md** defines lifecycle and CI rules:

    * Plan → Execute → Record → Commit & Tag
    * Required validations (lint, test, ADR, changelog)
    * Indexed turn registry (`turns/index.csv`)

---

## How It Works in ChatGPT Codex

1. **Initialize Sandbox**

    * Launch a Codex environment from the ChatGPT interface.
    * Codex detects `AGENTS.md` and loads contexts, governance, and patterns.

2. **Project Context & Pattern**

    * `project_context.md` provides application details (name, domain, schemas).
    * A selected pattern (e.g., `aws-serverless-typescript`) defines available tasks and standards.

3. **Run a Turn**

    * Human issues a task in the Codex chat (e.g., “Generate unit tests”).
    * Codex increments `turn_id`, scaffolds `/turns/<id>/`, and runs the pipeline.
    * Required artifacts are written (`manifest.json`, `changelog.md`, `adr.md`).

4. **Git + CI/CD Integration**

    * Commit message and tag (`turn/<id>`) are created.
    * CI enforces artifact validity and test gates before merge.

---

## Enhancing Code Generation

Traditional LLM-assisted coding = **raw snippets**.
Codex Agentic AI Pipeline = **structured workflow** with:

* **Context grounding** – Uses AGENTS.md, governance, and project context to align output with architecture.
* **Auditability** – Every action leaves behind artifacts and ADRs.
* **Reproducibility** – Each turn can be replayed deterministically.
* **Collaboration** – AI output enters the same Git/PR/CI cycle as human developers.
* **Governance** – Metadata headers, semantic versioning, and change logs enforce professional discipline.

---

## Quick Start

1. **Create a target project** using the template:
   [Agentic AI Pipeline Target Project Template](https://github.com/bobwares/agentic-ai-pipeline-target-project-template)

2. **Define project context**

    * Update `project_context.md` with project name, architecture pattern, and domain model.

3. **Launch Codex**

    * Open a Codex sandbox.
    * Codex loads `AGENTS.md` to initialize session, governance, and tasks.

4. **Run tasks**

    * Submit tasks via Codex turns.
    * Review generated code, ADRs, and PRs.

---

## Example Workflow

**Task**: “Generate Terraform infrastructure for the ShoppingCart domain.”
**Turn Outputs**:

* `iac/*.tf` – Terraform definitions
* `manifest.json` – turn metadata, hashes, metrics
* `changelog.md` – description of created infra code
* `adr.md` – rationale for resource design
* Git commit + PR for review

---

## Why This Matters

The Codex Agentic AI Pipeline transforms AI codegen into a **professional, enterprise-ready workflow**:

* Transparent and auditable
* Integrated into GitHub & CI/CD
* Enforcing governance and coding standards
* Enabling **AI–human collaboration** at the level of real-world software teams

