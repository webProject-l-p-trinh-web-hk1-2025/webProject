package com.proj.webprojrct.auth;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import static org.springframework.security.core.context.SecurityContextHolder.getContext;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login(@RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            Model model) {
        System.out.println("9999");
        if (error != null) {

            model.addAttribute("error", "Số điện thoại hoặc mật khẩu không đúng.");
        }
        if (logout != null) {
            System.out.println("8888");
            model.addAttribute("message", "Bạn đã đăng xuất thành công.");
        }
        return "login";
    }

    @GetMapping("/home")
    public String home() {
        return "home"; // Trả về tên view, ví dụ: home.html
    }

    // @GetMapping("/home")
    // public String homePage(Model model, Authentication authentication) {
    //     model.addAttribute("username", authentication.getName());
    //     return "home"; // -> /WEB-INF/jsp/home.jsp
    // }
}
