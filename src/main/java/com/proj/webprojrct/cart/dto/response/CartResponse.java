package com.proj.webprojrct.cart.dto.response;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CartResponse {
    private Long cartId;
    private Long userId;
    private LocalDateTime createdAt;
    private List<CartItemResponse> items;  
}
