package com.proj.webprojrct.cart.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class CartItemResponse {
    private Long cartItemId;
    private Long cartId;
    private Long productId;
    private Integer quantity;
    
    // Thông tin sản phẩm để hiển thị
    private String productName;
    private Double productPrice;
    private String productImageUrl;
}
