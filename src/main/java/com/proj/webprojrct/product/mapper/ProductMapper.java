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
    Product toEntity(ProductCreateRequest req);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "specifications", ignore = true)
    @Mapping(target = "category", ignore = true)
    void updateEntityFromDto(ProductUpdateRequest dto, @MappingTarget Product entity);

    @Mapping(target = "specs", source = "specifications")
    @Mapping(target = "category", expression = "java(categoryToDto(entity.getCategory()))")
    ProductResponse toResponse(Product entity);
    List<ProductResponse> toResponseList(List<Product> entities);

    default CategoryDto categoryToDto(Category c) {
        if (c == null) return null;
        return new CategoryDto(c.getId(), c.getName(), c.getDescription());
    }

    SpecDto specToDto(ProductSpec spec);
    @InheritInverseConfiguration(name = "specToDto")
    ProductSpec dtoToSpec(SpecDto dto);
}
