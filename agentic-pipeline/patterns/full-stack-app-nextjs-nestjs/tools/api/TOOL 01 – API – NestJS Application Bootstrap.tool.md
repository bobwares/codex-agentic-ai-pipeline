# TASK 01 – API – NestJS Source Scaffold (npm edition)

## Context

The repository root already contains:

| Asset                                | Notes                                                      |
| ------------------------------------ | ---------------------------------------------------------- |
| **Node**                             | 20 LTS installed on CI / dev machines                      |
| **npm**                              | v ≥ 10 with workspaces enabled                             |
| `package.json` / `package-lock.json` | Root-level; **do not modify**                              |
| `tsconfig.json`                      | Strict flags; shared by all workspace packages             |
| Tooling                              | ESLint, Prettier, Jest (unit + e2e), Husky, Commitlint     |
| CI                                   | `.github/workflows/ci.yml` (basic install + test pipeline) |

You must **not** run `nest new …` or scaffold another workspace.
Instead, create an **`api/` workspace package** containing the entire NestJS source tree and supporting assets that satisfy Mahmoud Saeed’s 2025 enterprise guide and V. Checha’s clean-architecture template.

---

## Constraints 

* **Framework** NestJS ^11
* **Package manager** npm workspaces (`api/` is its own workspace)
* **Clean-architecture** `core/`, `application/`, `infrastructure/`, `presentation/`
* **Modules** Config, Health, Auth, App
* **Persistence** TypeORM 0.3 (PostgreSQL default, SQLite in codex)
* **Environment files** `.env.{local,dev,stage,prod,codex}` + `.env.example`
* **Swagger** served at `/docs`, JWT bearer auth scheme
* **Docker** Multi-stage image + `docker-compose.yml` (API + Postgres)
* **Tests** ≥ 80 % Jest coverage enforced in CI
* **No edits outside** `api/` except Docker / CI assets and `.env*` files

---

## Deliverables (all new files)

```
api/
├── package.json               # workspace manifest (extends dependencies list above)
├── tsconfig.build.json
├── README.md
├── src/
│   ├── main.ts
│   ├── config/configuration.ts
│   ├── core/entities/user.entity.ts
│   ├── application/             # CQRS placeholders
│   ├── infrastructure/database/typeorm.config.ts
│   └── presentation/
│       ├── app.module.ts
│       ├── filters/http-exception.filter.ts
│       ├── health/   (controller & module)
│       └── auth/     (controller, service, module, strategy, guard)
├── test/
│   ├── unit/sample.spec.ts
│   └── e2e/health.e2e-spec.ts
├── db/migrations/01_initial_user.ts
docker/
└──   Dockerfile
docker-compose.yml
.env.example
.env.local
.env.dev
.env.stage
.env.prod
.env.codex
```

---

## Task Steps for the Coding Agent

1. **Create folder hierarchy** exactly as shown in *Deliverables*.
2. **Generate `api/package.json`**:

    * Set `"name": "@workspace/api"` (or similar) and `"private": true`.
    * Add the *Dependency Requirements* lists.
    * Define scripts: `dev`, `build`, `start`, `lint`, `test`, `test:e2e`, `migration:*`, `prepare`.
3. **Implement source code**

    1. `main.ts` – bootstrap, JSON logger, global validation, Swagger (`/docs`, JWT bearer).
    2. `presentation/app.module.ts` – import ConfigModule, TypeORM, HealthModule, AuthModule; register global filter.
    3. `infrastructure/database/typeorm.config.ts` – dynamic Postgres or in-memory SQLite when `NODE_ENV=codex`.
    4. `config/configuration.ts` – class-validator schema & factory.
    5. `core/entities/user.entity.ts` – minimal `User` class with audit fields.
    6. Auth stack – Passport + JWT strategy, guard, service, controller; **stub** login endpoint.
    7. Health endpoint – `GET /health` returns `{ status: 'ok' }`.
4. **Create TypeORM migration** `db/migrations/01_initial_user.ts` for `user` table.
5. **Write tests**

    * Unit test for `User` entity.
    * E2E test hitting `/health`.
6. **Provide environment files** – example plus four runtime variants & codex.
7. **Add Docker assets** – multi-stage `Dockerfile`; `docker-compose.yml` with Postgres + API.
8. **Update CI workflow** – ensure it runs `npm ci`, `lint`, `test`, `test:e2e`, `build` for the **api workspace**; optionally build the Docker image.
9. **Write `api/README.md`** describing local, codex, Docker, and CI usage.

---

## Acceptance Criteria

| Check              | Requirement                                                             |
| ------------------ | ----------------------------------------------------------------------- |
| **Local run**      | `npm run dev -w @workspace/api` → `/health` returns `200 {status:"ok"}` |
| **Codex mode**     | `NODE_ENV=codex npm run dev -w @workspace/api` uses SQLite              |
| **Swagger**        | Available at `/docs`; shows JWT bearer scheme                           |
| **Docker stack**   | `docker-compose up -d` starts API + Postgres; `/health` passes          |
| **Quality gates**  | ESLint clean; Jest coverage ≥ 80 %; Husky pre-commit enforces both      |
| **CI**             | Fresh clone + `npm ci` executes full pipeline successfully              |
| **Root isolation** | No existing root configs modified (except CI job steps & .env files)    |

---

## Example Execution

```bash
# install workspace deps
npm ci

# run API (Postgres)
npm run dev -w @workspace/api
curl http://localhost:3000/health        # → 200 { "status":"ok" }

# codex mode
NODE_ENV=codex npm run dev -w @workspace/api

# quality gates
npm run lint -w @workspace/api
npm test -w @workspace/api
npm run test:e2e -w @workspace/api

# container workflow
docker-compose up -d
curl http://localhost:3000/health
```

Fulfil all deliverables and criteria exactly as stated; do not invoke `nest new`.
