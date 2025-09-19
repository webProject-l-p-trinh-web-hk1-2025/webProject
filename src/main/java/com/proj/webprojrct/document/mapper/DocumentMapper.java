package com.proj.webprojrct.document.mapper;

import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.dto.request.DocumentUpdateRequest;
import com.proj.webprojrct.document.dto.response.DocumentResponse;
import com.proj.webprojrct.document.entity.Document;

public final class DocumentMapper {
    private DocumentMapper(){}

    // Create DTO -> Entity
    public static Document toEntity(DocumentCreateRequest r){
        if (r == null) return null;
        return Document.builder()
                .title(r.getTitle())
                .content(r.getContent())
                .build();
    }

    // Update vào entity hiện có 
    public static void updateEntity(Document d, DocumentUpdateRequest r){
        if (d == null || r == null) return;
        if (r.getTitle() != null)   d.setTitle(r.getTitle());
        if (r.getContent() != null) d.setContent(r.getContent());
    }

    // Entity -> Response
    public static DocumentResponse toResponse(Document d){
        if (d == null) return null;
        return DocumentResponse.builder()
                .id(d.getDocumentId())
                .title(d.getTitle())
                .content(d.getContent())
                .createdAt(d.getCreatedAt())
                .updatedAt(d.getUpdatedAt())
                .build();
    }
}
