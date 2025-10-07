package com.proj.webprojrct.cart.service.impl;

import com.proj.webprojrct.cart.dto.request.CartRequest;
import com.proj.webprojrct.cart.dto.response.CartResponse;
import com.proj.webprojrct.cart.dto.response.CartItemResponse;
import com.proj.webprojrct.cart.entity.Cart;
import com.proj.webprojrct.cart.entity.CartItem;
import com.proj.webprojrct.cart.repository.CartRepository;
import com.proj.webprojrct.cart.repository.CartItemRepository;
import com.proj.webprojrct.cart.service.CartService;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    public CartResponse getCartByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    newCart.setCreatedAt(LocalDateTime.now());
                    return cartRepository.save(newCart);
                });
        List<CartItem> items = cartItemRepository.findByCart(cart);
        List<CartItemResponse> itemResponses = items.stream().map(item -> {
            CartItemResponse resp = new CartItemResponse();
            resp.setId(item.getId());
            resp.setCartId(item.getCart().getId());
            resp.setProductId(item.getProductId());
            resp.setQuantity(item.getQuantity());
            return resp;
        }).collect(Collectors.toList());

        CartResponse response = new CartResponse();
        response.setId(cart.getId());
        response.setUserId(cart.getUser().getId());
        response.setItems(itemResponses);
        return response;
    }

    @Override
    public void addItemToCart(Long userId, CartRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    newCart.setCreatedAt(LocalDateTime.now());
                    return cartRepository.save(newCart);
                });
        List<CartItem> items = cartItemRepository.findByCart(cart);
        Optional<CartItem> existing = items.stream()
                .filter(i -> i.getProductId().equals(request.getProductId()))
                .findFirst();
        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            cartItemRepository.save(item);
        } else {
            CartItem item = new CartItem();
            item.setCart(cart);
            item.setProductId(request.getProductId());
            item.setQuantity(request.getQuantity());
            cartItemRepository.save(item);
        }
    }

    @Override
    public void removeItemFromCart(Long userId, Long productId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        List<CartItem> items = cartItemRepository.findByCart(cart);
        items.stream()
                .filter(i -> i.getProductId().equals(productId))
                .findFirst()
                .ifPresent(item -> cartItemRepository.deleteById(item.getId()));
    }

    @Override
    public void clearCart(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        cartItemRepository.deleteByCart(cart);
    }
}