TASK 12 – Docker Compose for DB and API.task.md

Goal
Provide a reproducible local development stack that runs PostgreSQL and the NestJS API via Docker Compose.

Context
Subsequent tasks rely on a working database and reachable API. This task standardizes local startup and environment configuration without using default fallbacks in variable substitution.

Preconditions

* Docker and Docker Compose installed.
* API project exists at project_root/api with npm scripts (start, start:dev, build).
* No other process is listening on API_PORT or DB_PORT.

Outputs

* project_root/infra/docker-compose.yml
* project_root/infra/.env
* project_root/api/.env.local.example
* (Optional) project_root/api/Dockerfile for containerizing the API

Authoritative templates

File: project_root/infra/docker-compose.yml

```yaml
services:
  db:
    image: postgres:16
    container_name: api_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - "${DB_PORT}:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
      interval: 5s
      timeout: 5s
      retries: 10

  api:
    # Option A: build from local Dockerfile (preferred for parity)
    build:
      context: ../api
      dockerfile: Dockerfile
    # Option B (dev): run Node image and mount source (uncomment to use)
    # image: node:20
    # working_dir: /workspace
    # volumes:
    #   - ../api:/workspace
    # command: ["npm", "run", "start:dev"]
    env_file:
      - ../api/.env.local
    ports:
      - "${API_PORT}:3000"
    depends_on:
      db:
        condition: service_healthy

volumes:
  db_data:
```

File: project_root/infra/.env

```
# Database (Compose scope)
DB_USER=customer_service
DB_PASSWORD=customer_service
DB_NAME=customer_service
DB_PORT=5432

# API (host port mapping)
API_PORT=3000
```

File: project_root/api/.env.local.example

```
# API -> DB connection (inside Compose network)
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_USERNAME=${DB_USER}
DATABASE_PASSWORD=${DB_PASSWORD}
DATABASE_NAME=${DB_NAME}
DATABASE_SCHEMA=public
DATABASE_SSL=false
```

File: project_root/api/Dockerfile (optional but recommended)

```
# Simple production-ish image; adapt as needed
FROM node:20

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Expose Nest default port
EXPOSE 3000

# Use production start; for dev, prefer volume + start:dev in compose
CMD ["npm", "run", "start:prod"]
```

Steps

1. Create project_root/infra directory and add docker-compose.yml and .env exactly as above.
2. Add project_root/api/.env.local.example. Copy it to .env.local for local runs: cp .env.local.example .env.local.
3. If you want to build the API image, add the Dockerfile above under api/. Adjust compose (Option A) as shown.
4. From project_root, start the stack: docker compose --env-file infra/.env -f infra/docker-compose.yml up -d.
5. Verify health: curl [http://localhost:${API_PORT}/health](http://localhost:${API_PORT}/health) returns status ok.
6. To stop: docker compose --env-file infra/.env -f infra/docker-compose.yml down.

Acceptance Criteria

* docker compose up -d brings up db and api containers; db becomes healthy; api is reachable at [http://localhost:${API_PORT}](http://localhost:${API_PORT}).
* The API connects to Postgres using DATABASE_HOST=db and the credentials from infra/.env via api/.env.local.
* No default fallbacks (e.g., ${VAR:-foo}) are present in any env substitutions.
* Data persists across restarts via the named volume db_data.
