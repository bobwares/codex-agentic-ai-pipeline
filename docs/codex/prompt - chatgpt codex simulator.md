# Context

act as a chatgpt codex simulator.  

## Definitions

- agentic pipeline container  - The context and task pipeline container that controls the code generation.
  - defined in this repo https://github.com/bobwares/codex-agentic-ai-pipeline.  

- Target Repo - the GitHub repository the codex environment is associated with.  
  - example: https://github.com/bobwares/codex-customer-registration-nextjs-nestjs.  
  
- Codex Environment Setup script.

```shell

#!/usr/bin/env bash
# setup_repo.sh
# Copies the java-spring-boot-codex-starter repo into the Codex workspace.

set -euo pipefail

AI_REPO_URL="https://github.com/bobwares/codex-agentic-ai-pipeline"
AI_REPO_DIR="../codex-agentic-ai-pipeline"


# If directory already exists, skip clone
if [ -d "$AI_REPO_DIR/.git" ]; then
  echo "Repository already cloned in $AI_REPO_DIR. Skipping..."
else
  echo "Cloning $AI_REPO_URL into $AI_REPO_DIR..."
  git clone "$AI_REPO_URL" "$AI_REPO_DIR"
fi
echo "Repository is ready in $AI_REPO_DIR."

# Symlink AGENTS.md into workspace root
ln -sf "$AI_REPO_DIR/AGENTS.md" AGENTS.md
echo "Symlink created: AGENTS.md -> $AI_REPO_DIR/AGENTS.md"





```

- Codex Sandbox.

The **ChatGPT Codex Sandbox** is an isolated workspace where agentic AI pipelines can execute tasks against a target project. It keeps context (domain schemas, project metadata, task registry) separate from the project itself, so that agents can generate, run, and refine artifacts—like code, migrations, or documentation—without polluting the source repository. In short, it’s a controlled environment for orchestrating and testing Codex agents on real projects.


- Codex Task - Prompt that will start the execution of a codex turn.  




## Executing a Codex Task.

| Tool Name         | Description                                                                          | Inputs               | Outputs                                           |
|-------------------|--------------------------------------------------------------------------------------|----------------------|---------------------------------------------------|
| **LoadContext**   | Load project context (domain, stack, metadata) from `ai/context/project_context.md`. | None                 | Parsed project context object.                    |
| **InspectSchema** | Parse and validate authoritative JSON Schema (domain definition).                    | Path to schema file. | Structured schema object.                         |
| **ReadTask**      | Load a task definition from the `tasks/` directory.                                  | Task file name.      | Task metadata (goal, steps, acceptance criteria). |


