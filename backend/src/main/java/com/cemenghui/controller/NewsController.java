package com.cemenghui.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.common.Result;
import com.cemenghui.entity.News;
import com.cemenghui.entity.User;
import com.cemenghui.service.NewsService;
import com.cemenghui.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/news")
public class NewsController {

    @Autowired
    private NewsService newsService;
    
    @Autowired
    private UserService userService;

    /**
     * 分页查询动态列表
     */
    @GetMapping("/page")
    public Result<Map<String, Object>> pageNews(@RequestParam(defaultValue = "1") int current,
                                                @RequestParam(defaultValue = "10") int size,
                                                @RequestParam(required = false) String keyword,
                                                @RequestParam(required = false) Integer status,
                                                @RequestParam(required = false) Long authorId,
                                                @RequestParam(required = false) String category,
                                                @RequestParam(required = false) String startDate,
                                                @RequestParam(required = false) String endDate) {
        Page<News> page = newsService.pageNews(current, size, keyword, status, authorId, category, startDate, endDate);
        
        // 为每个动态添加企业信息
        List<Map<String, Object>> enrichedRecords = new ArrayList<>();
        for (News news : page.getRecords()) {
            Map<String, Object> newsMap = new HashMap<>();
            newsMap.put("id", news.getId());
            newsMap.put("title", news.getTitle());
            newsMap.put("summary", news.getSummary());
            newsMap.put("content", news.getContent());
            newsMap.put("coverImage", news.getCoverImage());
            newsMap.put("author", news.getAuthor());
            newsMap.put("authorId", news.getAuthorId());
            newsMap.put("category", news.getCategory());
            newsMap.put("status", news.getStatus());
            newsMap.put("viewCount", news.getViewCount());
            newsMap.put("createTime", news.getCreateTime());
            newsMap.put("updateTime", news.getUpdateTime());
            
            // 获取作者企业信息
            if (news.getAuthorId() != null) {
                try {
                    User author = userService.getById(news.getAuthorId());
                    if (author != null && author.getCompanyName() != null) {
                        newsMap.put("publisherCompany", author.getCompanyName());
                    }
                } catch (Exception e) {
                    System.err.println("获取作者企业信息失败: " + e.getMessage());
                }
            }
            
            enrichedRecords.add(newsMap);
        }
        
        // 构建返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("records", enrichedRecords);
        result.put("total", page.getTotal());
        result.put("current", page.getCurrent());
        result.put("size", page.getSize());
        result.put("pages", page.getPages());
        
        return Result.success(result);
    }

    /**
     * 获取动态详情
     */
    @GetMapping("/{id}")
    public Result<Map<String, Object>> getNews(@PathVariable Long id) {
        News news = newsService.getById(id);
        if (news != null) {
            // 增加浏览量
            newsService.incrementViewCount(id);
            
            // 构建返回结果，包含企业信息
            Map<String, Object> result = new HashMap<>();
            result.put("id", news.getId());
            result.put("title", news.getTitle());
            result.put("summary", news.getSummary());
            result.put("content", news.getContent());
            result.put("coverImage", news.getCoverImage());
            result.put("author", news.getAuthor());
            result.put("authorId", news.getAuthorId());
            result.put("category", news.getCategory());
            result.put("status", news.getStatus());
            result.put("viewCount", news.getViewCount());
            result.put("createTime", news.getCreateTime());
            result.put("updateTime", news.getUpdateTime());
            
            // 获取作者企业信息
            if (news.getAuthorId() != null) {
                try {
                    User author = userService.getById(news.getAuthorId());
                    if (author != null && author.getCompanyName() != null) {
                        result.put("publisherCompany", author.getCompanyName());
                    }
                } catch (Exception e) {
                    System.err.println("获取作者企业信息失败: " + e.getMessage());
                }
            }
            
            return Result.success(result);
        } else {
            return Result.error("动态不存在");
        }
    }

    /**
     * 发布动态
     */
    @PostMapping
    public Result<String> createNews(@RequestBody News news, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        news.setAuthor(currentUser.getNickname() != null ? currentUser.getNickname() : currentUser.getUsername());
        news.setAuthorId(currentUser.getId());
        news.setViewCount(0);
        
        // 管理员发布的直接通过，企业用户发布的需要审核
        if ("ADMIN".equals(currentUser.getRole())) {
            news.setStatus(1);
        } else {
            news.setStatus(0);
        }
        
        if (newsService.save(news)) {
            return Result.success("发布成功");
        } else {
            return Result.error("发布失败");
        }
    }

