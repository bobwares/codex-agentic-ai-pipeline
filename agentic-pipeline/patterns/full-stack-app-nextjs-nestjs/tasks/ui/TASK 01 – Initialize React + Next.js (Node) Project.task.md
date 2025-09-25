# TASK 01 – Initialize React + Next.js (Node) Project

## Goal

Create a clean React + Next.js TypeScript project scaffold under `project_root/ui` that runs on Node.js 20 LTS with exact configuration files (`package.json`, `tsconfig.json`, `next.config.mjs`, ESLint, Prettier, `.gitignore`, Jest). Output runs with npm scripts, compiles TypeScript, supports unit tests with Jest, and includes a minimal API route.

## Inputs (authoritative)

* `package.json` (exact content below)
* `tsconfig.json` (exact content below)
* `next.config.mjs` (exact content below)
* `.eslintrc.js` (exact content below)
* `.prettier` (exact content below)
* `.gitignore` (exact content below)
* `jest.config.ts` (exact content below)
* `jest.setup.ts` (exact content below)

## Preconditions

* Node.js 20 LTS installed
* npm available

## Steps

### 1) Create project directory

```bash
mkdir -p project_root/ui
cd project_root/ui
git init  # optional
```

### 2) Write files

#### File: package.json

```json
{
  "name": "ui",
  "version": "0.0.1",
  "description": "React + Next.js TypeScript app",
  "author": "",
  "private": true,
  "license": "UNLICENSED",
  "engines": {
    "node": ">=20 <21",
    "npm": ">=10"
  },
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,js,jsx,json,md,css,scss}\"",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage"
  },
  "dependencies": {
    "next": "^14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@testing-library/jest-dom": "^6.6.3",
    "@testing-library/react": "^16.0.1",
    "@types/jest": "^29.5.14",
    "@types/node": "^22.5.4",
    "@types/react": "^18.3.5",
    "@types/react-dom": "^18.3.0",
    "eslint": "^9.8.0",
    "eslint-config-next": "^14.2.5",
    "eslint-config-prettier": "^10.1.0",
    "eslint-plugin-import": "^2.29.1",
    "jest": "^29.7.0",
    "prettier": "^3.3.3",
    "ts-jest": "^29.2.5",
    "typescript": "^5.5.4"
  }
}
```

#### File: tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["DOM", "ES2022"],
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "jsx": "preserve",
    "allowJs": false,
    "strict": true,
    "noEmit": true,
    "incremental": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "exactOptionalPropertyTypes": true,
    "types": ["jest", "node"]
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", "jest.setup.ts"],
  "exclude": ["node_modules"]
}
```

#### File: next.config.mjs

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: { typedRoutes: true },
  output: 'standalone'
};
export default nextConfig;
```

#### File: .eslintrc.js

```js
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: './tsconfig.json',
    tsconfigRootDir: __dirname
  },
  plugins: ['@typescript-eslint', 'import'],
  extends: [
    'next/core-web-vitals',
    'plugin:@typescript-eslint/recommended',
    'plugin:import/recommended',
    'plugin:import/typescript',
    'prettier'
  ],
  rules: {
    'import/order': [
      'warn',
      {
        groups: [['builtin', 'external'], ['internal'], ['parent', 'sibling', 'index']],
        'newlines-between': 'always'
      }
    ]
  },
  ignorePatterns: ['node_modules/', '.next/', 'out/']
};
```

#### File: .prettier

```json
{
  "printWidth": 100,
  "singleQuote": true,
  "trailingComma": "all",
  "semi": true
}
```

#### File: .gitignore

```gitignore
# App: {{project.name}}
# Package: ui
# File: .gitignore
# Version: 0.1.0
# Author: Codex Agent
# Description: Ignore build artifacts, dependencies, and environment files for the Next.js project.
node_modules/
.next/
out/
dist/
coverage/
.env
*.log
```

#### File: jest.config.ts

```ts
import type { Config } from 'jest';

const config: Config = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>'],
  testMatch: ['**/__tests__/**/*.test.ts?(x)', '**/?(*.)+(spec|test).ts?(x)'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx'],
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  collectCoverageFrom: [
    'app/**/*.{ts,tsx}',
    'components/**/*.{ts,tsx}',
    'lib/**/*.{ts,tsx}',
    '!**/node_modules/**',
    '!**/.next/**'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1'
  }
};

export default config;
```

#### File: jest.setup.ts

```ts
import '@testing-library/jest-dom';
```

### 3) Minimal source scaffold (Next.js App Router)

```bash
mkdir -p app/api/health
```

#### File: app/layout.tsx

```tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
```

#### File: app/page.tsx

```tsx
export default function HomePage() {
  return (
    <main>
      <h1>Next.js is running</h1>
    </main>
  );
}
```

#### File: app/api/health/route.ts

```ts
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({ status: 'ok', timestamp: new Date().toISOString() });
}
```

### 4) Optional: example unit test

#### File: **tests**/home.test.tsx

```tsx
import { render, screen } from '@testing-library/react';
import HomePage from '../app/page';

describe('HomePage', () => {
  it('renders heading', () => {
    render(<HomePage />);
    expect(screen.getByRole('heading', { name: /Next\.js is running/i })).toBeInTheDocument();
  });
});
```

### 5) Install and verify

```bash
cd project_root/ui
npm install
npm run typecheck
npm run build
npm run dev
# Visit:
# - http://localhost:3000            (Home page)
# - http://localhost:3000/api/health (JSON: { status: "ok", ... })

npm run lint
npm run format
npm test
```

## Acceptance Criteria

* `npm run build` completes without errors and emits a production build (`project_root/ui/.next`).
* `npm run dev` serves the app and the `/api/health` route returns a JSON payload.
* ESLint runs via `npm run lint` with the provided configuration.
* Prettier formats via `npm run format`.
* TypeScript type checks via `npm run typecheck`.
* Jest runs via `npm test` and the example test passes.

## Deliverables

* Project folder `project_root/ui/` containing all files above.
* Compilable Next.js TypeScript skeleton (React 18) with exact configuration files.
* ESLint and Prettier integrated; Next.js App Router with a minimal page and health API route.
* README.md instructions for starting ui and api for testing locally.
