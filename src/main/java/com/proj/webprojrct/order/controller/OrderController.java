package com.proj.webprojrct.order.controller;

import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.payment.vnpay.service.PaymentService;

import jakarta.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.proj.webprojrct.common.ResponseMessage;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private PaymentService paymentService;

    // Tạo đơn hàng mới
    @PostMapping("/create")
    public ResponseEntity<?> createOrder(@RequestBody OrderRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để tạo đơn hàng!"));
        }
        System.out.println("Order Request: " + request);
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
    public ResponseEntity<?> getOrdersByUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để xem đơn hàng!"));
        }
        List<OrderResponse> orders = orderService.getOrdersByUserId(userDetails.getUser().getId());
        return ResponseEntity.ok(orders);
    }

    // Hủy đơn hàng (chỉ được hủy đơn của mình)
    @PutMapping("/{orderId}/cancel")
    public ResponseEntity<ResponseMessage> cancelOrder(
            @PathVariable Long orderId,
            HttpServletRequest request) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Vui lòng đăng nhập để thực hiện!"));
        }

        try {
            // Gọi VNPay refund (giả sử refund toàn phần khi hủy)
            String refundResult = paymentService.handleRefund(orderId, "02", 100, request);

            // Parse JSON kết quả từ VNPay
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(refundResult);
            String responseCode = root.path("vnp_ResponseCode").asText();
            String txnStatus = root.path("vnp_TransactionStatus").asText();
            String paymentStatus = paymentService.getPaymentStatusByOrderId(orderId);
            String paymentMethod = paymentService.getPaymentMethodByOrderId(orderId);
            if (!"SUCCESS".equals(paymentStatus) || paymentStatus == null || "COD".equals(paymentMethod)) {
                orderService.cancelOrder(orderId);
                return ResponseEntity.ok(new ResponseMessage("Đã hủy đơn hàng thành công!"));
            }

            // Nếu refund thành công (ResponseCode = 00 và TransactionStatus = 00)
            if ("00".equals(responseCode) && "05".equals(txnStatus)) {
                orderService.cancelOrder(orderId);
                return ResponseEntity.ok(new ResponseMessage("Đã hủy và hoàn tiền đơn hàng thành công!"));
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ResponseMessage("Hoàn tiền thất bại hoặc chưa xác nhận. Phản hồi: " + refundResult));
            }

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("Lỗi khi xử lý hủy đơn hàng: " + e.getMessage()));
        }
    }

}
