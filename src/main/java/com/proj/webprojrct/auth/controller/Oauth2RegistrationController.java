package com.proj.webprojrct.auth.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.proj.webprojrct.auth.dto.request.RegisterRequest;
import com.proj.webprojrct.auth.service.Oauth2RegistrationService;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.common.config.security.JwtUtil;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/oauth2")
public class Oauth2RegistrationController {

    private final Oauth2RegistrationService registrationService;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    /**
     * Hiển thị form nhập thông tin bổ sung khi OAuth2 user chưa tồn tại
     */
    @GetMapping("/complete")
    public String showCompleteForm(HttpServletResponse response,
            HttpSession session,
            Model model) {
        String email = (String) session.getAttribute("oauth2_email");
        String name = (String) session.getAttribute("oauth2_name");
        String picture = (String) session.getAttribute("oauth2_picture");

        if (email == null) {
            return "redirect:/login"; // session hết → quay lại login
        }
        System.out.println("OAuth2 email: " + email);
        // Kiểm tra user đã tồn tại chưa
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null) {
            System.out.println("User with email " + email + " already exists. Logging in...");
            String accessToken = jwtUtil.generateAccessToken(user);
            String refreshToken = jwtUtil.generateRefreshToken(user);
            Cookie accessCookie = new Cookie("access_token", accessToken);
            accessCookie.setHttpOnly(true);
            accessCookie.setPath("/");
            response.addCookie(accessCookie);

            Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
            refreshCookie.setHttpOnly(true);
            refreshCookie.setPath("/");
            response.addCookie(refreshCookie);
            session.removeAttribute("oauth2_email");
            session.removeAttribute("oauth2_name");
            session.removeAttribute("oauth2_picture");
            return "redirect:/";
        }

        model.addAttribute("email", email);
        model.addAttribute("name", name);
        model.addAttribute("picture", picture);

        return "oauth2_complete_form";
    }

    @PostMapping("/complete")
    public String completeRegistration(HttpSession session,
            HttpServletResponse response,
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam(required = false) String address) {

        String email = (String) session.getAttribute("oauth2_email");
        if (email == null) {
            return "redirect:/login";
        }

        RegisterRequest request = new RegisterRequest();
        request.setEmail(email);
        request.setFullName(fullName);
        request.setPhone(phone);
        request.setAddress(address);

        // Service sẽ tạo random password và lưu user
        User user = registrationService.registerNewUser(request);

        // Generate JWT ngay sau khi tạo user
        String accessToken = jwtUtil.generateAccessToken(user);
        String refreshToken = jwtUtil.generateRefreshToken(user);

        Cookie accessCookie = new Cookie("access_token", accessToken);
        accessCookie.setHttpOnly(true);
        accessCookie.setPath("/");
        response.addCookie(accessCookie);

        Cookie refreshCookie = new Cookie("refresh_token", refreshToken);
        refreshCookie.setHttpOnly(true);
        refreshCookie.setPath("/");
        response.addCookie(refreshCookie);

        // Xóa session tạm
        session.removeAttribute("oauth2_email");
        session.removeAttribute("oauth2_name");
        session.removeAttribute("oauth2_picture");

        return "redirect:/"; // redirect về trang chính, user đã được đăng nhập bằng JWT
    }

}
