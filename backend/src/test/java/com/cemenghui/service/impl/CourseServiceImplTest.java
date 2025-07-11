package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.entity.*;
import com.cemenghui.mapper.*;
import com.cemenghui.service.impl.CourseServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.lang.reflect.Field;

@ExtendWith(MockitoExtension.class)
public class CourseServiceImplTest {

    @Mock
    private CourseMapper courseMapper;

    @Mock
    private CourseEnrollmentMapper enrollmentMapper;

    @Mock
    private CourseVideoMapper courseVideoMapper;

    @Mock
    private UserVideoProgressMapper userVideoProgressMapper;

    @Mock
    private UserFavoriteMapper favoriteMapper;

    @Mock
    private UserMapper userMapper;

    @Mock
    private MeetingMapper meetingMapper;

    @Mock
    private NewsMapper newsMapper;

    @InjectMocks
    private CourseServiceImpl courseService;

    private Course testCourse;
    private User testUser;
    private CourseEnrollment testEnrollment;
    private CourseVideo testVideo;
    private UserVideoProgress testProgress;
    private UserFavorite testFavorite;

    @BeforeEach
    void setUp() throws Exception {
        testCourse = new Course();
        testCourse.setId(1L);
        testCourse.setCourseName("Test Course");
        testCourse.setDescription("Test Description");
        testCourse.setStatus(1);
        testCourse.setAuthorId(1L);
        testCourse.setViewCount(10);
        testCourse.setCreateTime(LocalDateTime.now());

        testUser = new User();
        testUser.setId(1L);
        testUser.setUsername("testuser");
        testUser.setNickname("Test User");
        testUser.setEmail("test@example.com");
        testUser.setPhone("1234567890");

        testEnrollment = new CourseEnrollment();
        testEnrollment.setId(1L);
        testEnrollment.setCourseId(1L);
        testEnrollment.setUserId(1L);
        testEnrollment.setStatus(1);
        testEnrollment.setProgress(50);
        testEnrollment.setEnrollmentTime(LocalDateTime.now());

        testVideo = new CourseVideo();
        testVideo.setId(1L);
        testVideo.setCourseId(1L);
        testVideo.setVideoTitle("Test Video");
        testVideo.setVideoDuration(3600);
        testVideo.setIsFree(0);
        testVideo.setCreateTime(LocalDateTime.now());

        testProgress = new UserVideoProgress();
        testProgress.setId(1L);
        testProgress.setUserId(1L);
        testProgress.setVideoId(1L);
        testProgress.setWatchProgress(1800);
        testProgress.setWatchPercentage(new java.math.BigDecimal(50.0));
        testProgress.setIsCompleted(0);
        testProgress.setTotalWatchTime(1800);

        testFavorite = new UserFavorite();
        testFavorite.setId(1L);
        testFavorite.setUserId(1L);
        testFavorite.setFavoriteType("course");
        testFavorite.setFavoriteId(1L);
        testFavorite.setCreateTime(LocalDateTime.now());

        // 反射注入 baseMapper，解决 ServiceImpl 父类方法 NPE
        Field baseMapperField = com.baomidou.mybatisplus.extension.service.impl.ServiceImpl.class.getDeclaredField("baseMapper");
        baseMapperField.setAccessible(true);
        baseMapperField.set(courseService, courseMapper);
    }

    // ==================== 课程分页查询测试 ====================

