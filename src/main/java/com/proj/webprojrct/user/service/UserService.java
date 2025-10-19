package com.proj.webprojrct.user.service;

import java.io.IOException;
import java.io.InputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.mapper.UserMapper;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.storage.service.AvatarStorageService;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Service
public class UserService {

    @Autowired
    private AvatarStorageService avatarStorageService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserMapper userMapper;

    public void handleGetUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            User user = userDetails.getUser();
            System.out.println("User in service: " + user.getAvatarUrl());
            UserResponse userResponse = userMapper.toDto(user);
            model.addAttribute("user", userResponse);
        }

    }

    public String handleUpdateUserProfile(UserUpdateRequest userReq,
            MultipartFile avt,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {

            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            User existingUser = userDetails.getUser();

            if (avt != null && !avt.isEmpty()) {
                try (InputStream inputStream = avt.getInputStream()) {
                    String savedFileName = avatarStorageService.save(avt.getOriginalFilename(), inputStream);

                    String oldAvatar = existingUser.getAvatarUrl();
                    if (oldAvatar != null && !oldAvatar.isEmpty()) {
                        if (oldAvatar.startsWith("/uploads/avatars/")) {
                            String oldFileName = oldAvatar.substring("/uploads/avatars/".length());
                            avatarStorageService.delete(oldFileName);
                        }
                    }

                    existingUser.setAvatarUrl("/uploads/avatars/" + savedFileName);
                } catch (IOException e) {
                    model.addAttribute("error", "Lỗi khi lưu avatar: " + e.getMessage());
                    return "profile";
                }
            }

            existingUser.setFullName(userReq.getFullname());
            existingUser.setEmail(userReq.getEmail());
            existingUser.setAddress(userReq.getAddress());

            userRepository.save(existingUser);

            model.addAttribute("success", "Cập nhật thông tin thành công.");
            return "redirect:/profile";
        }

        model.addAttribute("error", "Bạn chưa đăng nhập.");
        return "redirect:/login";
    }
}
