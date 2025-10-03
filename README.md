# Agentic AI Pipeline


A structured framework for AI-driven code generation that orchestrates multi-turn development workflows using configurable application implementation patterns, tools, and governance policies.

Unlike one-off code snippets, tasks are executed as structured, traceable **turns**. Each turn produces required artifacts, is governed by explicit rules, and integrates with Git/CI. This elevates AI coding into a **professional-grade pipeline**.

## Purpose

Execute a single, well-scoped engineering task against a linked GitHub repository inside a prepared sandbox, producing standardized artifacts (manifest, changelog, ADR) and a verifiable commit.


## Overview

The **Agentic AI Pipeline** project defines a context for running an auditable, and reproducible AI-assisted development workflow using [**ChatGPT Codex**](https://developers.openai.com/codex/cloud) as the coding agent.

It instructs  **ChatGPT Codex** to build a container context at the beginning of each Codex Task.  

* It loads the following into the container context:
    * turn lifecycle specification
    * governance rules
    * container session
    * project session
    * application implementation pattern
    * Instructions for executing the task pipeline


## How It Works

ChatGPT Codex provides a [“cloud sandbox environment”](https://developers.openai.com/codex/cloud/environments) for executing Codex Tasks against a selected GitHub repository.  
The sandbox environment provides a set of preinstalled software tools such as runtimes for Java, Python, and Node.js already installed.  A setup script can be added to the environment's configuration that can add more tooling.  The [setup script](codex-enviroments/agentic-pipeline/env-setup.sh) is used to copy the Agentic AI Pipeline repository to the sandbox's workspace.

## Codex Task Execution

1. Human launches a codex task by entering a prompt in the ChatGPT Codex interface.
2. Codex initializes a sandbox with tooling.
3. Codex copies the target repository to the sandbox under the directory workspace.
4. Codex executes the environments setup script which 
   - copies the codex-agentic-ai-pipeline to the sandbox's workspace directory.  
   - creates a symbolic link in the  root of the target repository to the AGENTS.md file in the root of the codex-agentic-ai-pipeline repository.
5. Codex detects `AGENTS.md` which instructs the coding agent to loads the container context.
6. `AGENTS.md` instructs the coding agent to execute Turn lifecycle defined in the container context.
7. Codex generates artifacts guided by the tasks defined in the selected application implementation pattern.
8. Codex logs the turn in the target repository as defined by the Turns Lifecycle.
9. Codex presents the list of artifacts created for review by the human.
10. Codex presents a button to create a GitHub PR for the changes.  
11. If the human decides to create the PR, Codex will use the template defined in the Agentic AI Pipeline container to create the pull request.



## Quick Start

1. Create a target project using the template:  [Agentic AI Pipeline Target Project Template](https://github.com/bobwares/agentic-ai-pipeline-target-project-template)
2. Update `project_context.md` with project name, selected application implementation pattern, domain model and other context needed to implement the application.
3. Create an associated [Codex environment](docs/codex/README - Setting up the CodeX Environment.md).
4. Load [ChatGPT Codex](https://chatgpt.com/codex) in your browser and select the environment, select the repository branch, enter the task and click the Code button. 
5. Review generated code, Architecture Decision Records (ADR), and changelogs.
6. Create pull request.



