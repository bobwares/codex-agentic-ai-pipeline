# TASK - Add Health Check E2E .http Test

Goal
Provide an `.http` file under `api/e2e` for manual and automated endpoint verification of the Health Check module.

Outputs

* File: `api/e2e/health.http`
  Contains ready-to-run REST Client requests to validate `/health`, `/health/live`, and `/health/ready` endpoints.

Preconditions

* Health module and controller already implemented and wired into `AppModule`.
* Server running locally at `http://localhost:3000`.
* VS Code REST Client extension or equivalent tool available for executing `.http` requests.

Steps

1. Create new file: `api/e2e/health.http`

File: api/e2e/health.http

```
### Health metadata endpoint
GET http://localhost:3000/health
Accept: application/json

### Liveness probe
GET http://localhost:3000/health/live
Accept: application/json

### Readiness probe
GET http://localhost:3000/health/ready
Accept: application/json
```

2. Run

* Start app with `npm run start:dev`.
* Open `api/e2e/health.http` in VS Code.
* Use REST Client (`Send Request`) or `curl` equivalent.

3. Verify

* `/health` responds with JSON containing `status: "ok"`, `service: "backend"`, version, commit, uptime, etc.
* `/health/live` responds with `{ "status": "ok" }`.
* `/health/ready` responds with `{ "status": "ok" }`.

Acceptance Criteria

* `.http` file exists in `api/e2e` directory.
* Manual execution confirms all endpoints return HTTP 200 with expected payloads.
* File can be committed as part of E2E test assets alongside Jest specs.
