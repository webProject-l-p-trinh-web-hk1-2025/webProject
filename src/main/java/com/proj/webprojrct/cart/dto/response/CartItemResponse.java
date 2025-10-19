package com.proj.webprojrct.cart.dto.response;

import lombok.Data;

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
}
