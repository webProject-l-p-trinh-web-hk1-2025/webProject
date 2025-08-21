package com.example.webProject.user.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class UserProfileUpdateRequest {

    @JsonProperty("full_name")
    private String fullName;
}
