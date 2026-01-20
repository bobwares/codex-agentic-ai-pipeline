Below is a **ready-to-drop-in task definition** for your **Agentic AI Pipeline**, written in the same engineering tone, structure, and pattern as your existing *REST API + JPA* implementation tasks — but adapted for **MCP Server** integration instead of HTTP controllers.

This version assumes the goal is to build a **Spring Boot–based MCP Server** that exposes project-specific tools, resources, and prompts via the Model Context Protocol (stdio or WebSocket transport).
It follows the same “Task block” structure used across your *spring-boot-mvc-jpa-postgresql* pattern, but replaces REST with MCP.

---

# Task – Create MCP Server (Java / Spring)

## Purpose

Implement an MCP Server using Java 21 + Spring Boot 3.5.x that exposes domain-specific tools and resources to the Agentic AI Pipeline.
The AI pipeline will call these tools instead of REST endpoints.
The server must operate over supported MCP transports (stdio preferred), follow strict schema definitions, and match the Codex session context and project conventions.

## Inputs

Load Codex session context.

* Project

    * Name
    * Author

* Maven

    * groupId
    * artifactId

* Domain

    * Domain Object (singular, e.g., Customer)
    * Persisted Data schema (path to JSON Schema)

* Tech assumptions (implicit unless overridden)

    * Java 21, Spring Boot 3.5.x
    * MCP transport via stdio
    * Jackson for JSON serialization
    * Codex metadata header standard
    * Tools must follow JSON Schema definitions

---

# Constraints

* **Do not create REST controllers.**
  MCP replaces MVC controllers as the I/O interface.
* Use **@Component** and event-driven initialization for registering MCP tools.
* Expose **tools**, **resources**, and **prompts** consistent with the MCP protocol specification.
* Follow the same folder structure as the REST pattern (domain, repository, service), but replace the “controller” layer with **mcp/** and an **McpServerRunner**.
* All tool inputs/outputs must be defined with **JSON Schema** and validated with **jakarta.validation**.
* Must compile and run as a Spring Boot application.
* Must generate deterministic outputs and strict PEP8 analogues for Java, including formatting and imports.

---

# Folder Structure

Use the same pattern as the REST architecture, with the “mcp” layer replacing “controller”.

```
src/main/java/.../
    domain/
        <Domain>.java
        <Domain>Validator.java
    repository/
        <Domain>Repository.java
    service/
        <Domain>Service.java
    mcp/
        McpServerConfig.java
        McpServerRunner.java
        tools/
            Create<Domain>Tool.java
            Read<Domain>Tool.java
            Update<Domain>Tool.java
            List<Domain>Tool.java
        schemas/
            create_<domain>.schema.json
            update_<domain>.schema.json
            read_<domain>.schema.json
        resources/
            DomainResourceProvider.java
```

---

# High-Level Domain Actions

These represent the abstract functionality that must be implemented for any domain.
Equivalent to “persist customer domain” in the REST pattern.

1. **Create <Domain>**
   Validate input JSON via schema → call service → persist → return MCP result object.

2. **Read <Domain> by ID**
   Input: domainId
   Output: full domain object or MCP error.

3. **Update <Domain>**
   Validate → call service → persist updates → return updated object.

4. **List <Domain>**
   Query repository → return list of domain objects.

5. **Expose Domain as MCP Resource**
   Server must provide a resource endpoint for the domain schema:
   `resource://schemas/<domain>.json`

6. **Expose Scaffolded Prompts**
   Provide server-side prompts the model may request (e.g., “summarize domain”, “validate domain data”).

---

# Tasks

## Task 1 – Scaffold MCP Server Layer

Generate:

* `McpServerConfig` – config for registering tools, resources, prompts
* `McpServerRunner` – the stdio entry point (`System.in/out`)
* Tool registry and discovery mechanism
* JSON serialization via Jackson
* Integration test verifying tool registration

Acceptance Criteria:

* Boot app from CLI: `java -jar app.jar`
* Prints MCP server handshake over stdio
* Lists capabilities (tools, resources, prompts)

---

## Task 2 – Generate MCP Tools for Domain

Generate the set of LLM-callable tools, one per domain action:

* `Create<Domain>Tool`
* `Read<Domain>Tool`
* `Update<Domain>Tool`
* `List<Domain>Tool`

Each tool must define:

* `name`
* `description`
* `input_schema` (JSON Schema file)
* `output_schema`
* Handler method mapping to `<Domain>Service`

Acceptance Criteria:

* Tools validate incoming JSON using JSON Schema
* Tools return deterministic result objects
* Tools return a structured MCP error on failure

---

## Task 3 – Implement Domain Resources

Expose domain-related server resources:

* Schema resources (JSON Schema for create/update/read)
* Static metadata files (if any)

Resources must implement:

* Resource URI pattern
* ResourceInfo
* Streaming of JSON payloads

Acceptance Criteria:

* Model can load schema via MCP `resources.read`
* Schema is valid JSON and matches domain object

---

## Task 4 – Implement Server-Side Prompts

Create prompts the pipeline can request to help reasoning:

Example prompts:

* `summarize_<domain>`
* `validate_<domain>`
* `improve_<domain>_input`

Acceptance Criteria:

* Prompts are discoverable via MCP `prompts.list`
* Returned prompt templates follow GPT-5 prompt structure
* Prompts use Codex metadata header patterns

---

## Task 5 – Domain Service Layer Integration

Reuse the standard 3-tier (domain → repository → service) structure:

* Domain validation
* Repository persistence
* Service orchestrates operations for tools

Acceptance Criteria:

* CRUD operations all work via MCP
* No REST controllers or HTTP interfaces
* Integration tests with in-memory DB

---

## Task 6 – Provide Example MCP Client Usage

Provide client examples:

* CLI invocation
* LLM tool call example
* Example JSON request/response messages
* Instructions for registering this server with your Agentic AI pipeline

---

# Final Output of This Task

When the agent completes this task, the project will contain:

1. A fully functioning MCP Server running on Spring Boot.
2. Domain-specific tools callable by the LLM.
3. Resources and prompts available via MCP.
4. A complete service/repository/domain stack underneath the MCP layer.
5. Zero REST endpoints; the LLM interacts only through MCP.

---

If you want, I can generate:

* The full starter project (Maven + package structure + metadata headers)
* The complete Java implementation for the MCP server
* A pattern folder under `application-implementation-patterns/mcp-spring-server`
* A matching task for NestJS (Node-based MCP server)

Just tell me what direction you want next.
