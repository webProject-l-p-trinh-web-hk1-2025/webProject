package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.common.ResponseMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    // Lấy giỏ hàng của user
    @GetMapping("/{userId}")
    public ResponseEntity<CartResponse> getCart(@PathVariable Long userId) {
        CartResponse cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(cart);
    }

    // Thêm sản phẩm vào giỏ hàng
    @PostMapping("/{userId}/add")
    public ResponseEntity<ResponseMessage> addItem(@PathVariable Long userId, @RequestBody CartRequest request) {
        cartService.addItemToCart(userId, request);
        return ResponseEntity.ok(new ResponseMessage("Thêm hàng vào giỏ thành công!"));
    }

    // Xóa sản phẩm khỏi giỏ hàng
    @DeleteMapping("/{userId}/remove/{productId}")
    public ResponseEntity<ResponseMessage> removeItem(@PathVariable Long userId, @PathVariable Long productId) {
        cartService.removeItemFromCart(userId, productId);
        return ResponseEntity.ok(new ResponseMessage("Đã xóa sản phẩm khỏi giỏ hàng!"));
    }

    // Xóa toàn bộ giỏ hàng
    @DeleteMapping("/{userId}/clear")
    public ResponseEntity<ResponseMessage> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.ok(new ResponseMessage("Đã xóa toàn bộ giỏ hàng!"));
    }
}