# TASK 06 - Create TypeORM Configuration

## Purpose

Create a reproducible, environment-aware ORM configuration for a NestJS API using TypeORM v0.3.x. The agent must produce a single source of truth DataSource, integrate it with NestJS, wire migration scripts, and validate connectivity against the Dockerized PostgreSQL instance in project-root/db.

## Scope

TypeORM only (v0.3.x). PostgreSQL target. No Prisma in this task.

## Preconditions

* Node.js 20 LTS and npm available.
* Docker Compose stack defined under project-root/db (PostgreSQL service + .env).
* Project layout uses NestJS in project_root/api.
* Environment variables available via project\_root/ai/context/.env.
* DB uses snake_case everywhere

## Authoritative Paths

* DataSource: project\_root/api/src/database/data-source.ts
* Nest integration: project\_root/api/src/app.module.ts (or app.module integration module)
* Entities: project\_root/api/src/**/**.entity.ts
* Migrations (source): project\_root/api/src/migrations/
* Migrations (runtime): project\_root/api/dist/migrations/
* NPM scripts: project\_root/api/package.json

## Inputs

* DB environment: project\_root/ai/context/.env with:
  DATABASE\_HOST, DATABASE\_PORT, DATABASE\_USERNAME, DATABASE\_PASSWORD, DATABASE\_NAME, DATABASE\_SCHEMA, DATABASE\_SSL
* Existing entities (if any) under api/src/\*\*.entity.ts
* Docker Compose at project-root/db/docker-compose.yml

## Expected Outputs

1. data-source.ts exporting AppDataSource with:

    * type: postgres, env-driven connection, optional SSL, schema support
    * synchronize: false
    * entities: explicit imports or glob pattern
    * migrations: \['dist/migrations/\*.js']
2. package.json scripts for migration generate/run/revert (TS + JS variants).
3. NestJS integration that reuses the same options used by AppDataSource (no duplicate config).
4. A connection validation step that initializes the DataSource and runs a no-op query.
5. Documentation snippet (README section) explaining how to build and run migrations.

Acceptance Criteria

* AppDataSource.initialize() succeeds against the Docker PG from project-root/db.
* npm run typeorm\:migration\:run\:js applies migrations from dist/migrations without path errors.
* NestJS boot uses the same options as AppDataSource (no drift).
* synchronize is false.
* SSL behavior matches DATABASE\_SSL.
* Non-public schemas are honored (DATABASE\_SCHEMA).
* Scripts function in both dev (TS) and CI (JS built artifacts).

Agent Steps

Step 1 — Collect Environment

* Read project\_root/ai/context/.env.
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

Template (the agent must concretize imports and adjust paths to the repo):

```ts
/**
 * App: Customer Registration
 * Package: api
 * File: data-source.ts
 * Version: 0.1.3
 * Turns: 6
 * Author: Codex Agent
 * Date: 2025-09-24T23:05:00Z
 * Exports: AppDataSource, getDataSourceOptions
 * Description: Configures the shared TypeORM DataSource using environment variables sourced from project_root/api/.env.
 */
import 'reflect-metadata';
import * as path from 'node:path';
import * as dotenv from 'dotenv';
import { DataSource, DataSourceOptions } from 'typeorm';

// Load env from project_root/api/.env
const envPath = path.resolve(__dirname, '..', '..', '.env');
dotenv.config({ path: envPath });

function getEnv(name: string): string {
    const val = process.env[name];
    if (val === undefined || val === '') {
        throw new Error(
            `Database configuration is incomplete. Missing ${name}. Ensure it exists in ${envPath}`,
        );
    }
    return val;
}

function getBool(name: string): boolean {
    return getEnv(name).toLowerCase() === 'true';
}

function getInt(name: string, fallback?: number): number {
    const raw = process.env[name];
    if (raw === undefined || raw === '') {
        if (fallback !== undefined) return fallback;
        throw new Error(
            `Database configuration is incomplete. Missing ${name}. Ensure it exists in ${envPath}`,
        );
    }
    const n = Number(raw);
    if (Number.isNaN(n)) throw new Error(`Invalid integer for ${name}: "${raw}"`);
    return n;
}

export function getDataSourceOptions(): DataSourceOptions {

    const entities =  ['dist/**/*.entity.js'];
    const migrations = ['dist/migrations/*.js'];

    // Build with concrete types only (no string | undefined)
    const options: DataSourceOptions = {
        type: 'postgres',
        host: getEnv('DATABASE_HOST'),
        port: getInt('DATABASE_PORT', 5432),
        username: getEnv('DATABASE_USERNAME'),
        password: getEnv('DATABASE_PASSWORD'),
        database: getEnv('DATABASE_NAME'),
        // If you want schema optional instead of required, use the conditional block below.
        schema: getEnv('DATABASE_SCHEMA'),
        ssl: getBool('DATABASE_SSL'),
        entities,
        migrations,
        synchronize: false,
        logging: false,
    };

    return options;
}

/* If you prefer DATABASE_SCHEMA to be optional instead of required, replace the
   schema line above with this conditional block:

  const schema = process.env.DATABASE_SCHEMA;
  if (schema && schema !== '') {
    (options as any).schema = schema; // schema provided as concrete string
  }

*/

export const AppDataSource = new DataSource(getDataSourceOptions());

```

