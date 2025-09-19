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

The Container holds the context defines the rules and standard for how the Codex Agentic Pipeline should operate. These documents loaded into the container context should strictly be followed.

### Load Container Context

load each item into the container context:

* Turns Context: `agentic-pipeline/context/Turns_Technical_Design.md`
* Session Context: `agentic-pipeline/context/session_context.md`
* Application Implementation Pattern Context (selected): `agentic-pipeline/patterns/{{session context.application_implementation_pattern}}/**`
* Project Context: {{project_context}} (project inputs, schemas, constraints)
* Operational Governance: agentic-pipeline/context/Governance.md


---


# 3) Application Implementation Pattern Selection

* The selected Application Implementation Pattern is declared in `ai/context/codex_project_context.md`.
* Application Implementation Pattern files are read-only at runtime.
* Tool definitions and documentation live under `agentic-pipeline/patterns/{{pattern name}}/`.

---

# 4) Tasks Pipeline (Controller)

Defines exactly what runs each turn. No runtime discovery is allowed.

### Source of truth and precedence

* Authoritative (from the Application Implementation Pattern):
  `agentic-pipeline/patterns/<pattern-id>/tasks-pipeline.md`
* Optional project override (narrower/stricter only):
  `ai/agentic-pipeline/tasks-pipeline.md`
* Effective pipeline: the Application Implementation Pattern pipeline merged with the project override (override may tighten or reorder, never widen). If override is absent, use the pattern pipeline as-is.

