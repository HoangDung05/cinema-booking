# Cinema Booking System — Repository Audit

Audit date: 2026-10-17. Scope: the checked-out `improve/backend-portfolio` branch, source files and tracked SQL/configuration only. This is a code audit, not a live Railway/Vercel or production database verification. No application code, schema, deployment, or Git history was changed during this audit.

## Executive summary

The project is a functional single-application Spring Boot API with a React client, JWT login, an admin UI, a two-minute pending-booking workflow, MySQL schemas/seeds, Docker files, and a small H2-backed web test suite. The main portfolio risk is **booking correctness and access control**, not missing infrastructure: public endpoints can read/pay bookings by numeric ID; `holdBooking` trusts a caller-supplied user ID; and concurrent holds are protected by a read-before-write check without an atomic reservation constraint. These should be fixed before describing the service as production-ready.

Severity means potential impact **if the relevant endpoint is reachable**, not proof of exploitation in the deployed environment. Effort is a rough implementation and focused-test estimate for one developer, excluding deployment coordination.

## 1. Structure and architecture

| Area | Verified implementation |
| --- | --- |
| Backend | `cinema-booking-backend/`: one Java 21 Spring Boot application; controller → service/implementation → Spring Data JPA repository → MySQL. Executable WAR, Maven Wrapper. |
| Frontend | `cinema-booking-frontend/`: React SPA with client/admin layouts, pages, Axios service layer, React Router route guard. |
| Data | 11 JPA entities and 11 repositories. `init.sql` is a local export; `railway_demo.sql` creates a separate synthetic demo dataset. |
| Deployment | Root Compose runs MySQL, backend, frontend; backend and frontend each have a Dockerfile; frontend has Vercel rewrite configuration. README describes Railway/Vercel setup. |

This is a reasonable architecture for an intern portfolio. It does not need microservices or a message broker.

## 2. Actual technology inventory

Versions below come from manifests, not the currently deployed services. `pom.xml`: Java 21, Spring Boot **3.2.5**, Spring Web, Data JPA/Hibernate, Security, Validation, MySQL Connector/J, Lombok, JJWT **0.11.5**, springdoc OpenAPI **2.5.0**, JUnit/Spring Boot Test and H2 test dependency. `package.json`: React **^19.0.0**, TypeScript **~5.8.2**, Vite **^6.2.0**, React Router **^7.14.0**, Axios **^1.15.0**, Tailwind **^4.1.14**. These are declared ranges; the lockfile determines installed frontend versions. Compose pins `mysql:8.0`; a Railway screenshot or runtime may use a different MySQL version, which this audit did not inspect.

## 3. Database schema and relationships

The following is from the JPA entities and `railway_demo.sql`, **not a live schema inspection**:

| Table | Main relationships / constraints in `railway_demo.sql` |
| --- | --- |
| `roles`, `users` | `users.role_id → roles.id`; unique role name and user email. |
| `cinemas`, `rooms`, `seats` | `rooms.cinema_id → cinemas.id`; `seats.room_id → rooms.id`; unique `(cinema_id, name)` and `(room_id, seat_number)`. |
| `movies`, `showtimes` | `showtimes.movie_id → movies.id`; `showtimes.room_id → rooms.id`; unique `(room_id, start_time)`. |
| `bookings`, `booking_details` | Booking belongs to a showtime, optionally a user/voucher. Detail belongs to a booking, showtime, and seat. No unique `(showtime_id, seat_id)` constraint, to allow reuse after cancellation. |
| `vouchers`, `payments` | Booking may reference voucher; payment belongs to exactly one booking, with unique `payments.booking_id`. |

`bookings.status` includes `PENDING`, `AWAITING_CONFIRMATION`, `PAID`, `CANCELLED`. The SQL and Java models are not guaranteed identical after Hibernate's `ddl-auto: update`; compare them against a disposable MySQL instance before planning a migration. `init.sql` also contains recorded user/booking rows and is destructive when imported. Do not paste it into a public demo or production database.

## 4–8. Findings: auth, API, reservation, transactions, validation and security

### F01 — Booking ownership can be forged or bypassed

