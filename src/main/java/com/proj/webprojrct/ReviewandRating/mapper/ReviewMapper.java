package com.proj.webprojrct.reviewandrating.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import com.proj.webprojrct.reviewandrating.dto.request.ReviewRequest;
import com.proj.webprojrct.reviewandrating.dto.response.ReviewResponse;
import com.proj.webprojrct.reviewandrating.entity.Review;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;



@Mapper(componentModel = "spring")
public interface ReviewMapper {

    //ignore để bỏ qua các trường dữ liệu mà không phải người dùng nhập
    //các dữ liệu này được lấy từ auth hoặc trả về product id để tìm product gán cho một review
    @Mapping(target = "reviewId", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "product", ignore = true)
    @Mapping(target = "parentReview", ignore = true)
    @Mapping(target = "childReviews", ignore = true)
    public Review toEntity(ReviewRequest review);

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "productId", source = "product.id")
    @Mapping(target = "parentReviewId", source = "parentReview.reviewId")
    @Mapping(target = "childReviews", source = "childReviews")
    public ReviewResponse toDto(Review review);

    //chuyển từ set thành list để đảm bảo yêu cầu cho review response và để giữ thứ tự reply
    //set chỉ đảm bảo không có 2 review id con trùng id chứ không đảm bảo thứ tự
    default List<ReviewResponse> mapChildReviews(Set<Review> children) {
        if (children == null) return null;
        return children.stream().map(this::toDto).collect(Collectors.toList());
    }


   
}