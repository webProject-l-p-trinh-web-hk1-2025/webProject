package com.proj.webprojrct.document.controller;

import com.proj.webprojrct.document.dto.DocumentCreateRequest;
import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.document.service.DocumentService;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;

@Controller
@RequestMapping("/admin/document")
@RequiredArgsConstructor
public class DocumentController {

    private final DocumentService documentService;

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("document", null);
        model.addAttribute("formAction", "/admin/document/create");
        return "admin/document_form";
    }

    @PostMapping("/create")
    public String handleCreateDocument(
            @ModelAttribute DocumentCreateRequest dto,
            @RequestParam("images") List<MultipartFile> images,
            Model model) {

        try {
            documentService.createDocument(dto, images);
            model.addAttribute("success", "Tạo Document thành công!");
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
        }
        return "admin/document_form";
    }

    @GetMapping("/all")
    public String showAllDocuments(Model model) {
        List<Document> documents = documentService.getAllDocuments();
        model.addAttribute("documents", documents);
        return "admin/document_list"; // JSP hiển thị danh sách document
    }

    @GetMapping("/{id}")
    public String showDocumentDetail(@PathVariable Long id, Model model) {
        Document doc = documentService.getDocument(id);
        model.addAttribute("document", doc);
        return "admin/document_detail"; // JSP hiển thị chi tiết từng document
    }

    @PostMapping("/upload-image")
    @ResponseBody
    public ResponseEntity<?> handleEditorImageUpload(@RequestParam("image") MultipartFile image) {
        try {
            String imageUrl = documentService.saveImage(image); // Gọi service
            return ResponseEntity.ok(Map.of("imageUrl", imageUrl));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("error", "Could not upload the image"));
        }
    }
}
