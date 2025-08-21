package com.example.webProject.user.dto.request;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserDeleteRequest {

    private String email;
}
