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
├── railway_demo.sql          # Schema và dữ liệu giả lập an toàn cho Railway
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

`railway_demo.sql` không tạo tài khoản nào. Hai tài khoản trên chỉ có trong dữ liệu local từ `init.sql`.

## Chạy trực tiếp trên máy (không dùng Docker)

### Yêu cầu

- JDK 21 và Node.js 20 trở lên.
- MySQL 8 đang chạy ở `localhost:3306`.
- Tài khoản MySQL có quyền sử dụng database `cinema_booking`. Backend đọc kết nối qua `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`; khóa ký JWT qua `JWT_SECRET`.

### 1. Chuẩn bị database

Tạo database `cinema_booking`. Để có dữ liệu mẫu, import `init.sql` vào database đó bằng MySQL Workbench hoặc MySQL CLI. Ví dụ trong MySQL CLI:

```sql
CREATE DATABASE IF NOT EXISTS cinema_booking CHARACTER SET utf8mb4;
USE cinema_booking;
SOURCE D:/Project/cinema-booking/init.sql;
```

Thay đường dẫn `SOURCE` nếu dự án nằm ở vị trí khác. File SQL này chứa lệnh xóa và tạo lại bảng; **không import vào database đang có dữ liệu cần giữ**. Nếu chỉ tạo database trống, Hibernate (`ddl-auto: update`) sẽ tạo/cập nhật bảng khi backend chạy, nhưng sẽ không có dữ liệu mẫu.

### 2. Chạy backend

Để kiểm tra và đóng gói backend, chạy trong `cinema-booking-backend`:

```powershell
.\mvnw.cmd clean package
```

Bài test dùng database H2 tạm, nên lệnh build này không cần MySQL hoặc file `.env`. File WAR được tạo trong `target/`. Khi **chạy ứng dụng thật**, backend vẫn cần `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` và `JWT_SECRET`.

Mở PowerShell tại thư mục gốc dự án:

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
# Điền DB_PASSWORD và JWT_SECRET vào .env trước lần chạy đầu tiên.
Get-Content .env | ForEach-Object {
    if ($_ -match '^([A-Z_][A-Z0-9_]*)=(.*)$') {
        [Environment]::SetEnvironmentVariable($Matches[1], $Matches[2], 'Process')
    }
}
cd .\cinema-booking-backend
.\mvnw.cmd spring-boot:run
```

Thay `DB_USERNAME` và `DB_PASSWORD` trong `.env` theo MySQL trên máy. `JWT_SECRET` cần tối thiểu 64 byte UTF-8; tạo một khóa ngẫu nhiên một lần và giữ nguyên để JWT không mất hiệu lực sau mỗi lần chạy. Spring Boot không tự đọc `.env`, vì vậy terminal phải nạp file như trên. Nếu chạy từ IntelliJ IDEA, chọn file `.env` trong **Run → Edit Configurations → Environment variables** rồi chạy class `com.cinema.movie_booking.MovieBookingApplication`. Trên macOS/Linux, dùng `./mvnw spring-boot:run` sau khi export các biến tương ứng.

Backend chạy tại `http://localhost:8080/api`. Thử `http://localhost:8080/api/movies`; Swagger UI ở `http://localhost:8080/api/swagger-ui.html`.

### 3. Chạy frontend

Mở terminal thứ hai tại thư mục gốc dự án:

```powershell
cd .\cinema-booking-frontend
npm ci
npm run dev
```

Mở `http://localhost:3000`. Frontend dùng `VITE_API_URL` làm base URL cho cả API chính và chatbot; mặc định là `http://localhost:8080/api` khi chạy local. Khi deploy trên Vercel, đặt `VITE_API_URL` thành URL backend Railway có `/api` ở cuối, ví dụ `https://backend.example.up.railway.app/api`. Đây là biến công khai được Vite đưa vào bản build, không đặt mật khẩu hoặc API key trong biến `VITE_`. Sau khi đổi biến trên Vercel, cần redeploy để tạo bản build mới.

## Chạy bằng Docker Compose

Cần cài Docker Desktop (hoặc Docker Engine với Compose) và khởi động Docker trước. Tại thư mục gốc dự án:

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
# Điền MYSQL_ROOT_PASSWORD và JWT_SECRET vào .env trước khi chạy.
docker compose up -d --build
docker compose ps
```

| Dịch vụ | Địa chỉ trên máy |
| --- | --- |
| Frontend | `http://localhost/` |
| Backend API | `http://localhost:8080/api` |
| Swagger UI | `http://localhost:8080/api/swagger-ui.html` |
| MySQL | `localhost:3307` (trong container: `db:3306`) |

Compose dùng tài khoản MySQL `root` với mật khẩu lấy từ `.env` và tự import `init.sql` **chỉ khi volume MySQL được khởi tạo lần đầu**. `.env` đã được Git bỏ qua; không commit file này. Dừng các container bằng `docker compose down`. Nếu cần xóa toàn bộ dữ liệu trong volume và import lại từ đầu, chạy `docker compose down -v` rồi `docker compose up -d --build`.

