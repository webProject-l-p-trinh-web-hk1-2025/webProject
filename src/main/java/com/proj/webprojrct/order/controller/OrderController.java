package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // Tạo đơn hàng mới
    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody OrderRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để tạo đơn hàng!"));
        }
        OrderResponse order = orderService.createOrder(userDetails.getUser().getId(), request);
        return ResponseEntity.ok(order);
    }

    // Lấy chi tiết đơn hàng (chỉ được xem đơn của mình)
    @GetMapping("/{orderId}")
    public ResponseEntity<?> getOrder(@PathVariable Long orderId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để xem đơn hàng!"));
        }
        OrderResponse order = orderService.getOrderById(orderId);
        // TODO: Kiểm tra order.userId == userDetails.getUser().getId() để bảo mật
        return ResponseEntity.ok(order);
    }

    // Lấy danh sách đơn hàng của user đang login
    @GetMapping
    public ResponseEntity<?> getOrdersByUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để xem danh sách đơn hàng!"));
        }
        List<OrderResponse> orders = orderService.getOrdersByUserId(userDetails.getUser().getId());
        return ResponseEntity.ok(orders);
    }

    // Hủy đơn hàng (chỉ được hủy đơn của mình)
    @PutMapping("/{orderId}/cancel")
    public ResponseEntity<ResponseMessage> cancelOrder(@AuthenticationPrincipal CustomUserDetails userDetails, @PathVariable Long orderId) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để hủy đơn hàng!"));
        }
        // TODO: Kiểm tra order thuộc về user trước khi hủy
        orderService.cancelOrder(orderId);
        return ResponseEntity.ok(new ResponseMessage("Đã hủy đơn hàng thành công!"));
    }
}
