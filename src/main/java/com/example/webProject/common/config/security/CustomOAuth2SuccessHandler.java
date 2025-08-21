// package com.example.webProject.common.config.security;

// import com.example.webProject.user.entity.UserRole;
// import com.example.webProject.user.entity.User;
// import com.example.webProject.user.repository.UserRepository;
// import com.example.webProject.auth.JwtService;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import org.springframework.security.core.Authentication;
// import org.springframework.security.oauth2.core.user.OAuth2User;
// import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
// import org.springframework.stereotype.Component;

// import java.io.IOException;

// @Component
// public class CustomOAuth2SuccessHandler implements AuthenticationSuccessHandler {

//     private final UserRepository userRepository;
//     private final JwtService jwtService;

//     public CustomOAuth2SuccessHandler(UserRepository userRepository, JwtService jwtService) {
//         this.userRepository = userRepository;
//         this.jwtService = jwtService;
//     }

//     @Override
//     public void onAuthenticationSuccess(HttpServletRequest request,
//             HttpServletResponse response,
//             Authentication authentication)
//             throws IOException {
//         OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
//         String email = oAuth2User.getAttribute("email");

//         // Load user từ database
//         User user = userRepository.findByEmail(email)
//                 .orElseGet(() -> {
//                     // Nếu chưa có thì tạo mới user OAuth2
//                     User newUser = User.builder()
//                             .email(email)
//                             .fullName(oAuth2User.getAttribute("name"))
//                             .avatarUrl(oAuth2User.getAttribute("avatar_url"))
//                             .passwordHash("") // không cần mật khẩu
//                             .role(UserRole.MEMBER)
//                             .isActive(true)
//                             .build();
//                     return userRepository.save(newUser);
//                 });

//         String jwtAccessToken = jwtService.generateAccessToken(user);
//         String jwtRefreshToken = jwtService.generateRefreshToken(user);

//         // Lưu refresh token
//         user.setRefreshToken(jwtRefreshToken);
//         userRepository.save(user);

//         //Trả cho client
//         //TODO: Rediect về 1 endpoint nào đó của frontend với token
//         String json = String.format("{\"access_token\": \"%s\", \"refresh_token\": \"%s\"}", jwtAccessToken, jwtRefreshToken);

//         response.setContentType("application/json");
//         response.setCharacterEncoding("UTF-8");
//         response.getWriter().write(json);

//     }

// }
