package com.cemenghui.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

@Configuration
public class WebClientConfig {

    @Value("${api.base-url}")
    private String baseUrl;
    
    @Value("${api.auth.token}")
    private String apiToken; // 从配置文件注入

    @Bean(name = "difyWebClient")
    public WebClient difyWebClient() {
        return WebClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + apiToken) // 强制携带
                .defaultHeader(HttpHeaders.ACCEPT, MediaType.TEXT_EVENT_STREAM_VALUE) // 必须
                .codecs(configurer ->
                        configurer.defaultCodecs().maxInMemorySize(10 * 1024 * 1024)) // 增大缓冲区
                .clientConnector(new ReactorClientHttpConnector(
                        HttpClient.create()
                                .keepAlive(false) // 禁用连接池
                                .wiretap(true)    // 启用网络层日志
                ))
                .build();
    }
}