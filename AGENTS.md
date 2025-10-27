# Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.

# Execution Flow

1. Initialize Environment

- Session Context

Read: /workspace/agentic-ai-pipeline/agentic-pipeline/context/session_context.md

- Project Context

Read: ${PROJECT_CONTEXT}

- Application Implementation Pattern Context

Read: ${ACTIVE_PATTERN_PATH}/pattern_context.md

- Governance

Read: ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Governance.md

- Architecture Decision Record

Read: {AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Architecture_Decision_Record.md

- Task Pipeline

Read: ${ACTIVE_PATTERN_PATH}/tasks/task-pipeline.md


2. Execute Tasks

   - Execute selected agents and tasks in the task pipeline based on the input prompt. 
  
   
3. Finalize Turn
   - Create directory turn directory ${CURRENT_TURN_DIRECTORY}}.
   - write session_context values.
     - write to directory ${CURRENT_TURN_DIRECTORY}/session_context.md.

  - Create Pull Request.
    - Use Template : ${TEMPLATE_PULL_REQUEST}
    - Write to ${{CURRENT_TURN_DIRECTORY}}/pull_request.md
       
  - Create Architecture Decision Record.
    - Use Template: ${TEMPLATE_ADR}
    - Write to ${{CURRENT_TURN_DIRECTORY}}/adr.md

  - Create Turn Index

  Append one line per turn to `/ai/agentic-pipeline/turns_index.csv`:
   
  ```
  turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
  1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
  ```
4. Create Pull Request
- Copy this template ${TEMPLATE_PULL_REQUEST} into every PR description and fill in each placeholder.
- Set PR title:  `Turn ${TURN_ID} – ${DATE} – ${TIME_OF_EXECUTION}`.

