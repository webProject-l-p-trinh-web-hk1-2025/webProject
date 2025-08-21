package com.example.webProject.common.config.security;

import com.example.webProject.auth.JwtService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtAuthenticationFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();

        // Bỏ qua swagger và docs
        if (path.startsWith("/swagger-ui") || path.startsWith("/v3/api-docs")) {
            filterChain.doFilter(request, response);
            return;
        }

        String authHeader = request.getHeader("Authorization");

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);

            if (jwtService.validateToken(token)) {
                Claims claims = jwtService.extractAllClaims(token);
                String username = claims.getSubject();

                String role = (String) claims.get("role"); // ví dụ: "ADMIN"
                GrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + role);

                Authentication auth = new UsernamePasswordAuthenticationToken(
                        username, null, List.of(authority) // hoặc Collections.singletonList(authority)
                );

                SecurityContextHolder.getContext().setAuthentication(auth);

            }
        }

        filterChain.doFilter(request, response);
    }
}
