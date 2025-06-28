package com.cemenghui.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.cemenghui.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
} 