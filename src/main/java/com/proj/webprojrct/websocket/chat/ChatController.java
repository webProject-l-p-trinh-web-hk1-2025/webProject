package com.proj.webprojrct.websocket.chat;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

// Import đã được đơn giản hóa, UserRegistryService không còn cần thiết cho việc định tuyến chính
// import com.proj.webprojrct.websocket.user.UserRegistryService; 

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageService chatMessageService;
    // private final UserRegistryService userRegistryService; // KHÔNG CẦN THIẾT CHO ĐỊNH TUYẾN

    /**
     * Xử lý tin nhắn đến từ Client (Được gửi đến /app/chat).
     * Sửa lỗi định tuyến để tin nhắn đến cả người gửi và người nhận.
     */
    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage) {
        
        // 1. Lưu tin nhắn vào Database
        ChatMessage savedMsg = chatMessageService.save(chatMessage);

        // 2. Tạo đối tượng thông báo để gửi qua WebSocket
        // Sử dụng ChatNotification để tránh gửi toàn bộ object JPA/Hibernate
    ChatNotification notification = ChatNotification.builder()
        .id(String.valueOf(savedMsg.getId()))
        .senderId(savedMsg.getSenderId())
        .recipientId(savedMsg.getRecipientId())
        .content(savedMsg.getContent())
        .mediaPath(savedMsg.getMediaPath())
        .mediaType(savedMsg.getMediaType())
        .timestamp(savedMsg.getTimestamp())
        .build();

        // --- ĐỊNH TUYẾN CHUẨN ĐÃ SỬA LỖI ---
        
        // 3. Gửi tin nhắn tới NGƯỜI NHẬN (Recipient)
        // Spring sẽ tự động tìm session của RecipientId và gửi đến /user/{RecipientId}/queue/messages
        // Đây là tin nhắn mà User A (người nhận) cần để cập nhật UI
        messagingTemplate.convertAndSendToUser(
            chatMessage.getRecipientId(), 
            "/queue/messages", 
            notification
        );
        
        // 4. Gửi tin nhắn tới NGƯỜI GỬI (Sender)
        // Đây là tin nhắn phản hồi mà User B (người gửi) cần để kích hoạt onMessageReceived
        // và tải lại lịch sử chat, đảm bảo tin nhắn xuất hiện trên màn hình B ngay lập tức.
        messagingTemplate.convertAndSendToUser(
            chatMessage.getSenderId(), 
            "/queue/messages", 
            notification
        );
        
        // LƯU Ý QUAN TRỌNG: 
        // Logic này yêu cầu nickname (senderId/recipientId) phải KHỚP CHÍNH XÁC 
        // với Principal Name (tên người dùng) mà Spring Security đang sử dụng.
    }

    /**
     * REST API để tải lịch sử tin nhắn giữa hai người dùng.
     * Endpoint này được gọi từ JavaScript: fetch('/messages/{senderId}/{recipientId}')
     */
    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(
        @PathVariable String senderId,
        @PathVariable String recipientId) 
    {
        // Trả về lịch sử chat (đã được lưu vào DB)
        return ResponseEntity
            .ok(chatMessageService.findChatMessages(senderId, recipientId));
    }
    
    /**
     * Trả về danh sách các user (senderId) đã từng nhắn cho recipient (ví dụ admin)
     * Endpoint: GET /conversations/{recipientId}
     */
    @GetMapping("/conversations/{recipientId}")
    public ResponseEntity<List<String>> findConversationsForRecipient(@PathVariable String recipientId) {
        return ResponseEntity.ok(chatMessageService.findConversationUsersForRecipient(recipientId));
    }
    @GetMapping("/chat")
    public String chat() {
        return "chat"; 
    }
}