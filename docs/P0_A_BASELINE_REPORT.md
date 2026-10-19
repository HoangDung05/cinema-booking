# P0-A baseline and repository data report

Date: 2026-10-18 (Asia/Saigon). Scope: **Milestone P0-A only** on the local `improve/backend-portfolio` checkout. This report contains no credential values or personal records. No Railway database, deployment, Git history, booking logic, authorization, reservation, or payment behavior was changed.

## Issues discovered

1. The previously tracked `init.sql` was a local database export containing person-like names, contact details, password hashes, bookings and payments. Their provenance/consent cannot be established from the repository. The old rows remain in Git history even after changing the working file.
2. The README published fixed local demo account credentials, while `.env.example` proposed a trivial MySQL root password. Reusing either outside a disposable local environment would be unsafe.
3. A Google API-key-shaped literal appears in historical backend commits. The current source reads `GEMINI_API_KEY` from the environment, and the current tracked-file scan found no key-shaped literal. Validity/reuse of the historical key was **not** tested.
4. The terminal's default `java`/`JAVA_HOME` pointed to Java 8, although the project targets Java 21. This explains the original class-file-version 65 versus 52 test failure.
5. An old `target/` class produced `ClassFormatError` on a no-clean test run. `clean` removed this stale build output. Subsequent Java 21 tests started but stalled while the Byte Buddy agent attached dynamically on this Windows environment; a Surefire JVM startup agent resolved the stall. The Windows attach pipe error is evidence of an environment-dependent attach problem, not evidence of a failing test assertion.

## Changes made

| File | Change |
| --- | --- |
| `init.sql` | Replaced the tracked export with synthetic catalog seed data: same 11 table definitions, columns, keys, foreign keys and constraints as the previous script; no user, booking or payment inserts. No `DROP TABLE` commands. Intended only for a new empty database. |
| `.env.example` | Removed the example root-password value; private values are blank placeholders. |
| `README.md` | Removed fixed account credentials; documented local self-registration and optional local admin promotion, fresh-database-only SQL import, and Java 21 test command. |
| `cinema-booking-backend/pom.xml` | Configured the existing Maven Surefire test JVM to preload the already-resolved Byte Buddy agent, avoiding dynamic attach. No dependency was added. |
| `docs/P0_A_BASELINE_REPORT.md` | Added this evidence and action list. |

No other application source files were changed. The two earlier audit/roadmap documents remain untracked from the previous milestone and are outside this implementation. A review of the current worktree found only these four expected tracked-file changes and the three P0-A/audit documents; no unintended application changes were found. `git diff --check` exited 0 (Git emitted only LF-to-CRLF working-copy notices).

## Sensitive-data remediation and verification

- Compared normalized `CREATE TABLE` bodies from the old `init.sql` and the replacement: **all 11 matched** for columns, keys and constraints after ignoring dump-specific `AUTO_INCREMENT=<next ID>` counters and the replacement's `IF NOT EXISTS` clause. The replacement local seed uses synthetic movie/cinema/room/seat/showtime rows. It does not create login accounts.
- Static scan of the new `init.sql`: 11 `CREATE TABLE` statements; **0** `users`, `bookings`, or `payments` inserts; **0** email-like strings, BCrypt hashes, or `DROP TABLE` statements. The SQL was imported only into a newly created disposable database, as detailed below.
- `.gitignore` excludes root `.env` and `.env.*` except `.env.example`; frontend has its own `.env*` ignore rule. `git check-ignore` confirmed root `.env` is ignored; `git ls-files` found no tracked real `.env` file. An existing ignored local `.env` was **not read or changed**.
- A working-tree scan of tracked text files found no Google API-key-shaped literal, PEM private-key header, or JWT-shaped token. This is a pattern scan, not a full secret-scanning certification.

## Disposable MySQL import and verification (2026-10-18)

