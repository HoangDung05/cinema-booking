package com.cinema.movie_booking.security;

import io.jsonwebtoken.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.security.Key;
import io.jsonwebtoken.security.Keys;

@Component
public class JwtUtils {
    private final Key signingKey;
    private final int jwtExpirationMs = 86400000; // 1 ngày

    public JwtUtils(@Value("${JWT_SECRET}") String jwtSecret) {
        byte[] secretBytes = jwtSecret.getBytes(StandardCharsets.UTF_8);
        if (secretBytes.length < 64) {
            throw new IllegalArgumentException("JWT_SECRET phải có ít nhất 64 byte UTF-8 để ký HS512");
        }
        this.signingKey = Keys.hmacShaKeyFor(secretBytes);
    }

    private Key key() {
        return signingKey;
    }

    // Tạo Token khi Login thành công
    public String generateJwtToken(String username) {
        return Jwts.builder()
                .setSubject((username))
                .setIssuedAt(new Date())
                .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
                .signWith(key(), SignatureAlgorithm.HS512)
                .compact();
    }

    // Lấy Username từ Token
    public String getUserNameFromJwtToken(String token) {
        return Jwts.parserBuilder().setSigningKey(key()).build().parseClaimsJws(token).getBody().getSubject();
    }

    // Kiểm tra Token hợp lệ
    public boolean validateJwtToken(String authToken) {
        try {
            Jwts.parserBuilder().setSigningKey(key()).build().parseClaimsJws(authToken);
            return true;
        } catch (Exception e) {
            System.out.println("Lỗi Token: " + e.getMessage());
        }
        return false;
    }
}
