package com.cemenghui.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.cemenghui.entity.Course;
import com.cemenghui.entity.CourseEnrollment;
import com.cemenghui.entity.CourseVideo;
import com.cemenghui.entity.UserVideoProgress;

import java.util.List;
import java.util.Map;

public interface CourseService extends IService<Course> {
    
    /**
     * 分页查询课程
     */
    Page<Course> pageCourses(int current, int size, String keyword, Integer status, Long authorId);
    
    /**
     * 审核课程
     */
    boolean auditCourse(Long id, Integer status, Long auditUserId);
    
    /**
     * 增加浏览量
     */
    void incrementViewCount(Long id);
    
    /**
     * 检查用户是否已报名课程
     */
    boolean isUserEnrolled(Long courseId, Long userId);
    
    /**
     * 用户报名课程
     */
    boolean enrollCourse(Long courseId, Long userId);
    
    /**
     * 获取用户的课程学习记录
     */
    CourseEnrollment getUserEnrollment(Long courseId, Long userId);
    
    /**
     * 更新学习进度
     */
    boolean updateLearningProgress(Long courseId, Long userId, Integer progress);
    
    /**
     * 开始学习课程
     */
    boolean startLearning(Long courseId, Long userId);
    
    /**
     * 完成课程学习
     */
    boolean completeCourse(Long courseId, Long userId);
    
    /**
     * 获取用户报名的课程数量
     */
    int getUserEnrolledCourseCount(Long userId);
    
    /**
     * 获取用户报名的课程列表
     */
    List<Map<String, Object>> getUserEnrolledCourses(Long userId);
    
    /**
     * 获取课程详情（包含用户学习状态）
     */
    Map<String, Object> getCourseWithLearningStatus(Long courseId, Long userId);
    
    /**
     * 检查用户是否已收藏
     */
    boolean isUserFavorited(String type, Long itemId, Long userId);
    
    /**
     * 添加收藏
     */
    boolean addFavorite(String type, Long itemId, Long userId);
    
    /**
     * 取消收藏
     */
    boolean removeFavorite(String type, Long itemId, Long userId);
    
    /**
     * 获取用户收藏数量
     */
    int getUserFavoriteCount(Long userId);
    
    /**
     * 获取用户收藏列表
     */
    List<Map<String, Object>> getUserFavorites(Long userId, String type);
    
    // ==================== 视频相关方法 ====================
    
    /**
     * 获取课程的视频列表
     */
    List<CourseVideo> getCourseVideos(Long courseId);
    
    /**
     * 获取课程的免费视频列表
     */
    List<CourseVideo> getFreeCourseVideos(Long courseId);
    
    /**
     * 获取用户可观看的课程视频列表（包含学习进度）
     */
    List<Map<String, Object>> getUserCourseVideos(Long courseId, Long userId);
    
    /**
     * 添加课程视频
     */
    boolean addCourseVideo(CourseVideo courseVideo);
    
    /**
     * 更新课程视频
     */
    boolean updateCourseVideo(CourseVideo courseVideo);
    
    /**
     * 删除课程视频
     */
    boolean deleteCourseVideo(Long videoId);
    
    /**
     * 更新用户视频观看进度
     */
    boolean updateVideoProgress(Long userId, Long videoId, Integer watchProgress, Integer totalWatchTime);
    
    /**
     * 获取用户视频学习进度
     */
    UserVideoProgress getUserVideoProgress(Long userId, Long videoId);
    
    /**
     * 标记视频为已完成
     */
    boolean markVideoCompleted(Long userId, Long videoId);
} 