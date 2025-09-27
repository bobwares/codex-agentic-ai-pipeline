# TASK 01 - Initialize Project.task


## Goal

Create a clean NestJS 11 project scaffold with your exact package.json and tsconfig.json, plus standard Nest config (nest-cli.json), ESLint, and .gitignore. Output runs with npm scripts, compiles TypeScript, and supports Jest.

## Output (authoritative)

- package.json (exact content below)
- tsconfig.json (exact content below)
- nest-cli.json (exact) — collection preset and source root.&#x20;
- .eslintrc.js (exact content below)
- .gitignore (exact content below)
- .prettier (exact content below)
- jest.config.js

## Preconditions

- Node.js 20 LTS installed
- npm available

## Steps

1. Create project directory

- mkdir api && cd api
- git init (optional)

2. Write files

File: package.json

```json
{
  "name": "backend",
  "version": "0.0.1",
  "description": "",
  "author": "",
  "private": true,
  "license": "UNLICENSED",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  },
  "dependencies": {
    "@nestjs/axios": "^4.0.0",
    "@nestjs/common": "^11.1.3",
    "@nestjs/config": "^4.0.2",
    "@nestjs/core": "^11.1.3",
    "@nestjs/platform-express": "^11.1.3",
    "@nestjs/swagger": "^11.2.0",
    "@nestjs/typeorm": "^11.0.0",
    "axios": "^1.9.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.2",
    "pg": "^8.16.0",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.2",
    "joi": "^17.10.0",
    "typeorm": "^0.3.24"
  },
  "devDependencies": {
    "@nestjs/cli": "^11.0.7",
    "@nestjs/schematics": "^11.0.5",
    "@nestjs/testing": "^11.1.3",
    "@types/express": "^5.0.3",
    "@types/jest": "^29.5.14",
    "@types/node": "^22.15.30",
    "@types/supertest": "^6.0.3",
    "@typescript-eslint/eslint-plugin": "^8.33.1",
    "@typescript-eslint/parser": "^8.33.1",
    "eslint": "^9.28.0",
    "eslint-config-prettier": "^10.1.5",
    "eslint-plugin-prettier": "^5.4.1",
    "prettier": "^3.5.3",
    "source-map-support": "^0.5.21",
    "supertest": "^7.1.1",
    "ts-jest": "^29.3.4",
    "ts-loader": "^9.5.2",
    "ts-node": "^10.9.2",
    "typescript": "^5.8.3"
  }
}
```

File: tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "CommonJS",
    "moduleResolution": "node",
    "rootDir": "src",
    "outDir": "dist",
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "skipLibCheck": true,
    "incremental": true,
    "tsBuildInfoFile": ".tsbuildinfo",
    "sourceMap": true
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist", "**/*.spec.ts"]
}
```

File: nest-cli.json

```json
{
  "collection": "@nestjs/schematics",
  "sourceRoot": "src"
}
```



File: .eslintrc.js

```js
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module'
  },
  plugins: ['@typescript-eslint', 'import'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:import/typescript',
    'plugin:import/recommended',
    'prettier'
  ],
  root: true,
  env: {
    node: true,
    jest: true
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off'
  }
};
```

File: .gitignore

```
# App: {{project.name}}
# Package: api
# File: .gitignore
# Version: 0.1.0
# Turns: 2
# Author: Codex Agent
# Date: 2025-09-20T04:22:15Z
# Exports: (ignore rules)
# Description: Ignore build artifacts, dependencies, and environment files for the API project.
/node_modules
/dist
/.env
/coverage
```

File: jest.config.js

```javascript

* @type {import('jest').Config}
*/
module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'node',
    roots: ['<rootDir>/src'],
    testMatch: ['**/__tests__/**/*.test.ts', '**/?(*.)+(spec|test).ts?(x)'],
    moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node']
};
```

3. Minimal source scaffold

* mkdir -p src
* Create src/main.ts:

```ts
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);

    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

    const config = app.get(ConfigService);
    const port = config.get<number>('app.port', 3000);

    await app.listen(port);
}
bootstrap();

```

* Create src/app.module.ts:

```ts
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import configuration from './config/configuration';
import { validationSchema } from './config/validation';

@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            envFilePath: ['.env'],
            load: [configuration],
            validationSchema
        })
    ]
})
export class AppModule {}

```

* Create src/config/configuration.ts (configuration factory; centralizes keys):

```typescript

