# Database AI Coding Agent Context

## Purpose

This document equips AI coding agents with the context, conventions, constraints, and prompt templates needed to generate, modify, and validate code in the /db directory reliably and consistently.

It includes specific instructions for converting JSON schemas into normalized SQL CREATE TABLE statements, ensuring database migrations, schemas, and seed scripts align with the project’s persistence layer requirements.


## Application Overview

The /db directory defines the persistence layer for the project, supporting a PostgreSQL database for the backend and frontend applications.

Key components include:

- Dockerfile: Configures the PostgreSQL container.
- docker-compose.yml: Defines services for local development.
- .env: Template for environment variables.
- migrations/: Timestamped, forward-only SQL migration scripts.
- scripts/schema/: Ordered DDL scripts for base schema.
- scripts/seed/: Idempotent scripts for seeding reference and sample data.

## Technology Stack

- Container: Docker (v24+) & Docker Compose (v2.x)
- Database: PostgreSQL (v16)
- Scripting: Bash for execution scripts
- Environment: Configured via .env
- example:
  POSTGRES_USER=postgres
  POSTGRES_PASSWORD=password
  POSTGRES_DB=customer_db


## Coding Style & Conventions

**Directory Layout**

- All database-related files reside in /db/.
- migrations/: Forward-only migration scripts (e.g., 20250610120000_add_table.sql).
- scripts/schema/: Ordered DDL scripts (e.g., 01_create_customers.sql).
- scripts/seed/: Idempotent seed scripts (e.g., 01_seed_customers.sql).


Example:

File: project_root/db/scripts/schema/01_create_customer.sql

```sql
CREATE TABLE IF NOT EXISTS customer (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
```

File: project_root/db/scripts/seed/01_seed_customer.sql

```sql
INSERT INTO customer (name)
VALUES ('Alice'), ('Bob')
ON CONFLICT DO NOTHING;
```
**Metadata Headers**

Every SQL and Bash script must include a metadata header.

Format:-- App: <project-name>
-- Package: db
-- File: <filename>
-- Version: 0.1.0
-- Author: AI Agent
-- Date: <YYYY-MM-DD>
-- Description: <Brief purpose of the script>


**Naming Conventions**

Schema Scripts: NN_<description>.sql (e.g., 01_create_customers.sql), where NN is a two-digit sequence.
Seed Scripts: NN_<description>.sql (e.g., 01_seed_customers.sql).
Use lowercase and underscores for slugs and descriptions.
For JSON-derived tables, use singular nouns (e.g., customer, order_item).


**Idempotency**

Seed scripts must use INSERT ... ON CONFLICT DO NOTHING.
DDL scripts must use CREATE TABLE IF NOT EXISTS or ALTER TABLE ... ADD COLUMN IF NOT EXISTS.
Migrations should check for existing objects to avoid errors.


**Testing**

Include SQL smoke tests as comments at the end of migration and seed scripts.
Example:-- Smoke test: SELECT COUNT(*) FROM customers WHERE archived = FALSE;

Validate migrations and seeds in CI using make db-test (see /db/Makefile).


**SQL Style**

Use uppercase for SQL keywords (e.g., SELECT, CREATE TABLE).
Align columns and constraints for readability.
Include indexes for frequently queried columns (e.g., CREATE INDEX ...).
For JSON-derived schemas, infer data types (e.g., VARCHAR, INT, DECIMAL) and add constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE).



## Architectural Constraints

**Environment Parity**

Local, CI, and production environments must use PostgreSQL v16.
Use the same docker-compose.yml configuration across environments.


**Forward-Only Migrations**

Never modify existing migration files; create new ones for changes.
Ensure migrations are safe to run sequentially.


**Secrets Management**

Store credentials in .env (e.g., DATABASE_URL=postgres://user:password@localhost:5432/mydb).
Never commit sensitive data to version control.


**CI Integration**

Migrations and seeds must execute non-interactively in CI pipelines.
Provide a Bash script (scripts/exec-all.sh) to run migrations and seeds sequentially.
Ensure scripts exit with appropriate status codes (0 for success, non-zero for failure).


**Isolation**

The PostgreSQL container exposes port 5432 only to localhost or Docker network.
Use environment variables to configure access (e.g., POSTGRES_HOST).


**Performance**

Add indexes for columns used in WHERE, JOIN, or ORDER BY clauses.
Normalize tables to reduce redundancy, especially for JSON-derived schemas.
Avoid complex triggers; prefer application-level logic.

## JSON to SQL Transformation

This section provides instructions for AI agents to convert JSON schemas into normalized PostgreSQL CREATE TABLE statements, inspired by AI2SQL’s JSON to SQL Transformer (https://ai2sql.io/json-to-sql-transformer). The goal is to generate robust, normalized schemas that handle nested objects, arrays, and relationships.

### Key Principles

**Automatic Schema Detection:**

Infer data types from JSON values (e.g., string → VARCHAR, number → INT or DECIMAL, boolean → BOOLEAN).
Identify primary keys (e.g., id fields) and foreign keys based on relationships.
Detect unique constraints for fields like email.


**Comprehensive JSON Support:**

Map nested objects to separate tables with foreign keys.
Convert arrays to related tables (e.g., order.items → order_items).
Handle multi-level nesting and circular references by normalizing into flat tables.


**Optimization**

Normalize to at least 3NF to reduce redundancy.
Generate indexes for frequently queried columns.
Use constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE) to ensure data integrity.


**Customization**

Use PostgreSQL v16 dialect.
Follow project naming conventions (singular table names, lowercase with underscores).
Allow de-normalization for simpler schemas if specified.


## Best Practices

**Prepare JSON Input**

- Ensure consistent key names (e.g., avoid mixing camelCase and snake_case).
- Validate JSON for completeness and correct structure.


**Optimize SQL Output**

- Use appropriate data types (e.g., DECIMAL(10,2) for prices).
- Add indexes for foreign keys and queryable fields.
- Include NOT NULL constraints where applicable.


**Validate Results**

- Test schemas in a staging database using docker-compose up -d db.
- Verify data integrity with smoke tests.
- Check relationships with sample queries (e.g., SELECT * FROM orders JOIN customers ON orders.customer_id = customers.customer_id).

**Tasks**

- project_root/db/tasks/TASK - DB - JSON to SQL Transformation.md
- project_root/db/tasks/TASK - DB - Seed Script.md


End of Document