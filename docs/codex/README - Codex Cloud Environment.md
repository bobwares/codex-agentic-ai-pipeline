# Codex Cloud Environment



Codex runs each task inside a containerized [“cloud environment”](https://developers.openai.com/codex/cloud/environments) that you can customize to match your project’s toolchain. The agent only has a terminal; any capability beyond that (linters, CLIs, SDKs, test runners) must be present in the container image or installed by your setup scripts. 

## Execution Model

1. Codex prepares a container with your repo at the requested branch/SHA and runs your setup/maintenance scripts.
2. Internet is configured per your environment settings (off by default; you can allow limited or full access).
3. The agent loops on shell commands (edit code, run tests/linters), honoring commands you define in AGENTS.md.
4. When finished, Codex shows results and a diff; you can open a PR or request follow-ups. 

## Base Image

* Default image: codex-universal — preinstalls common languages and tools; you can pin language versions in environment settings and add more via scripts. Reference Dockerfile is public for local testing. 

## Dependencies

* Automatic install for standard package managers (npm, yarn, pnpm, pip, pipenv, poetry).
* For anything custom, provide a setup script. Note: setup runs in a separate shell; `export` won’t persist—write env changes to `~/.bashrc` if needed. 

## Environment Variables & Secrets

* Environment variables: available for the full task.
* Secrets: additionally encrypted; available only during setup scripts, then stripped before the agent runs. Plan your scripts accordingly. 

## Caching Behavior

* Codex caches post-setup container state for up to 12 hours to speed follow-ups.
* On resume, Codex checks out the task branch and runs the maintenance script.
* Cache auto-invalidates when setup/maintenance scripts, env vars, or secrets change; you can also reset manually. Team/Enterprise caches are shared. 

## Network Policy

* Internet is available during setup to install dependencies.
* During agent execution, outbound access is disabled by default; you can enable limited or full access. All outbound traffic goes through an HTTP/HTTPS proxy. 

## CLI Option

* If your stack doesn’t fit the cloud constraints, run Codex locally or in a background environment (e.g., a devbox or CI) using the Codex CLI. 

