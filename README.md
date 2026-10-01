# Cinema Booking

Ứng dụng đặt vé xem phim gồm giao diện khách hàng, trang quản trị, API Spring Boot và cơ sở dữ liệu MySQL. Khách hàng có thể xem phim, chọn suất chiếu và ghế, áp dụng mã giảm giá, đặt vé và xem lịch sử vé. Trang quản trị hỗ trợ quản lý phim, suất chiếu, phòng chiếu, người dùng, vé và voucher.

## Công nghệ

| Thành phần | Công nghệ |
| --- | --- |
| Frontend | React 19, TypeScript, Vite 6, Tailwind CSS 4, React Router, Axios |
| Backend | Java 21, Spring Boot 3.2.5, Spring Security, Spring Data JPA, JWT, Maven |
| Dữ liệu | MySQL 8 |
| Tài liệu API | Springdoc OpenAPI / Swagger UI |
| Triển khai Docker | Docker Compose, Nginx |

## Cấu trúc dự án

```text
cinema-booking/
├── cinema-booking-backend/   # API Spring Boot, Maven Wrapper
├── cinema-booking-frontend/  # Ứng dụng React/Vite
├── docker-compose.yml        # MySQL, backend, frontend
├── init.sql                  # Cấu trúc và dữ liệu mẫu MySQL
└── README.md
```

## Chức năng chính

- **Khách hàng:** xem và tìm phim, xem lịch chiếu, chọn ghế, giữ ghế, tính giá và áp dụng voucher, đặt vé, xem hồ sơ và lịch sử vé. Có thể đặt vé với email khách hoặc tài khoản đã đăng nhập.
- **Quản trị:** xem thống kê và danh sách vé; quản lý phim, suất chiếu, phòng chiếu, người dùng và voucher.
- **Chatbot:** giao diện gửi câu hỏi qua backend; backend sử dụng Gemini để tạo câu trả lời dựa trên dữ liệu phim và lịch chiếu.
- **Giữ ghế:** đơn ở trạng thái `PENDING` quá 2 phút sẽ được chuyển sang `CANCELLED` để giải phóng ghế.

> **Lưu ý về thanh toán:** nút thanh toán hiện gọi API để ghi nhận phương thức thanh toán và trạng thái thành công trong cơ sở dữ liệu. Dự án chưa tích hợp giao dịch thật với MoMo hoặc đơn vị phát hành thẻ.

## Tài khoản thử nghiệm

Sau khi import dữ liệu mẫu từ `init.sql`, bạn có thể đăng nhập bằng các tài khoản sau:

| Vai trò | Tên đăng nhập | Mật khẩu |
| --- | --- | --- |
| Khách hàng | `dung@gmail.com` | `123456` |
| Admin | `admin@gmail.com` | `123456` |

Các tài khoản này chỉ dùng để thử nghiệm; hãy đổi mật khẩu hoặc xóa chúng trước khi triển khai công khai.

## Chạy trực tiếp trên máy (không dùng Docker)

### Yêu cầu

- JDK 21 và Node.js 20 trở lên.
- MySQL 8 đang chạy ở `localhost:3306`.
- Tài khoản MySQL có quyền sử dụng database `cinema_booking`. Cấu hình mặc định trong `cinema-booking-backend/src/main/resources/application.yaml` là `root` / `root`; sửa file này hoặc đặt các biến môi trường `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD` cho phù hợp với máy của bạn.

### 1. Chuẩn bị database

Tạo database `cinema_booking`. Để có dữ liệu mẫu, import `init.sql` vào database đó bằng MySQL Workbench hoặc MySQL CLI. Ví dụ trong MySQL CLI:

```sql
CREATE DATABASE IF NOT EXISTS cinema_booking CHARACTER SET utf8mb4;
USE cinema_booking;
SOURCE D:/Project/cinema-booking/init.sql;
```

Thay đường dẫn `SOURCE` nếu dự án nằm ở vị trí khác. File SQL này chứa lệnh xóa và tạo lại bảng; **không import vào database đang có dữ liệu cần giữ**. Nếu chỉ tạo database trống, Hibernate (`ddl-auto: update`) sẽ tạo/cập nhật bảng khi backend chạy, nhưng sẽ không có dữ liệu mẫu.

