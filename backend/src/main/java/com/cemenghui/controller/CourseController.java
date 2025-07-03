package com.cemenghui.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.common.Result;
import com.cemenghui.entity.Course;
import com.cemenghui.entity.CourseVideo;
import com.cemenghui.entity.User;
import com.cemenghui.entity.UserVideoProgress;
import com.cemenghui.service.CourseService;
import com.cemenghui.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;
    
    @Autowired
    private UserService userService;

    /**
     * 分页查询课程列表
     */
    @GetMapping("/page")
    public Result<Page<Course>> pageCourses(@RequestParam(defaultValue = "1") int current,
                                           @RequestParam(defaultValue = "10") int size,
                                           @RequestParam(required = false) String keyword,
                                           @RequestParam(required = false) Integer status,
                                           @RequestParam(required = false) Long authorId) {
        Page<Course> page = courseService.pageCourses(current, size, keyword, status, authorId);
        return Result.success(page);
    }

    /**
     * 获取课程详情
     */
    @GetMapping("/{id}")
    public Result<Course> getCourse(@PathVariable Long id) {
        Course course = courseService.getById(id);
        if (course != null) {
            // 增加浏览量
            courseService.incrementViewCount(id);
            return Result.success(course);
        } else {
            return Result.error("课程不存在");
        }
    }
    
    /**
     * 获取课程详情（包含学习状态）
     */
    @GetMapping("/{id}/detail")
    public Result<Map<String, Object>> getCourseDetail(@PathVariable Long id, HttpServletRequest request) {
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        // 获取用户ID
        Long userId = null;
        String userIdHeader = request.getHeader("X-User-Id");
        if (userIdHeader != null) {
            try {
                userId = Long.parseLong(userIdHeader);
            } catch (NumberFormatException e) {
                // 忽略解析错误
            }
        }
        
        // 获取课程详情和学习状态
        Map<String, Object> result = courseService.getCourseWithLearningStatus(id, userId);
        
        // 增加浏览量
        courseService.incrementViewCount(id);
        
        return Result.success(result);
    }

    /**
     * 课程报名/开始学习
     */
    @PostMapping("/{id}/enroll")
    public Result<String> enrollCourse(@PathVariable Long id, HttpServletRequest request) {
        // 获取用户ID
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        if (course.getStatus() != 1) {
            return Result.error("课程未发布，无法报名");
        }
        
        // 检查是否已报名
        if (courseService.isUserEnrolled(id, userId)) {
            return Result.error("您已经报名了该课程");
        }
        
        // 报名课程
        if (courseService.enrollCourse(id, userId)) {
            return Result.success("报名成功，开始学习吧！");
        } else {
            return Result.error("报名失败，请稍后重试");
        }
    }
    
    /**
     * 开始学习课程
     */
    @PostMapping("/{id}/start")
    public Result<String> startLearning(@PathVariable Long id, HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        if (!courseService.isUserEnrolled(id, userId)) {
            return Result.error("请先报名该课程");
        }
        
        if (courseService.startLearning(id, userId)) {
            return Result.success("开始学习成功");
        } else {
            return Result.error("开始学习失败，请稍后重试");
        }
    }
    
    /**
     * 更新学习进度
     */
    @PostMapping("/{id}/progress")
    public Result<String> updateProgress(@PathVariable Long id, @RequestParam Integer progress, HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        if (!courseService.isUserEnrolled(id, userId)) {
            return Result.error("请先报名该课程");
        }
        
        if (courseService.updateLearningProgress(id, userId, progress)) {
            return Result.success("学习进度更新成功");
        } else {
            return Result.error("学习进度更新失败");
        }
    }
    
    /**
     * 收藏课程
     */
    @PostMapping("/{id}/favorite")
    public Result<String> addToFavorite(@PathVariable Long id, HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        if (courseService.isUserFavorited("course", id, userId)) {
            return Result.error("已收藏该课程");
        }
        
        if (courseService.addFavorite("course", id, userId)) {
            return Result.success("收藏成功");
        } else {
            return Result.error("收藏失败，请稍后重试");
        }
    }
    
    /**
     * 取消收藏课程
     */
    @DeleteMapping("/{id}/favorite")
    public Result<String> removeFromFavorite(@PathVariable Long id, HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        if (courseService.removeFavorite("course", id, userId)) {
            return Result.success("取消收藏成功");
        } else {
            return Result.error("取消收藏失败，请稍后重试");
        }
    }
    
    /**
     * 从请求中获取用户ID的辅助方法
     */
    private Long getUserIdFromRequest(HttpServletRequest request) {
        // 优先从请求头获取
        String userIdHeader = request.getHeader("X-User-Id");
        if (userIdHeader != null) {
            try {
                return Long.parseLong(userIdHeader);
            } catch (NumberFormatException e) {
                // 忽略解析错误
            }
        }
        
        // 兜底方案：从session获取
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                return user.getId();
            }
        }
        
        return null;
    }

    /**
     * 添加课程
     */
    @PostMapping
    public Result<Map<String, Object>> createCourse(@RequestBody Course course, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        course.setAuthor(currentUser.getNickname() != null ? currentUser.getNickname() : currentUser.getUsername());
        course.setAuthorId(currentUser.getId());
        course.setViewCount(0);
        
        // 管理员发布的直接通过，企业用户发布的需要审核
        if ("ADMIN".equals(currentUser.getRole())) {
            course.setStatus(1);
        } else {
            course.setStatus(0);
        }
        
        if (courseService.save(course)) {
            Map<String, Object> result = new HashMap<>();
            result.put("id", course.getId());
            result.put("message", "添加成功");
            return Result.success(result);
        } else {
            return Result.error("添加失败");
        }
    }

    /**
     * 更新课程
     */
    @PutMapping("/{id}")
    public Result<String> updateCourse(@PathVariable Long id, @RequestBody Course course, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Course existingCourse = courseService.getById(id);
        if (existingCourse == null) {
            return Result.error("课程不存在");
        }
        
        // 只有管理员或者作者本人可以编辑
        if (!"ADMIN".equals(currentUser.getRole()) && !existingCourse.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限编辑");
        }
        
        course.setId(id);
        course.setAuthor(existingCourse.getAuthor());
        course.setAuthorId(existingCourse.getAuthorId());
        course.setViewCount(existingCourse.getViewCount());
        
        // 企业用户编辑后需要重新审核
        if (!"ADMIN".equals(currentUser.getRole())) {
            course.setStatus(0);
        }
        
        if (courseService.updateById(course)) {
            return Result.success("更新成功");
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 删除课程
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteCourse(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Course existingCourse = courseService.getById(id);
        if (existingCourse == null) {
            return Result.error("课程不存在");
        }
        
        // 只有管理员或者作者本人可以删除
        if (!"ADMIN".equals(currentUser.getRole()) && !existingCourse.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限删除");
        }
        
        if (courseService.removeById(id)) {
            return Result.success("删除成功");
        } else {
            return Result.error("删除失败");
        }
    }

    /**
     * 审核课程
     */
    @PostMapping("/{id}/audit")
    public Result<String> auditCourse(@PathVariable Long id, @RequestBody Map<String, Integer> auditForm, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限审核");
        }
        
        Integer status = auditForm.get("status");
        if (courseService.auditCourse(id, status, currentUser.getId())) {
            return Result.success("审核成功");
        } else {
            return Result.error("审核失败");
        }
    }

    @DeleteMapping("/batch")
    public Result batchDelete(@RequestBody Map<String, List<Long>> params) {
        try {
            List<Long> ids = params.get("ids");
            courseService.removeByIds(ids);
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
                Course course = new Course();
                course.setId(id);
                course.setStatus(status);
                courseService.updateById(course);
            }
            
            return Result.success("批量审核成功");
        } catch (Exception e) {
            return Result.error("批量审核失败：" + e.getMessage());
        }
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> export(@RequestParam(required = false) String keyword) {
        try {
            QueryWrapper<Course> queryWrapper = new QueryWrapper<>();
            
            if (StringUtils.hasText(keyword)) {
                queryWrapper.and(wrapper -> wrapper
                    .like("title", keyword)
                    .or().like("description", keyword)
                );
            }
            
            queryWrapper.orderByDesc("create_time");
            
            List<Course> courseList = courseService.list(queryWrapper);
            
            // 简化的CSV导出
            StringBuilder csv = new StringBuilder();
            // 添加UTF-8 BOM头
            csv.append("\uFEFF");
            csv.append("Title,Author,Status,Description,SortOrder,ViewCount,CreateTime\n");
            
            for (Course course : courseList) {
                String statusText = "";
                if (course.getStatus() == 0) statusText = "Pending";
                else if (course.getStatus() == 1) statusText = "Published";
                else if (course.getStatus() == 2) statusText = "Rejected";
                
                csv.append(course.getTitle() != null ? course.getTitle().replace(",", ";") : "").append(",")
                   .append(course.getAuthor() != null ? course.getAuthor() : "").append(",")
                   .append(statusText).append(",")
                   .append(course.getDescription() != null ? course.getDescription().replace(",", ";") : "").append(",")
                   .append(course.getSortOrder() != null ? course.getSortOrder() : 0).append(",")
                   .append(course.getViewCount() != null ? course.getViewCount() : 0).append(",")
                   .append(course.getCreateTime() != null ? course.getCreateTime() : "").append("\n");
            }
            
            byte[] data = csv.toString().getBytes("UTF-8");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            String fileName = "courses_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
            headers.setContentDispositionFormData("attachment", fileName);
            
            return ResponseEntity.ok()
                .headers(headers)
                .body(data);
                
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // ==================== 视频相关API ====================
    
    /**
     * 获取课程视频列表
     */
    @GetMapping("/{id}/videos")
    public Result<List<Map<String, Object>>> getCourseVideos(@PathVariable Long id, 
                                                            @RequestParam(required = false, defaultValue = "false") Boolean admin,
                                                            HttpServletRequest request) {
        // 如果是管理端请求，直接返回所有视频
        if (admin != null && admin) {
            List<CourseVideo> videos = courseService.getCourseVideos(id);
            List<Map<String, Object>> result = new ArrayList<>();
            
            for (CourseVideo video : videos) {
                Map<String, Object> videoMap = new HashMap<>();
                videoMap.put("id", video.getId());
                videoMap.put("courseId", video.getCourseId());
                videoMap.put("videoTitle", video.getVideoTitle());
                videoMap.put("title", video.getVideoTitle());
                videoMap.put("videoUrl", video.getVideoUrl());
                videoMap.put("videoDuration", video.getVideoDuration());
                videoMap.put("duration", video.getVideoDuration());
                videoMap.put("formattedDuration", video.getFormattedDuration());
                videoMap.put("videoDescription", video.getVideoDescription());
                videoMap.put("description", video.getVideoDescription());
                videoMap.put("sortOrder", video.getSortOrder());
                videoMap.put("isFree", video.getIsFree());
                videoMap.put("status", video.getStatus());
                videoMap.put("createTime", video.getCreateTime());
                videoMap.put("updateTime", video.getUpdateTime());
                result.add(videoMap);
            }
            
            return Result.success(result);
        }
        
        // 普通用户请求，返回根据权限过滤的视频
        Long userId = getUserIdFromRequest(request);
        List<Map<String, Object>> videos = courseService.getUserCourseVideos(id, userId);
        return Result.success(videos);
    }
    
    /**
     * 添加课程视频
     */
    @PostMapping("/{id}/videos")
    public Result<String> addCourseVideo(@PathVariable Long id, @RequestBody Map<String, Object> videoData, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        // 只有管理员或者作者本人可以添加视频
        if (!"ADMIN".equals(currentUser.getRole()) && !course.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限添加视频");
        }
        
        // 构建CourseVideo对象
        CourseVideo courseVideo = new CourseVideo();
        courseVideo.setCourseId(id);
        courseVideo.setVideoTitle((String) videoData.get("title"));
        courseVideo.setVideoUrl((String) videoData.get("videoUrl"));
        courseVideo.setVideoDescription((String) videoData.get("description"));
        
        System.out.println("接收到的视频数据: " + videoData);
        
        // 处理数值类型字段
        if (videoData.get("duration") != null) {
            courseVideo.setVideoDuration(Integer.valueOf(videoData.get("duration").toString()));
        } else {
            courseVideo.setVideoDuration(0);
        }
        
        if (videoData.get("sortOrder") != null) {
            courseVideo.setSortOrder(Integer.valueOf(videoData.get("sortOrder").toString()));
        } else {
            courseVideo.setSortOrder(1);
        }
        
        if (videoData.get("isFree") != null) {
            Object isFreeValue = videoData.get("isFree");
            if (isFreeValue instanceof Boolean) {
                courseVideo.setIsFree((Boolean) isFreeValue ? 1 : 0);
            } else {
                courseVideo.setIsFree(Integer.valueOf(isFreeValue.toString()));
            }
        } else {
            courseVideo.setIsFree(0); // 默认收费
        }
        
        if (videoData.get("status") != null) {
            Object statusValue = videoData.get("status");
            if (statusValue instanceof Boolean) {
                courseVideo.setStatus((Boolean) statusValue ? 1 : 0);
            } else {
                courseVideo.setStatus(Integer.valueOf(statusValue.toString()));
            }
        } else {
            courseVideo.setStatus(1); // 默认启用
        }
        
        courseVideo.setCreateTime(LocalDateTime.now());
        courseVideo.setUpdateTime(LocalDateTime.now());
        
        System.out.println("构建的CourseVideo对象: " + courseVideo);
        
        if (courseService.addCourseVideo(courseVideo)) {
            System.out.println("视频添加成功，课程ID: " + id + ", 视频ID: " + courseVideo.getId());
            return Result.success("添加视频成功");
        } else {
            System.out.println("视频添加失败，课程ID: " + id);
            return Result.error("添加视频失败");
        }
    }
    
    /**
     * 更新课程视频
     */
    @PutMapping("/{id}/videos/{videoId}")
    public Result<String> updateCourseVideo(@PathVariable Long id, @PathVariable Long videoId, 
                                          @RequestBody Map<String, Object> videoData, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        // 只有管理员或者作者本人可以编辑视频
        if (!"ADMIN".equals(currentUser.getRole()) && !course.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限编辑视频");
        }
        
        // 构建CourseVideo对象
        CourseVideo courseVideo = new CourseVideo();
        courseVideo.setId(videoId);
        courseVideo.setCourseId(id);
        courseVideo.setVideoTitle((String) videoData.get("title"));
        courseVideo.setVideoUrl((String) videoData.get("videoUrl"));
        courseVideo.setVideoDescription((String) videoData.get("description"));
        
        // 处理数值类型字段
        if (videoData.get("duration") != null) {
            courseVideo.setVideoDuration(Integer.valueOf(videoData.get("duration").toString()));
        }
        if (videoData.get("sortOrder") != null) {
            courseVideo.setSortOrder(Integer.valueOf(videoData.get("sortOrder").toString()));
        }
        if (videoData.get("isFree") != null) {
            Object isFreeValue = videoData.get("isFree");
            if (isFreeValue instanceof Boolean) {
                courseVideo.setIsFree((Boolean) isFreeValue ? 1 : 0);
            } else {
                courseVideo.setIsFree(Integer.valueOf(isFreeValue.toString()));
            }
        }
        if (videoData.get("status") != null) {
            Object statusValue = videoData.get("status");
            if (statusValue instanceof Boolean) {
                courseVideo.setStatus((Boolean) statusValue ? 1 : 0);
            } else {
                courseVideo.setStatus(Integer.valueOf(statusValue.toString()));
            }
        }
        
        courseVideo.setUpdateTime(LocalDateTime.now());
        
        if (courseService.updateCourseVideo(courseVideo)) {
            return Result.success("更新视频成功");
        } else {
            return Result.error("更新视频失败");
        }
    }
    
    /**
     * 删除课程视频
     */
    @DeleteMapping("/{id}/videos/{videoId}")
    public Result<String> deleteCourseVideo(@PathVariable Long id, @PathVariable Long videoId, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Course course = courseService.getById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        // 只有管理员或者作者本人可以删除视频
        if (!"ADMIN".equals(currentUser.getRole()) && !course.getAuthorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限删除视频");
        }
        
        if (courseService.deleteCourseVideo(videoId)) {
            return Result.success("删除视频成功");
        } else {
            return Result.error("删除视频失败");
        }
    }
    
    /**
     * 更新视频观看进度
     */
    @PostMapping("/{id}/videos/{videoId}/progress")
    public Result<String> updateVideoProgress(@PathVariable Long id, @PathVariable Long videoId,
                                            @RequestParam Integer watchProgress,
                                            @RequestParam(defaultValue = "0") Integer totalWatchTime,
                                            HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        // 检查是否已报名课程或视频是否免费
        if (!courseService.isUserEnrolled(id, userId)) {
            // 检查是否为免费视频
            List<CourseVideo> freeVideos = courseService.getFreeCourseVideos(id);
            boolean isFreeVideo = freeVideos.stream().anyMatch(v -> v.getId().equals(videoId));
            if (!isFreeVideo) {
                return Result.error("请先报名课程或该视频为付费内容");
            }
        }
        
        if (courseService.updateVideoProgress(userId, videoId, watchProgress, totalWatchTime)) {
            return Result.success("更新观看进度成功");
        } else {
            return Result.error("更新观看进度失败");
        }
    }
    
    /**
     * 获取用户视频学习进度
     */
    @GetMapping("/{id}/videos/{videoId}/progress")
    public Result<UserVideoProgress> getVideoProgress(@PathVariable Long id, @PathVariable Long videoId,
                                                    HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        UserVideoProgress progress = courseService.getUserVideoProgress(userId, videoId);
        return Result.success(progress);
    }
    
    /**
     * 标记视频为已完成
     */
    @PostMapping("/{id}/videos/{videoId}/complete")
    public Result<String> markVideoCompleted(@PathVariable Long id, @PathVariable Long videoId,
                                           HttpServletRequest request) {
        Long userId = getUserIdFromRequest(request);
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        
        // 检查是否已报名课程或视频是否免费
        if (!courseService.isUserEnrolled(id, userId)) {
            List<CourseVideo> freeVideos = courseService.getFreeCourseVideos(id);
            boolean isFreeVideo = freeVideos.stream().anyMatch(v -> v.getId().equals(videoId));
            if (!isFreeVideo) {
                return Result.error("请先报名课程或该视频为付费内容");
            }
        }
        
        if (courseService.markVideoCompleted(userId, videoId)) {
            return Result.success("标记完成成功");
        } else {
            return Result.error("标记完成失败");
        }
    }
} 