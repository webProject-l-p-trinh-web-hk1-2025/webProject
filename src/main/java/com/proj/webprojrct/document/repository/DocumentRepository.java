package com.proj.webprojrct.document.repository;

import com.proj.webprojrct.document.entity.Document;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DocumentRepository extends JpaRepository<Document, Long> {
    List<Document> findByTitleContainingIgnoreCaseOrderByUpdatedAtDesc(String q);
}
