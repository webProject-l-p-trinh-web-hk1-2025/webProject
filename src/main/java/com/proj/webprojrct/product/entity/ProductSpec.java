package com.proj.webprojrct.product.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "specifications")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductSpec {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "spec_key")
    private String key;

    @Column(name = "spec_value")
    private String value;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;
}
