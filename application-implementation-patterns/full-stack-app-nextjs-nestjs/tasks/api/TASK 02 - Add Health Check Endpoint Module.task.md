# TASK 02 - Add Health Check Endpoint Module

Goal
Add a self-contained Health Check module to the existing NestJS 11 scaffold to provide liveness, readiness, and a rich service metadata endpoint.

Outputs
* create under project_root/api
* New module: src/health/health.module.ts
* New controller: src/health/health.controller.ts
* App wire-up: src/app.module.ts imports HealthModule
* Unit test: src/health/**tests**/health.controller.spec.ts
* E2E test config and spec (to satisfy `npm run test:e2e`): test/jest-e2e.json, test/health.e2e-spec.ts

Preconditions

* Project from “Initialize a Node.js NestJS Backend” task already created and installs/runs.
* No dependency changes required.

Steps

1. Create module
   File: src/health/health.module.ts

```ts
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';

@Module({
  controllers: [HealthController],
})
export class HealthModule {}
```

2. Create controller
   File: src/health/health.controller.ts

```ts
import { Controller, Get } from '@nestjs/common';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';

type HealthPayload = {
  status: 'ok';
  service: string;
  version: string | null;
  commit: string | null;
  pid: number;
  uptime: number;
  timestamp: string;
  memory: NodeJS.MemoryUsage;
};

function getPkgVersion(): string | null {
  try {
    const pkgPath = join(process.cwd(), 'package.json');
    const pkg = JSON.parse(readFileSync(pkgPath, 'utf8'));
    return typeof pkg?.version === 'string' ? pkg.version : null;
  } catch {
    return null;
  }
}

@Controller('health')
export class HealthController {
  @Get()
  health(): HealthPayload {
    return {
      status: 'ok',
      service: 'backend',
      version: getPkgVersion(),
      commit: process.env.COMMIT_SHA ?? null,
      pid: process.pid,
      uptime: Math.round(process.uptime()),
      timestamp: new Date().toISOString(),
      memory: process.memoryUsage(),
    };
  }

  @Get('live')
  liveness(): { status: 'ok' } {
    return { status: 'ok' };
  }

  @Get('ready')
  readiness(): { status: 'ok' } {
    return { status: 'ok' };
  }
}
```

3. Wire into app
   File: src/app.module.ts (import HealthModule and add to imports)

```ts
import { Module } from '@nestjs/common';
import { HealthModule } from './health/health.module';

@Module({
  imports: [HealthModule],
})
export class AppModule {}
```

4. Tests (optional but recommended)

File: src/health/**tests**/health.controller.spec.ts

```ts
import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from '../health.controller';

describe('HealthController', () => {
  let controller: HealthController;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
    }).compile();
    controller = module.get<HealthController>(HealthController);
  });

  it('GET /health returns status ok', () => {
    const res = controller.health();
    expect(res.status).toBe('ok');
    expect(res.service).toBe('backend');
  });

  it('GET /health/live returns ok', () => {
    expect(controller.liveness()).toEqual({ status: 'ok' });
  });

  it('GET /health/ready returns ok', () => {
    expect(controller.readiness()).toEqual({ status: 'ok' });
  });
});
```

File: test/jest-e2e.json

```json
{
  "moduleFileExtensions": ["js", "json", "ts"],
  "rootDir": "../",
  "testEnvironment": "node",
  "testRegex": ".e2e-spec.ts$",
  "transform": {
    "^.+\\.(t|j)s$": "ts-jest"
  }
}
```

File: test/health.e2e-spec.ts

```ts
import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Health E2E', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const modRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = modRef.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('/health (GET) -> 200', async () => {
    const res = await request(app.getHttpServer()).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
  });

  it('/health/live (GET) -> 200', async () => {
    const res = await request(app.getHttpServer()).get('/health/live');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });

  it('/health/ready (GET) -> 200', async () => {
    const res = await request(app.getHttpServer()).get('/health/ready');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});
```

Run

* npm run build
* npm run start\:dev
* curl [http://localhost:3000/health](http://localhost:3000/health)
* curl [http://localhost:3000/health/live](http://localhost:3000/health/live)
* curl [http://localhost:3000/health/ready](http://localhost:3000/health/ready)
* npm test
* npm run test\:e2e

Acceptance Criteria

* App compiles and starts with no errors.
* GET /health returns JSON including status: ok, service, version, commit, pid, uptime, timestamp, and memory.
* GET /health/live returns { status: "ok" }.
* GET /health/ready returns { status: "ok" }.
* Unit and E2E tests pass.
