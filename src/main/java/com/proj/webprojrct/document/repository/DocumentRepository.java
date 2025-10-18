package com.proj.webprojrct.document.repository;

import com.proj.webprojrct.document.entity.Document;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentRepository extends JpaRepository<Document, Long> {

    // Tìm tất cả document theo productId
    List<Document> findByProductId(Long productId);
}
