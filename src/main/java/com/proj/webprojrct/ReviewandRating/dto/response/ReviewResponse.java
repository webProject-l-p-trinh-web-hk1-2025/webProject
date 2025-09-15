package main.java.com.proj.webprojrct.ReviewandRating.dto.response;

import java.time.LocalDateTime;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class ReviewResponse {
    private Long id;
    private String reviewerName;
    private String comment;
    private int rating;
    private LocalDateTime createdAt;
    private String productName;

}
