package com.cemenghui.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("meeting_feedback")
public class MeetingFeedback {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long meetingId;
    
    private Long userId;
    
    private String userName;
    
    // 基本信息
    private String companyName; // 单位名称
    private String gender; // 性别
    private String userPhone; // 手机号码
    private String userEmail; // 电子邮箱
    
    // 到达信息
    private String arrivalMethod; // 到达方式
    private String arrivalInfo; // 到达车次/航班
    private String arrivalTime; // 到达时间
    
    // 评价信息
    private Integer rating; // 评分 1-5分
    private String content; // 回执内容
    private String suggestions; // 改进建议
    private Integer organizationRating; // 组织评分 1-5分
    private Integer contentRating; // 内容评分 1-5分
    private Integer venueRating; // 场地评分 1-5分
    
    private String attachments; // 附件路径，多个用逗号分隔
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime submitTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
} 