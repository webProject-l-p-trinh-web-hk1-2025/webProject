package com.proj.webprojrct.cart.dto.request;

import java.math.BigDecimal;

import lombok.Data;

@Data
public class CartRequest {
    private Long productId;
    private Integer quantity;
    private BigDecimal price;
}
