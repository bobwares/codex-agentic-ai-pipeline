### Task 09 – API Logging & Structured Request Tracing (NestJS built-in logger)

Goal
Provide correlation-friendly, JSON-structured logs using Nest’s `@nestjs/common` Logger (no pino/winston), including a per-request ID and latency.

Context

* Logs are copied into the repo after every Codex run; structure must be machine-searchable.
* Observability backends (Elastic/Grafana/CloudWatch) prefer JSON lines.

Acceptance Criteria

1. No third-party logger packages. Use Nest’s built-in `Logger` or a custom `LoggerService` derived from `ConsoleLogger`.
2. `RequestIdMiddleware` injects an `X-Request-Id` header (uuid v4) if absent.
3. `RequestContext` (AsyncLocalStorage) stores `requestId` and request start time per request.
4. `LoggingInterceptor` emits one JSON line on response completion with fields: `timestamp`, `level`, `context`, `method`, `url`, `statusCode`, `responseTimeMs`, `requestId`.
5. Errors are logged at `error` level with stack trace and `requestId`.
6. Config via env:

   * `LOG_LEVEL` in {`error`,`warn`,`log`,`debug`,`verbose`}.
   * `LOG_FORMAT` in {`json`,`text`}. In `json`, output one JSON line per record; in `text`, use `Logger` default formatting.
7. Unit tests assert a log entry contains `requestId` and `responseTimeMs`, and that `LOG_FORMAT=json` yields valid JSON.

Steps

1. Remove third-party logging deps (if present).

   * npm remove @nestjs/pino pino pino-pretty pino-http nestjs-winston winston
2. Create a lightweight logging infrastructure under `api/src/common/logging`:

   * `request-context.ts`: AsyncLocalStorage wrapper exposing `get()`/`run()` for `{ requestId: string; startHrTime: [number, number] }`.
   * `request-id.middleware.ts`: ensures `X-Request-Id` exists, seeds RequestContext.
   * `json-logger.service.ts`: extends `ConsoleLogger` or implements `LoggerService`. When `LOG_FORMAT=json`, serialize to JSON with stable keys; otherwise defer to base methods. Include `setLogLevels()` driven by `LOG_LEVEL`.
   * `logging.interceptor.ts`: measures latency with `process.hrtime.bigint()` or `process.hrtime()`, logs a structured line on success, and also in `catchError` path.
3. Wire up in `AppModule` and `main.ts`:

   * Register `RequestIdMiddleware` globally.
   * Provide `JsonLogger` as the app logger and pass levels via `NestFactory.create(AppModule, { logger: levels })`.
   * Register `LoggingInterceptor` globally.
4. Add environment toggles:

   * `.env`: `LOG_LEVEL=log`, `LOG_FORMAT=json` (dev may set `text`).
5. Unit tests:

   * Use `@nestjs/testing` to bootstrap the app with `LOG_FORMAT=json`; spy on `process.stdout.write` or the `JsonLogger` methods to assert a line includes `requestId` and valid JSON.
6. CI: archive `./logs/api-YYYYMMDD.log` (ensure the app writes logs to stdout; if you also tee to file, do so behind an env flag).

Reference Implementation (files)

File: `api/src/common/logging/request-context.ts`

```ts
import { AsyncLocalStorage } from 'node:async_hooks';

export type RequestContextStore = {
  requestId: string;
  startHrTime: [number, number];
};

const als = new AsyncLocalStorage<RequestContextStore>();

export const RequestContext = {
  run<T>(store: RequestContextStore, callback: () => T): T {
    return als.run(store, callback);
  },
  get(): RequestContextStore | undefined {
    return als.getStore();
  },
};
```

File: `api/src/common/logging/request-id.middleware.ts`

```ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { Request, Response, NextFunction } from 'express';
import { RequestContext } from './request-context';

@Injectable()
export class RequestIdMiddleware implements NestMiddleware {
  use(req: Request, _res: Response, next: NextFunction): void {
    const hdr = (req.headers['x-request-id'] as string | undefined) ?? randomUUID();
    req.headers['x-request-id'] = hdr;

    const start: [number, number] = process.hrtime();
    RequestContext.run({ requestId: hdr, startHrTime: start }, next);
  }
}
```

File: `api/src/common/logging/json-logger.service.ts`

