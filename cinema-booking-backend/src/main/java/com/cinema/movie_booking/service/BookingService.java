package com.cinema.movie_booking.service;

import java.util.List;

import com.cinema.movie_booking.dto.AdminStatsDTO;
import com.cinema.movie_booking.dto.BookingHistoryDTO;
import com.cinema.movie_booking.dto.BookingRequest;
import com.cinema.movie_booking.dto.BookingResponse;
import com.cinema.movie_booking.dto.PayBookingRequest;
import com.cinema.movie_booking.dto.PriceCalculateRequest;
import com.cinema.movie_booking.dto.PriceCalculateResponse;
import com.cinema.movie_booking.entity.Booking;
import org.springframework.security.core.Authentication;

public interface BookingService {
    List<Booking> getAllBookingsForAdmin();

    AdminStatsDTO getAdminStats();

    PriceCalculateResponse calculatePrice(PriceCalculateRequest request) throws Exception;

    BookingResponse holdBooking(BookingRequest request, Authentication authentication) throws Exception;

    BookingResponse payBooking(Integer bookingId, PayBookingRequest request,
                               Authentication authentication, String guestProof) throws Exception;

    BookingResponse confirmBooking(Integer bookingId) throws Exception;

    List<BookingHistoryDTO> getUserBookings(String email);

    Booking getBookingById(Integer id, Authentication authentication, String guestProof) throws Exception;

    void cancelBooking(Integer id, Authentication authentication, String guestProof) throws Exception;
}
