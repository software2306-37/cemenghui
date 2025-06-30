package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.cemenghui.entity.Meeting;
import com.cemenghui.entity.MeetingFeedback;
import com.cemenghui.entity.MeetingRegistration;
import com.cemenghui.entity.User;
import com.cemenghui.mapper.MeetingFeedbackMapper;
import com.cemenghui.mapper.MeetingMapper;
import com.cemenghui.mapper.MeetingRegistrationMapper;
import com.cemenghui.mapper.UserMapper;
import com.cemenghui.service.MeetingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MeetingServiceImpl extends ServiceImpl<MeetingMapper, Meeting> implements MeetingService {

    @Autowired
    private MeetingRegistrationMapper registrationMapper;

    @Autowired
    private MeetingFeedbackMapper feedbackMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId) {
        Page<Meeting> page = new Page<>(current, size);
        QueryWrapper<Meeting> queryWrapper = new QueryWrapper<>();

        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper ->
                wrapper.like("meeting_name", keyword)
                    .or().like("creator", keyword)
                    .or().like("organizer", keyword)
            );
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        if (creatorId != null) {
            queryWrapper.eq("creator_id", creatorId);
        }

        queryWrapper.orderByDesc("create_time");

        return this.page(page, queryWrapper);
    }

    @Override
    public Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId, String startDate, String endDate) {
        Page<Meeting> page = new Page<>(current, size);
        QueryWrapper<Meeting> queryWrapper = new QueryWrapper<>();

        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper ->
                wrapper.like("meeting_name", keyword)
                    .or().like("creator", keyword)
                    .or().like("organizer", keyword)
            );
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        if (creatorId != null) {
            queryWrapper.eq("creator_id", creatorId);
        }

        if (StringUtils.hasText(startDate)) {
            queryWrapper.ge("create_time", startDate + " 00:00:00");
        }

        if (StringUtils.hasText(endDate)) {
            queryWrapper.le("create_time", endDate + " 23:59:59");
        }

        queryWrapper.orderByDesc("create_time");

        return this.page(page, queryWrapper);
    }

    @Override
    public List<Meeting> getRecentMeetings(int limit) {
        QueryWrapper<Meeting> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1) // 只查询已发布的会议
                   .orderByDesc("create_time")
                   .last("LIMIT " + limit);

        return this.list(queryWrapper);
    }

    @Override
    public List<Meeting> getPublishedMeetings() {
        QueryWrapper<Meeting> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1)
                   .orderByDesc("meeting_time");

        return this.list(queryWrapper);
    }

    @Override
    public boolean isUserRegistered(Long meetingId, Long userId) {
        if (meetingId == null || userId == null) {
            return false;
        }

        try {
            QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("meeting_id", meetingId)
                       .eq("user_id", userId)
                       .ne("status", 3); // 排除已取消的报名
            Long count = registrationMapper.selectCount(queryWrapper);
            return count != null && count > 0;
        } catch (Exception e) {
            // 如果表不存在或查询失败，返回false
            System.out.println("检查报名状态失败: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean registerMeeting(Long meetingId, Long userId) {
        try {
            // 检查是否已报名
            if (isUserRegistered(meetingId, userId)) {
                return false;
            }

            // 获取用户信息
            User user = userMapper.selectById(userId);
            if (user == null) {
                return false;
            }

            // 创建报名记录
            MeetingRegistration registration = new MeetingRegistration();
            registration.setMeetingId(meetingId);
            registration.setUserId(userId);
            registration.setUserName(user.getNickname() != null ? user.getNickname() : user.getUsername());
            registration.setUserPhone(user.getPhone());
            registration.setUserEmail(user.getEmail());
            registration.setCompanyName(user.getCompanyName());
            registration.setStatus(0); // 已报名
            registration.setRegistrationTime(LocalDateTime.now());
            registration.setCreateTime(LocalDateTime.now());

            return registrationMapper.insert(registration) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public MeetingRegistration getUserRegistration(Long meetingId, Long userId) {
        QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("meeting_id", meetingId)
                   .eq("user_id", userId)
                   .ne("status", 3) // 排除已取消的报名
                   .orderByDesc("create_time")
                   .last("LIMIT 1");
        return registrationMapper.selectOne(queryWrapper);
    }

    @Override
    public boolean cancelRegistration(Long meetingId, Long userId) {
        QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("meeting_id", meetingId).eq("user_id", userId);

        MeetingRegistration registration = registrationMapper.selectOne(queryWrapper);
        if (registration != null) {
            registration.setStatus(3); // 已取消
            registration.setUpdateTime(LocalDateTime.now());
            return registrationMapper.updateById(registration) > 0;
        }
        return false;
    }

    @Override
    public List<MeetingRegistration> getMeetingRegistrations(Long meetingId) {
        QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("meeting_id", meetingId)
                   .ne("status", 3) // 排除已取消的报名
                   .orderByDesc("create_time");
        return registrationMapper.selectList(queryWrapper);
    }

    @Override
    public Map<String, Object> getMeetingWithRegistrationStatus(Long meetingId, Long userId) {
        Map<String, Object> result = new HashMap<>();

        // 获取会议信息
        Meeting meeting = this.getById(meetingId);
        result.put("meeting", meeting);

        // 获取报名状态
        MeetingRegistration registration = getUserRegistration(meetingId, userId);
        result.put("registration", registration);
        result.put("isRegistered", registration != null);

        // 检查是否可以填写回执
        result.put("canSubmitFeedback", canSubmitFeedback(meetingId, userId));

        // 检查是否已提交回执
        result.put("hasSubmittedFeedback", hasSubmittedFeedback(meetingId, userId));

        return result;
    }

    @Override
    public boolean canSubmitFeedback(Long meetingId, Long userId) {
        // 检查是否已报名
        if (!isUserRegistered(meetingId, userId)) {
            return false;
        }

        // 检查会议是否已结束
        Meeting meeting = this.getById(meetingId);
        if (meeting == null || meeting.getMeetingTime() == null) {
            return false;
        }

        // 会议结束后才能填写回执
        return LocalDateTime.now().isAfter(meeting.getMeetingTime());
    }

    @Override
    public boolean submitFeedback(MeetingFeedback feedback) {
        try {
            feedback.setSubmitTime(LocalDateTime.now());
            feedback.setCreateTime(LocalDateTime.now());
            return feedbackMapper.insert(feedback) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public MeetingFeedback getUserFeedback(Long meetingId, Long userId) {
        QueryWrapper<MeetingFeedback> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("meeting_id", meetingId)
                   .eq("user_id", userId)
                   .orderByDesc("create_time")
                   .last("LIMIT 1");
        return feedbackMapper.selectOne(queryWrapper);
    }

    @Override
    public boolean hasSubmittedFeedback(Long meetingId, Long userId) {
        QueryWrapper<MeetingFeedback> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("meeting_id", meetingId).eq("user_id", userId);
        return feedbackMapper.selectCount(queryWrapper) > 0;
    }

    @Override
    public int getUserRegisteredMeetingCount(Long userId) {
        try {
            QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .ne("status", 3); // 排除已取消的报名
            Long count = registrationMapper.selectCount(queryWrapper);
            return count != null ? count.intValue() : 0;
        } catch (Exception e) {
            System.err.println("查询用户会议数量失败: " + e.getMessage());
            return 0;
        }
    }

    @Override
    public List<Map<String, Object>> getUserRegisteredMeetings(Long userId) {
        List<Map<String, Object>> result = new ArrayList<>();

        try {
            // 查询用户的报名记录
            QueryWrapper<MeetingRegistration> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("user_id", userId)
                       .ne("status", 3) // 排除已取消的报名
                       .orderByDesc("create_time");

            List<MeetingRegistration> registrations = registrationMapper.selectList(queryWrapper);

            for (MeetingRegistration registration : registrations) {
                Meeting meeting = this.getById(registration.getMeetingId());
                if (meeting != null) {
                    Map<String, Object> meetingMap = new HashMap<>();
                    meetingMap.put("id", meeting.getId());
                    meetingMap.put("title", meeting.getMeetingName());
                    meetingMap.put("description", meeting.getMeetingContent());
                    meetingMap.put("coverImage", meeting.getCoverImage());
                    meetingMap.put("organizer", meeting.getOrganizer());
                    meetingMap.put("startTime", meeting.getMeetingTime());
                    meetingMap.put("endTime", meeting.getMeetingTime() != null ?
                        meeting.getMeetingTime().plusHours(2) : null); // 假设会议持续2小时
                    meetingMap.put("location", meeting.getLocation());
                    meetingMap.put("status", meeting.getStatus());
                    meetingMap.put("createTime", meeting.getCreateTime());
                    meetingMap.put("enrollTime", registration.getRegistrationTime());

                    // 判断会议状态
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime startTime = meeting.getMeetingTime();
                    String meetingStatus;
                    String participationStatus = "已报名";

                    if (startTime != null) {
                        LocalDateTime endTime = startTime.plusHours(2); // 假设会议持续2小时

                        if (now.isBefore(startTime)) {
                            meetingStatus = "即将开始";
                        } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
                            meetingStatus = "进行中";
                            participationStatus = "已参加";
                        } else {
                            meetingStatus = "已结束";
                            participationStatus = "已参加";
                        }
                    } else {
                        meetingStatus = "时间待定";
                    }

                    meetingMap.put("meetingStatus", meetingStatus);
                    meetingMap.put("participationStatus", participationStatus);

                    result.add(meetingMap);
                }
            }
        } catch (Exception e) {
            System.err.println("查询用户会议列表失败: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }
}