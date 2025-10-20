package com.proj.webprojrct.product.controller;

import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping(value = "/api/products", produces = MediaType.APPLICATION_JSON_VALUE)
public class ProductController {

    private final ProductService service;

    public ProductController(ProductService service) { this.service = service; }

    /* Tạo mới */
    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse create(@Valid @RequestBody ProductCreateRequest req) {
        return service.create(req);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse createMultipart(
            @Valid @RequestPart("data") ProductCreateRequest req,
            @RequestPart(value = "image", required = false) MultipartFile image
    ) {
        try {
            ProductResponse res = service.create(req);
            if (image != null && !image.isEmpty()) {
                service.uploadImage(res.getId(), image);
                res = service.getById(res.getId());
            }
            return res;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    /* Xem tổng */
    @GetMapping public List<ProductResponse> getAll() { return service.getAll(); }

    @GetMapping("/{id}") public ProductResponse getById(@PathVariable Long id) { return service.getById(id); }

    @GetMapping("/search")
    public Page<ProductResponse> search(@RequestParam(required = false) String brand,
                                        @RequestParam(required = false) String name,
                                        @RequestParam(required = false) BigDecimal minPrice,
                                        @RequestParam(required = false) BigDecimal maxPrice,
                                        @RequestParam(defaultValue = "0") int page,
                                        @RequestParam(defaultValue = "20") int size,
                                        @RequestParam(defaultValue = "createdAt,desc") String sort) {
        return service.search(brand, name, minPrice, maxPrice, page, size, sort);
    }

    @GetMapping("/brands")
    public List<String> getBrands() {
        return service.getAllBrands();
    }

    @GetMapping("/suggest")
    public List<String> suggestNames(@RequestParam("q") String q, @RequestParam(value = "limit", defaultValue = "10") int limit) {
        return service.suggestNames(q, limit);
    }

    /* Cập nhật */
    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ProductResponse update(@PathVariable Long id,
                                  @Valid @RequestPart("data") ProductUpdateRequest req,
                                  @RequestPart(value = "image", required = false) MultipartFile image) {
        try {
            ProductResponse res = service.update(id, req);
            if (image != null && !image.isEmpty()) {
                service.uploadImage(id, image);
                res = service.getById(id);
            }
            return res;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    /* Xóa */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    /* Upload ảnh riêng */
    @PostMapping("/{id}/image")
    public ResponseEntity<ProductResponse> uploadImage(@PathVariable Long id, @RequestParam("image") MultipartFile file) {
        try {
            service.uploadImage(id, file);
            return ResponseEntity.ok(service.getById(id));
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }
    
    /** Upload multiple images in one request. This appends images to the product. */
    @PostMapping("/{id}/images")
    public ResponseEntity<ProductResponse> uploadImages(@PathVariable Long id, @RequestParam("images") MultipartFile[] files) {
        try {
            if (files != null) {
                for (MultipartFile f : files) {
                    if (f != null && !f.isEmpty()) service.uploadImage(id, f);
                }
            }
            return ResponseEntity.ok(service.getById(id));
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi tải ảnh: " + e.getMessage());
        }
    }

    @DeleteMapping("/images/{id}")
    public ResponseEntity<Void> deleteImage(@PathVariable("id") Long id) {
        try {
            service.deleteImage(id);
            return ResponseEntity.noContent().build();
        } catch (IOException e) {
            throw new org.springframework.web.server.ResponseStatusException(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi xóa ảnh: " + e.getMessage());
        }
    }
}
