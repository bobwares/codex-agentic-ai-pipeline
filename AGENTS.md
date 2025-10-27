# Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.

---

# Execution Flow

1. Initialize Environment

* Session Context
  Read: `/workspace/agentic-ai-pipeline/agentic-pipeline/context/session_context.md`

* Project Context
  Read: `${PROJECT_CONTEXT}`

* Application Implementation Pattern Context
  Read: `${ACTIVE_PATTERN_PATH}/pattern_context.md`

* Governance
  Read: `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Governance.md`

* Architecture Decision Record
  Read: `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Architecture_Decision_Record.md`

* Task Pipeline
  Read: `${ACTIVE_PATTERN_PATH}/tasks/task-pipeline.md`

---

2. Execute Tasks

* Execute selected agents and tasks in the task pipeline based on the input prompt.

---

3. Finalize Turn

* Create directory turn directory `${CURRENT_TURN_DIRECTORY}`.

* Write session_context values.

    * Write to directory `${CURRENT_TURN_DIRECTORY}/session_context.md`.

* Create Pull Request.

    * Use Template : `${TEMPLATE_PULL_REQUEST}`
    * Write to `${CURRENT_TURN_DIRECTORY}/pull_request.md`

* Create Architecture Decision Record.

    * Use Template: `${TEMPLATE_ADR}`
    * Write to `${CURRENT_TURN_DIRECTORY}/adr.md`

* Create Turn Index

  Append one line per turn to `/ai/agentic-pipeline/turns_index.csv`:

  ```
  turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
  1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
  ```

---

**Turn Artifact Contract (MUST)**

Each turn must produce the following files inside `${CURRENT_TURN_DIRECTORY}`:

```
${CURRENT_TURN_DIRECTORY}/
  session_context.md
  adr.md
  pull_request.md
```

**Requirements**

* `session_context.md`: Must serialize the resolved session variables used in this turn (at minimum: `TURN_ID`, `TURN_STAMP`, `ACTIVE_PATTERN_NAME`, `CURRENT_TURN_DIRECTORY`, `TARGET_PROJECT`).
* `adr.md`: Must be rendered from `${TEMPLATE_ADR}` using this turn’s values (`TURN_ID`, `TURN_STAMP`, `HEAD_SHA` if available).
* `pull_request.md`: Must be rendered from `${TEMPLATE_PULL_REQUEST}` and contain the sentinel `<!-- TURN_TEMPLATE_V1 -->`.

If any required template is missing or any file fails to render, the turn must be marked failed but still recorded in the turn index.

---

4. Create Pull Request

* Copy this template `${TEMPLATE_PULL_REQUEST}` into every PR description and fill in each placeholder.
* Set PR title:  `Turn ${TURN_ID} – ${DATE} – ${TIME_OF_EXECUTION}`.

**PR Requirements (MUST)**

* The PR body must use the rendered file `${CURRENT_TURN_DIRECTORY}/pull_request.md` as its source.
* `${TEMPLATE_PULL_REQUEST}` must contain the literal marker `<!-- TURN_TEMPLATE_V1 -->`, which must also appear in the PR body.
* The PR body must reference:

    * `${CURRENT_TURN_DIRECTORY}/session_context.md`
    * `${CURRENT_TURN_DIRECTORY}/adr.md`
    * `/ai/agentic-pipeline/turns_index.csv`
* The PR body must state:

    * `Branch=turn/${TURN_ID}`
    * `Tag=turn/${TURN_ID}`
    * `Head after=${HEAD_SHA}` (or “unknown” if unavailable).

---

# Template Contract

* `${TEMPLATE_PULL_REQUEST}` must contain the literal marker:
  `<!-- TURN_TEMPLATE_V1 -->`

---

# Non-Compliance Handling

* If any required artifact (`session_context.md`, `adr.md`, or `pull_request.md`) is missing or invalid, the turn is considered failed.
* Failed turns must still write the `session_context.md`, `adr.md`, and `pull_request.md` files and must append an entry to `/ai/agentic-pipeline/turns_index.csv` for traceability.
