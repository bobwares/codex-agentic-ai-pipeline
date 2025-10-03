# TASK 03 – Generate Terraform Infrastructure

## Goal

Provision all cloud resources required to run the CRUD serverless application produced in Task 01.
Terraform code must:

* Live entirely under `iac/`.
* Target **Terraform ≥ 1.8** and AWS provider **\~> 5.x**.
* Deploy:

   * **API Gateway HTTP API** (one stage per `var.environment`).
   * **AWS Lambda** functions for every handler in `src/handlers/`, using the *arm64 Node 20* runtime and referencing the ZIPs produced by `npm run build`.
   * **DynamoDB single-table** with PAY\_PER\_REQUEST billing and GSI **`gsi1`**.
   * **IAM roles/policies** granting each Lambda only the permissions it requires.
* Define remote-state placeholders (S3 bucket + DynamoDB lock table) but do **not** create them.
* Expose usable outputs: `api_url`, `table_name`, and a map `lambda_arns`.

## Inputs

| Path / Reference                      | Purpose                                     |
| ------------------------------------- | ------------------------------------------- |
| `session_memory/01_task_01_output.md` | List of Lambda handlers and build artifacts |
| `package.json`                        | Confirms Node 20 runtime                    |
| `schema/domain.json`                  | Table key names and GSI projections         |
| `session_memory/*.md`                 | Prior decisions (naming, env vars, etc.)    |

## Tools

| Tool ID             | Shell Invocation           | Purpose                                  |
|---------------------|----------------------------|------------------------------------------|
| terraform\_init     | `terraform init`           | Initialise backend / providers           |
| terraform\_validate | `terraform  validate`      | Static analysis of Terraform code        |
| terraform\_fmt      | `terraform fmt -recursive` | Enforce canonical formatting             |
| tflint              | `tflint`                   | Terraform linting / best-practice checks |
| file\_write         | *virtual*                  | Create / overwrite files in `iac/`       |

## Acceptance Criteria

1. `terraform  init` completes without error.
2. `terraform  validate` reports **“Success! The configuration is valid.”**
3. `terraform  fmt -recursive` produces no diff.
4. `tflint ` exits with code 0 and no error-level findings.
5. All Lambda resources reference the correct build ZIPs and set env vars `TABLE_NAME`, `AWS_NODEJS_CONNECTION_REUSE_ENABLED=1`, and `POWERTOOLS_SERVICE_NAME`.
6. DynamoDB table definition matches the single-table pattern with composite `pk` / `sk` and GSI `gsi1`.
7. Remote-state bucket and lock table are referenced only in backend configuration—not provisioned.
8. Each IAM policy includes only the actions its Lambda needs (e.g., `dynamodb:GetItem`, `PutItem`).
9. Outputs `api_url`, `table_name`, and a map `lambda_arns` are declared and documented.

## Deliverables

* `iac/main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`, and module files such as `lambda.tf`, `dynamodb.tf`, `apigateway.tf`, `iam.tf`.
* `session_memory/03_task_03_output.md` — list of files created/modified and key outputs.
* `session_memory/03_task_03_decisions.md` — explanation of critical design choices (naming, GSI keys, IAM policies).
