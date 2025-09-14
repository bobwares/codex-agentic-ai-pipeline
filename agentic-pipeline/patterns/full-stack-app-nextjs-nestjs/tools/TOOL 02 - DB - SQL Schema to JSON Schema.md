# TASK 02 – DB – SQL → JSON Schema Transformation 

## Context

Convert the canonical SQL DDL in
`/db/migrations/01_<domain>.sql` into a normalized **Draft 2020-12 JSON Schema** file.

---

## Constraints

* **Target draft:** JSON Schema **Draft 2020-12**

* **Definitions** keyed by **singular** table names (e.g. `Customer`, `PostalAddress`)

* **SQL → JSON type mapping**

  | SQL type               | JSON Schema representation                         |
  |------------------------|----------------------------------------------------|
  | `UUID`                 | `"type": "string", "format": "uuid"`               |
  | `SERIAL` / integer PKs | `"type": "integer"`                                |
  | `VARCHAR(n)`           | `"type": "string", "maxLength": n`                 |
  | `CHAR(n)`              | `"type": "string", "minLength": n, "maxLength": n` |
  | `BOOLEAN`              | `"type": "boolean"`                                |

* **Required vs nullable** – any column declared `NOT NULL` must appear in the definition’s `"required"` array.

* **Primary keys** – record in both:

    * `"required"` array
    * `x-db.primaryKey`

* **Foreign keys** – capture under `x-db.foreignKey`, e.g.:

  ```json
  "x-db": {
    "foreignKey": { "column": "address_id", "ref": "PostalAddress.address_id" }
  }
  ```

* **Unique constraints** & **indexes** – list under `x-db.unique` and `x-db.indexes`.

* **Schema name** – add a root-level block:

  ```json
  "x-db": {
    "schema": "<domain>"
  }
  ```

  > **New requirement** ← ensures consumers know the exact PostgreSQL schema of all entities.

* **Output path**

  ```
  project_root/db/entity-specs/<domain>-entities.json
  ```

* **No file header** – emit *pure* JSON Schema (no Markdown, no comments).

---

## Inputs

| Item              | Value                                |
| ----------------- | ------------------------------------ |
| **Domain** | `<domain>` (e.g. `customer_profile`) |
| **SQL DDL**       | `/db/migrations/01_<domain>.sql`     |

---

## Output

A single file at `project_root/db/entity-specs/<domain>-entities.json`:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "<repo-root>/entity-specs/<domain>-entities.json",
  "title": "<domain> Domain Entities",
  "type": "object",
  "x-db": { "schema": "<domain>" },
  "definitions": {
    /* one definition per table */
  }
}
```

Each definition **must** include:

* `type`, `properties`, `required`
* `x-db.primaryKey`
* `x-db.foreignKey`
* `x-db.unique`
* `x-db.indexes`

---

## Task Steps

1. **Review** `/db/migrations/01_<domain>.sql`
   Identify tables, columns, constraints, and indexes.
2. **Parse** the DDL (script or parser) capturing:

    * Column name, data type, nullability
    * Primary-key, foreign-key, unique constraints
    * Explicit indexes
3. **Map** each table → JSON Schema definition:

    * Apply type mappings
    * Populate `"required"` from `NOT NULL` columns
    * Fill `x-db.*` sections
4. **Assemble** the final JSON document with the root-level `"x-db.schema"`.
5. **Validate** with a Draft 2020-12 linter (e.g. AJV).
6. **Record** any Architectural Decision Record (ADR) if mapping deviates from conventions.

---

## Acceptance Criteria

* `project_root/db/entity-specs/<domain>-entities.json` exists.
* JSON is valid Draft 2020-12 and passes `ajv validate`.
* All tables from the DDL are represented with correct types & required fields.
* Root-level `"x-db.schema"` matches the PostgreSQL schema name in the DDL.
* All PKs, FKs, uniques, and indexes are captured under `x-db.*`.
* File path and branch naming follow project standards.


## Example Execution 

**Inputs**

domain = customer_profile

SQL DDL =

```sql
-- App: Initial Full-Stack Application
-- Package: db
-- File: 20250610120000_create_customer_profile_tables.sql
-- Version: 0.1.0
-- Author: AI Agent
-- Date: 2025-06-10
-- Description: Creates the customer_profile schema and normalized tables.

BEGIN;

-- 1. Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS customer_profile;

-- 2. Work inside that schema for the rest of the script
SET search_path TO customer_profile, public;

/* ---------- Reference tables ---------- */
CREATE TABLE IF NOT EXISTS postal_address (
                                              address_id  SERIAL PRIMARY KEY,
                                              line1       VARCHAR(255) NOT NULL,
                                              line2       VARCHAR(255),
                                              city        VARCHAR(100) NOT NULL,
                                              state       VARCHAR(50)  NOT NULL,
                                              postal_code VARCHAR(20),
                                              country     CHAR(2)      NOT NULL
);

CREATE TABLE IF NOT EXISTS privacy_settings (
                                                privacy_settings_id      SERIAL  PRIMARY KEY,
                                                marketing_emails_enabled BOOLEAN NOT NULL,
                                                two_factor_enabled       BOOLEAN NOT NULL
);

