package com.proj.webprojrct.admin.controller;

import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.Product;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.storage.service.ProductStorageService;

import lombok.RequiredArgsConstructor;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.math.BigDecimal;

import org.springframework.http.HttpStatus;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/products")
public class AdminProductController {

    private final ProductRepository productRepository;

    private final ProductStorageService productStorageService;
    private final ProductService productService;

    //admin
    @GetMapping
    public String products(Model model) {
        return "admin/product_list";
    }

    // Trang form thêm mới
    @GetMapping("/new")
    public String form() {
        return "admin/product_form";
    }

    // Xử lý tạo sản phẩm mới
    @PostMapping("/create")
    public String createProduct(
            @RequestParam String name,
            @RequestParam String brand,
            @RequestParam BigDecimal price,
            @RequestParam Integer stock,
            // technical specs
            @RequestParam(required = false) String screenSize,
            @RequestParam(required = false) String displayTech,
            @RequestParam(required = false) String rearCamera,
            @RequestParam(required = false) String frontCamera,
            @RequestParam(required = false) String chipset,
            @RequestParam(required = false) String nfcSupport,
            @RequestParam(required = false) String ram,
            @RequestParam(required = false) String storage,
            @RequestParam(required = false) String battery,
            @RequestParam(required = false) String simType,
            @RequestParam(required = false) String os,
            @RequestParam(required = false) String resolution,
            @RequestParam(required = false) String displayFeatures,
            @RequestParam(required = false) String cpuSpecs,
            @RequestParam(value = "image", required = false) MultipartFile image
    ) throws IOException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }

        // Tạo sản phẩm mới
        Product p = Product.builder()
                .name(name)
                .brand(brand)
                .price(price)
                .stock(stock)
                .screenSize(screenSize)
                .displayTech(displayTech)
                .rearCamera(rearCamera)
                .frontCamera(frontCamera)
                .chipset(chipset)
                .nfcSupport(nfcSupport)
                .ram(ram)
                .storage(storage)
                .battery(battery)
                .simType(simType)
                .os(os)
                .resolution(resolution)
                .displayFeatures(displayFeatures)
                .cpuSpecs(cpuSpecs)
                .build();

        // Upload ảnh nếu có
        if (image != null && !image.isEmpty()) {
            String fileName = productStorageService.save(image.getOriginalFilename(), image.getInputStream());
            p.setImageUrl("/uploads/products/" + fileName);
        }

        productRepository.save(p);
        return "redirect:/admin/product_list";
    }

    // Xử lý xóa sản phẩm
    @ResponseBody
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        productRepository.deleteById(id);
    }

    @ResponseBody
    @PostMapping("/{id}/delete")
    public void deleteProductPost(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        productRepository.deleteById(id);
    }



     //admin
    @GetMapping("/edit")
    public String edit() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        return "admin/product_edit";
    }

    //admin
    @GetMapping("/edit/{id}")
    public String editById(@PathVariable Long id, Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
        }
        ProductResponse p = productService.getById(id);
        model.addAttribute("product", p);
        return "admin/product_edit";
    }

}
