# README—Session Context

## Overview
The Session Context is the single source of truth the coding agent reads at startup.
This README serves as the operational guide for how the **Session Context** initializes, governs, and stabilizes every agent run inside the Codex Agentic AI Pipeline.

The **Session Context** defines the execution environment for every **coding agent** in the Codex Agentic AI Pipeline.
It tells the agent *where to read shared resources*, *where to write generated outputs*, *which project pattern to execute*, and *how to track the current turn*.

Without this layer, agents would need to infer paths, guess pattern files, or risk overwriting shared assets.
The session context eliminates those risks by providing an explicit, immutable contract for every run.

---

## Role in the Overall Pipeline

The Agentic AI Pipeline is designed around two cooperating repositories:

1. **AGENTIC_PIPELINE_ROOT** – the shared, read-only pipeline framework that contains reusable patterns, templates, schemas, and tools.
2. **TARGET_PROJECT** – the writable project workspace where each turn’s generated artifacts are produced and versioned.

The **Session Context** binds these together. It ensures that:

* All agents know exactly where both repos live inside the Codex sandbox.
* The correct **application implementation pattern** is applied for the current project.
* Each execution cycle (turn) gets a unique, sequential **TURN_ID** for traceability.
* Generated outputs are confined to `TARGET_PROJECT`, preserving the immutability of the shared framework.

This architecture allows multiple projects to use the same agentic pipeline logic without modification.
Agents remain stateless between runs; the Session Context re-establishes their environment every time.

---

## Session Context Globals

| **Variable**               | **Description**                                                                                                                                           | **Path / Resolution Rule**                                                                   |
| -------------------------- |-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| **SANDBOX_BASE_DIRECTORY** | Root directory created by the Codex environment. Contains both the pipeline framework and the target project.                                             | `/workspace`                                                                                 |
| **AGENTIC_PIPELINE_ROOT**  | Read-only agentic pipeline framework providing reusable patterns, templates, schemas, and tools.                                                          | `${SANDBOX_BASE_DIRECTORY}/agentic-ai-pipeline`                                              |
| **TARGET_PROJECT**         | Writable project workspace cloned from the user’s GitHub repo. All generated code, manifests, and artifacts are written here.                             | `${SANDBOX_BASE_DIRECTORY}/${TARGET_PROJECT}`                                                |
| **PROJECT_CONTEXT**        | Local configuration directory for the target project. Defines domain models, application patterns, and other metadata consumed by agents.                 | `${TARGET_PROJECT}/ai/context`                                                               |
| **TURN_ID**                | Sequential identifier for the current pipeline execution turn. If no previous turns exist, set to `1`; otherwise increment the last existing turn number. | Computed dynamically at runtime.                                                             |
| **ACTIVE_PATTERN_NAME**         | Logical name or relative path of the application implementation pattern to execute (within the pipeline project).                                         | Read from `${PROJECT_CONTEXT}/project.ApplicationImplementationPattern`                      |
| **ACTIVE_PATTERN_PATH**         | Absolute filesystem path to the resolved pattern.                                                                                                         | `${AGENTIC_AI_PIPELINE_PROJECT}/application-implementation-patterns/${ACTIVE_PATTERN_NAME}` |


## Usage Summary

1. **Initialization**

    * The coding agent loads all Session Context variables before executing any task.
    * These variables define absolute paths for reading and writing within the sandbox.

2. **Boundaries**

    * **Read-only:** `${AGENTIC_PIPELINE_ROOT}`
    * **Writable:** `${TARGET_PROJECT}`

3. **Turn Management**

    * Each execution cycle (turn) increments `TURN_ID` and creates a directory at:
      `${TARGET_PROJECT}/ai/agentic-pipeline/turns/${TURN_ID}/`
    * All outputs, manifests, and summaries for that turn are written inside this folder.

4. **Pattern Execution**

    * The `ACTIVE_PATTERN` specifies the ordered list of tasks and agents to execute.
    * Each task consumes input files from `TARGET_PROJECT` or `AGENTIC_PIPELINE_ROOT` and writes its results back into `TARGET_PROJECT`.
    * Validation results and metadata are appended to a manifest for auditing.

5. **Artifacts and Provenance**

    * Agents emit:

        * `summary.md` – human-readable description of generated work.
        * `manifest.json` – structured record of inputs, outputs, tools, hashes, and timestamps.
        * `adr.md` – design rationale and contextual notes.
        * Updates to `turns_index.csv` – incremental audit log.
    * Together, these guarantee deterministic, verifiable builds across turns.

---

## Why the Session Context Is Essential

| **Capability**    | **Enabled By Session Context**                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------------------------------- |
| **Determinism**   | Agents never guess file locations or environment state; everything is declared up front.                        |
| **Safety**        | The read-only boundary around `AGENTIC_PIPELINE_ROOT` prevents accidental modification of shared resources.     |
| **Composability** | Multiple agents can run cooperatively because they share the same directory references and pattern definitions. |
| **Auditability**  | `TURN_ID`, manifests, and index files create a permanent, inspectable history of every generated artifact.      |
| **Portability**   | Any GitHub project can plug into the pipeline simply by declaring its `PROJECT_CONTEXT` and `ACTIVE_PATTERN`.   |
