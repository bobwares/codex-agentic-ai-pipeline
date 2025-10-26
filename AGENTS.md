Got it. Here’s your **AGENTS.md** with **minimal, targeted changes** to *guarantee* turn artifacts are created every run. I kept your structure and wording; I only strengthened the **Turn Artifacts** section and the **Task Execution Flow** with explicit, non-optional creation steps and failure policies.

---

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

**Artifact Creation Contract (non-optional):**

On every turn, the agent **must**:

1. **Create the turn directory**

   * `mkdir -p ${CURRENT_TURN_DIRECTORY}`

2. **Emit a manifest (even on failure)**

   * Write `${CURRENT_TURN_DIRECTORY}/manifest.json`
   * Must validate against `${TEMPLATE_MANIFEST_SCHEMA}`
   * Include: `turnId`, task entries (even if empty), provenance (`activePatternName`, `activePatternPath`, timestamps), and an overall `status` field (`success|failed`).

3. **Emit a changelog**

   * Render `${CURRENT_TURN_DIRECTORY}/changelog.md` from `${TEMPLATE_CHANGELOG}`
   * Must include sections for **High-level outcome**, **Files Added**, **Files Updated**, and **Turn Files Added**.

4. **Emit an ADR**

   * Render `${CURRENT_TURN_DIRECTORY}/adr.md` from `${TEMPLATE_ADR}`
   * Must reference `ACTIVE_PATTERN_NAME` and `ACTIVE_PATTERN_PATH`.

5. **Emit a PR body**

   * Render `${CURRENT_TURN_DIRECTORY}/pull_request_body.md` from `${TEMPLATE_PULL_REQUEST}`
   * Inject the “High-level outcome” extracted from `changelog.md` into the `<!-- CODEx_TURN_SUMMARY -->` block.

6. **Update the index**

   * Append a CSV row to `${TARGET_PROJECT}/ai/agentic-pipeline/turns_index.csv`
   * Create the file with header if it does not exist.

> If any template or directory is missing, **fail fast** and still write `manifest.json` with `status: "failed"` and a diagnostic entry.

---

## Task Execution Flow

1. **Initialize Environment**

   * Use the already-loaded Session Context variables.
   * Confirm `${AGENTIC_PIPELINE_PROJECT}` is read-only; write-only inside `${TARGET_PROJECT}`.
   * **Create `${CURRENT_TURN_DIRECTORY}` now** (see Artifact Creation Contract §1).
   * **Pre-seed empty artifacts** if desired (optional): write skeleton `changelog.md`, `adr.md`, and a minimal `manifest.json` with `status: "in-progress"`.

2. **Load Contexts**

   * Read Governance, Turn Lifecycle, Coding Agents, Project Context.
   * Resolve `${ACTIVE_PATTERN_NAME}` and `${ACTIVE_PATTERN_PATH}`.
   * Read `${ACTIVE_PATTERN_PATH}/tasks/tasks-pipeline.md`; locate `turn ${TURN_ID}` block.

3. **Assemble Pattern**

   * Parse `${ACTIVE_PATTERN_PATH}/pattern_context.md` and `${ACTIVE_PATTERN_PATH}/tasks/tasks-pipeline.md`.
   * Build an ordered list of tasks from the current `turn ${TURN_ID}` block.
   * Load and execute corresponding `.task.md` files or agent commands as defined.

4. **Execute Tasks**

   * For each task, run the designated agent and tools.
   * Use templates, read inputs from `${TARGET_PROJECT}` and `${AGENTIC_PIPELINE_PROJECT}`,
     and write outputs only to `${TARGET_PROJECT}` (recording under `${CURRENT_TURN_DIRECTORY}`).
   * After each task, append/merge its record into `manifest.json` (atomic write).

5. **Validate & Record**

   * Enforce governance validations.
   * Ensure final `manifest.json` conforms to `${TEMPLATE_MANIFEST_SCHEMA}` and includes `status`.
   * Render `changelog.md` and `adr.md` from templates, replacing placeholders with run data.

6. **Prepare Pull Request**

   * Extract the “High-level outcome” from `changelog.md`.
   * Render PR body with `${TEMPLATE_PULL_REQUEST}` and set title:
     `Turn ${TURN_ID} – ${DATE} – ${TIME_OF_EXECUTION}`.

7. **Finalize Turn**

   * Append a row to `.../ai/agentic-pipeline/turns_index.csv`.
   * Ensure all artifacts are present in `${CURRENT_TURN_DIRECTORY}`.
     If any required artifact is missing, write `manifest.json` with `status: "failed"` and a diagnostic entry, then exit non-zero.

---

**Rule of thumb:**
Only the **Bootstrap** step uses absolute paths. Everything after relies on the resolved Session Context variables.
