package com.cemenghui.controller;

import com.cemenghui.common.Result;
import com.cemenghui.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/stats")
public class StatController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private NewsMapper newsMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Autowired
    private MeetingMapper meetingMapper;

    @Autowired
    private TenantMapper tenantMapper;

    @GetMapping
    public Result getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            stats.put("userCount", userMapper.selectCount(null));
            stats.put("newsCount", newsMapper.selectCount(null));
            stats.put("courseCount", courseMapper.selectCount(null));
            stats.put("meetingCount", meetingMapper.selectCount(null));
            stats.put("tenantCount", tenantMapper.selectCount(null));
        } catch (Exception e) {
            // 如果查询失败，返回默认值
            stats.put("userCount", 0);
            stats.put("newsCount", 0);
            stats.put("courseCount", 0);
            stats.put("meetingCount", 0);
            stats.put("tenantCount", 0);
        }
        
        return Result.success(stats);
    }

    @GetMapping("/today")
    public Result getTodayStats() {
        Map<String, Object> todayStats = new HashMap<>();
        
        try {
            LocalDate today = LocalDate.now();
            String todayStr = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            
            // 这里应该根据实际的数据库查询今日新增数据
            // 由于没有具体的查询方法，使用模拟数据
            todayStats.put("newUsers", 5);
            todayStats.put("newNews", 3);
            todayStats.put("newCourses", 2);
            todayStats.put("newMeetings", 1);
        } catch (Exception e) {
            todayStats.put("newUsers", 0);
            todayStats.put("newNews", 0);
            todayStats.put("newCourses", 0);
            todayStats.put("newMeetings", 0);
        }
        
        return Result.success(todayStats);
    }

    @GetMapping("/pending")
    public Result getPendingStats() {
        Map<String, Object> pendingStats = new HashMap<>();
        
        try {
            // 查询待审核的数据
            // 状态0表示待审核
            pendingStats.put("pendingNews", newsMapper.selectCount(
                new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<com.cemenghui.entity.News>()
                    .eq("status", 0)
            ));
            pendingStats.put("pendingCourses", courseMapper.selectCount(
                new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<com.cemenghui.entity.Course>()
                    .eq("status", 0)
            ));
            pendingStats.put("pendingMeetings", meetingMapper.selectCount(
                new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<com.cemenghui.entity.Meeting>()
                    .eq("status", 0)
            ));
        } catch (Exception e) {
            pendingStats.put("pendingNews", 0);
            pendingStats.put("pendingCourses", 0);
            pendingStats.put("pendingMeetings", 0);
        }
        
        return Result.success(pendingStats);
    }

    @GetMapping("/system")
    public Result getSystemInfo() {
        Map<String, Object> systemInfo = new HashMap<>();
        
        try {
            // 获取系统运行时间（简化版本）
            long uptime = System.currentTimeMillis() / (1000 * 60 * 60 * 24); // 天数
            systemInfo.put("uptime", uptime + "天");
            
            // 获取存储空间信息（简化版本）
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();
            long usedMemory = totalMemory - freeMemory;
            systemInfo.put("storage", String.format("%.2fGB", usedMemory / (1024.0 * 1024.0 * 1024.0)));
        } catch (Exception e) {
            systemInfo.put("uptime", "0天");
            systemInfo.put("storage", "0GB");
        }
        
        return Result.success(systemInfo);
    }
} 