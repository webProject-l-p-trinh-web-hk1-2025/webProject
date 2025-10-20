package com.proj.webprojrct.user.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.couchbase.CouchbaseProperties;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.mapper.UserMapper;
import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.storage.service.AvatarStorageService;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.entity.UserRole;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.rest.chat.v1.service.UserReader;

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
    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<UserAdminResponse> getAllUsers(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            throw new RuntimeException("Bạn không đủ quyền truy cập.");
        }
        List<User> users = userRepository.findAll();
        return userMapper.toDto(users);
    }

    public UserAdminResponse handleCreateUser(Authentication authentication, UserCreateRequest userCreateRequest) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }
        if (userRepository.existsByPhone(userCreateRequest.getPhone())) {
            throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống.");
        }

        if (userRepository.existsByEmail(userCreateRequest.getEmail())) {
            throw new RuntimeException("Email đã tồn tại trong hệ thống.");
        }
        User newUser = userMapper.toEntity(userCreateRequest);
        newUser.setPasswordHash(passwordEncoder.encode("123"));
        userRepository.save(newUser);
        return userMapper.toAdminResponse(newUser);
    }

    public UserAdminResponse handleUpdateUser(Authentication authentication, UserAdminUpdateRequest updateRequest, long id) {

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User userToUpdate = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user cần cập nhật"));

        userToUpdate.setFullName(updateRequest.getFullname());
        userToUpdate.setEmail(updateRequest.getEmail());
        userToUpdate.setAddress(updateRequest.getAddress());
        userToUpdate.setRole(updateRequest.getRole());

        userRepository.save(userToUpdate);

        return userMapper.toAdminResponse(userToUpdate);
    }

    public void handleDeleteUser(Authentication authentication, long userId) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        String phone = authentication.getName();
        User currUser = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản hiện tại"));

        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User userToDelete = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user cần xóa"));
        userToDelete.setIsActive(false);
        userRepository.save(userToDelete);
    }

    /////////////////////////////////////////////////////////////////////////////////

    public UserResponse handleGetUserProfile(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        return userMapper.toDto(user);
    }

    public UserResponse updateCurrentUserProfile(Authentication authentication, UserUpdateRequest userReq, MultipartFile avt) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User existingUser = userDetails.getUser();

        if (avt != null && !avt.isEmpty()) {
            try (InputStream inputStream = avt.getInputStream()) {
                String savedFileName = avatarStorageService.save(avt.getOriginalFilename(), inputStream);

                String oldAvatar = existingUser.getAvatarUrl();
                if (oldAvatar != null && oldAvatar.startsWith("/uploads/avatars/")) {
                    String oldFileName = oldAvatar.substring("/uploads/avatars/".length());
                    avatarStorageService.delete(oldFileName);
                }
                existingUser.setAvatarUrl("/uploads/avatars/" + savedFileName);
            } catch (IOException e) {
                throw new RuntimeException("Lỗi khi lưu avatar: " + e.getMessage());
            }
        }

        existingUser.setFullName(userReq.getFullname());
        existingUser.setEmail(userReq.getEmail());
        existingUser.setAddress(userReq.getAddress());

        userRepository.save(existingUser);

        return userMapper.toDto(existingUser);
    }

    public UserResponse handleGetUserById(Authentication authentication, Long userId) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new RuntimeException("Bạn chưa đăng nhập.");
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User currUser = userDetails.getUser();
        if (currUser.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Bạn không đủ quyền thực hiện thao tác này.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        return userMapper.toDto(user);
    }
}
