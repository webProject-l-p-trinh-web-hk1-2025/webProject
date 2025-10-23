package com.proj.webprojrct.seller.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.security.core.Authentication;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.order.dto.response.OrderItemResponse;
import com.proj.webprojrct.order.dto.response.OrderSellerResponse;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.proj.webprojrct.user.entity.UserRole;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.entity.ProductImage;
import com.proj.webprojrct.product.repository.ProductImageRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SellerService {

    private final OrderRepository orderRepository;
    private final PaymentRepository paymentRepository;
    private final ProductRepository productRepository;
    private final ProductImageRepository productImageRepository;

    public List<OrderSellerResponse> getAllOrders(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || user.getRole() != UserRole.SELLER) {
            throw new IllegalArgumentException("User is not a seller");
        }
        List<Order> orders = orderRepository.findAll();
        List<OrderSellerResponse> orderResponses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public List<OrderSellerResponse> getOrdersBySellerId(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || user.getRole() != UserRole.SELLER) {
            throw new IllegalArgumentException("User is not a seller");
        }
        List<OrderSellerResponse> orderResponses = new ArrayList<>();
        List<Order> orders = orderRepository.findAll();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());

            // Chỉ lấy đơn đã thanh toán thành công hoặc COD
            if (!"SUCCESS".equalsIgnoreCase(paymentStatus) && !"COD".equalsIgnoreCase(paymentMethod)) {
                continue;
            }

            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public boolean acceptOrder(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || user.getRole() != UserRole.SELLER) {
            throw new IllegalArgumentException("User is not a seller");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        order.setStatus("ACCEPTED");
        orderRepository.save(order);
        return true;
    }

    public List<OrderSellerResponse> getAllOrderRefund(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() == null || user.getRole() != UserRole.SELLER) {
            throw new IllegalArgumentException("User is not a seller");
        }
        List<String> allowedStatuses = Arrays.asList("ACCEPTED", "SHIPPED");
        List<Order> orders = orderRepository.findByStatusIn(allowedStatuses);

        List<OrderSellerResponse> orderResponses = new ArrayList<>();

        for (Order order : orders) {
            if (order == null || order.getId() == null) {
                continue;
            }

            String paymentStatus = getPaymentStatusByOrderId(order.getId());
            String paymentMethod = getPaymentMethodByOrderId(order.getId());
            if (!paymentStatus.equals("SUCCESS")) {
                continue;
            }
            List<OrderItemResponse> orderItemResponses = new ArrayList<>();
            if (order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
                continue;
            }

            for (OrderItem item : order.getOrderItems()) {
                if (item == null) {
                    continue;
                }
                Product product = productRepository.findById(item.getProductId()).orElse(null);
                ProductImage productImage = productImageRepository.findFirstByProductOrderByIdAsc(product).orElse(null);

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
                itemResponse.setProductName(product != null ? product.getName() : "Unknown Product");
                itemResponse.setProductImageUrl(productImage != null ? productImage.getUrl() : null);
                orderItemResponses.add(itemResponse);
            }

            OrderSellerResponse orderSellerResponse = new OrderSellerResponse(
                    order.getId(),
                    order.getUser() != null ? order.getUser().getId() : null,
                    order.getStatus(),
                    paymentStatus,
                    paymentMethod,
                    order.getTotalAmount(),
                    order.getShippingAddress(),
                    order.getCreatedAt() != null ? order.getCreatedAt().toString() : null,
                    orderItemResponses
            );

            orderResponses.add(orderSellerResponse);
        }

        return orderResponses;
    }

    public boolean acceptOrderRefund(Long orderId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        if (user.getRole() == null || user.getRole() != UserRole.SELLER) {
            throw new IllegalArgumentException("User is not a seller");
        }
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        // Logic to process refund based on transType and percent
        order.setStatus("REFUNDED_ACCEPTED");
        orderRepository.save(order);
        return true;
    }

    public String getPaymentStatusByOrderId(Long orderId) {
        Payment p = paymentRepository.findByOrderId(orderId);
        if (p == null) {
            return "UNKNOWN";
        } else {
            return p.getStatus();
        }
    }

    public String getPaymentMethodByOrderId(Long orderId) {
        Payment p = paymentRepository.findByOrderId(orderId);
        if (p == null) {
            return "UNKNOWN";
        }
        return p.getMethod();
    }

}
