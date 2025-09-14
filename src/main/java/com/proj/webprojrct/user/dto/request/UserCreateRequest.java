package com.proj.webprojrct.user.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserCreateRequest {

    private String role;
    private String fullname;
    private String email;
    private String phone;
}
