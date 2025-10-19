package com.proj.webprojrct.product.service;

import com.proj.webprojrct.category.entity.Category;
import com.proj.webprojrct.category.repository.CategoryRepository;
import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.*;
import com.proj.webprojrct.product.mapper.ProductMapper;
import com.proj.webprojrct.product.repository.ProductRepository;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private final ProductRepository repo;
    private final ProductMapper mapper;
    private final CategoryRepository categoryRepo;

    public ProductServiceImpl(ProductRepository repo, ProductMapper mapper, CategoryRepository categoryRepo) {
        this.repo = repo;
        this.mapper = mapper;
        this.categoryRepo = categoryRepo;
    }

    @Override
    public ProductResponse create(ProductCreateRequest req) {
        Product p = mapper.toEntity(req);

        if (req.getCategoryId() != null) {
            Category c = categoryRepo.findById(req.getCategoryId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Danh mục không tồn tại"));
            p.setCategory(c);
        }

        if (req.getSpecs() != null) {
            List<ProductSpec> specs = new ArrayList<>();
            for (var s : req.getSpecs()) {
                specs.add(ProductSpec.builder().key(s.getKey()).value(s.getValue()).product(p).build());
            }
            p.setSpecifications(specs);
        }

        return mapper.toResponse(repo.save(p));
    }

    @Override
    public ProductResponse update(Long id, ProductUpdateRequest req) {
        Product p = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id));

        mapper.updateEntityFromDto(req, p);

        if (req.getCategoryId() != null) {
            Category c = categoryRepo.findById(req.getCategoryId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Danh mục không tồn tại"));
            p.setCategory(c);
        }

        if (req.getSpecs() != null) {
            p.getSpecifications().clear();
            for (var s : req.getSpecs()) {
                p.getSpecifications().add(ProductSpec.builder().key(s.getKey()).value(s.getValue()).product(p).build());
            }
        }

        return mapper.toResponse(repo.save(p));
    }

    @Override
    public void delete(Long id) {
        if (!repo.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id);
        repo.deleteById(id);
    }

    @Override
    public ProductResponse getById(Long id) {
        return mapper.toResponse(repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id)));
    }

    @Override
    public List<ProductResponse> getAll() {
        return mapper.toResponseList(repo.findAll(Sort.by(Sort.Direction.DESC, "createdAt")));
    }

    @Override
    public Page<ProductResponse> search(String brand, BigDecimal minPrice, BigDecimal maxPrice, int page, int size, String sort) {
        String[] parts = sort.split(",");
        Sort s = parts.length == 2 ? Sort.by(Sort.Direction.fromString(parts[1]), parts[0]) : Sort.by(Sort.Direction.DESC, "createdAt");
        Pageable pageable = PageRequest.of(page, size, s);

        Specification<Product> spec = (root, cq, cb) -> cb.conjunction();
        if (brand != null && !brand.isBlank()) spec = spec.and((r, cq2, cb2) -> cb2.like(cb2.lower(r.get("brand")), "%" + brand.toLowerCase() + "%"));
        if (minPrice != null) spec = spec.and((r, cq2, cb2) -> cb2.greaterThanOrEqualTo(r.get("price"), minPrice));
        if (maxPrice != null) spec = spec.and((r, cq2, cb2) -> cb2.lessThanOrEqualTo(r.get("price"), maxPrice));

        return repo.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override
    public String uploadImage(Long id, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty())
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ảnh không hợp lệ");

        Product p = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm #" + id));

        // Use an absolute upload directory under the application working directory to avoid
        // relying on the servlet container working directory. Ensure parent directories exist.
        File dir = new File(System.getProperty("user.dir"), "uploads/products");
        if (!dir.exists()) {
            if (!dir.mkdirs()) {
                throw new IOException("Không thể tạo thư mục upload: " + dir.getAbsolutePath());
            }
        }

        String original = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String ext = "";
        int idx = original.lastIndexOf('.');
        if (idx >= 0) ext = original.substring(idx);
        String filename = id + "_" + System.currentTimeMillis() + ext;
        File dest = new File(dir, filename);

        // Copy the stream instead of transferTo to avoid issues when temp files are on a
        // different filesystem or when security policies prevent rename.
        try (InputStream in = file.getInputStream()) {
            Files.copy(in, dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        p.setImageUrl("/uploads/products/" + filename);
        repo.save(p);
        return p.getImageUrl();
    }
}