### 2. Chạy backend

Mở PowerShell tại thư mục gốc dự án:

```powershell
cd .\cinema-booking-backend
.\mvnw.cmd spring-boot:run
```

Hoặc mở dự án backend trong IDE và chạy class `com.cinema.movie_booking.MovieBookingApplication`. Trên macOS/Linux, dùng `./mvnw spring-boot:run`.

Backend chạy tại `http://localhost:8080/api`. Thử `http://localhost:8080/api/movies`; Swagger UI ở `http://localhost:8080/api/swagger-ui.html`.

### 3. Chạy frontend

Mở terminal thứ hai tại thư mục gốc dự án:

```powershell
cd .\cinema-booking-frontend
npm ci
npm run dev
```

Mở `http://localhost:3000`. Frontend hiện gọi API cố định tại `http://localhost:8080/api` trong `src/services/apiClient.ts` và `src/services/chatbotService.ts`, nên cần chạy backend ở cổng 8080 khi dùng cấu hình mặc định.

## Chạy bằng Docker Compose

Cần cài Docker Desktop (hoặc Docker Engine với Compose) và khởi động Docker trước. Tại thư mục gốc dự án:

```powershell
docker compose up -d --build
docker compose ps
```

| Dịch vụ | Địa chỉ trên máy |
| --- | --- |
| Frontend | `http://localhost/` |
| Backend API | `http://localhost:8080/api` |
| Swagger UI | `http://localhost:8080/api/swagger-ui.html` |
| MySQL | `localhost:3307` (trong container: `db:3306`) |

Compose dùng MySQL `root` / `root` và tự import `init.sql` **chỉ khi volume MySQL được khởi tạo lần đầu**. Dừng các container bằng `docker compose down`. Nếu cần xóa toàn bộ dữ liệu trong volume và import lại từ đầu, chạy `docker compose down -v` rồi `docker compose up -d --build`.

## API chính

Tất cả đường dẫn bên dưới có tiền tố `/api`:

| Nhóm | Đường dẫn tiêu biểu |
| --- | --- |
| Xác thực | `POST /auth/register`, `POST /auth/login` |
| Phim | `GET /movies`, `GET /movies/{id}`, `GET /movies/now-showing`, `GET /movies/coming-soon` |
| Suất chiếu và ghế | `GET /showtimes`, `GET /showtimes/{id}/seats` |
| Đặt vé | `POST /bookings/calculate-price`, `POST /bookings/hold`, `POST /bookings/{id}/pay`, `GET /bookings/{id}` |
| Cá nhân | `GET /users/me`, `GET /users/me/bookings` |
| Quản trị | `/admin/stats`, `/admin/movies`, `/admin/showtimes`, `/admin/users`, `/admin/vouchers` |
| Chatbot | `POST /chat` |

Xem toàn bộ endpoint và cấu trúc request/response trong Swagger UI. Các API yêu cầu đăng nhập sử dụng JWT dạng `Authorization: Bearer <token>`. Quyền truy cập được khai báo trong `SecurityConfig`; hiện một số endpoint `/admin` (như voucher và danh sách vé) đang được cho phép truy cập công khai, cần rà soát trước khi triển khai thực tế.

## Cấu hình và lưu ý

- Cổng backend, context path và kết nối MySQL nằm trong `cinema-booking-backend/src/main/resources/application.yaml`.
- Chatbot sử dụng khóa Gemini qua cấu hình backend `gemini.api.key`. `ChatbotServiceImpl` hiện có khóa mặc định trong mã nguồn; hãy thay bằng cấu hình an toàn và thu hồi khóa cũ trước khi triển khai công khai.
- Cấu hình tài khoản MySQL trong dự án dành cho môi trường phát triển. Hãy đổi thông tin đăng nhập và cấu hình bảo mật trước khi triển khai công khai.
- Dữ liệu mẫu trong `init.sql` có các suất chiếu theo ngày cố định; nếu không còn suất chiếu sắp tới, hãy tạo suất chiếu mới trong trang quản trị.
- Nếu gặp lỗi cổng 8080 hoặc 3000 đã được sử dụng, hãy dừng tiến trình đang dùng cổng đó trước khi chạy lại. Khi chạy Docker, cổng 80 và 3307 cũng cần còn trống.
