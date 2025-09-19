package com.proj.webprojrct.cart.dto.response;

import lombok.Data;

@Data
public class CartItemResponse {
    private Long id;
    private Long cartId;
    private Long productId;
    private Integer quantity;
}
