package com.proj.webprojrct.product.service;

import com.proj.webprojrct.product.dto.request.ProductCreateRequest;
import com.proj.webprojrct.product.dto.request.ProductUpdateRequest;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import java.util.List;

public interface ProductService {
    ProductResponse create(ProductCreateRequest request);
    ProductResponse update(Long id, ProductUpdateRequest request);
    void delete(Long id);
    ProductResponse getById(Long id);
    List<ProductResponse> getAll();
}
