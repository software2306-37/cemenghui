package com.cemenghui.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.common.Result;
import com.cemenghui.entity.Meeting;
import com.cemenghui.entity.MeetingFeedback;
import com.cemenghui.entity.User;
import com.cemenghui.service.MeetingService;
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
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/meeting")
public class MeetingController {

    @Autowired
    private MeetingService meetingService;

    /**
     * 分页查询会议列表
     */
    @GetMapping("/page")
    public Result<Page<Meeting>> pageMeetings(@RequestParam(defaultValue = "1") int current,
                                            @RequestParam(defaultValue = "10") int size,
                                            @RequestParam(required = false) String keyword,
                                            @RequestParam(required = false) Integer status,
                                            @RequestParam(required = false) Long creatorId,
                                            @RequestParam(required = false) String startDate,
                                            @RequestParam(required = false) String endDate) {
        Page<Meeting> page;
        if (startDate != null || endDate != null) {
            page = meetingService.pageMeetings(current, size, keyword, status, creatorId, startDate, endDate);
        } else {
            page = meetingService.pageMeetings(current, size, keyword, status, creatorId);
        }
        return Result.success(page);
    }

    /**
     * 获取会议详情
     */
    @GetMapping("/{id}")
    public Result<Meeting> getMeeting(@PathVariable Long id) {
        Meeting meeting = meetingService.getById(id);
        if (meeting != null) {
            return Result.success(meeting);
        } else {
            return Result.error("会议不存在");
        }
    }
    
