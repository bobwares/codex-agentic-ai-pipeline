### Task 03 – Implement Customer Domain CRUD Endpoints (*Ticket 03*)

| Field        | Value                                                   |
| ------------ | ------------------------------------------------------- |
| **Filename** | `Task 03 – Implement Customer Domain CRUD Endpoints.md` |
| **T-Ref**    | Ticket 03                                               |

**Goal**
Expose REST endpoints to Create, Read (list + single), Update, and Delete customers.

**Acceptance Criteria**

| Endpoint         | Method | Behaviour                                         |
| ---------------- | ------ | ------------------------------------------------- |
| `/customers`     | POST   | Creates customer, returns `201-Created` with body |
| `/customers`     | GET    | Returns paginated array                           |
| `/customers/:id` | GET    | Returns one or `404`                              |
| `/customers/:id` | PUT    | Full-update, idempotent                           |
| `/customers/:id` | DELETE | Soft-delete flag                                  |

* DTOs validated with `class-validator`.
* Controller annotated for Swagger.
* Unit tests cover service & controller happy-path + 400/404.

**Steps**

1. `nest g module customer && nest g controller customer && nest g service customer`.
2. Define `CreateCustomerDto`, `UpdateCustomerDto`.
3. Add mapping layer (Entity ↔ DTO).
4. Write Jest tests (use in-memory repo stub for now).

**DoD** – All tests green; OpenAPI shows the five routes.
