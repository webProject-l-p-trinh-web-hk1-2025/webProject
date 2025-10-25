package com.proj.webprojrct.category.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.category.entity.Category;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByName(String name);
    
    // Phân trang với tìm kiếm theo tên
    Page<Category> findByNameContainingIgnoreCase(String name, Pageable pageable);
}
