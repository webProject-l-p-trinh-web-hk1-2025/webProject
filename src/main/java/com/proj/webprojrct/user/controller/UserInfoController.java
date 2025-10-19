package com.proj.webprojrct.user.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import java.util.Map;

@RestController
@RequestMapping("/api") //controller lấy thông tin user
@RequiredArgsConstructor
public class UserInfoController {

    private final UserRepository userRepository;

    @GetMapping("/me")
    public ResponseEntity<?> me(@AuthenticationPrincipal(expression = "username") String principalName) {
        if (principalName == null) {
            return ResponseEntity.ok(Map.of("authenticated", false));
        }

        var userOpt = userRepository.findByPhone(principalName).or(() -> userRepository.findByEmail(principalName));
        if (userOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("authenticated", false));
        }

    User u = userOpt.get();
    return ResponseEntity.ok(Map.of(
        "authenticated", true,
        "id", u.getId(),
        "phone", u.getPhone(),
        "email", u.getEmail(),
        "fullName", u.getFullName(),
        "role", u.getRole() == null ? "USER" : u.getRole().name()
    ));
    }
}
