package com.proj.webprojrct.category.controller;

import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.category.service.CategoryService;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping(value = "/api/categories", produces = MediaType.APPLICATION_JSON_VALUE)
public class CategoryController {

    private final CategoryService service;

    public CategoryController(CategoryService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public CategoryDto create(@RequestBody CategoryDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return service.create(dto);
    }

    @PutMapping("/{id}")
    public CategoryDto update(@PathVariable Long id, @RequestBody CategoryDto dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public CategoryDto getById(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return service.getById(id);
    }

    @GetMapping
    public List<CategoryDto> getAll() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return service.getAll();
    }
}
