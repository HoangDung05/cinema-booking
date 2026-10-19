package com.cinema.movie_booking.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Null;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingRequest {
    @Null(message = "userId must not be supplied")
    private Integer userId;
    @NotNull @Positive
    private Integer showtimeId;
    @NotEmpty @Size(max = 10)
    private List<@NotNull @Positive Integer> seatIds;
}