    /**
     * 更新动态
     */
    @PutMapping("/{id}")
    public Result<String> updateNews(@PathVariable Long id, @RequestBody News news, HttpSession session) {
        System.out.println("开始更改动态");
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        News existingNews = newsService.getById(id);
        if (existingNews == null) {
            return Result.error("动态不存在");
        }
        
        // 只有管理员或者作者本人可以编辑
        if (!"ADMIN".equals(currentUser.getRole()) && !existingNews.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限编辑");
        }
        
        news.setId(id);
        news.setAuthor(existingNews.getAuthor());
        news.setAuthorId(existingNews.getAuthorId());
        news.setViewCount(existingNews.getViewCount());
        
        // 企业用户编辑后需要重新审核
        if (!"ADMIN".equals(currentUser.getRole())) {
            news.setStatus(0);
        }
        
        if (newsService.updateById(news)) {
            return Result.success("更新成功");
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 删除动态
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteNews(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        News existingNews = newsService.getById(id);
        if (existingNews == null) {
            return Result.error("动态不存在");
        }
        
        // 只有管理员或者作者本人可以删除
        if (!"ADMIN".equals(currentUser.getRole()) && !existingNews.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限删除");
        }
        
        if (newsService.removeById(id)) {
            return Result.success("删除成功");
        } else {
            return Result.error("删除失败");
        }
    }

    /**
     * 审核动态
     */
    @PostMapping("/{id}/audit")
    public Result<String> auditNews(@PathVariable Long id, @RequestBody Map<String, Integer> auditForm, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限审核");
        }
        
        Integer status = auditForm.get("status");
        if (newsService.auditNews(id, status, currentUser.getId())) {
            return Result.success("审核成功");
        } else {
            return Result.error("审核失败");
        }
    }

    @DeleteMapping("/batch")
    public Result batchDelete(@RequestBody Map<String, List<Long>> params) {
        try {
            List<Long> ids = params.get("ids");
            newsService.removeByIds(ids);
            return Result.success("批量删除成功");
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }

    @PostMapping("/batch/audit")
    public Result batchAudit(@RequestBody Map<String, Object> params) {
        try {
            List<Long> ids = (List<Long>) params.get("ids");
            Integer status = (Integer) params.get("status");
            
            for (Long id : ids) {
                News news = new News();
                news.setId(id);
                news.setStatus(status);
                newsService.updateById(news);
            }
            
            return Result.success("批量审核成功");
        } catch (Exception e) {
            return Result.error("批量审核失败：" + e.getMessage());
        }
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> export(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Long authorId) {
        
        try {
            QueryWrapper<News> queryWrapper = new QueryWrapper<>();
            
            if (StringUtils.hasText(keyword)) {
                queryWrapper.and(wrapper -> wrapper
                    .like("title", keyword)
                    .or().like("summary", keyword)
                    .or().like("content", keyword)
                );
            }
            
            if (status != null) {
                queryWrapper.eq("status", status);
            }
            
            if (authorId != null) {
                queryWrapper.eq("author_id", authorId);
            }
            
            queryWrapper.orderByDesc("create_time");
            
            List<News> newsList = newsService.list(queryWrapper);
            
            // 简化的CSV导出
            StringBuilder csv = new StringBuilder();
            // 添加UTF-8 BOM头
            csv.append("\uFEFF");
            csv.append("Title,Author,Status,Summary,ViewCount,CreateTime\n");
            
            for (News news : newsList) {
                String statusText = "";
                if (news.getStatus() == 0) statusText = "Pending";
                else if (news.getStatus() == 1) statusText = "Published";
                else if (news.getStatus() == 2) statusText = "Rejected";
                
                csv.append(news.getTitle() != null ? news.getTitle().replace(",", ";") : "").append(",")
                   .append(news.getAuthor() != null ? news.getAuthor() : "").append(",")
                   .append(statusText).append(",")
                   .append(news.getSummary() != null ? news.getSummary().replace(",", ";") : "").append(",")
                   .append(news.getViewCount() != null ? news.getViewCount() : 0).append(",")
                   .append(news.getCreateTime() != null ? news.getCreateTime() : "").append("\n");
            }
            
            byte[] data = csv.toString().getBytes("UTF-8");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            String fileName = "news_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
            headers.setContentDispositionFormData("attachment", fileName);
            
            return ResponseEntity.ok()
                .headers(headers)
                .body(data);
                
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
} 