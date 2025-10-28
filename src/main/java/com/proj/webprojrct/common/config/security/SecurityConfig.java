package com.proj.webprojrct.common.config.security;

import lombok.RequiredArgsConstructor;
import com.proj.webprojrct.common.config.security.JwtAuthenticationFilter;

import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import com.proj.webprojrct.auth.service.CustomOauth2UserService;
import com.proj.webprojrct.auth.service.OAuth2AuthenticationFailureHandler;
import com.proj.webprojrct.auth.service.OAuth2AuthenticationSuccessHandler;
import org.springframework.http.HttpMethod;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomUserDetailsService uds;
    private final PasswordEncoder passwordEncoder;
    private final JwtAuthenticationFilter jwtFilter;
    private final CustomAccessDeniedHandler accessDeniedHandler;
    private final CustomAuthenticationEntryPoint authenticationEntryPoint;
    private final CustomOauth2UserService customOauth2UserService;
    private final OAuth2AuthenticationFailureHandler oAuth2AuthenticationFailureHandler;
    private final OAuth2AuthenticationSuccessHandler oauth2SuccessHandler;

    // @Bean
    // public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    //     http
    //             .csrf(csrf -> csrf.disable())
    //             .authorizeHttpRequests(auth -> auth
    //             .anyRequest().permitAll() // tạm mở tất cả
    //             );
    //     return http.build();
    // }
    // @Bean
    // public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    //     http.csrf(csrf -> csrf.disable())
    //             .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
    //             .authorizeHttpRequests(auth -> auth
    //             .requestMatchers("/", "/login", "/dologin", "/register", "/doregister", "/doResetPassword", "/resetPassword", "/refresh", "/home", "/api/documents/**", "/api/products/**", "/css/**", "/js/**", "/favicon.ico", "/error", "/WEB-INF/jsp/**").permitAll()
    //             .requestMatchers("/admin/**").hasRole("ADMIN")
    //             .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
    //             .anyRequest().authenticated()
    //             )
    //             .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
    //             .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
    //     return http.build();
    // }
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/oauth2/**", "/login", "/dologin", "/register", "/doregister", "/register-phone-verify", "/register-phone-skip", "/doResetPassword", "/resetPassword", "/refresh", "/home", "/about", "/product/**", "/products", "/shop", "/deals", "/cart", "/wishlist", "/css/**", "/js/**", "/fonts/**", "/img/**", "/image/**", "/uploads/**", "/favicon.ico", "/error", "/error/**", "/webjars/**", "/WEB-INF/views/**", "/WEB-INF/decorators/**", "/common/**").permitAll()
                .requestMatchers("/api/products/**", "/api/categories/**", "/api/media/**", "/api/cart/**", "/api/favorite/**", "/api/documents/**", "/api/reviews/**", "/api/send-otp", "/api/verify-otp").permitAll()
                .requestMatchers("/about", "/faq", "/warranty", "/return", "/payment", "/shipping", "/contact").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/seller/**").hasAnyRole("SELLER", "ADMIN")
                .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN", "SELLER")
                .anyRequest().authenticated()
                )
                .exceptionHandling(e -> e
                .accessDeniedHandler(accessDeniedHandler)
                .authenticationEntryPoint(authenticationEntryPoint)
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                .formLogin(form -> form.disable())
                .oauth2Login(oauth2 -> oauth2
                .loginPage("/login") // if you use a custom login page
                .defaultSuccessUrl("/", true) // or use a successHandler
                .userInfoEndpoint(userInfo -> userInfo.userService(customOauth2UserService))
                .successHandler(oauth2SuccessHandler)
                .failureHandler(oAuth2AuthenticationFailureHandler)
                )
                .httpBasic(httpBasic -> httpBasic.disable());

        return http.build();
    }

    @Bean
    public DaoAuthenticationProvider daoAuthProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(uds);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
}