- **Severity:** Critical
- **Files:** `cinema-booking-backend/src/main/java/com/cinema/movie_booking/config/SecurityConfig.java:52-54`; `controller/BookingController.java:34-107`; `service/impl/BookingServiceImpl.java:105-109,163-210,359-362`; `dto/BookingRequest.java`.
- **Evidence and impact:** Public `POST /bookings/hold`, `POST /bookings/{id}/pay`, and `GET /bookings/{id}` accept caller-chosen IDs. The hold request's `userId` is loaded directly from the database rather than tied to the JWT principal. A caller can create a booking under another account, read another booking's details, or pay an arbitrary pending booking. The public GET response omits email, but still exposes ticket/showtime/seat/price data.
- **Recommendation:** Define explicit guest versus authenticated booking flows. For signed-in users derive user identity from `Authentication`; check ownership in a service on every read/pay/cancel operation. For guest access use an unguessable, short-lived booking capability or another verified proof. Keep public seat selection without exposing arbitrary booking IDs.
- **Intern relevance:** Demonstrates object-level authorization and identity boundary design, a core backend skill.
- **Effort:** 1–2 days plus integration tests.

### F02 — Two concurrent holds can reserve the same seat

- **Severity:** Critical
- **Files:** `service/impl/BookingServiceImpl.java:92-149`; `repository/BookingDetailRepository.java:9-13`; `entity/BookingDetail.java`; `railway_demo.sql:116-128` (and corresponding table in `init.sql`).
- **Evidence and impact:** `existsByShowtimeIdAndSeatIdIn` runs before inserts. The detail table has separate indexes but no atomic active-seat uniqueness rule or explicit lock. Two transactions can both observe no active booking and insert details. Catching `DataIntegrityViolationException` cannot prevent this race without a relevant constraint. The audit has **not** reproduced the race against MySQL yet.
- **Recommendation:** Design a database-backed reservation invariant that supports release/reuse after cancellation (for example, a dedicated active-seat reservation table with unique showtime/seat and transactional delete on release, or a per-showtime row lock with a documented isolation strategy). Add a concurrent two-client MySQL integration test. Migrate existing data carefully, checking duplicates first.
- **Intern relevance:** A clear case study in transactions, isolation, and database constraints.
- **Effort:** 2–4 days including migration rehearsal and tests.

### F03 — Payment is accepted without a payment provider

- **Severity:** High
- **Files:** `service/impl/BookingServiceImpl.java:162-223`; `controller/BookingController.java:46-54`; `README.md` payment note.
- **Evidence and impact:** Calling `payBooking` sets payment `SUCCESS` and booking `PAID` (or guest `AWAITING_CONFIRMATION`) using the supplied method; there is no provider callback or verified charge. README accurately calls the flow simulated, but UI copy says “Thanh toán ngay” and “Tất cả giao dịch đều được mã hóa”.
- **Recommendation:** Keep the demo simulation, explicitly label it as simulated in API/UI, restrict the transition to booking owner/guest proof, and avoid presenting it as real payment. Real gateway integration is optional and out of scope for this portfolio.
- **Intern relevance:** Shows honest modeling of external side effects and state transitions.
- **Effort:** 0.5–1 day.

### F04 — Hold/payment expiry and voucher updates are not serialized

- **Severity:** High
- **Files:** `service/PendingBookingExpirationService.java:24-31`; `scheduler/PendingBookingExpiryScheduler.java`; `service/impl/BookingServiceImpl.java:162-217`; `repository/BookingRepository.java`.
- **Evidence and impact:** Expiry runs in a separate `REQUIRES_NEW` transaction, including at the start of hold/pay/read workflows. `payBooking` reads `PENDING` without a row lock or version and then changes status. A concurrent expiry/pay can race; voucher `usedCount` is read/incremented without locking, so a limited voucher may be oversubscribed. Exact outcomes depend on MySQL isolation/timing and have not been concurrency-tested.
- **Recommendation:** Make transitions conditional and atomic (row lock/version or conditional update), enforce the two-minute deadline at pay time, and serialize voucher usage or use conditional increment. Test pay-vs-expire and last-voucher-use races.
- **Intern relevance:** Demonstrates correct transactional boundaries and state machines.
- **Effort:** 1–3 days.

### F05 — Hold request does not verify seat belongs to the showtime room

- **Severity:** High
- **Files:** `service/impl/BookingServiceImpl.java:111-143`; `entity/Seat.java`; `entity/Showtime.java`.
- **Evidence and impact:** The service loads each requested seat by ID but does not compare `seat.room.id` with `showtime.room.id`. A valid seat in another room can be attached to this showtime, producing an invalid ticket and occupancy state. `calculatePrice` also counts seat IDs without loading or validating them.
- **Recommendation:** Validate showtime is bookable, every seat exists and belongs to its room, IDs are distinct, and request size is bounded. Put these rules in the service and test invalid combinations.
- **Intern relevance:** Illustrates server-side domain invariants rather than trusting UI restrictions.
- **Effort:** 0.5–1 day.

