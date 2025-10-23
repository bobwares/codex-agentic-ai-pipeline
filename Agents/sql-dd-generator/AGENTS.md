# Agent Context


- Application Implementation Pattern: agents


# Agent Context Statement: SQL DDL Generator from JSON Schema

## Purpose

* Generate deterministic, production-ready SQL DDL for a specified SQL dialect from an input JSON Schema that models a data domain.

## Inputs

* json_schema: A JSON Schema Draft-07+ object describing entities (objects), fields (properties), types, required flags, enums, formats, and relationships (via $ref or custom annotations).
* config:

    * target_dialect: one of [postgresql, mysql, mariadb, mssql, sqlite, duckdb, oracle, snowflake, bigquery].
    * schema_name: optional (database schema/namespace; e.g., public for PostgreSQL, dataset for BigQuery).
    * naming_strategy: snake_case | camelCase | PascalCase | custom regex map.
    * id_strategy: identity | serial | uuid | bigint_sequence | vendor-specific (e.g., GENERATED ALWAYS AS IDENTITY).
    * null_default: default nullability if unspecified (nullable | not_null).
    * enum_strategy: native_enum | check_constraint | lookup_table (dialect-aware).
    * array_strategy: native_array | junction_table (dialect-aware).
    * string_strategy: map of format→type (e.g., email→citext/text, uuid→uuid/char(36)).
    * timestamps: emit created_at/updated_at columns and triggers if supported.
    * storage_options: per-dialect table/column options (e.g., ENGINE, COLLATE, PARTITION BY).
    * indexes: auto-indexes for FKs/unique fields (on | off).
    * if_exists/if_not_exists: guard semantics for CREATE/DROP.
    * emit_comments: include COMMENT ON statements or inline comments.
    * migration_mode: full_create | incremental_diff (requires prev_schema).

## Outputs

* ddl_script: Ordered SQL statements ready to run for the target dialect:

    * CREATE SCHEMA/Database or equivalent (if requested and supported).
    * CREATE TYPE / ENUM (or alternative) in correct dependency order.
    * CREATE TABLE statements with columns, PKs, FKs, UNIQUEs, CHECKs, DEFAULTs, NULL/NOT NULL, computed/identity definitions.
    * INDEX statements (including composite and partial where supported).
    * Auxiliary artifacts per dialect (sequences, clustered indexes, DISTRIBUTED BY/PARTITION BY, OPTIONS).
    * COMMENT statements for tables/columns/types if emit_comments=true.
    * In migration_mode=incremental_diff, ALTER statements with safe ordering.
* manifest:

    * dialect, version, generated_at (UTC ISO-8601), hash(json_schema), hash(config).
    * dependency_graph (types→tables→indexes).
    * assumptions and fallbacks applied.

* diagnostics:

    * warnings (e.g., lossy type coercions, unsupported formats).
    * errors (schema invalid, unsupported features for target dialect).

## Success Criteria

* Compiles without modification on the target dialect.
* Round-trippable: Re-running with identical inputs is idempotent (no-op in full_create guarded mode).
* Deterministic ordering for reproducible builds.
* Explicit handling (not silent drops) for features unsupported in the target dialect.

## Scope

* Translate JSON Schema constructs to relational DDL:

    * object → table
    * required → NOT NULL
    * string/integer/number/boolean/date/time/date-time/uuid/email/uri → dialect types via configurable mapping
    * enum → native ENUM or CHECK or lookup table (configurable)
    * array/object references → association tables or native arrays (configurable, dialect-aware)
    * $ref → FK inference (with configurable on_delete/on_update)
    * pattern/minLength/maxLength/minimum/maximum → CHECK constraints where feasible
* Optionally emit seed/enum lookup INSERTs if enum_strategy=lookup_table.

## Non-Goals

* DML beyond optional enum seed rows.
* ORM-specific artifacts (migrations for a specific framework) unless explicitly configured.
* Stored procedures/functions beyond minimal triggers for timestamps if requested.

Dialect Rules (high level)

