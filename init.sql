-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: cinema_booking
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking_details`
--

DROP TABLE IF EXISTS `booking_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_details`
--

LOCK TABLES `booking_details` WRITE;
/*!40000 ALTER TABLE `booking_details` DISABLE KEYS */;
INSERT INTO `booking_details` VALUES (1,1,1,19,75000.00),(2,1,1,20,75000.00),(3,2,1,29,75000.00),(4,2,1,30,75000.00),(5,3,1,31,75000.00),(6,3,1,32,75000.00),(7,4,2,77,95000.00),(8,4,2,78,95000.00),(9,5,3,125,90000.00),(10,5,3,126,90000.00),(11,6,2,68,95000.00),(12,6,2,69,95000.00),(13,7,2,83,95000.00),(14,7,2,84,95000.00),(19,12,1,27,75000.00),(20,12,1,28,75000.00),(21,13,2,79,95000.00),(22,13,2,80,95000.00),(23,14,1,21,75000.00),(24,14,1,22,75000.00),(26,16,6,269,85000.00),(27,16,6,270,85000.00),(28,17,6,263,85000.00),(29,17,6,281,85000.00),(30,17,6,287,85000.00),(31,18,1,11,75000.00),(32,18,1,12,75000.00),(33,18,1,13,75000.00),(34,19,2,73,95000.00),(35,19,2,74,95000.00),(36,20,6,272,85000.00),(37,20,6,271,85000.00),(38,21,8,363,80000.00),(39,21,8,364,80000.00),(40,21,8,365,80000.00),(44,23,3,101,90000.00),(45,23,3,102,90000.00),(46,24,3,117,90000.00),(47,24,3,118,90000.00),(48,25,1,16,75000.00),(49,25,1,23,75000.00),(50,25,1,24,75000.00),(51,26,10,454,90000.00),(52,26,10,461,90000.00),(53,26,10,462,90000.00),(54,27,9,412,85000.00),(55,27,9,413,85000.00),(56,27,9,414,85000.00),(57,28,8,359,80000.00),(58,28,8,360,80000.00),(59,29,25,508,75000.00),(60,29,25,509,75000.00),(61,29,25,510,75000.00),(66,34,3,119,90000.00),(67,34,3,120,90000.00),(68,35,10,463,90000.00),(69,36,10,464,90000.00),(70,37,2,91,95000.00),(71,37,2,92,95000.00),(72,37,2,93,95000.00),(73,38,1,7,75000.00),(74,38,1,8,75000.00),(81,43,3,115,90000.00),(82,43,3,116,90000.00),(83,44,6,261,85000.00),(84,44,6,262,85000.00),(85,45,26,19,70000.00),(86,45,26,20,70000.00),(87,46,37,67,60000.00),(88,46,37,68,60000.00),(89,47,37,80,60000.00),(90,47,37,71,60000.00),(91,47,37,72,60000.00),(92,48,37,86,60000.00),(93,48,37,87,60000.00),(94,48,37,88,60000.00),(95,49,39,23,60000.00),(96,49,39,24,60000.00),(97,50,39,29,60000.00),(98,51,39,48,60000.00),(99,51,39,47,60000.00),(104,55,38,36,50000.00),(105,55,38,38,50000.00),(106,56,39,22,60000.00),(110,60,39,30,60000.00),(113,63,39,32,60000.00),(117,67,39,28,60000.00),(118,67,39,29,60000.00),(119,68,39,36,60000.00),(120,68,39,37,60000.00),(121,68,39,38,60000.00),(122,69,39,27,60000.00),(123,69,39,28,60000.00),(124,70,39,21,60000.00),(125,70,39,29,60000.00),(126,71,39,23,60000.00),(127,71,39,24,60000.00),(128,72,39,20,60000.00),(129,72,39,21,60000.00),(130,73,1,9,75000.00),(131,73,1,10,75000.00),(132,74,1,43,75000.00),(133,74,1,44,75000.00),(134,74,1,45,75000.00),(135,75,1,17,75000.00),(136,75,1,18,75000.00),(137,75,1,25,75000.00),(138,76,1,36,75000.00),(139,76,1,37,75000.00);
/*!40000 ALTER TABLE `booking_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,1,1,150000.00,'CANCELLED','2026-04-12 08:58:11',NULL,0.00,NULL),(2,1,1,150000.00,'CANCELLED','2026-04-12 09:00:26',NULL,0.00,NULL),(3,1,1,150000.00,'PAID','2026-04-12 09:00:40',NULL,0.00,NULL),(4,1,2,190000.00,'PAID','2026-04-12 16:19:27',NULL,0.00,NULL),(5,3,3,180000.00,'CANCELLED','2026-04-13 05:03:29',NULL,0.00,NULL),(6,3,2,190000.00,'CANCELLED','2026-04-13 05:04:06',NULL,0.00,NULL),(7,3,2,190000.00,'CANCELLED','2026-04-13 05:08:38',NULL,0.00,NULL),(12,3,1,150000.00,'PAID','2026-04-13 05:33:06',NULL,0.00,NULL),(13,3,2,190000.00,'PAID','2026-04-13 05:33:42',NULL,0.00,NULL),(14,2,1,150000.00,'PAID','2026-04-13 14:20:10',NULL,0.00,NULL),(16,1,6,170000.00,'PAID','2026-04-13 14:53:13',NULL,0.00,NULL),(17,1,6,255000.00,'PAID','2026-04-13 14:54:16',NULL,0.00,NULL),(18,4,1,225000.00,'PAID','2026-04-13 15:06:42',NULL,0.00,NULL),(19,4,2,190000.00,'CANCELLED','2026-04-13 15:07:24',NULL,0.00,NULL),(20,1,6,170000.00,'PAID','2026-04-13 16:30:43',NULL,0.00,NULL),(21,1,8,240000.00,'PAID','2026-04-13 16:31:03',NULL,0.00,NULL),(23,7,3,180000.00,'PAID','2026-04-14 02:09:15',NULL,0.00,NULL),(24,7,3,180000.00,'CANCELLED','2026-04-14 02:10:04',NULL,0.00,NULL),(25,7,1,225000.00,'PAID','2026-04-14 02:42:51',NULL,0.00,NULL),(26,1,10,270000.00,'PAID','2026-04-14 02:57:34',NULL,0.00,NULL),(27,1,9,205000.00,'PAID','2026-04-14 03:07:37',2,50000.00,NULL),(28,1,8,145000.00,'PAID','2026-04-14 03:40:32',3,15000.00,NULL),(29,1,25,215000.00,'PAID','2026-04-14 03:56:00',4,10000.00,NULL),(34,3,3,180000.00,'CANCELLED','2026-04-14 09:07:08',NULL,0.00,NULL),(35,1,10,90000.00,'CANCELLED','2026-04-14 09:08:34',NULL,0.00,NULL),(36,1,10,90000.00,'CANCELLED','2026-04-14 09:08:40',NULL,0.00,NULL),(37,10,2,275000.00,'PAID','2026-04-14 17:18:45',18,10000.00,NULL),(38,10,1,135000.00,'PAID','2026-04-14 17:19:11',21,15000.00,NULL),(43,10,3,180000.00,'CANCELLED','2026-04-14 17:19:47',NULL,0.00,NULL),(44,10,6,153000.00,'PAID','2026-04-14 17:20:14',21,17000.00,NULL),(45,11,26,140000.00,'CANCELLED','2026-04-15 08:18:32',NULL,0.00,NULL),(46,10,37,120000.00,'PAID','2026-04-18 10:55:48',NULL,0.00,NULL),(47,10,37,180000.00,'CANCELLED','2026-04-18 13:27:03',NULL,0.00,NULL),(48,10,37,180000.00,'CANCELLED','2026-04-18 13:29:10',NULL,0.00,NULL),(49,10,39,120000.00,'CANCELLED','2026-04-23 23:50:46',NULL,0.00,NULL),(50,10,39,60000.00,'CANCELLED','2026-04-24 00:21:58',NULL,0.00,NULL),(51,10,39,120000.00,'CANCELLED','2026-04-24 00:24:08',NULL,0.00,NULL),(55,NULL,38,100000.00,'PAID','2026-04-24 01:17:22',NULL,0.00,'ductrung@gmail.com'),(56,10,39,60000.00,'CANCELLED','2026-04-24 01:40:24',NULL,0.00,NULL),(60,NULL,39,60000.00,'CANCELLED','2026-04-24 01:48:15',NULL,0.00,NULL),(63,NULL,39,60000.00,'PAID','2026-04-24 01:48:57',NULL,0.00,'khachvanglai@gmail.com'),(67,6,39,120000.00,'CANCELLED','2026-04-24 01:55:22',NULL,0.00,NULL),(68,6,39,180000.00,'CANCELLED','2026-04-24 01:55:31',NULL,0.00,NULL),(69,NULL,39,120000.00,'CANCELLED','2026-04-24 01:58:44',NULL,0.00,NULL),(70,NULL,39,120000.00,'CANCELLED','2026-04-24 02:00:53',NULL,0.00,NULL),(71,NULL,39,120000.00,'PAID','2026-04-24 02:02:33',NULL,0.00,'abc@gmail.com'),(72,NULL,39,120000.00,'PAID','2026-04-24 02:07:41',NULL,0.00,'dungabc@gmail.com'),(73,10,1,135000.00,'AWAITING_CONFIRMATION','2026-05-15 04:01:45',21,15000.00,NULL),(74,NULL,1,225000.00,'AWAITING_CONFIRMATION','2026-05-15 11:04:25',NULL,0.00,'vanglai123@gmail.com'),(75,10,1,225000.00,'CANCELLED','2026-05-15 11:07:26',NULL,0.00,NULL),(76,10,1,150000.00,'CANCELLED','2026-05-15 11:13:16',NULL,0.00,NULL);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cinemas`
--

DROP TABLE IF EXISTS `cinemas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cinemas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinemas`
--

LOCK TABLES `cinemas` WRITE;
/*!40000 ALTER TABLE `cinemas` DISABLE KEYS */;
INSERT INTO `cinemas` VALUES (1,'Royal Cinema','Hồ Hoàn kiếm');
/*!40000 ALTER TABLE `cinemas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `duration` int NOT NULL,
  `release_date` date DEFAULT NULL,
  `poster_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trailer_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('COMING_SOON','NOW_SHOWING','ENDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'COMING_SOON',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movies`
