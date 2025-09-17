# TEST - TASK 02 – API – JSON Schema → NestJS Entity Generation

## Task Simulator

* simulate an ai coding agent. run test.

## Task to Test

# TASK 02 – API – JSON Schema → NestJS Entity Generation

**Context**
Generate TypeORM-based NestJS entity classes from an existing Draft 2020-12 JSON Schema that already mirrors the relational database design (produced by the DB tasks).
Directory: `/api`

**Goal**
For every definition in the JSON Schema, emit a fully annotated `*.entity.ts` class that:

* Compiles under NestJS v latest with TypeORM v0.3.x (the ORM declared in `package.json`).
* Reflects all columns, primary keys, indexes, unique constraints, and relations (one-to-one, one-to-many, many-to-one, many-to-many).
* Lives in `api/src/<domain>/entities/` using singular, Pascal-cased file & class names (`Customer.entity.ts`, `PostalAddress.entity.ts`, …).
* Includes the project’s standard metadata header (file path, version, author, date, description).

---

### Constraints

1. **Type Mappings**

   | JSON type / format             | TypeScript property type | TypeORM decorator                                           |
         | ------------------------------ | ------------------------ | ----------------------------------------------------------- |
   | `"integer"`                    | `number`                 | `@Column({ type: 'integer' })`                              |
   | `"string"`                     | `string`                 | `@Column({ type: 'varchar', length: n })`                   |
   | `"string"` + `"format":"uuid"` | `string`                 | `@PrimaryColumn('uuid')` or `@Column('uuid')` (see PK rule) |
   | `"boolean"`                    | `boolean`                | `@Column('boolean')`                                        |

2. **Primary Keys**

    * A column listed in `x-db.primaryKey` → `@PrimaryGeneratedColumn()` for serial/identity integers, else `@PrimaryColumn()` with explicit type.

3. **Foreign Keys & Relations**

    * For each `x-db.foreignKey` entry, add:

      ```ts
      @ManyToOne(() => <TargetEntity>, target => target.<reverseProperty>)
      @JoinColumn({ name: '<column>' })
      <property>: <TargetEntity>;
      ```
    * Add the primitive FK column (`@Column`) only if it is **not** already declared implicitly by `@JoinColumn`.

4. **Uniqueness & Indexes**

    * Use `@Unique()` at class level for composite uniques from `x-db.unique`.
    * Use `@Index()` for every array in `x-db.indexes`.

5. **Required vs. Nullable**

    * Properties absent from the schema’s `required` array must be marked `nullable: true` in the `@Column` options and optional (`prop?:`) in TypeScript.

6. **Naming**

    * Class = singular PascalCase of definition key.
    * Table name = snake\_case, configured with `@Entity({ name: '<snake_name>', schema: '<schema>' })`.

7. **Formatting**

    * All code must follow the project Prettier & ESLint rules and **PEP 8: E302** style for any Python snippets generated during testing (if applicable).
    * No emojis, icons, or extraneous formatting symbols.

---

### Inputs

* **Domain** – provided by the ticket invoking this task (e.g., `customer_profile`).
* **JSON Schema** – located at `project_root/db/entity-specs/<domain>-entities.json`.

---

### Output

* One `.entity.ts` file per schema definition, under `api/src/<domain>/entities/`.
* Each file contains:

    1. Standard metadata header (see other API tasks for template).
    2. Import statements (`Entity`, `Column`, `PrimaryGeneratedColumn`, `ManyToOne`, `OneToMany`, `JoinColumn`, `Unique`, `Index`, etc.).
    3. Decorated class per the mapping rules above.
    4. Stubbed reverse-relation arrays where relevant (e.g., `postalAddress.customers`).
    5. No runtime logic—data model only.

---

### Task

Generate the full set of NestJS/TypeORM entity classes for the supplied JSON Schema, adhering strictly to the **Constraints** above. Verify that the resulting project compiles (`npm run build`) and that the entities align 1-to-1 with the database schema (column names, types, nullability, keys, and relationships).

### Example Execution

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

**Expected Response**


### File: project_root/api/src/customers/entities/PostalAddress.entity.ts

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/PostalAddress.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: PostalAddress entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'postal_address', schema: 'customer_profile' })
export class PostalAddress {
  @PrimaryGeneratedColumn({ name: 'address_id', type: 'integer' })
  addressId: number;

  @Column({ name: 'line1', type: 'varchar', length: 255 })
  line1: string;

  @Column({ name: 'line2', type: 'varchar', length: 255, nullable: true })
  line2?: string;

  @Column({ name: 'city', type: 'varchar', length: 100 })
  city: string;

  @Column({ name: 'state', type: 'varchar', length: 50 })
  state: string;

  @Column({ name: 'postal_code', type: 'varchar', length: 20, nullable: true })
  postalCode?: string;

  @Column({ name: 'country', type: 'char', length: 2 })
  country: string;

  /* ---------- Reverse relations ---------- */

