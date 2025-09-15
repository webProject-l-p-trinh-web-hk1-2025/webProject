package main.java.com.proj.webprojrct.ReviewandRating.dto.request;
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

