package com.proj.webprojrct.product.dto.request;

import lombok.*;

import java.math.BigDecimal;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ProductCreateRequest {
    private String name;
    private String brand;
    private String description;
    private BigDecimal price;      // tiền tệ
    private Integer stock;
}
