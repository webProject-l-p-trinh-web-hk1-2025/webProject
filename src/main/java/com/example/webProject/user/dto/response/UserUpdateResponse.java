package com.example.webProject.user.dto.response;

import com.example.webProject.user.entity.UserRole;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserUpdateResponse {

    private Long id;
    private String avatar_url;
    @JsonProperty("full_name")
    private String fullName;
    @JsonProperty("email")
    private String email;
    private UserRole role;
    @JsonProperty("is_active")
    private Boolean isActive;
}
