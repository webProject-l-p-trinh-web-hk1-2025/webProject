package com.example.webProject.common.config.security;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.nimbusds.jose.jwk.source.ImmutableSecret;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    @Autowired
    private JwtAuthenticationFilter jwtFilter;

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Bean
    public JwtEncoder jwtEncoder() {
        SecretKey key = new SecretKeySpec(jwtSecret.getBytes(), "HmacSHA256");
        return new NimbusJwtEncoder(new ImmutableSecret<>(key));
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(Customizer.withDefaults())
                .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Không dùng session

                .authorizeHttpRequests(authz -> authz
                .requestMatchers("/**", "/api/v1/auth/forgot-password", "/api/v1/auth/verify/**", "/swagger-ui/**", "/v3/api-docs/**", "/error/**").permitAll()
                .anyRequest().authenticated()
                )
                // Các request khác cần login

                .exceptionHandling(ex -> ex
                .authenticationEntryPoint(new CustomAuthenticationEntryPoint())
                .accessDeniedHandler(new CustomAccessDeniedHandler(new ObjectMapper()))
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