Used the installed **MySQL Community Server 8.0.44 for Windows**, with a freshly initialized data directory under the operating system's temporary directory. The server was started with `--skip-networking`, `--shared-memory=ON`, and a unique shared-memory name; querying its settings returned shared memory **1** and skip networking **1**. The client created a new empty `cinema_p0a_verify_*` database, then executed `source D:/Project/cinema-booking/init.sql` with UTF-8 (`utf8mb4`). **Create and import both exited 0.** No Railway connection, existing local database, Docker volume, or existing Docker container was used. The temporary server was stopped and both scratch data directories were removed after verification.

The first attempt to start a scratch MySQL data directory on the workspace drive failed before any SQL import with MySQL InnoDB error `MY-013039` (an undo tablespace file already existed). A separately initialized data directory under the OS temporary directory started successfully. This was a local server startup issue, not an `init.sql` error.

Queries against `information_schema` and the imported catalog returned:

| Check | Observed result |
| --- | --- |
| Import into empty database | Exit **0**, no SQL error |
| Tables | **11**: `booking_details`, `bookings`, `cinemas`, `movies`, `payments`, `roles`, `rooms`, `seats`, `showtimes`, `users`, `vouchers` |
| Primary keys | **11**; each table has `id` as its primary-key column |
| Foreign keys | **12**; `booking_details` → bookings/seats/showtimes (3), `bookings` → showtimes/users/vouchers (3), `payments` → bookings (1), `rooms` → cinemas (1), `seats` → rooms (1), `showtimes` → movies/rooms (2), `users` → roles (1) |
| Seed rows | roles **2**, cinemas **1**, movies **3**, rooms **3**, seats **144**, showtimes **1095** |
| Private/transactional rows | vouchers **0**, users **0**, bookings **0**, booking_details **0**, payments **0** |
| Catalog relationship checks | **0** orphan rooms, seats, showtime→movie references, or showtime→room references |

Verification used `information_schema.tables`, `information_schema.table_constraints`, and `information_schema.key_column_usage` for table/constraint counts and mappings, plus `COUNT(*)` and left-join orphan checks on the imported tables. This proves this seed imports on MySQL 8.0.44 into a fresh database; it does not test upgrading an existing database.

## Manual security actions still required

1. **Revoke/rotate the historical Google API key** in the provider console if it was ever valid. Check usage/billing for unexpected activity, then update only the secret value stored in Railway/local environment. Do not paste the key into issues or Git.
2. **Review old SQL records and consent.** The old `init.sql` contents remain in reachable Git history and may already be present in remote clones. Decide with affected people whether history rewrite/removal is needed. No history rewrite was performed because it is destructive and requires separate approval and coordination with anyone who cloned the repository.
3. **Rotate any reused account, database, or JWT credentials.** The audit cannot determine whether old demo passwords or local secrets were reused in Railway or elsewhere. Change them in the owning service, then update environment variables securely. A JWT-secret rotation invalidates existing tokens.
4. **Handle existing local databases separately.** Changing a SQL file does not erase old rows in an already initialized MySQL volume/database. Do not run `docker compose down -v` or re-import scripts until the owner has backed up or explicitly approved disposal of that data.

## Environment and command outcomes

