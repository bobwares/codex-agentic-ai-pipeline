# tool – DB – Create Test Data for Schema

### Context

Create SQL statements to insert the initial set of data for the domain in to the SQL database.


- File location:** `db/scripts/<domain>_test_data.sql`
- Insert 20 sets domain objects**
- Idempotent** – use `INSERT … ON CONFLICT DO NOTHING`.
- Metadata header** (App, Package, File, Version, Author, Date, Description).
- Realistic sample data** (names + emails).
- Timestamps in UTC** (script comment or explicit `timezone` clause).
- Smoke-test query** that counts rows.
- Follow project SQL style conventions.

---

### Acceptance Criteria

* Script file exists at `project_root/db/scripts/<domain>_test_data.sql`.
* Header present and accurate.
* Exactly 20 `INSERT` rows, each idempotent.
* Script runs cleanly multiple times without duplicate rows.
* Smoke-test query present and returns **≥ 10** rows after first run.

---

### Example 

**Input**

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
**Output**

File: project_root/db/test/01_customer_domain_test_data.sql

```sql
-- App: Client Profile Module
-- Package: db
-- File: 01_customer_domain_test_data.sql
-- Version: 0.0.4
-- Author: Bobwares
-- Date: 2025-06-12T01:30:00Z
-- Description: Inserts sample customer domain data for testing purposes.
--
BEGIN;

-- Insert postal addresses
INSERT INTO postal_address (address_id, line1, line2, city, state, postal_code, country)
VALUES
    (1, '100 Market St', NULL, 'Springfield', 'IL', '62701', 'US'),
    (2, '200 Oak Ave', 'Apt 2', 'Madison', 'WI', '53703', 'US'),
    (3, '300 Pine Rd', NULL, 'Austin', 'TX', '73301', 'US'),
    (4, '400 Maple Ln', NULL, 'Denver', 'CO', '80014', 'US'),
    (5, '500 Cedar Blvd', 'Suite 5', 'Phoenix', 'AZ', '85001', 'US'),
    (6, '600 Birch Way', NULL, 'Portland', 'OR', '97035', 'US'),
    (7, '700 Walnut St', NULL, 'Boston', 'MA', '02108', 'US'),
    (8, '800 Chestnut Dr', NULL, 'Seattle', 'WA', '98101', 'US'),
    (9, '900 Elm Cir', NULL, 'Atlanta', 'GA', '30303', 'US'),
    (10, '1000 Ash Pl', NULL, 'Miami', 'FL', '33101', 'US')
ON CONFLICT DO NOTHING;

-- Insert privacy settings
INSERT INTO privacy_settings (privacy_settings_id, marketing_emails_enabled, two_factor_enabled)
VALUES
    (1, TRUE, FALSE),
    (2, FALSE, TRUE),
    (3, TRUE, TRUE),
    (4, FALSE, FALSE),
    (5, TRUE, FALSE),
    (6, FALSE, TRUE),
    (7, TRUE, TRUE),
    (8, FALSE, FALSE),
    (9, TRUE, FALSE),
    (10, FALSE, TRUE)
ON CONFLICT DO NOTHING;

-- Insert customers
INSERT INTO customer (customer_id, first_name, middle_name, last_name, address_id, privacy_settings_id)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'Alice', NULL, 'Smith', 1, 1),
    ('22222222-2222-2222-2222-222222222222', 'Bob', 'J', 'Jones', 2, 2),
    ('33333333-3333-3333-3333-333333333333', 'Charlie', NULL, 'Brown', 3, 3),
    ('44444444-4444-4444-4444-444444444444', 'David', 'K', 'Miller', 4, 4),
    ('55555555-5555-5555-5555-555555555555', 'Emma', NULL, 'Davis', 5, 5),
    ('66666666-6666-6666-6666-666666666666', 'Frank', NULL, 'Wilson', 6, 6),
    ('77777777-7777-7777-7777-777777777777', 'Grace', 'L', 'Taylor', 7, 7),
    ('88888888-8888-8888-8888-888888888888', 'Hugo', NULL, 'Anderson', 8, 8),
    ('99999999-9999-9999-9999-999999999999', 'Isabel', NULL, 'Thomas', 9, 9),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Jack', 'M', 'Jackson', 10, 10)
ON CONFLICT DO NOTHING;

-- Insert customer emails
INSERT INTO customer_email (customer_id, email)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'alice@example.com'),
    ('22222222-2222-2222-2222-222222222222', 'bob@example.com'),
    ('33333333-3333-3333-3333-333333333333', 'charlie@example.com'),
    ('44444444-4444-4444-4444-444444444444', 'david@example.com'),
    ('55555555-5555-5555-5555-555555555555', 'emma@example.com'),
    ('66666666-6666-6666-6666-666666666666', 'frank@example.com'),
    ('77777777-7777-7777-7777-777777777777', 'grace@example.com'),
    ('88888888-8888-8888-8888-888888888888', 'hugo@example.com'),
    ('99999999-9999-9999-9999-999999999999', 'isabel@example.com'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'jack@example.com')
ON CONFLICT DO NOTHING;

-- Insert phone numbers
INSERT INTO customer_phone_number (customer_id, type, number)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'mobile', '+15555550101'),
    ('22222222-2222-2222-2222-222222222222', 'mobile', '+15555550102'),
    ('33333333-3333-3333-3333-333333333333', 'mobile', '+15555550103'),
    ('44444444-4444-4444-4444-444444444444', 'mobile', '+15555550104'),
    ('55555555-5555-5555-5555-555555555555', 'mobile', '+15555550105'),
    ('66666666-6666-6666-6666-666666666666', 'mobile', '+15555550106'),
    ('77777777-7777-7777-7777-777777777777', 'mobile', '+15555550107'),
    ('88888888-8888-8888-8888-888888888888', 'mobile', '+15555550108'),
    ('99999999-9999-9999-9999-999999999999', 'mobile', '+15555550109'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'mobile', '+15555550110')
ON CONFLICT DO NOTHING;

COMMIT;
```