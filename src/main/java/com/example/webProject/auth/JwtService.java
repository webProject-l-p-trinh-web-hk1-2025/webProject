package com.example.webProject.auth;

import com.example.webProject.user.entity.User;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;

@Component
public class JwtService {

    @Value("${jwt.secret}")
    private String secret;

    private static final long ACCESS_TOKEN_EXPIRATION = 2 * 60 * 60 * 1000; // 2 tiếng
    private static final long REFRESH_TOKEN_EXPIRATION = 7 * 24 * 60 * 60 * 1000; // 7 ngày

    public String generateAccessToken(User user) {
        return generateToken(user, ACCESS_TOKEN_EXPIRATION, "access");
    }

    public String generateRefreshToken(User user) {
        return generateToken(user, REFRESH_TOKEN_EXPIRATION, "refresh");
    }

    public String generateToken(User user, long expirationMillis, String type) {
        return Jwts.builder()
                .setSubject(user.getEmail())
                .claim("id", user.getId())
                .claim("email", user.getEmail())
                .claim("fullName", user.getFullName())
                .claim("role", user.getRole().name())
                .claim("isActive", user.isActive())
                .claim("type", type) // <--- thêm type: "access" hoặc "refresh"
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMillis))
                .signWith(SignatureAlgorithm.HS256, secret)
                .compact();
    }

    public Claims extractAllClaims(String token) {
        return Jwts.parser()
                .setSigningKey(secret)
                .parseClaimsJws(token)
                .getBody();
    }

    public String extractRole(String token) {
        return (String) extractAllClaims(token).get("role");
    }

    public boolean isTokenExpired(String token) {
        Date expiration = extractAllClaims(token).getExpiration();
        return expiration.before(new Date());
    }

    public boolean validateToken(String token) {
        try {
            extractAllClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String extractTokenType(String token) {
        return (String) extractAllClaims(token).get("type");
    }

    public boolean isAccessToken(String token) {
        return "access".equals(extractTokenType(token));
    }

    public boolean isRefreshToken(String token) {
        return "refresh".equals(extractTokenType(token));
    }
}
