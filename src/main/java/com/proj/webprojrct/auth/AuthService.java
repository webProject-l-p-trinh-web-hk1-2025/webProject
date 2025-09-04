package com.proj.webprojrct.auth;

import com.proj.webprojrct.sms.smsService;
import com.proj.webprojrct.email.emailService;

import com.proj.webprojrct.common.config.security.PasswordConfig;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import com.proj.webprojrct.user.entity.User;
import com.proj.webprojrct.user.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final smsService smsS;
    private final emailService emailService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, smsService smsS, emailService emailService) {
        this.emailService = emailService;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.smsS = smsS;
    }

    // public boolean RegisterHandle(User user, Model model) {
    //     if (isPhoneExist(user.getPhone())) {
    //         model.addAttribute("error", "Số điện thoại đã được sử dụng.");
    //         model.addAttribute("user", user);
    //         return false;
    //     }
    //     registerUser(user);
    //     return true;
    // }
    public boolean PhoneResetPasswordHandle(String phone, Model model) {
        User user = userRepository.findByPhone(phone).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Số điện thoại không tồn tại.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        String smsBody = "Mật khẩu mới sau khi reset của bạn là: " + newPassword;
        String formattedPhone = formatPhone(phone);
        smsS.sendSms(formattedPhone, smsBody);
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        return true;
    }

    public boolean EmailResetPasswordHandle(String email, Model model) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            model.addAttribute("error", "Email không tồn tại.");
            return false;
        }

        String newPassword = PasswordConfig.generateRandomPassword();
        // Gửi email chứa mật khẩu mới
        String emailBody = "Mật khẩu mới sau khi reset của bạn là: " + newPassword;
        emailService.sendEmail(email, "Reset Mật Khẩu", emailBody);
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        return true;
    }

    public boolean isPhoneExist(String phone) {
        return userRepository.findByPhone(phone).isPresent();
    }

    private String formatPhone(String phone) {
        if (phone.startsWith("0")) {
            System.out.println("Formatted phone: " + "+84" + phone.substring(1));
            return "+84" + phone.substring(1);
        } else if (phone.startsWith("+84")) {
            return phone;
        } else {
            throw new IllegalArgumentException("Số điện thoại không đúng định dạng VN: " + phone);
        }
    }

}
