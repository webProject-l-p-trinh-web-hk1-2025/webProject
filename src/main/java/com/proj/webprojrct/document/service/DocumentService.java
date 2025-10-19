package com.proj.webprojrct.document.service;

import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.dto.request.DocumentUpdateRequest;
import com.proj.webprojrct.document.dto.response.DocumentResponse;
import java.util.List;

public interface DocumentService {
    List<DocumentResponse> list(String q);
    DocumentResponse get(Long id);
    DocumentResponse create(DocumentCreateRequest req);
    DocumentResponse update(Long id, DocumentUpdateRequest req);
    void delete(Long id);
}
