package com.example.webProject.common.service;

import com.example.webProject.auth.ConfirmationService;
import com.example.webProject.user.repository.UserTokenRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class TokenCleanUpService {

    private final UserTokenRepository userTokenRepository;

    public TokenCleanUpService(UserTokenRepository userTokenRepository) {
        this.userTokenRepository = userTokenRepository;
    }

    @Scheduled(fixedRate = 60 * 60 * 1000) // mỗi giờ một lần
    public void deleteExpiredTokens() {
        userTokenRepository.deleteAllExpiredSince(LocalDateTime.now());
    }
}
