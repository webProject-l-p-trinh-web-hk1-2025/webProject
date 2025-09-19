package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    // Lấy giỏ hàng của user
    @GetMapping("/{userId}")
    public CartResponse getCart(@PathVariable Long userId) {
        return cartService.getCartByUserId(userId);
    }

    // Thêm sản phẩm vào giỏ
    @PostMapping("/{userId}/add")
    public void addItem(@PathVariable Long userId, @RequestBody CartRequest request) {
        cartService.addItemToCart(userId, request);
    }

    // Xóa sản phẩm khỏi giỏ
    @DeleteMapping("/{userId}/remove/{productId}")
    public void removeItem(@PathVariable Long userId, @PathVariable Long productId) {
        cartService.removeItemFromCart(userId, productId);
    }

    // Xóa toàn bộ giỏ hàng
    @DeleteMapping("/{userId}/clear")
    public void clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
    }
}