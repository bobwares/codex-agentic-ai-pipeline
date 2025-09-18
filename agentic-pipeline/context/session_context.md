#  Session Context


## Globals
- sandbox_base_directory: workspace
- agentic-pipeline:  this project that is copied to the sandbox_base_directory.
- target_project: {{the name of the github repo attached to codex environment. this project is copied to sandbox_base_directory/target_project }}
- project_context: target_project/ai/context.
- turn_task: {{user's codex task prompt for the turn.}}
- turn_id: {{look for latest turn directory in targe_project/ai/agentic-pipeline/turns. if no turns exist set turn_id to 1. else increment turn_id by 1 more than the last existing turn.}}
- application_implementation_pattern: {{match pattern called out in turn_task to the patterns defined in the {agentic-pipeline}/agentic-pipeline/patterns.

## initialize  

1. calculate current turn id
2. set target_project value
3. load project_context directory into the session context.
4. load selected application implementation pattern into the context in to the sandbox_base_directory/target_project/ai/agentic-pipeline/codex_project_context.md
5. write global and project scoped variable values to session_context_values.md in the current turn directory.
