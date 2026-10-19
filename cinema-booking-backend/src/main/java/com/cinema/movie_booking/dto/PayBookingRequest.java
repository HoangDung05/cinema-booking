package com.cinema.movie_booking.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PayBookingRequest {
    @NotBlank
    @Pattern(regexp = "MOMO|CARD", flags = Pattern.Flag.CASE_INSENSITIVE)
    private String paymentMethod;
    @Size(max = 50)
    private String voucherCode;
    @Email @Size(max = 100)
    private String guestEmail;
}
