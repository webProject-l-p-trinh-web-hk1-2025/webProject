package com.proj.webprojrct.auth;

import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import com.proj.webprojrct.common.config.security.CustomUserDetails;

import jakarta.servlet.http.HttpSession;

import java.lang.annotation.Repeatable;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.*;

@AllArgsConstructor
@Controller
public class AuthController {

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

    @GetMapping("/login")
    public String loginPage(@CookieValue(value = "access_token", required = false) String accessToken) {
        if (accessToken != null && jwtUtil.validateToken(accessToken)) {
            return "redirect:/home";
        }
        return "login";
    }

    @PostMapping("/dologin")
    public String login(@RequestParam String phone,
            @RequestParam String password,
            HttpServletResponse response,
            HttpSession session,
            Model model) {

        try {
            Authentication auth = authManager.authenticate(
                    new UsernamePasswordAuthenticationToken(phone, password)
            );

            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            User user = userDetails.getUser();

            if (user == null || !user.getIsActive()) {
                model.addAttribute("error", "User is not active or does not exist");
                return "login"; // login.jsp
            }

            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);

            // Lưu refresh token vào DB
            user.setRefreshToken(refreshToken);
            userRepo.save(user);

            // Cookie (HttpOnly)
            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            // 🔹 Lưu thông tin user vào session (để JSP home đọc được nhiều lần)
            session.setAttribute("username", user.getFullName());
            session.setAttribute("role", user.getRole().name());
            session.setAttribute("phone", user.getPhone());
            return "redirect:/home"; // điều hướng thay vì render trực tiếp
        } catch (Exception e) {
            model.addAttribute("error", "Sai số điện thoại hoặc mật khẩu!");
            return "login"; // login.jsp
        }
    }

    @GetMapping("/home")
    public String homePage(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            User user = userDetails.getUser();
            model.addAttribute("username", user.getFullName());
            model.addAttribute("role", user.getRole().name());
            model.addAttribute("phone", user.getPhone());
        }
        return "home";
    }

    @PostMapping("/refresh")
    public String refresh(@CookieValue("refresh_token") String refreshToken,
            HttpServletResponse response,
            Model model) {
        String username = jwtUtil.extractUsername(refreshToken);

        User user = userRepo.findByPhone(username).orElseThrow();
        if (!refreshToken.equals(user.getRefreshToken())) {
            model.addAttribute("error", "Invalid refresh token");
            return "login"; // login.jsp
        }

        String newAccess = jwtUtil.generateAccessToken(user);
        Cookie accessCookie = new Cookie("access_token", newAccess);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        response.addCookie(accessCookie);

        model.addAttribute("message", "Token refreshed successfully!");
        model.addAttribute("user", user.getUsername());
        model.addAttribute("role", user.getRole().name());
        model.addAttribute("phone", user.getPhone());
        return "home";
    }

    @PostMapping("/dologout")
    public String logout(@CookieValue(value = "refresh_token", required = false) String refreshToken,
            HttpServletResponse response,
            HttpSession session) {

        // Xóa token trong DB
        if (refreshToken != null) {
            try {
                String phone = jwtUtil.extractUsername(refreshToken);
                User user = userRepo.findByPhone(phone).orElse(null);
                if (user != null) {
                    user.setRefreshToken(null);
                    userRepo.save(user);
                }
            } catch (Exception e) {
                // token không hợp lệ thì bỏ qua
            }
        }

        Cookie accessCookie = new Cookie("access_token", null);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");          // path giống lúc tạo
        accessCookie.setDomain("localhost"); // domain giống lúc tạo
        accessCookie.setMaxAge(0);          // xóa cookie
        response.addCookie(accessCookie);

        // Xóa refresh_token
        Cookie refreshCookie = new Cookie("refresh_token", null);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        refreshCookie.setDomain("localhost");
        refreshCookie.setMaxAge(0);
        response.addCookie(refreshCookie);

        session.invalidate();

        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage(@CookieValue(value = "access_token", required = false) String accessToken) {
        if (accessToken != null && jwtUtil.validateToken(accessToken)) {
            return "redirect:/home";
        }
        return "register";
    }

    @PostMapping("/doregister")
    public String register(@CookieValue(value = "access_token", required = false) String accessToken,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String fullName,
            @RequestParam String email,
            Model model) {
        if (accessToken != null && jwtUtil.validateToken(accessToken)) {
            return "redirect:/home";
        }
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp!");
            return "register";
        }
        if (userRepo.existsByPhone(phone)) {
            model.addAttribute("error", "Số điện thoại đã được đăng ký!");
            return "register";
        }
        UserRole userRole = UserRole.USER; // Vai trò mặc định
        User newUser = new User();
        newUser.setPhone(phone);
        newUser.setPasswordHash(passwordEncoder.encode(password)); // Mã hóa mật khẩu trong service
        newUser.setFullName(fullName);
        newUser.setIsActive(true); // Mặc định kích hoạt tài khoản
        newUser.setRole(userRole); // Vai trò mặc định
        newUser.setEmail(email);
        userRepo.save(newUser);
        model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
        return "register";
    }

    @GetMapping("/resetPassword")
    public String resetPasswordPage(@CookieValue(value = "access_token", required = false) String accessToken) {
        if (accessToken != null && jwtUtil.validateToken(accessToken)) {
            return "redirect:/home";
        }
        return "resetPassword";
    }

    @PostMapping("/doResetPassword")
    public String resetPassword(@RequestParam String input,
            @CookieValue(value = "access_token", required = false) String accessToken,
            Model model) {
        if (accessToken != null && jwtUtil.validateToken(accessToken)) {
            return "redirect:/home";
        }
        //User user = userRepo.findByPhone(phone).orElse(null);
        if (input == null || input.isEmpty()) {
            model.addAttribute("error", "vui lòng hập email hoặc số điện thoại.");
            return "resetPassword";
        }
        if (input.contains("@")) {
            boolean result = authService.EmailResetPasswordHandle(input, model);
            if (!result) {
                return "resetPassword";
            }
            model.addAttribute("message", "Mật khẩu mới đã được gửi qua email. Vui lòng kiểm tra email của bạn.");

        } else {
            boolean result = authService.PhoneResetPasswordHandle(input, model);
            if (!result) {
                return "resetPassword";
            }
            model.addAttribute("message", "Mật khẩu mới đã được gửi qua SMS. Vui lòng kiểm tra điện thoại của bạn.");
        }
        return "resetPassword";
    }

}
