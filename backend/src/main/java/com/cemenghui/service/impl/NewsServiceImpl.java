package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.cemenghui.entity.News;
import com.cemenghui.mapper.NewsMapper;
import com.cemenghui.service.NewsService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class NewsServiceImpl extends ServiceImpl<NewsMapper, News> implements NewsService {
    @Override
    public Page<News> pageNews(int current, int size, String keyword, Integer status, Long authorId) {
        return null;
    }

    @Override
    public Page<News> pageNews(int current, int size, String keyword, Integer status, Long authorId, String category, String startDate, String endDate) {
        return null;
    }

    @Override
    public boolean auditNews(Long id, Integer status, Long auditUserId) {
        return false;
    }

    @Override
    public void incrementViewCount(Long id) {

    }
}