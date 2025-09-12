# Codex Session Context

# Project 

- Name: Customer Registration
- Detailed Description:

  The Customer Registration project provides a standardized service for securely onboarding new customers into a system. It manages the complete registration lifecycle—from capturing customer details and validating inputs, to persisting records in a relational database, and exposing CRUD operations through a REST API. The system is designed to integrate with enterprise authentication and authorization frameworks, ensuring compliance with data security policies. It also establishes a foundation for downstream processes such as customer profile enrichment, service eligibility checks, and integration with external systems.

- Short Description

    Customer Registration is a service that securely captures, validates, and manages new customer data, exposing standardized APIs for onboarding and downstream integrations.


- Author: Bobwares ([bobwares@outlook.com](mailto:bobwares@outlook.com)) 
 
## Maven 

- groupId: com.bobwares.customer
- artifactId: registration
- name: Customer Registration
- description: Spring Boot service for managing customer registrations

## Domain
- Domain Object
  Customer
- REST API Request Schema
  load ./schemas/customer.schema.json
- REST API Response Schema
  load ./schemas/customer.schema.json
- Persisted Data schema
    load ./schemas/customer.schema.json