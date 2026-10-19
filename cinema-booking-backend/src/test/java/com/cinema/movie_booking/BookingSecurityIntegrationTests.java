package com.cinema.movie_booking;

import com.cinema.movie_booking.entity.*;
import com.cinema.movie_booking.repository.*;
import com.cinema.movie_booking.security.JwtUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@AutoConfigureMockMvc
@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:cinema_p0b_test;MODE=MySQL;DB_CLOSE_DELAY=-1",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.jpa.hibernate.ddl-auto=create-drop",
        "JWT_SECRET=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
})
class BookingSecurityIntegrationTests {
    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private JwtUtils jwtUtils;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private RoleRepository roleRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private CinemaRepository cinemaRepository;
    @Autowired private RoomRepository roomRepository;
    @Autowired private MovieRepository movieRepository;
    @Autowired private ShowtimeRepository showtimeRepository;
    @Autowired private SeatRepository seatRepository;
    @Autowired private BookingRepository bookingRepository;

    private User owner;
    private User otherCustomer;
    private User admin;
    private Showtime showtime;
    private Seat seatA;
    private Seat seatB;
    private Seat otherRoomSeat;

    @BeforeEach
    void fixture() {
        String suffix = UUID.randomUUID().toString().substring(0, 8);
        Role customerRole = roleRepository.findByName("CUSTOMER").orElseGet(() -> {
            Role role = new Role();
            role.setName("CUSTOMER");
            return roleRepository.save(role);
        });
        Role adminRole = roleRepository.findByName("ADMIN").orElseGet(() -> {
            Role role = new Role();
            role.setName("ADMIN");
            return roleRepository.save(role);
        });
        owner = userRepository.save(user("owner-" + suffix + "@example.test", customerRole));
        otherCustomer = userRepository.save(user("other-" + suffix + "@example.test", customerRole));
        admin = userRepository.save(user("admin-" + suffix + "@example.test", adminRole));

        Cinema cinema = new Cinema();
        cinema.setName("Test cinema " + suffix);
        cinema = cinemaRepository.save(cinema);
        Room room = new Room();
        room.setName("Room A");
        room.setCinema(cinema);
        room = roomRepository.save(room);
        Room otherRoom = new Room();
        otherRoom.setName("Room B");
        otherRoom.setCinema(cinema);
        otherRoom = roomRepository.save(otherRoom);

        Movie movie = new Movie();
        movie.setTitle("Synthetic film " + suffix);
        movie.setDuration(100);
        movie.setStatus(MovieStatus.NOW_SHOWING);
        movie = movieRepository.save(movie);
        showtime = new Showtime();
        showtime.setMovie(movie);
        showtime.setRoom(room);
        showtime.setStartTime(LocalDateTime.now().plusDays(2));
        showtime.setPrice(new BigDecimal("75000"));
        showtime = showtimeRepository.save(showtime);
        seatA = seatRepository.save(seat(room, "A1"));
        seatB = seatRepository.save(seat(room, "A2"));
        otherRoomSeat = seatRepository.save(seat(otherRoom, "B1"));
    }

