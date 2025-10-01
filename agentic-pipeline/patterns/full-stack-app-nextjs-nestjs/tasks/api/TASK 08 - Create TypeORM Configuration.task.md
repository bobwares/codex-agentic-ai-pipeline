# TASK 08 - Configure project for TypeORM.

## Purpose

Create a reproducible, environment-aware ORM configuration for a NestJS API using TypeORM v0.3.x. 

## Scope

- TypeORM only (v0.3.x). 
- PostgreSQL target. 
- No Prisma in this task.

## Inputs

Authoritative Paths:

* DataSource: project_root/api/src/database/data-source.ts
* Nest integration: project_root/api/src/app.module.ts (or app.module integration module)
* Entities: project_root/api/src/**/**.entity.ts
* Migrations (source): project_root/api/src/migrations/
* Migrations (runtime): project_root/api/dist/migrations/
* NPM scripts: project_root/api/package.json

## Expected Outputs

1. New: project_root/api/src/database/data-source.ts
2. Updated: project_root/api/src/app.module.ts
3. New: project_root/api/src/database/validate-connection.ts
4. Updated: project_root/api/package.json
5. Documentation snippet (README section) explaining how to build and run migrations.

## Acceptance Criteria

* AppDataSource.initialize() succeeds against the Docker PG from project-root/db.
* npm run typeorm\:migration\:run\:js applies migrations from dist/migrations without path errors.
* NestJS boot uses the same options as AppDataSource (no drift).
* synchronize is false.
* SSL behavior matches DATABASE\_SSL.
* Non-public schemas are honored (DATABASE\_SCHEMA).
* Scripts function in both dev (TS) and CI (JS built artifacts).

## Agent Steps

Step 1 — Collect Environment

* Read project_root/ai/context/.env.
* Validate required vars. If any missing, emit a remediation block listing missing names.

Step 2 — Install Dependencies (idempotent)

* Ensure api has: typeorm, reflect-metadata, pg, class-transformer, class-validator.
* Dev deps: ts-node, @types/node, typeorm-naming-strategies (optional but recommended).

Step 3 — Emit DataSource
Write project\_root/api/src/database/data-source.ts with the following properties:

* Loads dotenv from project\_root/ai/context/.env.
* Exposes AppDataSource: DataSource.
* Sets naming strategy to snake\_case (SnakeNamingStrategy) if package installed.
* entities: explicit imports of known entities; if none, default to a safe glob \['dist/**/\*.entity.js'] for runtime and \['src/**/\*.entity.ts'] for generation.
* migrations: \['dist/migrations/\*.js'] for runtime.
* synchronize: false.

Got it. Here are the artifacts again, now with proper metadata headers on each file:

---

### Step 1 

Update project_root/api/src/app.module.ts.

```ts
/**
 * App: {}
 * Package: api
 * File: src/app.module.ts
 * Version: 0.1.0
 * Author: Codex Agent
 * Date: {}
 * Description: Root NestJS module. Loads ConfigModule with env validation
 *              and integrates TypeORM with ConfigService values.
 */

import * as path from 'node:path';
import * as Joi from 'joi';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

const CONTEXT_ENV = path.resolve(__dirname, '.', '.env');

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: [CONTEXT_ENV, '.env'],
      validationSchema: Joi.object({
        DATABASE_HOST: Joi.string().required(),
        DATABASE_PORT: Joi.number().integer().required(),
        DATABASE_USERNAME: Joi.string().required(),
        DATABASE_PASSWORD: Joi.string().required(),
        DATABASE_NAME: Joi.string().required(),
        DATABASE_SCHEMA: Joi.string().required(),
        DATABASE_SSL: Joi.boolean().truthy('true').falsy('false').required(),
      }),
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('DATABASE_HOST'),
        port: config.get<number>('DATABASE_PORT'),
        username: config.get<string>('DATABASE_USERNAME'),
        password: config.get<string>('DATABASE_PASSWORD'),
        database: config.get<string>('DATABASE_NAME'),
        schema: config.get<string>('DATABASE_SCHEMA'),
        ssl: config.get<boolean>('DATABASE_SSL'),
        namingStrategy: new SnakeNamingStrategy(),
        synchronize: false,
        logging: false,
        entities: ['dist/**/*.entity.js', 'src/**/*.entity.ts'],
        migrations: ['dist/migrations/*.js'],
      }),
    }),
  ],
})
export class AppModule {}
```

### Step 2

Create project_root/api/src/database/data-source.ts

```ts
/**
 * App: {}
 * Package: api
 * File: src/database/data-source.ts
 * Version: 0.1.0
 * Author: Codex Agent
 * Date: {}
 * Exports: AppDataSource
 * Description: Minimal TypeORM DataSource config for CLI usage. Reads
 *              environment from process.env as populated by ConfigService/scripts.
 */

import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DATABASE_HOST,
  port: Number(process.env.DATABASE_PORT ?? 5432),
  username: process.env.DATABASE_USERNAME,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  schema: process.env.DATABASE_SCHEMA,
  ssl: process.env.DATABASE_SSL === 'true',
  namingStrategy: new SnakeNamingStrategy(),
  synchronize: false,
  logging: false,
  entities: ['dist/**/*.entity.js', 'src/**/*.entity.ts'],
  migrations: ['dist/migrations/*.js'],
});
```

### Step 3 

create project_root/api/src/database/validate-connection.ts.

```ts
/**
 * App: {}
 * Package: api
 * File: src/database/validate-connection.ts
 * Version: 0.1.0
 * Author: Codex Agent
 * Date: {}
 * Description: Connectivity smoke-test script for the DataSource.
 */

import { AppDataSource } from './data-source';

(async () => {
  try {
    const ds = await AppDataSource.initialize();
    await ds.query('SELECT 1');
    await ds.destroy();
    console.log('DB connection OK');
  } catch (e) {
    console.error('DB connection failed', e);
    process.exit(1);
  }
})();
```

### Step 4

Update project_root/api/package.json.

```json
{
  "_meta": {
    "app": "Customer Registration",
    "package": "api",
    "file": "package.json (scripts)",
    "version": "0.1.0",
    "author": "Codex Agent",
    "date": "2025-09-30",
    "description": "NPM scripts for building, validating, and running TypeORM migrations."
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",

    "db:validate": "dotenv -e ../ai/context/.env -e .env -- ts-node src/database/validate-connection.ts",

    "typeorm:migration:create": "dotenv -e ../ai/context/.env -e .env -- typeorm migration:create src/migrations/Manual",
    "typeorm:migration:generate": "dotenv -e ../ai/context/.env -e .env -- typeorm migration:generate src/migrations/Auto -d src/database/data-source.ts",

    "typeorm:migration:run": "dotenv -e ../ai/context/.env -e .env -- node --require ts-node/register ./node_modules/typeorm/cli.js migration:run -d src/database/data-source.ts",
    "typeorm:migration:revert": "dotenv -e ../ai/context/.env -e .env -- node --require ts-node/register ./node_modules/typeorm/cli.js migration:revert -d src/database/data-source.ts",

    "typeorm:migration:run:js": "dotenv -e ../ai/context/.env -e .env -- node ./node_modules/typeorm/cli.js migration:run -d dist/database/data-source.js",
    "typeorm:migration:revert:js": "dotenv -e ../ai/context/.env -e .env -- node ./node_modules/typeorm/cli.js migration:revert -d dist/database/data-source.js"
  }
}
```

