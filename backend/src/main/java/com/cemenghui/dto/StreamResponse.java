package com.cemenghui.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class StreamResponse {
    private String event;                  // 事件类型
    private String task_id;                // 任务ID
    private String message_id;             // 消息ID
    private String conversation_id;        // 会话ID
    private String answer;                 // 回答内容
    private Map<String, Object> metadata;  // 元数据
    private Usage usage;                    // 用量信息
    private List<RetrieverResource> retriever_resources; // 引用资源
    private Long created_at;               // 时间戳

    @Data
    public static class Usage {
        private int prompt_tokens;
        private int completion_tokens;
    }

    @Data
    public static class RetrieverResource {
        private String content;
        private String title;
    }
}