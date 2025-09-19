# AGENTS.md — Codex Agentic Pipeline

## Purpose

Define the runtime contract for how a Codex container loads context and executes a turn.
Principles:

* Context is read-only and snapshotted at turn start.
* Execution is driven by a single, declarative Tasks Pipeline document (Markdown).
* The selected Application Implementation Pattern provides the authoritative pipeline; the project may supply a stricter override.
* Governance is loaded during init (Markdown) and enforced; no separate section is required here.

---

# 1) Container Context (Top-Level)

The Container Context aggregates all read-only inputs the agent may consult at runtime.

### Includes (read-only at runtime)

* Turns Context: `agentic-pipeline/context/Turns_Technical_Design.md`
* Session Context: `agentic-pipeline/context/session_context.md`
* Application Implementation Pattern Context (selected): `agentic-pipeline/patterns/<pattern-id>/**`
* Project Context: `ai/context/**` (project inputs, schemas, constraints)
* Tasks Pipeline (effective): resolved from the selected Application Implementation Pattern (see section 4) with optional project override
* Governance (loaded during init): pattern default with optional project override; both Markdown

Runtime rule: writes to any of the above paths must fail the turn.

---

# 2) Session Context (Initialization Contract)

Performed by `codex-turn init` before any task runs.

### Required globals

* `sandbox_base_directory`
* `target_project`
* `turn_id` (monotonic, allocated at init)
* `application_implementation_pattern` (pattern id from `ai/context/codex_project_context.md`)
* `patterns` (enumerated at build time; not re-scanned at run time)

### Init sequence

1. Allocate next `turn_id`.
2. Load Project Context (`ai/context/**`).
3. Resolve Application Implementation Pattern ID from `ai/context/codex_project_context.md`; do not scan for tasks here.
4. Load Application Implementation Pattern Tasks Pipeline (authoritative; see section 4) and merge optional Project Pipeline Override.
5. Load Governance from the Application Implementation Pattern and optional project override (Markdown only).
6. Snapshot all resolved context into `ai/agentic-pipeline/turns/<TurnID>/context.snapshot.json`, including:

    * `applicationImplementationPatternId`, hashes of pattern pipeline, project override (if any), effective pipeline
    * governance hashes and effective governance reference
    * effective policy (write allowlist/denylist)
    * resolved task list for the turn

The executor must read only from the snapshot after init.

---

# 3) Application Implementation Pattern Selection

* The selected Application Implementation Pattern is declared in `ai/context/codex_project_context.md`.
* Application Implementation Pattern files are read-only at runtime.
* Tool definitions and documentation live under `agentic-pipeline/patterns/<pattern-id>/`.

---

# 4) Tasks Pipeline (Controller)

Defines exactly what runs each turn. No runtime discovery is allowed.

### Source of truth and precedence

* Authoritative (from the Application Implementation Pattern):
  `agentic-pipeline/patterns/<pattern-id>/tasks-pipeline.md`
* Optional project override (narrower/stricter only):
  `ai/agentic-pipeline/tasks-pipeline.md`
* Effective pipeline: the Application Implementation Pattern pipeline merged with the project override (override may tighten or reorder, never widen). If override is absent, use the pattern pipeline as-is.

### Merge policy (project override → Application Implementation Pattern)

* Allowed: change `policy.mode`, further restrict `write_allowlist` / add `denylist`, override `turns.<TurnID>` or `turns.default` sequences.
* Disallowed: add new tool names not present in the pattern catalog, reference task ids not defined in the pattern catalog, widen write access beyond the pattern baseline. Any disallowed change → hard fail before RUN.

### Execution contract

* The executor resolves the task list for `turn_id` (fallback to `default`) from the effective pipeline stored in the snapshot.
* All task/tool lookups MUST use the snapshot copy; no filesystem searches.

---

# 5) Execution Model (Turns)

A turn is a deterministic state machine driven by the snapshot and the effective pipeline.

### States

`INIT → PLAN → RUN (tasks in order) → RECORD → VALIDATE → FINALIZE → DONE`
Any policy violation → `ABORT` (artifacts preserved for audit).

### PLAN

* Read the effective pipeline from the snapshot.
* Resolve task list for `turn_id`.
* Verify tools exist (by name) and inputs are present.
* Pre-create `ai/agentic-pipeline/turns/<TurnID>/{manifest.json, adr.md, changelog.md, logs/, reports/}`.

### RUN

For each task in order:

* Enforce write policy: `task.write_allowlist ∩ pipeline.policy.turn_scope.write_allowlist` and `denylist`.
* Invoke tools with declared inputs to produce declared outputs.
* Stream logs to `logs/task_<seq>.log`.

### RECORD

* Finalize `manifest.json` with file list, hashes, metrics, and:

    * `contextSnapshotPath`, `contextSnapshotHash`
    * `policy.mode`, effective allow/deny lists

### VALIDATE

* Enforce Governance rules (coding standards, logging, ADR policy, git workflow) using the effective Governance loaded at init.
* Artifact presence checks (manifest/changelog/ADR non-empty).
* Path policy: all changed files ⊆ effective allowlists; denylist untouched.
* Run acceptance tests from the pipeline; record under `reports/` and in `manifest.json`.

### FINALIZE

* Commit with conventional turn header and `Turn-*` footers.
* Tag `turn/<TurnID>`.
* Append `/turns/index.csv`.

---

# 6) Required Artifacts (per Turn)

* `ai/agentic-pipeline/turns/<TurnID>/context.snapshot.json`
* `ai/agentic-pipeline/turns/<TurnID>/manifest.json`
* `ai/agentic-pipeline/turns/<TurnID>/changelog.md`
* `ai/agentic-pipeline/turns/<TurnID>/adr.md`
* Optional: `ai/agentic-pipeline/turns/<TurnID>/diff.patch`, `logs/**`, `reports/**`

---


# 8) Quick Start (Turn 1, DB-only example)

1. In `ai/context/codex_project_context.md`, set the Application Implementation Pattern id.
2. Ensure the Application Implementation Pattern contains `tasks-pipeline.md` with `policy.mode: db-only` and DB tasks only.
3. Optionally add a project override `ai/agentic-pipeline/tasks-pipeline.md` to further restrict or sequence tasks for turn 1.
4. Run:

    * `codex-turn init` → creates `turns/1/` and `context.snapshot.json`
    * `codex-turn run`  → executes tasks from the effective pipeline
    * `codex-turn finalize` → validates artifacts, commits, tags `turn/1`
5. CI enforces immutability and path policy; merge only if green.

---

## Non-Goals

* Do not “discover” tasks by scanning Application Implementation Pattern folders at runtime.
* Do not write into context or Application Implementation Pattern directories during execution.
* Any scope broadening (e.g., adding UI/API in a DB-only pipeline) must be proposed via ADR and scheduled for a future turn with an updated pipeline.
