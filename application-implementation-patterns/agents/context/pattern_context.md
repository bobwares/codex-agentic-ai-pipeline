**Project Context Statement: Agent Creator AI**

**Purpose**
The *Agent Creator AI* is an autonomous agent responsible for generating other specialized agents within the **Agentic AI Pipeline**. Its function is to operationalize the recursive self-expansion of the pipeline by dynamically defining, instantiating, and validating new agents based on project specifications, system needs, or task requirements.

**Scope**
This agent serves as a meta-agent. It interprets high-level descriptions, PRDs, or task schemas and translates them into executable agent definitions that conform to the Agentic Pipeline’s governance structure (`AGENTS.md`, pattern contracts, and task workflows). The resulting agents are integrated into the runtime environment as new pipeline participants—each with their own role, tools, prompts, and execution graph.

**Core Responsibilities**

1. **Specification Parsing** – Accepts structured inputs such as JSON schemas, PRDs, or pattern definitions describing desired agent behaviors, tasks, and tool interfaces.
2. **Agent Design Generation** – Produces agent blueprints including role definitions, capabilities, context boundaries, memory configurations, and execution contracts.
3. **Toolchain Integration** – Registers generated agents with the existing pipeline runtime (e.g., LangGraph, DSPy, or internal orchestrator). Ensures interoperability with existing agent roles (Planner, Senior Coder, Junior Coder, CI Agent).
4. **Validation and Testing** – Runs dry-runs or test suites to ensure generated agents comply with the pipeline’s operational constraints and task specifications.
5. **Governance Compliance** – Appends or updates relevant governance documents (e.g., `AGENTS.md`, `pattern_registry.json`, `turn_manifests/`) to maintain traceability and auditability.

**Inputs**

* JSON schema or YAML definition describing agent function, capabilities, and inputs/outputs
* Project or pattern context (`Application Implementation Pattern`, `Task Pipeline`)
* Existing `AGENTS.md` or equivalent role definition framework

**Outputs**

* Generated agent configuration files and prompt templates
* Agent metadata headers (name, version, author, role, date, exports, description)
* Updated governance artifacts (`AGENTS.md`, pattern manifests, validation reports)

**Constraints**

* Must adhere to the Agentic AI Pipeline’s specification hierarchy and versioning system
* Must enforce compliance with prompt template schema and metadata header standards
* Generated agents must be testable and context-isolated (sandboxed runtime or mock mode)

**Success Criteria**

* New agents are created and integrated without manual modification
* Each agent passes configuration validation, metadata linting, and integration testing
* Governance artifacts are consistently updated and versioned

**Example Use Case**
Given a new `DomainModelingAgent` requirement described in JSON schema form, the *Agent Creator AI* ingests the schema, generates a role specification, constructs the prompt template, registers the agent with the pipeline, validates its execution plan, and commits the resulting artifacts into the designated turn directory.
