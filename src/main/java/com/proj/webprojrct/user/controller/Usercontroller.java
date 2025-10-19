package com.proj.webprojrct.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;
import com.proj.webprojrct.user.service.UserService;

import lombok.*;

import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.dto.request.UserUpdateRequest;

@NoArgsConstructor
@Controller
public class Usercontroller {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String getUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            userService.handleGetUserProfile(model);
            return "profile";
        }
        model.addAttribute("error", "bạn chưa đăng nhập.");
        return "direct:/login";
    }

    @GetMapping("/update-profile")
    public String updateUserProfile(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {

            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            userService.handleGetUserProfile(model);
            return "update-profile";
        }

        model.addAttribute("error", "Bạn chưa đăng nhập.");
        return "redirect:/login"; // sửa lại redirect đúng cú pháp
    }

    @PostMapping("/update-profile")
    public String handleUpdateUserProfile(@ModelAttribute UserUpdateRequest userReq,
            @RequestParam("avt") MultipartFile avt,
            Model model) {
        return userService.handleUpdateUserProfile(userReq, avt, model);
    }

}