  @OneToMany(() => Customer, (customer) => customer.postalAddress)
  customers: Customer[];
}
```

---
### File: project_root/api/src/customers/entities/PrivacySettings.entity.ts

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/PrivacySettings.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: PrivacySettings entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'privacy_settings', schema: 'customer_profile' })
export class PrivacySettings {
  @PrimaryGeneratedColumn({
    name: 'privacy_settings_id',
    type: 'integer',
  })
  privacySettingsId: number;

  @Column({
    name: 'marketing_emails_enabled',
    type: 'boolean',
  })
  marketingEmailsEnabled: boolean;

  @Column({
    name: 'two_factor_enabled',
    type: 'boolean',
  })
  twoFactorEnabled: boolean;

  /* ---------- Reverse relations ---------- */

  @OneToMany(() => Customer, (customer) => customer.privacySettings)
  customers: Customer[];
}
```

---

### File: project_root/api/src/customers/entities/Customer.entity.ts

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/Customer.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: Customer entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { PostalAddress } from './PostalAddress.entity';
import { PrivacySettings } from './PrivacySettings.entity';
import { CustomerEmail } from './CustomerEmail.entity';
import { CustomerPhoneNumber } from './CustomerPhoneNumber.entity';

@Entity({ name: 'customer', schema: 'customer_profile' })
@Index(['addressId'])
@Index(['privacySettingsId'])
export class Customer {
  @PrimaryColumn('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'first_name', type: 'varchar', length: 255 })
  firstName: string;

  @Column({
    name: 'middle_name',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  middleName?: string;

  @Column({ name: 'last_name', type: 'varchar', length: 255 })
  lastName: string;

  /* ---------- Foreign-key columns ---------- */

  @Column({ name: 'address_id', type: 'integer', nullable: true })
  addressId?: number;

  @Column({ name: 'privacy_settings_id', type: 'integer', nullable: true })
  privacySettingsId?: number;

  /* ---------- Relations ---------- */

  @ManyToOne(() => PostalAddress, (address) => address.customers, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'address_id' })
  postalAddress?: PostalAddress;

  @ManyToOne(() => PrivacySettings, (ps) => ps.customers, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'privacy_settings_id' })
  privacySettings?: PrivacySettings;

  @OneToMany(() => CustomerEmail, (email) => email.customer)
  emails: CustomerEmail[];

  @OneToMany(
    () => CustomerPhoneNumber,
    (phone) => phone.customer,
  )
  phoneNumbers: CustomerPhoneNumber[];
}
```

---

### File: project_root/api/src/customers/entities/CustomerEmail.entity.ts

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/CustomerEmail.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: CustomerEmail entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'customer_email', schema: 'customer_profile' })
@Unique('UQ_customer_email', ['customerId', 'email'])
@Index('IDX_customer_email_customer', ['customerId'])
export class CustomerEmail {
  @PrimaryGeneratedColumn({ name: 'email_id', type: 'integer' })
  emailId: number;

  @Column('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'email', type: 'varchar', length: 255 })
  email: string;

  /* ---------- Relations ---------- */

  @ManyToOne(() => Customer, (customer) => customer.emails, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'customer_id' })
  customer: Customer;
}
```

---

### File: project_root/api/src/customers/entities/CustomerPhoneNumber.entity.ts

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/CustomerPhoneNumber.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: CustomerPhoneNumber entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'customer_phone_number', schema: 'customer_profile' })
@Unique('UQ_customer_phone_number', ['customerId', 'number'])
@Index('IDX_customer_phone_customer', ['customerId'])
export class CustomerPhoneNumber {
  @PrimaryGeneratedColumn({ name: 'phone_id', type: 'integer' })
  phoneId: number;

  @Column('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'type', type: 'varchar', length: 20 })
  type: string;

  @Column({ name: 'number', type: 'varchar', length: 15 })
  number: string;

  /* ---------- Relations ---------- */

  @ManyToOne(() => Customer, (customer) => customer.phoneNumbers, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'customer_id' })
  customer: Customer;
}
```

---

**Compilation check**

```bash
# From project_root/api
npm run build
```

## Inputs

File: **project\_root/db/entity-specs/customer\_profile-entities.json**

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
      "x-db": { "primaryKey": [ "address_id" ] }
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
      "x-db": { "primaryKey": [ "privacy_settings_id" ] }
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

## Assertion

Compare task output to the **Expected Results**. Determine if equal to expected results.

---

### Expected Results

File: **project\_root/api/src/customer\_profile/entities/PostalAddress.entity.ts**

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/PostalAddress.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: PostalAddress entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'postal_address', schema: 'customer_profile' })
export class PostalAddress {
  @PrimaryGeneratedColumn({ name: 'address_id', type: 'integer' })
  addressId: number;

  @Column({ name: 'line1', type: 'varchar', length: 255 })
  line1: string;

  @Column({ name: 'line2', type: 'varchar', length: 255, nullable: true })
  line2?: string;

  @Column({ name: 'city', type: 'varchar', length: 100 })
  city: string;

  @Column({ name: 'state', type: 'varchar', length: 50 })
  state: string;

  @Column({ name: 'postal_code', type: 'varchar', length: 20, nullable: true })
  postalCode?: string;

  @Column({ name: 'country', type: 'char', length: 2 })
  country: string;

  /* ---------- Reverse relations ---------- */

  @OneToMany(() => Customer, (customer) => customer.postalAddress)
  customers: Customer[];
}
```

