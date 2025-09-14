# Ticket 04 – Persist Customer Data to PostgreSQL

**Description**  
Wire up your backend API to the PostgreSQL database defined in `project-root/db`. You will:

1. **Configure ORM**
    - Install and configure TypeORM (or Prisma) in `project_root/api`.
    - Point your ORM config to the connection settings in `project-root/db` (e.g. `db/.env` or `db/docker-compose.yml`).
2. **Define Entity**
    - Create `Customer` entity class (`project_root/api/src/customers/customer.entity.ts`) using decorators that match the JSON schema in `libs/domain/customer_domain.json`.
3. **Set Up Migrations**
    - Generate a migration to create the `customers` table with all schema fields.
    - Add migration scripts under `project_root/api/migrations/`.
4. **Repository & Service**
    - Inject the `CustomerRepository` into `CustomerService` instead of using in-memory data.
    - Ensure each CRUD method (`create()`, `findAll()`, etc.) uses the repository to persist/retrieve data.
5. **Database Lifecycle in Tests & CI**
    - Update your test setup (`project_root/api/test`) and CI workflow to:
        - Start a PostgreSQL instance (via Docker Compose from `project-root/db`).
        - Run migrations before executing tests.
    - Modify `customers.e2e-spec.ts` to verify persistence across requests.
6. **Documentation**
    - Update `project_root/api/README.md` with setup steps:
        - How to spin up the database (`db/docker-compose up -d`).
        - How to run migrations (`npm run typeorm:migration:run`).
        - How to run the server and tests.

**Acceptance Criteria**
- `project_root/api/src/ormconfig.ts` (or equivalent) loads DB settings from `project-root/db`.
- `Customer` entity exists with correct column definitions.
- At least one migration file creates the `customers` table.
- Application successfully connects and runs migrations on start.
- `CustomerService` methods persist and retrieve real data via the repository.
- E2E tests pass against a live PostgreSQL instance.
- CI pipeline brings up the DB, runs migrations, then tests without errors.
- Documentation in `project_root/api/README.md` covers database setup, migrations, and testing.
- Pull request opened on branch `task-04-persist-customer-data-postgres`.

**Inputs**
- Connection settings and Docker Compose in `project-root/db/`
- JSON schema: `libs/domain/customer_domain.json`
- Outputs from Task 03 (controllers, DTOs, service stubs)

**Expected Outputs**
- ORM configuration file under `project_root/api/src/`
- `Customer` entity class in `project_root/api/src/customers/`
- Migration scripts in `project_root/api/migrations/`
- Updated `CustomerService` using repository
- Revised E2E tests verifying persistence
- Updated CI workflow and README section  
