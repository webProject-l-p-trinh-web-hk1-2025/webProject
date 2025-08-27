// package com.proj.webprojrct.auth;

// import com.proj.webprojrct.sms.smsService;

// import com.proj.webprojrct.common.config.security.PasswordConfig;
// import org.springframework.security.core.userdetails.UsernameNotFoundException;
// import com.proj.webprojrct.user.entity.User;
// import com.proj.webprojrct.user.repository.UserRepository;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.stereotype.Service;
// import org.springframework.ui.Model;

// @Service
// public class AuthService {

//     private final UserRepository userRepository;
//     private final PasswordEncoder passwordEncoder;
//     private final smsService smsS;

//     public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, smsService smsS) {
//         this.userRepository = userRepository;
//         this.passwordEncoder = passwordEncoder;
//         this.smsS = smsS;
//     }

//     public boolean RegisterHandle(User user, Model model) {
//         if (isPhoneExist(user.getPhone())) {
//             model.addAttribute("error", "Số điện thoại đã được sử dụng.");
//             model.addAttribute("user", user);
//             return false;
//         }

//         registerUser(user);
//         return true;
//     }

//     public boolean ResetPasswordHandle(String phone, Model model) {
//         User user = userRepository.findByPhone(phone).orElse(null);
//         if (user == null) {
//             model.addAttribute("error", "Số điện thoại không tồn tại.");
//             return false;
//         }

//         String newPassword = PasswordConfig.generateRandomPassword();
//         String smsBody = "Mật khẩu mới sau khi reset của bạn là: " + newPassword;
//         String formattedPhone = formatPhone(phone);
//         smsS.sendSms(formattedPhone, smsBody);
//         user.setPassword(passwordEncoder.encode(newPassword));
//         userRepository.save(user);
//         return true;
//     }

//     public boolean isPhoneExist(String phone) {
//         return userRepository.findByPhone(phone).isPresent();
//     }

//     public User registerUser(User user) {
//         user.setPassword(passwordEncoder.encode(user.getPassword()));
//         return userRepository.save(user);
//     }

//     private String formatPhone(String phone) {
//         if (phone.startsWith("0")) {
//             System.out.println("Formatted phone: " + "+84" + phone.substring(1));
//             return "+84" + phone.substring(1);
//         } else if (phone.startsWith("+84")) {
//             return phone;
//         } else {
//             throw new IllegalArgumentException("Số điện thoại không đúng định dạng VN: " + phone);
//         }
//     }

// }
