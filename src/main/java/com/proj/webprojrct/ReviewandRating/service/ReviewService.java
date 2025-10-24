package com.proj.webprojrct.ReviewandRating.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.proj.webprojrct.ReviewandRating.dto.request.ReviewRequest;
import com.proj.webprojrct.ReviewandRating.dto.response.ReviewResponse;
import com.proj.webprojrct.ReviewandRating.entity.Review;
import com.proj.webprojrct.ReviewandRating.mapper.ReviewMapper;
import com.proj.webprojrct.ReviewandRating.repository.ReviewRepository;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;

import java.util.Optional;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ReviewMapper reviewMapper;

    @Transactional
    public ReviewResponse handleCreateReview(ReviewRequest dto, Long currentUserId) {
        Review review = reviewMapper.toEntity(dto); //chuyển dto sang entity
        //getReferenceById là hàm mặc định của JPA
        review.setUser(userRepository.getReferenceById(currentUserId));
        review.setProduct(productRepository.getReferenceById(dto.getProductId()));
        if (dto.getParentReviewId() != null) {
            // If replying to a reply, attach this new reply to the top-level parent
            // so all replies to the same top-level review are siblings (same level).
            Review intendedParent = reviewRepository.findById(dto.getParentReviewId()).orElse(null);
            if (intendedParent != null) {
                Review rootParent = intendedParent.getParentReview() != null ? intendedParent.getParentReview() : intendedParent;
                review.setParentReview(rootParent);
            }
        }
        Review saved = reviewRepository.save(review);
        return reviewMapper.toDto(saved);
    }

    /*
    Lấy từng đối tượng review trong trang, 
    sau đó gọi phương thức toDto của reviewMapper 
    và truyền đối tượng review đó vào để tạo thành dto response
     */
    public Page<ReviewResponse> handleGetReviewsByProduct(Long productId, Pageable pageable) {
        // fetch only top-level reviews (parentReview null) so child replies are shown nested only
        Page<Review> page = reviewRepository.findByProduct_IdAndParentReviewIsNull(productId, pageable);
        return page.map(reviewMapper::toDto);
    }

    public Optional<ReviewResponse> handleGetReviewThread(Long reviewId) {
        Optional<Review> r = reviewRepository.findById(reviewId);
        return r.map(reviewMapper::toDto);
    }
}
