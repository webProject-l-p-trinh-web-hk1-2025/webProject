package com.example.webProject.auth.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class RefreshTokenRequest {

    private String refresh_token;
}
