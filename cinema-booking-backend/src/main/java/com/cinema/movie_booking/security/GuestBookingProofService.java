package com.cinema.movie_booking.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.util.Date;
import java.util.UUID;

/**
 * Stateless, time-limited capability for a guest booking. A domain-separated key
 * ensures this proof cannot be used as a login JWT.
 */
@Component
public class GuestBookingProofService {
    private static final Duration LIFETIME = Duration.ofDays(7);
    private static final String PURPOSE = "guest-booking";
    private final Key signingKey;

    public GuestBookingProofService(@Value("${JWT_SECRET}") String jwtSecret) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-512");
            digest.update(jwtSecret.getBytes(StandardCharsets.UTF_8));
            this.signingKey = Keys.hmacShaKeyFor(
                    digest.digest((":" + PURPOSE).getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-512 is unavailable", e);
        }
    }

    public String issue(Integer bookingId) {
        Date now = new Date();
        return Jwts.builder()
                .setSubject(bookingId.toString())
                .setId(UUID.randomUUID().toString())
                .claim("purpose", PURPOSE)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + LIFETIME.toMillis()))
                .signWith(signingKey, SignatureAlgorithm.HS512)
                .compact();
    }

    public boolean isValid(String proof, Integer bookingId) {
        if (proof == null || proof.isBlank() || proof.length() > 2048) {
            return false;
        }
        try {
            Claims claims = Jwts.parserBuilder().setSigningKey(signingKey).build()
                    .parseClaimsJws(proof).getBody();
            return PURPOSE.equals(claims.get("purpose"))
                    && bookingId.toString().equals(claims.getSubject());
        } catch (RuntimeException e) {
            return false;
        }
    }
}
