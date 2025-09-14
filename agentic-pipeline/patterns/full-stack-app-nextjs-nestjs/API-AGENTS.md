# Backend AI Coding Agent (Codex) Context

## 1. Purpose

Provide Codex with all information needed to generate, modify, and validate back-end application code reliably and consistently. This document defines the project context, conventions, constraints, and prompt templates for the AI Coding Agent.

## 2. Application Overview

This is a NestJS + TypeScript REST API that connects to an ORM layer. Its responsibilities include:

* Defining controllers, services, and modules under `src/`
* Exposing CRUD endpoints over HTTP
* Interacting with the database via an ORM (e.g. TypeORM, Prisma)
* Validating input, handling errors, and returning structured responses

## 3. Technology Stack

**Runtime**

* Node.js (v20 or later)

**Language**

* TypeScript (v5.x or later)

**Framework**

* NestJS (latest stable)

**ORM**

* TypeORM or Prisma (refer to `package.json` for the chosen library)

**Testing**

* Jest
* .http files

## Directory Structure

```
project_root/api/
├── src/
│   ├── modules/           Feature modules (controllers, services, entities)
│   ├── common/            Shared utilities, filters, pipes, interceptors
│   ├── config/            Configuration loader and validation schemas
│   ├── main.ts            Application entry point
│   └── ...                Other application code
├── rest-tests/            .http files for testing REST endpoints.
├── package.json
├── tsconfig.json
└── README.md
```

## 4. Coding Style & Conventions

1. **Directory Layout**

   * All production code resides under `src/`.
   * Tests mirror the source structure under `src/` (unit tests) or in `__tests__/` (integration/e2e).

2. **Metadata Headers**
   Each source file must begin with a metadata header specifying application, package, file, version, author, date, and description.

   *Definition of metadata header section:*

   ```markdown
   # App: {{Application Name}}
   # Package: {{package}}
   # File: {{file name}}
   # Version: sematic versioning starting at 0.1.0
   # Author: {{author}}
   # Date: {Timestamp when the change was made}
   # Description:  level 5 documentation of the class or function.  Document each method or function in the file.  
   #
   ```

3. **Test-Driven Development (TDD)**

   * Write unit tests before implementation.
   * Name test files `<module>.test.ts`.
   * Place unit tests in the same directory as the source code being tested
   * Maintain a minimum 80% coverage.
   * npm run test
   * When creating new REST endpoints, create .http test for the resource.



4. **Use of Modern Language & Framework Features**

   * Use async/await, decorators, dependency injection, and pipe-based validation.
   * Leverage NestJS features: modules, controllers, providers, guards, interceptors, and filters.
   * Avoid deprecated APIs or experimental flags.
   * Update dependencies regularly for security and feature improvements.

5. **Documentation**

   * Maintain `project_root/api/README.md` with:

      * Overview and architecture
      * Setup and build instructions
      * API endpoint summary (e.g. Swagger/OpenAPI)
      * Instructions for running migrations and seeding data

## 5. Architectural Constraints

1. **Multi-Environment Support**

   * Environments: `local`, `dev`, `stage`, `prod`
   * Active environment specified via `APP_ENV` or `NODE_ENV`.

2. **Externalized & Validated Configuration**

   * All settings (database URLs, credentials, feature flags) from environment variables.
   * Validate on startup using a schema (e.g. Joi, Zod). Fail fast on missing/invalid values.

3. **Secret Management**

   * Retrieve sensitive values (DB passwords, JWT secrets) from a secure vault or secrets manager at runtime.
   * Never commit secrets to source control.

4. **Logging & Monitoring**

   * Configurable log levels via env var (`DEBUG`, `INFO`, `WARN`, `ERROR`).
   * Emit structured JSON logs.
   * Integrate with monitoring systems (e.g. Prometheus metrics, application performance tracing).

5. **Health Checks & Readiness**

   * Expose `/health` and `/ready` endpoints for liveness/readiness probes.
   * Health checks should verify DB connectivity and dependent services.

6. **API Documentation**

   * Generate OpenAPI (Swagger) docs via NestJS decorators.
   * Expose `/docs` or `/api-docs` endpoint in non-production environments.

