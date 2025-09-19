package com.proj.webprojrct.document.controller;

import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.dto.request.DocumentUpdateRequest;
import com.proj.webprojrct.document.dto.response.DocumentResponse;
import com.proj.webprojrct.document.entity.Document;
import com.proj.webprojrct.document.mapper.DocumentMapper;
import com.proj.webprojrct.document.repository.DocumentRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/documents", produces = MediaType.APPLICATION_JSON_VALUE)
public class DocumentController {

    private final DocumentRepository repo;

    @GetMapping
    @Transactional(readOnly = true)
    public List<DocumentResponse> list(@RequestParam(required = false) String q) {
        List<Document> docs = (q == null || q.isBlank())
                ? repo.findAll()
                : repo.findByTitleContainingIgnoreCaseOrderByUpdatedAtDesc(q.trim());
        return docs.stream().map(DocumentMapper::toResponse).toList();
    }

    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public DocumentResponse get(@PathVariable Long id) {
        return repo.findById(id)
                .map(DocumentMapper::toResponse)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Document not found"));
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public ResponseEntity<DocumentResponse> create(@Valid @RequestBody DocumentCreateRequest req) {
        Document entity = DocumentMapper.toEntity(req);
        entity = repo.save(entity);
        DocumentResponse body = DocumentMapper.toResponse(entity);
        return ResponseEntity.created(URI.create("/api/documents/" + body.getId())).body(body);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public DocumentResponse update(@PathVariable Long id, @Valid @RequestBody DocumentUpdateRequest req) {
        Document entity = repo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Document not found"));
        DocumentMapper.updateEntity(entity, req);
        entity = repo.save(entity);
        return DocumentMapper.toResponse(entity);
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Document not found");
        }
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
