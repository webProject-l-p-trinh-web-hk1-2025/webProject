package com.proj.webprojrct.ReviewandRating.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.proj.webprojrct.ReviewandRating.entity.Review;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    // only fetch top-level reviews (parentReview is null) for product listing
    Page<Review> findByProduct_IdAndParentReviewIsNull(Long productId, Pageable pageable);
}
