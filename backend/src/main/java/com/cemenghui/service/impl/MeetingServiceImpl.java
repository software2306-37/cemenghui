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
    @Override
    public Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId) {
        return null;
    }

    @Override
    public Page<Meeting> pageMeetings(int current, int size, String keyword, Integer status, Long creatorId, String startDate, String endDate) {
        return null;
    }

    @Override
    public List<Meeting> getRecentMeetings(int limit) {
        return null;
    }

    @Override
    public List<Meeting> getPublishedMeetings() {
        return null;
    }

    @Override
    public boolean isUserRegistered(Long meetingId, Long userId) {
        return false;
    }

    @Override
    public boolean registerMeeting(Long meetingId, Long userId) {
        return false;
    }

    @Override
    public MeetingRegistration getUserRegistration(Long meetingId, Long userId) {
        return null;
    }

    @Override
    public boolean cancelRegistration(Long meetingId, Long userId) {
        return false;
    }

    @Override
    public List<MeetingRegistration> getMeetingRegistrations(Long meetingId) {
        return null;
    }

    @Override
    public Map<String, Object> getMeetingWithRegistrationStatus(Long meetingId, Long userId) {
        return null;
    }

    @Override
    public boolean canSubmitFeedback(Long meetingId, Long userId) {
        return false;
    }

    @Override
    public boolean submitFeedback(MeetingFeedback feedback) {
        return false;
    }

    @Override
    public MeetingFeedback getUserFeedback(Long meetingId, Long userId) {
        return null;
    }

    @Override
    public boolean hasSubmittedFeedback(Long meetingId, Long userId) {
        return false;
    }

    @Override
    public int getUserRegisteredMeetingCount(Long userId) {
        return 0;
    }

    @Override
    public List<Map<String, Object>> getUserRegisteredMeetings(Long userId) {
        return null;
    }
}