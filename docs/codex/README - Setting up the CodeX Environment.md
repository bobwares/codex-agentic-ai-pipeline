# Setting up the OpenAI Codex Cloud Environment

This guide documents the structure and initialization process for projects running inside the **OpenAI Codex** development container. It standardizes how to configure dependencies, environments, and project scaffolding for AI-enabled workflows using languages such as Python, Node.js, Go, and more.

**Authentication Requirement**: You must connect Codex to your GitHub account to authorize repository access and enable environment setup.

## Environment Setup

### 1. Basic

The **Basic** section defines repository-level metadata and workspace settings:

* **GitHub organization:** Select a GitHub Account that you have connected to CodeX.
* **Repository**: Select one private or public GitHub repository to work with. The selected GitHub repository is cloned into `/workspace/<your-project-name>`.
* **Name**: Enter a name for the environment.
* **Description**: Enter a description of the environment.

### 2. Code Execution

This section governs how your code runs inside the Codex environment:

* **Container Image**: [`openai/codex-universal`](https://github.com/openai/codex-universal) — Ubuntu 24.04-based container with pre-installed language runtimes. Universal is the only selection. Click on Preinstalled packages to select versions of packages.

  Universal Container image pre-installed packages:

    * Python 3.12
    * Node.js 20
    * Ruby 3.4.4
    * Rust 1.87.0
    * Go 1.23.8
    * Bun 1.2.14
    * Java 21
    * Swift 6.1

* **Environment Variables:** Add key and value for each environment variable you want to add to the container's environment.

* **Secrets:** Add key and value for each secret you want to add to the container's environment.

* **Setup script:** The setup script is run at the start of every task, after the repo is cloned. Network access is always enabled for this step.

* **Agent internet access:** By default internet access is disabled after the setup script is executed. The Codex container will only be able to use the dependencies installed in the Universal Container image and the packages installed by the setup script. You can override this by turning internet access on so that your tasks can access the internet.

* **Domain allow list:** Select "none", "Common dependencies", or "All (unrestricted)".

    1. **Additional allowed domains:** Enter domains, separated by commas.
    2. **Allowed HTTP Methods:** Select "All Methods" or "GET, HEAD, and OPTIONS".

* **Terminal Window**: An interactive terminal is connected to the container.

Example setup script:

```bash
echo "Starting Setup Script..."
pip install -r requirements.txt
yarn install
```

---

## Project Directory Layout

```
/workspace/<your-project-name>
├── AGENTS.md              # (Optional) AI agent roles, logic, or workflows
├── Makefile               # Task automation: run, test, lint
├── README.md              # Project documentation
├── version.md             # Changelog / version history
├── src/                   # Source code
├── tests/                 # Unit & integration tests
└── e2e/                   # End-to-end or .http tests
```

---

## Makefile Commands (Recommended)

```make
run:         # Start the application (CLI, web, etc.)
lint:        # Run code linters (e.g., flake8, eslint)
test:        # Execute tests (unit/integration)
```

---

## Best Practices

* Install **all dependencies** during the setup phase — no post-setup downloads.
* Track all changes in `version.md`.
* Define your agents and workflows in `AGENTS.md`.
* Internet access is revoked after setup; only local execution is allowed.

---

## References

* **CodeX CLI**: [https://github.com/openai/codex](https://github.com/openai/codex)
* **Universal Container Image**: [https://github.com/openai/codex-universal](https://github.com/openai/codex-universal)
* **Environment Configuration**: [https://platform.openai.com/docs/codex/overview#environment-configuration](https://platform.openai.com/docs/codex/overview#environment-configuration)
