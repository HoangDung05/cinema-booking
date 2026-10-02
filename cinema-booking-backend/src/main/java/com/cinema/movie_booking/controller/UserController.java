package com.cinema.movie_booking.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cinema.movie_booking.dto.ChangePasswordRequest;
import com.cinema.movie_booking.entity.User;
import com.cinema.movie_booking.service.BookingService;
import com.cinema.movie_booking.service.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final BookingService bookingService;
    private final com.cinema.movie_booking.service.VoucherService voucherService;

    // Lấy thông tin cá nhân của người dùng đã đăng nhập.
    @GetMapping("/me")
    public ResponseEntity<?> getMyProfile(Authentication authentication) {
        return ResponseEntity.ok(userService.getByEmail(authentication.getName()));
    }

    // Cập nhật thông tin cá nhân của người dùng đã đăng nhập.
    @PutMapping("/me")
    public ResponseEntity<?> updateMyProfile(Authentication authentication, @RequestBody User user) {
        return ResponseEntity.ok(userService.updateProfile(authentication.getName(), user, true));
    }

    @PutMapping("/me/change-password")
    public ResponseEntity<?> changeMyPassword(Authentication authentication, @RequestBody ChangePasswordRequest request) {
        try {
            userService.changePassword(authentication.getName(), request.getCurrentPassword(), request.getNewPassword());
            return ResponseEntity.ok("Đổi mật khẩu thành công.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Lấy lịch sử đặt vé của người dùng đã đăng nhập.
    @GetMapping("/me/bookings")
    public ResponseEntity<?> getUserBookingHistory(Authentication authentication) {
        try {
            return ResponseEntity.ok(bookingService.getUserBookings(authentication.getName()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi khi lấy lịch sử đặt vé: " + e.getMessage());
        }
    }

    // Lấy voucher đang hoạt động.
    @GetMapping("/me/vouchers")
    public ResponseEntity<?> getMyVouchers() {
        try {
            return ResponseEntity.ok(voucherService.getActiveVouchers());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
