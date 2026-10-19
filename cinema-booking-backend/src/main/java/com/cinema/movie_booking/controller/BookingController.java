package com.cinema.movie_booking.controller;

import com.cinema.movie_booking.dto.BookingRequest;
import com.cinema.movie_booking.dto.BookingResponse;
import com.cinema.movie_booking.dto.PayBookingRequest;
import com.cinema.movie_booking.dto.PriceCalculateRequest;
import com.cinema.movie_booking.dto.PriceCalculateResponse;
import com.cinema.movie_booking.entity.Booking;
import com.cinema.movie_booking.service.BookingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/bookings")
@RequiredArgsConstructor
public class BookingController {
    public static final String GUEST_PROOF_HEADER = "X-Guest-Booking-Proof";
    private final BookingService bookingService;

    @PostMapping("/calculate-price")
    public ResponseEntity<PriceCalculateResponse> calculatePrice(@Valid @RequestBody PriceCalculateRequest request)
            throws Exception {
        return ResponseEntity.ok(bookingService.calculatePrice(request));
    }

    @PostMapping("/hold")
    public ResponseEntity<BookingResponse> holdBooking(@Valid @RequestBody BookingRequest request,
                                                        Authentication authentication) throws Exception {
        return ResponseEntity.ok(bookingService.holdBooking(request, authentication));
    }

    @PostMapping("/{id}/pay")
    public ResponseEntity<BookingResponse> payBooking(@PathVariable Integer id,
                                                       @Valid @RequestBody PayBookingRequest request,
                                                       Authentication authentication,
                                                       @RequestHeader(value = GUEST_PROOF_HEADER, required = false)
                                                       String guestProof) throws Exception {
        return ResponseEntity.ok(bookingService.payBooking(id, request, authentication, guestProof));
    }

    @PostMapping("/{id}/confirm")
    public ResponseEntity<BookingResponse> confirmBooking(@PathVariable Integer id) throws Exception {
        return ResponseEntity.ok(bookingService.confirmBooking(id));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getBookingDetails(
            @PathVariable Integer id, Authentication authentication,
            @RequestHeader(value = GUEST_PROOF_HEADER, required = false) String guestProof) throws Exception {
        Booking booking = bookingService.getBookingById(id, authentication, guestProof);
        Map<String, Object> response = new HashMap<>();
        response.put("id", booking.getId());
        response.put("status", booking.getStatus());
        response.put("createdAt", booking.getCreatedAt());
        response.put("totalPrice", booking.getTotalPrice());
        response.put("discountAmount", booking.getDiscountAmount());

        if (booking.getShowtime() != null) {
            Map<String, Object> showtimeData = new HashMap<>();
            showtimeData.put("showtimeId", booking.getShowtime().getId());
            showtimeData.put("startTime", booking.getShowtime().getStartTime());
            showtimeData.put("movieTitle", booking.getShowtime().getMovie().getTitle());
            showtimeData.put("movieDuration", booking.getShowtime().getMovie().getDuration());
            showtimeData.put("posterUrl", booking.getShowtime().getMovie().getPosterUrl());
            showtimeData.put("roomName", booking.getShowtime().getRoom().getName());
            showtimeData.put("cinemaName", booking.getShowtime().getRoom().getCinema().getName());
            response.put("showtime", showtimeData);
        }

        List<String> seats = booking.getBookingDetails().stream()
                .map(detail -> detail.getSeat().getSeatNumber()).toList();
        response.put("seats", seats);
        response.put("seatDetails", booking.getBookingDetails().stream().map(detail -> {
            Map<String, Object> seat = new HashMap<>();
            seat.put("id", detail.getSeat().getId());
            seat.put("seatNumber", detail.getSeat().getSeatNumber());
            return seat;
        }).toList());
        if (booking.getVoucher() != null) {
            response.put("voucherCode", booking.getVoucher().getCode());
        }
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> cancelBooking(
            @PathVariable Integer id, Authentication authentication,
            @RequestHeader(value = GUEST_PROOF_HEADER, required = false) String guestProof) throws Exception {
        bookingService.cancelBooking(id, authentication, guestProof);
        return ResponseEntity.ok(Map.of("message", "Booking cancelled."));
    }
}
