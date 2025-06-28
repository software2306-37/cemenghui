package com.cemenghui.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.cemenghui.entity.UserVideoProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserVideoProgressMapper extends BaseMapper<UserVideoProgress> {

    /**
     * 获取用户在某个课程的视频学习进度
     */
    @Select("SELECT * FROM user_video_progress WHERE user_id = #{userId} AND course_id = #{courseId}")
    List<UserVideoProgress> getUserCourseProgress(@Param("userId") Long userId, @Param("courseId") Long courseId);

    /**
     * 获取用户某个视频的学习进度
     */
    @Select("SELECT * FROM user_video_progress WHERE user_id = #{userId} AND video_id = #{videoId}")
    UserVideoProgress getUserVideoProgress(@Param("userId") Long userId, @Param("videoId") Long videoId);

    /**
     * 获取用户在某个课程已完成的视频数量
     */
    @Select("SELECT COUNT(*) FROM user_video_progress WHERE user_id = #{userId} AND course_id = #{courseId} AND is_completed = 1")
    int getCompletedVideoCount(@Param("userId") Long userId, @Param("courseId") Long courseId);

    /**
     * 获取用户在某个课程的总学习时长
     */
    @Select("SELECT COALESCE(SUM(total_watch_time), 0) FROM user_video_progress WHERE user_id = #{userId} AND course_id = #{courseId}")
    int getTotalWatchTime(@Param("userId") Long userId, @Param("courseId") Long courseId);
} 