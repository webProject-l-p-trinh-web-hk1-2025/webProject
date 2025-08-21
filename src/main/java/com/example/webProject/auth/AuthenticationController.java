package com.example.webProject.auth;

import com.example.webProject.auth.dto.request.ChangePasswordRequest;
import com.example.webProject.auth.dto.request.LoginDTO;
import com.example.webProject.auth.dto.request.RefreshTokenRequest;
import com.example.webProject.auth.dto.request.ResetPasswordRequest;
import com.example.webProject.auth.dto.response.LoginResponse;
import com.example.webProject.auth.dto.response.LoginResponseV1;
import com.example.webProject.common.error.Common;
import com.example.webProject.common.config.ApiMessage;
import com.example.webProject.common.exception.VerificationException;
import com.example.webProject.common.service.TokenCleanUpService;
import com.example.webProject.user.entity.User;
import com.example.webProject.user.repository.UserRepository;
import com.example.webProject.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.persistence.EntityExistsException;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthenticationController {

    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final AuthenicationService authenicationService;
    private final UserService userService;
    private final UserRepository userRepository;
    @Autowired
    private JwtService jwtService;
    @Autowired
    private TokenCleanUpService tokenCleanUpService;

    public AuthenticationController(UserService userService, AuthenicationService authenicationService, AuthenticationManagerBuilder authenticationManagerBuilder, UserRepository userRepository) {
        this.authenticationManagerBuilder = authenticationManagerBuilder;
        this.authenicationService = authenicationService;
        this.userService = userService;
        this.userRepository = userRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseV1> login(@RequestBody LoginDTO loginDto) {
        // Xác thực username/password
        UsernamePasswordAuthenticationToken authToken
                = new UsernamePasswordAuthenticationToken(loginDto.getUsername(), loginDto.getPassword());

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authToken);

        // Lưu thông tin xác thực vào context (nếu cần)
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Lấy user từ DB để sinh JWT
        User user = userRepository.findByEmail(loginDto.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        String jwt = jwtService.generateAccessToken(user);
        String refresh_jwt = jwtService.generateRefreshToken(user);
        // Lưu refresh_token
        user.setRefreshToken(refresh_jwt);
        userRepository.save(user);

        // Trả về access_token (hoặc set cookie nếu muốn)
        return ResponseEntity.ok().body(new LoginResponseV1(jwt, refresh_jwt));
    }

    @PostMapping("/refresh")
    @ApiMessage("Get Access Token")
    public ResponseEntity<LoginResponseV1> getNewAccessToken(@RequestBody RefreshTokenRequest refresh_token_rq) throws EntityExistsException {
        return ResponseEntity.ok().body(this.authenicationService.handleRefreshToken(refresh_token_rq));
    }

    @PostMapping("/forgot-password")
    @ApiMessage("Get Access Token")
    public ResponseEntity<Void> forgotPassword(@RequestParam String email) throws EntityExistsException {
        this.authenicationService.handleForgotPassword(email);
        return ResponseEntity.status(HttpStatus.CREATED).body(null);
    }

    @GetMapping("/verify/{token}")
    @ApiMessage("Verify Token")
    public ResponseEntity<Void> verifyToken(@PathVariable("token") String token) throws VerificationException {
        this.authenicationService.handleVerify(token);
        return ResponseEntity.ok().body(null);
    }

    @PostMapping("/reset-password")
    @ApiMessage("Reset password")
    public ResponseEntity<String> resetPassword(@RequestBody ResetPasswordRequest resetPasswordRequest) throws VerificationException {
        authenicationService.handleResetPassword(resetPasswordRequest);
        return ResponseEntity.ok().body("Reset password successfully");
    }

    @PostMapping("/change-password")
    @ApiMessage("Change password")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordRequest changePasswordRequest) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        authenicationService.handleChangePassword(changePasswordRequest, authentication);
        return ResponseEntity.ok().body("Change password successful");

    }

    /*@GetMapping("/oauth2/success")
    public ResponseEntity<?> success(@AuthenticationPrincipal OAuth2User principal) {
        // Lấy thông tin user từ GitLab
        String username = principal.getAttribute("username");
        String email = principal.getAttribute("email");
        String name = principal.getAttribute("name");

        // Tạo JWT token
        String token = jwtService.generateToken(username);

        // Trả JSON gồm token + thông tin user
        Map<String, Object> response = Map.of(
                "token", token,
                "username", username,
                "email", email,
                "name", name,
                "attributes", principal.getAttributes() // nếu muốn trả toàn bộ dữ liệu
        );

        return ResponseEntity.ok(response);
    }*/
}