--

LOCK TABLES `movies` WRITE;
/*!40000 ALTER TABLE `movies` DISABLE KEYS */;
INSERT INTO `movies` VALUES (1,'Nhà Tù Shawshank','Nhà tù Shawshank kể về Andrew, một nhân viên nhà băng, bị kết án chung thân sau khi giết vợ và nhân tình của cô. Anh một mực cho rằng mình bị oan. Andy bị đưa tới nhà tù Shawshank. Tại đây, thế giới ngầm của các phạm nhân, sự hà khắc của hệ thống quản giáo xung đột và giành nhau quyền thống trị. Chỉ có các phạm nhân trung lập là bị kẹt ở giữa và có thể bỏ mạng. Làm quen với tay ‘quản lý chợ đen’ Redding, Andy dần thích nghi với cuộc sống tại Shawshank. Song, kế hoạch lớn hơn việc tồn tại ở nhà tù này đang được anh suy tính. Qua con mắt và lời kể của Redding, cuộc vượt ngục vĩ đại này được kể tuần tự cùng một kết thúc bất ngờ',142,'2026-03-22','https://image.tmdb.org/t/p/w1280/zLyG4nquaaZKCA3CJdQCEzTwN1R.jpg','https://www.youtube.com/watch?v=6hB3S9bIaco','NOW_SHOWING'),(2,'Bố Già','Một câu chuyện kéo dài từ năm 1945 đến năm 1955, một biên niên sử về gia đình tội phạm Corleone người Mỹ gốc Ý. Khi tộc trưởng gia đình tội phạm có tổ chức, Vito Corleone bị ám sát bởi băng nhóm đối thủ, con trai út của ông, Michael đã phải nhúng tay vào tội ác và chống lại đối thủ với việc phát động một chiến dịch trả thù đẫm máu.',175,'2026-03-14','https://image.tmdb.org/t/p/w1280/84MHN3JvOV4ORHgELrQM6SBlhdB.jpg','https://www.youtube.com/watch?v=sY1S34973zA','NOW_SHOWING'),(3,'Kỵ Sĩ Bóng Đêm','Người Dơi bước vào giai đoạn cam go nhất trong cuộc chiến chống lại cái ác khi tên tội phạm bậc thầy The Joker xuất hiện. Các tay trùm thuê The Joker giết Người Dơi để trả thù cho chỗ tài sản phi pháp bị anh lật tẩy. Tiếp tay cho The Joker là toàn bộ tội phạm ở thành phố Gotham, những kẻ đang bị bộ ba Người Dơi - Trung úy Gordon - Luật sư Harvey Dent thu hẹp đất sống. Hàng loạt vụ tấn công xảy ra khiến Người Dơi lúng túng. Các quan chức bị sát hại, người dân không dám ra đường buổi tối vì sợ bị giết, mọi lối ra vào thành phố Gotham bị phong tỏa. Tất cả đều do một tay The Joker sắp đặt.',152,'2026-02-16','https://image.tmdb.org/t/p/w1280/7EfSqviKvXwbiGhUjHyUBGVdoiW.jpg','https://www.youtube.com/watch?v=EXeTwQWrcwY','NOW_SHOWING'),(4,'Bản Danh Sách Của Schindler','Bản danh sách của Schindler (Schindler`s List) là một bộ phim truyện sản xuất năm 1993 của Hoa Kỳ về Oskar Schindler, một nhà kinh doanh người Đức. Phim bắt đầu vào năm 1939 với sự tập trung người Ba Lan gốc Do Thái của chính quyền Đức Quốc Xã sau khi xâm lược Ba Lan, từ việc bao vây, giam lỏng trong vùng tới xây dựng những khu tập trung Kraków Ghetto không lâu sau khi Đệ nhị thế chiến bắt đầu. Trong lúc đó, Oskar Schindler (Liam Neeson), một doanh nhân thất bại, đến thành phố từ Sudetenland với những hy vọng làm giàu.',195,'2025-12-15','http://image.tmdb.org/t/p/w1280/xx4JCtIkUj31PJbPFRLhuBc1PRl.jpg','https://www.youtube.com/watch?v=gG22XNhtnoY','ENDED'),(5,'12 Người Đàn Ông Giận Dữ','Một thanh niên bị tình nghi giết cha ruột của mình. 12 người của bồi thẩm đoàn bắt đầu phiên làm việc của mình và tất cả hội thẩm viên đều muốn kết thúc nhanh chóng vụ án vì các chứng cứ đã quá rõ ràng. Trừ một người duy nhất. Ông không muốn sinh mạng của một con người lại có thể được quyết định chỉ trong vòng chưa đầy 10 phút. Ông có một sự nghi ngờ riêng đối với vụ án kỳ lạ này. Và ông quyết định: tìm cách thuyết phục mọi người. Nhưng ông sẽ làm gì để giúp cậu bé kia và thuyết phục những người trong bồi thẩm đoàn đây?',96,'2026-01-10','https://image.tmdb.org/t/p/w1280/aa4s7J0ld2UHUooc1H8o1sNuZ2m.jpg','https://www.youtube.com/watch?v=2L4Igb32_9U','ENDED'),(6,'Trò Chơi Của Quỷ 2','Chỉ ít phút sau khi sống sót khỏi cuộc tấn công toàn diện của gia tộc Le Domas, Grace nhận ra mình đã bước sang cấp độ tiếp theo của trò chơi ác mộng — lần này, với người chị em xa cách Faith đứng bên cạnh. Grace chỉ có một cơ hội để sống sót, bảo vệ em gái, và giành lấy Ngai Cao của Hội Đồng — thế lực đang kiểm soát cả thế giới. Bốn gia tộc đối địch đang truy lùng cô để đoạt lấy ngai vàng, và kẻ chiến thắng sẽ thống trị tất cả.',108,'2026-03-10','https://image.tmdb.org/t/p/w1280/7BwIVOiFHPK3Oaj4VA2i5k7znDj.jpg','https://www.youtube.com/watch?v=jczr0KCloXk&t=1s','NOW_SHOWING'),(7,'Kẻ Đánh Cắp Giấc Mơ','Cobb đánh cắp thông tin từ các mục tiêu của mình bằng cách đi vào giấc mơ của họ. Saito đề nghị xóa sạch tiền án của Cobb như một khoản thanh toán cho việc thực hiện hành vi đầu tiên đối với con trai của đối thủ cạnh tranh ốm yếu của mình.',148,'2026-03-15','https://image.tmdb.org/t/p/w1280/eBtqGWtR5KUiNl6OXHLR3ri6nVm.jpg','https://www.youtube.com/watch?v=YoHD9XEInc0','NOW_SHOWING'),(8,'Sàn Đấu Sinh Tử','Cuộc gặp gỡ định mệnh của một nhân viên giám định bảo hiểm và một gã lông bông bán xà phòng trên chuyến bay đã mở ra một cuộc phiêu lưu kỳ lạ. Với các \"câu lạc bộ chiến đấu\" ngầm hình thành ở mọi thị trấn, cuốn theo nhiều diễn biến phức tạp và một cái kết đầy kịch tính.',139,'2026-02-15','https://image.tmdb.org/t/p/w1280/wBxkCbNI8eDRRfUEl8w0G2rfLyu.jpg','https://www.youtube.com/watch?v=qtRKdVHc-cE','NOW_SHOWING'),(9,'Forrest Gump','Forrest Gump là một đứa trẻ bất hạnh khi sinh ra đã không có cha, hơn nữa Forrest còn bị thiểu năng. Forrest luôn bị bạn bè cùng trang lứa trêu trọc, bắt nạt. Người bạn duy nhất của Forrest là Jenny, chính Jenny đã phát hiện ra những khả năng đặc biệt của anh. Tốt nghiệp đại học Forrest nhập ngũ và tham chiến ở Việt Nam, Bubba trở thành bạn thân thứ 2 của anh. Forrest rời chiến trường với vết thương và khả năng chơi bóng bàn xuất sắc. Những biến cố nối tiếp nhau xuất hiện làm thay đổi hoàn toàn cuộc đời Forrest.',142,'2026-02-23','https://image.tmdb.org/t/p/w1280/yvEDqdIQnYUahG6oY9bKHMubqp8.jpg','https://www.youtube.com/watch?v=bLvqoHBptjg','NOW_SHOWING'),(10,'Ma Trận','The Matrix (MaTrận) là bộ phim khoa học giả tưởng về tương lai. Trong tương lai đó, Thomas, biệt danh Neo, là một hacker luôn có cảm giác khác thường về thế giới thực. Cho tới khi người đàn ông tự xưng là Morpheus tìm đến anh. Người đàn ông này nói cho anh biết, thế giới mà mọi người coi là thực chỉ là một chương trình giả lập để máy móc cai trị con người. Chỉ có một người có thể phá được Ma trận. Những người thật sống sót còn lại cuối cùng và những nhân viên Ma trận đều cùng đi tìm người đó. Và người đó chính là anh – Neo…',136,'2026-03-30','https://image.tmdb.org/t/p/w1280/fE7S6EwaBgRQeqKoDVFoImMmAF4.jpg','https://www.youtube.com/watch?v=m8e-FF8MsqU','NOW_SHOWING'),(11,'Chiến Hữu','Câu chuyện có thật về Henry Hill, một cậu bé Brooklyn mang nửa dòng máu Ailen, nửa Sicily, được các băng nhóm xã hội đen hàng xóm nhận nuôi khi còn nhỏ và leo lên hàng ngũ của một gia đình Mafia dưới sự hướng dẫn của Jimmy Conway.',145,'2024-09-12','https://image.tmdb.org/t/p/w1280/56yHDzoWZUFLUD2ztsVzSNcHo6f.jpg','https://www.youtube.com/watch?v=2ilzidi_J8Q','ENDED'),(14,'Ký Sinh Trùng','Bộ phim xoay quanh hai gia đình hoàn toàn trái ngược: một bên vô cùng giàu có, còn một bên luôn sống trong cảnh nghèo túng. Họ tình cờ gặp gỡ và quen biết nhau sau một biến cố không ngờ.',132,'2019-05-30','https://image.tmdb.org/t/p/w1280/zZydO1LhMhqDAMM86JUi241wT7X.jpg','https://www.youtube.com/watch?v=5xH0HfJHsaY','ENDED'),(15,'Sự Im Lặng Của Bầy Cừu','Một cô gái trẻ mất tích và vụ án này có liên quan đến một kẻ giết người hàng loạt, để thỏa mãn cho những ý nghĩ bệnh hoạn của gã. Người duy nhất có thể làm vụ án sáng tỏ là tên tù nhân tâm thần, chuyên ăn thịt người Hannibal Lecter ( Anthony Hopkins ). Cô nhân viên trẻ Clarice được giao nhiệm vụ khai thác thông tin ở Hannibal. Từ đó, cô dần khám phá ra bí mật của những tiếng kêu kì lạ từ đàn cừu mà mình hằng ám ảnh…Một bộ phim đầy tính nhân bản được thể hiện qua những đoạn đốI thoại của Clarice và Hannibal và ở cái kết khiến người xem phải suy nghĩ rất nhiều…Bộ phim đã đoạt cùng lúc 5 giải Oscar quan trọng: giải phim hay nhất, đạo diễn, biên kịch, nam nữ diễn viên chính xuất sắc nhất. Đây là một thành tích ...',118,'1991-02-14','https://image.tmdb.org/t/p/w1280/7h6frYSP6wE3knBG9bpnYFLDA5I.jpg','https://www.youtube.com/watch?v=W6Mm8SbeRIw','ENDED'),(17,'Dặm Xanh','Bộ phim là câu chuyện hồi tưởng của một viên coi ngục cai quản những tên tử tù bất trị đang chờ ngày ngồi lên ghế điện trả giá cho những tội ác mà chúng gây ra. Cuộc sống của ông thay đổi hoàn toàn kể từ khi một người tù da đen có khả năng kì lạ xuất hiện trong ngục của ông...',189,'2026-12-10','https://image.tmdb.org/t/p/w1280/pTEuy2oti9ITTzzrTRZNeSAXzfC.jpg','https://image.tmdb.org/t/p/w500/velWPhS0mS3uRD97ZfsZ06m9v1o.jpg','COMING_SOON'),(18,'Hành Tinh Cát – Phần Hai','Hãy theo chân hành trình của Paul Atreides khi anh ấy cùng với Chani và những người Fremen trên con đường trả thù những kẻ đã âm mưu phá hủy gia đình của anh. Đối diện với sự lựa chọn giữa tình yêu của đời mình và số phận của vũ trụ rộng lớn, Paul phải cố ngăn chặn một tương lai kinh khủng chỉ có anh mới nhìn thấy được.',-166,'2026-08-01','https://image.tmdb.org/t/p/w1280/8QdnKQyZDlN6rBSrfU1V5PctfUu.jpg','https://www.youtube.com/watch?v=Way9Dexny3w','COMING_SOON'),(19,'Người Nhện: Du Hành Vũ Trụ Nhện','Miles Morales tái xuất trong phần tiếp theo của bom tấn hoạt hình từng đoạt giải Oscar - Spider-Man: Across the Spider-Verse. Sau khi gặp lại Gwen Stacy, chàng Spider-Man thân thiện đến từ Brooklyn phải du hành qua đa vũ trụ và gặp một nhóm Người Nhện chịu trách nhiệm bảo vệ các thế giới song song. Nhưng khi nhóm siêu anh hùng xung đột về cách xử lý một mối đe dọa mới, Miles buộc phải đọ sức với các Người Nhện khác và phải xác định lại ý nghĩa của việc trở thành một người hùng để có thể cứu những người cậu yêu thương nhất.',140,'2026-06-02','https://image.tmdb.org/t/p/w1280/paM6UdMgXuXyAK0jhGfV07o3lRW.jpg','https://www.youtube.com/watch?v=shW9i6k8cB0','COMING_SOON'),(20,'Avatar: Dòng chảy của nước','Câu chuyện của “Avatar: Dòng Chảy Của Nước” lấy bối cảnh 10 năm sau những sự kiện xảy ra ở phần đầu tiên. Phim kể câu chuyện về gia đình mới của Jake Sully (Sam Worthington thủ vai) cùng những rắc rối theo sau và bi kịch họ phải chịu đựng khi phe loài người xâm lược hành tinh Pandora.',192,'2026-11-20','https://image.tmdb.org/t/p/w1280/luCqqHf10eQuGAYFO3U7JEqT4XC.jpg','https://www.youtube.com/watch?v=d9MyW72ELq0','COMING_SOON'),(21,'adcb',NULL,156,'2026-04-14',NULL,NULL,'COMING_SOON'),(22,'abc',NULL,120,'2026-04-18',NULL,NULL,'NOW_SHOWING'),(23,'a',NULL,0,NULL,NULL,NULL,'COMING_SOON');
/*!40000 ALTER TABLE `movies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(38,2) NOT NULL,
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('SUCCESS','FAILED','PENDING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `booking_id` (`booking_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,3,150000.00,'MOMO','SUCCESS','2026-04-12 23:00:45'),(2,4,190000.00,'MOMO','SUCCESS','2026-04-12 23:19:32'),(3,12,150000.00,'MOMO','SUCCESS','2026-04-13 12:33:16'),(4,13,190000.00,'MOMO','SUCCESS','2026-04-13 12:33:50'),(5,14,150000.00,'MOMO','SUCCESS','2026-04-13 21:20:46'),(6,16,170000.00,'MOMO','SUCCESS','2026-04-13 21:53:17'),(7,17,255000.00,'MOMO','SUCCESS','2026-04-13 21:54:34'),(8,18,225000.00,'MOMO','SUCCESS','2026-04-13 22:07:03'),(9,20,170000.00,'MOMO','SUCCESS','2026-04-13 23:30:48'),(10,21,240000.00,'MOMO','SUCCESS','2026-04-13 23:32:46'),(11,23,180000.00,'MOMO','SUCCESS','2026-04-14 09:10:58'),(12,25,225000.00,'MOMO','SUCCESS','2026-04-14 09:43:06'),(13,26,270000.00,'MOMO','SUCCESS','2026-04-14 09:57:43'),(14,27,205000.00,'MOMO','SUCCESS','2026-04-14 10:07:48'),(15,28,145000.00,'MOMO','SUCCESS','2026-04-14 10:40:35'),(16,29,215000.00,'MOMO','SUCCESS','2026-04-14 10:56:05'),(17,37,275000.00,'MOMO','SUCCESS','2026-04-15 00:18:57'),(18,38,135000.00,'MOMO','SUCCESS','2026-04-15 00:19:16'),(19,44,153000.00,'MOMO','SUCCESS','2026-04-15 00:20:16'),(20,46,120000.00,'MOMO','SUCCESS','2026-04-18 17:56:05'),(21,55,100000.00,'MOMO','SUCCESS','2026-04-24 08:17:47'),(22,63,60000.00,'MOMO','SUCCESS','2026-04-24 08:49:32'),(23,71,120000.00,'MOMO','SUCCESS','2026-04-24 09:02:42'),(24,72,120000.00,'MOMO','SUCCESS','2026-04-24 09:07:53'),(25,73,135000.00,'MOMO','SUCCESS','2026-05-15 11:02:26'),(26,74,225000.00,'MOMO','SUCCESS','2026-05-15 18:04:45');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (2,'ADMIN'),(1,'CUSTOMER');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cinema_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cinema_id` (`cinema_id`,`name`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`cinema_id`) REFERENCES `cinemas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'Phòng 01',1),(2,'Phòng 02',1),(3,'Phòng 03',1),(4,'Phòng 04',1),(5,'Phòng 05',1),(6,'Phòng 06',1),(7,'Phòng 07',1),(8,'Phòng 08',1),(9,'Phòng 09',1),(10,'Phòng 10',1),(11,'Phòng 11',1);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats`
--

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_id` (`room_id`,`seat_number`),
  CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=529 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seats`
--

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` VALUES (1,'A1',1),(2,'A2',1),(3,'A3',1),(4,'A4',1),(5,'A5',1),(6,'A6',1),(7,'A7',1),(8,'A8',1),(9,'B1',1),(10,'B2',1),(11,'B3',1),(12,'B4',1),(13,'B5',1),(14,'B6',1),(15,'B7',1),(16,'B8',1),(17,'C1',1),(18,'C2',1),(19,'C3',1),(20,'C4',1),(21,'C5',1),(22,'C6',1),(23,'C7',1),(24,'C8',1),(25,'D1',1),(26,'D2',1),(27,'D3',1),(28,'D4',1),(29,'D5',1),(30,'D6',1),(31,'D7',1),(32,'D8',1),(33,'E1',1),(34,'E2',1),(35,'E3',1),(36,'E4',1),(37,'E5',1),(38,'E6',1),(39,'E7',1),(40,'E8',1),(41,'F1',1),(42,'F2',1),(43,'F3',1),(44,'F4',1),(45,'F5',1),(46,'F6',1),(47,'F7',1),(48,'F8',1),(49,'A1',2),(50,'A2',2),(51,'A3',2),(52,'A4',2),(53,'A5',2),(54,'A6',2),(55,'A7',2),(56,'A8',2),(57,'B1',2),(58,'B2',2),(59,'B3',2),(60,'B4',2),(61,'B5',2),(62,'B6',2),(63,'B7',2),(64,'B8',2),(65,'C1',2),(66,'C2',2),(67,'C3',2),(68,'C4',2),(69,'C5',2),(70,'C6',2),(71,'C7',2),(72,'C8',2),(73,'D1',2),(74,'D2',2),(75,'D3',2),(76,'D4',2),(77,'D5',2),(78,'D6',2),(79,'D7',2),(80,'D8',2),(81,'E1',2),(82,'E2',2),(83,'E3',2),(84,'E4',2),(85,'E5',2),(86,'E6',2),(87,'E7',2),(88,'E8',2),(89,'F1',2),(90,'F2',2),(91,'F3',2),(92,'F4',2),(93,'F5',2),(94,'F6',2),(95,'F7',2),(96,'F8',2),(97,'A1',3),(98,'A2',3),(99,'A3',3),(100,'A4',3),(101,'A5',3),(102,'A6',3),(103,'A7',3),(104,'A8',3),(105,'B1',3),(106,'B2',3),(107,'B3',3),(108,'B4',3),(109,'B5',3),(110,'B6',3),(111,'B7',3),(112,'B8',3),(113,'C1',3),(114,'C2',3),(115,'C3',3),(116,'C4',3),(117,'C5',3),(118,'C6',3),(119,'C7',3),(120,'C8',3),(121,'D1',3),(122,'D2',3),(123,'D3',3),(124,'D4',3),(125,'D5',3),(126,'D6',3),(127,'D7',3),(128,'D8',3),(129,'E1',3),(130,'E2',3),(131,'E3',3),(132,'E4',3),(133,'E5',3),(134,'E6',3),(135,'E7',3),(136,'E8',3),(137,'F1',3),(138,'F2',3),(139,'F3',3),(140,'F4',3),(141,'F5',3),(142,'F6',3),(143,'F7',3),(144,'F8',3),(145,'A1',4),(146,'A2',4),(147,'A3',4),(148,'A4',4),(149,'A5',4),(150,'A6',4),(151,'A7',4),(152,'A8',4),(153,'B1',4),(154,'B2',4),(155,'B3',4),(156,'B4',4),(157,'B5',4),(158,'B6',4),(159,'B7',4),(160,'B8',4),(161,'C1',4),(162,'C2',4),(163,'C3',4),(164,'C4',4),(165,'C5',4),(166,'C6',4),(167,'C7',4),(168,'C8',4),(169,'D1',4),(170,'D2',4),(171,'D3',4),(172,'D4',4),(173,'D5',4),(174,'D6',4),(175,'D7',4),(176,'D8',4),(177,'E1',4),(178,'E2',4),(179,'E3',4),(180,'E4',4),(181,'E5',4),(182,'E6',4),(183,'E7',4),(184,'E8',4),(185,'F1',4),(186,'F2',4),(187,'F3',4),(188,'F4',4),(189,'F5',4),(190,'F6',4),(191,'F7',4),(192,'F8',4),(193,'A1',5),(194,'A2',5),(195,'A3',5),(196,'A4',5),(197,'A5',5),(198,'A6',5),(199,'A7',5),(200,'A8',5),(201,'B1',5),(202,'B2',5),(203,'B3',5),(204,'B4',5),(205,'B5',5),(206,'B6',5),(207,'B7',5),(208,'B8',5),(209,'C1',5),(210,'C2',5),(211,'C3',5),(212,'C4',5),(213,'C5',5),(214,'C6',5),(215,'C7',5),(216,'C8',5),(217,'D1',5),(218,'D2',5),(219,'D3',5),(220,'D4',5),(221,'D5',5),(222,'D6',5),(223,'D7',5),(224,'D8',5),(225,'E1',5),(226,'E2',5),(227,'E3',5),(228,'E4',5),(229,'E5',5),(230,'E6',5),(231,'E7',5),(232,'E8',5),(233,'F1',5),(234,'F2',5),(235,'F3',5),(236,'F4',5),(237,'F5',5),(238,'F6',5),(239,'F7',5),(240,'F8',5),(241,'A1',6),(242,'A2',6),(243,'A3',6),(244,'A4',6),(245,'A5',6),(246,'A6',6),(247,'A7',6),(248,'A8',6),(249,'B1',6),(250,'B2',6),(251,'B3',6),(252,'B4',6),(253,'B5',6),(254,'B6',6),(255,'B7',6),(256,'B8',6),(257,'C1',6),(258,'C2',6),(259,'C3',6),(260,'C4',6),(261,'C5',6),(262,'C6',6),(263,'C7',6),(264,'C8',6),(265,'D1',6),(266,'D2',6),(267,'D3',6),(268,'D4',6),(269,'D5',6),(270,'D6',6),(271,'D7',6),(272,'D8',6),(273,'E1',6),(274,'E2',6),(275,'E3',6),(276,'E4',6),(277,'E5',6),(278,'E6',6),(279,'E7',6),(280,'E8',6),(281,'F1',6),(282,'F2',6),(283,'F3',6),(284,'F4',6),(285,'F5',6),(286,'F6',6),(287,'F7',6),(288,'F8',6),(289,'A1',7),(290,'A2',7),(291,'A3',7),(292,'A4',7),(293,'A5',7),(294,'A6',7),(295,'A7',7),(296,'A8',7),(297,'B1',7),(298,'B2',7),(299,'B3',7),(300,'B4',7),(301,'B5',7),(302,'B6',7),(303,'B7',7),(304,'B8',7),(305,'C1',7),(306,'C2',7),(307,'C3',7),(308,'C4',7),(309,'C5',7),(310,'C6',7),(311,'C7',7),(312,'C8',7),(313,'D1',7),(314,'D2',7),(315,'D3',7),(316,'D4',7),(317,'D5',7),(318,'D6',7),(319,'D7',7),(320,'D8',7),(321,'E1',7),(322,'E2',7),(323,'E3',7),(324,'E4',7),(325,'E5',7),(326,'E6',7),(327,'E7',7),(328,'E8',7),(329,'F1',7),(330,'F2',7),(331,'F3',7),(332,'F4',7),(333,'F5',7),(334,'F6',7),(335,'F7',7),(336,'F8',7),(337,'A1',8),(338,'A2',8),(339,'A3',8),(340,'A4',8),(341,'A5',8),(342,'A6',8),(343,'A7',8),(344,'A8',8),(345,'B1',8),(346,'B2',8),(347,'B3',8),(348,'B4',8),(349,'B5',8),(350,'B6',8),(351,'B7',8),(352,'B8',8),(353,'C1',8),(354,'C2',8),(355,'C3',8),(356,'C4',8),(357,'C5',8),(358,'C6',8),(359,'C7',8),(360,'C8',8),(361,'D1',8),(362,'D2',8),(363,'D3',8),(364,'D4',8),(365,'D5',8),(366,'D6',8),(367,'D7',8),(368,'D8',8),(369,'E1',8),(370,'E2',8),(371,'E3',8),(372,'E4',8),(373,'E5',8),(374,'E6',8),(375,'E7',8),(376,'E8',8),(377,'F1',8),(378,'F2',8),(379,'F3',8),(380,'F4',8),(381,'F5',8),(382,'F6',8),(383,'F7',8),(384,'F8',8),(385,'A1',9),(386,'A2',9),(387,'A3',9),(388,'A4',9),(389,'A5',9),(390,'A6',9),(391,'A7',9),(392,'A8',9),(393,'B1',9),(394,'B2',9),(395,'B3',9),(396,'B4',9),(397,'B5',9),(398,'B6',9),(399,'B7',9),(400,'B8',9),(401,'C1',9),(402,'C2',9),(403,'C3',9),(404,'C4',9),(405,'C5',9),(406,'C6',9),(407,'C7',9),(408,'C8',9),(409,'D1',9),(410,'D2',9),(411,'D3',9),(412,'D4',9),(413,'D5',9),(414,'D6',9),(415,'D7',9),(416,'D8',9),(417,'E1',9),(418,'E2',9),(419,'E3',9),(420,'E4',9),(421,'E5',9),(422,'E6',9),(423,'E7',9),(424,'E8',9),(425,'F1',9),(426,'F2',9),(427,'F3',9),(428,'F4',9),(429,'F5',9),(430,'F6',9),(431,'F7',9),(432,'F8',9),(433,'A1',10),(434,'A2',10),(435,'A3',10),(436,'A4',10),(437,'A5',10),(438,'A6',10),(439,'A7',10),(440,'A8',10),(441,'B1',10),(442,'B2',10),(443,'B3',10),(444,'B4',10),(445,'B5',10),(446,'B6',10),(447,'B7',10),(448,'B8',10),(449,'C1',10),(450,'C2',10),(451,'C3',10),(452,'C4',10),(453,'C5',10),(454,'C6',10),(455,'C7',10),(456,'C8',10),(457,'D1',10),(458,'D2',10),(459,'D3',10),(460,'D4',10),(461,'D5',10),(462,'D6',10),(463,'D7',10),(464,'D8',10),(465,'E1',10),(466,'E2',10),(467,'E3',10),(468,'E4',10),(469,'E5',10),(470,'E6',10),(471,'E7',10),(472,'E8',10),(473,'F1',10),(474,'F2',10),(475,'F3',10),(476,'F4',10),(477,'F5',10),(478,'F6',10),(479,'F7',10),(480,'F8',10),(481,'A1',11),(482,'A2',11),(483,'A3',11),(484,'A4',11),(485,'A5',11),(486,'A6',11),(487,'A7',11),(488,'A8',11),(489,'B1',11),(490,'B2',11),(491,'B3',11),(492,'B4',11),(493,'B5',11),(494,'B6',11),(495,'B7',11),(496,'B8',11),(497,'C1',11),(498,'C2',11),(499,'C3',11),(500,'C4',11),(501,'C5',11),(502,'C6',11),(503,'C7',11),(504,'C8',11),(505,'D1',11),(506,'D2',11),(507,'D3',11),(508,'D4',11),(509,'D5',11),(510,'D6',11),(511,'D7',11),(512,'D8',11),(513,'E1',11),(514,'E2',11),(515,'E3',11),(516,'E4',11),(517,'E5',11),(518,'E6',11),(519,'E7',11),(520,'E8',11),(521,'F1',11),(522,'F2',11),(523,'F3',11),(524,'F4',11),(525,'F5',11),(526,'F6',11),(527,'F7',11),(528,'F8',11);
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `showtimes`
--

DROP TABLE IF EXISTS `showtimes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `showtimes` (
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `showtimes`
--

LOCK TABLES `showtimes` WRITE;
/*!40000 ALTER TABLE `showtimes` DISABLE KEYS */;
INSERT INTO `showtimes` VALUES (1,1,1,'2026-05-17 08:30:00',75000.00,'2026-04-15 11:07:00.000000'),(2,2,2,'2026-04-15 09:00:00',95000.00,'2026-04-15 12:10:00.000000'),(3,3,3,'2026-04-15 13:30:00',90000.00,'2026-04-15 16:17:00.000000'),(4,4,4,'2026-04-15 15:00:00',80000.00,'2026-04-15 18:30:00.000000'),(5,5,5,'2026-04-15 19:00:00',70000.00,'2026-04-15 20:51:00.000000'),(6,6,6,'2026-04-16 08:00:00',85000.00,'2026-04-16 10:49:00.000000'),(7,7,7,'2026-04-16 10:30:00',95000.00,'2026-04-16 13:13:00.000000'),(8,8,8,'2026-04-16 14:00:00',80000.00,'2026-04-16 16:34:00.000000'),(9,9,9,'2026-04-16 16:30:00',85000.00,'2026-04-16 19:07:00.000000'),(10,10,10,'2026-04-16 20:00:00',90000.00,'2026-04-16 22:31:00.000000'),(21,2,1,'2026-04-15 20:00:00',20000.00,NULL),(24,1,11,'2026-04-16 11:00:00',50000.00,NULL),(25,2,11,'2026-04-18 13:00:00',75000.00,NULL),(26,1,1,'2026-04-16 10:00:00',70000.00,NULL),(27,1,2,'2026-04-16 10:30:00',80000.00,NULL),(28,1,3,'2026-04-17 19:00:00',60000.00,NULL),(29,2,11,'2026-04-15 19:10:00',50000.00,NULL),(30,2,10,'2026-04-15 15:00:00',60000.00,NULL),(31,2,9,'2026-04-17 14:10:00',45000.00,NULL),(32,2,5,'2026-04-17 17:00:00',90000.00,NULL),(33,2,8,'2026-04-17 19:00:00',60000.00,NULL),(34,1,7,'2026-04-16 14:00:00',60000.00,NULL),(36,1,1,'2026-04-19 20:00:00',50000.00,NULL),(37,1,2,'2026-04-19 17:00:00',60000.00,NULL),(38,1,1,'2026-04-25 10:47:00',50000.00,NULL),(39,1,1,'2026-04-25 06:47:00',60000.00,NULL),(40,1,1,'2026-05-17 16:30:00',50000.00,NULL),(41,3,4,'2026-05-18 10:49:00',30000.00,NULL),(42,1,2,'2026-05-17 16:30:00',40000.00,NULL),(43,2,5,'2026-05-18 09:50:00',60000.00,NULL),(44,1,1,'2026-05-19 14:50:00',50000.00,NULL),(45,1,5,'2026-05-18 19:10:00',60000.00,NULL);
/*!40000 ALTER TABLE `showtimes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'dunghv.1005@gmail.com','$2a$10$1oKEt/jwg1STSnr5Jsd.G.bKEOtt9D.K3Lv2G43OAgo8fnY6uNTIi','Hoàng Văn Dũng','0365387833',1,'2026-04-12 15:56:47','ACTIVE',NULL),(2,'admin@gmail.com','$2a$10$9sBQkf/aIlqgE3v2cWZij.JJa3JVe2AUS8xx1h2/0BRQRXLFfULhW','ADMIN','0123456789',2,'2026-04-12 15:58:42','ACTIVE',NULL),(3,'my@gmail.com','$2a$10$yDN0UB9Q0wsa.ulona9/8egi4WkU0BSXxeSG.yvyJ8z0eggLQjZUO','Trà My','0123456789',1,'2026-04-13 05:03:06','ACTIVE',NULL),(4,'tuan@gmail.com','$2a$10$cAaEKnyeTDJGtVxfizo86OQ0DgHyCgVCHcywCDBcOHd7wYkOVt4vG','Quốc Tuấn','0123456787',1,'2026-04-13 15:05:20','ACTIVE',NULL),(5,'dat1@gmail.com','$2a$10$jF7nsgrR6PGD6Z6.ZbvBce2LwbGU50Ri62bK6ePYKjEnE7s2Qu0jy','Bùi Đạt','098765432',1,'2026-04-13 17:10:18','ACTIVE',NULL),(6,'trung@gmail.com','$2a$10$cMi7HiNBgcc7Y0.BltIO5OOnAiIFfYnJbJPyfVUIpn/4WKiZRp9M.','Đức Trung','0926766556',1,'2026-04-13 17:13:51','ACTIVE',NULL),(7,'trungnguyen@gmail.com','$2a$10$/riv0OM8XX1ZOn9cvyNoSedrboL2TG9DgI0V2Rxd86QJ/gxo.oNBW','Nguyễn Xuân Trung','0933437435',1,'2026-04-14 02:06:43','ACTIVE',NULL),(8,'dat@gmail.com','$2a$10$tiiyLa.IUG8o2.VgnXfSCu.JDAxvLQFqAI3hBnMdkhO7mNhHHZGD6','Bùi Văn Đạt','0987563728',1,'2026-04-14 17:16:41','ACTIVE',NULL),(9,'son@gmail.com','$2a$10$oqZ/IPDHNXr5iM2f05MjTu1IgS.abXV5ApSTEsfTbMKkSHCA.BNH2','Dương Tuấn Sơn','0948372617',1,'2026-04-14 17:17:46','ACTIVE',NULL),(10,'dung@gmail.com','$2a$10$WXsnVtZywfN3PSZ0NPpiEOpNBlPnmwxgqiOnNtpWJAyWICZ6hq/C.','Hoàng Văn Dũng','0365378838',1,'2026-04-14 17:18:17','ACTIVE',NULL),(11,'son1@gmail.com','$2a$10$MBtAvaTGLIwwhiPURDcab.SYd36icZirhSCcKchpEjWB6n5gV2cSC','son','0123456789',1,'2026-04-15 08:16:18','ACTIVE',NULL),(12,'abcde@gmail.com','$2a$10$OycSgqxZsx6ASNp/kDG2MuCv7hCVLpO4ux2dzaJRFbgm05pC7PJry','Nguyễn Văn B','0987654324',1,'2026-04-18 08:54:19','ACTIVE',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (1,'KM10','Giam 10%','PERCENT',10.00,100000.00,20000.00,'2026-01-01 00:00:00','2026-12-31 23:59:59',NULL,0,'INACTIVE'),(2,'KM20','Giam 20%','PERCENT',20.00,200000.00,50000.00,'2026-01-01 00:00:00','2026-12-31 00:00:00',1,1,'ACTIVE'),(3,'TIETKIEM','Giam 15k','FIXED',15000.00,50000.00,15000.00,'2026-01-01 00:00:00','2026-12-31 00:00:00',1,1,'ACTIVE'),(4,'KM01','KM 1','PERCENT',5.00,70000.00,10000.00,'2026-04-01 00:00:00','2026-04-23 23:59:59',10,1,'EXPIRED'),(5,'KM02','KM 2','PERCENT',5.00,70000.00,10000.00,'2026-04-01 00:00:00','2026-05-01 23:59:59',15,0,'ACTIVE'),(18,'KM16','KM 16','PERCENT',5.00,120000.00,10000.00,'2026-04-01 00:00:00','2026-05-01 23:59:59',1,1,'ACTIVE'),(21,'KM19','Giam 40%','PERCENT',10.00,100000.00,20000.00,'2025-12-31 17:00:00','2026-12-30 17:00:00',10,3,'ACTIVE'),(22,'WELCOME10',NULL,'PERCENT',10.00,0.00,NULL,'2024-01-01 00:00:00','2026-12-31 23:59:59',100,0,'ACTIVE'),(23,'PHIMHAY20',NULL,'PERCENT',20.00,0.00,50000.00,'2024-01-01 00:00:00','2026-12-31 23:59:59',50,0,'ACTIVE'),(24,'CUOITUAN30',NULL,'PERCENT',30.00,150000.00,100000.00,'2024-01-01 00:00:00','2026-12-31 23:59:59',20,0,'ACTIVE'),(25,'STUDENT',NULL,'PERCENT',15.00,100000.00,NULL,'2024-01-01 00:00:00','2026-12-31 23:59:59',200,0,'ACTIVE'),(26,'MEGA99',NULL,'PERCENT',50.00,300000.00,200000.00,'2024-01-01 00:00:00','2026-12-31 23:59:59',10,0,'ACTIVE'),(27,'GIAM20K',NULL,'FIXED',20000.00,0.00,NULL,'2024-01-01 00:00:00','2026-12-31 23:59:59',100,0,'ACTIVE'),(28,'BANBE50',NULL,'FIXED',50000.00,200000.00,NULL,'2024-01-01 00:00:00','2026-01-06 23:59:59',50,0,'EXPIRED'),(29,'VOUCHER100','Giam 100k','FIXED',100000.00,400000.00,100000.00,'2024-01-01 00:00:00','2026-12-31 23:59:59',11,0,'ACTIVE'),(31,'DEMO10K','Giam 10k','FIXED',10000.00,50000.00,10000.00,'2024-01-01 00:00:00','2026-12-31 23:59:59',300,0,'ACTIVE'),(32,'KM2377',NULL,'FIXED',10828.00,NULL,NULL,'2026-04-15 00:00:00','2026-04-21 23:59:59',NULL,0,'ACTIVE');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-17  0:00:12
