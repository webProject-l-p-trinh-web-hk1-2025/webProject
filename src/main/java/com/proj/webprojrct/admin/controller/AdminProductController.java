package com.proj.webprojrct.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminProductController {

    @GetMapping("/admin/products")
    public String listProducts() {
        return "admin/product_list";
    }

}
