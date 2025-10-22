package com.proj.webprojrct.user.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.service.UserService;

import lombok.NoArgsConstructor;

import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.dto.response.UserResponse;
import com.proj.webprojrct.user.entity.UserRole;

@NoArgsConstructor
@Controller
public class Usercontroller {

    @Autowired
    private UserService userService;

    // @GetMapping("/admin/users")
    // public String getAllAdminUsers(Model model, Authentication authentication) {
    //     //authentication = SecurityContextHolder.getContext().getAuthentication();
    //     boolean isAdmin = authentication != null && authentication.isAuthenticated()
    //             && authentication.getAuthorities().stream()
    //                     .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    //     if (!isAdmin) {
    //         model.addAttribute("error", "Bạn không đủ quyền truy cập.");
    //         return "redirect:/login";
    //     }
    //     List<UserAdminResponse> users = userService.getAllUsers(authentication);
    //     model.addAttribute("users", users);
    //     return "admin/users";
    // }
    // // @GetMapping("/admin/createUser")
    // // public String showCreateUserForm(Model model) {
    // //     try {
    // //         Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    // //         CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
    // //         User currUser = userDetails.getUser();
    // //         if (currUser.getRole() != UserRole.ADMIN) {
    // //             model.addAttribute("error", "Bạn không đủ quyền tạo user.");
    // //             return "redirect:/admin/users";
    // //         }
    // //         model.addAttribute("user", new UserCreateRequest());
    // //         return "admin/createUser";
    // //     } catch (Exception e) {
    // //         model.addAttribute("error", e.getMessage());
    // //         return "redirect:/admin/users";
    // //     }
    // // }
    // @PostMapping("/admin/createUser")
    // public String handleCreateUser(
    //         @ModelAttribute UserCreateRequest userCreateRequest,
    //         Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     try {
    //         // Gọi service
    //         UserAdminResponse createdUser = userService.handleCreateUser(authentication, userCreateRequest);
    //         model.addAttribute("user", createdUser);
    //         model.addAttribute("success", "Tạo tài khoản thành công: " + createdUser.getPhone());
    //         return "redirect:/admin/users";
    //     } catch (RuntimeException e) {
    //         model.addAttribute("error", e.getMessage());
    //         model.addAttribute("userCreateRequest", userCreateRequest);
    //         List<UserAdminResponse> users = userService.getAllUsers(authentication);
    //         model.addAttribute("users", users);
    //         return "admin/users";
    //     }
    // }
    // // @GetMapping("/admin/updateUser/{id}")
    // // public String showUpdateUserForm(
    // //         @PathVariable("id") Long userId,
    // //         Model model,
    // //         Authentication authentication) {
    // //     try {
    // //         UserResponse userResponse = userService.handleGetUserById(authentication, userId);
    // //         model.addAttribute("user", userResponse);
    // //         return "admin/editUser";
    // //     } catch (RuntimeException e) {
    // //         model.addAttribute("error", e.getMessage());
    // //         return "redirect:/admin/users";
    // //     }
    // // }
    // @PostMapping("/admin/updateUser/{id}")
    // public String handleUpdateUser(
    //         @PathVariable("id") Long userId,
    //         @ModelAttribute UserAdminUpdateRequest updateRequest,
    //         Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     try {
    //         UserAdminResponse updatedUser = userService.handleUpdateUser(authentication, updateRequest, userId);
    //         model.addAttribute("user", updatedUser);
    //         model.addAttribute("success", "Cập nhật user thành công: " + updatedUser.getPhone());
    //         return "redirect:/admin/users";
    //     } catch (RuntimeException e) {
    //         model.addAttribute("error", e.getMessage());
    //         return "admin/users";
    //     }
    // }
    // @PostMapping("/admin/deleteUser/{id}")
    // public String handleDeleteUser(
    //         @PathVariable("id") long userId,
    //         Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     try {
    //         userService.handleDeleteUser(authentication, userId);
    //         model.addAttribute("success", "Xóa user thành công.");
    //     } catch (RuntimeException e) {
    //         model.addAttribute("error", e.getMessage());
    //     }
    //     return "redirect:/admin/users";
    // }
    /////////////////////////////////////////////////////////////////////////////////////////

    @GetMapping("/profile")
    public String getUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        try {
            UserResponse userResponse = userService.handleGetUserProfile(authentication);
            model.addAttribute("user", userResponse);
            // Also provide verification flags to the view (read from authenticated user)
            try {
                CustomUserDetails cud = (CustomUserDetails) authentication.getPrincipal();
                com.proj.webprojrct.user.entity.User u = cud.getUser();
                boolean verifyPhone = u.getVerifyPhone() != null && u.getVerifyPhone();
                boolean verifyEmail = u.getVerifyEmail() != null && u.getVerifyEmail();
                model.addAttribute("verifyPhone", verifyPhone);
                model.addAttribute("verifyEmail", verifyEmail);
            } catch (Exception ignored) {
                model.addAttribute("verifyPhone", false);
                model.addAttribute("verifyEmail", false);
            }
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "profile";
    }

    @GetMapping("/profile/orders")
    public String getProfileOrders(Model model) {
        // reuse existing order list page
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        try {
            // Will be filled by OrderPageController if needed; here just forward to order list JSP
            return "order_list";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "profile";
        }
    }

    @GetMapping("/profile/update")
    public String getProfileUpdate(Model model) {
        // reuse existing update-profile endpoint/view
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        try {
            UserResponse userResponse = userService.handleGetUserProfile(authentication);
            model.addAttribute("user", userResponse);
            return "profile_update";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "profile";
        }
    }

    @GetMapping("/profile/offers")
    public String getProfileOffers(Model model) {
        // simple page listing offers; controller will pass 'offers' if available
        return "profile_offers";
    }

    @GetMapping("/profile-update")
    public String updateUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        try {
            UserResponse userResponse = userService.handleGetUserProfile(authentication);
            model.addAttribute("user", userResponse);
            return "profile_update";
        } catch (RuntimeException e) {
            return "redirect:/login";
        }
    }

    @PostMapping("/profile-update")
    public String handleUpdateUserProfile(
            @ModelAttribute UserUpdateRequest userReq,
            @RequestParam(value = "avt", required = false) MultipartFile avt,
            Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        try {
            UserResponse updatedUser = userService.updateCurrentUserProfile(authentication, userReq, avt);
            model.addAttribute("user", updatedUser);
            return "redirect:/profile";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/profile";
        }
    }
}
