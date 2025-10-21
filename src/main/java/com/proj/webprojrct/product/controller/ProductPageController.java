package com.proj.webprojrct.product.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.product.dto.response.ProductResponse;

@Controller
public class ProductPageController {

    private final ProductService productService;

    public ProductPageController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/product_list")
    public String list() { 
        return "product_list"; 
    }

    @GetMapping("/product_detail")
    public String detail(Model model) { 
        return "product_detail"; 
    }

    @GetMapping("/admin/products/edit")
    public String edit() { 
        return "product_edit"; 
    }

    @GetMapping("/admin/products/edit/{id}")
    public String editById(@PathVariable Long id, Model model) {
        ProductResponse p = productService.getById(id);
        model.addAttribute("product", p);
        return "product_edit";
    }

    @GetMapping("/shop")
    public String shop() {
        return "shop";
    }

    @GetMapping("/products")
    public String products(Model model) {
        // Có thể thêm logic load products vào model nếu cần
        return "product_list";
    }

    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        ProductResponse product = productService.getById(id);
        model.addAttribute("product", product);
        return "product_detail";
    }
}