---

File: **project\_root/api/src/customer\_profile/entities/PrivacySettings.entity.ts**

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/PrivacySettings.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: PrivacySettings entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  OneToMany,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'privacy_settings', schema: 'customer_profile' })
export class PrivacySettings {
  @PrimaryGeneratedColumn({
    name: 'privacy_settings_id',
    type: 'integer',
  })
  privacySettingsId: number;

  @Column({
    name: 'marketing_emails_enabled',
    type: 'boolean',
  })
  marketingEmailsEnabled: boolean;

  @Column({
    name: 'two_factor_enabled',
    type: 'boolean',
  })
  twoFactorEnabled: boolean;

  /* ---------- Reverse relations ---------- */

  @OneToMany(() => Customer, (customer) => customer.privacySettings)
  customers: Customer[];
}
```

---

File: **project\_root/api/src/customer\_profile/entities/Customer.entity.ts**

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/Customer.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: Customer entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { PostalAddress } from './PostalAddress.entity';
import { PrivacySettings } from './PrivacySettings.entity';
import { CustomerEmail } from './CustomerEmail.entity';
import { CustomerPhoneNumber } from './CustomerPhoneNumber.entity';

@Entity({ name: 'customer', schema: 'customer_profile' })
@Index(['addressId'])
@Index(['privacySettingsId'])
export class Customer {
  @PrimaryColumn('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'first_name', type: 'varchar', length: 255 })
  firstName: string;

  @Column({
    name: 'middle_name',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  middleName?: string;

  @Column({ name: 'last_name', type: 'varchar', length: 255 })
  lastName: string;

  /* ---------- Foreign-key columns ---------- */

  @Column({ name: 'address_id', type: 'integer', nullable: true })
  addressId?: number;

  @Column({ name: 'privacy_settings_id', type: 'integer', nullable: true })
  privacySettingsId?: number;

  /* ---------- Relations ---------- */

  @ManyToOne(() => PostalAddress, (address) => address.customers, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'address_id' })
  postalAddress?: PostalAddress;

  @ManyToOne(() => PrivacySettings, (ps) => ps.customers, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'privacy_settings_id' })
  privacySettings?: PrivacySettings;

  @OneToMany(() => CustomerEmail, (email) => email.customer)
  emails: CustomerEmail[];

  @OneToMany(
    () => CustomerPhoneNumber,
    (phone) => phone.customer,
  )
  phoneNumbers: CustomerPhoneNumber[];
}
```

---

File: **project\_root/api/src/customer\_profile/entities/CustomerEmail.entity.ts**

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/CustomerEmail.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: CustomerEmail entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'customer_email', schema: 'customer_profile' })
@Unique('UQ_customer_email', ['customerId', 'email'])
@Index('IDX_customer_email_customer', ['customerId'])
export class CustomerEmail {
  @PrimaryGeneratedColumn({ name: 'email_id', type: 'integer' })
  emailId: number;

  @Column('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'email', type: 'varchar', length: 255 })
  email: string;

  /* ---------- Relations ---------- */

  @ManyToOne(() => Customer, (customer) => customer.emails, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'customer_id' })
  customer: Customer;
}
```

---

File: **project\_root/api/src/customer\_profile/entities/CustomerPhoneNumber.entity.ts**

```ts
/* ============================================================
 * File: api/src/customer_profile/entities/CustomerPhoneNumber.entity.ts
 * Version: 0.1.0
 * Author: AI Coding Agent
 * Date: 2025-06-12
 * Description: CustomerPhoneNumber entity mapped from JSON Schema definition.
 * ============================================================ */

import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { Customer } from './Customer.entity';

@Entity({ name: 'customer_phone_number', schema: 'customer_profile' })
@Unique('UQ_customer_phone_number', ['customerId', 'number'])
@Index('IDX_customer_phone_customer', ['customerId'])
export class CustomerPhoneNumber {
  @PrimaryGeneratedColumn({ name: 'phone_id', type: 'integer' })
  phoneId: number;

  @Column('uuid', { name: 'customer_id' })
  customerId: string;

  @Column({ name: 'type', type: 'varchar', length: 20 })
  type: string;

  @Column({ name: 'number', type: 'varchar', length: 15 })
  number: string;

  /* ---------- Relations ---------- */

  @ManyToOne(() => Customer, (customer) => customer.phoneNumbers, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'customer_id' })
  customer: Customer;
}
```

---

**Compilation check**

```bash
# From project_root/api
npm run build
```

---

*The test passes if the AI coding agent generates all five entity files exactly as shown above and the project builds without TypeScript or ESLint errors.*
