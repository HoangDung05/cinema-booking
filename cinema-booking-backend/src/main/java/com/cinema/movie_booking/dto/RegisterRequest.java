package com.cinema.movie_booking.dto;
import lombok.Data;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Data
public class RegisterRequest {
    @NotBlank @Email @Size(max = 100)
    private String email;
    @NotBlank @Size(min = 6, max = 72)
    private String password;
    @NotBlank @Size(max = 100)
    private String fullName;
    @NotBlank @Pattern(regexp = "\\d{10}")
    private String phone;
}
