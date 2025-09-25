TASK 13 – Makefile for DB, Migrations, App, and Compose.task.md

Goal
Provide a single entry point for local dev and CI to manage Docker Compose services, database lifecycle, TypeORM migrations, and API app commands.

Context
Standardized targets reduce drift and make CI pipelines predictable. This task assumes the Compose files and envs from Task 12 and a TypeORM 0.3.x data source file in the API project.

Preconditions

* Task 12 completed (infra/docker-compose.yml, infra/.env, api/.env.local).
* TypeORM CLI available (dev dependency) in api package.
* Data source file exists at api/src/database/data-source.ts.
* Node 20+, Docker, and Docker Compose installed.

Outputs

* project_root/Makefile (top-level)

Authoritative template

File: project_root/Makefile

```
SHELL := /bin/bash

# Paths
ENV ?= infra/.env
COMPOSE := docker compose --env-file $(ENV) -f infra/docker-compose.yml
API_DIR := api
DATASOURCE := $(API_DIR)/src/database/data-source.ts

# Migration name (override: make migrate-generate NAME=add_customer_table)
NAME ?= migration

.PHONY: compose-up compose-down compose-logs \
        db-up db-down db-logs db-psql db-wait \
        api-dev api-build api-test \
        migrate-generate migrate-run migrate-revert \
        clean

## Docker Compose (full stack)
compose-up:
	$(COMPOSE) up -d

compose-down:
	$(COMPOSE) down -v

compose-logs:
	$(COMPOSE) logs -f

## Database-only shortcuts
db-up:
	$(COMPOSE) up -d db

db-down:
	$(COMPOSE) stop db

db-logs:
	$(COMPOSE) logs -f db

# Open psql in the db container using container env (POSTGRES_USER/POSTGRES_DB)
db-psql:
	$(COMPOSE) exec db psql -U $$POSTGRES_USER -d $$POSTGRES_DB

# Wait until Postgres is accepting connections
db-wait:
	until $(COMPOSE) exec db pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB >/dev/null 2>&1; do \
	  echo "Waiting for database..."; sleep 1; \
	done; echo "Database is ready."

## API app commands
api-dev:
	cd $(API_DIR) && npm run start:dev

api-build:
	cd $(API_DIR) && npm run build

api-test:
	cd $(API_DIR) && npm test

## TypeORM migrations (0.3.x)
migrate-generate:
	cd $(API_DIR) && npx typeorm migration:generate -d $(DATASOURCE) src/migrations/$(NAME)

migrate-run:
	cd $(API_DIR) && npx typeorm migration:run -d $(DATASOURCE)

migrate-revert:
	cd $(API_DIR) && npx typeorm migration:revert -d $(DATASOURCE)

## Clean untracked files (use with care)
clean:
	git clean -fdx
```

Steps

1. Create project_root/Makefile with the contents above.
2. Ensure infra/.env exists (from Task 12) and contains DB_USER, DB_PASSWORD, DB_NAME, DB_PORT, API_PORT; Compose maps them to container envs (POSTGRES_*).
3. Verify workflow:

    * make compose-up
    * make db-wait
    * make migrate-run
    * make api-dev
4. For new migrations, run make migrate-generate NAME=<descriptive_name> and commit the generated files under api/src/migrations.

Acceptance Criteria

* make compose-up brings the db container up; make db-wait completes when Postgres is ready.
* make migrate-run applies migrations using api/src/database/data-source.ts without additional flags.
* make api-dev starts the NestJS server and it can connect to the db started by Compose.
* All targets run without using default env fallbacks (no ${VAR:-...} constructs).
