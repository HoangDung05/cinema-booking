package com.cinema.movie_booking.dto;

import lombok.Data;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.util.List;

@Data
public class PriceCalculateRequest {
    @NotNull @Positive
    private Integer showtimeId;
    @NotEmpty @Size(max = 10)
    private List<@NotNull @Positive Integer> seatIds;
    @Size(max = 50)
    private String voucherCode; // Optional - có thể null nếu không dùng voucher
}
