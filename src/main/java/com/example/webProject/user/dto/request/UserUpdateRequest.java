package com.example.webProject.user.dto.request;

import com.example.webProject.user.entity.UserRole;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserUpdateRequest {

    @JsonProperty("avatar_url")
    private String avatarUrl;
    @JsonProperty("full_name")
    private String fullName;
    private UserRole role;
}
