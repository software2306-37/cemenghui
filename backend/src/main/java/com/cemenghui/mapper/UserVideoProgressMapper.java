package com.cemenghui.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.cemenghui.entity.UserVideoProgress;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserVideoProgressMapper extends BaseMapper<UserVideoProgress> {
} 