7. **Error Handling & Validation**

   * Use global exception filters to format errors uniformly.
   * Validate request payloads with DTOs, Pipes, and class-validator.
   * Return clear, structured error responses with appropriate HTTP status codes.

8. **Twelve-Factor Compliance**

   * Strict separation of config from code.
   * Build once, deploy the same artifact across all environments.

9. **CI/CD & Migrations**

   * CI pipelines must run linting, tests, and build before merging.
   * Database migrations managed via CLI; run at deployment time.

10. **Secure Defaults**

   * Default to least-privilege database accounts.
   * Enforce HTTPS and CORS policies.
   * Sanitize all inputs to prevent injection attacks.

## 6. Agent Prompt Template

When crafting prompts for Codex, follow this structure:

### Context

```
<Brief summary of module or feature>
Tech: NestJS, TypeScript, [ORM]
Env: { APP_ENV = "<env>" }
DB: <database type and connection method>
```

### Task

```
<Clear instruction — e.g. “Create an endpoint GET /users that returns a paginated list of users…”>
```

### Constraints

- Place code under `src/users/`
- Prepend metadata header as specified
- Use DTO classes with validation decorators
- Write unit tests in `users.service.spec.ts` and `users.controller.spec.ts`


### Output Format

```
- Provide complete file content blocks (controllers, services, DTOs, tests)
- No explanatory text outside code fences
```

## 7. Sample Prompt

```
### Context
User management module to handle registration and retrieval.
Tech: NestJS, TypeScript, TypeORM
Env: { APP_ENV = "development" }
DB: PostgreSQL via TypeORM

### Task
Implement `users.controller.ts` and `users.service.ts` under `src/users/`:
- Controller: 
  - POST /users to create a user using `CreateUserDto`
  - GET /users to return paginated list
- Service:
  - `create()` and `findAll(page: number, limit: number)`
- Use TypeORM repository injection

### Constraints
- Prepend required metadata header
- DTO classes in `src/users/dto/`
- Validate input with class-validator
- Write tests in `users.service.spec.ts` and `users.controller.spec.ts`

### Output Format
- Three code fences: controller, service, DTOs plus two fences for tests
```

### Examples

File: package.json

```json
{
  "name": "backend",
  "version": "0.0.1",
  "description": "",
  "author": "Bobwares",
  "private": true,
  "license": "UNLICENSED",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  },
  "dependencies": {
    "@nestjs/axios": "^4.0.0",
    "@nestjs/common": "^11.1.3",
    "@nestjs/config": "^4.0.2",
    "@nestjs/core": "^11.1.3",
    "@nestjs/platform-express": "^11.1.3",
    "@nestjs/swagger": "^11.2.0",
    "@nestjs/typeorm": "^11.0.0",
    "axios": "^1.9.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.2",
    "pg": "^8.16.0",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.2",
    "typeorm": "^0.3.24"
  },
  "devDependencies": {
    "@nestjs/cli": "^11.0.7",
    "@nestjs/schematics": "^11.0.5",
    "@nestjs/testing": "^11.1.3",
    "@types/express": "^5.0.3",
    "@types/jest": "^29.5.14",
    "@types/node": "^22.15.30",
    "@types/supertest": "^6.0.3",
    "@typescript-eslint/eslint-plugin": "^8.33.1",
    "@typescript-eslint/parser": "^8.33.1",
    "eslint": "^9.28.0",
    "eslint-config-prettier": "^10.1.5",
    "eslint-plugin-prettier": "^5.4.1",
    "prettier": "^3.5.3",
    "source-map-support": "^0.5.21",
    "supertest": "^7.1.1",
    "ts-jest": "^29.3.4",
    "ts-loader": "^9.5.2",
    "ts-node": "^10.9.2",
    "typescript": "^5.8.3"
  }
}
```

File: main.ts

```typescript
/**
 * @application Job Search Backend
 * @source src/main.ts
 * @author
 * @version 1.0
 * @description Entry point of the Job Search Backend application. Sets up the NestJS server, configures CORS, and starts listening on the specified port.
 * @updated 2025-01-27
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  await app.listen(process.env.PORT || 3001);
}

bootstrap();
```

File: app.modules.ts

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CustomerModule } from './customers/customer.module';
import ormConfig from './ormconfig';

