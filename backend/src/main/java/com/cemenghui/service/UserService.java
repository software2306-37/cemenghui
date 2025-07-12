package com.cemenghui.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.cemenghui.entity.User;

public interface UserService extends IService<User> {
    
    /**
     * 用户登录
     */
    User login(String username, String password);
    
    /**
     * 用户注册
     */
    boolean register(User user);
    
    /**
     * 分页查询用户
     */
    Page<User> pageUsers(int current, int size, String keyword);
    
    /**
     * 修改密码
     */
    boolean changePassword(Long userId, String oldPassword, String newPassword);
    
    /**
     * 重置用户密码（忘记密码功能）
     */
    boolean resetUserPassword(Long userId, String newPassword);
} 