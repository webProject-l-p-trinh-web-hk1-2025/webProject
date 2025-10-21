package com.proj.webprojrct.category.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.category.dto.CategoryDto;

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

    @GetMapping("/admin/categories")
    public String adminList() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "category_list";
    }

    @GetMapping("/category_detail")
    public String detail(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "category_detail";
    }

    @GetMapping("/admin/categories/new")
    public String createForm() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "category_form";
    }

    @GetMapping("/admin/categories/edit")
    public String edit() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return "category_form";
    }

    @GetMapping("/admin/categories/edit/{id}")
    public String editById(@PathVariable Long id, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CategoryDto dto = categoryService.getById(id);
        model.addAttribute("category", dto);
        return "category_form";
    }
}
