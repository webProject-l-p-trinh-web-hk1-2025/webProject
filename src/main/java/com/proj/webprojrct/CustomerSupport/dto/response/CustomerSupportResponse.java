package main.java.com.proj.webprojrct.CustomerSupport.dto.response;

import java.time.LocalDateTime;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class CustomerSupportResponse {
    private Long id;
    private String customerName;
    private String email;
    private String subject;
    private String message;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
  
}
