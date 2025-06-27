package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.cemenghui.entity.News;

public interface NewsService extends IService<News> {
    
    /**
     * 分页查询动态
     */
    Page<News> pageNews(int current, int size, String keyword, Integer status, Long authorId);
    
    /**
     * 分页查询动态（带时间和分类筛选）
     */
    Page<News> pageNews(int current, int size, String keyword, Integer status, Long authorId, String category, String startDate, String endDate);
    
    /**
     * 审核动态
     */
    boolean auditNews(Long id, Integer status, Long auditUserId);
    
    /**
     * 增加浏览量
     */
    void incrementViewCount(Long id);
} 