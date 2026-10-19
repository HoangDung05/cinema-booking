# Cinema Booking System — Improvement Roadmap

Based on [PORTFOLIO_AUDIT.md](PORTFOLIO_AUDIT.md), audited 2026-10-17. This is a proposed sequence, **not an implementation record**. No application code or database schema was modified for this roadmap. Begin implementation only after the owner approves the audit and priority/order.

## Scope and working rules

Keep the existing Spring Boot + React monolith and its functional flows. Treat payment as a clearly labelled simulation unless a real gateway is separately requested. For schema work: inspect a disposable MySQL copy, write forward/rollback migrations, preserve current bookings, and check for conflicting rows before enforcing new constraints. Never paste secrets, personal data or live DB dumps into issues, tests or screenshots. Do not commit/push or deploy without explicit owner approval.

## Proposed order

| Order | Priority / milestone | Why now | Rough effort |
| --- | --- | --- | --- |
| 0 | P0-A: Data/privacy triage and reproducible baseline | A public portfolio must not publish sensitive local data; tests need a dependable Java 21 run. | 1–2 days |
| 1 | P0-B: Booking ownership and validation | Closes direct authorization and invalid-ticket paths. | 2–3 days |
| 2 | P0-C: Atomic seat holds and state transitions | Makes the project's central promise defensible under concurrency. | 3–5 days |
| 3 | P1-A: API contracts and service boundaries | Makes errors and persistence behavior maintainable. | 2–4 days |
| 4 | P1-B: Database migrations, tests and API docs | Gives reviewers proof of the invariants and a reproducible schema. | 3–5 days |
| 5 | P2: Local/CI developer experience | Makes setup and test feedback reliable for others. | 1–2 days |
| 6 | P3: Portfolio presentation | Captures the now-verified design, evidence, and demo. | 1–2 days |

Estimates overlap where a test is implemented with a fix; they are planning ranges, not a promise or measured velocity.

## P0 — Correctness and security

### Milestone P0-A — Protect repository data and establish baseline

**Audit findings:** F15, F13, F16. Review the tracked `init.sql` data, identify whether any person or account is real, replace with a synthetic local seed in a follow-up, and rotate/revoke any reused credentials. Keep Railway data untouched until separately reviewed. Document JDK 21 selection and make a clean Maven test run reproducible; use an explicit timeout if a test process hangs. Verify `.env` is untracked and examples contain placeholders only.

**Acceptance criteria:** public repository has no unapproved personal rows or reusable secrets in current content; demo credentials, if retained, work only for deliberately seeded demo data; `.env` remains ignored; a fresh Java 21 backend test run finishes with recorded pass/fail output. History-removal decisions and credential rotation are documented separately before any destructive Git action.

### Milestone P0-B — Enforce identity and input invariants

**Audit findings:** F01, F05, F06, F09. Decide how guest bookings prove ownership; derive signed-in user from JWT instead of `BookingRequest.userId`. Enforce owner/guest proof on booking read/pay, keep admin-only operations under server-side role checks, validate room–seat–showtime consistency, and reject empty/duplicate/excessive seat sets, expired showtimes and malformed registration/payment data.

**Acceptance criteria:** anonymous users cannot read/pay arbitrary numeric booking IDs; a CUSTOMER cannot attach a hold to another account or access another customer's booking; ADMIN/CUSTOMER/anonymous authorization matrix passes; invalid seat IDs and wrong-room seats return a stable client error; valid guest and authenticated booking flows still work. Frontend admin navigation agrees with server role names.

### Milestone P0-C — Make reservations and expiry atomic

**Audit findings:** F02, F04, F11, F12. Choose a MySQL-backed active-seat invariant that permits cancellation/reuse; add a migration with duplicate-row preflight and rollback plan. Serialize pay/expire and voucher-limit transitions; enforce deadline at pay time. Define one time-zone policy and test boundary times. Keep showtime overlap validation but make its concurrency behavior explicit.

