package com.proj.webprojrct.cart.controller;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    // Lấy giỏ hàng của user đang login
    @GetMapping
    public ResponseEntity<?> getCart(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResponseMessage("Vui lòng đăng nhập để xem giỏ hàng!"));
        }
        CartResponse cart = cartService.getCartByUserId(userDetails.getUser().getId());
        return ResponseEntity.ok(cart);
    }

    // Thêm sản phẩm vào giỏ hàng
    @PostMapping("/add")
    public ResponseEntity<ResponseMessage> addItem(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestBody CartRequest request) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResponseMessage("Vui lòng đăng nhập để thêm vào giỏ hàng!"));
        }
        cartService.addItemToCart(userDetails.getUser().getId(), request);
        return ResponseEntity.ok(new ResponseMessage("Thêm hàng vào giỏ thành công!"));
    }

    // Cập nhật số lượng sản phẩm trong giỏ hàng
    @PutMapping("/update/{cartItemId}")
    public ResponseEntity<ResponseMessage> updateItem(@AuthenticationPrincipal CustomUserDetails userDetails, 
                                                      @PathVariable Long cartItemId,
                                                      @RequestBody CartRequest request) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResponseMessage("Vui lòng đăng nhập để cập nhật giỏ hàng!"));
        }
        cartService.updateItemQuantity(userDetails.getUser().getId(), cartItemId, request.getQuantity());
        return ResponseEntity.ok(new ResponseMessage("Đã cập nhật số lượng sản phẩm!"));
    }

    // Xóa sản phẩm khỏi giỏ hàng
    @DeleteMapping("/remove/{productId}")
    public ResponseEntity<ResponseMessage> removeItem(@AuthenticationPrincipal CustomUserDetails userDetails, @PathVariable Long productId) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResponseMessage("Vui lòng đăng nhập để xóa sản phẩm!"));
        }
        cartService.removeItemFromCart(userDetails.getUser().getId(), productId);
        return ResponseEntity.ok(new ResponseMessage("Đã xóa sản phẩm khỏi giỏ hàng!"));
    }

    // Xóa toàn bộ giỏ hàng
    @DeleteMapping("/clear")
    public ResponseEntity<ResponseMessage> clearCart(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ResponseMessage("Vui lòng đăng nhập để xóa giỏ hàng!"));
        }
        cartService.clearCart(userDetails.getUser().getId());
        return ResponseEntity.ok(new ResponseMessage("Đã xóa toàn bộ giỏ hàng!"));
    }
}