export default () => ({
  app: {
    name: process.env.APP_NAME ?? 'backend',
    env: process.env.NODE_ENV ?? 'development',
    port: parseInt(process.env.PORT ?? '3000', 10)
  },
  // Example DB block – adapt later for TypeORM wiring
  db: {
    host: process.env.DATABASE_HOST,
    port: parseInt(process.env.DATABASE_PORT ?? '5432', 10),
    user: process.env.DATABASE_USER,
    pass: process.env.DATABASE_PASSWORD,
    name: process.env.DATABASE_NAME,
    schema: process.env.DATABASE_SCHEMA ?? 'public',
    ssl: (process.env.DATABASE_SSL ?? 'false').toLowerCase() === 'true'
  }
});

```

* Create src/config/validation.ts (Joi validation that fails fast on bad .env):

```ts
// src/config/validation.ts
import * as Joi from 'joi';

export const validationSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'test', 'production')
    .default('development'),

  APP_NAME: Joi.string().default('backend'),
  PORT: Joi.number().integer().min(1).max(65535).default(3000),

  DATABASE_HOST: Joi.string().hostname().required(),
  DATABASE_PORT: Joi.number().integer().min(1).max(65535).default(5432),
  DATABASE_USER: Joi.string().required(),
  DATABASE_PASSWORD: Joi.string().allow('').required(),
  DATABASE_NAME: Joi.string().required(),
  DATABASE_SCHEMA: Joi.string().default('public'),
  DATABASE_SSL: Joi.boolean().truthy('true').falsy('false').default(false)
});
```

* Create .env.example (checked into git; copy to .env locally):

```
# Application
APP_NAME=backend
NODE_ENV=development
PORT=3000

# Database (example: Postgres)
DATABASE_HOST=127.0.0.1
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=appdb
DATABASE_SCHEMA=public
DATABASE_SSL=false
```

* Create src/README-config.md (short developer note on usage):

```
# Config usage

1) Read values anywhere by injecting ConfigService:

import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class ExampleService {
  constructor(private readonly config: ConfigService) {}

  getDbHost(): string {
    return this.config.get<string>('db.host', '127.0.0.1');
  }
}

2) Add strongly-typed helpers if desired (create a config.types.ts and wrap lookups).
3) Validation lives in src/config/validation.ts; update when adding new env keys.
```

4. Install and verify

* npm install
* cp .env.example .env and adjust values
* npm run build
* npm run start:dev
* Open [http://localhost:3000](http://localhost:3000) (no routes yet; 404 is expected). Verify process started using PORT from .env. Try breaking .env (e.g., remove DATABASE_HOST) and confirm startup fails with a Joi validation error.

How to use ConfigService (in practice)

* Inject ConfigService into any provider/controller:

```ts
import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Controller('meta')
export class MetaController {
  constructor(private readonly config: ConfigService) {}

  @Get('env')
  env() {
    return {
      app: this.config.get('app.name'),
      env: this.config.get('app.env'),
      port: this.config.get('app.port')
    };
  }
}
```

* Derive typed accessors (optional pattern):

```ts
// src/config/config.selectors.ts
import { ConfigService } from '@nestjs/config';

export function getAppPort(config: ConfigService): number {
  return config.get<number>('app.port', 3000);
}
```

## Acceptance Criteria

* npm run build succeeds and emits dist.
* npm run start:dev starts a Nest app without configuration errors.
* The configuration layer is global via ConfigModule.forRoot({ isGlobal: true }).
* On startup, environment variables are validated by Joi; missing/invalid values fail fast with a clear message.
* main.ts binds the HTTP listener to ConfigService app.port (default 3000).
* ESLint runs with npm run lint.
* Formatting runs with npm run format.
* Jest runs with npm test (tests can be added later).
* .env.example is present and documents required keys.

## Deliverables

* Project folder containing the files above.
* Compilable NestJS 11 skeleton with your exact package.json and tsconfig.json.
* Global, validated configuration module with @nestjs/config and Joi, including a configuration factory and example usage.


4. Install and verify

* npm install
* npm run build
* npm run start\:dev
* Open [http://localhost:3000](http://localhost:3000) (no routes yet; 404 is expected)

Acceptance Criteria

* npm run build succeeds and emits dist.
* npm run start\:dev starts a Nest app without configuration errors.
* ESLint runs with npm run lint.
* Formatting runs with npm run format.
* Jest runs with npm test (you can add specs later).

Deliverables

* Project folder containing the files above.
* Compilable NestJS 11 skeleton with your exact package.json and tsconfig.json.
* ESLint and Prettier integrated; nest-cli.json aligned to src as source root.&#x20;