### F06 — Request validation is incomplete

- **Severity:** High
- **Files:** `dto/BookingRequest.java`, `dto/PriceCalculateRequest.java`, `dto/PayBookingRequest.java`, `dto/RegisterRequest.java`; `controller/BookingController.java`, `controller/AuthController.java`; `service/impl/BookingServiceImpl.java:48-52,97-103`.
- **Evidence and impact:** DTOs have no Bean Validation constraints and controllers do not use `@Valid`. For example `calculatePrice` calls `request.getSeatIds().size()` before checking null; blank email, invalid payment method, negative/oversized collections and malformed amounts are not uniformly rejected. Registration has only partial manual checks.
- **Recommendation:** Add dedicated request DTO constraints and domain checks, cap seat count, and return structured 400 responses. Keep validation at both request and service boundaries.
- **Intern relevance:** Demonstrates predictable API behavior and defensive backend design.
- **Effort:** 1–2 days.

### F07 — Error handling is scattered and obscures server faults

- **Severity:** Medium
- **Files:** `controller/AuthController.java:19-38`; `controller/BookingController.java`; `controller/ShowtimeController.java`; `controller/AdminController.java`; no `@ControllerAdvice` in `src/main/java`.
- **Evidence and impact:** Controllers catch broad `Exception`, returning plain strings and often 400. Login catches all failures and returns 401 even for unexpected server/database errors, while printing a stack trace. Other endpoints can expose exception messages or default error bodies.
- **Recommendation:** Add typed domain exceptions and a central `@RestControllerAdvice` with consistent 400/401/403/404/409/500 JSON. Log unexpected failures server-side with context but no secrets.
- **Intern relevance:** API contracts and diagnosis are common code review criteria.
- **Effort:** 1–2 days.

### F08 — Public chat endpoint can trigger unbounded upstream/database work

- **Severity:** Medium
- **Files:** `config/SecurityConfig.java:55`; `controller/ChatbotController.java`; `service/impl/ChatbotServiceImpl.java:35-136`.
- **Evidence and impact:** `/chat` is public. Each request builds context from **all** movies and showtimes, checks seats for every future showtime, then calls Gemini through a newly constructed `RestTemplate`. No explicit input cap, request timeout, context limit, or rate limit is visible. With the demo seed's long schedule this can create many DB queries and slow/fail requests.
- **Recommendation:** Limit request/history sizes and the showtime window, batch availability counts, configure HTTP timeout, and add modest abuse controls if publicly exposed. Avoid including the API key in URL-based diagnostics.
- **Intern relevance:** Shows awareness of bounded work and external-service failure handling.
- **Effort:** 1–2 days.

### F09 — JWT and admin authorization have a good base, but need behavioral tests

- **Severity:** Medium
- **Files:** `config/SecurityConfig.java`; `security/JwtUtils.java`; `security/JwtAuthFilter.java`; `security/UserDetailsServiceImpl.java`; `cinema-booking-frontend/src/utils/authSession.ts`.
- **Evidence and impact:** BCrypt, HS512 with a required 64-byte secret, database reload of JWT subject, locked-user check, admin route patterns and CORS allowlist exist. The React admin guard checks numeric `roleId === 2`, while server checks role name; these can disagree with database role IDs. Current tests only assert anonymous admin denial, not CUSTOMER denial/ADMIN allow or booking ownership. JWT is stored in `localStorage`, so XSS would expose it.
- **Recommendation:** Treat server roles as authoritative; make UI check role name from the session; add role matrix/JWT expiry/locked-user tests; review localStorage/XSS tradeoff and avoid unsafe HTML rendering. Keep secrets out of source.
- **Intern relevance:** Distinguishes UI navigation from actual server authorization.
- **Effort:** 1–2 days.

### F10 — JPA entities leak into API contracts and persistence work can happen during JSON rendering

- **Severity:** Medium
- **Files:** `controller/UserController.java:28-36`; `controller/RoomController.java`; `controller/VoucherController.java`; `entity/User.java`; `entity/Booking.java`; `service/impl/BookingServiceImpl.java:248-283`; `src/main/resources/application.yaml`.
- **Evidence and impact:** Several controllers accept/return JPA entities. `User.password` correctly has `@JsonIgnore`, but entities still expose persistence structure and can trigger lazy loading. The H2 test startup warns that `spring.jpa.open-in-view` is enabled. `getUserBookings` queries details per booking, and admin stats traverses booking detail collections, creating likely N+1 queries on larger datasets.
- **Recommendation:** Introduce focused input/output DTOs on key flows, fetch needed relationships inside read-only service transactions, then disable Open Session in View. Add pagination/query plans where lists can grow.
- **Intern relevance:** Demonstrates clean API boundaries and JPA performance awareness.
- **Effort:** 2–4 days, incremental.

