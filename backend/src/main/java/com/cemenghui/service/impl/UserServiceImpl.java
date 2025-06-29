package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.cemenghui.entity.User;
import com.cemenghui.mapper.UserMapper;
import com.cemenghui.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public User login(String username, String password) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        User user = this.getOne(queryWrapper);
        
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            // 检查用户状态，只有启用状态的用户才能登录
            if (user.getStatus() != 1) {
                return null; // 用户已被禁用
            }
            // 清除密码字段
            user.setPassword(null);
            return user;
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        // 检查用户名是否已存在
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", user.getUsername());
        if (this.count(queryWrapper) > 0) {
            return false;
        }
        
        // 加密密码
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return this.save(user);
    }

    @Override
    public Page<User> pageUsers(int current, int size, String keyword) {
        Page<User> page = new Page<>(current, size);
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        
        if (StringUtils.isNotBlank(keyword)) {
            queryWrapper.like("username", keyword)
                    .or().like("nickname", keyword)
                    .or().like("phone", keyword)
                    .or().like("company_name", keyword);
        }
        
        queryWrapper.orderByDesc("create_time");
        Page<User> result = this.page(page, queryWrapper);
        
        // 清除密码字段
        result.getRecords().forEach(user -> user.setPassword(null));
        return result;
    }

    @Override
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = this.getById(userId);
        if (user == null) {
            return false;
        }
        
        // 验证旧密码
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return false;
        }
        
        // 检查新密码是否与当前密码相同
        if (passwordEncoder.matches(newPassword, user.getPassword())) {
            return false;
        }
        
        // 更新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        return this.updateById(user);
    }
    
    @Override
    public boolean resetUserPassword(Long userId, String newPassword) {
        User user = this.getById(userId);
        if (user == null) {
            return false;
        }
        
        // 加密新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        return this.updateById(user);
    }
} 