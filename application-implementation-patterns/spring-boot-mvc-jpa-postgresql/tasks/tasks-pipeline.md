# Tasks

tasks are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/spring-boot-mvc-jpa-postgresql/tasks

# Tools

tools are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/spring-boot-mvc-jpa-postgresql/tools/


# Agentic Pipeline Flow

Execute the following Tasks:

turn 1

1. TASK 01 - Initialize Project.task.md

turn 2

1. TASK - Create Docker Compose for PostgreSQL.task.md
2. agent run sql-ddl-generator --dialect postgresql --schema-path session context: Persisted Data schema
3. TASK - Create Persistence Layer.task.md
4. TASK - Create REST Service.task.md