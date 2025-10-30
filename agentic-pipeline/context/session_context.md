TURN_START_TIME = {{DATE TIME}}

TURN_END_TIME = {{DATE TIME}}

TURN_ELAPSED_TIME = ${TURN_END_TIME} - ${TURN_START_TIME}

SANDBOX_BASE_DIRECTORY = `/workspace`

AGENTIC_PIPELINE_PROJECT = `${SANDBOX_BASE_DIRECTORY}/codex-agentic-ai-pipeline`

SESSION_CONTEXT = `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/context/session_context.md`

TARGET_PROJECT = `${SANDBOX_BASE_DIRECTORY}/${TARGET_PROJECT}`

PROJECT_CONTEXT = `${TARGET_PROJECT}/ai/context/project_context.md`

ACTIVE_PATTERN_NAME = `${PROJECT_CONTEXT}/project.ApplicationImplementationPattern`

ACTIVE_PATTERN_PATH = `${AGENTIC_PIPELINE_PROJECT}/application-implementation-patterns/${ACTIVE_PATTERN_NAME}`

EXECUTION_PLAN = `${AGENTIC_PIPELINE_PROJECT}/application-implementation-patterns/${ACTIVE_PATTERN_NAME}/execution-plan.md`


TEMPLATES = `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/templates`

TEMPLATE_METADATA_HEADER = `${TEMPLATES}/governance/metadata_header.md`

TEMPLATE_BRANCH_NAMING = `${TEMPLATES}/governance/branch_naming.md`

TEMPLATE_COMMIT_MESSAGE = `${TEMPLATES}/governance/commit_message.md`

TEMPLATE_PULL_REQUEST = `${TEMPLATES}/pr/pull_request_template.md`

TEMPLATE_ADR = `${TEMPLATES}/adr/adr_template.md`

TEMPLATE_MANIFEST_SCHEMA = `${TEMPLATES}/turn/manifest.schema.json`

CODING_AGENTS_DIRECTORY = `${AGENTIC_PIPELINE_PROJECT}/coding-agents`

CONTAINER_TASKS = `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/container/tasks`


CURRENT_TURN_DIRECTORY = `${TARGET_PROJECT}/ai/agentic-pipeline/turns/${TURN_ID}`

TURN_ID = Computed dynamically at runtime. starts at 1.
