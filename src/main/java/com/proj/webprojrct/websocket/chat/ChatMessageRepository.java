package com.proj.webprojrct.websocket.chat;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByChatId(String chatId);
    
    @Query("SELECT DISTINCT c.senderId FROM ChatMessage c WHERE c.recipientId = :recipientId")
    List<String> findDistinctSenderIdsByRecipientId(@Param("recipientId") String recipientId);
}
