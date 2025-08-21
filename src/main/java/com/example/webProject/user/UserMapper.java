package com.example.webProject.user;

import com.example.webProject.common.mapper.IdMapper;
import com.example.webProject.user.dto.request.UserCreateRequest;
import com.example.webProject.user.dto.request.UserUpdateRequest;
import com.example.webProject.user.dto.response.UserCreateResponse;
import com.example.webProject.user.dto.response.UserResponse;
import com.example.webProject.user.dto.response.UserUpdateResponse;
import com.example.webProject.user.entity.User;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

import com.example.webProject.user.dto.request.UserUpdateStatusRequest;

@Mapper(componentModel = "spring", uses = IdMapper.class)
public interface UserMapper {

    // request -> Entity
    public User toEntity(UserCreateRequest user);

    public User toEntity(UserUpdateRequest user);

    public User toEntity(UserUpdateStatusRequest user);

    // Entity -> response
    public UserCreateResponse toCreatResponse(User user);

    @Mapping(target = "avatar_url", source = "avatarUrl")
    public UserUpdateResponse toUpdateResponse(User user);

    public UserResponse toResponse(User user);
    // Entity List -> response list

    public List<UserResponse> toResponse(List<User> users);

}
