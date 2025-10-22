package com.proj.webprojrct.order.service.impl;

import com.proj.webprojrct.payment.entity.Payment;
import com.proj.webprojrct.payment.repository.PaymentRepository;
import com.proj.webprojrct.order.dto.request.OrderRequest;
import com.proj.webprojrct.order.dto.response.OrderResponse;
import com.proj.webprojrct.order.dto.response.OrderItemResponse;
import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.repository.OrderRepository;
import com.proj.webprojrct.order.repository.OrderItemRepository;
import com.proj.webprojrct.order.service.OrderService;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.entity.ProductImage;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.repository.ProductImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductImageRepository productImageRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    public OrderResponse createOrder(Long userId, OrderRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getVerifyPhone()) {
            throw new RuntimeException("Chưa xác thực số điện thoại.");
        }
        Order order = new Order();
        order.setUser(user);
        order.setStatus("PENDING");
        order.setTotalAmount(request.getTotalAmount());
        order.setShippingAddress(user.getAddress());
        order.setCreatedAt(LocalDateTime.now());
        order = orderRepository.save(order);

        final Order savedOrder = order;
        if (request.getOrderItems() != null) {
            for (OrderRequest.OrderItemRequest itemReq : request.getOrderItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(savedOrder);
                orderItem.setProductId(itemReq.getProductId());
                orderItem.setQuantity(itemReq.getQuantity());
                orderItem.setPrice(itemReq.getPrice());
                orderItemRepository.save(orderItem);
            }
        }

        return getOrderById(savedOrder.getId());
    }

    @Override
    public OrderResponse getOrderById(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        List<OrderItem> items = orderItemRepository.findByOrder(order);
        List<OrderItemResponse> itemResponses = items.stream().map(item -> {
            OrderItemResponse resp = new OrderItemResponse();
            resp.setOrderItemId(item.getId());
            resp.setOrderId(item.getOrder().getId());
            resp.setProductId(item.getProductId());
            resp.setQuantity(item.getQuantity());
            resp.setPrice(item.getPrice());

            Product product = productRepository.findById(item.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            resp.setProductName(product.getName());

            List<ProductImage> images = productImageRepository.findByProduct(product);
            if (!images.isEmpty()) {
                resp.setProductImageUrl(images.get(0).getUrl());
            } else {
                resp.setProductImageUrl(null);
            }
            return resp;
        }).collect(Collectors.toList());

        OrderResponse response = new OrderResponse();
        response.setOrderId(order.getId());
        response.setUserId(order.getUser().getId());
        response.setStatus(order.getStatus());
        response.setTotalAmount(order.getTotalAmount());
        response.setShippingAddress(order.getShippingAddress());
        // **Chuyển LocalDateTime sang String đã format**
        response.setCreatedAt(order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        response.setItems(itemResponses);
        return response;
    }

    @Override
    public List<OrderResponse> getOrdersByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<Order> orders = orderRepository.findByUser(user);

        return orders.stream().map(order -> {
            List<OrderItem> items = orderItemRepository.findByOrder(order);
            List<OrderItemResponse> itemResponses = items.stream().map(item -> {
                OrderItemResponse resp = new OrderItemResponse();
                resp.setOrderItemId(item.getId());
                resp.setOrderId(order.getId());
                resp.setProductId(item.getProductId());
                resp.setQuantity(item.getQuantity());
                resp.setPrice(item.getPrice());

                Product product = productRepository.findById(item.getProductId())
                        .orElseThrow(() -> new RuntimeException("Product not found"));
                resp.setProductName(product.getName());

                List<ProductImage> images = productImageRepository.findByProduct(product);
                if (!images.isEmpty()) {
                    resp.setProductImageUrl(images.get(0).getUrl());
                } else {
                    resp.setProductImageUrl(null);
                }
                return resp;
            }).collect(Collectors.toList());

            OrderResponse response = new OrderResponse();
            response.setOrderId(order.getId());
            response.setUserId(userId);
            response.setStatus(order.getStatus());
            response.setTotalAmount(order.getTotalAmount());
            response.setShippingAddress(order.getShippingAddress());
            response.setCreatedAt(order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
            response.setItems(itemResponses);
            return response;
        }).collect(Collectors.toList());
    }

    @Override
    public void cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        order.setStatus("CANCELLED");
        orderRepository.save(order);
    }

    @Override
    public Payment updateOrderPayment(Long orderId) {
        Payment existingPayment = paymentRepository.findByOrderId(orderId);
        if (existingPayment == null) {
            return null;
        }
        return existingPayment;

    }
}
