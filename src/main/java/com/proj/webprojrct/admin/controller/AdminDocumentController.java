package com.proj.webprojrct.admin.controller;

import java.util.List;

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

import java.util.Map;

@Controller
@RequestMapping("/admin/document")
public class AdminDocumentController {

    @Autowired
    private DocumentService documentService;

    @GetMapping({"/all", "/list"})
    public String showAllDocuments(Model model) {
        List<Document> documents = documentService.getAllDocuments();
        model.addAttribute("documents", documents);
        return "admin/document_list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("document", null);
        model.addAttribute("formAction", "/admin/document/create");
        return "admin/document_form";
    }

    @PostMapping("/create")
    public String handleCreateDocument(@ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model) {
        try {
            documentService.createDocument(dto, images == null ? List.of() : images);
            model.addAttribute("success", "Tạo Document thành công!");
            return "redirect:/admin/document/list";
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
        return "admin/document_form";
    }

    @PostMapping("/update/{id}")
    public String updateDocument(@PathVariable Long id,
            @ModelAttribute DocumentCreateRequest dto,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            Model model) {
        documentService.updateDocument(id, dto, images == null ? List.of() : images);
        model.addAttribute("success", "Cập nhật document thành công!");
        return "redirect:/admin/document/list";
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
}
