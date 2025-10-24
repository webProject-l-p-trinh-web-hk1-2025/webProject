package com.proj.webprojrct.product.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.category.service.CategoryService;
import com.proj.webprojrct.product.dto.response.ProductResponse;

import java.util.List;

@Controller
public class ProductPageController {

    private final ProductService productService;
    
    @Autowired
    private CategoryService categoryService;

    public ProductPageController(ProductService productService) {
        this.productService = productService;
    }

    // //admin
    // @GetMapping("/product_list")
    // public String list() {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
    //     }
    //     return "product_list";
    // }

    //admin
    // @GetMapping("/product_detail")
    // public String detail(Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
    //     }
    //     return "product_detail";
    // }

    // //admin
    // @GetMapping("/admin/products/edit")
    // public String edit() {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
    //     }
    //     return "product_edit";
    // }

    // //admin
    // @GetMapping("/admin/products/edit/{id}")
    // public String editById(@PathVariable Long id, Model model) {
    //     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    //     if (authentication == null || !authentication.isAuthenticated()
    //             || authentication instanceof AnonymousAuthenticationToken) {
    //         throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập!");
    //     }
    //     ProductResponse p = productService.getById(id);
    //     model.addAttribute("product", p);
    //     return "product_edit";
    // }

    @GetMapping("/shop")
    public String shop(@RequestParam(required = false) List<Long> category, 
                      @RequestParam(required = false) List<String> brand,
                      @RequestParam(required = false) String name,
                      @RequestParam(required = false, defaultValue = "popular") String sort,
                      @RequestParam(required = false, defaultValue = "12") int limit,
                      @RequestParam(required = false, defaultValue = "1") int page,
                      Model model) {
        try {
            List<ProductResponse> products = productService.getAll();
            
            // Lọc theo tên sản phẩm (search) với fuzzy matching
            if (name != null && !name.trim().isEmpty()) {
                String searchTerm = name.trim().toLowerCase();
                String[] searchWords = searchTerm.split("\\s+");
                
                products = products.stream()
                    .filter(p -> {
                        if (p.getName() == null) return false;
                        String productName = p.getName().toLowerCase();
                        
                        // Exact match
                        if (productName.contains(searchTerm)) return true;
                        
                        // Check if any search word is in product name
                        for (String word : searchWords) {
                            if (word.length() >= 2 && productName.contains(word)) {
                                return true;
                            }
                        }
                        
                        // Fuzzy matching for typos
                        return isFuzzyMatch(productName, searchTerm);
                    })
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Lọc theo categories (có thể chọn nhiều)
            if (category != null && !category.isEmpty()) {
                products = products.stream()
                    .filter(p -> p.getCategory() != null && category.contains(p.getCategory().getId()))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Lọc theo brands (có thể chọn nhiều)
            if (brand != null && !brand.isEmpty()) {
                products = products.stream()
                    .filter(p -> p.getBrand() != null && brand.contains(p.getBrand()))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Sắp xếp
            java.util.Comparator<ProductResponse> comparator = null;
            switch (sort) {
                case "price-asc":
                    comparator = java.util.Comparator.comparing(ProductResponse::getPrice);
                    break;
                case "price-desc":
                    comparator = java.util.Comparator.comparing(ProductResponse::getPrice).reversed();
                    break;
                case "popular":
                default:
                    // Sắp xếp theo ID giảm dần (sản phẩm mới nhất)
                    comparator = java.util.Comparator.comparing(ProductResponse::getId).reversed();
                    break;
            }
            
            if (comparator != null) {
                products = products.stream()
                    .sorted(comparator)
                    .collect(java.util.stream.Collectors.toList());
            }
            
            // Tính toán phân trang
            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / limit);
            
            // Đảm bảo page không vượt quá số trang
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            // Lấy products cho trang hiện tại
            int startIndex = (page - 1) * limit;
            int endIndex = Math.min(startIndex + limit, totalProducts);
            
            List<ProductResponse> paginatedProducts;
            if (startIndex < totalProducts) {
                paginatedProducts = products.subList(startIndex, endIndex);
            } else {
                paginatedProducts = java.util.Collections.emptyList();
            }
            
            model.addAttribute("products", paginatedProducts);
            model.addAttribute("categories", categoryService.getAll());
            model.addAttribute("brands", productService.getAllBrands());
            model.addAttribute("selectedCategories", category != null ? category : java.util.Collections.emptyList());
            model.addAttribute("selectedBrands", brand != null ? brand : java.util.Collections.emptyList());
            model.addAttribute("searchName", name != null ? name : "");
            model.addAttribute("selectedSort", sort);
            model.addAttribute("selectedLimit", limit);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalProducts", totalProducts);
            model.addAttribute("startIndex", startIndex + 1);
            model.addAttribute("endIndex", endIndex);
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }
        return "shop";
    }

    // //admin
    // @GetMapping("/products")
    // public String products(Model model) {
    //     // Có thể thêm logic load products vào model nếu cần
    //     return "product_list";
    // }
    //user
    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        ProductResponse product = productService.getById(id);
        model.addAttribute("product", product);
        return "product_detail";
    }
    
    @GetMapping("/deals")
    public String deals(Model model) {
        try {
            // Get all products with onDeal=true
            List<ProductResponse> allProducts = productService.getAll();
            List<ProductResponse> dealProducts = allProducts.stream()
                .filter(p -> p.getOnDeal() != null && p.getOnDeal())
                .collect(java.util.stream.Collectors.toList());
            
            model.addAttribute("products", dealProducts);
            model.addAttribute("categories", categoryService.getAll());
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải dữ liệu khuyến mãi: " + e.getMessage());
        }
        return "deals";
    }
    
    // Helper method for fuzzy matching
    private boolean isFuzzyMatch(String productName, String searchTerm) {
        if (searchTerm.length() < 3) return false;
        
        int searchIndex = 0;
        for (int i = 0; i < productName.length() && searchIndex < searchTerm.length(); i++) {
            if (productName.charAt(i) == searchTerm.charAt(searchIndex)) {
                searchIndex++;
            }
        }
        
        // If we matched at least 70% of search term characters
        return searchIndex >= (searchTerm.length() * 0.7);
    }
}