/* ---------- Root entity ---------- */
CREATE TABLE IF NOT EXISTS customer (
                                        customer_id         UUID PRIMARY KEY,
                                        first_name          VARCHAR(255) NOT NULL,
                                        middle_name         VARCHAR(255),
                                        last_name           VARCHAR(255) NOT NULL,
                                        address_id          INT  REFERENCES postal_address(address_id),
                                        privacy_settings_id INT  REFERENCES privacy_settings(privacy_settings_id)
);

CREATE INDEX IF NOT EXISTS idx_customer_address_id
    ON customer (address_id);
CREATE INDEX IF NOT EXISTS idx_customer_privacy_settings_id
    ON customer (privacy_settings_id);

/* ---------- One-to-many collections ---------- */
CREATE TABLE IF NOT EXISTS customer_email (
                                              email_id    SERIAL PRIMARY KEY,
                                              customer_id UUID NOT NULL REFERENCES customer(customer_id) ON DELETE CASCADE,
                                              email       VARCHAR(255) NOT NULL,
                                              UNIQUE (customer_id, email)
);
CREATE INDEX IF NOT EXISTS idx_customer_email_customer_id
    ON customer_email (customer_id);

CREATE TABLE IF NOT EXISTS customer_phone_number (
                                                     phone_id    SERIAL PRIMARY KEY,
                                                     customer_id UUID NOT NULL REFERENCES customer(customer_id) ON DELETE CASCADE,
                                                     type        VARCHAR(20) NOT NULL,
                                                     number      VARCHAR(15) NOT NULL,
                                                     UNIQUE (customer_id, number)
);
CREATE INDEX IF NOT EXISTS idx_customer_phone_customer_id
    ON customer_phone_number (customer_id);

COMMIT;
```

**output**

File: project_root/db/entity-specs/customer_profile-entities.json

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "<repo-root>/entity-specs/customer_profile-entities.json",
  "title": "customer_profile Domain Entities",
  "type": "object",
  "x-db": { "schema": "customer_profile" },
  "definitions": {
    "PostalAddress": {
      "type": "object",
      "properties": {
        "address_id": { "type": "integer" },
        "line1":      { "type": "string", "maxLength": 255 },
        "line2":      { "type": "string", "maxLength": 255 },
        "city":       { "type": "string", "maxLength": 100 },
        "state":      { "type": "string", "maxLength": 50 },
        "postal_code":{ "type": "string", "maxLength": 20 },
        "country":    { "type": "string", "minLength": 2, "maxLength": 2 }
      },
      "required": [ "address_id", "line1", "city", "state", "country" ],
      "x-db": {
        "primaryKey": [ "address_id" ]
      }
    },

    "PrivacySettings": {
      "type": "object",
      "properties": {
        "privacy_settings_id":     { "type": "integer" },
        "marketing_emails_enabled":{ "type": "boolean" },
        "two_factor_enabled":      { "type": "boolean" }
      },
      "required": [
        "privacy_settings_id",
        "marketing_emails_enabled",
        "two_factor_enabled"
      ],
      "x-db": {
        "primaryKey": [ "privacy_settings_id" ]
      }
    },

    "Customer": {
      "type": "object",
      "properties": {
        "customer_id":         { "type": "string", "format": "uuid" },
        "first_name":          { "type": "string", "maxLength": 255 },
        "middle_name":         { "type": "string", "maxLength": 255 },
        "last_name":           { "type": "string", "maxLength": 255 },
        "address_id":          { "type": "integer" },
        "privacy_settings_id": { "type": "integer" }
      },
      "required": [ "customer_id", "first_name", "last_name" ],
      "x-db": {
        "primaryKey": [ "customer_id" ],
        "foreignKey": [
          { "column": "address_id",          "ref": "PostalAddress.address_id" },
          { "column": "privacy_settings_id", "ref": "PrivacySettings.privacy_settings_id" }
        ],
        "indexes": [
          [ "address_id" ],
          [ "privacy_settings_id" ]
        ]
      }
    },

    "CustomerEmail": {
      "type": "object",
      "properties": {
        "email_id":    { "type": "integer" },
        "customer_id": { "type": "string", "format": "uuid" },
        "email":       { "type": "string", "maxLength": 255 }
      },
      "required": [ "email_id", "customer_id", "email" ],
      "x-db": {
        "primaryKey": [ "email_id" ],
        "foreignKey": { "column": "customer_id", "ref": "Customer.customer_id" },
        "unique":     [ [ "customer_id", "email" ] ],
        "indexes":    [ [ "customer_id" ] ]
      }
    },

    "CustomerPhoneNumber": {
      "type": "object",
      "properties": {
        "phone_id":    { "type": "integer" },
        "customer_id": { "type": "string", "format": "uuid" },
        "type":        { "type": "string", "maxLength": 20 },
        "number":      { "type": "string", "maxLength": 15 }
      },
      "required": [ "phone_id", "customer_id", "type", "number" ],
      "x-db": {
        "primaryKey": [ "phone_id" ],
        "foreignKey": { "column": "customer_id", "ref": "Customer.customer_id" },
        "unique":     [ [ "customer_id", "number" ] ],
        "indexes":    [ [ "customer_id" ] ]
      }
    }
  }
}

```