```ts
import { ConsoleLogger, Injectable, LogLevel } from '@nestjs/common';
import { RequestContext } from './request-context';

type JsonLine = {
  timestamp: string;
  level: LogLevel;
  context?: string;
  message: string;
  requestId?: string;
  stack?: string;
  [k: string]: unknown;
};

const asBool = (v: string | undefined) => v === '1' || v?.toLowerCase() === 'true';
const isJson = () => (process.env.LOG_FORMAT ?? 'json').toLowerCase() === 'json';

@Injectable()
export class JsonLogger extends ConsoleLogger {
  override setLogLevels(levels: LogLevel[]) {
    super.setLogLevels(levels);
  }

  private write(level: LogLevel, message: unknown, context?: string, meta?: Record<string, unknown>, err?: unknown) {
    if (!isJson()) {
      super[level as 'log' | 'error' | 'warn' | 'debug' | 'verbose'](
        typeof message === 'string' ? message : JSON.stringify(message),
        err instanceof Error ? err.stack : undefined,
        context,
      );
      return;
    }

    const ctx = RequestContext.get();
    const line: JsonLine = {
      timestamp: new Date().toISOString(),
      level,
      context,
      message: typeof message === 'string' ? message : JSON.stringify(message),
      requestId: ctx?.requestId,
      ...(meta ?? {}),
    };
    if (err instanceof Error) line.stack = err.stack;
    process.stdout.write(`${JSON.stringify(line)}\n`);
  }

  override log(message: any, context?: string) {
    this.write('log', message, context);
  }
  override error(message: any, stackOrContext?: string, context?: string) {
    // Nest calls error(message, stack, context)
    const stack = stackOrContext && !context ? stackOrContext : undefined;
    const ctx = stack ? context : stackOrContext;
    this.write('error', message, ctx, undefined, stack ? new Error(stack) : undefined);
  }
  override warn(message: any, context?: string) {
    this.write('warn', message, context);
  }
  override debug(message: any, context?: string) {
    this.write('debug', message, context);
  }
  override verbose(message: any, context?: string) {
    this.write('verbose', message, context);
  }
}
```

File: `api/src/common/logging/logging.interceptor.ts`

```ts
import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable, tap, catchError, throwError } from 'rxjs';
import { RequestContext } from './request-context';
import { JsonLogger } from './json-logger.service';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  constructor(private readonly logger: JsonLogger) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const http = context.switchToHttp();
    const req = http.getRequest<Request & { originalUrl?: string }>();
    const res = http.getResponse<{ statusCode: number }>();

    return next.handle().pipe(
      tap(() => {
        this.emit(req.method, req.originalUrl ?? req.url, res.statusCode, undefined);
      }),
      catchError((err) => {
        this.emit(req.method, req.originalUrl ?? req.url, res.statusCode ?? 500, err);
        return throwError(() => err);
      }),
    );
  }

  private emit(method: string, url: string, statusCode: number, err?: unknown) {
    const ctx = RequestContext.get();
    const elapsed = ctx?.startHrTime
      ? Math.round(Number(process.hrtime(ctx.startHrTime)[1]) / 1e6 + process.hrtime(ctx.startHrTime)[0] * 1000)
      : undefined;

    const meta = {
      method,
      url,
      statusCode,
      responseTimeMs: elapsed,
    };

    if (err instanceof Error) {
      this.logger.error(
        `Request failed`,
        err.stack ?? undefined,
        'HTTP',
      );
      // Emit a structured line as well
      this.logger.log({ msg: 'request', ...meta }, 'HTTP');
    } else {
      this.logger.log({ msg: 'request', ...meta }, 'HTTP');
    }
  }
}
```

File: `api/src/app.module.ts` (excerpt)

```ts
import { Module, MiddlewareConsumer } from '@nestjs/common';
import { JsonLogger } from './common/logging/json-logger.service';
import { RequestIdMiddleware } from './common/logging/request-id.middleware';
// ...other imports

@Module({
  providers: [JsonLogger],
  exports: [JsonLogger],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RequestIdMiddleware).forRoutes('*');
  }
}
```

File: `api/src/main.ts` (excerpt – logger activation and interceptor)

```ts
import { NestFactory } from '@nestjs/core';
import { Logger, LogLevel, ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { JsonLogger } from './common/logging/json-logger.service';
import { LoggingInterceptor } from './common/logging/logging.interceptor';

async function bootstrap(): Promise<void> {
  const level = (process.env.LOG_LEVEL ?? 'log') as LogLevel;
  const levelsOrder: LogLevel[] = ['error', 'warn', 'log', 'debug', 'verbose'];
  const levels = levelsOrder.slice(0, levelsOrder.indexOf(level) + 1);

  const app = await NestFactory.create(AppModule, { logger: levels });
  const jsonLogger = app.get(JsonLogger);
  jsonLogger.setLogLevels(levels);

  app.useGlobalInterceptors(new LoggingInterceptor(jsonLogger));

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true, forbidNonWhitelisted: true }));

  await app.listen(Number(process.env.PORT ?? 3000));
}
bootstrap();
```

Environment

* `.env`

```
LOG_LEVEL=log
LOG_FORMAT=json
```

Tests (outline)

* `api/test/logging.e2e.spec.ts`:

   * Boot app with `LOG_FORMAT=json`.
   * Spy on `process.stdout.write` to capture lines during a simple `GET /health`.
   * Assert a captured line parses as JSON and includes `requestId` and `responseTimeMs`.
   * Force an error route and assert an `error` record with stack is produced.

CI

* Extend pipeline to `tee` stdout to `./logs/api-$(date +%Y%m%d).log` when running the app, or archive container logs after run.
