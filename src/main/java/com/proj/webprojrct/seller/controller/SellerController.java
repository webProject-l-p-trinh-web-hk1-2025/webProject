package com.proj.webprojrct.seller.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.proj.webprojrct.payment.vnpay.service.PaymentService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.proj.webprojrct.order.dto.response.OrderSellerResponse;
import com.proj.webprojrct.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final SellerService sellerService;
    private final PaymentService paymentService;

    @GetMapping("/seller/all-orders")
    public String getAllSellerOrders(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> orderSellerResponse = sellerService.getAllOrders(authentication);

            model.addAttribute("orders", orderSellerResponse);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/all_orders";
    }

    @GetMapping("/seller/orders")
    public String getSellerOrders(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> orderSellerResponse = sellerService.getOrdersBySellerId(authentication);

            model.addAttribute("orders", orderSellerResponse);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders";
    }

    @PostMapping("/seller/accept-order/{orderId}")
    public String postSellerOrders(@PathVariable("orderId") Long orderId, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            if (sellerService.acceptOrder(orderId, authentication)) {
                model.addAttribute("success", "Order accepted successfully.");
            } else {
                model.addAttribute("error", "Failed to accept the order.");
            }

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "redirect:/seller/orders";
    }

    @GetMapping("/seller/orders-refund")
    public String getSellerOrdersRefund(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        try {
            List<OrderSellerResponse> orderSellerResponse = sellerService.getAllOrderRefund(authentication);

            model.addAttribute("orders", orderSellerResponse);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/home";
        }
        return "seller/orders_refund";
    }

    @PostMapping("/seller/orders-refund/{orderId}/process")
    public ResponseEntity<String> processOrderRefund(
            @PathVariable("orderId") Long orderId,
            @RequestParam String trantype,
            @RequestParam int percent,
            Authentication authentication,
            HttpServletRequest request) {

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Vui lòng đăng nhập để thực hiện.");
        }

        try {

            String refundResult = paymentService.handleRefund(orderId, trantype, percent, request);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(refundResult);
            String responseCode = root.path("vnp_ResponseCode").asText();
            String txnStatus = root.path("vnp_TransactionStatus").asText();
            System.out.println("Refund Response Code: " + responseCode);
            System.out.println("Refund Transaction Status: " + txnStatus);
            if ("00".equals(responseCode) && "05".equals(txnStatus)) {
                sellerService.acceptOrderRefund(orderId, authentication);
                return ResponseEntity.ok("Hoàn tiền thành công! API trả về: " + refundResult);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body("Hoàn tiền thất bại hoặc chưa xác nhận. API trả về: " + refundResult);
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi khi xử lý hoàn tiền: " + e.getMessage());
        }
    }

    // @PostMapping("/seller/accept-order-refund/{orderId}")
    // public String postSellerOrdersRefund(@PathVariable("orderId") Long orderId,
    //         @RequestParam String transType,
    //         @RequestParam int percent, Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     if (authentication == null || !authentication.isAuthenticated()) {
    //         return "redirect:/login";
    //     }
    //     try {
    //         if (sellerService.processRefund(orderId, transType, percent, authentication)) {
    //             model.addAttribute("success", "Order refund accepted successfully.");
    //         } else {
    //             model.addAttribute("error", "Failed to accept the order refund.");
    //         }
    //     } catch (IllegalArgumentException e) {
    //         model.addAttribute("error", e.getMessage());
    //         return "redirect:/home";
    //     }
    //     return "redirect:/seller/oders-refund";
    // }
}
