package com.proj.webprojrct.auth.dto.request;

import org.springframework.core.annotation.AliasFor;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class RegisterRequest {

    private String phone;
    private String password;
    private String confirmPassword;
    private String fullName;
    private String email;
}
