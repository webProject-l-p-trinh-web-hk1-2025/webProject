package com.proj.webprojrct.order.dto.request;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderRequest {

    private Long productId;
    private Integer quantity;
    private BigDecimal price;
}
