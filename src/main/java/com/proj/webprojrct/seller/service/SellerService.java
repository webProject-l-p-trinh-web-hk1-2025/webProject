package com.proj.webprojrct.seller.service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.dto.response.OrderItemResponse;
import com.proj.webprojrct.order.dto.response.OrderSellerResponse;
import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SellerService {

    private final OrderRepository orderRepository;
    private final PaymentRepository paymentRepository;

    public List<OrderSellerResponse> getOrdersBySellerId() {
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

                OrderItemResponse itemResponse = new OrderItemResponse();
                itemResponse.setOrderItemId(item.getId());
                itemResponse.setOrderId(order.getId());
                itemResponse.setProductId(item.getProductId());
                itemResponse.setQuantity(item.getQuantity());
                itemResponse.setPrice(item.getPrice());
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

    public boolean acceptOrder(Long orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            throw new IllegalArgumentException("Order not found with id: " + orderId);
        }
        order.setStatus("ACCEPTED");
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
