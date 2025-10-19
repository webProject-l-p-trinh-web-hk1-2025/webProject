package com.proj.webprojrct.category.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.category.entity.Category;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByName(String name);
}
