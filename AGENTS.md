# AGENTS.md

## Container Context

Act as an **Agentic Coding Agent**.

This file is split into two phases:

1. **Bootstrap (absolute paths only)** — load the Session Context *before* any variables exist.
2. **Execution (resolved variables)** — after loading, use the Session Context variables for everything else.

---

## 1) Bootstrap (load Session Context first)

Until the Session Context is loaded, **no `${...}` variables are defined**.
Use the absolute, sandbox-stable path to load it:

* Read:
  `/workspace/agentic-ai-pipeline/agentic-pipeline/context/session_context.md`

This initializes and exports the following variables (examples):
`SANDBOX_BASE_DIRECTORY`, `AGENTIC_PIPELINE_PROJECT`, `TARGET_PROJECT`, `PROJECT_CONTEXT`,
`ACTIVE_PATTERN_NAME`, `ACTIVE_PATTERN_PATH`, `TURN_ID`, `CURRENT_TURN_DIRECTORY`, and all **TEMPLATE_*** paths.

> After this step, you may safely reference `${...}` variables below.

---

## 2) Execution (use resolved Session Context variables)

### Session Context (for reference)

* `${SESSION_CONTEXT}` (the same file read during Bootstrap)

**Environment**

* `${SANDBOX_BASE_DIRECTORY}` – sandbox root (e.g., `/workspace`)
* `${AGENTIC_PIPELINE_PROJECT}` – read-only pipeline framework (resolved after bootstrap)

**Project**

* `${TARGET_PROJECT}` – writable project workspace
* `${PROJECT_CONTEXT}` – project configuration/context (e.g., `.../ai/context/project_context.md`)

**Patterns**

* `${ACTIVE_PATTERN_NAME}` – pattern name or relative path (Markdown)
* `${ACTIVE_PATTERN_PATH}` – absolute path to the resolved pattern directory/file

**Turn**

* `${TURN_ID}` – current turn number
* `${CURRENT_TURN_DIRECTORY}` – per-turn artifacts directory

**Templates**

* `${TEMPLATES}` – templates root
* `${TEMPLATE_METADATA_HEADER}`
* `${TEMPLATE_BRANCH_NAMING}`
* `${TEMPLATE_COMMIT_MESSAGE}`
* `${TEMPLATE_PULL_REQUEST}`
* `${TEMPLATE_ADR}`
* `${TEMPLATE_CHANGELOG}` (`changelog.md`)
* `${TEMPLATE_MANIFEST_SCHEMA}`

---

## Turn Lifecycle

Read:
`${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Turns_Technical_Design.md`

Stages:

1. **Initialize** – confirm variables, paths, and write boundaries.
2. **Assemble Contexts** – load governance, agents, and patterns.
3. **Execute Tasks** – run generation steps via assigned agents and tools.
4. **Validate** – enforce governance and pattern validation rules.
5. **Record Artifacts** – changelog, ADR, manifest, PR body.
6. **Submit** – create PR.
7. **End Turn** – update index and persist results.

---

## Project Context

Read:
`${PROJECT_CONTEXT}`

Defines project-level metadata, environment bindings, and the active pattern reference.

---

## Pattern Context

Read:
`${ACTIVE_PATTERN_PATH}/pattern_context.md`

Also read:
`${ACTIVE_PATTERN_PATH}/tasks/tasks-pipeline.md`

The `tasks-pipeline.md` file defines the ordered list of tasks to execute for each turn.
Tasks are located in:
`${ACTIVE_PATTERN_PATH}/tasks/`

For each `turn ${TURN_ID}` block in `tasks-pipeline.md`:

* Execute any line starting with `agent run ...` as a direct agent command.
* Execute any line starting with `TASK ... .task.md` by opening and processing the corresponding file under `/tasks/`.
* Resolve any `session context:` references in arguments using `${PROJECT_CONTEXT}` before execution.

---

## Application Implementation Pattern

Read all pattern files:
`${ACTIVE_PATTERN_PATH}/**`

These Markdown files define the tasks, agents, inputs/outputs, validations, and composition rules used to assemble the application.

---

## Governance

Read:
`${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Governance.md`

Enforce:

* File metadata headers
* Versioning rules
* Branch naming and commit message conventions
* Pull-request structure and checks

---

## Coding Agents

Read:
`${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Coding_Agents.md`

Describes roles, tools, and constraints for each agent used in tasks.

---

## Templates

| Template            | Description                                                       | Path                          |
| ------------------- | ----------------------------------------------------------------- | ----------------------------- |
| **Metadata Header** | Source file header inserted at top of generated files.            | `${TEMPLATE_METADATA_HEADER}` |
| **Branch Naming**   | Git branch naming conventions.                                    | `${TEMPLATE_BRANCH_NAMING}`   |
| **Commit Message**  | Commit message convention for agent commits.                      | `${TEMPLATE_COMMIT_MESSAGE}`  |
| **Pull Request**    | PR body and validation checklist; agent injects the turn summary. | `${TEMPLATE_PULL_REQUEST}`    |
| **ADR**             | Architectural Decision Record template.                           | `${TEMPLATE_ADR}`             |
| **Turn Changelog**  | Turn-level change summary (`changelog.md`).                       | `${TEMPLATE_CHANGELOG}`       |
| **Manifest Schema** | JSON schema for `manifest.json`.                                  | `${TEMPLATE_MANIFEST_SCHEMA}` |

---

## Turn Artifacts

Write all outputs for this turn into:
`${CURRENT_TURN_DIRECTORY}`

Artifacts:

* `changelog.md`
* `adr.md`
* `manifest.json`
* `pull_request_body.md` (rendered from `${TEMPLATE_PULL_REQUEST}`)

---

## Task Execution Flow

1. **Initialize Environment**

   * Use the already-loaded Session Context variables.
   * Confirm `${AGENTIC_PIPELINE_PROJECT}` is read-only; write-only inside `${TARGET_PROJECT}`.

2. **Load Contexts**

   * Read Governance, Turn Lifecycle, Coding Agents, Project Context.
   * Resolve `${ACTIVE_PATTERN_NAME}` and `${ACTIVE_PATTERN_PATH}`.

3. **Assemble Pattern**

   * Parse `${ACTIVE_PATTERN_PATH}/pattern_context.md` and `${ACTIVE_PATTERN_PATH}/tasks/tasks-pipeline.md`.
   * Build an ordered list of tasks from the current `turn ${TURN_ID}` block.
   * Load and execute corresponding `.task.md` files or agent commands as defined.

4. **Execute Tasks**

   * For each task, run the designated agent and tools.
   * Use templates, read inputs from `${TARGET_PROJECT}` and `${AGENTIC_PIPELINE_PROJECT}`,
     and write outputs only to `${TARGET_PROJECT}` (recording under `${CURRENT_TURN_DIRECTORY}`).

5. **Validate & Record**

   * Enforce governance validations.
   * Generate `manifest.json` validated against `${TEMPLATE_MANIFEST_SCHEMA}`.
   * Render `changelog.md` and `adr.md` from templates.

6. **Prepare Pull Request**

   * Extract the “High-level outcome” from `changelog.md`.
   * Render PR body with `${TEMPLATE_PULL_REQUEST}` and set title:
     `Turn ${TURN_ID} – ${DATE} – ${TIME_OF_EXECUTION}`.

7. **Finalize Turn**

   * Append a row to `.../ai/agentic-pipeline/turns_index.csv`.
   * Keep all artifacts in `${CURRENT_TURN_DIRECTORY}` for auditability.

---

**Rule of thumb:**
Only the **Bootstrap** step uses absolute paths. Everything after relies on the resolved Session Context variables.

