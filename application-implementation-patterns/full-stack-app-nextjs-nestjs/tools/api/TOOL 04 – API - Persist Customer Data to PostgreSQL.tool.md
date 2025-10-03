### Task 04 – Persist Customer Data to PostgreSQL (*Ticket 04*)

| Field        | Value                                              |
| ------------ | -------------------------------------------------- |
| **Filename** | `Task 04 – Persist Customer Data to PostgreSQL.md` |
| **T-Ref**    | Ticket 04                                          |

**Goal**
Replace in-memory repository with Postgres persistence using the project’s ORM (TypeORM or Prisma—decide via ADR).

**Acceptance Criteria**

* Customer table mirrors DB DDL produced in db tasks.
* Repository implements CRUD with transactions.
* Integration tests spin up Postgres (Docker) and pass.

**Steps**

1. Choose ORM → write ADR.
2. Generate entity/model.
3. Implement `CustomerRepository`.
4. Add TypeORM migration or Prisma migration.
5. Extend CI with `docker-compose -f infra/db.yml up -d`.

**DoD** – `npm run test:e2e` connects to real Postgres and passes.