| Command / check | Environment | Result |
| --- | --- | --- |
| `java -version` with terminal default | Corretto Java 8 | Java 8 detected; unsuitable for this Java 21 project. |
| `mvnw.cmd test -q` with default Java | Java 8 | **Failed**: class file version 65 requires Java 21 (Java 8 supports up to 52). |
| Java 21 Maven version check | Oracle JDK **21.0.10**, Maven Wrapper **3.9.12**, Windows 11 | Confirmed Maven itself ran on JDK 21 after setting `JAVA_HOME` and prepending its `bin` directory to `PATH`. |
| `mvnw.cmd -DforkCount=0 test` | JDK 21, stale `target` | **Failed** with `ClassFormatError` in a cached compiled entity class; no test pass claimed. |
| `mvnw.cmd clean test` before Surefire change | JDK 21 | Started Spring/H2, then stalled after context startup and was interrupted. No test result claimed. |
| `mvnw.cmd -DargLine=-javaagent:<resolved-agent-jar> test -q` | JDK 21 | **Passed**, exit 0; established that preloading the agent avoided the observed stall. |
| `mvnw.cmd clean test -q` with checked-in Surefire configuration | JDK 21, H2 in-memory | **Passed**, exit 0; fresh Surefire report dated 2026-10-18 shows **5 tests, 0 failures, 0 errors, 0 skipped**. No MySQL or Railway was needed. |
| `npm run lint` | Node **24.14.0**, npm **11.9.0** | **Passed**, exit 0. The script runs `tsc --noEmit`, not ESLint. |
| `npm run build` | Same Node/npm; installed Vite **6.4.1** | **Passed**, exit 0; 130 modules transformed. |
| Disposable MySQL 8.0.44 `CREATE DATABASE` then `source .../init.sql` | New scratch data directory, shared-memory transport, TCP disabled | **Passed**, both exit 0; 11 tables, 11 primary keys, 12 foreign keys and seed counts verified above. |
| Repeat `mvnw.cmd clean test -q` and `mvnw.cmd -version` | Oracle JDK **21.0.10**, Maven Wrapper **3.9.12**, Windows 11 | **Passed**, exit 0 on 2026-10-18; fresh Surefire XML: **5 tests, 0 failures, 0 errors, 0 skipped**. |
| Repeat `npm run lint` and `npm run build` | Node **24.14.0**, npm **11.9.0**, Vite **6.4.1** | **Passed**, exit 0 for each on 2026-10-18; typecheck clean and 130 modules transformed. |
| `git diff --check` and worktree file review | Local checkout | **Passed**, exit 0; expected four tracked-file edits and three untracked audit/P0-A documents only. LF-to-CRLF notices are not whitespace errors. |

Reproducible backend test command on Windows PowerShell (replace the JDK path with the installed JDK 21 location):

```powershell
$env:JAVA_HOME = 'C:\path\to\jdk-21'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
cd D:\Project\cinema-booking\cinema-booking-backend
java -version
.\mvnw.cmd clean test
```

The `clean` step avoids stale/partial classes. The checked-in Surefire setting uses the Byte Buddy version managed by the Spring Boot parent and Maven's local repository; it adds no runtime behavior to the application. Test assertions are not skipped or suppressed. A custom Maven repository layout or future Spring Boot dependency change should be checked on CI when CI is introduced.

## Remaining risks and limits

- Historical SQL data and a historical key-shaped literal are still present in Git history. Rotating a key and any history rewrite are manual follow-ups; neither occurred here.
- Existing MySQL instances/volumes were not inspected or modified. The fresh import passed on MySQL 8.0.44; compatibility with other MySQL versions or re-importing into existing data was not tested.
- The five passing tests cover startup, catalog exposure, anonymous admin denial and CORS. They do **not** establish booking correctness, ownership, concurrency, real payment, or live Railway health. Those belong to later approved milestones.
- The frontend build and backend H2 tests do not verify the public Vercel/Railway deployment. No deployment was attempted.

## P0-A acceptance checklist

- [x] Inspect tracked SQL, README, environment examples, configuration and ignore rules.
- [x] Replace current tracked local personal-looking dataset with synthetic seed while preserving schema/relationships/constraints.
- [x] Remove published fixed local demo credentials and trivial example database password.
- [x] Confirm local `.env` is ignored and no real `.env` is tracked.
- [x] Identify historical exposure and document manual rotation/revocation and Git-history decision.
- [x] Select Java 21, diagnose the interrupted test run, and establish a clean reproducible Maven test command.
- [x] Run the existing backend tests and frontend typecheck/build; record fresh exit status and versions.
- [ ] Manual revocation/rotation and any Git-history cleanup, if needed — owner/provider action; no destructive operation authorized here.
- [x] Import `init.sql` into a disposable empty MySQL 8.0.44 database and verify all 11 tables, 11 primary keys, 12 foreign keys, seed counts, and catalog references.

**Code-level P0-A verdict:** the current working-tree content and local verification satisfy the P0-A acceptance criteria. Historical data/key exposure, any credential reuse, owner/provider rotation or revocation, and the separate Git-history decision remain unresolved owner actions. No commit, push, deploy, remote credential rotation, or history rewrite was performed.
