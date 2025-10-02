# Container Context

Act as an Agentic Coding Agent.

# Session Context

- open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/context/session_context.md

# Turns

- open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Turns_Technical_Design.md

# Project Context

- open and read file /workspace/{{session context.globals.project_context}}/project_context.md


# Pattern

- open and read pattern specified in the codex_project_context in the directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/{{session context.globals.application_implementation_pattern}}

# Governance

open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Governance.md

# Tasks

- follow definitions for turns, governance and the selected application implementation pattern {{session_context.globals.application_implementation_pattern}} 
- execute tasks in file  /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/{{session context.globals.application_implementation_pattern}}/tasks-pipeline.md

