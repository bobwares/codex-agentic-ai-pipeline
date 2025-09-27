# Task — Generate DB Migration and README from JSON Schema

## Goal

Given an authoritative JSON Schema for a domain object, produce:

1. a deterministic SQL migration (TypeORM migration class) that creates/updates the relational schema; and
2. a concise README describing the schema, tables, columns, constraints, and how to run/revert the migration.

## Inputs (authoritative)

* `{{project_root}}/ai/context/domain/{{domain}}.schema.json` (Draft-07+ JSON Schema)
* `{{project_root}}/api/src/database/data-source.ts` (TypeORM DataSource)
* `{{project_root}}/.env` (DB connection variables used by the DataSource)
* Optional: `{{project_root}}/ai/context/migration/overrides/{{domain}}.overrides.json` (naming/DDL hints: tableName, pk, indexes, unique, enum strategy, timestamps, schema, precision/scale, text/varchar thresholds, onDelete/onUpdate)

## Preconditions

* Node.js 20 LTS installed
* TypeORM CLI available via `npx typeorm ...`
* DataSource references `.env` and resolves entities/migrations paths correctly


## Outputs

* `{{project_root}}/api/src/migrations/{{timestamp}}-{{domain}}.ts` (TypeORM Migration)
* `{{project_root}}/api/README.migrations/{{domain}}.md` (human-readable spec & runbook)
* `{{project_root}}/api/src/{{domain}}/entities/{{Domain}}.entity.ts` (optional; generated if missing and required for future diffs)
* `{{project_root}}/api/src/{{domain}}/entities/index.ts` (re-export, if created/updated)

## Directory Structure (authoritative)

* `project_root/`

    * `api/`

        * `src/`

            * `database/data-source.ts`
            * `migrations/`
            * `{{domain}}/entities/`
        * `README.migrations/`
    * `ai/context/`

        * `domain/{{domain}}.schema.json`
        * `migration/overrides/{{domain}}.overrides.json` (optional)
    * `.env`

## Acceptance Criteria

1. Migration file compiles, runs cleanly with `npx typeorm migration:run -d src/database/data-source.ts`, and is reversible with `migration:revert`.
2. DDL reflects the JSON Schema accurately:

    * Types mapped (string, number/integer with precision/scale, boolean, date/time, array/object via JSONB where appropriate).
    * Required fields ⇒ `NOT NULL`.
    * Primary key present; unique/index constraints honored (from overrides or `x-unique`, `x-index` hints).
    * Enum fields implemented per overrides (native enum or check constraint).
    * String length defaults and overrides applied.
3. Foreign keys defined when `$ref` or `x-foreignKey` hints are present (namespaced, deterministic constraint names).
4. README includes: source schema path, table/column matrix, constraints, indexes, enums, and step-by-step run/revert/tests.
5. Deterministic naming:

    * Tables: `snake_case plural` unless `overrides.tableName` is set.
    * Columns: `snake_case`.
    * Constraints/Indexes: `pk_<table>`, `fk_<table>__<ref_table>__<col>`, `uq_<table>__<col>`, `ix_<table>__<col>`.
6. No destructive changes without explicit override (`"mode": "allow_destructive": true`); otherwise migration must be additive.
7. Idempotence: `down()` fully reverts changes introduced by `up()` with correct drop order.

## Tooling Contracts (Agent Steps)

### Step 1 — Load Schema & Overrides

* Parse `{{domain}}.schema.json`.
* If present, merge `overrides` shallowly; `overrides` win.
* Validate minimal invariants: has `title` or `x-tableName`, at least one primary key strategy (`id` with uuid/serial or override).

### Step 2 — Derive Relational Model

* Determine table name:

    * `overrides.tableName` → else `kebab-case(schema.title || domain)` → `snake_case plural`.
* Field mapping rules (defaults, can be overridden):

    * `string`:

        * `format: "uuid"` → `uuid`.
        * `format: "date-time"` → `timestamptz`.
        * `format: "date"` → `date`.
        * `format: "email"` → `varchar(320)`.
        * otherwise `varchar(length)` where `length`:

            * `maxLength` if present and ≤ 1000,
            * else `text`.
    * `integer` → `integer` (or `bigint` via `x-sqlType`).
    * `number` → `numeric(precision,scale)` if `x-precision`/`x-scale`, else `double precision`.
    * `boolean` → `boolean`.
    * `array|object` → `jsonb`.
    * `enum` (via `enum` or `x-enum`) → native enum or check constraint per override.
* Required props ⇒ `NOT NULL`.
* Primary key:

    * If a property named `id` with `format: uuid` → `uuid` PK default `gen_random_uuid()` (or `uuid_generate_v4()` per environment).
    * Else use override `{ pk: ["field"] }` or composite PK list.
* Uniqueness & indexes:

    * From `x-unique: true` or `overrides.unique[]`.
    * From `x-index: true` or `overrides.indexes[]`.
