package com.proj.webprojrct.common.config.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtUtil jwtUtil, UserDetailsService uds) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = uds;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req,
            HttpServletResponse res,
            FilterChain chain) throws IOException, ServletException {
        String token = null;
        if (req.getCookies() != null) {
            for (Cookie c : req.getCookies()) {
                if ("access_token".equals(c.getName())) {
                    token = c.getValue();
                }
            }
        }

        if (token != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            String username = jwtUtil.extractUsername(token);
            var userDetails = userDetailsService.loadUserByUsername(username);
            if (jwtUtil.isTokenValid(token, userDetails)) {
                var auth = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }

        chain.doFilter(req, res);
    }
}
