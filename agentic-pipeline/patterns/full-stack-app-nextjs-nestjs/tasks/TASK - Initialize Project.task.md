TASK — Initialize a Node.js NestJS Backend 

Goal
Create a clean NestJS 11 project scaffold with your exact package.json and tsconfig.json, plus standard Nest config (nest-cli.json), ESLint, and .gitignore. Output runs with npm scripts, compiles TypeScript, and supports Jest.

Inputs (authoritative)

* package.json (exact content below)
* tsconfig.json (exact content below)
* nest-cli.json (exact) — collection preset and source root.&#x20;
* .eslintrc.js (exact content below)
* .gitignore (exact content below)
* .prettier (exact content below)
* jest.config.js

Preconditions

* Node.js 20 LTS installed
* npm available

Steps

1. Create project directory

* mkdir api && cd api
* git init (optional)

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
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
  await app.listen(3000);
}
bootstrap();
```

* Create src/app.module.ts:

```ts
import { Module } from '@nestjs/common';

@Module({
  imports: [],
})
export class AppModule {}
```

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


