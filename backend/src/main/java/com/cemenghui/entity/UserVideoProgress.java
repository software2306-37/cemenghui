package com.cemenghui.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("user_video_progress")
public class UserVideoProgress {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long userId;
    
    private Long courseId;
    
    private Long videoId;
    
    private Integer watchProgress; // 观看进度(秒)
    
    private BigDecimal watchPercentage; // 观看百分比
    
    private Integer isCompleted; // 是否完成 0-未完成 1-已完成
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastWatchTime; // 最后观看时间
    
    private Integer totalWatchTime; // 总观看时长(秒)
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    
    // 便利方法
    public boolean isVideoCompleted() {
        return isCompleted != null && isCompleted == 1;
    }
    
    public String getFormattedWatchProgress() {
        if (watchProgress == null || watchProgress <= 0) {
            return "00:00";
        }
        int minutes = watchProgress / 60;
        int seconds = watchProgress % 60;
        return String.format("%02d:%02d", minutes, seconds);
    }
    
    public String getFormattedTotalWatchTime() {
        if (totalWatchTime == null || totalWatchTime <= 0) {
            return "00:00";
        }
        int minutes = totalWatchTime / 60;
        int seconds = totalWatchTime % 60;
        return String.format("%02d:%02d", minutes, seconds);
    }
    
    public double getWatchPercentageValue() {
        return watchPercentage != null ? watchPercentage.doubleValue() : 0.0;
    }
} 