    private User user(String email, Role role) {
        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode("test-password"));
        user.setFullName("Synthetic tester");
        user.setPhone("0900000000");
        user.setRole(role);
        return user;
    }

    private Seat seat(Room room, String number) {
        Seat seat = new Seat();
        seat.setRoom(room);
        seat.setSeatNumber(number);
        return seat;
    }

    private String token(User user) {
        return jwtUtils.generateJwtToken(user.getEmail());
    }

    private MockHttpServletRequestBuilder as(MockHttpServletRequestBuilder request, User user) {
        return request.header("Authorization", "Bearer " + token(user));
    }

    private String json(Object body) throws Exception {
        return objectMapper.writeValueAsString(body);
    }

    private JsonNode hold(Seat seat, User user) throws Exception {
        MockHttpServletRequestBuilder request = post("/api/bookings/hold").contextPath("/api")
                .contentType(MediaType.APPLICATION_JSON)
                .content(json(Map.of("showtimeId", showtime.getId(), "seatIds", List.of(seat.getId()))));
        if (user != null) request = as(request, user);
        String body = mockMvc.perform(request).andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(body);
    }

    private MockHttpServletRequestBuilder pay(int bookingId, String method, String email, String proof)
            throws Exception {
        String body = email == null
                ? json(Map.of("paymentMethod", method))
                : json(Map.of("paymentMethod", method, "guestEmail", email));
        MockHttpServletRequestBuilder request = post("/api/bookings/{id}/pay", bookingId).contextPath("/api")
                .contentType(MediaType.APPLICATION_JSON).content(body);
        if (proof != null) request.header("X-Guest-Booking-Proof", proof);
        return request;
    }

    @Test
    void anonymousCannotReadPayOrCancelAccountBookingByNumber() throws Exception {
        int id = hold(seatA, owner).get("bookingId").asInt();
        mockMvc.perform(get("/api/bookings/{id}", id).contextPath("/api"))
                .andExpect(status().isUnauthorized()).andExpect(jsonPath("$.code").value("AUTH_REQUIRED"));
        mockMvc.perform(pay(id, "MOMO", null, null))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(delete("/api/bookings/{id}", id).contextPath("/api"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void anotherCustomerIsForbiddenAndOwnerCanReadPayAndCancel() throws Exception {
        int id = hold(seatA, owner).get("bookingId").asInt();
        mockMvc.perform(as(get("/api/bookings/{id}", id).contextPath("/api"), otherCustomer))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("BOOKING_FORBIDDEN"));
        mockMvc.perform(as(pay(id, "CARD", null, null), otherCustomer))
                .andExpect(status().isForbidden());
        mockMvc.perform(as(pay(id, "CARD", null, null), admin))
                .andExpect(status().isForbidden());
        mockMvc.perform(as(delete("/api/bookings/{id}", id).contextPath("/api"), otherCustomer))
                .andExpect(status().isForbidden());
        mockMvc.perform(as(get("/api/bookings/{id}", id).contextPath("/api"), owner))
                .andExpect(status().isOk()).andExpect(jsonPath("$.id").value(id));
        org.junit.jupiter.api.Assertions.assertEquals(owner.getId(),
                bookingRepository.findById(id).orElseThrow().getUser().getId());
        mockMvc.perform(as(pay(id, "CARD", null, null), owner))
                .andExpect(status().isOk()).andExpect(jsonPath("$.guestProof").isEmpty());

        int cancellable = hold(seatB, owner).get("bookingId").asInt();
        mockMvc.perform(as(delete("/api/bookings/{id}", cancellable).contextPath("/api"), owner))
                .andExpect(status().isOk());
        org.junit.jupiter.api.Assertions.assertEquals(
                "CANCELLED", bookingRepository.findById(cancellable).orElseThrow().getStatus());
    }

    @Test
    void guestProofIsRequiredValidatedAndBoundToOneBooking() throws Exception {
        JsonNode first = hold(seatA, null);
        int id = first.get("bookingId").asInt();
        String proof = first.get("guestProof").asText();
        JsonNode second = hold(seatB, null);
        int otherId = second.get("bookingId").asInt();

        mockMvc.perform(get("/api/bookings/{id}", id).contextPath("/api"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("GUEST_PROOF_REQUIRED"));
        mockMvc.perform(get("/api/bookings/{id}", id).contextPath("/api")
                        .header("X-Guest-Booking-Proof", "invalid"))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.code").value("GUEST_PROOF_INVALID"));
        mockMvc.perform(get("/api/bookings/{id}", otherId).contextPath("/api")
                        .header("X-Guest-Booking-Proof", proof))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/api/bookings/{id}", id).contextPath("/api")
                        .header("X-Guest-Booking-Proof", proof))
                .andExpect(status().isOk());
        mockMvc.perform(pay(id, "MOMO", "guest@example.test", null))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(pay(id, "MOMO", "guest@example.test", proof))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.guestProof").isEmpty());
        mockMvc.perform(delete("/api/bookings/{id}", otherId).contextPath("/api")
                        .header("X-Guest-Booking-Proof", proof))
                .andExpect(status().isForbidden());
        mockMvc.perform(delete("/api/bookings/{id}", otherId).contextPath("/api")
                        .header("X-Guest-Booking-Proof", second.get("guestProof").asText()))
                .andExpect(status().isOk());
    }

    @Test
    void seatRoomAndSeatListValidationRejectsInvalidRequests() throws Exception {
        String wrongRoom = json(Map.of("showtimeId", showtime.getId(),
                "seatIds", List.of(otherRoomSeat.getId())));
        mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON).content(wrongRoom))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("SEAT_ROOM_MISMATCH"));
        mockMvc.perform(post("/api/bookings/calculate-price").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON).content(wrongRoom))
                .andExpect(status().isBadRequest());
        for (List<Integer> ids : List.of(List.<Integer>of(), List.of(seatA.getId(), seatA.getId()),
                List.of(-1), List.of(seatA.getId(), seatA.getId(), seatA.getId(),
                        seatA.getId(), seatA.getId(), seatA.getId(), seatA.getId(),
                        seatA.getId(), seatA.getId(), seatA.getId(), seatA.getId()))) {
            mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(json(Map.of("showtimeId", showtime.getId(), "seatIds", ids))))
                    .andExpect(status().isBadRequest());
        }
        mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json(Map.of("userId", otherCustomer.getId(),
                                "showtimeId", showtime.getId(), "seatIds", List.of(seatA.getId())))))
                .andExpect(status().isBadRequest());
        mockMvc.perform(as(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json(Map.of("userId", otherCustomer.getId(),
                                "showtimeId", showtime.getId(), "seatIds", List.of(seatA.getId())))), owner))
                .andExpect(status().isBadRequest());
        mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"showtimeId\":" + showtime.getId() + ",\"seatIds\":\"bad\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void unavailableAndMissingShowtimesAreRejected() throws Exception {
        String missing = json(Map.of("showtimeId", 999999, "seatIds", List.of(seatA.getId())));
        mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON).content(missing))
                .andExpect(status().isNotFound());
        showtime.setStartTime(LocalDateTime.now().minusMinutes(1));
        showtimeRepository.save(showtime);
        String past = json(Map.of("showtimeId", showtime.getId(), "seatIds", List.of(seatA.getId())));
        mockMvc.perform(post("/api/bookings/hold").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON).content(past))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SHOWTIME_UNAVAILABLE"));
    }

    @Test
    void invalidRegistrationAndPaymentRequestsReturnClientErrors() throws Exception {
        String badRegistration = json(Map.of("email", "not-an-email", "password", "short",
                "fullName", " ", "phone", "abc"));
        mockMvc.perform(post("/api/auth/register").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON).content(badRegistration))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("INVALID_REQUEST"));
        mockMvc.perform(post("/api/auth/register").contextPath("/api")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json(Map.of("email", "new-" + UUID.randomUUID() + "@example.test",
                                "password", "valid-pass", "fullName", "Synthetic guest",
                                "phone", "0900000001"))))
                .andExpect(status().isOk());
        JsonNode guest = hold(seatA, null);
        int id = guest.get("bookingId").asInt();
        String proof = guest.get("guestProof").asText();
        mockMvc.perform(pay(id, "CASH", "guest@example.test", proof))
                .andExpect(status().isBadRequest());
        mockMvc.perform(pay(id, "MOMO", "not-an-email", proof))
                .andExpect(status().isBadRequest());
        mockMvc.perform(pay(id, "MOMO", null, proof))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("GUEST_EMAIL_REQUIRED"));
    }

    @Test
    void adminCustomerAndAnonymousPermissionsRemainServerEnforced() throws Exception {
        mockMvc.perform(get("/api/admin/bookings").contextPath("/api"))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(as(get("/api/admin/bookings").contextPath("/api"), owner))
                .andExpect(status().isForbidden());
        mockMvc.perform(as(get("/api/admin/bookings").contextPath("/api"), admin))
                .andExpect(status().isOk());
        JsonNode guest = hold(seatA, null);
        int id = guest.get("bookingId").asInt();
        mockMvc.perform(pay(id, "MOMO", "guest@example.test", guest.get("guestProof").asText()))
                .andExpect(status().isOk());
        mockMvc.perform(post("/api/bookings/{id}/confirm", id).contextPath("/api"))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(as(post("/api/bookings/{id}/confirm", id).contextPath("/api"), owner))
                .andExpect(status().isForbidden());
        mockMvc.perform(as(post("/api/bookings/{id}/confirm", id).contextPath("/api"), admin))
                .andExpect(status().isOk());
    }
}
