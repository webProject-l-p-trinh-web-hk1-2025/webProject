package com.proj.webprojrct.user.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserUpdateRequest {

    private String fullname;
    private String email;
    private String avatarUrl;
}
