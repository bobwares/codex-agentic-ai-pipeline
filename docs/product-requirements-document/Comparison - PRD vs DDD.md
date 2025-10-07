| Dimension         | PRD                                              | DDD document                                                                         |
| ----------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------ |
| Primary purpose   | Agree on problem, users, and measurable outcomes | Model the core domain: concepts, rules, and boundaries                               |
| Audience          | Product, design, engineering, stakeholders       | Engineering, architecture, domain experts                                            |
| Scope             | Features, success metrics, constraints           | Bounded contexts, aggregates, entities, value objects, domain events, policies/sagas |
| Abstraction       | Outcome-oriented, solution-agnostic              | Behavior-oriented, implementation-agnostic but architecture-informing                |
| Testability focus | Acceptance criteria per requirement              | Invariants, property/contract tests, event flows                                     |
| Traceability      | Requirement → acceptance tests                   | Command → aggregate → events → projections/policies                                  |
| Change cadence    | Faster (market/feature shifts)                   | Slower (business rules and boundaries evolve carefully)                              |
| Outputs           | Backlog, release plan, KPIs                      | Context map, domain model, command/event schemas, repository ports                   |
