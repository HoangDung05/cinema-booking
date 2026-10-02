-- Cinema Ticket Booking - sanitized Railway demo database
-- Chạy trên database MySQL mới, trống. Không chứa dữ liệu người dùng thật.
-- Không dùng init.sql: file đó có người dùng, đơn hàng và lịch chiếu cũ.
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cinemas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `movies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `duration` int NOT NULL,
  `release_date` date DEFAULT NULL,
  `poster_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trailer_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('COMING_SOON','NOW_SHOWING','ENDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'COMING_SOON',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `discount_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(38,2) NOT NULL,
  `min_order_value` decimal(38,2) DEFAULT NULL,
  `max_discount_amount` decimal(38,2) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `usage_limit` int DEFAULT '1',
  `used_count` int DEFAULT '0',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cinema_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cinema_id` (`cinema_id`,`name`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`cinema_id`) REFERENCES `cinemas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `seats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_id` (`room_id`,`seat_number`),
  CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `showtimes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `movie_id` int NOT NULL,
  `room_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `price` decimal(38,2) NOT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_id` (`room_id`,`start_time`),
  KEY `movie_id` (`movie_id`),
  CONSTRAINT `showtimes_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`),
  CONSTRAINT `showtimes_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `showtime_id` int NOT NULL,
  `total_price` decimal(38,2) DEFAULT NULL,
  `status` enum('PENDING','AWAITING_CONFIRMATION','PAID','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `voucher_id` int DEFAULT NULL,
  `discount_amount` decimal(38,2) DEFAULT NULL,
  `guest_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `showtime_id` (`showtime_id`),
  KEY `fk_booking_voucher` (`voucher_id`),
  KEY `bookings_ibfk_1` (`user_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`showtime_id`) REFERENCES `showtimes` (`id`),
  CONSTRAINT `fk_booking_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `booking_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `showtime_id` int NOT NULL,
  `seat_id` int NOT NULL,
  `price_at_booking` decimal(38,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  KEY `seat_id` (`seat_id`),
  KEY `idx_showtime_id` (`showtime_id`),
  CONSTRAINT `booking_details_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `booking_details_ibfk_2` FOREIGN KEY (`showtime_id`) REFERENCES `showtimes` (`id`),
  CONSTRAINT `booking_details_ibfk_3` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(38,2) NOT NULL,
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('SUCCESS','FAILED','PENDING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chỉ chạy phần dữ liệu một lần trên database mới, trống.
-- Tài khoản demo sẽ được tạo riêng sau khi backend chạy; không chép user thật lên cloud.
INSERT INTO `roles` (`id`, `name`) VALUES
  (1, 'CUSTOMER'),
  (2, 'ADMIN');

INSERT INTO `cinemas` (`id`, `name`, `address`) VALUES
  (1, 'Group3 Cinema – Chi nhánh trung tâm', 'Địa chỉ demo');

INSERT INTO `rooms` (`id`, `name`, `cinema_id`) VALUES
  (1, 'Phòng 1', 1),
  (2, 'Phòng 2', 1),
  (3, 'Phòng 3', 1);

INSERT INTO `movies`
  (`id`, `title`, `description`, `duration`, `release_date`, `poster_url`, `trailer_url`, `status`)
VALUES
  (1, 'Chuyến Tàu Sao Mai', 'Phim phiêu lưu giả lập dùng cho bản demo đặt vé.', 115, CURDATE(), NULL, NULL, 'NOW_SHOWING'),
  (2, 'Khu Vườn Ánh Sáng', 'Phim gia đình giả lập dùng cho bản demo đặt vé.', 105, CURDATE(), NULL, NULL, 'NOW_SHOWING'),
  (3, 'Mật Mã Nửa Đêm', 'Phim bí ẩn giả lập dùng cho bản demo đặt vé.', 120, CURDATE(), NULL, NULL, 'NOW_SHOWING');

-- 6 hàng x 8 ghế/phòng, cùng sơ đồ mà backend tạo mặc định.
INSERT INTO `seats` (`seat_number`, `room_id`)
SELECT CONCAT(seat_rows.row_name, seat_columns.column_number), rooms.id
FROM `rooms`
CROSS JOIN (
  SELECT 'A' AS row_name UNION ALL SELECT 'B' UNION ALL SELECT 'C'
  UNION ALL SELECT 'D' UNION ALL SELECT 'E' UNION ALL SELECT 'F'
) AS seat_rows
CROSS JOIN (
  SELECT 1 AS column_number UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
) AS seat_columns
WHERE rooms.id IN (1, 2, 3);

-- Ba suất chiếu mỗi ngày trong 365 ngày tính từ ngày nạp dữ liệu.
-- Mỗi phim có một phòng riêng; các khung giờ không đè nhau.
INSERT INTO `showtimes` (`movie_id`, `room_id`, `start_time`, `price`)
SELECT slots.movie_id, slots.room_id,
       TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL (hundreds.n * 100 + tens.n * 10 + ones.n) DAY), slots.start_at),
       slots.price
FROM (
  SELECT 1 AS movie_id, 1 AS room_id, '10:00:00' AS start_at, 75000.00 AS price
  UNION ALL SELECT 2, 2, '14:00:00', 85000.00
  UNION ALL SELECT 3, 3, '18:00:00', 95000.00
) AS slots
CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) AS hundreds
CROSS JOIN (
  SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) AS tens
CROSS JOIN (
  SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) AS ones
WHERE hundreds.n * 100 + tens.n * 10 + ones.n < 365;
