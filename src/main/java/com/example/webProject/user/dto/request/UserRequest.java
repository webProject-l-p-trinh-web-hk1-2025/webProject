package com.example.webProject.user.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.webProject.user.entity.UserRole;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserRequest {

    @JsonProperty("full_name")
    private String fullName;
    private String email;
    private UserRole role;
    @JsonProperty("is_active")
    private Boolean isActive;
}