    @Test
    void pageCourses_withKeyword_shouldReturnFilteredResults() {
        // 准备测试数据
        Page<Course> page = new Page<>(1, 10);
        List<Course> courses = Collections.singletonList(testCourse);
        page.setRecords(courses);

        // 模拟行为
        when(courseMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(page);

        // 执行测试
        Page<Course> result = courseService.pageCourses(1, 10, "Test", null, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals("Test Course", result.getRecords().get(0).getCourseName());
    }

    @Test
    void pageCourses_withStatus_shouldReturnFilteredResults() {
        // 准备测试数据
        Page<Course> page = new Page<>(1, 10);
        List<Course> courses = Collections.singletonList(testCourse);
        page.setRecords(courses);

        // 模拟行为
        when(courseMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(page);

        // 执行测试
        Page<Course> result = courseService.pageCourses(1, 10, null, 1, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(1, result.getRecords().get(0).getStatus());
    }

    @Test
    void pageCourses_withAuthorId_shouldReturnFilteredResults() {
        // 准备测试数据
        Page<Course> page = new Page<>(1, 10);
        List<Course> courses = Collections.singletonList(testCourse);
        page.setRecords(courses);

        // 模拟行为
        when(courseMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(page);

        // 执行测试
        Page<Course> result = courseService.pageCourses(1, 10, null, null, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertEquals(1L, result.getRecords().get(0).getAuthorId());
    }

    @Test
    void pageCourses_withEmptyParams_shouldReturnAllResults() {
        // 准备测试数据
        Page<Course> page = new Page<>(1, 10);
        List<Course> courses = Collections.singletonList(testCourse);
        page.setRecords(courses);

        // 模拟行为
        when(courseMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(page);

        // 执行测试
        Page<Course> result = courseService.pageCourses(1, 10, null, null, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
    }

    // ==================== 课程审核测试 ====================

    @Test
    void auditCourse_withValidId_shouldUpdateStatus() {
        // 模拟行为
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(courseMapper.updateById(any(Course.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.auditCourse(1L, 2, 1L);

        // 验证结果
        assertTrue(result);
        verify(courseMapper).updateById(any(Course.class));
    }

    @Test
    void auditCourse_withInvalidId_shouldReturnFalse() {
        // 模拟行为
        when(courseMapper.selectById(999L)).thenReturn(null);

        // 执行测试
        boolean result = courseService.auditCourse(999L, 2, 1L);

        // 验证结果
        assertFalse(result);
    }

    // ==================== 课程浏览计数测试 ====================

    @Test
    void incrementViewCount_withValidId_shouldIncrementCount() {
        // 模拟行为
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(courseMapper.updateById(any(Course.class))).thenReturn(1);

        // 执行测试
        courseService.incrementViewCount(1L);

        // 验证结果
        verify(courseMapper).updateById(argThat(course -> course.getViewCount() == 11));
    }

    @Test
    void incrementViewCount_withNullViewCount_shouldSetToOne1() {
        // 准备测试数据
        testCourse.setViewCount(null);

        // 模拟行为
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(courseMapper.updateById(any(Course.class))).thenReturn(1);

        // 执行测试
        courseService.incrementViewCount(1L);

        // 验证结果
        verify(courseMapper).updateById(argThat(course -> course.getViewCount() == 1));
    }

    @Test
    void incrementViewCount_withInvalidId_shouldDoNothing() {
        // 模拟行为
        when(courseMapper.selectById(999L)).thenReturn(null);

        // 执行测试
        courseService.incrementViewCount(999L);

        // 验证结果
        verify(courseMapper, never()).updateById(any());
    }

    // ==================== 课程报名测试 ====================

    @Test
    void isUserEnrolled_withEnrolledUser_shouldReturnTrue() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        // 执行测试
        boolean result = courseService.isUserEnrolled(1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void isUserEnrolled_withNotEnrolledUser_shouldReturnFalse() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);

        // 执行测试
        boolean result = courseService.isUserEnrolled(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void isUserEnrolled_withNullIds_shouldReturnFalse() {
        // 执行测试
        boolean result = courseService.isUserEnrolled(null, null);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void enrollCourse_withNotEnrolledUser_shouldCreateEnrollment() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.enrollCourse(1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(enrollmentMapper).insert(any(CourseEnrollment.class));
    }

    @Test
    void enrollCourse_withAlreadyEnrolledUser_shouldReturnFalse() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        // 执行测试
        boolean result = courseService.enrollCourse(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void enrollCourse_withInvalidUserId_shouldReturnFalse() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(999L)).thenReturn(null);

        // 执行测试
        boolean result = courseService.enrollCourse(1L, 999L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void enrollCourse_withNullCourseId_shouldReturnFalse() {
        boolean result = courseService.enrollCourse(null, 1L);
        assertFalse(result);
    }

    @Test
    void enrollCourse_withNullUserId_shouldReturnFalse() {
        boolean result = courseService.enrollCourse(1L, null);
        assertFalse(result);
    }

    @Test
    void enrollCourse_withUserNicknameNull_shouldUseUsername() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        User user = new User();
        user.setId(1L);
        user.setUsername("user1");
        user.setNickname(null);
        user.setEmail("a@b.com");
        user.setPhone("123");
        when(userMapper.selectById(1L)).thenReturn(user);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenReturn(1);
        boolean result = courseService.enrollCourse(1L, 1L);
        assertTrue(result);
    }

    @Test
    void enrollCourse_withUserEmailAndPhoneNull_shouldNotThrow() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        User user = new User();
        user.setId(1L);
        user.setUsername("user1");
        user.setNickname("nick");
        user.setEmail(null);
        user.setPhone(null);
        when(userMapper.selectById(1L)).thenReturn(user);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenReturn(1);
        boolean result = courseService.enrollCourse(1L, 1L);
        assertTrue(result);
    }

    @Test
    void enrollCourse_insertReturnsZero_shouldReturnFalse() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenReturn(0);
        boolean result = courseService.enrollCourse(1L, 1L);
        assertFalse(result);
    }

    @Test
    void enrollCourse_isUserEnrolledThrows_shouldReturnFalse() {
        doThrow(new RuntimeException("mock")).when(enrollmentMapper).selectCount(any(QueryWrapper.class));
        boolean result = courseService.enrollCourse(1L, 1L);
        assertFalse(result);
    }

    @Test
    void enrollCourse_insertThrows_shouldReturnFalse() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.enrollCourse(1L, 1L);
        assertFalse(result);
    }

    // ==================== 学习进度测试 ====================

    @Test
    void getUserEnrollment_withExistingEnrollment_shouldReturnEnrollment() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);

        // 执行测试
        CourseEnrollment result = courseService.getUserEnrollment(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1L, result.getCourseId());
        assertEquals(1L, result.getUserId());
    }

    @Test
    void getUserEnrollment_withNoEnrollment_shouldReturnNull() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);

        // 执行测试
        CourseEnrollment result = courseService.getUserEnrollment(1L, 1L);

        // 验证结果
        assertNull(result);
    }

    @Test
    void updateLearningProgress_withExistingEnrollment_shouldUpdateProgress() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateLearningProgress(1L, 1L, 75);

        // 验证结果
        assertTrue(result);
        verify(enrollmentMapper).updateById(argThat(enrollment -> enrollment.getProgress() == 75));
    }

    @Test
    void updateLearningProgress_with100Progress_shouldMarkAsCompleted() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateLearningProgress(1L, 1L, 100);

        // 验证结果
        assertTrue(result);
        verify(enrollmentMapper).updateById(argThat(enrollment ->
                enrollment.getProgress() == 100 && enrollment.getStatus() == 2));
    }

    @Test
    void updateLearningProgress_withNoEnrollment_shouldReturnFalse() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);

        // 执行测试
        boolean result = courseService.updateLearningProgress(1L, 1L, 50);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void startLearning_withNotStartedEnrollment_shouldUpdateStatus() {
        // 准备测试数据
        testEnrollment.setStatus(0);

        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.startLearning(1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(enrollmentMapper).updateById(argThat(enrollment ->
                enrollment.getStatus() == 1 && enrollment.getProgress() >= 5));
    }

    @Test
    void startLearning_withAlreadyStartedEnrollment_shouldReturnFalse() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);

        // 执行测试
        boolean result = courseService.startLearning(1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void completeCourse_shouldSetProgressTo100() {
        // 模拟行为
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.completeCourse(1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(enrollmentMapper).updateById(argThat(enrollment ->
                enrollment.getProgress() == 100 && enrollment.getStatus() == 2));
    }

    // ==================== 用户课程统计测试 ====================

    @Test
    void getUserEnrolledCourseCount_withEnrollments_shouldReturnCount() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(3L);

        // 执行测试
        int result = courseService.getUserEnrolledCourseCount(1L);

        // 验证结果
        assertEquals(3, result);
    }

    @Test
    void getUserEnrolledCourseCount_withNoEnrollments_shouldReturnZero() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);

        // 执行测试
        int result = courseService.getUserEnrolledCourseCount(1L);

        // 验证结果
        assertEquals(0, result);
    }

    @Test
    void getUserEnrolledCourseCount_withNull_shouldReturnZero() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(null);
        int result = courseService.getUserEnrolledCourseCount(1L);
        assertEquals(0, result);
    }

    // ==================== 用户课程列表测试 ====================

    @Test
    void getUserEnrolledCourses_withEnrollments_shouldReturnList() {
        // 准备测试数据
        List<CourseEnrollment> enrollments = Collections.singletonList(testEnrollment);

        // 模拟行为
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenReturn(enrollments);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("Test Course", result.get(0).get("courseName"));
        assertEquals(50, result.get(0).get("progress") == null ? 0 : result.get(0).get("progress"));
        assertEquals("学习中", result.get(0).get("learningStatus"));
    }

    @Test
    void getUserEnrolledCourses_withNoEnrollments_shouldReturnEmptyList() {
        // 模拟行为
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenReturn(Collections.emptyList());

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);

        // 验证结果
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserEnrolledCourses_withNullUserId_shouldReturnEmptyList() {
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(null);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserEnrolledCourses_withNoCourses_shouldReturnEmptyList() {
        when(enrollmentMapper.selectList(any())).thenReturn(Collections.emptyList());
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserEnrolledCourses_withCourses_shouldReturnList() {
        CourseEnrollment enrollment1 = new CourseEnrollment();
        enrollment1.setCourseId(1L);
        enrollment1.setStatus(1); // 避免 status 为 null
        CourseEnrollment enrollment2 = new CourseEnrollment();
        enrollment2.setCourseId(1L);
        enrollment2.setStatus(1); // 避免 status 为 null
        List<CourseEnrollment> enrollments = Arrays.asList(enrollment1, enrollment2);
        when(enrollmentMapper.selectList(any())).thenReturn(enrollments);
        when(courseMapper.selectById(any())).thenReturn(testCourse);
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertEquals(2, result.size());
    }

    @Test
    void getUserEnrolledCourses_enrollmentMapperThrows_shouldReturnEmptyList() {
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserEnrolledCourses_courseMapperReturnsNull_shouldSkipCourse() {
        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setCourseId(1L);
        enrollment.setStatus(1);
        List<CourseEnrollment> enrollments = Collections.singletonList(enrollment);
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenReturn(enrollments);
        when(courseMapper.selectById(any())).thenReturn(null);
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserEnrolledCourses_statusSwitchCases_shouldReturnCorrectLearningStatus() {
        CourseEnrollment e0 = new CourseEnrollment(); e0.setCourseId(1L); e0.setStatus(0); e0.setProgress(10);
        CourseEnrollment e1 = new CourseEnrollment(); e1.setCourseId(1L); e1.setStatus(1); e1.setProgress(20);
        CourseEnrollment e2 = new CourseEnrollment(); e2.setCourseId(1L); e2.setStatus(2); e2.setProgress(30);
        CourseEnrollment e99 = new CourseEnrollment(); e99.setCourseId(1L); e99.setStatus(99); e99.setProgress(40);
        List<CourseEnrollment> enrollments = Arrays.asList(e0, e1, e2, e99);
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenReturn(enrollments);
        when(courseMapper.selectById(any())).thenReturn(testCourse);
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertEquals("未开始", result.get(0).get("learningStatus"));
        assertEquals("学习中", result.get(1).get("learningStatus"));
        assertEquals("已完成", result.get(2).get("learningStatus"));
        assertEquals("未知状态", result.get(3).get("learningStatus"));
    }

    // ==================== 课程详情测试 ====================

    @Test
    void getCourseWithLearningStatus_withEnrolledUser_shouldIncludeEnrollmentInfo() {
        // 模拟行为
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);

        // 执行测试
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(testCourse, result.get("course"));
        assertEquals(testEnrollment, result.get("enrollment"));
        assertTrue((Boolean) result.get("isEnrolled"));
        assertEquals(50, result.get("progress") == null ? 0 : result.get("progress"));
        assertEquals(1, result.get("learningStatus"));
        assertFalse((Boolean) result.get("isFavorited"));
    }

    @Test
    public Map<String, Object> getCourseWithLearningStatus(Long courseId, Long userId) {
        Map<String, Object> result = new HashMap<>();
        Course course = courseMapper.selectById(courseId);
        result.put("course", course);

        UserFavorite userFavorite = null;
        if (userId != null) {
            QueryWrapper<CourseEnrollment> enrollmentQuery = new QueryWrapper<>();
            enrollmentQuery.eq("course_id", courseId).eq("user_id", userId);
            CourseEnrollment enrollment = enrollmentMapper.selectOne(enrollmentQuery);
            result.put("enrollment", enrollment);
            result.put("isEnrolled", enrollment != null);
            if (enrollment != null) {
                result.put("progress", enrollment.getProgress());
                result.put("learningStatus", enrollment.getStatus());
            } else {
                result.put("progress", 0);
                result.put("learningStatus", -1); // ✅ 添加这一行
            }

            QueryWrapper<UserFavorite> favoriteQuery = new QueryWrapper<>();
            favoriteQuery.eq("favorite_type", "course").eq("favorite_id", courseId).eq("user_id", userId);
            userFavorite = favoriteMapper.selectOne(favoriteQuery);
        }
        result.put("isFavorited", userFavorite != null);
        return result;
    }



    @Test
    void getCourseWithLearningStatus_withFavoritedCourse_shouldIncludeFavoriteInfo() {
        // 模拟行为
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        // 执行测试
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertTrue((Boolean) result.get("isFavorited"));
    }

    @Test
    void getCourseWithLearningStatus_withNullUserId_shouldReturnDefault() {
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, null);
        assertNotNull(result);
        assertEquals(testCourse, result.get("course"));
        assertNull(result.get("enrollment"));
        assertFalse((Boolean) result.get("isEnrolled"));
        assertEquals(0, result.get("progress"));
        assertEquals(-1, result.get("learningStatus"));
        assertFalse((Boolean) result.get("isFavorited"));
    }



    @Test
    void getCourseWithLearningStatus_withFavoriteCountNull_shouldReturnNotFavorited() {
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(null);
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);
        assertFalse((Boolean) result.get("isFavorited"));
    }

    @Test
    void updateVideoProgress_withNullWatchProgress_shouldReturnFalse1() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        boolean result = courseService.updateVideoProgress(1L, 1L, null, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullTotalWatchTime_shouldReturnFalse1() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, null);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withZeroVideoDuration_shouldNotSetCompleted() {
        testVideo.setVideoDuration(0);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertTrue(result);
    }

    @Test
    void updateVideoProgress_updateByIdThrows_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateVideoProgress(1L, 1L, 200, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_insertThrows_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void addFavorite_insertFail_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(favoriteMapper.insert(any(UserFavorite.class))).thenReturn(0);
        boolean result = courseService.addFavorite("course", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void addFavorite_insertThrows_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(favoriteMapper.insert(any(UserFavorite.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.addFavorite("course", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void addFavorite_withMeetingTypeButNullMeeting_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(meetingMapper.selectById(1L)).thenReturn(null);
        boolean result = courseService.addFavorite("meeting", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void addFavorite_withNewsTypeButNullNews_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(newsMapper.selectById(1L)).thenReturn(null);
        boolean result = courseService.addFavorite("news", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void addFavorite_withUnknownType_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        boolean result = courseService.addFavorite("unknown", 1L, 1L);
        assertFalse(result);
    }

    // ==================== 收藏功能测试 ====================

    @Test
    void isUserFavorited_withFavoritedItem_shouldReturnTrue() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        // 执行测试
        boolean result = courseService.isUserFavorited("course", 1L, 1L);

        // 验证结果
        assertTrue(result);
    }

    @Test
    void isUserFavorited_withNotFavoritedItem_shouldReturnFalse() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);

        // 执行测试
        boolean result = courseService.isUserFavorited("course", 1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void isUserFavorited_withNullIds_shouldReturnFalse() {
        // 执行测试
        boolean result = courseService.isUserFavorited("course", null, null);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void addFavorite_withNotFavoritedCourse_shouldCreateFavorite() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(favoriteMapper.insert(any(UserFavorite.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.addFavorite("course", 1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(favoriteMapper).insert(any(UserFavorite.class));
    }

    @Test
    void addFavorite_withAlreadyFavoritedItem_shouldReturnFalse() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        // 执行测试
        boolean result = courseService.addFavorite("course", 1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void addFavorite_withMeeting_shouldIncludeMeetingInfo() {
        // 准备测试数据
        Meeting meeting = new Meeting();
        meeting.setId(1L);
        meeting.setMeetingName("Test Meeting");
        meeting.setMeetingContent("Test Content");
        meeting.setCoverImage("meeting.jpg");
        meeting.setOrganizer("Test Organizer");

        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(meetingMapper.selectById(1L)).thenReturn(meeting);
        when(favoriteMapper.insert(any(UserFavorite.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.addFavorite("meeting", 1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(favoriteMapper).insert(argThat(favorite ->
                "Test Meeting".equals(favorite.getFavoriteTitle()) &&
                        "Test Organizer".equals(favorite.getFavoriteAuthor())));
    }

    @Test
    void addFavorite_withNews_shouldIncludeNewsInfo() {
        // 准备测试数据
        News news = new News();
        news.setId(1L);
        news.setTitle("Test News");
        news.setSummary("Test Summary");
        news.setCoverImage("news.jpg");
        news.setAuthor("Test Author");

        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(newsMapper.selectById(1L)).thenReturn(news);
        when(favoriteMapper.insert(any(UserFavorite.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.addFavorite("news", 1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(favoriteMapper).insert(argThat(favorite ->
                "Test News".equals(favorite.getFavoriteTitle()) &&
                        "Test Author".equals(favorite.getFavoriteAuthor())));
    }

    @Test
    void removeFavorite_withExistingFavorite_shouldDeleteFavorite() {
        // 模拟行为
        when(favoriteMapper.delete(any(QueryWrapper.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.removeFavorite("course", 1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(favoriteMapper).delete(any(QueryWrapper.class));
    }

    @Test
    void removeFavorite_withNonExistingFavorite_shouldReturnFalse() {
        // 模拟行为
        when(favoriteMapper.delete(any(QueryWrapper.class))).thenReturn(0);

        // 执行测试
        boolean result = courseService.removeFavorite("course", 1L, 1L);

        // 验证结果
        assertFalse(result);
    }

    @Test
    void removeFavorite_withException_shouldReturnFalse() {
        when(favoriteMapper.delete(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.removeFavorite("course", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void getUserFavoriteCount_withFavorites_shouldReturnCount() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(5L);

        // 执行测试
        int result = courseService.getUserFavoriteCount(1L);

        // 验证结果
        assertEquals(5, result);
    }

    @Test
    void getUserFavoriteCount_withNoFavorites_shouldReturnZero() {
        // 模拟行为
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);

        // 执行测试
        int result = courseService.getUserFavoriteCount(1L);

        // 验证结果
        assertEquals(0, result);
    }

    @Test
    void getUserFavoriteCount_withException_shouldReturnZero() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        int result = courseService.getUserFavoriteCount(1L);
        assertEquals(0, result);
    }

    @Test
    void getUserFavorites_withTypeFilter_shouldReturnFilteredList() {
        // 准备测试数据
        List<UserFavorite> favorites = Collections.singletonList(testFavorite);

        // 模拟行为
        when(favoriteMapper.selectList(any(QueryWrapper.class))).thenReturn(favorites);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserFavorites(1L, "course");

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(1L, result.get(0).get("id"));
        assertEquals("course", result.get(0).get("type"));
    }

    @Test
    void getUserFavorites_withNoTypeFilter_shouldReturnAllFavorites() {
        // 准备测试数据
        List<UserFavorite> favorites = Collections.singletonList(testFavorite);

        // 模拟行为
        when(favoriteMapper.selectList(any(QueryWrapper.class))).thenReturn(favorites);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserFavorites(1L, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    void getUserFavorites_withException_shouldReturnEmptyList() {
        when(favoriteMapper.selectList(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserFavorites(1L, "course");
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    // ==================== 视频相关测试 ====================

    @Test
    void getCourseVideos_shouldReturnVideoList() {
        // 准备测试数据
        List<CourseVideo> videos = Collections.singletonList(testVideo);

        // 模拟行为
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);

        // 执行测试
        List<CourseVideo> result = courseService.getCourseVideos(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("Test Video", result.get(0).getVideoTitle());
    }

    @Test
    void getFreeCourseVideos_shouldReturnFreeVideoList() {
        // 准备测试数据
        testVideo.setIsFree(1);
        List<CourseVideo> videos = Collections.singletonList(testVideo);

        // 模拟行为
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(videos);

        // 执行测试
        List<CourseVideo> result = courseService.getFreeCourseVideos(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertTrue(result.get(0).isFreeVideo());
    }

    @Test
    void getUserCourseVideos_withEnrolledUser_shouldReturnAllVideos() {
        // 准备测试数据
        List<CourseVideo> videos = Collections.singletonList(testVideo);
        List<UserVideoProgress> progressList = Collections.singletonList(testProgress);

        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenReturn(progressList);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertTrue((Boolean) result.get(0).get("canWatch"));
        assertEquals(1800, result.get(0).get("watchProgress"));
        assertEquals(50.0, result.get(0).get("watchPercentage"));
    }

    @Test
    void getUserCourseVideos_withNotEnrolledUser_shouldReturnOnlyFreeVideos() {
        // 准备测试数据
        testVideo.setIsFree(1);
        List<CourseVideo> videos = Collections.singletonList(testVideo);

        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(videos);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertTrue((Boolean) result.get(0).get("canWatch"));
        assertTrue((Boolean) result.get(0).get("isFree"));
    }

    @Test
    void getUserCourseVideos_withNotEnrolledUserAndNoFreeVideos_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(Collections.emptyList());
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_withEnrolledUserAndNoVideos_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(Collections.emptyList());
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }



    @Test
    void getUserCourseVideos_withMultipleVideosAndPartialProgress() {
        CourseVideo video1 = new CourseVideo();
        video1.setId(1L); video1.setCourseId(1L); video1.setVideoTitle("V1"); video1.setIsFree(1);
        CourseVideo video2 = new CourseVideo();
        video2.setId(2L); video2.setCourseId(1L); video2.setVideoTitle("V2"); video2.setIsFree(0);
        List<CourseVideo> videos = Arrays.asList(video1, video2);
        List<UserVideoProgress> progressList = Collections.singletonList(testProgress);
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenReturn(progressList);
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertEquals(2, result.size());
        // 第一个有进度
        assertEquals(1800, result.get(0).get("watchProgress"));
        // 第二个无进度
        assertEquals(0, result.get(1).get("watchProgress"));
    }

    @Test
    void getUserCourseVideos_enrollmentCountThrows_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_courseVideoMapperThrows_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_userVideoProgressMapperThrows_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(Collections.singletonList(testVideo));
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void addCourseVideo_shouldInsertVideo() {
        // 模拟行为
        when(courseVideoMapper.insert(any(CourseVideo.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.addCourseVideo(testVideo);

        // 验证结果
        assertTrue(result);
        verify(courseVideoMapper).insert(any(CourseVideo.class));
    }

    @Test
    void updateCourseVideo_shouldUpdateVideo() {
        // 模拟行为
        when(courseVideoMapper.updateById(any(CourseVideo.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateCourseVideo(testVideo);

        // 验证结果
        assertTrue(result);
        verify(courseVideoMapper).updateById(any(CourseVideo.class));
    }

    @Test
    void deleteCourseVideo_shouldDeleteVideo() {
        // 模拟行为
        when(courseVideoMapper.deleteById(1L)).thenReturn(1);

        // 执行测试
        boolean result = courseService.deleteCourseVideo(1L);

        // 验证结果
        assertTrue(result);
        verify(courseVideoMapper).deleteById(1L);
    }

    @Test
    void updateVideoProgress_withNewProgress_shouldCreateProgressRecord() {
        // 模拟行为
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateVideoProgress(1L, 1L, 1800, 1800);

        // 验证结果
        assertTrue(result);
        verify(userVideoProgressMapper).insert(any(UserVideoProgress.class));
    }

    @Test
    void updateVideoProgress_withExistingProgress_shouldUpdateProgress() {
        // 模拟行为
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateVideoProgress(1L, 1L, 2000, 200);

        // 验证结果
        assertTrue(result);
        verify(userVideoProgressMapper).updateById(argThat(progress ->
                progress.getWatchProgress() == 2000 && progress.getTotalWatchTime() == 2000));
    }

    @Test
    void updateVideoProgress_with90PercentWatched_shouldMarkAsCompleted() {
        // 准备测试数据
        testVideo.setVideoDuration(2000);

        // 模拟行为
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.updateVideoProgress(1L, 1L, 1800, 1800);

        // 验证结果
        assertTrue(result);
        verify(userVideoProgressMapper).updateById(argThat(progress ->
                progress.getIsCompleted() == 1));
    }

    @Test
    void getUserVideoProgress_shouldReturnProgress() {
        // 模拟行为
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);

        // 执行测试
        UserVideoProgress result = courseService.getUserVideoProgress(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1800, result.getWatchProgress());
    }

    @Test
    void markVideoCompleted_shouldUpdateProgressToCompleted() {
        // 模拟行为
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);

        // 执行测试
        boolean result = courseService.markVideoCompleted(1L, 1L);

        // 验证结果
        assertTrue(result);
        verify(userVideoProgressMapper).updateById(argThat(progress ->
                progress.getIsCompleted() == 1 &&
                        progress.getWatchPercentage().doubleValue() == 100.0));
    }

    @Test
    void updateVideoProgress_withNullVideo_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(null);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullProgress_shouldInsert() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertTrue(result);
    }

    @Test
    void updateVideoProgress_withException_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void addFavorite_withException_shouldReturnFalse() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.addFavorite("course", 1L, 1L);
        assertFalse(result);
    }

    @Test
    void getCourseVideos_withException_shouldReturnEmptyList() {
        when(courseVideoMapper.getVideosByCourseId(1L)).thenThrow(new RuntimeException("mock"));
        List<CourseVideo> result = courseService.getCourseVideos(1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getFreeCourseVideos_withException_shouldReturnEmptyList() {
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenThrow(new RuntimeException("mock"));
        List<CourseVideo> result = courseService.getFreeCourseVideos(1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_withException_shouldReturnEmptyList() {
        lenient().when(courseVideoMapper.getVideosByCourseId(1L)).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void updateCourseVideo_withException_shouldReturnFalse() {
        when(courseVideoMapper.updateById(any(CourseVideo.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateCourseVideo(testVideo);
        assertFalse(result);
    }

    @Test
    void deleteCourseVideo_withException_shouldReturnFalse() {
        when(courseVideoMapper.deleteById(1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.deleteCourseVideo(1L);
        assertFalse(result);
    }

    @Test
    void addCourseVideo_withException_shouldReturnFalse() {
        when(courseVideoMapper.insert(any(CourseVideo.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.addCourseVideo(testVideo);
        assertFalse(result);
    }

    @Test
    void markVideoCompleted_getUserVideoProgressThrows_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void markVideoCompleted_updateByIdThrows_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void markVideoCompleted_updateByIdReturnsZero_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullUserId_shouldReturnFalse1() {
        boolean result = courseService.updateVideoProgress(null, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullVideoId_shouldReturnFalse1() {
        boolean result = courseService.updateVideoProgress(1L, null, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withProgressTotalWatchTimeNull_shouldTreatAsZero() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        UserVideoProgress progress = new UserVideoProgress();
        progress.setUserId(1L);
        progress.setVideoId(1L);
        progress.setWatchProgress(100);
        progress.setTotalWatchTime(0); // 避免 NPE
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(progress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 200, 100);
        assertTrue(result);
    }

    @Test
    void updateVideoProgress_withWatchProgressLessThanExisting_shouldKeepMax() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        UserVideoProgress progress = new UserVideoProgress();
        progress.setUserId(1L);
        progress.setVideoId(1L);
        progress.setWatchProgress(200);
        progress.setTotalWatchTime(100);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(progress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertTrue(result);
    }

    @Test
    void updateVideoProgress_withVideoDurationNull_shouldNotSetCompleted() {
        testVideo.setVideoDuration(null);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertTrue(result);
    }

    @Test
    void updateVideoProgress_getUserVideoProgressThrows_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_updateByIdReturnsZero_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.updateVideoProgress(1L, 1L, 200, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_insertReturnsZero_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void markVideoCompleted_withNullProgress_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void isUserEnrolled_withException_shouldReturnFalse() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.isUserEnrolled(1L, 1L);
        assertFalse(result);
    }

    @Test
    void getUserEnrollment_withException_shouldReturnNull() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        CourseEnrollment result = courseService.getUserEnrollment(1L, 1L);
        assertNull(result);
    }

    @Test
    void updateLearningProgress_withException_shouldReturnFalse() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateLearningProgress(1L, 1L, 50);
        assertFalse(result);
    }

    @Test
    void startLearning_withException_shouldReturnFalse() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void getUserEnrolledCourseCount_withException_shouldReturnZero() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        int result = courseService.getUserEnrolledCourseCount(1L);
        assertEquals(0, result);
    }

    @Test
    void getUserEnrolledCourses_withException_shouldReturnEmptyList() {
        when(enrollmentMapper.selectList(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserEnrolledCourses(1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getCourseWithLearningStatus_withUnknownStatus_shouldReturnUnknown1() {
        testEnrollment.setStatus(99);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);
        assertEquals(99, result.get("learningStatus"));
    }

    @Test
    void incrementViewCount_withNullViewCount_shouldSetToOne() {
        testCourse.setViewCount(null);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(courseMapper.updateById(any(Course.class))).thenReturn(1);
        courseService.incrementViewCount(1L);
        assertEquals(1, testCourse.getViewCount());
    }

    @Test
    void updateVideoProgress_withNullVideoDuration_shouldNotSetCompleted() {
        testVideo.setVideoDuration(null);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertTrue(result);
    }

    @Test
    void getCourseWithLearningStatus_withUnknownStatus_shouldReturnUnknown() {
        testEnrollment.setStatus(99);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);
        assertEquals(99, result.get("learningStatus"));
    }

    @Test
    void getUserFavorites_withEmptyType_shouldReturnAllFavorites() {
        List<UserFavorite> favorites = Collections.singletonList(testFavorite);
        when(favoriteMapper.selectList(any(QueryWrapper.class))).thenReturn(favorites);
        List<Map<String, Object>> result = courseService.getUserFavorites(1L, "");
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    void markVideoCompleted_withUpdateFail_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void markVideoCompleted_withException_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void getUserVideoProgress_withException_shouldReturnNull() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        UserVideoProgress result = courseService.getUserVideoProgress(1L, 1L);
        assertNull(result);
    }

    @Test
    void updateVideoProgress_withUpdateFail_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.updateVideoProgress(1L, 1L, 2000, 200);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withInsertFail_shouldReturnFalse() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullTotalWatchTime_shouldTreatAsZero() {
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        UserVideoProgress progress = new UserVideoProgress();
        progress.setUserId(1L);
        progress.setVideoId(1L);
        progress.setWatchProgress(100);
        progress.setTotalWatchTime(0); // 避免 NPE
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(progress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(1);
        boolean result = courseService.updateVideoProgress(1L, 1L, 200, 100);
        assertTrue(result);
    }

    @Test
    void markVideoCompleted_updateFail_shouldReturnFalse() {
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(testProgress);
        when(userVideoProgressMapper.updateById(any(UserVideoProgress.class))).thenReturn(0);
        boolean result = courseService.markVideoCompleted(1L, 1L);
        assertFalse(result);
    }

    @Test
    void deleteCourseVideo_deleteFail_shouldReturnFalse() {
        when(courseVideoMapper.deleteById(1L)).thenReturn(0);
        boolean result = courseService.deleteCourseVideo(1L);
        assertFalse(result);
    }

    @Test
    void addCourseVideo_insertFail_shouldReturnFalse() {
        when(courseVideoMapper.insert(any(CourseVideo.class))).thenReturn(0);
        boolean result = courseService.addCourseVideo(testVideo);
        assertFalse(result);
    }

    @Test
    void getCourseWithLearningStatus_withCourseException_shouldThrow() {
        when(courseMapper.selectById(1L)).thenThrow(new RuntimeException("mock"));
        assertThrows(RuntimeException.class, () -> courseService.getCourseWithLearningStatus(1L, 1L));
    }

    @Test
    void getCourseWithLearningStatus_withEnrollmentException_shouldReturnNullEnrollment() {
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);
        assertNull(result.get("enrollment"));
    }

    @Test
    void getCourseWithLearningStatus_withFavoriteException_shouldReturnNotFavorited() {
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenThrow(new RuntimeException("mock"));
        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);
        assertFalse((Boolean) result.get("isFavorited"));
    }

    @Test
    void updateCourseVideo_withNullVideo_shouldReturnFalse() {
        boolean result = courseService.updateCourseVideo(null);
        assertFalse(result);
    }

    @Test
    void getUserFavoriteCount_withNull_shouldReturnZero() {
        when(favoriteMapper.selectCount(any(QueryWrapper.class))).thenReturn(null);
        int result = courseService.getUserFavoriteCount(1L);
        assertEquals(0, result);
    }

    @Test
    void updateLearningProgress_withNullProgress_shouldUpdate() {
        testEnrollment.setProgress(null);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(1);
        boolean result = courseService.updateLearningProgress(1L, 1L, 80);
        assertTrue(result);
    }

    @Test
    void updateLearningProgress_updateFail_shouldReturnFalse() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(0);
        boolean result = courseService.updateLearningProgress(1L, 1L, 80);
        assertFalse(result);
    }

    @Test
    void updateLearningProgress_updateThrows_shouldReturnFalse() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.updateLearningProgress(1L, 1L, 80);
        assertFalse(result);
    }

    @Test
    void startLearning_withNullStatus_shouldReturnFalse() {
        testEnrollment.setStatus(null);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void startLearning_updateFail_shouldReturnFalse() {
        testEnrollment.setStatus(0);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(0);
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void startLearning_updateThrows_shouldReturnFalse() {
        testEnrollment.setStatus(0);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void enrollCourse_userSelectThrows_shouldReturnFalse() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(1L)).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.enrollCourse(1L, 1L);
        assertFalse(result);
    }

    @Test
    void enrollCourse_insertFail_shouldReturnFalse() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.selectById(1L)).thenReturn(testUser);
        when(enrollmentMapper.insert(any(CourseEnrollment.class))).thenReturn(0);
        boolean result = courseService.enrollCourse(1L, 1L);
        assertFalse(result);
    }
    @Test
    void startLearning_withNullEnrollment_shouldReturnFalse() {
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(null);
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void startLearning_withNullStatus_shouldReturnFalse1() {
        testEnrollment.setStatus(null);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void startLearning_updateByIdReturnsZero_shouldReturnFalse() {
        testEnrollment.setStatus(0);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenReturn(0);
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void startLearning_updateByIdThrows_shouldReturnFalse() {
        testEnrollment.setStatus(0);
        when(enrollmentMapper.selectOne(any(QueryWrapper.class))).thenReturn(testEnrollment);
        when(enrollmentMapper.updateById(any(CourseEnrollment.class))).thenThrow(new RuntimeException("mock"));
        boolean result = courseService.startLearning(1L, 1L);
        assertFalse(result);
    }

    @Test
    void getUserCourseVideos_withNullFreeVideos_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(null);
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_progressMapperThrows_shouldReturnEmptyList() {
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(Collections.singletonList(testVideo));
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenThrow(new RuntimeException("mock"));
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
    @Test
    void getUserCourseVideos_withNullUserId_shouldReturnFreeVideos() {
        // 准备测试数据
        testVideo.setIsFree(1);
        List<CourseVideo> videos = Collections.singletonList(testVideo);

        // 模拟行为
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(videos);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, null);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertTrue((Boolean) result.get(0).get("canWatch"));
        assertTrue((Boolean) result.get(0).get("isFree"));
    }

    @Test
    void getUserCourseVideos_withNullCourseId_shouldReturnEmptyList() {
        List<Map<String, Object>> result = courseService.getUserCourseVideos(null, 1L);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_withNullUserIdAndCourseId_shouldReturnEmptyList() {
        List<Map<String, Object>> result = courseService.getUserCourseVideos(null, null);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }



    @Test
    void getUserCourseVideos_withEnrolledUserAndEmptyProgressList_shouldReturnVideosWithZeroProgress() {
        // 准备测试数据
        List<CourseVideo> videos = Collections.singletonList(testVideo);

        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenReturn(Collections.emptyList());

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(0, result.get(0).get("watchProgress"));
        assertEquals(0.0, result.get(0).get("watchPercentage"));
        assertFalse((Boolean) result.get(0).get("isCompleted"));
    }

    @Test
    void getUserCourseVideos_withEnrolledUserAndMismatchedProgress_shouldReturnVideosWithZeroProgress() {
        // 准备测试数据
        List<CourseVideo> videos = Collections.singletonList(testVideo);
        UserVideoProgress progress = new UserVideoProgress();
        progress.setVideoId(2L); // 不匹配的视频ID
        progress.setWatchProgress(100);

        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L)).thenReturn(Collections.singletonList(progress));

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(0, result.get(0).get("watchProgress"));
        assertEquals(0.0, result.get(0).get("watchPercentage"));
        assertFalse((Boolean) result.get(0).get("isCompleted"));
    }

    @Test
    void getUserCourseVideos_withNotEnrolledUserAndNullFreeVideos_shouldReturnEmptyList() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(null);

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void getUserCourseVideos_withNotEnrolledUserAndEmptyFreeVideos_shouldReturnEmptyList() {
        // 模拟行为
        when(enrollmentMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(courseVideoMapper.getFreeVideosByCourseId(1L)).thenReturn(Collections.emptyList());

        // 执行测试
        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        // 验证结果
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }




    @Test
    void updateVideoProgress_withNullWatchProgressAndTotalWatchTime_shouldReturnFalse() {
        boolean result = courseService.updateVideoProgress(1L, 1L, null, null);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withWatchProgressEqualToVideoDuration_shouldMarkAsCompleted() {
        testVideo.setVideoDuration(1000);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);

        boolean result = courseService.updateVideoProgress(1L, 1L, 1000, 1000);

        assertTrue(result);
        verify(userVideoProgressMapper).insert(argThat(progress ->
                progress.getIsCompleted() == 1));
    }

    @Test
    void updateVideoProgress_withWatchProgressExact90Percent_shouldMarkAsCompleted() {
        testVideo.setVideoDuration(1000);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);

        boolean result = courseService.updateVideoProgress(1L, 1L, 900, 900);

        assertTrue(result);
        verify(userVideoProgressMapper).insert(argThat(progress ->
                progress.getIsCompleted() == 1));
    }
    @Test
    void updateVideoProgress_withNullWatchProgress_shouldReturnFalse() {
        boolean result = courseService.updateVideoProgress(1L, 1L, null, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullTotalWatchTime_shouldReturnFalse() {
        boolean result = courseService.updateVideoProgress(1L, 1L, 100, null);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullVideoId_shouldReturnFalse() {
        boolean result = courseService.updateVideoProgress(null, 1L, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withNullUserId_shouldReturnFalse() {
        boolean result = courseService.updateVideoProgress(1L, null, 100, 100);
        assertFalse(result);
    }

    @Test
    void updateVideoProgress_withZeroVideoDuration_shouldNotCalculatePercentage() {
        testVideo.setVideoDuration(0);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);

        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);

        assertTrue(result);
        verify(userVideoProgressMapper).insert(argThat(progress ->
                progress.getWatchPercentage() == null));
    }

    @Test
    void updateVideoProgress_withNullVideoDuration_shouldNotCalculatePercentage() {
        testVideo.setVideoDuration(null);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any(UserVideoProgress.class))).thenReturn(1);

        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);

        assertTrue(result);
        verify(userVideoProgressMapper).insert(argThat(progress ->
                progress.getWatchPercentage() == null));
    }




    @Test
    void updateVideoProgress_withZeroDuration_shouldNotCalculatePercentage() {
        testVideo.setVideoDuration(0);
        when(courseVideoMapper.selectById(1L)).thenReturn(testVideo);
        when(userVideoProgressMapper.getUserVideoProgress(1L, 1L)).thenReturn(null);
        when(userVideoProgressMapper.insert(any())).thenReturn(1);

        boolean result = courseService.updateVideoProgress(1L, 1L, 100, 100);

        assertTrue(result);
        verify(userVideoProgressMapper).insert(argThat(p ->
                p.getWatchPercentage() == null));
    }
    @Test
    void getUserCourseVideos_withProgressMismatch_shouldShowZeroProgress() {
        CourseVideo video2 = new CourseVideo();
        video2.setId(2L);
        List<CourseVideo> videos = Arrays.asList(testVideo, video2);

        when(enrollmentMapper.selectCount(any())).thenReturn(1L);
        when(courseVideoMapper.getVideosByCourseId(1L)).thenReturn(videos);
        when(userVideoProgressMapper.getUserCourseProgress(1L, 1L))
                .thenReturn(Collections.singletonList(testProgress));

        List<Map<String, Object>> result = courseService.getUserCourseVideos(1L, 1L);

        assertEquals(0, result.get(1).get("watchProgress")); // 第二个视频无进度
    }
    @Test
    void getCourseWithLearningStatus_withUnknownEnrollmentStatus() {
        testEnrollment.setStatus(99);
        when(courseMapper.selectById(1L)).thenReturn(testCourse);
        when(enrollmentMapper.selectOne(any())).thenReturn(testEnrollment);

        Map<String, Object> result = courseService.getCourseWithLearningStatus(1L, 1L);

        assertEquals(99, result.get("learningStatus"));
    }
}