**Acceptance criteria:** two simultaneous holds for the same seat/showtime produce exactly one active reservation; distinct seats can still be held concurrently; cancelling/expiring a pending hold releases the seat once; pay after deadline fails; pay-versus-expire yields one valid final state and at most one payment; the last voucher use cannot be claimed twice; migration works on a disposable MySQL copy with existing data. No existing paid ticket changes state.

## P1 — Backend engineering

### Milestone P1-A — Consistent API boundaries

**Audit findings:** F03, F07, F10. Add focused request/response DTOs for user/booking/admin flows; centralize typed exception-to-HTTP mapping; remove broad catches except where deliberately translating an external failure. Label simulated payment truthfully. Move lazy loading into service transactions and address N+1 queries in ticket/history/stats paths.

**Acceptance criteria:** documented 400/401/403/404/409/500 JSON format; no raw exception or password field is returned; unexpected server faults are not reported as invalid credentials; list endpoints remain functional with Open Session in View disabled; representative query counts are bounded for multiple bookings. Existing frontend consumers are updated without losing features.

### Milestone P1-B — Reproducible schema and meaningful tests

**Audit findings:** F02, F04, F13, F14. Add versioned MySQL migrations, separate synthetic seed from schema, and keep `ddl-auto` from changing deployed schema automatically after validation. Add service tests for pricing/validation/expiry, MockMvc auth/error-contract tests, and MySQL integration tests for reservation/voucher races. Expand existing springdoc definitions for auth and booking states rather than adding another docs stack.

**Acceptance criteria:** a fresh disposable MySQL database migrates from empty to current schema; an existing compatible database upgrades after preflight without losing bookings; migrations are idempotently tracked by the migration tool; all new invariant tests pass on Java 21, including a repeatable two-client MySQL test; Swagger describes the actual public/admin endpoints and the simulated payment boundary.

## P2 — Developer experience

### Milestone P2 — One-command local setup and CI feedback

**Audit findings:** F16, F17. Add DB health/readiness to Compose, keep `.env.example` placeholder-only, document direct terminal/IDE and Compose setup, and create a minimal GitHub Actions workflow for Java 21 backend tests plus frontend typecheck/build. Do not make external Railway credentials required for CI.

**Acceptance criteria:** on a clean machine with documented prerequisites, local services start in the documented order; tests run without private secrets; CI checks every proposed change and displays a green/red result; README commands match checked-in scripts. Docker image build may skip tests only after CI enforces them.

## P3 — Portfolio presentation

### Milestone P3 — Recruiter-ready evidence

**Audit findings:** F03, F17. Rewrite the main README in concise English after implementation is verified. Use these sections in order: Project Overview; Key Features; Tech Stack; System Architecture; Database Design; Authentication and Authorization; Booking Workflow and Concurrency Handling; Getting Started; Environment Variables; API Documentation; Testing; Screenshots; Demo; Deployment; Technical Challenges and Solutions; Author. Draw architecture/ERD from the final code/migrations, link Swagger, and prepare a 2–3 minute demo script. Add screenshot/video **placeholders** until real captures exist.

**Acceptance criteria:** a reviewer can understand the Java backend contribution in under two minutes; every technical claim points to implementation or executed test evidence; diagrams match the final schema; public links are checked before claiming they work; payment is labelled simulated; no fabricated performance metrics or deployment verification appear; an applicant can demonstrate browse → select → hold → pay simulation → admin confirm with known-safe demo data.

## Release gates before calling the project “production-minded”

1. P0 authorization and reservation acceptance tests pass against the intended database behavior.
2. Sensitive sample data and credentials are reviewed and handled.
3. Database migration/backout and environment setup are documented and rehearsed on a disposable database.
4. CI passes, and the README reflects actual features and verified demo state.

These gates describe portfolio readiness, not certification for processing real payments or personal data at scale.
