package com.proj.webprojrct.product.mapper;

import com.proj.webprojrct.product.dto.request.ProductCreateRequest;
import com.proj.webprojrct.product.dto.request.ProductUpdateRequest;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.Product;

public final class ProductMapper {
    private ProductMapper() {}

    public static Product toEntity(ProductCreateRequest r) {
        if (r == null) return null;
        Product p = new Product();
        p.setName(r.getName());
        p.setBrand(r.getBrand());
        p.setDescription(r.getDescription());
        p.setPrice(r.getPrice());
        p.setStock(r.getStock() == null ? 0 : r.getStock());
        return p;
    }

    public static void updateEntity(Product p, ProductUpdateRequest r) {
        if (p == null || r == null) return;
        if (r.getName() != null)        p.setName(r.getName());
        if (r.getBrand() != null)       p.setBrand(r.getBrand());
        if (r.getDescription() != null) p.setDescription(r.getDescription());
        if (r.getPrice() != null)       p.setPrice(r.getPrice());
        if (r.getStock() != null)       p.setStock(r.getStock());
    }

    public static ProductResponse toResponse(Product p) {
        if (p == null) return null;
        return ProductResponse.builder()
            .id(p.getId())
            .name(p.getName())
            .brand(p.getBrand())
            .description(p.getDescription())
            .price(p.getPrice())
            .stock(p.getStock())
            .categoryName(null)
            .createdAt(p.getCreatedAt())
            .build();
    }
}
