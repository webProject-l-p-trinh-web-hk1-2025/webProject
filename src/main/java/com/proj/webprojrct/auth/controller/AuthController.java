package com.proj.webprojrct.auth.controller;

import com.proj.webprojrct.auth.service.AuthService;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import com.proj.webprojrct.common.config.security.CustomUserDetails;

import jakarta.servlet.http.HttpSession;

import java.lang.annotation.Repeatable;
import java.util.HashMap;
import java.util.Map;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.proj.webprojrct.auth.dto.request.ChangePassRequest;
import com.proj.webprojrct.auth.dto.request.LoginRequest;
import com.proj.webprojrct.auth.dto.response.LoginResponse;

import lombok.*;

import com.proj.webprojrct.auth.dto.request.ChangePassRequest;

import com.proj.webprojrct.auth.dto.request.RegisterRequest;

import com.proj.webprojrct.auth.dto.request.LoginRequest;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;

import com.proj.webprojrct.auth.dto.response.LoginResponse;

@AllArgsConstructor
@Controller
public class AuthController {

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

    @GetMapping("/login")
    public String loginPage() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            return "redirect:/home";
        }

        return "login";
    }

    @PostMapping("/dologin")
    public String login(@ModelAttribute LoginRequest loginRequest,
            HttpServletResponse response,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) { //login
        try {
            LoginResponse loginResponse = authService.handleLogin(
                    loginRequest.getPhone(),
                    loginRequest.getPassword(),
                    session,
                    model
            );

            User user = loginResponse.getUser();
            String accessToken = loginResponse.getAccessToken();
            String refreshToken = loginResponse.getRefreshToken();

            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);

            return "redirect:/home";

        } catch (Exception e) {
            //model.addAttribute("error", e.getMessage());
            //return "login";
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/login"; //giữ lại model login
        }
    }

    @GetMapping("/home")
    public String homePage(Model model) {
        // Redirect to main home controller to ensure consistent data loading
        return "redirect:/";
    }

    @GetMapping("/refresh")
    public String refresh(@CookieValue("refresh_token") String refreshToken,
            HttpServletResponse response,
            Model model) {
        try {
            User user = authService.handleRefreshToken(refreshToken);
            String newAccess = authService.generateAccessToken(user);

            Cookie accessCookie = new Cookie("access_token", newAccess);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            model.addAttribute("message", "Token refreshed successfully!");
            model.addAttribute("user", user.getFullName());
            model.addAttribute("role", user.getRole().name());
            model.addAttribute("phone", user.getPhone());

            return "home";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "login";
        }
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
    public String registerPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home";
        }
        return "register";
    }

    @PostMapping("/doregister")
    public String register(@ModelAttribute RegisterRequest request, Model model, RedirectAttributes redirectAttributes) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home";
        }

        try {
            authService.registerUser(request);
            redirectAttributes.addFlashAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            return "redirect:/register";
        } catch (RuntimeException e) {
            // preserve entered values except passwords
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("fullName", request.getFullName());
            redirectAttributes.addFlashAttribute("phone", request.getPhone());
            redirectAttributes.addFlashAttribute("email", request.getEmail());
            return "redirect:/register";
        }
    }

    @GetMapping("/resetPassword")
    public String resetPasswordPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home"; // Đã đăng nhập, chuyển hướng
        }
        return "resetPassword";
    }

    @PostMapping("/doResetPassword")
    // public String resetPassword(@RequestParam String input, Model model) {
    public String resetPassword(@RequestParam String input, Model model, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "redirect:/home"; // người dùng đã đăng nhập
        }

        if (input == null || input.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng nhập email hoặc số điện thoại.");
            //return "resetPassword";
            redirectAttributes.addFlashAttribute("input", input);
            return "redirect:/resetPassword";
        }

        if (input.contains("@")) {
            boolean result = authService.EmailResetPasswordHandle(input, model);
            if (!result) {
                //return "resetPassword";

                // giải quyết email cài model.error
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Mật khẩu mới đã được gửi qua email. Vui lòng kiểm tra email của bạn.");
        } else {
            boolean result = authService.PhoneResetPasswordHandle(input, model);
            if (!result) {
                if (model.containsAttribute("error")) {
                    redirectAttributes.addFlashAttribute("error", model.asMap().get("error"));
                }
                redirectAttributes.addFlashAttribute("input", input);
                return "redirect:/resetPassword";
            }
            redirectAttributes.addFlashAttribute("message", "Mật khẩu mới đã được gửi qua SMS. Vui lòng kiểm tra điện thoại của bạn.");
        }

        return "redirect:/resetPassword";
        //return "resetPassword";
    }

    @PostMapping("/change-password")
    public String changePassword(@ModelAttribute ChangePassRequest request, RedirectAttributes redirectAttributes) {
        String message;
        boolean success = true;
        try {
            message = authService.changePassword(request);
        } catch (RuntimeException ex) {
            message = ex.getMessage();
            success = false;
        }

        redirectAttributes.addFlashAttribute("passwordChangeMessage", message);
        redirectAttributes.addFlashAttribute("passwordChangeSuccess", success);
        return "redirect:/profile";
    }

    @GetMapping("/change-password")
    public String showChangePasswordForm(Model model) {
        model.addAttribute("changePassRequest", new ChangePassRequest());
        return "change-password";
    }

    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @GetMapping("/verify-otp")
    public String showOtpForm(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof CustomUserDetails) {
            return "verify-otp";
        }
        return "redirect:/home";
    }

    @PostMapping("/send-otp-email")
    public String sendOtpEmail(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
            return "redirect:/home";
        }
        try {
            String msg = authService.sendOtpEmail();
            model.addAttribute("success", msg);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "verify-otp";
    }

    // Gửi OTP phone
    @PostMapping("/send-otp-phone")
    public String sendOtpPhone(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
            return "redirect:/home";
        }
        try {
            String msg = authService.sendOtpPhone();
            model.addAttribute("success", msg);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "verify-otp";
    }

    // Xác thực OTP
    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam("otp") String otpInput, Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
            return "redirect:/home";
        }
        try {
            String msg = authService.verifyOtp(otpInput);
            model.addAttribute("success", msg);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "verify-otp";
    }

    // API endpoints for AJAX calls
    @PostMapping("/api/send-otp")
    @ResponseBody
    public Map<String, Object> sendOtpAPI(@RequestParam("type") String type) {
        Map<String, Object> response = new HashMap<>();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
            response.put("success", false);
            response.put("message", "Bạn cần đăng nhập để thực hiện chức năng này");
            return response;
        }

        try {
            String msg;
            if ("email".equals(type)) {
                msg = authService.sendOtpEmail();
            } else if ("phone".equals(type)) {
                msg = authService.sendOtpPhone();
            } else {
                response.put("success", false);
                response.put("message", "Loại xác thực không hợp lệ");
                return response;
            }
            response.put("success", true);
            response.put("message", msg);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/api/verify-otp")
    @ResponseBody
    public Map<String, Object> verifyOtpAPI(@RequestParam("otp") String otpInput) {
        Map<String, Object> response = new HashMap<>();
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated() || !(auth.getPrincipal() instanceof CustomUserDetails)) {
            response.put("success", false);
            response.put("message", "Bạn cần đăng nhập để thực hiện chức năng này");
            return response;
        }

        try {
            String msg = authService.verifyOtp(otpInput);
            response.put("success", true);
            response.put("message", msg);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

}
