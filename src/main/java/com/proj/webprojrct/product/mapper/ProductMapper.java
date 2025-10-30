package com.proj.webprojrct.product.mapper;

import com.proj.webprojrct.product.dto.SpecDto;
import com.proj.webprojrct.product.dto.request.*;
import com.proj.webprojrct.product.dto.response.ProductResponse;
import com.proj.webprojrct.product.entity.*;
import com.proj.webprojrct.category.dto.CategoryDto;
import com.proj.webprojrct.category.entity.Category;
import org.mapstruct.*;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ProductMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "specifications", ignore = true)
    @Mapping(target = "category", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "imageUrl", ignore = true)
    @Mapping(target = "images", ignore = true)
    Product toEntity(ProductCreateRequest req);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "specifications", ignore = true)
    @Mapping(target = "category", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "imageUrl", ignore = true)
    @Mapping(target = "images", ignore = true)
    void updateEntityFromDto(ProductUpdateRequest dto, @MappingTarget Product entity);

    @Mapping(target = "specs", source = "specifications")
    @Mapping(target = "category", expression = "java(categoryToDto(entity.getCategory()))")
    @Mapping(target = "imageUrls", expression = "java(imagesToUrls(entity))")
    @Mapping(target = "images", expression = "java(imagesToDtos(entity))")
    @Mapping(target = "availableColors", expression = "java(extractAvailableColors(entity))")
    ProductResponse toResponse(Product entity);

    List<ProductResponse> toResponseList(List<Product> entities);

    default CategoryDto categoryToDto(Category c) {
        if (c == null) {
            return null;
        }
        return new CategoryDto(c.getId(), c.getName(), c.getDescription(), c.getParentId());
    }

    SpecDto specToDto(ProductSpec spec);

    @InheritInverseConfiguration(name = "specToDto")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "product", ignore = true)
    ProductSpec dtoToSpec(SpecDto dto);

    default java.util.List<String> imagesToUrls(Product entity) {
        if (entity == null || entity.getImages() == null) {
            return null;
        }
        java.util.List<String> urls = new java.util.ArrayList<>();
        for (var img : entity.getImages()) {
            urls.add(img.getUrl());
        }
        return urls;
    }

    default java.util.List<com.proj.webprojrct.product.dto.ImageDto> imagesToDtos(Product entity) {
        if (entity == null || entity.getImages() == null) {
            return null;
        }
        java.util.List<com.proj.webprojrct.product.dto.ImageDto> out = new java.util.ArrayList<>();
        for (var img : entity.getImages()) {
            out.add(new com.proj.webprojrct.product.dto.ImageDto(img.getId(), img.getUrl(), img.getColor()));
        }
        return out;
    }

    default java.util.List<String> extractAvailableColors(Product entity) {
        if (entity == null || entity.getImages() == null || entity.getImages().isEmpty()) {
            return java.util.Collections.emptyList();
        }
        // Extract unique colors from images
        return entity.getImages().stream()
                .map(ProductImage::getColor)
                .filter(color -> color != null && !color.trim().isEmpty())
                .distinct()
                .collect(java.util.stream.Collectors.toList());
    }
}
