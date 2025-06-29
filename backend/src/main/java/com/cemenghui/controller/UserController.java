package com.cemenghui.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cemenghui.common.PageResult;
import com.cemenghui.common.Result;
import com.cemenghui.entity.User;
import com.cemenghui.service.UserService;
import com.cemenghui.service.CourseService;
import com.cemenghui.service.MeetingService;
import com.cemenghui.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private MeetingService meetingService;

    @Autowired
    private NewsService newsService;

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<User> login(@RequestBody Map<String, String> loginForm, HttpSession session, HttpServletResponse response) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");

        // 先查找用户是否存在
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        User user = userService.getOne(queryWrapper);

        if (user == null) {
            return Result.error("用户名不存在");
        }

        // 检查用户状态
        if (user.getStatus() != 1) {
            return Result.error("账户已被禁用，请联系管理员");
        }

        // 验证密码
        User loginUser = userService.login(username, password);
        if (loginUser != null) {
            session.setAttribute("user", loginUser);
            // 为小程序添加sessionId到响应头
            response.setHeader("X-Session-Id", session.getId());
            return Result.success("登录成功", loginUser);
        } else {
            return Result.error("密码错误");
        }
    }

    /**
     * 微信登录
     */
    @PostMapping("/wechat-login")
    public Result<User> wechatLogin(@RequestBody Map<String, String> wechatData, HttpSession session, HttpServletResponse response) {
        String code = wechatData.get("code");
        String rawData = wechatData.get("rawData");
        String signature = wechatData.get("signature");
        String encryptedData = wechatData.get("encryptedData");
        String iv = wechatData.get("iv");

        try {
            // 这里应该调用微信API获取用户信息，但为了简化，我们直接解析rawData
            // 实际项目中需要通过code获取session_key，然后解密encryptedData

            // 简化处理：解析rawData获取用户基本信息
            Map<String, Object> userInfo = parseWechatUserInfo(rawData);

            if (userInfo == null) {
                return Result.error("微信用户信息获取失败");
            }

            String openId = "wx_" + System.currentTimeMillis(); // 简化处理，实际应该从微信API获取
            String nickName = (String) userInfo.get("nickName");
            String avatarUrl = (String) userInfo.get("avatarUrl");

            // 查找是否已存在该微信用户
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("username", openId);
            User existingUser = userService.getOne(queryWrapper);

            User user;
            if (existingUser != null) {
                // 已存在，更新用户信息
                existingUser.setNickname(nickName);
                existingUser.setAvatar(avatarUrl);
                existingUser.setUpdateTime(LocalDateTime.now());
                userService.updateById(existingUser);
                user = existingUser;
            } else {
                // 不存在，创建新用户
                user = new User();
                user.setUsername(openId);
                user.setNickname(nickName);
                user.setAvatar(avatarUrl);
                user.setRole("USER");
                user.setStatus(1);
                user.setCreateTime(LocalDateTime.now());
                user.setUpdateTime(LocalDateTime.now());
                // 微信用户不需要密码
                user.setPassword("wechat_user");

                if (!userService.save(user)) {
                    return Result.error("创建微信用户失败");
                }
            }

            // 登录成功，设置session
            session.setAttribute("user", user);
            response.setHeader("X-Session-Id", session.getId());

            return Result.success("微信登录成功", user);

        } catch (Exception e) {
            System.err.println("微信登录失败: " + e.getMessage());
            e.printStackTrace();
            return Result.error("微信登录失败");
        }
    }

    /**
     * 解析微信用户信息（简化处理）
     */
    private Map<String, Object> parseWechatUserInfo(String rawData) {
        try {
            // 这里应该使用JSON解析库，为了简化直接返回模拟数据
            Map<String, Object> userInfo = new HashMap<>();

            // 简单解析rawData中的nickName和avatarUrl
            if (rawData.contains("nickName")) {
                String nickName = extractJsonValue(rawData, "nickName");
                userInfo.put("nickName", nickName != null ? nickName : "微信用户");
            } else {
                userInfo.put("nickName", "微信用户");
            }

            if (rawData.contains("avatarUrl")) {
                String avatarUrl = extractJsonValue(rawData, "avatarUrl");
                userInfo.put("avatarUrl", avatarUrl);
            }

            return userInfo;
        } catch (Exception e) {
            System.err.println("解析微信用户信息失败: " + e.getMessage());
            return null;
        }
    }

    /**
     * 从JSON字符串中提取指定字段的值（简化处理）
     */
    private String extractJsonValue(String json, String key) {
        try {
            String searchKey = "\"" + key + "\":\"";
            int startIndex = json.indexOf(searchKey);
            if (startIndex != -1) {
                startIndex += searchKey.length();
                int endIndex = json.indexOf("\"", startIndex);
                if (endIndex != -1) {
                    return json.substring(startIndex, endIndex);
                }
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<String> register(@RequestBody User user) {
        user.setRole("USER");
        user.setStatus(1);

        if (userService.register(user)) {
            return Result.success("注册成功");
        } else {
            return Result.error("用户名已存在");
        }
    }

    /**
     * 用户登出
     */
    @PostMapping("/logout")
    public Result<String> logout(HttpSession session) {
        session.removeAttribute("user");
        return Result.success("登出成功");
    }
}
