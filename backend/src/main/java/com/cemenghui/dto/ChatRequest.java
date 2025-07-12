package com.cemenghui.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
public class ChatRequest {
    private String query;                   // 用户输入
    private Map<String, Object> inputs = new HashMap<>();    // 变量键值对
    private String response_mode = "streaming"; // 固定为流式
    private String user = "admin";                   // 用户唯一标识
    private String conversation_id;         // 会话ID（选填）
    private List<ChatFile> files;          // 上传文件（选填）
    private Boolean auto_generate_name;    // 自动生成标题（选填）

    @Data
    public static class ChatFile {
        private String type;               // 文件类型：image
        private String transfer_method;    // 传递方式：remote_url/local_file
        private String url;                // 图片地址（remote_url时）
        private String upload_file_id;     // 上传文件ID（local_file时）
    }
}