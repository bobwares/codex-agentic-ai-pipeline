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

- Turn Artifacts

Read: ${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/Turns_Technical_Design.md

- Task Pipeline

Read: ${ACTIVE_PATTERN_PATH}/tasks/task-pipeline.md


2. Execute Tasks

   * For each task, run the designated agent and tools.
  
   
3. Finalize Turn

   - Append a row to `.../ai/agentic-pipeline/turns_index.csv`.
   - Ensure all turn artifacts are created in `${CURRENT_TURN_DIRECTORY}`.
   

4. Prepare Pull Request

   * Extract the “High-level outcome” from changelog.md.
   * Render PR body with ${TEMPLATE_PULL_REQUEST} and set title:  `Turn ${TURN_ID} – ${DATE} – ${TIME_OF_EXECUTION}`.

