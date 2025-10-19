package com.proj.webprojrct.reviewandrating.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.dto.response.ReviewResponse;
import com.proj.webprojrct.reviewandrating.entity.Review;
import com.proj.webprojrct.reviewandrating.mapper.ReviewMapper;
import com.proj.webprojrct.reviewandrating.repository.ReviewRepository;
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
            review.setParentReview(reviewRepository.getReferenceById(dto.getParentReviewId()));
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
        Page<Review> page = reviewRepository.findByProduct_Id(productId, pageable);
        return page.map(reviewMapper::toDto);
    }

    public Optional<ReviewResponse> handleGetReviewThread(Long reviewId) {
        Optional<Review> r = reviewRepository.findById(reviewId);
        return r.map(reviewMapper::toDto);
    }
}
