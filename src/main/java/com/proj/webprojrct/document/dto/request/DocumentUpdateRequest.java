package com.proj.webprojrct.document.dto.request;

import jakarta.validation.constraints.Size;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class DocumentUpdateRequest {

    @Size(max = 200, message = "Title must be at most 200 characters")
    private String title;  

    private String content; 
}
