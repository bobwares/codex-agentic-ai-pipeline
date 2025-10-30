# Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc.).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.

# Session Context

- Open and read /workspace/codex-agentic-ai-pipeline/agentic-pipeline/context/session_context.md.
- resolve variables.

# Project Context

- Open and read ${PROJECT_CONTEXT}

# Tasks Context

- Open and read ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Tasks.md.

# Coding Agents Context

- Open and read ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Coding_Agents.md.

# Application Implementation Pattern Context 

- Open and read ${ACTIVE_PATTERN_PATH}/pattern_context.md.

# Governance 

- Open and read ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Governance.md.

# Architecture Decision Record

- Open and read ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Architecture_Decision_Record.md.

# Execution Plan

- Open and read ${EXECUTION_PLAN}.

# Turns lifecycle

- Write session_context values.
  - Write to session context variables to directory ${CURRENT_TURN_DIRECTORY}/session_context.md. Use template 
- Execute the tasks and agent calls in ${EXECUTION_PLAN}.
- Create Pull Request file.
  - Use Template : ${TEMPLATE_PULL_REQUEST}
  - Write to ${CURRENT_TURN_DIRECTORY}/pull_request.md.
- Create Architecture Decision Record.
  - Use Template: ${TEMPLATE_ADR}
  - Write to ${CURRENT_TURN_DIRECTORY}/adr.md.
- Create Turn Index

  Append one line per turn to ${TARGET_PROJECT}/ai/agentic-pipeline/turns_index.csv.

  ```
  turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
  1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
  ```
 

 
# Pull Request

- PR title:  `Turn ${TURN_ID} – {{DATE}} – {{TIME_OF_EXECUTION}}`.
- PR Body use template: ${TEMPLATE_PULL_REQUEST}.


