package com.example.webProject.user;

import java.util.List;
import java.io.IOException;

import com.example.webProject.user.dto.request.UserCreateRequest;
import com.example.webProject.user.dto.response.UserCreateResponse;
import com.example.webProject.user.dto.request.UserUpdateRequest;
import com.example.webProject.user.dto.request.UserProfileUpdateRequest;
import com.example.webProject.user.dto.request.UserRequest;
import com.example.webProject.user.dto.request.UserUpdateStatusRequest;
import com.example.webProject.user.dto.response.UserUpdateResponse;
import com.example.webProject.user.dto.response.UserResponse;
import com.example.webProject.user.dto.request.UserDeleteRequest;
import com.example.webProject.user.dto.request.UserUpdateMultipartRequest;
import com.example.webProject.user.dto.response.UserDeleteResponse;
import com.example.webProject.user.entity.User;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import org.springframework.security.core.context.SecurityContextHolder;

import com.example.webProject.user.entity.UserRole;

import org.springframework.http.MediaType;

import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
@RequestMapping("/api/v1")
public class UserController {

    private final UserService userService;
    private final UserMapper userMapper;

    @PreAuthorize("hasAnyRole('ADMIN', 'ROOT')")
    @Operation(summary = "Tìm kiếm người dùng", description = "Trả về danh sách người dùng phù hợp với tiêu chí tìm kiếm")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @GetMapping("/users")
    public ResponseEntity<List<UserResponse>> getUsers(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) UserRole role,
            @RequestParam(name = "status", required = false) Boolean isActive) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserRequest userRequest = new UserRequest();
        userRequest.setFullName(name);
        userRequest.setEmail(email);
        userRequest.setRole(role);
        userRequest.setIsActive(isActive);
        List<UserResponse> users = userService.handleUserRequest(userRequest, authentication);
        return ResponseEntity.status(HttpStatus.OK).body(users);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'ROOT')")
    @Operation(summary = "Tạo người dùng mới", description = "Trả về thông tin người dùng sau khi tạo")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @PostMapping("/users")
    public ResponseEntity<UserCreateResponse> createNewUser(@RequestBody UserCreateRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(this.userService.handleUserCreateRequest(request, authentication));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'ROOT')")
    @Operation(summary = "Cập nhật thông tin người dùng", description = "Trả về thông tin người dùng sau khi cập nhật")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @PatchMapping("/users/{id}")
    public ResponseEntity<UserUpdateResponse> updateUser(
            @RequestBody UserUpdateRequest request,
            @PathVariable long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserUpdateResponse response = this.userService.handleUserUpdateRequest(request, id, authentication);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    // @PreAuthorize("hasAnyRole('ADMIN', 'ROOT')")
    // @Operation(summary = "Cập nhật người dùng (multipart)", description = "Cập nhật tên, role, avatar (multipart)")
    // @ApiResponse(responseCode = "200", description = "Thành công")
    // @PatchMapping(value = "/users/{id}/multipart", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    // public ResponseEntity<UserUpdateResponse> updateUserMultipart(
    //         @RequestParam(required = false) String full_name,
    //         @RequestParam(required = false) UserRole role,
    //         @RequestPart(required = false) MultipartFile avatar,
    //         @PathVariable long id) throws IOException {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     UserUpdateMultipartRequest request = new UserUpdateMultipartRequest();
    //     request.setFull_name(full_name);
    //     request.setRole(role);
    //     request.setAvatar(avatar);
    //     UserUpdateResponse response = this.userService.handleUserUpdateMultipartRequest(request, id, authentication);
    //     return ResponseEntity.ok(response);
    // }
    @PreAuthorize("hasAnyRole('ADMIN', 'ROOT')")
    @Operation(summary = "Cập nhật trạng thái người dùng", description = "Trả về thông tin người dùng sau khi cập nhật trạng thái")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @PatchMapping("/users/{id}/status")
    public ResponseEntity<UserUpdateResponse> updateUserStatus(
            @RequestBody UserUpdateStatusRequest request,
            @PathVariable long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserUpdateResponse response = this.userService.handleUserUpdateStatusRequest(request, id, authentication);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PreAuthorize("hasAnyRole('ROOT')")
    @Operation(summary = "Xoá người dùng", description = "Trả về id và thông báo xóa thành công.")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @DeleteMapping("/users/{id}")
    public ResponseEntity<UserDeleteResponse> deleteUser(
            @PathVariable long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDeleteResponse response = this.userService.handleUserDeleteRequest(id, authentication);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Lấy thông tin người dùng hiện tại", description = "Trả về thông tin người dùng hiện tại")
    @ApiResponse(responseCode = "200", description = "Thành công")
    @GetMapping("/users/me")
    public ResponseEntity<UserResponse> UserProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserResponse profile = userService.handleUserProfileRequest(authentication);
        return ResponseEntity.status(HttpStatus.OK).body(profile);
    }

    @ApiResponse(responseCode = "200", description = "Thành công")
    @PatchMapping("/users/me")
    public ResponseEntity<UserResponse> updateUserProfile(
            @RequestBody UserProfileUpdateRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserResponse response = this.userService.handleUserProfileUpdateRequest(request, authentication);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    // @ApiResponse(responseCode = "200", description = "Thành công")
    // @PatchMapping(value = "/users/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    // public ResponseEntity<UserResponse> updateUserAvatar(
    //         @RequestPart(required = false) MultipartFile avatar) throws IOException {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     UserResponse response = this.userService.handleUserAvtUpdateRequest(avatar, authentication);
    //     return ResponseEntity.status(HttpStatus.OK).body(response);
    // }
    // @GetMapping("/user/profile")
    // public ResponseEntity<UserResponse> getUserProfile(Authentication authentication) {
    //     String userName = authentication.getName();
    //     UserResponse profile =userMapper.toResponse(userService.getUserByUserName(userName));
    //     return ResponseEntity.status(HttpStatus.OK).body(profile);
    // }
    // @GetMapping("/users")
    // public ResponseEntity<List<User>> getAllUsers() {
    //     return ResponseEntity.status(HttpStatus.OK).body(this.userService.getAllUsers());
    // }
}
