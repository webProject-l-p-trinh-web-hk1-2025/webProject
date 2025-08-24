package com.proj.webprojrct.common.config.security;

import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String phone) throws UsernameNotFoundException {
        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy user: " + phone));

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getPhone()) // dùng phone làm username
                .password(user.getPasswordHash())
                .roles(user.getRole().name()) // ROLE_USER, ROLE_ADMIN
                .disabled(!Boolean.TRUE.equals(user.getIsActive()))
                .build();
    }
}
