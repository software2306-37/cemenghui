package com.cemenghui.service;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.cemenghui.mapper")
public class CemenghuiApplication {

    public static void main(String[] args) {
        SpringApplication.run(CemenghuiApplication.class, args);
    }

} 