package com.proj.webprojrct.cart.dto.request;

import lombok.Data;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class CartRequest {
    private Long productId;
    private Integer quantity;
}
