package com.proj.webprojrct.category.service;

import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.category.entity.Category;
import com.proj.webprojrct.category.repository.CategoryRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository repo;

    public CategoryServiceImpl(CategoryRepository repo) { this.repo = repo; }

    @Override
    public CategoryDto create(CategoryDto dto) {
        if (repo.findByName(dto.getName()).isPresent())
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Tên danh mục đã tồn tại");
        Category c = Category.builder()
                .name(dto.getName())
                .description(dto.getDescription())
                .build();
        return map(repo.save(c));
    }

    @Override
    public CategoryDto update(Long id, CategoryDto dto) {
        Category c = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id));
        c.setName(dto.getName());
        c.setDescription(dto.getDescription());
        return map(repo.save(c));
    }

    @Override
    public void delete(Long id) {
        if (!repo.existsById(id))
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id);
        repo.deleteById(id);
    }

    @Override
    public CategoryDto getById(Long id) {
        return map(repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy danh mục #" + id)));
    }

    @Override
    public List<CategoryDto> getAll() {
        return repo.findAll().stream().map(this::map).collect(Collectors.toList());
    }

    private CategoryDto map(Category c) {
        return new CategoryDto(c.getId(), c.getName(), c.getDescription());
    }
}
