package com.proj.webprojrct.document.mapper;

import com.proj.webprojrct.document.dto.request.DocumentCreateRequest;
import com.proj.webprojrct.document.dto.request.DocumentUpdateRequest;
import com.proj.webprojrct.document.dto.response.DocumentResponse;
import com.proj.webprojrct.document.entity.Document;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface DocumentMapper {

    @Mappings({
        @Mapping(target = "documentId", ignore = true),
        @Mapping(target = "createdAt", ignore = true),
        @Mapping(target = "updatedAt", ignore = true)
    })
    Document toEntity(DocumentCreateRequest request);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntityFromDto(DocumentUpdateRequest dto, @MappingTarget Document entity);

    @Mapping(target = "id", source = "documentId")
    DocumentResponse toResponse(Document document);

    List<DocumentResponse> toResponseList(List<Document> documents);
}

