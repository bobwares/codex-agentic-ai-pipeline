# Container Context

Act as an Agentic Coding Agent.

# Turn Lifecycle

- open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Turns_Technical_Design.md

# Session Context

- open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/context/session_context.md

# Project Context

- open and read file /workspace/{{session context.globals.project_context}}/project_context.md


# Pattern Context

- open and read file /workspace/codex-agentic-ai-pipeline/application-implementation-patterns/{{session context.globals.application_implementation_pattern}}/pattern_context.md


# Application Implementation Pattern

- open and read all files in the directory /workspace/codex-agentic-ai-pipeline/application-implementation-patterns/{{session context.globals.application_implementation_pattern}}/**


# Governance

open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Governance.md

# Coding Agents

open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Coding_Agents.md


# Tasks

- execute Turn lifecycle defined in Turns_Technical_Design.md. 
- Enforce the rules specified in the Governance.md.


