package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;

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

    @GetMapping("/cart")
public String cartPage(Model model, Principal principal, HttpSession session) {
    Long userId = (Long) session.getAttribute("userId");
    if (userId == null && principal != null) {
        try {
            userId = Long.parseLong(principal.getName());
        } catch (NumberFormatException e) {
            userId = null;
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
}