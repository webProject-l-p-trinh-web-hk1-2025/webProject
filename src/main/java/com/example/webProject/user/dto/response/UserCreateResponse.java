package com.example.webProject.user.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.webProject.user.entity.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserCreateResponse {

    private long id;
    @JsonProperty("full_name")
    private String fullName;
    private String email;
    private UserRole role;
    @JsonProperty("is_active")
    private Boolean isActive;
    @JsonProperty("avatar_url")
    private String avtUrl;
}
