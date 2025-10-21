package com.proj.webprojrct.favorite.repository;

import com.proj.webprojrct.favorite.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    
    List<Favorite> findByUserId(Long userId);
    
    Optional<Favorite> findByUserIdAndProductId(Long userId, Long productId);
    
    boolean existsByUserIdAndProductId(Long userId, Long productId);
    
    @Modifying
    @Transactional
    void deleteByUserIdAndProductId(Long userId, Long productId);
    
    @Modifying
    @Transactional
    void deleteByUserId(Long userId);
}