@Module({
  imports:
      [
        TypeOrmModule.forRoot(ormConfig),
        CustomerModule
      ],
})
export class AppModule {}

```

File: ormconfig.ts

```typescript
import { Customer } from './customers/customer.entity';
import { TypeOrmModuleOptions } from '@nestjs/typeorm';

import * as dotenv from 'dotenv';
dotenv.config();  

const databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl) {
  throw new Error('Environment variable DATABASE_URL must be defined');
}

const ormConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  url: databaseUrl,
  entities: [Customer]
};

export default ormConfig;
```

File: {{resource}}.controller.ts

```typescript
/**
 * @application Job Search Backend
 * @source src/jobsearch/controllers/jobs.controller.ts
 * @author bobwares codebot
 * @version 1.2
 * @description Controller for managing job-related endpoints, including searching and retrieving job details by ID.
 * @updated 2025-01-27
 */

import {
  Controller,
  Post,
  Get,
  Param,
  Body,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { JobsService } from '../services/jobs.service';
import { JobsBrowserService } from '../services/jobsBrowser.service';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';
import { SearchResultDto } from '../dto/search.result.dto';
import { SearchRequestDto } from '../dto/search.request.dto';
import { JobDto } from '../dto/job.dto';

@ApiTags('jobs')
@Controller('jobs')
export class JobsController {
  private readonly logger = new Logger(JobsController.name);

  constructor(
    private readonly jobsService: JobsService,
    private readonly jobsBrowserService: JobsBrowserService,
  ) {}

  /**
   * Search for jobs based on criteria.
   * @param searchRequest The search criteria including query and location.
   * @returns A SearchResult object containing jobs and pagination info.
   */
  @Post()
  @ApiOperation({ summary: 'Search for jobs based on criteria' })
  @ApiBody({ type: SearchRequestDto })
  @ApiResponse({
    status: 200,
    description: 'List of jobs with pagination metadata',
    type: SearchResultDto,
  })
  @ApiResponse({ status: 400, description: 'Invalid search criteria' })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async search(@Body() searchRequest: SearchRequestDto): Promise<SearchResultDto> {
    this.logger.log(
      `Received search request with query: ${searchRequest.query}, location: ${searchRequest.location}`,
    );
    try {
      const result = await this.jobsService.search(
        searchRequest.query,
        searchRequest.location,
      );
      this.logger.log(`Search request successful. Found ${result.count} jobs.`);
      return result;
    } catch (error) {
      this.logger.error('Error fetching jobs', error.stack || error);
      throw new HttpException(
        {
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          error: 'Failed to fetch jobs. Please try again later.',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  /**
   * Retrieve all available jobs.
   * @returns An array of JobDto objects representing all jobs.
   */
  @Get()
  @ApiOperation({ summary: 'Retrieve all available jobs' })
  @ApiResponse({
    status: 200,
    description: 'List of all jobs',
    type: [JobDto],
  })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getAllJobs(): Promise<JobDto[]> {
    this.logger.log('Retrieving all jobs');
    try {
      const jobs = await this.jobsBrowserService.getAllJobs();
      this.logger.log(`Successfully retrieved ${jobs.length} jobs.`);
      return jobs;
    } catch (error) {
      this.logger.error('Error retrieving all jobs', error.stack || error);
      throw new HttpException(
        {
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          error: 'Failed to retrieve jobs. Please try again later.',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  /**
   * Get job details by ID.
   * @param id The unique identifier of the job to retrieve.
   * @returns A JobDto object containing the job details.
   * @throws HttpException if the job is not found or if an error occurs.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get job details by ID' })
  @ApiResponse({
    status: 200,
    description: 'Job details for the given ID',
    type: JobDto,
  })
  @ApiResponse({ status: 404, description: 'Job not found' })
  @ApiResponse({ status: 500, description: 'Internal server error' })
  async getJobById(@Param('id') id: string): Promise<JobDto> {
    this.logger.log(`Fetching job by ID: ${id}`);
    try {
      const job = await this.jobsService.getJobById(id);
      if (!job) {
        this.logger.warn(`Job with ID ${id} not found.`);
        throw new HttpException(
          {
            status: HttpStatus.NOT_FOUND,
            error: `Job with ID ${id} not found.`,
          },
          HttpStatus.NOT_FOUND,
        );
      }
      this.logger.log(`Job with ID ${id} retrieved successfully.`);
      return job;
    } catch (error) {
      this.logger.error(`Error fetching job by ID ${id}`, error.stack || error);
      throw new HttpException(
        {
          status: HttpStatus.INTERNAL_SERVER_ERROR,
          error: 'Failed to fetch job details. Please try again later.',
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
```

File: {{entity}}.repository.ts

```typescript
/**
 * @application Job Search Backend
 * @source src/jobsearch/entities/JobDao.ts
 * @author bobwares codebot
 * @version 1.1
 * @description Repository class for managing job data, including creating, retrieving, and updating jobs and their providers.
 * @updated 2025-01-04
 */

import { Injectable, Logger } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Job } from '../entities/job.entity';
import { JobProvider } from '../entities/job-provider.entity';
import { JobDto } from '../dto/job.dto';

@Injectable()
export class JobDao {
  private readonly logger = new Logger(JobDao.name);

  constructor(
    @InjectRepository(Job)
    private readonly jobRepository: Repository<Job>,

    @InjectRepository(JobProvider)
    private readonly jobProviderRepository: Repository<JobProvider>,
  ) {}

  /**
   * Creates or updates a job along with its job providers.
   * @param jobDto The data transfer object containing job details.
   * @param query The search query that led to finding this job.
   * @param location The location filter used during the search.
   * @returns The created or updated job entity.
   */
  async createJob(
    jobDto: JobDto,
    query: string,
    location: string,
  ): Promise<Job> {
    try {
      const { jobProviders, ...jobData } = jobDto;

      this.logger.debug(
        `Attempting to create or update job with code: ${jobData.id}`,
      );

      const existingJob = await this.jobRepository.findOne({
        where: { code: jobData.id },
      });

      // If the job exists, update it
      if (existingJob) {
        this.logger.log(
          `Job with code ${jobData.id} already exists. Updating the job.`,
        );

        existingJob.title = jobData.title;
        existingJob.company = jobData.company;
        existingJob.description = jobData.description;
        existingJob.image = jobData.image;
        existingJob.location = jobData.location;
        existingJob.employmentType = jobData.employmentType;
        existingJob.datePosted = jobData.datePosted;
        existingJob.salaryRange = jobData.salaryRange;
        existingJob.jobProviders = jobProviders.map((provider) =>
          this.jobProviderRepository.create(provider),
        );

        await this.jobRepository.save(existingJob);
        this.logger.log(`Job with code ${jobData.id} has been updated.`);
        return existingJob;
      }

      // Otherwise, create a new job record
      const job = this.jobRepository.create({
        code: jobData.id,
        title: jobData.title,
        company: jobData.company,
        description: jobData.description,
        image: jobData.image,
        location: jobData.location,
        employmentType: jobData.employmentType,
        datePosted: jobData.datePosted,
        salaryRange: jobData.salaryRange,
        jobProviders: jobProviders.map((provider) =>
          this.jobProviderRepository.create(provider),
        ),
        search_query: query,
        search_location: location,
        applied: 'NO',
      });

      const createdJob = await this.jobRepository.save(job);
      this.logger.log(`Job with code ${jobData.id} has been created.`);
      return createdJob;
    } catch (error) {
      this.logger.error(
        `Error in createJob method at line ${error.stack
          .split('\n')[1]
          .trim()}`,
        {
          message: error.message,
          stack: error.stack,
        },
      );
      throw error;
    }
  }

  /**
   * Retrieves all jobs with their providers.
   * @returns An array of job entities.
   */
  async getAllJobs(): Promise<Job[]> {
    try {
      this.logger.debug('Fetching all jobs.');
      const jobs = await this.jobRepository.find({
        relations: ['jobProviders'],
      });
      this.logger.debug(`Found ${jobs.length} jobs.`);
      return jobs;
    } catch (error) {
      this.logger.error(
        `Error in getAllJobs method at line ${error.stack
          .split('\n')[1]
          .trim()}`,
        {
          message: error.message,
          stack: error.stack,
        },
      );
      throw error;
    }
  }

  /**
   * Retrieves a job by its ID (code).
   * @param id The unique code of the job to retrieve.
   * @returns The job entity if found, otherwise null.
   */
  async findJobById(id: string): Promise<Job | null> {
    this.logger.log(`Fetching job with ID: ${id}`);
    try {
      const job = await this.jobRepository.findOne({
        where: { code: id },
        relations: ['jobProviders'],
      });
      if (!job) {
        this.logger.warn(`Job with ID ${id} not found.`);
      } else {
        this.logger.log(`Job with ID ${id} retrieved successfully.`);
      }
      return job;
    } catch (error) {
      this.logger.error(
        `Error in findJobById method at line ${error.stack
          .split('\n')[1]
          .trim()}`,
        {
          message: error.message,
          stack: error.stack,
        },
      );
      throw error;
    }
  }
}
```

File: {{dto}}.dto.ts

```typescript
/**
 * @application Job Search Backend
 * @source src/jobsearch/dto/job.dto.ts
 * @author bobwares codebot
 * @version 1.3
 * @description Data Transfer Object for Job entities, encapsulating job details such as title, company, description, location, and providers.
 * @updated 2025-01-27
 */

import { JobProviderDto } from './job-provider.dto';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CreateDateColumn, UpdateDateColumn } from 'typeorm';

export class JobDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  company: string;

  @ApiProperty()
  description: string;

  @ApiPropertyOptional()
  image?: string;

  @ApiProperty()
  location: string;

  @ApiProperty()
  employmentType: string;

  @ApiProperty()
  datePosted: string;

  @ApiPropertyOptional()
  salaryRange?: string;

  @ApiProperty({ type: [JobProviderDto] })
  jobProviders: JobProviderDto[];

  @ApiProperty()
  @CreateDateColumn({
    name: 'created_at',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt?: Date;

  @ApiProperty()
  @UpdateDateColumn({
    name: 'updated_at',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
  })
  updatedAt?: Date;

  /**
   * Returns the string representation of the JobDto object.
   * @returns A formatted string containing job details such as ID, title, company, description, location, employment type, date posted, salary range, creation and update timestamps, and the number of job providers.
   */
  toString(): string {
    return `JobDto { 
      id: ${this.id || 'N/A'}, 
      title: ${this.title}, 
      company: ${this.company}, 
      description: ${this.description}, 
      image: ${this.image || 'N/A'}, 
      location: ${this.location}, 
      employmentType: ${this.employmentType}, 
      datePosted: ${this.datePosted}, 
      salaryRange: ${this.salaryRange || 'N/A'}, 
      createdAt: ${this.createdAt?.toISOString() || 'N/A'}, 
      updatedAt: ${this.updatedAt?.toISOString() || 'N/A'}, 
      jobProviders: ${this.jobProviders.length} provider(s)
    }`;
  }
}
```

File: {{resource}}.service.ts

```typescript
/**
 * @application Job Search Backend
 * @source src/jobsearch/services/jobs.service.ts
 * @author
 * @version 1.2
 * @description Service for managing job-related operations, including searching and fetching job details by ID.
 * @updated 2025-01-27
 */

import { Injectable, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { lastValueFrom } from 'rxjs';
import { SearchResultDto } from '../dto/search.result.dto';
import { ConfigService } from '@nestjs/config';
import { JobDao } from '../dao/job.dao';
import { JobDto } from '../dto/job.dto';

interface Job {
  id: string;
  title: string;
  company: string;
  description: string;
  image: string;
  location: string;
  employmentType: string;
  datePosted: string;
  salaryRange: string;
  jobProviders: { jobProvider: string; url: string }[];
}

interface JobsApiResponse {
  jobs: Job[];
  nextPage: string;
}

@Injectable()
export class JobsService {
  private readonly logger = new Logger(JobsService.name);

  private readonly url = 'https://jobs-api14.p.rapidapi.com/v2/list';
  private readonly headers = {
    'x-rapidapi-host': 'jobs-api14.p.rapidapi.com',
    'x-rapidapi-key': this.configService.get<string>('RAPIDAPI_KEY'),
  };

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
    private readonly jobDao: JobDao,
  ) {
    this.logger.log('Initializing JobsService');
    this.logger.debug(
      `RapidAPI Key Exists: ${!!this.headers['x-rapidapi-key']}`,
    );
  }

  /**
   * Searches for jobs based on the provided query and location.
   * @param query The search query string.
   * @param location The location filter for the job search.
   * @returns A SearchResult object containing an array of JobDto and pagination info.
   * @throws HttpException if there is an error fetching jobs from the API.
   */
  async search(
    query = 'Software Engineer javascript',
    location = 'remote',
  ): Promise<SearchResultDto> {
    this.logger.log(
      `Searching jobs with query: ${query}, location: ${location}`,
    );
    try {
      const jobs: Job[] = [];
      let currentNextPage: string | null = null;

      /**
       * Use a do-while loop so the fetch runs at least once.
       * Fetch subsequent pages only if `nextPage` is returned.
       */
      do {
        const params: any = { query, location };
        if (currentNextPage) {
          params.nextPage = currentNextPage;
          this.logger.log(`Using next page token: ${currentNextPage}`);
        }

        this.logger.debug('Preparing API request', { params });

        const response = await lastValueFrom(
          this.httpService.get<JobsApiResponse>(this.url, {
            params,
            headers: this.headers,
          }),
        );

        const data = response.data;
        this.logger.log(`Received jobs data with ${data.jobs.length} jobs`);

        // Collect jobs from this response
        jobs.push(...data.jobs);

        // Update nextPage for the next iteration
        currentNextPage = data.nextPage || null;
      } while (currentNextPage);

      // Build the SearchResult object
      const searchResult = new SearchResultDto();
      searchResult.jobs = jobs.map((job) => ({
        id: job.id,
        title: job.title,
        company: job.company,
        description: job.description,
        image: job.image || null,
        location: job.location,
        employmentType: job.employmentType,
        datePosted: job.datePosted,
        salaryRange: job.salaryRange || null,
        jobProviders: job.jobProviders,
        createdAt: new Date(),
        updatedAt: new Date(),
      }));
      searchResult.count = searchResult.jobs.length;

      // Save each job into the database if necessary
      for (const job of searchResult.jobs) {
        const jobDto: JobDto = {
          id: job.id,
          title: job.title,
          company: job.company,
          description: job.description,
          image: job.image || null,
          location: job.location,
          employmentType: job.employmentType,
          datePosted: job.datePosted,
          salaryRange: job.salaryRange || null,
          jobProviders: job.jobProviders,
        };
        this.logger.log(`Job details: ${JSON.stringify(jobDto, null, 2)}`);

        try {
          await this.jobDao.createJob(jobDto, query, location);
          this.logger.log(`Job '${job.title}' saved successfully.`);
        } catch (saveError) {
          this.logger.error(
            `Failed to save job '${job.title}': ${saveError.message}`,
          );
        }
      }

      return searchResult;
    } catch (error: any) {
      this.logger.error('Error fetching jobs', error.stack);

      if (error.response) {
        this.logger.error('API Response Error', {
          status: error.response.status,
          data: error.response.data,
        });
      }

      throw new HttpException(
        `Error fetching jobs: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  /**
   * Retrieves job details by the unique job ID.
   * @param id The unique identifier of the job to retrieve.
   * @returns A JobDto object containing the job details.
   * @throws HttpException if the job is not found or if an error occurs during retrieval.
   */
  async getJobById(id: string): Promise<JobDto> {
    this.logger.log(`Fetching job by ID: ${id}`);
    try {
      const job = await this.jobDao.findJobById(id);
      if (!job) {
        this.logger.warn(`Job with ID ${id} not found.`);
        throw new HttpException(
          {
            status: HttpStatus.NOT_FOUND,
            error: `Job with ID ${id} not found.`,
          },
          HttpStatus.NOT_FOUND,
        );
      }
      this.logger.log(`Job details retrieved: ${JSON.stringify(job)}`);
      const jobDto: JobDto = {
        id: job.id,
        title: job.title,
        company: job.company,
        description: job.description,
        image: job.image || null,
        location: job.location,
        employmentType: job.employmentType,
        datePosted: job.datePosted,
        salaryRange: job.salaryRange || null,
        jobProviders: job.jobProviders,
      };
      return jobDto;
    } catch (error: any) {
      this.logger.error(`Error fetching job by ID ${id}`, error.stack || error);
      throw new HttpException(
        `Error fetching job by ID: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
```

*End of AGENTS.md*
