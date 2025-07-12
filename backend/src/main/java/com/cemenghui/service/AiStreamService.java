package com.cemenghui.service;

import com.cemenghui.dto.ChatRequest;
import com.cemenghui.dto.StreamResponse;
import reactor.core.publisher.Flux;


public interface AiStreamService {
    Flux<StreamResponse> streamChat(ChatRequest request);
    Flux<String> streamRawSse(ChatRequest request);
}
