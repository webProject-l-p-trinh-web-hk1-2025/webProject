package com.proj.webprojrct.admin.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.service.DocumentService;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.service.ProductService;
import com.proj.webprojrct.document.repository.DocumentRepository;

import java.util.Map;

@Controller
@RequestMapping("/admin/document")
public class AdminDocumentController {

    @Autowired
    private DocumentService documentService;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private DocumentRepository documentRepository;
    
      @GetMapping
    public String show(Model model) {
        List<Document> documents = documentService.getAllDocuments();
        List<ProductResponse> products = productService.getAll();
        model.addAttribute("documents", documents);
        model.addAttribute("products", products);
        return "admin/document_list";
    }

    @GetMapping({"/all", "/list"})
    public String showAllDocuments(Model model) {
        List<Document> documents = documentService.getAllDocuments();
        List<ProductResponse> products = productService.getAll();
        model.addAttribute("documents", documents);
        model.addAttribute("products", products);
        return "admin/document_list";
    }

    @GetMapping({"/create", "/new"})
    public String showCreateForm(Model model) {
        model.addAttribute("document", null);
        model.addAttribute("formAction", "/admin/document/create");
        
        // Load danh sách products chưa có document
        List<ProductResponse> allProducts = productService.getAll();
        List<Long> productIdsWithDocuments = documentRepository.findAllProductIdsWithDocuments();
        
        // Lọc ra những sản phẩm chưa có document
        List<ProductResponse> availableProducts = allProducts.stream()
            .filter(product -> !productIdsWithDocuments.contains(product.getId()))
            .collect(Collectors.toList());
        
        model.addAttribute("products", availableProducts);
        
        return "admin/document_form";
    }

    @PostMapping("/create")
    public String handleCreateDocument(@ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model) {
        try {
            documentService.createDocument(dto, images == null ? List.of() : images);
            model.addAttribute("success", "Tạo Document thành công!");
            return "redirect:/admin/document";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "admin/document_form";
        }
    }

    @GetMapping("/{id}")
    public String showDocumentDetail(@PathVariable Long id, Model model) {
        Document doc = documentService.getDocument(id);
        model.addAttribute("document", doc);
        return "admin/document_detail";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Document document = documentService.getDocument(id);
        model.addAttribute("document", document);
        
        // Load danh sách products chưa có document
        List<ProductResponse> allProducts = productService.getAll();
        List<Long> productIdsWithDocuments = documentRepository.findAllProductIdsWithDocuments();
        
        // Lọc ra những sản phẩm chưa có document, NHƯNG vẫn giữ lại sản phẩm hiện tại của document này
        List<ProductResponse> availableProducts = allProducts.stream()
            .filter(product -> !productIdsWithDocuments.contains(product.getId()) 
                || product.getId().equals(document.getProductId()))
            .collect(Collectors.toList());
        
        model.addAttribute("products", availableProducts);
        
        return "admin/document_form";
    }

    @PostMapping("/update/{id}")
    public String updateDocument(@PathVariable Long id,
            @ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model) {
        documentService.updateDocument(id, dto, images == null ? List.of() : images);
        model.addAttribute("success", "Cập nhật document thành công!");
        return "redirect:/admin/document";
    }

    @PostMapping("/upload-image")
    @ResponseBody
    public ResponseEntity<?> handleEditorImageUpload(@RequestParam("image") MultipartFile image) {
        try {
            String imageUrl = documentService.saveImage(image);
            return ResponseEntity.ok(Map.of("imageUrl", imageUrl));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("error", "Could not upload the image"));
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteDocument(@PathVariable Long id, Model model) {
        try {
            documentService.deleteDocument(id);
            model.addAttribute("success", "Xóa document thành công!");
        } catch (Exception e) {
            model.addAttribute("error", "Không thể xóa document: " + e.getMessage());
        }
        return "redirect:/admin/document";
    }
    
    // API endpoint to get document by productId (for product detail page)
    @GetMapping("/api/product/{productId}")
    @ResponseBody
    public ResponseEntity<?> getDocumentByProductId(@PathVariable Long productId) {
        try {
            Document document = documentService.getDocumentByProductId(productId);
            if (document == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(document);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}