    /**
     * 获取会议详情（包含用户报名状态）
     */
    @GetMapping("/{id}/detail")
    public Result<Map<String, Object>> getMeetingDetail(@PathVariable Long id, HttpSession session, HttpServletRequest request) {
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser != null) {
            Map<String, Object> result = meetingService.getMeetingWithRegistrationStatus(id, currentUser.getId());
            return Result.success(result);
        } else {
            // 未登录用户只返回会议基本信息
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("meeting", meeting);
            result.put("isRegistered", false);
            result.put("canSubmitFeedback", false);
            result.put("hasSubmittedFeedback", false);
            return Result.success(result);
        }
    }

    /**
     * 创建会议
     */
    @PostMapping
    public Result<String> createMeeting(@RequestBody Meeting meeting, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        meeting.setCreator(currentUser.getNickname() != null ? currentUser.getNickname() : currentUser.getUsername());
        meeting.setCreatorId(currentUser.getId());
        
        // 管理员创建的直接通过，企业用户创建的需要审核
        if ("ADMIN".equals(currentUser.getRole())) {
            meeting.setStatus(1);
        } else {
            meeting.setStatus(0);
        }
        
        if (meetingService.save(meeting)) {
            return Result.success("创建成功");
        } else {
            return Result.error("创建失败");
        }
    }

    /**
     * 更新会议
     */
    @PutMapping("/{id}")
    public Result<String> updateMeeting(@PathVariable Long id, @RequestBody Meeting meeting, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Meeting existingMeeting = meetingService.getById(id);
        if (existingMeeting == null) {
            return Result.error("会议不存在");
        }
        
        // 只有管理员或者创建者本人可以编辑
        if (!"ADMIN".equals(currentUser.getRole()) && !existingMeeting.getCreatorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限编辑");
        }
        
        meeting.setId(id);
        meeting.setCreator(existingMeeting.getCreator());
        meeting.setCreatorId(existingMeeting.getCreatorId());
        
        // 企业用户编辑后需要重新审核
        if (!"ADMIN".equals(currentUser.getRole())) {
            meeting.setStatus(0);
        }
        
        if (meetingService.updateById(meeting)) {
            return Result.success("更新成功");
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 删除会议
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteMeeting(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        // 只有管理员或者创建者本人可以删除
        if (!"ADMIN".equals(currentUser.getRole()) && !meeting.getCreatorId().equals(currentUser.getId())) {
            return Result.error(403, "无权限删除");
        }
        
        if (meetingService.removeById(id)) {
            return Result.success("删除成功");
        } else {
            return Result.error("删除失败");
        }
    }

    /**
     * 审核会议
     */
    @PostMapping("/{id}/audit")
    public Result<String> auditMeeting(@PathVariable Long id, @RequestParam Integer status, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        if (!"ADMIN".equals(currentUser.getRole())) {
            return Result.error(403, "无权限审核");
        }
        
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        meeting.setStatus(status);
        meeting.setAuditTime(LocalDateTime.now());
        meeting.setAuditUserId(currentUser.getId());
        
        if (meetingService.updateById(meeting)) {
            return Result.success("审核成功");
        } else {
            return Result.error("审核失败");
        }
    }
    
    /**
     * 会议报名
     */
    @PostMapping("/{id}/register")
    public Result<String> registerMeeting(@PathVariable Long id, HttpSession session, HttpServletRequest request) {
        System.out.println("会议报名请求 - 会议ID: " + id + ", 请求头X-User-Id: " + request.getHeader("X-User-Id"));
        
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            System.out.println("会议报名失败 - 用户未登录");
            return Result.error(401, "未登录");
        }
        
        System.out.println("会议报名 - 用户ID: " + currentUser.getId() + ", 用户名: " + currentUser.getUsername());
        
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        if (meeting.getStatus() != 1) {
            return Result.error("会议未开放报名");
        }
        
        // 检查是否已报名
        if (meetingService.isUserRegistered(id, currentUser.getId())) {
            return Result.error("您已报名该会议");
        }
        
        // 创建报名记录
        if (meetingService.registerMeeting(id, currentUser.getId())) {
            return Result.success("报名成功");
        } else {
            return Result.error("报名失败");
        }
    }
    
    /**
     * 取消会议报名
     */
    @PostMapping("/{id}/cancel")
    public Result<String> cancelRegistration(@PathVariable Long id, HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        // 检查是否已报名
        if (!meetingService.isUserRegistered(id, currentUser.getId())) {
            return Result.error("您未报名该会议");
        }
        
        // 取消报名
        if (meetingService.cancelRegistration(id, currentUser.getId())) {
            return Result.success("取消报名成功");
        } else {
            return Result.error("取消报名失败");
        }
    }
    
    /**
     * 提交参会回执
     */
    @PostMapping("/{id}/feedback")
    public Result<String> submitFeedback(@PathVariable Long id, @RequestBody MeetingFeedback feedback, 
                                       HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        Meeting meeting = meetingService.getById(id);
        if (meeting == null) {
            return Result.error("会议不存在");
        }
        
        // 检查是否可以提交回执
        if (!meetingService.canSubmitFeedback(id, currentUser.getId())) {
            return Result.error("暂不可提交回执，请确认已报名且会议已结束");
        }
        
        // 检查是否已提交过回执
        if (meetingService.hasSubmittedFeedback(id, currentUser.getId())) {
            return Result.error("您已提交过回执");
        }
        
        // 设置回执信息
        feedback.setMeetingId(id);
        feedback.setUserId(currentUser.getId());
        feedback.setUserName(currentUser.getNickname() != null ? currentUser.getNickname() : currentUser.getUsername());
        
        if (meetingService.submitFeedback(feedback)) {
            return Result.success("回执提交成功");
        } else {
            return Result.error("回执提交失败");
        }
    }
    
    /**
     * 获取用户的参会回执
     */
    @GetMapping("/{id}/feedback")
    public Result<MeetingFeedback> getUserFeedback(@PathVariable Long id, HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        MeetingFeedback feedback = meetingService.getUserFeedback(id, currentUser.getId());
        return Result.success(feedback);
    }
    
    /**
     * 批量检查会议报名状态
     */
    @PostMapping("/batch-check-registration")
    public Result<Map<Long, Boolean>> batchCheckRegistration(@RequestBody List<Long> meetingIds, 
                                                           HttpSession session, HttpServletRequest request) {
        Map<Long, Boolean> result = new java.util.HashMap<>();
        
        try {
            User currentUser = getCurrentUserFromSession(request, session);
            
            if (currentUser == null || currentUser.getId() == null) {
                // 未登录用户，所有会议都未报名
                System.out.println("用户未登录，设置所有会议为未报名状态");
                for (Long meetingId : meetingIds) {
                    result.put(meetingId, false);
                }
            } else {
                // 已登录用户，检查每个会议的报名状态
                System.out.println("检查用户 " + currentUser.getId() + " 的报名状态");
                for (Long meetingId : meetingIds) {
                    try {
                        boolean isRegistered = meetingService.isUserRegistered(meetingId, currentUser.getId());
                        result.put(meetingId, isRegistered);
                        System.out.println("会议 " + meetingId + " 报名状态: " + isRegistered);
                    } catch (Exception e) {
                        System.out.println("检查会议 " + meetingId + " 报名状态失败: " + e.getMessage());
                        result.put(meetingId, false);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("批量检查报名状态失败: " + e.getMessage());
            // 出错时，所有会议都设置为未报名
            for (Long meetingId : meetingIds) {
                result.put(meetingId, false);
            }
        }
        
        return Result.success(result);
    }
    
    @Autowired
    private com.cemenghui.mapper.UserMapper userMapper;
    
    /**
     * 获取当前用户信息 - 兼容小程序端
     */
    private User getCurrentUserFromSession(HttpServletRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user;
        }
        
        // 小程序端通过请求头获取用户ID
        String userIdHeader = request.getHeader("X-User-Id");
        if (userIdHeader != null && !userIdHeader.isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdHeader);
                // 从数据库查询用户信息
                User userFromDb = userMapper.selectById(userId);
                return userFromDb;
            } catch (NumberFormatException e) {
                return null;
            }
        }
        
        return null;
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> export(@RequestParam(required = false) String keyword) {
        try {
            QueryWrapper<Meeting> queryWrapper = new QueryWrapper<>();
            
            if (StringUtils.hasText(keyword)) {
                queryWrapper.and(wrapper -> wrapper
                    .like("meeting_name", keyword)
                    .or().like("location", keyword)
                    .or().like("organizer", keyword)
                );
            }
            
            queryWrapper.orderByDesc("create_time");
            
            List<Meeting> meetingList = meetingService.list(queryWrapper);
            
            // 简化的CSV导出
            StringBuilder csv = new StringBuilder();
            // 添加UTF-8 BOM头
            csv.append("\uFEFF");
            csv.append("MeetingName,MeetingTime,Location,Organizer,Category,Creator,Status,CreateTime\n");
            
            for (Meeting meeting : meetingList) {
                String statusText = "";
                if (meeting.getStatus() == 0) statusText = "Pending";
                else if (meeting.getStatus() == 1) statusText = "Published";
                else if (meeting.getStatus() == 2) statusText = "Rejected";
                
                csv.append(meeting.getMeetingName() != null ? meeting.getMeetingName().replace(",", ";") : "").append(",")
                   .append(meeting.getMeetingTime() != null ? meeting.getMeetingTime() : "").append(",")
                   .append(meeting.getLocation() != null ? meeting.getLocation().replace(",", ";") : "").append(",")
                   .append(meeting.getOrganizer() != null ? meeting.getOrganizer().replace(",", ";") : "").append(",")
                   .append(meeting.getCategory() != null ? meeting.getCategory() : "").append(",")
                   .append(meeting.getCreator() != null ? meeting.getCreator() : "").append(",")
                   .append(statusText).append(",")
                   .append(meeting.getCreateTime() != null ? meeting.getCreateTime() : "").append("\n");
            }
            
            byte[] data = csv.toString().getBytes("UTF-8");
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            String fileName = "meetings_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
            headers.setContentDispositionFormData("attachment", fileName);
            
            return ResponseEntity.ok()
                .headers(headers)
                .body(data);
                
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
} 