* PostgreSQL: prefer GENERATED ... AS IDENTITY, uuid, jsonb, arrays, native enum; COMMENT ON supported.
* MySQL/MariaDB: AUTO_INCREMENT, json (no jsonb), enum (native), check constraints limited in older versions; engine/collation options.
* SQL Server: IDENTITY, unique identifier, nvarchar, computed columns (PERSISTED), clustered/non-clustered indexes.
* SQLite: type affinity rules; enforce constraints via CHECK; emulate enums; limited ALTER TABLE.
* DuckDB: good JSON, limited DDL extras; no sequences; consider CREATE TYPE ENUM.
* Oracle: identity columns, VARCHAR2, NUMBER, triggers optional; comments supported.
* Snowflake: VARIANT for JSON, sequences/identity, clustering keys; no native enum.
* BigQuery: dataset. Schema, STRUCT/ARRAY native; DDL differs (CREATE TABLE schema.col TYPE); keys and constraints are documentation only—emit as labels/comments and create pseudo-constraints via INFORMATION_SCHEMA notes if requested.

Mapping Strategy (defaults; override via config)

* JSON Schema type → SQL type:

    * string: varchar(255) unless format maps to text/citext/uuid/json/email/etc.
    * integer: bigint (if format=int64) else int
    * number: numeric(38, 9) default unless format=double/float
    * boolean: boolean/bit
    * object: table or json/jsonb (if denormalized=true)
    * array: junction table or native array (postgres/duckdb/bigquery)
    * date/time/date-time: date/time/timestamp(tz) per dialect
* required: NOT NULL; default: DEFAULT <value> when specified.
* relations: $ref or x-foreignKey annotation → FK with ON DELETE/UPDATE from config policy (restrict|cascade|set null).

Validation and Safety

* Validate input JSON Schema against Draft-07+ before generation.
* Report unsupported keywords per dialect.
* Ensure dependency-ordered emission: types → tables → constraints → indexes → comments.
* Guard destructive changes in migration_mode=incremental_diff (no drop without explicit allow_drop=true).
* Emit BEGIN/COMMIT or transactionless blocks depending on dialect capabilities.

Interface Contract

* Function: generate(sql_dialect, json_schema, config?) → { ddl_script, manifest, diagnostics }
* Determinism: same inputs produce byte-identical output.
* Large schema handling: topological sort; stable hashing for object IDs and relation names.

Naming Conventions

* Default snake_case for identifiers; pluralize table names; singularize type names.
* Length limits and quoting handled per dialect; auto-shorten with stable hash suffix if exceeded.
* Reserved word escaping per dialect.

Indexing Policy

* Auto-create indexes for:

    * primary keys
    * foreign keys
    * unique constraints (unique index where required by dialect)
    * frequently filtered fields via x-index or config.index_hints

Comments/Metadata

* Use title/description from JSON Schema for COMMENT statements.
* Preserve x- annotations (x-db-*, x-index, x-partition, x-distribution).

Testing and QA

* Emit a companion verification script (optional) that:

    * creates a temp database/schema
    * runs DDL
    * introspects information_schema/system catalogs
    * asserts expected shapes (tables, columns, types, constraints)
* Return machine-readable manifest to drive CI checks.

Error Handling

* Hard fail on invalid JSON Schema, missing $id for cross-refs, or circular refs without array/junction strategy.
* Degrade gracefully with warnings for lossy mappings; require explicit override to proceed.

Security/Compliance

* No execution of generated DDL—generation only.
* No PII inference; treat formats purely as type hints unless config flags enable privacy annotations.

Operational Notes

* Version the generator and include generator_version in manifest.
* Include a dialect version in manifest for compatibility tracking.
* Support dry-run (emit only diagnostics and a summarized plan).

## Acceptance Examples (abbreviated)

* Given an entity Customer with id (uuid, required), email (string, format=email, unique), createdAt (date-time)
* For PostgreSQL (enum_strategy=native_enum, timestamps=true), expect:

    * CREATE EXTENSION statements omitted unless configured.
    * CREATE TABLE with id uuid PRIMARY KEY DEFAULT gen_random_uuid() if configured; email citext UNIQUE NOT NULL if configured; created_at/updated_at with trigger if timestamps=true.
* For MySQL, expect AUTO_INCREMENT or UUID via char(36) + default function, and ENUM as native enum or CHECK fallback.

This statement defines the agent’s contract, behavior, and boundaries to ensure predictable, high-quality SQL DDL generation across multiple SQL dialects from JSON Schema inputs.
Agent Context Statement: SQL DDL Generator from JSON Schema


# Inputs

- domain_schema = json schema
- dialect = = valid(postgresql, mysql, mssql)