package com.example.webProject.user;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

import com.example.webProject.common.error.Common;
import com.example.webProject.common.exception.EmailAlreadyExistsException;
import com.example.webProject.common.exception.EntityNotExistException;
import com.example.webProject.common.exception.PermissionDeny;
// import com.example.webProject.storage.service.AvatarStorageService;
import com.example.webProject.user.dto.request.UserCreateRequest;
import com.example.webProject.user.dto.request.UserProfileUpdateRequest;
import com.example.webProject.user.dto.request.UserRequest;
import com.example.webProject.user.dto.request.UserUpdateRequest;
import com.example.webProject.user.dto.response.UserUpdateResponse;
import com.example.webProject.user.dto.response.UserCreateResponse;
import com.example.webProject.user.dto.request.UserDeleteRequest;
import com.example.webProject.user.dto.response.UserDeleteResponse;
import com.example.webProject.user.dto.response.UserResponse;
import com.example.webProject.user.entity.User;
import com.example.webProject.user.entity.UserToken;
import com.example.webProject.user.repository.UserRepository;
import com.example.webProject.user.repository.UserTokenRepository;
import com.example.webProject.user.exception.*;

import org.springframework.security.authentication.AnonymousAuthenticationToken;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.webProject.user.dto.request.UserUpdateMultipartRequest;
import com.example.webProject.user.dto.request.UserUpdateStatusRequest;
import com.example.webProject.user.entity.UserRole;

