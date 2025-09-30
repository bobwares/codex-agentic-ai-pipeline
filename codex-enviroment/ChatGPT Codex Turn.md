A **ChatGPT Codex turn** is a single cycle of interaction between you, the Codex agent, and the sandboxed project environment. Each turn follows a defined structure that keeps the process deterministic, traceable, and context-aware.

Here’s the breakdown:

### 1. Input Context

At the start of the turn, the Codex agent ingests:

* **Conversation context** (your latest instruction + retained project context).
* **Artifacts and state** from the sandbox (JSON Schemas, task files, migrations, code modules, etc.).
* **Tool registry** (the set of available tools such as `npm build`, `typeorm migration:run`, `generate DTO`, etc.).

This defines the problem space for the current turn.

### 2. Reasoning and Planning

The agent applies **chain-of-thought orchestration**:

* Identifies the user’s goal (“Generate controllers and services with Swagger docs”).
* Decomposes it into one or more tasks.
* Decides which tools to call and in what sequence.

At this stage, no execution has occurred—just reasoning.

### 3. Tool Invocation

The Codex agent then calls one or more tools:

* Example: `GenerateMigrationFromSchemaTool` → produces a TypeORM migration file.
* Example: `RunBuildTool` → runs `npm run build` inside the sandbox.

Each tool runs deterministically against the sandbox project, producing concrete outputs (files, logs, test results).

### 4. Artifact Creation

Outputs from the tools are committed back into the sandbox:

* New or modified source files (e.g., `customer.controller.ts`).
* Supporting artifacts (docs, README snippets, test cases).
* Logs or structured results (migration run success/failure).

Artifacts are versioned per-turn so later turns can reference or roll back.

### 5. Response Back to User

The Codex agent then:

* Summarizes what happened (which tools ran, what files were created/changed).
* Surfaces artifacts inline if appropriate (like showing a generated migration or service class).
* Provides next-step guidance (“Run Task 09 for logging setup” or “Apply migrations to database”).

This closes the turn.

---

**In short:**
A **Codex turn** = (Context ingestion → Reasoning → Tool calls → Artifact generation → Response).

Would you like me to diagram this as a **flow chart (Mermaid)** so you can drop it into your Codex docs, or keep it strictly textual?
