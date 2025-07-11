package com.cemenghui.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.entity.User;
import com.cemenghui.mapper.UserMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import static org.mockito.ArgumentMatchers.*;

import org.mockito.MockitoAnnotations;

public class UserServiceImplTest {

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserServiceImpl userService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    // TC001: 登录成功
    @Test
    void testLoginSuccess() {
        String rawPassword = "123456";
        String encodedPassword = passwordEncoder.encode(rawPassword);
        User mockUser = new User();
        mockUser.setUsername("test");
        mockUser.setPassword(encodedPassword);
        mockUser.setStatus(1);

        when(userMapper.selectOne(any(QueryWrapper.class))).thenReturn(mockUser);

        User result = userService.login("test", rawPassword);
        assertNotNull(result);
        assertNull(result.getPassword());
    }

    // TC002: 登录失败-密码错误
    @Test
    void testLoginFail_WrongPassword() {
        User mockUser = new User();
        mockUser.setUsername("test");
        mockUser.setPassword(passwordEncoder.encode("correct"));
        mockUser.setStatus(1);

        when(userMapper.selectOne(any(QueryWrapper.class))).thenReturn(mockUser);

        User result = userService.login("test", "wrong");
        assertNull(result);
    }

    // TC003: 登录失败-用户被禁用
    @Test
    void testLoginFail_DisabledUser() {
        User mockUser = new User();
        mockUser.setUsername("test");
        mockUser.setPassword(passwordEncoder.encode("123456"));
        mockUser.setStatus(0); // 被禁用

        when(userMapper.selectOne(any(QueryWrapper.class))).thenReturn(mockUser);

        User result = userService.login("test", "123456");
        assertNull(result);
    }

    // TC004: 注册成功
    @Test
    void testRegisterSuccess() {
        User newUser = new User();
        newUser.setUsername("newUser");
        newUser.setPassword("123456");

        when(userMapper.selectCount(any(QueryWrapper.class))).thenReturn(0L);
        when(userMapper.insert(any(User.class))).thenReturn(1);

        boolean result = userService.register(newUser);
        assertTrue(result);
    }

    // TC005: 注册失败-用户名已存在
    @Test
    void testRegisterFail_UsernameExists() {
        User newUser = new User();
        newUser.setUsername("existingUser");

        when(userMapper.selectCount(any(QueryWrapper.class))).thenReturn(1L);

        boolean result = userService.register(newUser);
        assertFalse(result);
    }

    // TC006: 修改密码成功
    @Test
    void testChangePasswordSuccess() {
        User user = new User();
        user.setId(1L);
        user.setPassword(passwordEncoder.encode("oldPwd"));

        when(userMapper.selectById(1L)).thenReturn(user);
        when(userMapper.updateById(any(User.class))).thenReturn(1);

        boolean result = userService.changePassword(1L, "oldPwd", "newPwd");
        assertTrue(result);
    }

    // TC007: 修改密码失败-旧密码不正确
    @Test
    void testChangePasswordFail_WrongOldPassword() {
        User user = new User();
        user.setId(1L);
        user.setPassword(passwordEncoder.encode("correctOldPwd"));

        when(userMapper.selectById(1L)).thenReturn(user);

        boolean result = userService.changePassword(1L, "wrongOldPwd", "newPwd");
        assertFalse(result);
    }

    // TC008: 修改密码失败-新旧密码相同
    @Test
    void testChangePasswordFail_SameNewPassword() {
        String encodedPwd = passwordEncoder.encode("123456");
        User user = new User();
        user.setId(1L);
        user.setPassword(encodedPwd);

        when(userMapper.selectById(1L)).thenReturn(user);

        boolean result = userService.changePassword(1L, "123456", "123456");
        assertFalse(result);
    }

    // TC009: 修改密码失败-用户不存在
    @Test
    void testChangePasswordFail_UserNotFound() {
        when(userMapper.selectById(999L)).thenReturn(null);

        boolean result = userService.changePassword(999L, "123", "456");
        assertFalse(result);
    }

    // TC010: 重置密码成功
    @Test
    void testResetPasswordSuccess() {
        User user = new User();
        user.setId(1L);

        when(userMapper.selectById(1L)).thenReturn(user);
        when(userMapper.updateById(any(User.class))).thenReturn(1);

        boolean result = userService.resetUserPassword(1L, "newPwd");
        assertTrue(result);
    }

    // TC011: 重置密码失败-用户不存在
    @Test
    void testResetPasswordFail_UserNotFound() {
        when(userMapper.selectById(999L)).thenReturn(null);

        boolean result = userService.resetUserPassword(999L, "newPwd");
        assertFalse(result);
    }

    // TC012: 分页查询（带关键字）
    @Test
    void testPageUsersWithKeyword() {
        Page<User> mockPage = new Page<>();
        User u = new User();
        u.setPassword("testpwd"); // 模拟原始密码
        mockPage.setRecords(Collections.singletonList(u));

        when(userMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(mockPage);

        Page<User> result = userService.pageUsers(1, 10, "key");
        assertNotNull(result);
        assertEquals(1, result.getRecords().size());
        assertNull(result.getRecords().get(0).getPassword()); // 密码应被清空
    }

    // TC013: 分页查询（无关键字）
    @Test
    void testPageUsersWithoutKeyword() {
        Page<User> mockPage = new Page<>();
        User u = new User();
        u.setPassword("testpwd");
        mockPage.setRecords(Collections.singletonList(u));

        when(userMapper.selectPage(any(Page.class), any(QueryWrapper.class))).thenReturn(mockPage);

        Page<User> result = userService.pageUsers(1, 10, null);
        assertEquals(1, result.getRecords().size());
        assertNull(result.getRecords().get(0).getPassword());
    }
}
