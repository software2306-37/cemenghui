package com.cemenghui.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.cemenghui.entity.CourseVideo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CourseVideoMapper extends BaseMapper<CourseVideo> {

    /**
     * 根据课程ID获取视频列表
     */
    @Select("SELECT * FROM course_video WHERE course_id = #{courseId} AND status = 1 ORDER BY sort_order ASC")
    List<CourseVideo> getVideosByCourseId(@Param("courseId") Long courseId);

    /**
     * 根据课程ID获取免费视频列表
     */
    @Select("SELECT * FROM course_video WHERE course_id = #{courseId} AND status = 1 AND is_free = 1 ORDER BY sort_order ASC")
    List<CourseVideo> getFreeVideosByCourseId(@Param("courseId") Long courseId);

    /**
     * 获取课程的视频总数
     */
    @Select("SELECT COUNT(*) FROM course_video WHERE course_id = #{courseId} AND status = 1")
    int getVideoCountByCourseId(@Param("courseId") Long courseId);

    /**
     * 获取课程的总时长
     */
    @Select("SELECT COALESCE(SUM(video_duration), 0) FROM course_video WHERE course_id = #{courseId} AND status = 1")
    int getTotalDurationByCourseId(@Param("courseId") Long courseId);
} 