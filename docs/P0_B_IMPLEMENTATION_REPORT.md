# P0-B implementation report

Date: 2026-10-19 (Asia/Saigon). Scope: **Milestone P0-B only**. Changes are local and uncommitted. No Railway database, deployment, Git history, or live data was modified.

## 1. Changes and impacted files

### Backend

- `security/GuestBookingProofService.java`: creates and verifies a signed, booking-bound guest proof with a seven-day expiry.
- `web/ApiException.java` and `web/BookingAuthExceptionHandler.java`: stable client errors using `{code, message}`.
- `controller/BookingController.java` and `controller/AuthController.java`: use `@Valid`, authentication context, and the guest proof header.
- Booking, payment, price, login, and registration DTOs: request validation and removal of client supplied booking identity fields.
- `service/BookingService.java` and `service/impl/BookingServiceImpl.java`: ownership checks, guest proof checks, showtime/seat validation, payment validation, and authenticated identity derivation.
- `config/SecurityConfig.java`: leaves booking routes reachable for the service-level owner/proof decision while keeping admin confirmation protected.
- `BookingSecurityIntegrationTests.java`: H2/MockMvc authorization and validation coverage.

### Frontend

- Booking API calls no longer send `userId` or an email query as an identity claim.
- Guest proofs are passed through the booking route state and request headers; they are not stored in localStorage.
- Checkout, ticket history, seat selection, admin errors, and session handling were updated for the new response and error contract.

No database schema migration was introduced.

## 2. Booking authorization design

- Account identity is derived from Spring Security `Authentication.getName()` and the server-side user record. A client `userId` is rejected by validation and is never used as proof of identity.
- Reading, paying, and cancelling an account booking require the authenticated booking owner. An administrator cannot use these owner operations to access another customer's booking.
- Guest bookings require a valid proof bound to the requested booking ID. A numeric booking ID alone is insufficient.
- Admin-only confirmation remains protected by the existing `ADMIN` role rule.

## 3. Guest-booking proof flow

1. A guest holds seats without a logged-in account.
2. The hold response includes `guestProof` for that booking only.
3. The frontend keeps it in in-memory route state and sends it as `X-Guest-Booking-Proof` for booking detail, payment, and cancellation.
4. The backend verifies its signature, purpose, booking subject, expiry, and required guest booking state.

The proof is a bearer capability. Anyone who obtains it can use it until expiry; it is not persisted or revocable in this milestone. The signing key is derived from `JWT_SECRET`, so the environment secret must remain stable and private.

## 4. API contract and validation changes

- Hold requests contain `showtimeId` and `seatIds`; `userId` is not accepted.
- Booking detail, payment, and cancellation accept either the authenticated owner JWT or `X-Guest-Booking-Proof` for a guest booking.
- Payment methods are limited to `MOMO` and `CARD`; guest payment requires a valid email.
- Seat selections must be non-empty, positive, unique, and contain no more than 10 seats.
- Every selected seat must exist and belong to the room of the selected showtime.
- The showtime must exist, be in the future, have a positive price, and not reference an ended movie.
- Login, registration, price calculation, booking, and payment bodies use Bean Validation and `@Valid`.
- Validation and authorization failures use stable HTTP errors with a machine-readable `code` and user-facing `message`.

## 5. Frontend compatibility

Normal browse, hold, checkout, payment, ticket viewing, and cancellation flows continue through the existing routes. The client now forwards the server-issued guest proof and displays the stable backend message when a request is rejected. No sensitive guest proof is written to browser localStorage.

## 6. Tests executed

Environment: Windows 11, Oracle JDK **21.0.10**, Maven Wrapper **3.9.12**, Node **24.14.0**, npm **11.9.0**, Vite **6.4.1**.

| Command | Result |
| --- | --- |
| `mvnw.cmd clean test -q` with `JAVA_HOME` set to JDK 21 | **Passed**; 12 tests, 0 failures, 0 errors, 0 skipped |
| `mvnw.cmd clean test -q -Dtest=BookingSecurityIntegrationTests` | **Passed**; focused P0-B security suite passed |
| `npm run lint` | **Passed**; TypeScript `tsc --noEmit` |
| `npm run build` | **Passed**; 130 modules transformed |
| `git diff --check` | **Passed**; only normal LF/CRLF notices from Git |

The integration suite covers anonymous, customer, owner, guest-proof, and admin authorization cases; invalid room-seat combinations; empty, duplicate, negative, and excessive seat lists; invalid registration/payment requests; and client-supplied user ID rejection. Tests use an isolated in-memory H2 database and do not contact Railway.

## 7. Remaining risks

- P0-C concurrency and race-condition handling is intentionally not implemented.
- Guest proofs are bearer credentials with a seven-day lifetime and no revocation store.
- H2 integration tests do not prove MySQL-specific behavior or production networking.
- Existing application-wide error handling and schema evolution concerns remain outside P0-B.
- Historical secrets and personal-data exposure listed in P0-A remain owner actions; no credential rotation or Git history rewrite was performed.

## 8. Acceptance criteria checklist

- [x] Booking identity is derived server-side from authentication.
- [x] Booking detail, payment, and cancellation enforce ownership.
- [x] Guest access requires a signed, booking-bound proof.
- [x] Showtime, room-seat, seat-list, payment, login, and registration validation is enforced server-side.
- [x] Frontend booking and guest flows use the updated contract without persistent guest proofs.
- [x] Automated authorization and validation tests were added and passed on Java 21.
- [x] Existing frontend typecheck and production build passed.
- [x] No live Railway database, deployment, payment gateway, or P0-C concurrency code was changed.
- [x] No commit or push was performed.

**Code-level P0-B acceptance criteria are satisfied locally.** This report stops at P0-B for review.
