package com.proj.webprojrct.reviewandrating.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.reviewandrating.entity.Review;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    Page<Review> findByProduct_Id(Long productId, Pageable pageable);
}
