# PRD: Customer Registration Module

- Version: 0.1.0
- Owner: Bobwares
- Last updated: 2025-10-06
- Status: Draft

1. Problem Statement

* We need a secure, self-service online flow for new customers to create an account, verify identity with two-factor authentication, be added to the Customer Domain, and provide required personal data and preferences so downstream products can function without manual onboarding.

Drivers, Assumptions, and Validation Plan (greenfield)

* Business driver: Enable digital onboarding; reduce manual account creation and support overhead; unblock growth initiatives dependent on authenticated users.
* Compliance/Security guardrails: MFA at registration, consent capture, audit logging, least-privilege data collection.
* Technical guardrails: Dedicated registration APIs with SLOs, rate limiting, fraud/abuse controls, observability from day one.
* Success hypotheses (initial targets to validate post-launch):

    * End-to-end signup conversion ≥ 70% within 30 days.
    * 95th percentile time-to-complete ≤ 4 minutes.
    * OTP delivery success ≥ 98% within 60 seconds.
    * Registration API 5xx error rate ≤ 0.2% steady-state.

2. Target users

* Primary: New customers creating an account for the first time.
* Secondary: Support agents who may resend verification links or complete edge-case registrations.
* Internal stakeholders: Security, Compliance, Data Privacy, Marketing (preference capture), Analytics.

3. Key scenarios

* S1: Email+password signup, email or SMS OTP verification, account activated.
* S2: User requests OTP resend; throttling prevents abuse; eventual success.
* S3: Password fails policy; inline guidance enables correction.
* S4: Returning user restarts an incomplete registration and completes verification.
* S5: Duplicate email/phone detected; user guided to sign in or account recovery.
* S6: Consent and preferences captured (marketing opt-in/out, channel, language).
* S7: Accessibility path: keyboard-only, screen reader, color-contrast compliant.
* S8: Error handling: upstream OTP/Email service degraded; graceful fallback, clear messaging; no PII leakage.

4. Scope
   4.a Goals

* Provide a reliable, secure, and compliant online registration that:

    * Creates a customer account with password + 2FA.
    * Adds the user to the Customer Domain with a unique identifier.
    * Collects required personal information and preferences with explicit consent.
    * Emits analytics and audit events for each step and outcome.

4.b Non-goals

* Social/SSO sign-in providers (deferred).
* Full KYC/identity proofing beyond OTP (deferred unless mandated).
* Account recovery/forgot-password flows (separate PRD).
* In-product profile management and preference center (separate PRD).
* Native mobile SDKs (web-first; native deferred).

5. Success Metrics

* Conversion: Registration start→completed activation ≥ 70% (M30), ≥ 80% (M90).
* Speed: p95 time-to-complete ≤ 4:00; median ≤ 2:00.
* Reliability: Registration API 5xx ≤ 0.2% daily; availability ≥ 99.9%.
* OTP: Delivery success ≥ 98% within 60s; verification success ≥ 95%.
* Accessibility: WCAG 2.1 AA checks pass on all registration views.
* Privacy/Compliance: 0 critical audit findings; 0 PII incidents.
* Support load: Tickets tagged “signup/verification” ≤ 40/mo after stabilization.

6. Functional requirements
   FR-1 Account creation

* Users can register with email (primary identifier) and password meeting policy.
* System creates a unique customer ID in the Customer Domain.

FR-2 Two-factor verification at registration

* System supports OTP via email and SMS; admin-configurable default and fallback.
* Codes expire within N minutes and are single-use.

FR-3 Personal information capture

* Minimum set: first name, last name, country/region, preferred language; field requirements configurable.
* Input validation, inline error feedback, masking where appropriate.

FR-4 Preferences and consent capture

* Marketing opt-in/out with channel preferences; explicit consent text linked to policy; timestamped records.
* Language preference and communication channel stored.

FR-5 Duplicate detection and recovery

* If email or phone already exists, guide user to sign in or account recovery without revealing account existence beyond what is necessary.

FR-6 Resend and retry policies

* Resend OTP with backoff and rate limits; clear countdown UI; max attempts per time window.

FR-7 Session and state continuity

* Incomplete registrations can be resumed within a limited window; state persists securely.

FR-8 Audit and analytics events

* Emit events for each step: started, field validation errors, OTP send, OTP verify, completed, abandoned, throttled, blocked.

FR-9 Administrative observability

* Dashboard or logs to view aggregate funnel, error rates, OTP provider status; no raw PII display.

FR-10 Accessibility and localization

* UI supports keyboard navigation, screen readers, high contrast; copy and error messages are localizable; initial locales: en-US; others as phased.

7. Non-functional requirements
   7.a Performance

* Page TTI ≤ 3s on 3G-fast reference; API p95 latency ≤ 300 ms for registration endpoints under normal load; OTP send initiation ≤ 500 ms.

