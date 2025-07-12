package com.cemenghui.controller;


import com.cemenghui.dto.ChatRequest;
import com.cemenghui.service.AiStreamService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/LLM")
public class ChatController {

    private final AiStreamService aiStreamService;

    // 构造器注入（推荐方式）
    public ChatController(AiStreamService aiStreamService) {
        this.aiStreamService = aiStreamService;
    }
    @PostMapping(value = "/chat", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> chat(@RequestBody ChatRequest request) {
        return aiStreamService.streamRawSse(request);
    }
}