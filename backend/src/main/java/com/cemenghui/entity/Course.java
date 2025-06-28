package com.cemenghui.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("course")
public class Course {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @JsonIgnore
    private String courseName;
    
    @JsonIgnore
    private String courseSummary;
    
    private String coverImage;
    
    private String videoUrl;
    
    private String author;
    
    private Long authorId;
    
    private Integer sortOrder;
    
    private Integer status;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime auditTime;
    
    private Long auditUserId;
    
    private Integer viewCount;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    
    // 为前端提供便利的getter方法
    @JsonProperty("title")
    public String getTitle() {
        return courseName;
    }
    
    @JsonProperty("description") 
    public String getDescription() {
        return courseSummary;
    }
    
    // 为前端提供便利的setter方法
    @JsonProperty("title")
    public void setTitle(String title) {
        this.courseName = title;
    }
    
    @JsonProperty("description")
    public void setDescription(String description) {
        this.courseSummary = description;
    }
    
    public Integer getPrice() {
        // 模拟价格，实际应该从数据库字段获取
        return 299;
    }
    
    public Integer getDuration() {
        // 模拟时长，实际应该从数据库字段获取
        return 20;
    }
    
    public String[] getTags() {
        // 模拟标签，实际应该从数据库字段获取
        return new String[]{"测试", "技术"};
    }
} 