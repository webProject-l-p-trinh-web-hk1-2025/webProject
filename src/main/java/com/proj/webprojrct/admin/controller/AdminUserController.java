package com.proj.webprojrct.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.proj.webprojrct.user.dto.request.UserCreateRequest;
import com.proj.webprojrct.user.dto.request.UserAdminUpdateRequest;
import com.proj.webprojrct.user.dto.response.UserAdminResponse;
import com.proj.webprojrct.user.service.UserService;

@Controller
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping("/admin/users")
    public String getAllAdminUsers(Model model, Authentication authentication) {
        try {
            List<UserAdminResponse> users = userService.getAllUsers(authentication);
            model.addAttribute("users", users);
            return "admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/users";
        }
    }

    @PostMapping("/admin/createUser")
    public String handleCreateUser(@ModelAttribute UserCreateRequest userCreateRequest,
            Model model, Authentication authentication) {
        try {
            userService.handleCreateUser(authentication, userCreateRequest);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            // reload users to show the page
            try {
                model.addAttribute("users", userService.getAllUsers(authentication));
            } catch (Exception ex) {
                // ignore
            }
            return "admin/users";
        }
    }

    @PostMapping("/admin/updateUser/{id}")
    public String handleUpdateUser(@PathVariable("id") Long userId,
            @ModelAttribute UserAdminUpdateRequest updateRequest,
            Model model, Authentication authentication) {
        try {
            userService.handleUpdateUser(authentication, updateRequest, userId);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/users";
        }
    }

    @PostMapping("/admin/deleteUser/{id}")
    public String handleDeleteUser(@PathVariable("id") long userId,
            Model model, Authentication authentication) {
        try {
            userService.handleDeleteUser(authentication, userId);
            return "redirect:/admin/users";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/admin/users";
        }
    }
}