import org.springframework.web.server.ResponseStatusException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Path;
import java.nio.file.Paths;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserService {

    UserMapper userMapper;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserTokenRepository userTokenRepository;

    public List<UserResponse> handleUserRequest(UserRequest userRequest, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }
        // User whom trying to search users.
        String userEmail = authentication.getName();
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
        if (user.getIsActive() == false) {
            throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
        }
        if (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.ROOT) {
            throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
        }

        String nameFilter = StringUtils.removeAccents(userRequest.getFullName());

        List<User> users = this.userRepository.findAll();

        List<User> filteredUsers = users.stream()
                .filter(u -> {
                    boolean matches = true;

                    if (nameFilter != null) {
                        String fullName = StringUtils.removeAccents(u.getFullName());
                        matches &= fullName.contains(nameFilter);
                    }

                    if (userRequest.getEmail() != null) {
                        matches &= u.getEmail() == userRequest.getEmail();
                    }

                    if (userRequest.getRole() != null) {
                        matches &= u.getRole() == userRequest.getRole();
                    }

                    if (userRequest.getIsActive() != null) {
                        matches &= u.getIsActive().equals(userRequest.getIsActive());
                    }

                    return matches;
                })
                .toList();
        if (filteredUsers.isEmpty()) {
            throw new EntityNotExistException(Common.USER_NOT_FOUND);
        }
        return userMapper.toResponse(filteredUsers);
    }

    public UserCreateResponse handleUserCreateRequest(UserCreateRequest request, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }
        String currentEmail = authentication.getName(); // lấy email người dùng hiện tại

        User user = userRepository.findByEmail(currentEmail)
                .orElseThrow(() -> new EmailAlreadyExistsException(Common.USER_NOT_FOUND));
        if (user.getIsActive() == false) {
            throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
        }

        //check if the email is valid    
        if (!isValidEmail(request.getEmail())) {
            throw new InvalidEmailFormatException("Email không hợp lệ");
        }

        //Check if the user has permission to create a new user
        if (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.ROOT) {
            throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
        }
        if (user.getRole().compareTo(request.getRole()) >= 0) {
            throw new PermissionDeny("Bạn không có quyền tạo người dùng với role cao hơn bạn.");
        }
        //check email already exists
        if (this.userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException("Email đã tồn tại");
        }

        User userToSave = userMapper.toEntity(request);

        //add path for avatar
        if (userToSave.getAvatarUrl() == null || userToSave.getAvatarUrl().isEmpty()) {
            userToSave.setAvatarUrl("uploads/avatars/defaultAvt.jpg");
        }

        userToSave.setPasswordHash(passwordEncoder.encode(userToSave.getPasswordHash()));
        this.userRepository.save(userToSave);

        return userMapper.toCreatResponse(userToSave);
    }

    public UserUpdateResponse handleUserUpdateRequest(UserUpdateRequest request, long id, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }
        String currentEmail = authentication.getName();
        User userCurr = userRepository.findByEmail(currentEmail)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        if (userCurr.getIsActive() == false) {
            throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
        }
        // Check if the user has permission to update
        if (userCurr.getRole() != UserRole.ADMIN && userCurr.getRole() != UserRole.ROOT) {
            throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
        }

        User user = this.userRepository.findById(id)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        if (userCurr.getRole().compareTo(user.getRole()) >= 0) {
            throw new PermissionDeny("Bạn không có quyền cập nhật người dùng với role cao hơn bạn.");
        }

        // Update user fields
        if (request.getAvatarUrl() != null) {
            user.setAvatarUrl(request.getAvatarUrl());
        }
        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }
        if (request.getRole() != null) {
            user.setRole(request.getRole());
        }

        User updatedUser = this.userRepository.save(user);
        return userMapper.toUpdateResponse(updatedUser);
    }

    // public UserUpdateResponse handleUserUpdateMultipartRequest(UserUpdateMultipartRequest request, long id, Authentication authentication) throws IOException {
    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
    //     }
    //     String currentEmail = authentication.getName();
    //     User userCurr = userRepository.findByEmail(currentEmail)
    //             .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
    //     if (userCurr.getIsActive() == false) {
    //         throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
    //     }
    //     // Check if the user has permission to update
    //     if (userCurr.getRole() != UserRole.ADMIN && userCurr.getRole() != UserRole.ROOT) {
    //         throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
    //     }
    //     User user = this.userRepository.findById(id)
    //             .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
    //     // Update user fields
    //     if (request.getFull_name() != null) {
    //         user.setFullName(request.getFull_name());
    //     }
    //     if (request.getRole() != null) {
    //         user.setRole(request.getRole());
    //     }
    //     if (request.getAvatar() != null && !request.getAvatar().isEmpty()) {
    //         AvatarStorageService avatarStorageService = new AvatarStorageService(Paths.get("uploads/avatars"));
    //         try {
    //             String originalFilename = Paths.get(request.getAvatar().getOriginalFilename()).getFileName().toString();
    //             String savedFilename = avatarStorageService.save(originalFilename, request.getAvatar().getInputStream());
    //             String avatarUrl = "/uploads/avatars/" + savedFilename; // Nếu client sẽ gọi API này
    //             user.setAvatarUrl(avatarUrl);
    //         } catch (IOException e) {
    //             throw new RuntimeException("Lỗi khi lưu file avatar: " + e.getMessage(), e);
    //         }
    //     }
    //     User updatedUser = this.userRepository.save(user);
    //     return userMapper.toUpdateResponse(updatedUser);
    // }
    public UserUpdateResponse handleUserUpdateStatusRequest(UserUpdateStatusRequest request, long id, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }
        String currentEmail = authentication.getName();
        // Check if the user has permission to update status
        User currentUser = userRepository.findByEmail(currentEmail)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
        if (currentUser.getIsActive() == false) {
            throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
        }
        if (currentUser.getRole() != UserRole.ADMIN && currentUser.getRole() != UserRole.ROOT) {
            throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
        }

        User user = this.userRepository.findById(id)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        user.setIsActive(request.getIsActive());
        User updatedUser = this.userRepository.save(user);
        return userMapper.toUpdateResponse(updatedUser);
    }

    public UserDeleteResponse handleUserDeleteRequest(long id, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }
        String currentEmail = authentication.getName();
        // Check if the user has permission to delete
        User currentUser = userRepository.findByEmail(currentEmail)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
        if (currentUser.getIsActive() == false) {
            throw new PermissionDeny("Tài khoản của bạn đã bị khóa.");
        }
        if (currentUser.getRole() != UserRole.ROOT) {
            throw new PermissionDeny("Bạn không có quyền truy cập vào chức năng này.");
        }
        User user = this.userRepository.findById(id)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        if (currentUser.getRole().compareTo(user.getRole()) > 0) {
            throw new PermissionDeny("Bạn không có quyền xóa người dùng này.");
        }
        user.setIsActive(false);
        this.userRepository.save(user);
        //this.userRepository.delete(user);
        return new UserDeleteResponse("User deleted successfully");
    }

    public UserResponse handleUserProfileRequest(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }

        String userName = authentication.getName();
        User user = userRepository.findByEmail(userName)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
        return userMapper.toResponse(user);
    }

    public UserResponse handleUserProfileUpdateRequest(UserProfileUpdateRequest request, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
        }

        String userName = authentication.getName();
        User user = userRepository.findByEmail(userName)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        // Update user fields
        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }

        User updatedUser = this.userRepository.save(user);
        return userMapper.toResponse(updatedUser);
    }

    // public UserResponse handleUserAvtUpdateRequest(MultipartFile avatar, Authentication authentication) throws IOException {
    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new UnauthenticatedException("Bạn chưa đăng nhập, đăng nhập để tiếp tục.");
    //     }
    //     String userName = authentication.getName();
    //     User user = userRepository.findByEmail(userName)
    //             .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
    //     // Update avatar
    //     if (avatar != null && !avatar.isEmpty()) {
    //         AvatarStorageService avatarStorageService = new AvatarStorageService(Paths.get("uploads/avatars"));
    //         try {
    //             String originalFilename = Paths.get(avatar.getOriginalFilename()).getFileName().toString();
    //             String savedFilename = avatarStorageService.save(originalFilename, avatar.getInputStream());
    //             String avatarUrl = "/uploads/avatars/" + savedFilename; // Nếu client sẽ gọi API này
    //             //avatarStorageService.delete(user.getAvatarUrl()); // Xóa avatar cũ nếu có
    //             user.setAvatarUrl(avatarUrl);
    //         } catch (IOException e) {
    //             throw new RuntimeException("Lỗi khi lưu file avatar: " + e.getMessage(), e);
    //         }
    //     }
    //     User updatedUser = this.userRepository.save(user);
    //     return userMapper.toResponse(updatedUser);
    // }
    public UserCreateResponse createNewUser(UserCreateRequest request) {
        if (this.userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException(Common.USER_ALREADY_EXIST);
        }

        // User whom trying to creat another user.
        User user = userRepository.findByEmail(getCurrentUserEmail())
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));

        User userToSave = userMapper.toEntity(request);
        //If user have enough permission
        if (user.getRole().compareTo(request.getRole()) >= 0) {
            throw new PermissionDeny(Common.ACCESS_DENY);
        }

        // Hash password before save into dtb
        userToSave.setPasswordHash(passwordEncoder.encode(userToSave.getPassword()));

        this.userRepository.save(userToSave);
        return userMapper.toCreatResponse(userToSave);
    }

    public void logOut(Authentication authentication) {
        this.userRepository.clearRefreshToken(authentication.getName());
    }

    public List<User> getAllUsers() {
        if (this.userRepository.count() == 0) {
            throw new EntityNotExistException(Common.USER_NOT_FOUND);
        }
        List<User> users = this.userRepository.findAll();
        return users;
    }

    public User getUserByUserName(String username) {
        return this.userRepository.findByEmail(username)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id)
                .orElseThrow(() -> new EntityNotExistException(Common.USER_NOT_FOUND));
    }

    public User updateUser(User user) {
        return this.userRepository.save(user);
    }

    public User getUserByRefreshToken(String refresh_token) {
        return this.userRepository.findByRefreshToken(refresh_token)
                .orElseThrow(() -> new EntityNotExistException(Common.REFRESH_TOKEN_NOT_FOUND));
    }

    //Get curren user whom requesting
    protected String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    public UserToken creatToken(UserToken token) {
        return this.userTokenRepository.save(token);
    }

    public boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email.matches(emailRegex);
    }

}
