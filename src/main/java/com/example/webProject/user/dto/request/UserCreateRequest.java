package com.example.webProject.user.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.webProject.user.entity.UserRole;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserCreateRequest {

    @NotBlank(message = "First name is required")
    private String email;
    @JsonProperty("full_name")
    @NotBlank(message = "Last name is required")
    private String fullName;
    @NotBlank(message = "Email is required")
    @JsonProperty("password_hash")
    private String passwordHash;
    @NotBlank(message = "Role is required")
    private UserRole role;
    @JsonProperty("is_active")
    private Boolean isActive = true;
}
