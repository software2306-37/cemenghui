package com.cemenghui.service.impl;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.entity.*;
import com.cemenghui.mapper.*;
import com.cemenghui.service.impl.MeetingServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MeetingServiceImplTest {

    @Mock
    private MeetingMapper meetingMapper;

    @Mock
    private MeetingRegistrationMapper registrationMapper;

    @Mock
    private MeetingFeedbackMapper feedbackMapper;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private MeetingServiceImpl meetingService;

    private Meeting testMeeting;
    private User testUser;
    private MeetingRegistration testRegistration;
    private MeetingFeedback testFeedback;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(meetingService, "baseMapper", meetingMapper);
        // 初始化测试数据
        testMeeting = new Meeting();
        testMeeting.setId(1L);
        testMeeting.setMeetingName("测试会议");
        testMeeting.setStatus(1); // 已发布
        testMeeting.setMeetingTime(LocalDateTime.now().plusDays(1));
        testMeeting.setCreateTime(LocalDateTime.now());

        testUser = new User();
        testUser.setId(1L);
        testUser.setUsername("testuser");
        testUser.setNickname("测试用户");
        testUser.setPhone("13800138000");
        testUser.setEmail("test@example.com");
        testUser.setCompanyName("测试公司");

        testRegistration = new MeetingRegistration();
        testRegistration.setId(1L);
        testRegistration.setMeetingId(1L);
        testRegistration.setUserId(1L);
        testRegistration.setStatus(0); // 已报名
        testRegistration.setRegistrationTime(LocalDateTime.now());

        testFeedback = new MeetingFeedback();
        testFeedback.setId(1L);
        testFeedback.setMeetingId(1L);
        testFeedback.setUserId(1L);
        testFeedback.setContent("测试反馈内容");
        testFeedback.setSubmitTime(LocalDateTime.now());

    }

    // 测试分页查询会议
    @Test
    void pageMeetings_ShouldReturnPagedMeetings() {
        // 准备测试数据
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        // 模拟行为
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        // 调用方法
        Page<Meeting> result = meetingService.pageMeetings(1, 10, null, null, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(testMeeting.getMeetingName(), result.getRecords().get(0).getMeetingName());
    }

    @Test
    void pageMeetings_WithKeyword_ShouldFilterResults() {
        // 准备测试数据
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        // 模拟行为
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        // 调用方法
        Page<Meeting> result = meetingService.pageMeetings(1, 10, "测试", null, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 测试获取最近会议
    @Test
    void getRecentMeetings_ShouldReturnLimitedPublishedMeetings() {
        // 准备测试数据
        List<Meeting> expectedMeetings = Collections.singletonList(testMeeting);

        // 模拟行为
        when(meetingMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(expectedMeetings);

        // 调用方法
        List<Meeting> result = meetingService.getRecentMeetings(5);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testMeeting.getMeetingName(), result.get(0).getMeetingName());
    }

    // 测试获取已发布会议
    @Test
    void getPublishedMeetings_ShouldReturnOnlyPublishedMeetings() {
        // 准备测试数据
        List<Meeting> expectedMeetings = Collections.singletonList(testMeeting);

        // 模拟行为
        when(meetingMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(expectedMeetings);

        // 调用方法
        List<Meeting> result = meetingService.getPublishedMeetings();

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(1, result.get(0).getStatus()); // 验证只返回已发布会议
    }

    // 测试用户是否已报名
    @Test
    void isUserRegistered_WhenRegistered_ShouldReturnTrue() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);

        // 调用方法
        boolean result = meetingService.isUserRegistered(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void isUserRegistered_WhenNotRegistered_ShouldReturnFalse() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);

        // 调用方法
        boolean result = meetingService.isUserRegistered(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void isUserRegistered_WithNullInput_ShouldReturnFalse() {
        // 调用方法
        boolean result1 = meetingService.isUserRegistered(null, 1L);
        boolean result2 = meetingService.isUserRegistered(1L, null);
        boolean result3 = meetingService.isUserRegistered(null, null);

        // 验证结果
        assertFalse(result1);
        assertFalse(result2);
        assertFalse(result3);
    }

    // 测试会议报名
    @Test
    void registerMeeting_WhenNotRegistered_ShouldReturnTrue() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenReturn(1);

        // 调用方法
        boolean result = meetingService.registerMeeting(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void registerMeeting_WhenAlreadyRegistered_ShouldReturnFalse() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);

        // 调用方法
        boolean result = meetingService.registerMeeting(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void registerMeeting_WhenUserNotFound_ShouldReturnFalse() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(null);

        // 调用方法
        boolean result = meetingService.registerMeeting(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    // 测试获取用户报名信息
    @Test
    void getUserRegistration_WhenExists_ShouldReturnRegistration() {
        // 模拟行为
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testRegistration);

        // 调用方法
        MeetingRegistration result = meetingService.getUserRegistration(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(testRegistration.getId(), result.getId());
    }

    @Test
    void getUserRegistration_WhenNotExists_ShouldReturnNull() {
        // 模拟行为
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(null);

        // 调用方法
        MeetingRegistration result = meetingService.getUserRegistration(1L, 1L);

        // 验证结果
        assertNull(result);
    }

    // 测试取消报名
    @Test
    void cancelRegistration_WhenExists_ShouldReturnTrue() {
        // 模拟行为
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testRegistration);
        when(registrationMapper.updateById(any(MeetingRegistration.class)))
                .thenReturn(1);

        // 调用方法
        boolean result = meetingService.cancelRegistration(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void cancelRegistration_WhenNotExists_ShouldReturnFalse() {
        // 模拟行为
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(null);

        // 调用方法
        boolean result = meetingService.cancelRegistration(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    // 测试获取会议报名列表
    @Test
    void getMeetingRegistrations_ShouldReturnRegistrationList() {
        // 准备测试数据
        List<MeetingRegistration> expectedRegistrations = Collections.singletonList(testRegistration);

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(expectedRegistrations);

        // 调用方法
        List<MeetingRegistration> result = meetingService.getMeetingRegistrations(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testRegistration.getId(), result.get(0).getId());
    }

    // 测试获取会议及报名状态
    @Test
    void getMeetingWithRegistrationStatus_ShouldReturnCompleteInfo() {
        // 模拟行为
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testRegistration);
        when(feedbackMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);

        // 调用方法
        Map<String, Object> result = meetingService.getMeetingWithRegistrationStatus(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(testMeeting, result.get("meeting"));
        assertEquals(testRegistration, result.get("registration"));
        assertTrue((Boolean) result.get("isRegistered"));
        assertFalse((Boolean) result.get("hasSubmittedFeedback"));
    }

    // 测试是否可以提交反馈
    @Test
    void canSubmitFeedback_WhenMeetingNotEnded_ShouldReturnFalse() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting); // 会议时间是未来

        // 调用方法
        boolean result = meetingService.canSubmitFeedback(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void canSubmitFeedback_WhenMeetingEndedAndRegistered_ShouldReturnTrue() {
        // 准备测试数据 - 会议时间设置为过去
        testMeeting.setMeetingTime(LocalDateTime.now().minusDays(1));

        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);

        // 调用方法
        boolean result = meetingService.canSubmitFeedback(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    // 测试提交反馈
    @Test
    void submitFeedback_ShouldReturnTrueWhenSuccess() {
        // 模拟行为
        when(feedbackMapper.insert(any(MeetingFeedback.class)))
                .thenReturn(1);

        // 调用方法
        boolean result = meetingService.submitFeedback(testFeedback);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void submitFeedback_WhenExceptionOccurs_ShouldReturnFalse() {
        // 模拟行为
        when(feedbackMapper.insert(any(MeetingFeedback.class)))
                .thenThrow(new RuntimeException("Database error"));

        // 调用方法
        boolean result = meetingService.submitFeedback(testFeedback);

        // 验证结果
        assertFalse(result);
    }

    // 测试获取用户反馈
    @Test
    void getUserFeedback_WhenExists_ShouldReturnFeedback() {
        // 模拟行为
        when(feedbackMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testFeedback);

        // 调用方法
        MeetingFeedback result = meetingService.getUserFeedback(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(testFeedback.getId(), result.getId());
    }

    // 测试是否已提交反馈
    @Test
    void hasSubmittedFeedback_WhenExists_ShouldReturnTrue() {
        // 模拟行为
        when(feedbackMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);

        // 调用方法
        boolean result = meetingService.hasSubmittedFeedback(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    // 测试获取用户报名会议数量
    @Test
    void getUserRegisteredMeetingCount_ShouldReturnCorrectCount() {
        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(3L);

        // 调用方法
        int result = meetingService.getUserRegisteredMeetingCount(1L);

        // 验证结果
        assertEquals(3, result);
    }

    // 测试获取用户报名会议列表
    @Test
    void getUserRegisteredMeetings_ShouldReturnMeetingList() {
        // 准备测试数据
        List<MeetingRegistration> registrations = Collections.singletonList(testRegistration);

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(registrations);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testMeeting.getMeetingName(), result.get(0).get("title"));
    }

    // 边界条件测试
    @Test
    void pageMeetings_WithMaxPageSize_ShouldHandleCorrectly() {
        // 准备测试数据
        Page<Meeting> expectedPage = new Page<>(1, Integer.MAX_VALUE);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        // 模拟行为
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        // 调用方法 - 使用最大整数作为分页大小
        Page<Meeting> result = meetingService.pageMeetings(1, Integer.MAX_VALUE, null, null, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    @Test
    void getRecentMeetings_WithZeroLimit_ShouldReturnEmptyList() {
        // 调用方法 - 限制为0
        List<Meeting> result = meetingService.getRecentMeetings(0);

        // 验证结果
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void registerMeeting_WithMaxUserId_ShouldHandleCorrectly() {
        // 准备测试数据 - 使用最大Long值作为用户ID
        Long maxUserId = Long.MAX_VALUE;
        testUser.setId(maxUserId);

        // 模拟行为
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(eq(maxUserId)))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenReturn(1);

        // 调用方法
        boolean result = meetingService.registerMeeting(1L, maxUserId);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void pageMeetings_WithDateRange_ShouldFilterByDate() {
        // 准备测试数据
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        // 模拟行为
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        // 调用带时间范围的重载方法
        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "2023-01-01", "2023-12-31");

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }
    @Test
    void getPublishedMeetings_WhenNoMeetings_ShouldReturnEmptyList() {
        // 模拟空结果
        when(meetingMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.emptyList());

        List<Meeting> result = meetingService.getPublishedMeetings();

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void pageMeetings_WithInvalidDateFormat_ShouldIgnoreDateFilter() {
        // 使用Collections.singletonList()替代List.of()
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(new Page<Meeting>().setRecords(Collections.singletonList(testMeeting)));

        // 调用带非法日期格式的方法
        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "invalid-date", "2023/12/31");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }
    @Test
    void getUserRegisteredMeetingCount_WhenNoRegistrations_ShouldReturnZero() {
        // 模拟返回0
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);

        int result = meetingService.getUserRegisteredMeetingCount(1L);

        assertEquals(0, result);
    }

    // 测试异常处理路径 - isUserRegistered
    @Test
    void isUserRegistered_WhenDatabaseError_ShouldReturnFalse() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenThrow(new RuntimeException("Database error"));

        boolean result = meetingService.isUserRegistered(1L, 1L);

        assertFalse(result);
        verify(registrationMapper).selectCount(any(QueryWrapper.class));
    }

    // 测试 registerMeeting 中的异常处理
    @Test
    void registerMeeting_WhenDatabaseError_ShouldReturnFalse() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenThrow(new RuntimeException("Database error"));

        boolean result = meetingService.registerMeeting(1L, 1L);

        assertFalse(result);
    }

    // 测试 getUserRegisteredMeetingCount 异常处理
    @Test
    void getUserRegisteredMeetingCount_WhenDatabaseError_ShouldReturnZero() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenThrow(new RuntimeException("Database error"));

        int result = meetingService.getUserRegisteredMeetingCount(1L);

        assertEquals(0, result);
    }

    // 测试 getUserRegisteredMeetings 异常处理
    @Test
    void getUserRegisteredMeetings_WhenDatabaseError_ShouldReturnEmptyList() {
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenThrow(new RuntimeException("Database error"));

        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // 测试 pageMeetings 的所有查询条件组合
    @Test
    void pageMeetings_WithAllFilters_ShouldApplyAllConditions() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(1, 10, "测试", 1, 1L);

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 测试日期过滤的边界情况
    @Test
    void pageMeetings_WithOnlyStartDate_ShouldFilterCorrectly() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "2023-01-01", null);

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    @Test
    void pageMeetings_WithOnlyEndDate_ShouldFilterCorrectly() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                null, "2023-12-31");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 测试 getUserRegistration 返回多个记录时的处理
    @Test
    void getUserRegistration_WhenMultipleExist_ShouldReturnLatest() {
        MeetingRegistration olderRegistration = new MeetingRegistration();
        olderRegistration.setId(2L);
        olderRegistration.setCreateTime(LocalDateTime.now().minusDays(1));

        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testRegistration);

        MeetingRegistration result = meetingService.getUserRegistration(1L, 1L);

        assertNotNull(result);
        assertEquals(testRegistration.getId(), result.getId());
    }

    // 测试 cancelRegistration 更新失败的情况
    @Test
    void cancelRegistration_WhenUpdateFails_ShouldReturnFalse() {
        when(registrationMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testRegistration);
        when(registrationMapper.updateById(any(MeetingRegistration.class)))
                .thenReturn(0);

        boolean result = meetingService.cancelRegistration(1L, 1L);

        assertFalse(result);
    }

    // 测试 getMeetingWithRegistrationStatus 中 meeting 为 null 的情况
    @Test
    void getMeetingWithRegistrationStatus_WhenMeetingNotFound_ShouldReturnNullMeeting() {
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(null);

        Map<String, Object> result = meetingService.getMeetingWithRegistrationStatus(1L, 1L);

        assertNotNull(result);
        assertNull(result.get("meeting"));
    }

    // 测试 canSubmitFeedback 中 meeting 为 null 的情况
    @Test
    void canSubmitFeedback_WhenMeetingNotFound_ShouldReturnFalse() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(null);

        boolean result = meetingService.canSubmitFeedback(1L, 1L);

        assertFalse(result);
    }

    // 测试 canSubmitFeedback 中 meetingTime 为 null 的情况
    @Test
    void canSubmitFeedback_WhenMeetingTimeIsNull_ShouldReturnFalse() {
        testMeeting.setMeetingTime(null);

        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(1L);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);

        boolean result = meetingService.canSubmitFeedback(1L, 1L);

        assertFalse(result);
    }

    // 测试 getUserFeedback 返回多个记录时的处理
    @Test
    void getUserFeedback_WhenMultipleExist_ShouldReturnLatest() {
        MeetingFeedback olderFeedback = new MeetingFeedback();
        olderFeedback.setId(2L);
        olderFeedback.setCreateTime(LocalDateTime.now().minusDays(1));

        when(feedbackMapper.selectOne(any(QueryWrapper.class)))
                .thenReturn(testFeedback);

        MeetingFeedback result = meetingService.getUserFeedback(1L, 1L);

        assertNotNull(result);
        assertEquals(testFeedback.getId(), result.getId());
    }
    // 补充测试 getUserRegisteredMeetings 方法
    @Test
    void getUserRegisteredMeetings_WhenMeetingHasNullFields_ShouldHandleGracefully() {
        // 准备测试数据
        testMeeting.setMeetingContent(null);
        testMeeting.setCoverImage(null);
        testMeeting.setOrganizer(null);
        testMeeting.setLocation(null);
        testMeeting.setMeetingTime(null);

        List<MeetingRegistration> registrations = Collections.singletonList(testRegistration);

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(registrations);
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertNull(result.get(0).get("description"));
        assertNull(result.get(0).get("coverImage"));
        assertEquals("时间待定", result.get(0).get("meetingStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenRegistrationHasNullMeetingId_ShouldSkip() {
        testRegistration.setMeetingId(null);
        List<MeetingRegistration> registrations = Collections.singletonList(testRegistration);

        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(registrations);

        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // 补充测试 pageMeetings 方法
    @Test
    void pageMeetings_WithEmptyKeyword_ShouldNotApplyKeywordFilter() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(1, 10, "", null, null);

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    @Test
    void pageMeetings_WithEmptyDateStrings_ShouldNotApplyDateFilter() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));
        expectedPage.setTotal(1);

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "", "");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 补充测试 registerMeeting 方法
    @Test
    void registerMeeting_WhenUserHasNullFields_ShouldHandleGracefully() {
        testUser.setNickname(null);
        testUser.setPhone(null);
        testUser.setEmail(null);
        testUser.setCompanyName(null);

        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenReturn(1);

        boolean result = meetingService.registerMeeting(1L, 1L);

        assertTrue(result);
        verify(registrationMapper).insert(argThat(reg ->
                reg.getUserName().equals(testUser.getUsername()) &&
                        reg.getUserPhone() == null &&
                        reg.getUserEmail() == null &&
                        reg.getCompanyName() == null
        ));
    }

    // 补充测试 getUserRegisteredMeetingCount 方法
    @Test
    void getUserRegisteredMeetingCount_WhenCountIsNull_ShouldReturnZero() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(null);

        int result = meetingService.getUserRegisteredMeetingCount(1L);

        assertEquals(0, result);
    }

    // 补充测试 submitFeedback 方法
    @Test
    void submitFeedback_WhenFeedbackHasNullFields_ShouldHandleGracefully() {
        testFeedback.setContent(null);

        when(feedbackMapper.insert(any(MeetingFeedback.class)))
                .thenReturn(1);

        boolean result = meetingService.submitFeedback(testFeedback);

        assertTrue(result);
        verify(feedbackMapper).insert(argThat(fb ->
                fb.getContent() == null &&
                        fb.getSubmitTime() != null
        ));
    }
    @Test
    void registerMeeting_WhenInsertFails_ShouldReturnFalse() {
        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenReturn(0); // 插入返回0表示失败

        boolean result = meetingService.registerMeeting(1L, 1L);

        assertFalse(result);
    }

    @Test
    void registerMeeting_WhenUserHasNoNickname_ShouldUseUsername() {
        testUser.setNickname(null);

        when(registrationMapper.selectCount(any(QueryWrapper.class)))
                .thenReturn(0L);
        when(userMapper.selectById(anyLong()))
                .thenReturn(testUser);
        when(registrationMapper.insert(any(MeetingRegistration.class)))
                .thenReturn(1);

        boolean result = meetingService.registerMeeting(1L, 1L);

        assertTrue(result);
        verify(registrationMapper).insert(argThat(reg ->
                reg.getUserName().equals(testUser.getUsername())
        ));
    }
    @Test
    void getUserRegisteredMeetings_WhenMeetingTimeIsNull_ShouldSetStatusAsUndetermined() {
        testMeeting.setMeetingTime(null);

        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(testRegistration));
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(testMeeting);

        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        assertEquals("时间待定", result.get(0).get("meetingStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingIsNull_ShouldSkip() {
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(testRegistration));
        when(meetingMapper.selectById(anyLong()))
                .thenReturn(null);

        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        assertTrue(result.isEmpty());
    }
    @Test
    void pageMeetings_WithEmptyKeyword_ShouldNotBuildKeywordCondition() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));

        when(meetingMapper.selectPage(any(Page.class), argThat(wrapper -> {
            // 验证没有添加keyword条件
            return wrapper.getExpression().getNormal().isEmpty();
        }))).thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(1, 10, "", null, null);

        assertNotNull(result);
    }
    // 测试空日期字符串的情况 - 通过验证方法行为间接测试
    @Test
    void pageMeetings_WithEmptyStartDate_ShouldNotApplyStartDateFilter() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));

        // 使用doAnswer验证Wrapper构建逻辑
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenAnswer(invocation -> {
                    QueryWrapper<Meeting> wrapper = invocation.getArgument(1);
                    String sql = wrapper.getCustomSqlSegment(); // 获取生成的SQL片段

                    // 验证SQL中不包含startDate条件
                    assertFalse(sql.contains("create_time >= '2023-01-01 00:00:00'"));
                    return expectedPage;
                });

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "", "2023-12-31");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 测试所有过滤条件组合的情况 - 通过验证返回结果间接测试
    @Test
    void pageMeetings_WithAllFiltersCombined_ShouldApplyAllConditions() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));

        // 使用verify验证方法调用
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, "测试", 1, 1L,
                "2023-01-01", "2023-12-31");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());

        // 验证mapper方法被调用
        verify(meetingMapper).selectPage(any(Page.class), any(QueryWrapper.class));
    }

    // 测试日期范围无效的情况 - 通过结果验证
    @Test
    void pageMeetings_WithStartDateAfterEndDate_ShouldReturnEmptyPage() {
        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(new Page<Meeting>().setRecords(Collections.emptyList()));

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "2023-12-31", "2023-01-01");

        assertNotNull(result);
        assertTrue(result.getRecords().isEmpty());
    }

    // 测试仅使用日期过滤的情况 - 通过模拟数据验证
    @Test
    void pageMeetings_WithOnlyDateFilters_ShouldFilterCorrectly() {
        Meeting pastMeeting = new Meeting();
        pastMeeting.setId(2L);
        pastMeeting.setCreateTime(LocalDateTime.of(2023, 6, 1, 0, 0));

        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(pastMeeting));

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, null,
                "2023-01-01", "2023-12-31");

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(2L, result.getRecords().get(0).getId());
    }

    // 测试关键字和状态组合查询
    @Test
    void pageMeetings_WithKeywordAndStatus_ShouldApplyBothConditions() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, "测试", 1, null,
                null, null);

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // 测试创建者ID过滤
    @Test
    void pageMeetings_WithCreatorId_ShouldApplyCreatorFilter() {
        Page<Meeting> expectedPage = new Page<>(1, 10);
        expectedPage.setRecords(Collections.singletonList(testMeeting));

        when(meetingMapper.selectPage(any(Page.class), any(QueryWrapper.class)))
                .thenReturn(expectedPage);

        Page<Meeting> result = meetingService.pageMeetings(
                1, 10, null, null, 1L,
                null, null);

        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    @Test
    void submitFeedback_WhenFeedbackIsNull_ShouldReturnFalse() {
        // 调用方法
        boolean result = meetingService.submitFeedback(null);

        // 验证结果
        assertFalse(result);
        verifyNoInteractions(feedbackMapper);
    }

    @Test
    void submitFeedback_WhenInsertReturnsZero_ShouldReturnFalse() {
        when(feedbackMapper.insert(any(MeetingFeedback.class)))
                .thenReturn(0);

        boolean result = meetingService.submitFeedback(testFeedback);

        assertFalse(result);
    }

    @Test
    void submitFeedback_WhenFeedbackIdIsNull_ShouldStillSubmit() {
        testFeedback.setId(null);

        when(feedbackMapper.insert(any(MeetingFeedback.class)))
                .thenReturn(1);

        boolean result = meetingService.submitFeedback(testFeedback);

        assertTrue(result);
        verify(feedbackMapper).insert(argThat(fb -> fb.getId() == null));
    }
    @Test
    void getUserRegisteredMeetings_ShouldReturnCompleteMeetingInfo() {
        // 准备测试数据
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);
        registration.setRegistrationTime(LocalDateTime.now());

        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingName("测试会议");
        meeting.setMeetingContent("会议内容");
        meeting.setCoverImage("cover.jpg");
        meeting.setOrganizer("组织者");
        meeting.setMeetingTime(LocalDateTime.now().plusDays(1));
        meeting.setLocation("会议室A");
        meeting.setStatus(1);
        meeting.setCreateTime(LocalDateTime.now());

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(meeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());

        Map<String, Object> meetingInfo = result.get(0);
        assertEquals(meeting.getId(), meetingInfo.get("id"));
        assertEquals(meeting.getMeetingName(), meetingInfo.get("title"));
        assertEquals(meeting.getMeetingContent(), meetingInfo.get("description"));
        assertEquals(meeting.getCoverImage(), meetingInfo.get("coverImage"));
        assertEquals(meeting.getOrganizer(), meetingInfo.get("organizer"));
        assertEquals(meeting.getMeetingTime(), meetingInfo.get("startTime"));
        assertEquals(meeting.getMeetingTime().plusHours(2), meetingInfo.get("endTime"));
        assertEquals(meeting.getLocation(), meetingInfo.get("location"));
        assertEquals(meeting.getStatus(), meetingInfo.get("status"));
        assertEquals(meeting.getCreateTime(), meetingInfo.get("createTime"));
        assertEquals(registration.getRegistrationTime(), meetingInfo.get("enrollTime"));
        assertEquals("即将开始", meetingInfo.get("meetingStatus"));
        assertEquals("已报名", meetingInfo.get("participationStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingInProgress_ShouldReturnCorrectStatus() {
        // 准备测试数据 - 会议正在进行中
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);
        registration.setRegistrationTime(LocalDateTime.now());

        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingTime(LocalDateTime.now().minusMinutes(30)); // 30分钟前开始
        meeting.setStatus(1);

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(meeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证状态
        assertEquals("进行中", result.get(0).get("meetingStatus"));
        assertEquals("已参加", result.get(0).get("participationStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingEnded_ShouldReturnCorrectStatus() {
        // 准备测试数据 - 会议已结束
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);
        registration.setRegistrationTime(LocalDateTime.now());

        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingTime(LocalDateTime.now().minusHours(3)); // 3小时前开始
        meeting.setStatus(1);

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(meeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证状态
        assertEquals("已结束", result.get(0).get("meetingStatus"));
        assertEquals("已参加", result.get(0).get("participationStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingTimeIsNull_ShouldReturnUndeterminedStatus() {
        // 准备测试数据 - 会议时间未定
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);

        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingTime(null); // 会议时间为null

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(meeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证状态
        assertEquals("时间待定", result.get(0).get("meetingStatus"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMultipleRegistrations_ShouldReturnAll() {
        // 准备测试数据 - 多个报名记录
        MeetingRegistration reg1 = new MeetingRegistration();
        reg1.setId(1L);
        reg1.setMeetingId(1L);
        reg1.setUserId(1L);

        MeetingRegistration reg2 = new MeetingRegistration();
        reg2.setId(2L);
        reg2.setMeetingId(2L);
        reg2.setUserId(1L);

        Meeting meeting1 = new Meeting();
        meeting1.setId(1L);
        meeting1.setMeetingName("会议1");

        Meeting meeting2 = new Meeting();
        meeting2.setId(2L);
        meeting2.setMeetingName("会议2");

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Arrays.asList(reg1, reg2));
        when(meetingMapper.selectById(1L)).thenReturn(meeting1);
        when(meetingMapper.selectById(2L)).thenReturn(meeting2);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果
        assertEquals(2, result.size());
        assertEquals("会议1", result.get(0).get("title"));
        assertEquals("会议2", result.get(1).get("title"));
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingNotFound_ShouldSkip() {
        // 准备测试数据
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);

        // 模拟行为 - 会议不存在
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(null);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果 - 应该跳过无效记录
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserRegisteredMeetings_WhenExceptionOccurs_ShouldReturnEmptyList() {
        // 模拟数据库异常
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenThrow(new RuntimeException("Database error"));

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果 - 异常时应返回空列表
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserRegisteredMeetings_WhenNoRegistrations_ShouldReturnEmptyList() {
        // 模拟无报名记录
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.emptyList());

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserRegisteredMeetings_WhenMeetingFieldsAreNull_ShouldHandleGracefully() {
        // 准备测试数据 - 会议字段为null
        MeetingRegistration registration = new MeetingRegistration();
        registration.setId(1L);
        registration.setMeetingId(1L);
        registration.setUserId(1L);

        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingName("测试会议");
        // 其他字段保持null

        // 模拟行为
        when(registrationMapper.selectList(any(QueryWrapper.class)))
                .thenReturn(Collections.singletonList(registration));
        when(meetingMapper.selectById(1L)).thenReturn(meeting);

        // 调用方法
        List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(1L);

        // 验证结果 - 应该处理null字段
        assertNotNull(result);
        assertEquals(1, result.size());
        assertNull(result.get(0).get("description"));
        assertNull(result.get(0).get("coverImage"));
        assertNull(result.get(0).get("organizer"));
        assertNull(result.get(0).get("startTime"));
        assertNull(result.get(0).get("endTime"));
        assertNull(result.get(0).get("location"));
    }
}