package com.proj.webprojrct.document.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class DocumentCreateRequest {

    @NotBlank(message = "Bắt buộc phải có tiêu đề")
    @Size(max = 200, message = "Tiêu đề tối đa 20 chữ")
    private String title;

    private String content;
}
