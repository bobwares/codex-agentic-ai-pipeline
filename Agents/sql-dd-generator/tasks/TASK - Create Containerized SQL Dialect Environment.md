# TASK — Create Containerized SQL Dialect Environments

## Inputs

- SQL Dialect


Use the dialect list defined in the agent context (currently: `postgresql`, `mysql`, `mariadb`, `mssql`, `sqlite`, `duckdb`, `oracle`, `snowflake`, `bigquery`) to validate the input.


## Objective

Provision containerization assets that allow engineers to spin up local development instances for the inputted SQL dialect.

## Required Outputs

- generate the following assets under `project_root` for the selected SQL Dialect.

1. **Dockerfile**
    - Place at `project_root/docker/<dialect>/Dockerfile` (create the dialect-specific folder if it does not exist).
    - Base image MUST match the dialect engine or the closest officially supported image/emulator.
    - Include any dialect-specific initialization steps (plugins, extensions, entrypoint scripts) required for local development.
    - Use metadata headers that conform to project governance.

2. **docker-compose service definition**
    - Centralize all dialect services inside `project_root/docker-compose.yml` using distinct service names (e.g., `postgresql-db`, `mysql-db`, etc.).
    - Reference the dialect-specific Dockerfile via the `build` directive.
    - Expose default ports via `ports` mapping and declare `healthcheck` instructions whenever the engine supports them.
    - Mount any necessary initialization volumes (e.g., seed SQL scripts located in `project_root/db/<dialect>/init`).
    - Ensure services are isolated but may be run individually via compose profiles (define a profile per dialect).

3. **Environment variables file**
    - Provide `.env.<dialect>` files at the repository root containing sensible local defaults (username, password, database/schema names, host, port, version).
    - Include comments describing each variable and how to override them.
    - Add a top-level `.env.example` that documents the union of all variables and instructs users to copy values into dialect-specific files.

## Documentation Updates

- Update `README.md` (or the primary project documentation) with instructions on how to start, stop, and connect to each dialect using Docker Compose profiles and environment files.
- Document any limitations (e.g., when using community images or emulators such as DuckDB-in-container or BigQuery emulator).

## Constraints & Notes

- Do **not** generate the Dockerfiles, docker-compose content, or `.env` files within this task description; only define the requirements so future automation can produce them.
- When a dialect lacks an official Docker image (e.g., Snowflake, BigQuery), document the recommended local development strategy (emulator, mock, or omission) and structure the composed service accordingly (even if disabled by default).
- Ensure all new files include metadata headers per governance.
- Maintain idempotency: re-running this task should regenerate files without a manual cleanup.