package com.proj.webprojrct.customersupport.dto.request;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class CustomerSupportCreateRequest {
    private String customerName;
    private String email;
    private String subject;
    private String message;

}