package com.proj.webprojrct.reviewandrating.dto.request;
import lombok.*;
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ReviewCreateRequest {
    
    private String reviewerName;
    private String comment;
    private int rating;
    private Long productId;
   
}

