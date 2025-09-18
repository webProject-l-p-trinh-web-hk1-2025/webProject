package com.proj.webprojrct.storage;

import com.proj.webprojrct.storage.entity.FileStorageServiceI;
import com.proj.webprojrct.storage.service.AvatarStorageService;
import com.proj.webprojrct.storage.service.ProductStorageService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.nio.file.Paths;

@Configuration
public class FileStorageConfig {

    @Bean
    public AvatarStorageService avatarStorage(FileStorageProperties props) throws IOException {
        return new AvatarStorageService(Paths.get(props.getAvatars()));
    }

    @Bean
    public ProductStorageService productStorage(FileStorageProperties props) throws IOException {
        return new ProductStorageService(Paths.get(props.getProducts()));
    }

}