### F11 — Showtime conflict check is application-side only

- **Severity:** Medium
- **Files:** `service/impl/ShowtimeServiceImpl.java:111-208`; `railway_demo.sql:83-94`.
- **Evidence and impact:** The service checks overlap in memory before saving. The unique SQL key protects only identical `(room_id, start_time)`, not overlapping intervals; concurrent admin writes may bypass the read check. The service also fetches all showtimes for a movie/room to validate a single change.
- **Recommendation:** Add a focused overlap query and transaction/locking strategy for the room schedule, with tests for same-time and overlapping concurrent creates. Preserve existing showtimes during migration.
- **Intern relevance:** Another concrete data-integrity example without unnecessary infrastructure.
- **Effort:** 1–2 days.

### F12 — Time-zone rules are implicit

- **Severity:** Medium
- **Files:** `entity/Booking.java:31-39`; `service/PendingBookingExpirationService.java:26`; `service/impl/BookingServiceImpl.java:278-280`; `cinema-booking-frontend/src/utils/localDateTime.ts`; `cinema-booking-frontend/src/pages/client/MyTickets.tsx`.
- **Evidence and impact:** Expiry uses JVM-local `LocalDateTime.now()`, while `bookingCreatedAt` attaches `ZoneId.systemDefault()` to a DB timestamp and the frontend treats offsetless showtimes as browser-local cinema time. The UI now places active holds under “Sắp chiếu”, but hold expiry can still depend on JVM/DB/client time-zone configuration. No explicit zone policy or clock-based tests were found.
- **Recommendation:** Define a single zone/instant policy for booking creation and expiry; keep cinema display times explicit. Inject `Clock` in time-sensitive logic and test across zones and boundary minutes.
- **Intern relevance:** Shows care with distributed deployment and temporal correctness.
- **Effort:** 1–2 days.

## 9. Tests and verification

- Existing automated backend tests: **five** methods in `cinema-booking-backend/src/test/java/com/cinema/movie_booking/MovieBookingApplicationTests.java`: context start, public catalog, anonymous admin denial, allowed CORS, rejected CORS. They use H2 MySQL mode. No booking, voucher, ownership, concurrency, or real MySQL integration tests were found.
- Frontend `npm run lint` runs `tsc --noEmit`, not ESLint; no frontend test script or test files were found.
- **This audit's run:** `npm run lint` and `npm run build` passed (the installed Vite reported 6.4.1). An initial `mvnw.cmd test -q` failed because terminal `java` was Corretto 8 while project classes target Java 21. With `JAVA_HOME=C:\Program Files\Java\latest\jdk-21`, the Spring/H2 test context started, but the Maven process did not finish within the observation window and was interrupted; no pass claim is made. The prior Surefire report in `target/` is dated 2026-10-03 and is not evidence of this run.

### F13 — Test suite does not cover the project's central invariant

- **Severity:** High
- **Files:** `src/test/java/com/cinema/movie_booking/MovieBookingApplicationTests.java`; `service/impl/BookingServiceImpl.java`; `repository/BookingDetailRepository.java`.
- **Evidence and impact:** The five tests do not exercise hold/pay/expire, booking ownership, invalid seat-room combinations, voucher limits, or two simultaneous holds. H2 mode may not reproduce MySQL locking/ENUM behavior.
- **Recommendation:** Add focused service and MockMvc tests, then a small MySQL Testcontainers (or disposable MySQL) integration suite for race/constraint behavior. Keep slow DB tests separate if needed.
- **Intern relevance:** A convincing portfolio needs tests around its hardest behavior.
- **Effort:** 2–4 days across milestones.

## 10. Docker, deployment, and environment

`DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, and `JWT_SECRET` are environment-based. The frontend uses `VITE_API_URL`. `.env` is ignored and `.env.example` is tracked. Local Compose uses MySQL 8.0 with persisted volume and init script, builds an executable WAR, and serves the SPA with Nginx. The backend Dockerfile skips tests. There is no tracked GitHub Actions workflow or database migration directory.

### F14 — Schema changes are uncontrolled in deployed environments

- **Severity:** High
- **Files:** `cinema-booking-backend/src/main/resources/application.yaml:17-20`; `init.sql`; `railway_demo.sql`; no Flyway/Liquibase migration directory.
- **Evidence and impact:** `ddl-auto: update` can silently diverge a Railway schema from the two SQL scripts; fresh install and upgrade paths are not reproducible. Changing reservation tables without a migration/rollback plan would risk bookings.
- **Recommendation:** Snapshot and inspect a disposable MySQL schema; establish versioned migrations, seed demo data separately, and set non-development environments to `validate`/`none` once migrations are proven. Document compatibility and backup/rollback for every schema change.
- **Intern relevance:** Demonstrates practical database lifecycle knowledge.
- **Effort:** 2–3 days.

### F15 — Tracked local SQL includes personal data and shared demo credentials

- **Severity:** High
- **Files:** tracked `init.sql` (notably `users` and `bookings` inserts); `README.md` test-account table; `.env.example` default MySQL root value.
- **Evidence and impact:** `init.sql` contains non-synthetic-looking names, contact information, password hashes, and booking history. The README publishes fixed demo login credentials for this local seed, and `.env.example` suggests a trivial root password. No live credential validity or individual consent was checked; the repository's data alone warrants review. `railway_demo.sql` contains synthetic catalog data and does not create users.
- **Recommendation:** Audit provenance/consent, replace the tracked local dump with synthetic seed data in a reviewed follow-up, rotate any reused credentials, and review Git history if removal is required. Use placeholders and least-privilege DB user in examples; never copy a real secret into documentation.
- **Intern relevance:** Public-repo privacy and secret hygiene are basic professional expectations.
- **Effort:** 1–2 days plus any credential rotation/history coordination.

### F16 — Compose does not express database readiness or run tests in the image build

- **Severity:** Low
- **Files:** `docker-compose.yml:32-34`; `cinema-booking-backend/Dockerfile:20-23`; `cinema-booking-frontend/Dockerfile`.
- **Evidence and impact:** `depends_on` only orders container startup; it does not wait for MySQL readiness. Backend image packaging uses `-DskipTests`. On a cold start the API may temporarily fail, while CI is absent to enforce tests before builds.
- **Recommendation:** Add a DB healthcheck/startup dependency, use CI to run tests before image packaging, and keep the local dev command simple.
- **Intern relevance:** Reproducible local onboarding is valuable to reviewers.
- **Effort:** 0.5–1 day.

## 11. README and GitHub presentation

The current Vietnamese README is useful for local setup, Docker, Railway demo import, API overview and a candid simulated-payment note. It is **not yet an English recruiter-facing case study**. It has no checked-in architecture/ERD diagrams, screenshot set, test evidence, CI badge, or 2–3 minute demo script. The public demo URL is documented but was **not opened or verified** during this audit.

### F17 — Portfolio story and evidence are incomplete

- **Severity:** Medium
- **Files:** `README.md`; missing `docs/` assets and `.github/workflows/` at audit start.
- **Evidence and impact:** The README explains how to run but gives little visual system context or evidence of key backend decisions. A recruiter cannot quickly inspect the booking invariant, test outcomes, and known simulation boundary.
- **Recommendation:** After correctness work, write a concise English README using the requested 16-section structure, add diagrams generated from actual models, labelled screenshot/demo placeholders until captured, accurate setup/CI instructions, and a short technical-challenges section. Keep the existing Vietnamese setup details accessible if useful.
- **Intern relevance:** Clear, honest presentation improves reviewability in a short screening window.
- **Effort:** 1–2 days after P0/P1.

## 12. Confirmed features and incomplete edges

Confirmed in code: movie browsing/filtering, showtimes, room/seat admin, voucher CRUD, registration/login, profile/password change, guest and signed-in holds, two-minute expiry scheduler, simulated payment, admin confirmation, admin stats, ticket tabs, and optional Gemini chatbot. Active `PENDING` holds are already classified into the frontend **“Sắp chiếu”** tab in `MyTickets.tsx`; the earlier tab issue is not an open finding here.

Not implemented or not evidenced: verified real payment, email delivery despite UI copy promising an email, comprehensive booking/concurrency tests, controlled DB migrations, CI, production health/readiness validation, recruiter-ready English documentation and screenshots. These are not all required features; the roadmap prioritizes the ones that demonstrate backend correctness. No deployment availability, live seat race, credential validity, or load capacity was tested.
