package com.proj.webprojrct.cart.repository;

import com.proj.webprojrct.cart.entity.CartItem;
import com.proj.webprojrct.cart.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCart(Cart cart);
    void deleteByCart(Cart cart);
}