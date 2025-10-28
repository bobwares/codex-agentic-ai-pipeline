# Session Context

## Globals

### **Environment**

| **Variable**                 | **Description**                                                                                                                      | **Path / Resolution Rule**                                                |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| **SANDBOX_BASE_DIRECTORY**   | Root directory automatically created by the Codex environment. It contains both the agentic pipeline and the target project.         | `/workspace`                                                              |
| **AGENTIC_PIPELINE_PROJECT** | Read-only agentic pipeline framework cloned into the sandbox. Provides patterns, templates, schemas, and shared tools.               | `${SANDBOX_BASE_DIRECTORY}/agentic-ai-pipeline`                           |
| **SESSION_CONTEXT**          | Canonical reference describing all session variables, semantics, and usage. Agents read this to understand contracts and boundaries. | `${AGENTIC_PIPELINE_PROJECT}/agentic-pipeline/context/session_context.md` |

---

### **Project**

| **Variable**        | **Description**                                                                                                                                                  | **Path / Resolution Rule**                        |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| **TARGET_PROJECT**  | Writable GitHub project attached to the Codex environment. All generated code, manifests, and artifacts are written here.                                        | `${SANDBOX_BASE_DIRECTORY}/${TARGET_PROJECT}`     |
| **PROJECT_CONTEXT** | Local project context that defines metadata, configuration, and environment settings. Used to resolve the active application pattern and drive generation logic. | `${TARGET_PROJECT}/ai/context/project_context.md` |

---

### **Patterns**

| **Variable**            | **Description**                                                                                                                                                   | **Path / Resolution Rule**                                                               |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
| **ACTIVE_PATTERN_NAME** | Logical name or relative path of the application implementation pattern (Markdown file) defining the structure and task composition of the generated application. | Read from `${PROJECT_CONTEXT}/project.ApplicationImplementationPattern`                  |
| **ACTIVE_PATTERN_PATH** | Absolute filesystem path to the resolved pattern file.                                                                                                            | `${AGENTIC_PIPELINE_PROJECT}/application-implementation-patterns/${ACTIVE_PATTERN_NAME}` |

---

### **Turn**

| **Variable**               | **Description**                                                                                                                                                                                                                 | **Path / Resolution Rule**                               |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| **TURN_ID**                | Sequential identifier for the current pipeline execution turn. If `${TARGET_PROJECT}/ai/agentic-pipeline/turns/` does not exist → `TURN_ID = 1`. Otherwise, set `TURN_ID` to one greater than the highest existing turn number. | Computed dynamically at runtime.                         |
| **CURRENT_TURN_DIRECTORY** | Directory where the turn’s artifacts are written.                                                                                                                                                                               | `${TARGET_PROJECT}/ai/agentic-pipeline/turns/${TURN_ID}` |

---

### **Templates**

| **Variable**                 | **Description**                                                                                      | **Path / Resolution Rule**                   |
|------------------------------|------------------------------------------------------------------------------------------------------|----------------------------------------------|
| **TEMPLATES**                | Root directory for all reusable templates used by the agentic pipeline.                              |
| **TEMPLATE_METADATA_HEADER** | Template for metadata headers placed at the top of all source files.                                 | `${TEMPLATES}/governance/metadata_header.md` |
| **TEMPLATE_BRANCH_NAMING**   | Reference document defining branch naming conventions for Git workflows.                             | `${TEMPLATES}/governance/branch_naming.md`   |
| **TEMPLATE_COMMIT_MESSAGE**  | Markdown guide for standardized commit messages generated by the coding agent.                       | `${TEMPLATES}/governance/commit_message.md`  |
| **TEMPLATE_PULL_REQUEST**    | Pull request summary and checklist template used when creating PRs for completed turns.              | `${TEMPLATES}/pr/pull_request_template.md`   |
| **TEMPLATE_ADR**             | Architectural Decision Record template used for documenting reasoning and design decisions per turn. | `${TEMPLATES}/adr/adr_template.md`           |
| **TEMPLATE_MANIFEST_SCHEMA** | JSON schema defining the structure and validation rules for each turn’s manifest.                    | `${TEMPLATES}/turn/manifest.schema.json`     |
