package com.example.webProject.user.dto.response;

import com.example.webProject.user.entity.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.fasterxml.jackson.annotation.JsonProperty;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse {

    private long id;
    @JsonProperty("full_name")
    private String fullName;
    private String email;
    @JsonProperty("avatar_url")
    private String avatarUrl;
    private UserRole role;
    @JsonProperty("is_active")
    private Boolean isActive;
}
