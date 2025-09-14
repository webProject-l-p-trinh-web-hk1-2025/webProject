package com.proj.webprojrct.user.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserRequest {

    private String phone;
    private String password;
    private String confirmPassword;
    private String fullname;
    private String email;
}
