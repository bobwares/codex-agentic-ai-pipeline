# application-implementation-patterns/mcp-spring-server

## 1. Purpose

Provides a **Spring Boot 3.5.x + Java 21** implementation pattern for building an **MCP Server** that exposes tools, resources, and prompts as the primary interface to the Agentic AI Pipeline.
This pattern replaces REST controllers with MCP tool handlers and follows the same layered architecture:

* domain
* repository
* service
* mcp (interface layer)

The project uses stdio as the default MCP transport and exposes JSON-schema-validated tools per domain.

---

# 2. Folder Structure (Template)

```
application-implementation-patterns/
└── mcp-spring-server/
    ├── README.md
    ├── pattern.json
    ├── project-structure.md
    ├── scaffolding-notes.md
    ├── src/
    │   ├── main/java/com/example/mcpserver/
    │   │   ├── domain/
    │   │   │   └── <Domain>.java
    │   │   ├── repository/
    │   │   │   └── <Domain>Repository.java
    │   │   ├── service/
    │   │   │   └── <Domain>Service.java
    │   │   ├── mcp/
    │   │   │   ├── McpServerConfig.java
    │   │   │   ├── McpServerRunner.java
    │   │   │   ├── tools/
    │   │   │   │   ├── Create<Domain>Tool.java
    │   │   │   │   ├── Read<Domain>Tool.java
    │   │   │   │   ├── Update<Domain>Tool.java
    │   │   │   │   └── List<Domain>Tool.java
    │   │   │   ├── prompts/
    │   │   │   │   └── <domain>-prompt-summaries.txt
    │   │   │   └── resources/
    │   │   │       └── DomainResourceProvider.java
    │   │   └── Application.java
    │   └── main/resources/
    │       └── schemas/
    │           ├── create_<domain>.schema.json
    │           ├── update_<domain>.schema.json
    │           └── read_<domain>.schema.json
    └── test/
        └── McpServerIntegrationTest.java
```

You can consider this the equivalent of your `spring-boot-mvc-jpa-postgresql` pattern, but built for MCP.

---

# 3. README.md (Pattern Overview)

**README.md**

```
# MCP Spring Server Pattern

## Overview
This pattern provides a Spring Boot 3.5.x implementation of a Model Context Protocol
server. Instead of REST controllers, the system exposes domain-specific operations
as MCP tools, resources, and prompts.

The agentic pipeline uses this interface to perform CRUD operations, read schemas,
and load server-provided prompts. This allows the LLM to integrate safely with the
application runtime without exposing a REST surface.

## Key Features
- MCP stdio transport
- Domain-layer CRUD operations exposed as tools
- JSON Schema validation for tool input/output
- Resource providers for schema and static metadata
- Server-side prompt registry
- Compatible with Codex session context standards

## Intended Use
This folder serves as a template. The Agentic AI Pipeline will:
1. Copy this structure
2. Insert project metadata
3. Generate domain-specific code
4. Integrate the MCP server into CI/CD
```

---

# 4. pattern.json

This file defines how the pipeline uses the pattern.

```
{
  "name": "mcp-spring-server",
  "language": "java",
  "runtime": "spring-boot-3.5.x",
  "description": "Spring Boot MCP server exposing tools/resources/prompts for domain CRUD actions.",
  "layers": [
    "domain",
    "repository",
    "service",
    "mcp"
  ],
  "entry": "src/main/java/com/example/mcpserver/Application.java",
  "mcp": {
    "transport": "stdio",
    "tools": true,
    "resources": true,
    "prompts": true
  },
  "supports": {
    "domain": true,
    "json-schema": true,
    "postgres": true
  }
}
```

---

# 5. project-structure.md

```
# Project Structure – MCP Spring Server

## Layer Summary

domain/
    Java domain classes and validation.

repository/
    Spring Data repositories for database persistence.

service/
    Contains the business logic. Tools call into this layer.

mcp/
    This is the interface layer. Replaces REST controllers.
    Contains:
      - MCP server config
      - Runner using stdio transport
      - Tools (CRUD)
      - Prompts
      - Resource providers

schemas/
    JSON schemas defining tool input/output requirements.
```

---

# 6. scaffolding-notes.md

This instructs the agent how to auto-generate code.

```
# Scaffolding Notes – MCP Spring Server

## Replace Tokens
- <Domain> → singular domain object (Customer, Order, Asset)
- <domain> → lowercase version (customer, order, asset)
- Adjust package paths based on Codex session context inputs.

## Codegen Rules
1. Every domain gets exactly 4 tools:
   - Create<Domain>Tool
   - Read<Domain>Tool
   - Update<Domain>Tool
   - List<Domain>Tool

2. All tool inputs must be validated using JSON Schema.
3. All output must return:
   { "content": [ { "type": "text", "text": "<payload>" } ] }

4. Tools must call the service layer; they do not contain business logic.
5. Prompts must follow the GPT-5 standard metadata header.
6. The stdio runner must:
   - Initialize MCP server
   - Register tools
   - Register resources
   - Register prompts
   - Start the event loop

7. The project must compile with:
   javac --release 21
   spring-boot-maven-plugin
```

---

# 7. Template Java Files

Below are **abbreviated versions** of the template files so your agents know how to scaffold them.
They use placeholders for domain replacement.

### src/main/java/.../mcp/McpServerRunner.java

```
@Component
public class McpServerRunner implements CommandLineRunner {

    private final McpServerConfig config;

    public McpServerRunner(McpServerConfig config) {
        this.config = config;
    }

    @Override
    public void run(String... args) throws Exception {
        McpServer server = new McpServer(System.in, System.out);
        config.register(server);
        server.start();
    }
}
```

### src/main/java/.../mcp/McpServerConfig.java

```
@Component
public class McpServerConfig {

    private final List<McpTool> tools;
    private final List<McpResourceProvider> resources;
    private final List<McpPrompt> prompts;

    public McpServerConfig(
        List<McpTool> tools,
        List<McpResourceProvider> resources,
        List<McpPrompt> prompts
    ) {
        this.tools = tools;
        this.resources = resources;
        this.prompts = prompts;
    }

    public void register(McpServer server) {
        tools.forEach(server::registerTool);
        resources.forEach(server::registerResourceProvider);
        prompts.forEach(server::registerPrompt);
    }
}
```

### CRUD Tool Template

```
@Component
public class Create<Domain>Tool implements McpTool {
    @Override
    public String name() {
        return "create_<domain>";
    }

    @Override
    public McpResult execute(JsonNode input) {
        <Domain> obj = schemaValidator.validateAndConvert(input, <Domain>.class);
        <Domain> saved = service.create(obj);
        return McpResult.from(saved);
    }
}
```

---

# 8. Integration Test Template

```
@SpringBootTest
public class McpServerIntegrationTest {

    @Test
    void mcpServerBootsAndRegistersTools() {
        // validate tool list and capability response
    }
}
```

---

# Ready for Generation

This pattern is now fully defined and can be consumed by your Agentic AI Pipeline exactly like your other patterns.

If you want, I can now generate:

* The complete code files for every template
* The full Maven project starter (pom.xml, application.yml, metadata headers)
* A pattern-level README with example tool invocation
* A NestJS version of this MCP pattern using @modelcontextprotocol/server

Just tell me the next step.
