package com.proj.webprojrct.websocket.chat;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageService chatMessageService;


    @GetMapping("/user/chat")
    public String chatuser() {
        return "chat_user"; 
    }
    @GetMapping("/admin/chat")
    public String chatadmin() {
        return "admin/chat_admin"; 
    }




    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage) {
    
        ChatMessage savedMsg = chatMessageService.save(chatMessage);

    ChatNotification notification = ChatNotification.builder()
        .id(String.valueOf(savedMsg.getId()))
        .senderId(savedMsg.getSenderId())
        .recipientId(savedMsg.getRecipientId())
        .content(savedMsg.getContent())
        .mediaPath(savedMsg.getMediaPath())
        .mediaType(savedMsg.getMediaType())
        .timestamp(savedMsg.getTimestamp())
        .build();

        messagingTemplate.convertAndSendToUser(
            chatMessage.getRecipientId(), 
            "/queue/messages", 
            notification
        );
  
        messagingTemplate.convertAndSendToUser(
            chatMessage.getSenderId(), 
            "/queue/messages", 
            notification
        );
        
       
    }

  
    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(
        @PathVariable String senderId,
        @PathVariable String recipientId) 
    {
       
        return ResponseEntity
            .ok(chatMessageService.findChatMessages(senderId, recipientId));
    }
    
 
    @GetMapping("/conversations/{recipientId}")
    public ResponseEntity<List<String>> findConversationsForRecipient(@PathVariable String recipientId) {
        return ResponseEntity.ok(chatMessageService.findConversationUsersForRecipient(recipientId));
    }

  
}