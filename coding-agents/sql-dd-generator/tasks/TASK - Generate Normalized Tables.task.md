# TASK Generate Normalized Tables from JSON Schema


## Context

Convert a JSON schema into normalized DDL SQL statements.  
Output Directory: `/db`

## Constraints**
- Use input dialect
- Normalize to at least 3NF
- Use singular table names (e.g., customer, order_item)
- Include indexes for foreign keys and queryable fields
- Use CREATE TABLE IF NOT EXISTS
- Follow project naming conventions
- Replace NN in a file path with incremented number. ie db/migrations/01_<domain>_.sql

## Inputs

- codex session context: Persisted Data schema

## Output

- A complete SQL file with metadata header, table definitions, foreign keys, and indexes.
- File path: db/migrations/NN_<domain>_.sql

## Task
Generate a migration in `db/migrations/NN_<schema title>_tables.sql` that:
- Creates normalized tables from the JSON schema referenced in Task.
- Infers data types and constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE)
- Maps nested objects ie (`customer`, `shipping_address`) to separate tables
- Converts arrays (`items`) to a related table
- Creates a flattened views of the domain.

## Workflow Outline

1. Review the DB task file to confirm conventions, timestamp rules, and required header fields.
2. Parse the customer JSON schema to derive an entity-relationship outline (e.g., `customer`, `customer_address`, `customer_contact`, etc.).
3. Draft SQL with all constraints and indexes (`btree` on foreign keys, `GIN` or `btree` on heavily-queried columns).

## Acceptance Criteria
* Expected Outputs were created.
* Each file contains a metadata header block.
* Uses `CREATE TABLE IF NOT EXISTS` statements valid for select dialect.
* Implements all keys, constraints, and indexes required by the JSON schema.
* Naming conventions, timestamp format, and directory layout match project standards.
* `project_root/db/README.md` gains a short “Domain Migration” section describing how to execute the migration and smoke tests locally.

# Example Execution

## Inputs

- codex session context: Persisted Data schema

## JSON Schema
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "CustomerProfile",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the customer profile"
    },
    "firstName": {
      "type": "string",
      "minLength": 1,
      "description": "Customer’s given name"
    },
    "middleName": {
      "type": "string",
      "description": "Customer’s middle name or initial",
      "minLength": 1
    },
    "lastName": {
      "type": "string",
      "minLength": 1,
      "description": "Customer’s family name"
    },
    "emails": {
      "type": "array",
      "description": "List of the customer’s email addresses",
      "items": {
        "type": "string",
        "format": "email"
      },
      "minItems": 1,
      "uniqueItems": true
    },
    "phoneNumbers": {
      "type": "array",
      "description": "List of the customer’s phone numbers",
      "items": {
        "$ref": "#/definitions/PhoneNumber"
      },
      "minItems": 1
    },
    "address": {
      "$ref": "#/definitions/PostalAddress"
    },
    "privacySettings": {
      "$ref": "#/definitions/PrivacySettings"
    }
  },
  "required": [
    "id",
    "firstName",
    "lastName",
    "emails",
    "privacySettings"
  ],
  "additionalProperties": false,
  "definitions": {

    "PhoneNumber": {
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "description": "Type of phone number",
          "enum": ["mobile", "home", "work", "other"]
        },
        "number": {
          "type": "string",
          "pattern": "^\\+?[1-9]\\d{1,14}$",
          "description": "Phone number in E.164 format"
        }
      },
      "required": ["type", "number"],
      "additionalProperties": false
    },
    "PostalAddress": {
      "type": "object",
      "properties": {
        "line1": {
          "type": "string",
          "minLength": 1,
          "description": "Street address, P.O. box, company name, c/o"
        },
        "line2": {
          "type": "string",
          "description": "Apartment, suite, unit, building, floor, etc."
        },
        "city": {
          "type": "string",
          "minLength": 1,
          "description": "City or locality"
        },
        "state": {
          "type": "string",
          "minLength": 1,
          "description": "State, province, or region"
        },
        "postalCode": {
          "type": "string",
          "description": "ZIP or postal code"
        },
        "country": {
          "type": "string",
          "minLength": 2,
          "maxLength": 2,
          "description": "ISO 3166-1 alpha-2 country code"
        }
      },
      "required": ["line1", "city", "state", "postalCode", "country"],
      "additionalProperties": false
    },
    "PrivacySettings": {
      "type": "object",
      "properties": {
        "marketingEmailsEnabled": {
          "type": "boolean",
          "description": "Whether the user opts in to marketing emails"
        },
        "twoFactorEnabled": {
          "type": "boolean",
          "description": "Whether two-factor authentication is enabled"
        }
      },
      "required": [
        "marketingEmailsEnabled",
        "twoFactorEnabled"
      ],
      "additionalProperties": false
    }
  }
}
````

**Expected Output

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







