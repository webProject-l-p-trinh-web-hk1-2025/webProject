package com.proj.webprojrct.category.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.common.config.security.CustomUserDetails;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.user.entity.UserRole;

@Controller
public class CategoryPageController {

    private final CategoryService categoryService;

    public CategoryPageController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/category_list")
    public String list() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "category_list";
    }

    //Đem qua Admin
    // @GetMapping("/admin/categories")
    // public String adminList() {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    //     return "category_list";
    // }
    @GetMapping("/category_detail")
    public String detail(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can create categories.");
        }
        return "admin/category_detail";
    }

    @GetMapping("/admin/categories/new")
    public String createForm(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can create categories.");
        }
        List<CategoryDto> dtos = categoryService.getAll();
        model.addAttribute("category", dtos);

        System.out.println("Debug: Loaded categories for creation form: " + dtos);

        return "admin/category_form";
    }

    @GetMapping("/admin/categories/edit")
    public String edit(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can create categories.");
        }
        List<CategoryDto> dtos = categoryService.getAll();
        model.addAttribute("category", dtos);

        return "admin/category_form";
    }

    @GetMapping("/admin/categories/edit/{id}")
    public String editById(@PathVariable Long id, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();
        if (user.getRole() != UserRole.ADMIN) {
            throw new RuntimeException("Access denied: Only ADMIN users can create categories.");
        }
        CategoryDto dto = categoryService.getById(id);
        model.addAttribute("category", dto);
        List<CategoryDto> dtos = categoryService.getAll();
        model.addAttribute("categorys", dtos);
        return "admin/category_form";
    }
}
