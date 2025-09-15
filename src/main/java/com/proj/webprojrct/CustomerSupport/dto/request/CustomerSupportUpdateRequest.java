package main.java.com.proj.webprojrct.CustomerSupport.dto.request;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class CustomerSupportUpdateRequest {
     private Long id;
    private String subject;
    private String message;
}
