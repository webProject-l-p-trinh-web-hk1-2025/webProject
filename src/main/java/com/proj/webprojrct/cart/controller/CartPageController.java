package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

@Controller
public class CartPageController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/cart")
    public String cartPage(Model model, Principal principal, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        
        // Nếu không có userId trong session, lấy từ principal (phone number là username)
        if (userId == null && principal != null) {
            String phone = principal.getName(); // Username = phone number
            User user = userRepository.findByPhone(phone)
                    .orElse(null);
            if (user != null) {
                userId = user.getId();
                session.setAttribute("userId", userId); // Cache vào session
            }
        }
        
        if (userId == null) {
            // Chưa đăng nhập, chuyển về trang đăng nhập
            return "redirect:/login";
        }
        
        CartResponse cart = cartService.getCartByUserId(userId);
        model.addAttribute("cart", cart);
        return "cart";
    }

    @GetMapping("/cart.jsp")
    public String cartTestPage() {
        return "cart";
    }
}