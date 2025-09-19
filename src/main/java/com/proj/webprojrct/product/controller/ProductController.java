package com.proj.webprojrct.product.controller;

import com.proj.webprojrct.product.dto.request.ProductCreateRequest;
import com.proj.webprojrct.product.dto.request.ProductUpdateRequest;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.mapper.ProductMapper;
import com.proj.webprojrct.product.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping(value = "/api/products", produces = MediaType.APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class ProductController {

    private final ProductRepository productRepository;

    /* ---------- CRUD ---------- */
    @PostMapping
    public ResponseEntity<ProductResponse> create(@RequestBody ProductCreateRequest req) {
        Product p = ProductMapper.toEntity(req);
        p = productRepository.save(p);
        return ResponseEntity.status(HttpStatus.CREATED).body(ProductMapper.toResponse(p));
    }

    @PutMapping("/{id}")
    public ProductResponse update(@PathVariable Long id, @RequestBody ProductUpdateRequest req) {
        Product p = productRepository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
        ProductMapper.updateEntity(p, req);
        return ProductMapper.toResponse(productRepository.save(p));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!productRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found");
        }
        productRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ProductResponse getById(@PathVariable Long id) {
        Product p = productRepository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
        return ProductMapper.toResponse(p);
    }

    @GetMapping
    public List<ProductResponse> getAll() {
        return productRepository.findAll().stream().map(ProductMapper::toResponse).toList();
    }

    /* ---------- Search + Paging + Sort ----------*/
    @GetMapping("/search")
    public Page<ProductResponse> search(
        @RequestParam(required = false) String q,
        @RequestParam(required = false) BigDecimal minPrice,
        @RequestParam(required = false) BigDecimal maxPrice,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "12") int size,
        @RequestParam(defaultValue = "createdAt,desc") String sort
    ) {
        Sort s = parseSort(sort, "createdAt");
        Pageable pageable = PageRequest.of(page, size, s);

        Specification<Product> spec = Specification.where((root, cq, cb) -> cb.conjunction());
        if (q != null && !q.isBlank()) {
            String like = "%" + q.toLowerCase() + "%";
            spec = spec.and((root, cq, cb) ->
                cb.or(
                    cb.like(cb.lower(root.get("name")), like),
                    cb.like(cb.lower(root.get("brand")), like)
                )
            );
        }
        if (minPrice != null) spec = spec.and((r, cq, cb) -> cb.greaterThanOrEqualTo(r.get("price"), minPrice));
        if (maxPrice != null) spec = spec.and((r, cq, cb) -> cb.lessThanOrEqualTo(r.get("price"), maxPrice));

        return productRepository.findAll(spec, pageable).map(ProductMapper::toResponse);
    }

    private Sort parseSort(String sort, String defaultProp) {
        String[] parts = sort.split(",");
        return (parts.length == 2)
            ? Sort.by(Sort.Direction.fromString(parts[1]), parts[0])
            : Sort.by(Sort.Direction.DESC, defaultProp);
    }
}
