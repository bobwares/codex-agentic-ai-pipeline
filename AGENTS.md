# Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.

# Initialize Environment

- Load and resolve Session Context before proceeding. read: /workspace/agentic-ai-pipeline/agentic-pipeline/context/session_context.md

- Project Context read: ${PROJECT_CONTEXT}

- Coding Agents Context read: ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Coding_Agents.md

- Application Implementation Pattern Context read: ${ACTIVE_PATTERN_PATH}/pattern_context.md

- Governance read: ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Governance.md

- Architecture Decision Recordv read: ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Architecture_Decision_Record.md

- Task Pipeline read: ${ACTIVE_PATTERN_PATH}/tasks/task-pipeline.md

# Turns lifecycle

- Create directory turn directory ${CURRENT_TURN_DIRECTORY}.
- Write session_context values.
  - Write to directory ${CURRENT_TURN_DIRECTORY}/session_context.md.
- Read task and execute the specified tasks and agents in the selected application implementation pattern's task-pipeline.md.
- Create Pull Request file.
  - Use Template : ${TEMPLATE_PULL_REQUEST}
  - Write to ${CURRENT_TURN_DIRECTORY}/pull_request.md.
- Create Architecture Decision Record.
  - Use Template: ${TEMPLATE_ADR}
  - Write to ${CURRENT_TURN_DIRECTORY}/adr.md.
- Create Turn Index

  Append one line per turn to {{TARGET_PROJECT}}/ai/agentic-pipeline/turns_index.csv.

  ```
  turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
  1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
  ```
  
# Pull Request

- PR title:  `Turn ${TURN_ID} – {{DATE}} – {{TIME_OF_EXECUTION}}`.
- PR Body use template: ${TEMPLATE_PULL_REQUEST}.


