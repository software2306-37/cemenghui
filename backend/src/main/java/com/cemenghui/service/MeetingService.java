package com.cemenghui.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.cemenghui.entity.Meeting;
import com.cemenghui.entity.MeetingRegistration;
import com.cemenghui.entity.MeetingFeedback;

import java.util.List;
import java.util.Map;

public interface MeetingService extends IService<Meeting> {

    /**
     * 分页查询会议
     */
    Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId);

    /**
     * 分页查询会议（带时间筛选）
     */
    Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId, String startDate, String endDate);

    /**
     * 获取最新会议列表
     */
    List<Meeting> getRecentMeetings(int limit);

    /**
     * 获取已发布的会议列表
     */
    List<Meeting> getPublishedMeetings();

    /**
     * 检查用户是否已报名会议
     */
    boolean isUserRegistered(Long meetingId, Long userId);

    /**
     * 用户报名会议
     */
    boolean registerMeeting(Long meetingId, Long userId);

    /**
     * 获取用户的会议报名记录
     */
    MeetingRegistration getUserRegistration(Long meetingId, Long userId);

    /**
     * 取消会议报名
     */
    boolean cancelRegistration(Long meetingId, Long userId);

    /**
     * 获取会议报名列表
     */
    List<MeetingRegistration> getMeetingRegistrations(Long meetingId);

    /**
     * 获取用户的会议列表（带报名状态）
     */
    Map<String, Object> getMeetingWithRegistrationStatus(Long meetingId, Long userId);

    /**
     * 检查用户是否可以填写回执
     */
    boolean canSubmitFeedback(Long meetingId, Long userId);

    /**
     * 提交参会回执
     */
    boolean submitFeedback(MeetingFeedback feedback);

    /**
     * 获取用户的会议回执
     */
    MeetingFeedback getUserFeedback(Long meetingId, Long userId);

    /**
     * 检查用户是否已提交回执
     */
    boolean hasSubmittedFeedback(Long meetingId, Long userId);

    /**
     * 获取用户报名的会议数量
     */
    int getUserRegisteredMeetingCount(Long userId);

    /**
     * 获取用户报名的会议列表
     */
    List<Map<String, Object>> getUserRegisteredMeetings(Long userId);
} 