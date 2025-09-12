# ChatGPT Codex Agentic Pipeline

## Overview

This repository defines an **agentic pipeline** for the ChatGPT Codex environment.
The pipeline enables iterative, tool-driven software generation where each execution is called a **turn**.

Key features:

* Structured orchestration via `AGENTS.md`
* Tool and task separation for modularity
* Persistent turn history with logs, inputs, outputs, and artifacts
* Metadata headers and versioning standards across all generated files
* Automated changelogs and Architecture Decision Records (ADRs)

---

## Concepts

### Turns

* A **turn** represents one execution of a Codex task.
* Each turn has a unique **Turn ID** (integer, incremented by 1 for each new turn).
* Turns create artifacts including:

    * **Changelog** entries
    * **Architecture Decision Records (ADR)**
    * Input and output directories for reproducibility

### Tasks

* A **task** is a prompt or workflow unit that Codex executes.
* Tasks are defined in `/tasks/` using Markdown (`*.prompt.md`), YAML, or JSON schemas.
* Tasks are modular and reusable, allowing flexible orchestration.

### Tools

* **Tools** encapsulate reusable operations that tasks can call.
* Examples:

    * SQL DDL generator
    * Test data generator
    * E2E HTTP test generator
    * OpenAPI annotator

### Orchestration (`AGENTS.md`)

* The **Codex agent** is configured in `AGENTS.md`.
* Defines how tools are chained together and how Codex interprets user requests.
* Enforces metadata headers and versioning for all generated files.

---

## Repository Layout

```
project root/AGENTS.md
project root/ai/tasks/
  person-crud-tool.prompt.md
  task.schema.json
  task.person-crud.yaml
project root/ai/tools/
  sql-ddl.prompt.md
  test-data.prompt.md
  e2e-http.prompt.md
  openapi-annotate.prompt.md
project root/ai/turns/
  index.csv
  2025-09-05T183000Z_turn-004/
    inputs/
    outputs/
    logs/
    artifacts/
agentic/
  context.schema.json
  tool.schema.json
  pipeline.config.yaml

```

---

## Metadata Standards

All source code, config, and prompt files must include a **metadata header**:

```
# App: {application-name}
# Package: {package-name}
# File: {file-name}
# Version: {semantic-version}
# Author: {author}
# Date: {ISO-8601 timestamp}
# Exports: {main classes, functions, or artifacts}
# Description: {purpose of this file}
```

---

## Workflow

1. **Start a Turn**

    * Increment Turn ID in `/turns/index.csv`.
    * Create a new turn directory (`/turns/{timestamp}_turn-{id}`).

2. **Execute a Task**

    * Run the chosen task through Codex.
    * Codex selects tools as needed.

3. **Generate Outputs**

    * Store results in `outputs/`.
    * Capture logs in `logs/`.

4. **Record Artifacts**

    * Store generated code, schemas, or configs in `artifacts/`.
    * Write/update ADR and changelog.



---

## Example Pipeline Flow

1. User requests a new CRUD module.
2. Codex executes the **CRUD task** → uses:

    * `sql-ddl.prompt.md` (generate SQL DDL)
    * `test-data.prompt.md` (generate test cases)
    * `e2e-http.prompt.md` (generate HTTP tests)
3. Outputs and artifacts stored under the active turn.
4. Changelog updated with the new feature.
5. ADR written to document design decisions.

---

## Goals

* Ensure reproducibility of every Codex execution
* Enforce standards for metadata and versioning
* Provide traceability via changelogs and ADRs
* Build modular, extensible pipelines that grow with project complexity
