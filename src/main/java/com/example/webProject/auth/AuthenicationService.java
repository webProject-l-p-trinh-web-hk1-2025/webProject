package com.example.webProject.auth;

import com.example.webProject.auth.dto.request.ChangePasswordRequest;
import com.example.webProject.auth.dto.request.RefreshTokenRequest;
import com.example.webProject.auth.dto.request.ResetPasswordRequest;
import com.example.webProject.auth.dto.response.LoginResponseV1;
import com.example.webProject.common.exception.InValidTokenExeption;
import com.example.webProject.common.exception.VerificationException;
import com.example.webProject.email.EmailService;
import com.example.webProject.user.entity.User;
import com.example.webProject.auth.dto.response.LoginResponse;
import com.example.webProject.user.repository.UserRepository;
import com.example.webProject.user.UserService;
import com.example.webProject.common.util.SecurityUtil;
import com.example.webProject.user.entity.UserToken;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import jakarta.xml.bind.ValidationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityExistsException;
import lombok.AllArgsConstructor;

import javax.swing.text.html.Option;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@AllArgsConstructor
@Service
public class AuthenicationService {

    private final UserService userService;
    private final SecurityUtil securityUtil;
    private final UserRepository userRepository;
    private PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final ConfirmationService confirmationService;
    private final JwtService jwtService;

    public LoginResponse handleLoginResponce(Authentication authentication, String username) {
        User user = this.userService.getUserByUserName(username);
        LoginResponse.UserLogin userLogin = new LoginResponse.UserLogin();
        userLogin.setEmail(user.getEmail());
        userLogin.setId(user.getId());
        userLogin.setRole(user.getRole());
        userLogin.setUserName(username);
        String accessToken = this.securityUtil.createToken(username, user);
        String refreshToken = this.securityUtil.createRefreshToken(username, user);
        user.setRefreshToken(refreshToken);
        this.userService.updateUser(user);

        ResponseCookie springCookie = ResponseCookie.from("refresh-token", refreshToken)
                .httpOnly(true)
                .secure(true)
                .path("/")
                .maxAge(this.securityUtil.jwtRefreshTokenExpiration)
                .build();
        LoginResponse loginResponse = LoginResponse.builder()
                .accessToken(accessToken)
                .springCookie(springCookie)
                .user(userLogin)
                .build();
        return loginResponse;
    }

    public LoginResponse getAccessToken(String refresh_token) throws EntityExistsException {
        User user = this.userService.getUserByRefreshToken(refresh_token);
        LoginResponse.UserLogin userResponce = new LoginResponse.UserLogin();
        userResponce.setId((user.getId()));
        userResponce.setUserName(user.getEmail());
        String accessToken = this.securityUtil.createToken(user.getEmail(), user);
        userResponce.setEmail(user.getEmail());
        LoginResponse loginResponse = new LoginResponse();
        loginResponse.setUser(userResponce);
        loginResponse.setAccessToken(accessToken);

        String refreshToken = this.securityUtil.createRefreshToken(user.getEmail(), user);
        user.setRefreshToken(refreshToken);
        this.userService.updateUser(user);

        ResponseCookie springCookie = ResponseCookie.from("refresh-token", refreshToken)
                .httpOnly(true)
                .secure(true)
                .path("/")
                .maxAge(this.securityUtil.jwtRefreshTokenExpiration)
                .build();
        loginResponse.setSpringCookie(springCookie);
        return loginResponse;
    }

    public void handleForgotPassword(String email) {
        User user = this.userService.getUserByUserName(email);
        if (user == null) {
            throw new EntityNotFoundException("User not found");
        }
        long tokenValue = new Random().nextLong();
        if (tokenValue < 0) {
            tokenValue = -tokenValue;
        }

        UserToken token = UserToken.builder()
                .token(tokenValue)
                .user(user)
                .expiresAt(LocalDateTime.now().plusMinutes(15))
                .build();

        token = this.userService.creatToken(token);
        this.emailService.send(user.getEmail(), user.getFullName(), token.getToken());
    }

    public void handleVerify(String token) {
        List<String> tokenList = Arrays.asList(token.split(","));
        long tokenNumber = Long.parseLong(tokenList.get(0));
        String email = tokenList.get(1);
        UserToken confirmationToken = this.confirmationService.getConfirmationByTokenAndEmail(tokenNumber, email).
                orElseThrow(
                        () -> new VerificationException("token is not found.")
                );
        if (confirmationToken.getConfirmedAt() != null) {
            throw new VerificationException("email is already confirmed");
        }
        if (confirmationToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new VerificationException("email is already expired");
        }
        this.confirmationService.ConfirmToken(tokenNumber, email);
    }

    @Transactional
    public void handleResetPassword(ResetPasswordRequest resetPasswordRequest) {
        Long resetToken = resetPasswordRequest.getToken();

        // Check if token is valid
        User user = confirmationService.findUserByResetPasswordToken(resetToken);
        if (user == null) {
            throw new VerificationException("Token not exist or not last");
        }

        // Change user's password
        user.setPasswordHash(passwordEncoder.encode(resetPasswordRequest.getNewPassword()));

        // Save user's password
        userService.updateUser(user);

        // Delete token
        confirmationService.removeToken(resetToken);
    }

    public void handleChangePassword(ChangePasswordRequest changePasswordRequest, Authentication authentication) {
        //Find current user
        String email = authentication.getName();
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            throw new VerificationException("User not found");
        }
        User targetUser = user.get();
        // Check if current password is correct
        if (!passwordEncoder.matches(changePasswordRequest.getCurrentPassword(), targetUser.getPasswordHash())) {
            throw new VerificationException("Current password is wrong");
        }

        // Change password
        targetUser.setPasswordHash(passwordEncoder.encode(changePasswordRequest.getNewPassword()));
        userService.updateUser(targetUser);

    }

    public LoginResponseV1 handleRefreshToken(RefreshTokenRequest request) throws InValidTokenExeption {
        String refresh_token = request.getRefresh_token();
        //Check if refresh_token exist
        Optional<User> userOptional = userRepository.findByRefreshToken(refresh_token);
        if (userOptional.isEmpty()) {
            throw new InValidTokenExeption("Token not found");
        }

        //Check if refresh_token is expiry
        if (jwtService.isTokenExpired(refresh_token)) {
            throw new InValidTokenExeption("Token is expiry");
        }

        //Gen new access token
        User user = userOptional.get();

        String newAccessToken = jwtService.generateAccessToken(user);
        return new LoginResponseV1(newAccessToken, refresh_token);
    }
}
