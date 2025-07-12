package com.cemenghui.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_favorite")
public class UserFavorite {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long userId;
    
    private String favoriteType; // 收藏类型：course, meeting, news
    
    private Long favoriteId; // 被收藏内容的ID
    
    private String favoriteTitle; // 被收藏内容的标题
    
    private String favoriteSummary; // 被收藏内容的摘要
    
    private String favoriteCover; // 被收藏内容的封面
    
    private String favoriteAuthor; // 被收藏内容的作者
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
} 