* FKs:

    * From `x-foreignKey`: `{ column, refTable, refColumn, onDelete, onUpdate }`.
    * From `$ref` referencing other domains when override supplies mapping.

### Step 3 — Generate TypeORM Entity (optional but recommended)

* If file missing:

    * Create `{{Domain}}.entity.ts` with TypeORM decorators mapping derived columns and constraints.
    * Respect naming strategies; include `@Index`/`@Unique` decorators where applicable.

### Step 4 — Emit TypeORM Migration

* Create `api/src/migrations/{{timestamp}}-{{domain}}.ts` with class:

    * `up()`:

        * `CREATE TYPE` for enums (or add check constraints).
        * `CREATE TABLE` with columns, defaults, and `NOT NULL`.
        * `ALTER TABLE` add PK/UK/FK.
        * `CREATE INDEX` for secondary indexes.
    * `down()`:

        * Drop indexes, FKs, table, enum types (reverse order).
* Use deterministic names from Acceptance Criteria.
* Guard destructive operations unless `overrides.mode.allow_destructive = true`.

### Step 5 — README Generation

* Path: `api/README.migrations/{{domain}}.md`
* Contents:

    * Title: `{{Domain}} Migration`
    * Source schema path and git commit hash (if available).
    * Table summary and purpose.
    * Column table:

        * name, type, nullability, default, notes (format/index/unique/fk).
    * Constraints & indexes lists.
    * Enums (values and storage strategy).
    * Commands:

        * `cd {{project_root}}/api`
        * `npx typeorm migration:run -d src/database/data-source.ts`
        * `npx typeorm migration:revert -d src/database/data-source.ts`
    * Troubleshooting: common errors (missing extension for `uuid`, enum rename, locking).
    * Change log stub for future edits to this migration.

### Step 6 — Validation & Dry-Run

* Compile migration: `tsc -p tsconfig.json` (or `nest build` if applicable).
* Connect using DataSource; dry-run by running against a disposable database or transaction (if supported) and log generated DDL.
* Lint generated entity files (if emitted).

## Implementation Notes

* If the target DB is PostgreSQL, prefer:

    * UUID default: `gen_random_uuid()` with `pgcrypto` or `uuid-ossp` depending on stack.
    * Timestamps: `timestamptz` with `DEFAULT now()`.
* For other RDBMS, switch type mappings via override:

    * `overrides.adapter: "postgres" | "mysql" | "mariadb" | "mssql" | "oracle"`.
* Support string length heuristics:

    * `maxLength <= 255` → `varchar(maxLength)`.
    * `255 < maxLength <= 1000` → `varchar(1000)` unless override.
    * `> 1000` or unspecified → `text`.
* Deterministic timestamp: use UTC `YYYYMMDDHHmmss` in filename prefix.

## Example Commands (developer runbook)

From `{{project_root}}/api`:

* Generate class (this task writes file content; this is only to format name):
  `npx ts-node -e "console.log(new Date().toISOString().replace(/[-:TZ.]/g,''))"`
* Run migration:
  `npx typeorm migration:run -d src/database/data-source.ts`
* Revert last:
  `npx typeorm migration:revert -d src/database/data-source.ts`
* Show status:
  `npx typeorm migration:show -d src/database/data-source.ts`

## Hints in JSON Schema (optional vendor extensions)

Add any of the following to properties or root:

* `x-sqlType`: force exact column type (e.g., `"x-sqlType": "numeric(12,2)"`).
* `x-unique: true` or `x-unique: ["colA","colB"]`.
* `x-index: true` or object `{ name, using }`.
* `x-foreignKey`: `{ column, refTable, refColumn, onDelete, onUpdate }`.
* `x-default`: raw SQL default (e.g., `"x-default": "now()"`).
* `x-check`: check constraint expression.
* `x-enumName`: name for enum type.
* Root‐level `x-tableName`, `x-schema`, `x-pk: ["id"]`, `x-adapter`.

## Failure Modes & Safeguards

* If required fields are missing or no PK strategy is inferable, fail with actionable message and a suggested `overrides` snippet.
* If a destructive change is detected and `allow_destructive` is not enabled, emit an additive migration or abort with guidance.
* Validate that `down()` is the strict reverse of `up()`.

## Test Cases (minimum)

* Required vs optional column generation.
* Unique + index creation and naming.
* Enum creation and teardown.
* FK creation with cascade options.
* Re-run `migration:run` on an already-migrated DB is a no-op; `revert` cleanly rolls back.

## Deliverables Checklist

* [ ] `src/migrations/{{timestamp}}-{{domain}}.ts` present and compiles
* [ ] README with table/columns/constraints and runbook
* [ ] Optional entity emitted and exported
* [ ] Commands to run/revert verified locally
* [ ] No unintended destructive DDL unless explicitly allowed
