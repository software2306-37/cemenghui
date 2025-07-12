package com.cemenghui.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("course_video")
public class CourseVideo {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField("course_id")
    private Long courseId;
    
    @TableField("video_title")
    private String videoTitle;
    
    @TableField("video_url")
    private String videoUrl;
    
    @TableField("video_duration")
    private Integer videoDuration; // 视频时长(秒)
    
    @TableField("video_size")
    private Long videoSize; // 视频大小(字节)
    
    @TableField("video_description")
    private String videoDescription;
    
    @TableField("sort_order")
    private Integer sortOrder;
    
    @TableField("is_free")
    private Integer isFree; // 是否免费 0-收费 1-免费
    
    @TableField("status")
    private Integer status; // 状态 0-禁用 1-启用
    
    @TableField("create_time")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    
    // 便利方法
    public String getFormattedDuration() {
        if (videoDuration == null || videoDuration <= 0) {
            return "00:00";
        }
        int minutes = videoDuration / 60;
        int seconds = videoDuration % 60;
        return String.format("%02d:%02d", minutes, seconds);
    }
    
    public boolean isFreeVideo() {
        return isFree != null && isFree == 1;
    }
    
    public boolean isEnabled() {
        return status != null && status == 1;
    }
} 