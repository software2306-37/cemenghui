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
        Page<News> page = new Page<>(current, size);
        QueryWrapper<News> queryWrapper = new QueryWrapper<>();

        if (StringUtils.isNotBlank(keyword)) {
            queryWrapper.and(wrapper -> wrapper
                .like("title", keyword)
                .or().like("summary", keyword)
                .or().like("author", keyword)
            );
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        if (authorId != null) {
            queryWrapper.eq("author_id", authorId);
        }

        queryWrapper.orderByDesc("create_time");
        return this.page(page, queryWrapper);
    }

    @Override
    public Page<News> pageNews(int current, int size, String keyword, Integer status, Long authorId, String category, String startDate, String endDate) {
        Page<News> page = new Page<>(current, size);
        QueryWrapper<News> queryWrapper = new QueryWrapper<>();

        if (StringUtils.isNotBlank(keyword)) {
            queryWrapper.and(wrapper -> wrapper
                .like("title", keyword)
                .or().like("summary", keyword)
                .or().like("author", keyword)
            );
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        if (authorId != null) {
            queryWrapper.eq("author_id", authorId);
        }

        if (StringUtils.isNotBlank(category)) {
            queryWrapper.eq("category", category);
        }

        if (StringUtils.isNotBlank(startDate)) {
            queryWrapper.ge("create_time", startDate + " 00:00:00");
        }

        if (StringUtils.isNotBlank(endDate)) {
            queryWrapper.le("create_time", endDate + " 23:59:59");
        }

        queryWrapper.orderByDesc("create_time");
        return this.page(page, queryWrapper);
    }

    @Override
    public boolean auditNews(Long id, Integer status, Long auditUserId) {
        News news = this.getById(id);
        if (news != null) {
            news.setStatus(status);
            news.setAuditUserId(auditUserId);
            news.setAuditTime(LocalDateTime.now());
            return this.updateById(news);
        }
        return false;
    }

    @Override
    public void incrementViewCount(Long id) {
        News news = this.getById(id);
        if (news != null) {
            news.setViewCount(news.getViewCount() == null ? 1 : news.getViewCount() + 1);
            this.updateById(news);
        }
    }
}