## Nạp dữ liệu demo vào MySQL trên Railway

Chỉ dùng [railway_demo.sql](railway_demo.sql) cho **database Railway mới, trống**. File này tạo 11 bảng và dữ liệu giả lập: 3 phim, 1 rạp, 3 phòng, 144 ghế, 3 suất chiếu/ngày trong 365 ngày tính từ ngày import. Bảng `users`, `bookings` và `payments` ban đầu trống. Không import `init.sql` lên Railway vì file local đó chứa thông tin người dùng, lịch sử vé và lịch chiếu cũ.

1. Trong Railway, mở service **MySQL → Variables**. Kiểm tra có `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD`. Không sao chép giá trị bí mật vào Git hoặc tin nhắn.
2. Vào **Settings → Networking**, thêm **Public Access** cho MySQL. Railway tạo `MYSQL_PUBLIC_URL` với host và cổng TCP công khai. Dùng host/cổng trong URL đó cho kết nối từ máy tính; `MYSQLHOST`/`MYSQLPORT` nội bộ chỉ dùng giữa các service Railway.
3. Mở MySQL Workbench, tạo kết nối mới kiểu **Standard (TCP/IP)**. Điền hostname và port từ `MYSQL_PUBLIC_URL`, username từ `MYSQLUSER`, password từ `MYSQLPASSWORD`, **Default Schema** là `MYSQLDATABASE`. Bấm **Test Connection**.
4. Mở [railway_demo.sql](railway_demo.sql) bằng **File → Open SQL Script**. Chọn `MYSQLDATABASE` làm schema mặc định, rồi chạy toàn bộ script. Chỉ chạy một lần; file dùng ID cố định để các bảng liên kết đúng.
5. Trong Workbench, chạy truy vấn kiểm tra:

   ```sql
   SELECT (SELECT COUNT(*) FROM movies) AS movies,
          (SELECT COUNT(*) FROM rooms) AS rooms,
          (SELECT COUNT(*) FROM seats) AS seats,
          (SELECT COUNT(*) FROM showtimes) AS showtimes,
          (SELECT COUNT(*) FROM users) AS users,
          (SELECT COUNT(*) FROM bookings) AS bookings;
   SELECT MIN(start_time), MAX(start_time) FROM showtimes;
   ```

   Kết quả mong đợi: `3` phim, `3` phòng, `144` ghế, `1095` suất chiếu, `0` người dùng, `0` đơn đặt vé. Ngày cuối của lịch chiếu phải ở tương lai.
6. Sau khi kiểm tra, trở lại **MySQL → Settings → Networking** và xóa **Public Access** của database. Backend Railway sẽ kết nối qua mạng nội bộ ở giai đoạn tiếp theo.

Nếu Workbench báo lỗi, giữ nguyên log lỗi và dòng SQL gây lỗi để kiểm tra; không chạy lại toàn bộ file trên database đã import một phần.

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

Xem toàn bộ endpoint và cấu trúc request/response trong Swagger UI. Các API yêu cầu đăng nhập sử dụng JWT dạng `Authorization: Bearer <token>`. Quyền truy cập được khai báo trong `SecurityConfig`; các API quản trị và thao tác ghi phim/phòng/voucher yêu cầu quyền ADMIN. Thanh toán hiện chỉ là luồng mô phỏng để trình diễn, chưa tích hợp cổng thanh toán thật.

## Cấu hình và lưu ý

- Cổng backend, context path và kết nối MySQL nằm trong `cinema-booking-backend/src/main/resources/application.yaml`.
- Backend đọc `CORS_ALLOWED_ORIGINS` dưới dạng danh sách origin cách nhau bằng dấu phẩy. Mặc định chỉ cho phép frontend local. Khi có domain Vercel, đặt biến này trong **Variables** của service Backend trên Railway, ví dụ `https://ten-du-an.vercel.app` (không thêm `/api` hoặc dấu `/` cuối); nếu cần nhiều origin, phân tách bằng dấu phẩy. Frontend gửi JWT qua header `Authorization`, không dùng cookie.
- Chatbot đọc khóa Gemini từ biến môi trường `GEMINI_API_KEY`. Khi chưa có khóa, các phần khác vẫn chạy và chatbot trả thông báo chưa được cấu hình. Khóa từng có trong mã nguồn cần được thu hồi trước khi triển khai công khai.
- Cấu hình tài khoản MySQL trong dự án dành cho môi trường phát triển. Hãy đổi thông tin đăng nhập và cấu hình bảo mật trước khi triển khai công khai.
- Dữ liệu mẫu trong `init.sql` có các suất chiếu theo ngày cố định; nếu không còn suất chiếu sắp tới, hãy tạo suất chiếu mới trong trang quản trị.
- Nếu gặp lỗi cổng 8080 hoặc 3000 đã được sử dụng, hãy dừng tiến trình đang dùng cổng đó trước khi chạy lại. Khi chạy Docker, cổng 80 và 3307 cũng cần còn trống.
