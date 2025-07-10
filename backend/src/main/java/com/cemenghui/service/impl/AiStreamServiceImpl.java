package com.cemenghui.service.impl;


import com.cemenghui.dto.ChatRequest;
import com.cemenghui.dto.StreamResponse;
import com.cemenghui.service.AiStreamService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service
public class AiStreamServiceImpl implements AiStreamService {

    private final WebClient webClient;
    private final ObjectMapper objectMapper;

    public AiStreamServiceImpl(@Qualifier("difyWebClient") WebClient webClient, ObjectMapper objectMapper) {
        this.webClient = webClient;
        this.objectMapper = objectMapper;
    }

    public Flux<StreamResponse> streamChat(ChatRequest request) {
        if (request.getInputs() == null) {
            request.setInputs(new java.util.HashMap<>());
        }
        if (request.getUser() == null) {
            request.setUser("admin");
        }
        try {
            String jsonBody = objectMapper.writeValueAsString(request);
            System.out.println("即将发送AI请求: POST /v1/chat-messages");
            System.out.println("请求头: Authorization: Bearer [已隐藏], Content-Type: application/json, Accept: text/event-stream");
            System.out.println("请求体: {"+ jsonBody+"}");
        } catch (Exception e) {
            System.out.println("请求体序列化失败"+e);
        }
        Flux<StreamResponse> responseFlux = webClient.post()
                .uri("/v1/chat-messages")
                .bodyValue(request)
                .exchangeToFlux(response -> {
                    System.out.println("响应状态码: " + response.statusCode());
                    return response.bodyToFlux(String.class)
                        .doOnNext(s -> System.out.println("原始流内容: " + s));
                })
                .filter(data -> data.startsWith("data: "))  // 过滤SSE格式
                .map(data -> data.substring(6))              // 去掉"data: "前缀
                .map(this::parseResponse)                   // JSON解析
                .doOnNext(response -> {
                    switch (response.getEvent()) {
                        case "message":
                            log.info("收到消息块: {}", response.getAnswer());
                            System.out.println("AI流内容: " + response.getAnswer());
                            break;
                        case "message_end":
                            log.info("消息结束，用量: {}", response.getUsage());
                            break;
                        case "error":
                            log.error("API错误: {}", response.getAnswer());
                            System.out.println("AI流错误: " + response.getAnswer());
                            break;
                    }
                })
                .onErrorResume(e -> {
                    log.error("流式请求异常", e);
                    System.out.println("流式请求异常: " + e.getMessage());
                    return Flux.just(createErrorResponse(e.getMessage()));
                });
        System.out.println("AiStreamService准备返回Flux");
        return responseFlux;
    }

//    public Flux<String> streamRawSse(ChatRequest request) {
//        return webClient.post()
//                .uri("/v1/chat-messages")
//                .bodyValue(request)
//                .accept(MediaType.TEXT_EVENT_STREAM)
//                .exchangeToFlux(response ->
//                        response.bodyToFlux(DataBuffer.class)
//                                .map(dataBuffer -> {
//                                    try {
//                                        return decodeDataBuffer(dataBuffer);
//                                    } finally {
//                                        DataBufferUtils.release(dataBuffer); // 确保资源释放
//                                    }
//                                })
//                                .map(chunk -> cleanSseChunk(chunk)) // 清理异常的data:前缀
//                                .doOnNext(chunk -> log.debug("收到SSE数据块: {}", chunk))
//                                .doFinally(signal -> {
//                                    log.info("SSE流处理完成: {}", signal.name());
//                                })
//                                .onErrorResume(e -> {
//                                    log.error("SSE流处理错误", e);
//                                    return Flux.empty();
//                                })
//                );
//    }

    public Flux<String> streamRawSse(ChatRequest request) {

        AtomicInteger StreamID = new AtomicInteger();

        return webClient.post()
                .uri("/v1/chat-messages")
                .bodyValue(request)
                .accept(MediaType.TEXT_EVENT_STREAM)
                .exchangeToFlux(response ->
                        response.bodyToFlux(DataBuffer.class)
                                .map(dataBuffer -> {
                                    try {
                                        return decodeDataBuffer(dataBuffer);
                                    } finally {
                                        DataBufferUtils.release(dataBuffer); // 确保资源释放
                                    }
                                })
                                .map(chunk -> cleanSseChunk(chunk,StreamID)) // 清理异常的data:前缀,添加唯一标识后缀

                                .doOnNext(chunk -> {
                                    log.debug("收到SSE数据块: {}", chunk);
                                    StreamID.getAndIncrement();
                                })
                                .doFinally(signal -> {
                                    log.info("SSE流处理完成: {}", signal.name());
                                })
                                .onErrorResume(e -> {
                                    log.error("SSE流处理错误", e);
                                    return Flux.empty();
                                })

                )
                .flatMap(dataBuffer -> {
                    return Flux.fromArray(dataBuffer.split("\n\n")); // 严格分割
                }).share(); // 关键修改：使流变为热发布;
    }

    private String cleanSseChunk(String chunk, AtomicInteger streamId) {
        String modifiedData = chunk.replaceFirst(
                "\"from_variable_selector\"",
                "\"stream_id\": \"" + streamId + "\", \"from_variable_selector\""
        );
        // 修复不正常的"data:data:"前缀问题
        if (modifiedData.startsWith("data:data:")) {
            return modifiedData.substring(5); // 去除多余的前缀
        }
        return modifiedData;
    }

    static class SSEEventParser implements Publisher<String> {
        private final Flux<String> source;

        public SSEEventParser(Flux<DataBuffer> dataBufferFlux) {
            this.source = dataBufferFlux
                    .map(buf -> {
                        String data = buf.toString(StandardCharsets.UTF_8);
                        DataBufferUtils.release(buf);
                        return data;
                    })
                    .flatMapIterable(raw -> Arrays.asList(raw.split("\n\n"))); // 严格分割
        }

        @Override
        public void subscribe(Subscriber<? super String> subscriber) {
            source.subscribe(subscriber);
        }
    }

    private String decodeDataBuffer(DataBuffer dataBuffer) {
        byte[] bytes = new byte[dataBuffer.readableByteCount()];
        dataBuffer.read(bytes);
        String chunk = new String(bytes, StandardCharsets.UTF_8);

        // 修复内容内的换行符导致的JSON分割
        return chunk.replaceAll("\\n\\ndata:", "\n  "); // 替换异常的JSON内换行符
    }

    // 2. 修改JSON解析方法
    private StreamResponse parseResponse(String json) {
        try {
            return objectMapper.readValue(json, StreamResponse.class);
        } catch (Exception e) {
            log.error("JSON解析失败: {}", json, e);
            return createErrorResponse("Invalid JSON: " + e.getMessage());
        }
    }

    private StreamResponse createErrorResponse(String error) {
        StreamResponse response = new StreamResponse();
        response.setEvent("error");
        response.setAnswer(error);
        return response;
    }
}