Step 4 — Wire NestJS to the Same Config
Update api/src/app.module.ts to reuse DataSource options (single source of truth):

```ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppDataSource } from './database/data-source';
// import { CustomersModule } from './customers/customers.module';

@Module({
  imports: [
    TypeOrmModule.forRoot(AppDataSource.options),
    // CustomersModule,
  ],
})
export class AppModule {}
```

Step 5 — Add NPM Scripts
Update api/package.json with TS and JS variants:

```json
{
  "scripts": {
    "typeorm:migration:generate": "typeorm migration:generate src/migrations/Auto -d src/database/data-source.ts",
    "typeorm:migration:create": "typeorm migration:create src/migrations/Manual",
    "typeorm:migration:run": "node --require ts-node/register ./node_modules/typeorm/cli.js migration:run -d src/database/data-source.ts",
    "typeorm:migration:revert": "node --require ts-node/register ./node_modules/typeorm/cli.js migration:revert -d src/database/data-source.ts",
    "typeorm:migration:run:js": "node ./node_modules/typeorm/cli.js migration:run -d dist/database/data-source.js",
    "typeorm:migration:revert:js": "node ./node_modules/typeorm/cli.js migration:revert -d dist/database/data-source.js"
  }
}
```

Step 6 — Connectivity Validation
Emit a small script api/src/database/validate-connection.ts:

```ts
import { AppDataSource } from './data-source';

(async () => {
  try {
    const ds = await AppDataSource.initialize();
    await ds.query('SELECT 1');
    await ds.destroy();
    // eslint-disable-next-line no-console
    console.log('DB connection OK');
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error('DB connection failed', e);
    process.exit(1);
  }
})();
```

Add an npm script: `"db:validate": "ts-node src/database/validate-connection.ts"`

Step 7 — README Snippet
Append to api/README.md:

* How to start DB: docker compose -f ../db/docker-compose.yml up -d
* Validate: npm run db\:validate
* Generate migration: npm run typeorm\:migration\:generate
* Build + run migrations (CI/prod): npm run build && npm run typeorm\:migration\:run\:js

Step 8 — CI Notes
In the pipeline job before tests:

* docker compose -f project-root/db/docker-compose.yml up -d
* npm ci && npm run build
* npm run typeorm\:migration\:run\:js
* npm test

Validation Checks (agent must enforce)

* Fail fast if any required DB env var is missing; print which.
* DataSource.migrations path resolves to dist/migrations/\*.js after build.
* synchronize is false.
* When DATABASE\_SCHEMA ≠ 'public', verify that new tables are created in that schema by running a smoke migration and querying information\_schema.tables.
* If DATABASE\_SSL=true, ensure pg SSL options are correctly applied (basic boolean accepted; advanced SSL config out of scope here).

Edge Cases

* No entities yet: ensure generate command doesn’t fail; allow manual migration create.
* Non-default port or host (Docker compose networks): host must match service name if running inside a container vs localhost outside.
* Local TS vs CI JS execution: both paths must work.

Deliverables

* data-source.ts ready for import by both NestJS and the TypeORM CLI.
* package.json scripts for migration lifecycle (TS + JS).
* validate-connection.ts script and npm run db\:validate.
* Updated app.module.ts that reuses AppDataSource.options.
* README section with exact commands.

Exit Criteria

* npm run db\:validate prints “DB connection OK”.
* npm run build && npm run typeorm\:migration\:run\:js completes without error against the Docker PG.
* Application boots with TypeOrmModule.forRoot(AppDataSource.options) and can resolve repositories for any existing entities.
