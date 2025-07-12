package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.cemenghui.entity.*;
import com.cemenghui.mapper.*;
import com.cemenghui.service.CourseService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements CourseService {

    @Autowired
    private CourseEnrollmentMapper enrollmentMapper;
    
    @Autowired
    private CourseVideoMapper courseVideoMapper;
    
    @Autowired
    private UserVideoProgressMapper userVideoProgressMapper;
    
    @Autowired
    private UserFavoriteMapper favoriteMapper;
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private MeetingMapper meetingMapper;
    
    @Autowired
    private NewsMapper newsMapper;

    @Override
    public Page<Course> pageCourses(int current, int size, String keyword, Integer status, Long authorId) {
        Page<Course> page = new Page<>(current, size);
        QueryWrapper<Course> queryWrapper = new QueryWrapper<>();
        
        if (StringUtils.isNotBlank(keyword)) {
            queryWrapper.like("course_name", keyword)
                    .or().like("course_summary", keyword)
                    .or().like("author", keyword);
        }
        
        if (status != null) {
            queryWrapper.eq("status", status);
        }
        
        if (authorId != null) {
            queryWrapper.eq("author_id", authorId);
        }
        
        queryWrapper.orderByDesc("sort_order").orderByDesc("create_time");
        return this.page(page, queryWrapper);
    }

    @Override
    public boolean auditCourse(Long id, Integer status, Long auditUserId) {
        Course course = this.getById(id);
        if (course != null) {
            course.setStatus(status);
            course.setAuditUserId(auditUserId);
            course.setAuditTime(LocalDateTime.now());
            return this.updateById(course);
        }
        return false;
    }

    @Override
    public void incrementViewCount(Long id) {
        Course course = this.getById(id);
        if (course != null) {
            course.setViewCount(course.getViewCount() == null ? 1 : course.getViewCount() + 1);
            this.updateById(course);
        }
    }

    @Override
    public boolean isUserEnrolled(Long courseId, Long userId) {
        if (courseId == null || userId == null) {
            return false;
        }
        
        try {
            QueryWrapper<CourseEnrollment> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("course_id", courseId)
                       .eq("user_id", userId)
                       .ne("status", 3); // 排除已取消的报名
            Long count = enrollmentMapper.selectCount(queryWrapper);
            return count != null && count > 0;
        } catch (Exception e) {
            System.out.println("检查课程报名状态失败: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean enrollCourse(Long courseId, Long userId) {
        try {
            // 检查是否已报名
            if (isUserEnrolled(courseId, userId)) {
                return false;
            }
            
            // 获取用户信息
            User user = userMapper.selectById(userId);
            if (user == null) {
                return false;
            }
            
            // 创建报名记录
            CourseEnrollment enrollment = new CourseEnrollment();
            enrollment.setCourseId(courseId);
            enrollment.setUserId(userId);
            enrollment.setUserName(user.getNickname() != null ? user.getNickname() : user.getUsername());
            enrollment.setUserEmail(user.getEmail());
            enrollment.setUserPhone(user.getPhone());
            enrollment.setProgress(0); // 初始进度为0
            enrollment.setStatus(0); // 已报名
            enrollment.setEnrollmentTime(LocalDateTime.now());
            enrollment.setCreateTime(LocalDateTime.now());
            
            return enrollmentMapper.insert(enrollment) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public CourseEnrollment getUserEnrollment(Long courseId, Long userId) {
        try {
            QueryWrapper<CourseEnrollment> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("course_id", courseId)
                       .eq("user_id", userId)
                       .ne("status", 3) // 排除已取消的报名
                       .orderByDesc("create_time")
                       .last("LIMIT 1");
            return enrollmentMapper.selectOne(queryWrapper);
        } catch (Exception e) {
            System.out.println("获取用户课程报名记录失败: " + e.getMessage());
            return null;
        }
    }

    @Override
    public boolean updateLearningProgress(Long courseId, Long userId, Integer progress) {
        try {
            CourseEnrollment enrollment = getUserEnrollment(courseId, userId);
            if (enrollment != null) {
                enrollment.setProgress(progress);
                enrollment.setUpdateTime(LocalDateTime.now());
                
                // 根据进度更新状态
                if (progress >= 100) {
                    enrollment.setStatus(2); // 已完成
                    enrollment.setCompleteTime(LocalDateTime.now());
                } else if (progress > 0) {
                    enrollment.setStatus(1); // 学习中
                }
                
                return enrollmentMapper.updateById(enrollment) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean startLearning(Long courseId, Long userId) {
        try {
            CourseEnrollment enrollment = getUserEnrollment(courseId, userId);
            if (enrollment != null && enrollment.getStatus() == 0) {
                enrollment.setStatus(1); // 学习中
                enrollment.setStartTime(LocalDateTime.now());
                enrollment.setProgress(Math.max(enrollment.getProgress() != null ? enrollment.getProgress() : 0, 5)); // 至少5%进度
                enrollment.setUpdateTime(LocalDateTime.now());
                return enrollmentMapper.updateById(enrollment) > 0;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean completeCourse(Long courseId, Long userId) {
        return updateLearningProgress(courseId, userId, 100);
    }

    @Override
    public int getUserEnrolledCourseCount(Long userId) {
        try {
            QueryWrapper<CourseEnrollment> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .ne("status", 3); // 排除已取消的报名
            Long count = enrollmentMapper.selectCount(queryWrapper);
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            System.err.println("查询用户课程数量失败: " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Map<String, Object>> getUserEnrolledCourses(Long userId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        try {
            // 查询用户的报名记录
            QueryWrapper<CourseEnrollment> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .ne("status", 3) // 排除已取消的报名
                       .orderByDesc("create_time");
            
            List<CourseEnrollment> enrollments = enrollmentMapper.selectList(queryWrapper);
            
            for (CourseEnrollment enrollment : enrollments) {
                Course course = this.getById(enrollment.getCourseId());
                if (course != null) {
                    Map<String, Object> courseMap = new HashMap<>();
                    courseMap.put("id", course.getId());
                    courseMap.put("title", course.getTitle());
                    courseMap.put("courseName", course.getCourseName());
                    courseMap.put("description", course.getDescription());
                    courseMap.put("courseSummary", course.getCourseSummary());
                    courseMap.put("coverImage", course.getCoverImage());
                    courseMap.put("instructor", course.getAuthor());
                    courseMap.put("author", course.getAuthor());
                    courseMap.put("duration", course.getDuration());
                    courseMap.put("enrollmentCount", course.getViewCount());
                    courseMap.put("viewCount", course.getViewCount());
                    courseMap.put("status", course.getStatus());
                    courseMap.put("createTime", course.getCreateTime());
                    courseMap.put("enrollTime", enrollment.getEnrollmentTime());
                    
                    // 学习进度和状态
                    courseMap.put("progress", enrollment.getProgress() != null ? enrollment.getProgress() : 0);
                    
                    String learningStatus;
                    switch (enrollment.getStatus()) {
                        case 0:
                            learningStatus = "未开始";
                            break;
                        case 1:
                            learningStatus = "学习中";
                            break;
                        case 2:
                            learningStatus = "已完成";
                            break;
                        default:
                            learningStatus = "未知状态";
                    }
                    courseMap.put("learningStatus", learningStatus);
                    
                    result.add(courseMap);
                }
            }
        } catch (Exception e) {
            System.err.println("查询用户课程列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }

    @Override
    public Map<String, Object> getCourseWithLearningStatus(Long courseId, Long userId) {
        Map<String, Object> result = new HashMap<>();
        
        // 获取课程信息
        Course course = this.getById(courseId);
        result.put("course", course);
        
        if (userId != null) {
            // 获取学习状态
            CourseEnrollment enrollment = getUserEnrollment(courseId, userId);
            result.put("enrollment", enrollment);
            result.put("isEnrolled", enrollment != null);
            
            if (enrollment != null) {
                result.put("progress", enrollment.getProgress() != null ? enrollment.getProgress() : 0);
                result.put("learningStatus", enrollment.getStatus());
            }
            
            // 检查是否已收藏
            result.put("isFavorited", isUserFavorited("course", courseId, userId));
        } else {
            result.put("enrollment", null);
            result.put("isEnrolled", false);
            result.put("progress", 0);
            result.put("learningStatus", -1);
            result.put("isFavorited", false);
        }
        
        return result;
    }

    @Override
    public boolean isUserFavorited(String type, Long itemId, Long userId) {
        if (itemId == null || userId == null) {
            return false;
        }
        
        try {
            QueryWrapper<UserFavorite> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .eq("favorite_type", type)
                       .eq("favorite_id", itemId);
            Long count = favoriteMapper.selectCount(queryWrapper);
            return count != null && count > 0;
        } catch (Exception e) {
            System.out.println("检查收藏状态失败: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean addFavorite(String type, Long itemId, Long userId) {
        try {
            // 检查是否已收藏
            if (isUserFavorited(type, itemId, userId)) {
                return false;
            }
            
            // 获取要收藏的内容信息
            String title = "";
            String summary = "";
            String cover = "";
            String author = "";
            
            if ("course".equals(type)) {
                Course course = this.getById(itemId);
                if (course != null) {
                    title = course.getTitle();
                    summary = course.getDescription();
                    cover = course.getCoverImage();
                    author = course.getAuthor();
                }
            } else if ("meeting".equals(type)) {
                Meeting meeting = meetingMapper.selectById(itemId);
                if (meeting != null) {
                    title = meeting.getMeetingName();
                    summary = meeting.getMeetingContent();
                    cover = meeting.getCoverImage();
                    author = meeting.getOrganizer();
                }
            } else if ("news".equals(type)) {
                News news = newsMapper.selectById(itemId);
                if (news != null) {
                    title = news.getTitle();
                    summary = news.getSummary();
                    cover = news.getCoverImage();
                    author = news.getAuthor();
                }
            }
            
            // 创建收藏记录
            UserFavorite favorite = new UserFavorite();
            favorite.setUserId(userId);
            favorite.setFavoriteType(type);
            favorite.setFavoriteId(itemId);
            favorite.setFavoriteTitle(title);
            favorite.setFavoriteSummary(summary);
            favorite.setFavoriteCover(cover);
            favorite.setFavoriteAuthor(author);
            favorite.setCreateTime(LocalDateTime.now());
            
            return favoriteMapper.insert(favorite) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeFavorite(String type, Long itemId, Long userId) {
        try {
            QueryWrapper<UserFavorite> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .eq("favorite_type", type)
                       .eq("favorite_id", itemId);
            
            return favoriteMapper.delete(queryWrapper) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getUserFavoriteCount(Long userId) {
        try {
            QueryWrapper<UserFavorite> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId);
            Long count = favoriteMapper.selectCount(queryWrapper);
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            System.err.println("查询用户收藏数量失败: " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Map<String, Object>> getUserFavorites(Long userId, String type) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        try {
            QueryWrapper<UserFavorite> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId);
            if (StringUtils.isNotBlank(type)) {
                queryWrapper.eq("favorite_type", type);
            }
            queryWrapper.orderByDesc("create_time");
            
            List<UserFavorite> favorites = favoriteMapper.selectList(queryWrapper);
            
            for (UserFavorite favorite : favorites) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", favorite.getFavoriteId());
                item.put("type", favorite.getFavoriteType());
                item.put("title", favorite.getFavoriteTitle());
                item.put("summary", favorite.getFavoriteSummary());
                item.put("author", favorite.getFavoriteAuthor());
                item.put("coverImage", favorite.getFavoriteCover());
                item.put("favoriteTime", favorite.getCreateTime());
                
                result.add(item);
            }
        } catch (Exception e) {
            System.err.println("查询用户收藏列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
    
    // ==================== 视频相关方法实现 ====================
    
    @Override
    public List<CourseVideo> getCourseVideos(Long courseId) {
        try {
            return courseVideoMapper.getVideosByCourseId(courseId);
        } catch (Exception e) {
            System.err.println("获取课程视频列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    @Override
    public List<CourseVideo> getFreeCourseVideos(Long courseId) {
        try {
            return courseVideoMapper.getFreeVideosByCourseId(courseId);
        } catch (Exception e) {
            System.err.println("获取免费课程视频列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    @Override
    public List<Map<String, Object>> getUserCourseVideos(Long courseId, Long userId) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        try {
            // 检查用户是否已报名
            boolean isEnrolled = isUserEnrolled(courseId, userId);
            
            List<CourseVideo> videos;
            if (isEnrolled) {
                // 已报名用户可以看到所有视频
                videos = getCourseVideos(courseId);
            } else {
                // 未报名用户只能看到免费视频
                videos = getFreeCourseVideos(courseId);
            }
            
            // 获取用户的观看进度
            List<UserVideoProgress> progressList = userVideoProgressMapper.getUserCourseProgress(userId, courseId);
            Map<Long, UserVideoProgress> progressMap = new HashMap<>();
            for (UserVideoProgress progress : progressList) {
                progressMap.put(progress.getVideoId(), progress);
            }
            
            for (CourseVideo video : videos) {
                Map<String, Object> videoMap = new HashMap<>();
                videoMap.put("id", video.getId());
                videoMap.put("courseId", video.getCourseId());
                videoMap.put("title", video.getVideoTitle());
                videoMap.put("videoUrl", video.getVideoUrl());
                videoMap.put("duration", video.getVideoDuration());
                videoMap.put("formattedDuration", video.getFormattedDuration());
                videoMap.put("description", video.getVideoDescription());
                videoMap.put("sortOrder", video.getSortOrder());
                videoMap.put("isFree", video.isFreeVideo());
                videoMap.put("canWatch", isEnrolled || video.isFreeVideo());
                
                // 添加学习进度信息
                UserVideoProgress progress = progressMap.get(video.getId());
                if (progress != null) {
                    videoMap.put("watchProgress", progress.getWatchProgress());
                    videoMap.put("watchPercentage", progress.getWatchPercentageValue());
                    videoMap.put("isCompleted", progress.isVideoCompleted());
                    videoMap.put("lastWatchTime", progress.getLastWatchTime());
                    videoMap.put("totalWatchTime", progress.getTotalWatchTime());
                } else {
                    videoMap.put("watchProgress", 0);
                    videoMap.put("watchPercentage", 0.0);
                    videoMap.put("isCompleted", false);
                    videoMap.put("lastWatchTime", null);
                    videoMap.put("totalWatchTime", 0);
                }
                
                result.add(videoMap);
            }
        } catch (Exception e) {
            System.err.println("获取用户课程视频列表失败: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
    
    @Override
    public boolean addCourseVideo(CourseVideo courseVideo) {
        try {
            courseVideo.setCreateTime(LocalDateTime.now());
            courseVideo.setUpdateTime(LocalDateTime.now());
            System.out.println("正在插入视频数据: " + courseVideo);
            int result = courseVideoMapper.insert(courseVideo);
            System.out.println("插入结果: " + result + ", 生成的视频ID: " + courseVideo.getId());
            return result > 0;
        } catch (Exception e) {
            System.err.println("添加课程视频失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean updateCourseVideo(CourseVideo courseVideo) {
        try {
            courseVideo.setUpdateTime(LocalDateTime.now());
            return courseVideoMapper.updateById(courseVideo) > 0;
        } catch (Exception e) {
            System.err.println("更新课程视频失败: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteCourseVideo(Long videoId) {
        try {
            return courseVideoMapper.deleteById(videoId) > 0;
        } catch (Exception e) {
            System.err.println("删除课程视频失败: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean updateVideoProgress(Long userId, Long videoId, Integer watchProgress, Integer totalWatchTime) {
        try {
            // 获取视频信息
            CourseVideo video = courseVideoMapper.selectById(videoId);
            if (video == null) {
                return false;
            }
            
            // 查找现有进度记录
            UserVideoProgress progress = userVideoProgressMapper.getUserVideoProgress(userId, videoId);
            
            if (progress == null) {
                // 创建新的进度记录
                progress = new UserVideoProgress();
                progress.setUserId(userId);
                progress.setCourseId(video.getCourseId());
                progress.setVideoId(videoId);
                progress.setWatchProgress(watchProgress);
                progress.setTotalWatchTime(totalWatchTime);
                progress.setLastWatchTime(LocalDateTime.now());
                progress.setCreateTime(LocalDateTime.now());
                progress.setUpdateTime(LocalDateTime.now());
                
                // 计算观看百分比
                if (video.getVideoDuration() != null && video.getVideoDuration() > 0) {
                    double percentage = (double) watchProgress / video.getVideoDuration() * 100;
                    progress.setWatchPercentage(new java.math.BigDecimal(percentage));
                    
                    // 如果观看超过90%，标记为已完成
                    if (percentage >= 90) {
                        progress.setIsCompleted(1);
                    }
                }
                
                return userVideoProgressMapper.insert(progress) > 0;
            } else {
                // 更新现有记录
                progress.setWatchProgress(Math.max(progress.getWatchProgress(), watchProgress));
                progress.setTotalWatchTime(progress.getTotalWatchTime() + totalWatchTime);
                progress.setLastWatchTime(LocalDateTime.now());
                progress.setUpdateTime(LocalDateTime.now());
                
                // 重新计算观看百分比
                if (video.getVideoDuration() != null && video.getVideoDuration() > 0) {
                    double percentage = (double) progress.getWatchProgress() / video.getVideoDuration() * 100;
                    progress.setWatchPercentage(new java.math.BigDecimal(percentage));
                    
                    // 如果观看超过90%，标记为已完成
                    if (percentage >= 90) {
                        progress.setIsCompleted(1);
                    }
                }
                
                return userVideoProgressMapper.updateById(progress) > 0;
            }
        } catch (Exception e) {
            System.err.println("更新视频观看进度失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public UserVideoProgress getUserVideoProgress(Long userId, Long videoId) {
        try {
            return userVideoProgressMapper.getUserVideoProgress(userId, videoId);
        } catch (Exception e) {
            System.err.println("获取用户视频学习进度失败: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    public boolean markVideoCompleted(Long userId, Long videoId) {
        try {
            UserVideoProgress progress = getUserVideoProgress(userId, videoId);
            if (progress != null) {
                progress.setIsCompleted(1);
                progress.setWatchPercentage(new java.math.BigDecimal(100));
                progress.setUpdateTime(LocalDateTime.now());
                return userVideoProgressMapper.updateById(progress) > 0;
            }
            return false;
        } catch (Exception e) {
            System.err.println("标记视频完成失败: " + e.getMessage());
            return false;
        }
    }
} 