7.b Reliability

* Availability ≥ 99.9% monthly for registration endpoints; graceful degradation if OTP provider degraded; retry policies on transient failures.

7.c Security

* MFA enforced during registration; secrets and keys stored in managed secret store; rate limiting and IP/device fingerprint throttling; strong password policy; no sensitive error disclosures; CSP and standard web security headers.

7.d Compliance

* Consent logging; data minimization; data retention policies defined; support for GDPR/CCPA data subject requests; audit trail for account creation.

7.e Accessibility

* WCAG 2.1 AA conformance; automated checks in CI plus manual audits on key templates.

7.f Privacy

* PII encryption at rest and in transit; purpose limitation; consent surfaces clear and unambiguous; default to opt-out for marketing unless jurisdiction requires opt-in.

7.g Internationalization (i18n)

* All user-visible text externalized; date/phone formats validated per locale; right-to-left readiness considered in design system; initial locale en-US.

8. Constraints (tech, org, regulatory)

* Must integrate with an enterprise IdP/OTP provider selected by Security; provider must support email and SMS OTP with deliverability SLAs.
* Legal must approve consent copy and retention schedules before launch.
* Analytics and audit pipelines must be available at launch for funnel tracking and audits.
* Rate limiting must align with Abuse/Fraud thresholds.

9. Acceptance criteria and test criteria
   A. Funnel and reliability

* Given a healthy system, when 1,000 synthetic signups run in a load test, then completed registrations ≥ 80% and API 5xx ≤ 0.2%.

B. Password policy

* Given a user enters a non-compliant password, when they submit, then the form blocks submission and displays policy guidance without revealing exact rules in a way that weakens security.

C. OTP

* Given a valid email and phone, when OTP is requested, then a code is delivered within 60s in ≥ 98% of cases; expired codes are rejected; only the latest code is valid.

D. Duplicate handling

* Given an email that already exists, when user attempts registration, then the flow offers sign-in or recovery without confirming account existence beyond acceptable leakage thresholds.

E. Consent and preferences

* Given the consent checkbox is unchecked in a jurisdiction requiring explicit opt-in, when submitting, then the form blocks submission and indicates consent is required; consent event is logged when accepted.

F. Accessibility

* Given a keyboard-only user, when navigating all fields and actions, then all controls are reachable and usable; automated a11y suite passes with no critical violations.

G. Analytics/Audit

* Given a registration completes, when events are queried, then created events include timestamps, user pseudonymous ID, and step outcomes; no raw PII is present in logs.

10. Risks with mitigations

* OTP deliverability variability by carrier or region → Dual-channel (email/SMS) with auto-fallback; provider health checks; resend with backoff.
* Abuse via OTP spamming → Per-identifier/IP rate limits; challenge after N attempts; dark mode throttles without user-visible hints.
* Regulatory changes to consent/retention → Centralized copy and policy flags; feature flags by region.
* Analytics blind spots at launch → Instrumentation checklist as launch gate; synthetic monitoring.
* Performance regressions under campaign spikes → Load testing and auto-scaling; circuit breakers on dependencies.

11. Open questions and decision log
    Open questions

* Is MFA mandatory at registration for all regions or post-login step-up acceptable in some jurisdictions?
* Which fields are legally required at registration vs deferred to profile completion?
* Minimum supported locales at launch beyond en-US?
* What is the OTP code length and expiry standard?
* Is phone collection mandatory or optional?

Decision log

* [D-001] Email as primary identifier; phone optional for OTP fallback.
* [D-002] OTP via email default, SMS fallback where phone present.
* [D-003] Registration recovery window set to 72 hours.
* [D-004] Initial locales: en-US. Others follow in v1.1.

12. Release scope & phased delivery (MVP → v1.x)
    MVP (v0.1)

* Email+password registration with inline validation.
* OTP verification via email; SMS fallback where phone provided.
* Required PII: first name, last name, country/region; consent capture; preferences: marketing opt-in/out, language.
* Basic analytics and audit events; rate limiting; a11y baseline; en-US.

v1.0

* Admin dashboards for funnel and error telemetry.
* Improved duplicate detection UX and self-service recovery hand-off.
* Resilience patterns for OTP provider (multi-region, queuing).
* Expanded accessibility audits; localization framework ready.

v1.1+

* Additional locales; richer preferences center integration.
* Optional SSO providers; device binding or TOTP MFA.
* Progressive profiling; jurisdiction-specific consent banners.
* Fraud signals integration (velocity, device reputation).

If you want this tailored to your stack and org policies, tell me the IdP/OTP provider, password policy, and jurisdictions. Otherwise I can proceed to add a requirements traceability table and derive a test plan from FR/NFR IDs.

