package com.proj.webprojrct.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    @GetMapping
    public String index() {
        // return the JSP view for admin categories
        return "category_list";
    }
}
