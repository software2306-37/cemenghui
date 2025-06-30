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
    /**
     * 获取当前用户信息
     */
    @GetMapping("/current")
    public Result<User> getCurrentUser(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            return Result.success(user);
        } else {
            return Result.error(401, "未登录");
        }
    }

    /**
     * 小程序端获取成员列表 - 只返回基本信息用于首页展示
     */
    @GetMapping("/miniapp/members")
    public Result<java.util.List<User>> getMiniappMemberList(@RequestParam(defaultValue = "0") int limit) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 1); // 只获取活跃用户
        queryWrapper.orderByDesc("create_time");

        // 如果limit大于0，则限制返回数量；否则返回所有数据
        if (limit > 0) {
            queryWrapper.last("LIMIT " + limit);
        }

        java.util.List<User> users = userService.list(queryWrapper);
        // 清除敏感信息
        users.forEach(user -> {
            user.setPassword(null);
            user.setPhone(null);
            user.setEmail(null);
        });

        return Result.success(users);
    }

    /**
     * 分页查询用户列表
     */
    @GetMapping("/page")
    public Result<PageResult<User>> page(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        Page<User> page = new Page<>(current, size);
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();

        if (StringUtils.hasText(keyword)) {
            queryWrapper.and(wrapper -> wrapper
                    .like("username", keyword)
                    .or().like("nickname", keyword)
                    .or().like("phone", keyword)
                    .or().like("email", keyword)
                    .or().like("company_name", keyword)
            );
        }

        if (StringUtils.hasText(role)) {
            queryWrapper.eq("role", role);
        }

        if (status != null) {
            queryWrapper.eq("status", status);
        }

        if (StringUtils.hasText(startDate)) {
            queryWrapper.ge("create_time", startDate + " 00:00:00");
        }

        if (StringUtils.hasText(endDate)) {
            queryWrapper.le("create_time", endDate + " 23:59:59");
        }

        queryWrapper.orderByDesc("create_time");

        IPage<User> userPage = userService.page(page, queryWrapper);

        PageResult<User> pageResult = new PageResult<>();
        pageResult.setRecords(userPage.getRecords());
        pageResult.setTotal(userPage.getTotal());
        pageResult.setCurrent(userPage.getCurrent());
        pageResult.setSize(userPage.getSize());

        return Result.success(pageResult);
    }

    /**
     * 创建用户
     */
    @PostMapping
    public Result<String> createUser(@RequestBody User user) {
        if (userService.register(user)) {
            return Result.success("创建成功");
        } else {
            return Result.error("用户名已存在");
        }
    }

    /**
     * 更新用户
     */
    @PutMapping("/{id}")
    public Result<String> updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        user.setPassword(null); // 不允许通过此接口修改密码
        if (userService.updateById(user)) {
            return Result.success("更新成功");
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        if (userService.removeById(id)) {
            return Result.success("删除成功");
        } else {
            return Result.error("删除失败");
        }
    }

    /**
     * 获取当前登录用户（支持小程序）
     */
    private User getCurrentUserFromSession(HttpServletRequest request, HttpSession session) {
        // 首先尝试从session获取
        User user = (User) session.getAttribute("user");
        if (user != null) {
            // 重新从数据库获取用户信息，确保状态是最新的
            User dbUser = userService.getById(user.getId());
            if (dbUser != null && dbUser.getStatus() == 1) {
                // 清除密码字段
                dbUser.setPassword(null);
                // 更新session中的用户信息
                session.setAttribute("user", dbUser);
                return dbUser;
            } else {
                // 用户已被禁用，清除session
                session.removeAttribute("user");
                return null;
            }
        }

        // 如果session中没有用户信息，但前端发送了用户ID，进行验证
        String userIdHeader = request.getHeader("X-User-Id");
        if (userIdHeader != null && !userIdHeader.trim().isEmpty()) {
            try {
                Long userId = Long.parseLong(userIdHeader.trim());
                User dbUser = userService.getById(userId);
                if (dbUser != null && dbUser.getStatus() == 1) {
                    // 清除密码字段
                    dbUser.setPassword(null);
                    // 将用户信息放入session
                    session.setAttribute("user", dbUser);
                    return dbUser;
                }
            } catch (NumberFormatException e) {
                System.out.println("无效的用户ID格式: " + userIdHeader);
            }
        }

        return null;
    }

    /**
     * 更新个人资料
     */
    @PostMapping("/profile")
    public Result<User> updateProfile(@RequestBody User user, HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        // 只允许更新部分字段
        User updateUser = userService.getById(currentUser.getId());
        if (updateUser == null) {
            return Result.error("用户不存在");
        }

        // 更新允许修改的字段
        if (user.getNickname() != null) {
            updateUser.setNickname(user.getNickname());
        }
        if (user.getEmail() != null) {
            updateUser.setEmail(user.getEmail());
        }
        if (user.getPhone() != null) {
            updateUser.setPhone(user.getPhone());
        }
        if (user.getGender() != null) {
            updateUser.setGender(user.getGender());
        }
        if (user.getCompanyName() != null) {
            updateUser.setCompanyName(user.getCompanyName());
        }
        if (user.getAvatar() != null) {
            updateUser.setAvatar(user.getAvatar());
        }

        boolean success = userService.updateById(updateUser);
        if (success) {
            // 更新session中的用户信息
            session.setAttribute("user", updateUser);
            return Result.success("个人资料更新成功", updateUser);
        } else {
            return Result.error("更新失败");
        }
    }

    /**
     * 修改密码
     */
    @PostMapping("/change-password")
    public Result<String> changePassword(@RequestBody Map<String, String> passwordData, HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        String oldPassword = passwordData.get("oldPassword");
        String newPassword = passwordData.get("newPassword");

        if (oldPassword == null || newPassword == null) {
            return Result.error("请提供当前密码和新密码");
        }

        if (newPassword.length() < 6 || newPassword.length() > 20) {
            return Result.error("新密码长度必须在6-20位之间");
        }

        // 使用UserService的方法来修改密码，确保密码验证和加密
        boolean success = userService.changePassword(currentUser.getId(), oldPassword, newPassword);

        if (success) {
            // 获取更新后的用户信息并更新session
            User updatedUser = userService.getById(currentUser.getId());
            if (updatedUser != null) {
                // 清除密码字段后再存入session
                updatedUser.setPassword(null);
                session.setAttribute("user", updatedUser);
            }
            return Result.success("密码修改成功");
        } else {
            return Result.error("当前密码错误或密码修改失败");
        }
    }

    @DeleteMapping("/batch")
    public Result batchDelete(@RequestBody List<Long> ids) {
        try {
            userService.removeByIds(ids);
            return Result.success("批量删除成功");
        } catch (Exception e) {
            return Result.error("批量删除失败：" + e.getMessage());
        }
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> export(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) Integer status) {

        try {
            QueryWrapper<User> queryWrapper = new QueryWrapper<>();

            if (StringUtils.hasText(keyword)) {
                queryWrapper.and(wrapper -> wrapper
                        .like("username", keyword)
                        .or().like("nickname", keyword)
                        .or().like("phone", keyword)
                        .or().like("email", keyword)
                        .or().like("company_name", keyword)
                );
            }

            if (StringUtils.hasText(role)) {
                queryWrapper.eq("role", role);
            }

            if (status != null) {
                queryWrapper.eq("status", status);
            }

            List<User> users = userService.list(queryWrapper);

            // 简化的CSV导出
            StringBuilder csv = new StringBuilder();
            // 添加UTF-8 BOM头
            csv.append("\uFEFF");
            csv.append("Username,Nickname,Phone,Email,Company,Role,Status,CreateTime\n");

            for (User user : users) {
                csv.append(user.getUsername() != null ? user.getUsername() : "").append(",")
                        .append(user.getNickname() != null ? user.getNickname() : "").append(",")
                        .append(user.getPhone() != null ? user.getPhone() : "").append(",")
                        .append(user.getEmail() != null ? user.getEmail() : "").append(",")
                        .append(user.getCompanyName() != null ? user.getCompanyName() : "").append(",")
                        .append("ADMIN".equals(user.getRole()) ? "Admin" : "User").append(",")
                        .append(user.getStatus() == 1 ? "Active" : "Inactive").append(",")
                        .append(user.getCreateTime() != null ? user.getCreateTime() : "").append("\n");
            }

            byte[] data = csv.toString().getBytes("UTF-8");

            // 添加UTF-8 BOM头
            byte[] bom = new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF};
            byte[] result = new byte[bom.length + data.length];
            System.arraycopy(bom, 0, result, 0, bom.length);
            System.arraycopy(data, 0, result, bom.length, data.length);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            String fileName = "users_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
            headers.setContentDispositionFormData("attachment", fileName);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(result);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 获取用户统计信息
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getUserStats(HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        Map<String, Object> stats = new HashMap<>();

        try {
            // 查询用户实际的报名数据
            // 1. 用户报名的会议数量（实际数据）
            int userMeetingCount = 0;
            try {
                userMeetingCount = meetingService.getUserRegisteredMeetingCount(currentUser.getId());
            } catch (Exception e) {
                System.err.println("查询用户会议数量失败: " + e.getMessage());
                userMeetingCount = 0;
            }

            // 2. 用户课程数量
            int userCourseCount = 0;
            try {
                userCourseCount = courseService.getUserEnrolledCourseCount(currentUser.getId());
            } catch (Exception e) {
                System.err.println("查询用户课程数量失败: " + e.getMessage());
                userCourseCount = 0;
            }

            // 3. 用户收藏数量
            int userFavoriteCount = 0;
            try {
                userFavoriteCount = courseService.getUserFavoriteCount(currentUser.getId());
            } catch (Exception e) {
                System.err.println("查询用户收藏数量失败: " + e.getMessage());
                userFavoriteCount = 0;
            }

            stats.put("courseCount", userCourseCount);
            stats.put("meetingCount", userMeetingCount);
            stats.put("favoriteCount", userFavoriteCount);

            // 计算学习时长（基于课程和会议数量的合理估算）
            int studyHours = userCourseCount * 2 + userMeetingCount * 1; // 每个课程2小时，每个会议1小时
            stats.put("studyHours", studyHours);

            System.out.println("用户统计数据 - 用户ID: " + currentUser.getId() + ", 统计: " + stats);

        } catch (Exception e) {
            System.err.println("获取用户统计失败: " + e.getMessage());
            e.printStackTrace();
            // 查询失败时返回默认值
            stats.put("courseCount", 0);
            stats.put("meetingCount", 0);
            stats.put("favoriteCount", 0);
            stats.put("studyHours", 0);
        }

        return Result.success(stats);
    }

    /**
     * 重置密码
     */
    /**
     * 验证用户身份（找回密码第一步）
     */
    @PostMapping("/verify-identity")
    public Result<String> verifyIdentity(@RequestBody Map<String, String> verifyForm) {
        String username = verifyForm.get("username");
        String email = verifyForm.get("email");

        // 查找用户
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username).eq("email", email);
        User user = userService.getOne(queryWrapper);

        if (user == null) {
            return Result.error("用户名和邮箱不匹配，请检查输入信息");
        }

        // 检查用户状态
        if (user.getStatus() != 1) {
            return Result.error("账户已被禁用，无法重置密码，请联系管理员");
        }

        return Result.success("身份验证成功");
    }

    /**
     * 重置密码（找回密码第二步）
     */
    @PostMapping("/reset-password")
    public Result<String> resetPassword(@RequestBody Map<String, String> resetForm) {
        String username = resetForm.get("username");
        String email = resetForm.get("email");
        String newPassword = resetForm.get("newPassword");

        // 查找用户
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username).eq("email", email);
        User user = userService.getOne(queryWrapper);

        if (user == null) {
            return Result.error("用户信息验证失败");
        }

        // 检查用户状态
        if (user.getStatus() != 1) {
            return Result.error("账户已被禁用，无法重置密码，请联系管理员");
        }

        // 使用UserService的方法来重置密码，确保密码加密
        if (userService.resetUserPassword(user.getId(), newPassword)) {
            return Result.success("密码重置成功");
        } else {
            return Result.error("密码重置失败，请重试");
        }
    }

    /**
     * 获取用户的课程列表
     */
    @GetMapping("/my-courses")
    public Result<List<Map<String, Object>>> getMyCourses(HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        try {
            // 获取用户报名的课程列表
            List<Map<String, Object>> result = courseService.getUserEnrolledCourses(currentUser.getId());

            System.out.println("用户 " + currentUser.getId() + " 查询我的课程列表，数量: " + result.size());

            return Result.success(result);
        } catch (Exception e) {
            System.err.println("获取用户课程列表失败: " + e.getMessage());
            e.printStackTrace();
            return Result.error("获取课程列表失败：" + e.getMessage());
        }
    }

    /**
     * 获取用户的会议列表
     */
    @GetMapping("/my-meetings")
    public Result<List<Map<String, Object>>> getMyMeetings(HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        try {
            // 查询用户实际报名的会议
            List<Map<String, Object>> result = meetingService.getUserRegisteredMeetings(currentUser.getId());

            System.out.println("用户 " + currentUser.getId() + " 查询我的会议列表，数量: " + result.size());

            return Result.success(result);
        } catch (Exception e) {
            System.err.println("获取用户会议列表失败: " + e.getMessage());
            e.printStackTrace();
            return Result.error("获取会议列表失败：" + e.getMessage());
        }
    }

    /**
     * 获取用户的收藏列表
     */
    @GetMapping("/my-favorites")
    public Result<List<Map<String, Object>>> getMyFavorites(
            @RequestParam(required = false) String type,
            HttpSession session, HttpServletRequest request) {
        User currentUser = getCurrentUserFromSession(request, session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        try {
            // 获取用户收藏列表
            List<Map<String, Object>> result = courseService.getUserFavorites(currentUser.getId(), type);

            System.out.println("用户 " + currentUser.getId() + " 查询我的收藏列表，类型: " + type + ", 数量: " + result.size());

            return Result.success(result);
        } catch (Exception e) {
            System.err.println("获取用户收藏列表失败: " + e.getMessage());
            e.printStackTrace();
            return Result.error("获取收藏列表失败：" + e.getMessage());
        }
    }

    /**
     * 提交反馈
     */
    @PostMapping("/feedback/submit")
    public Result<String> submitFeedback(@RequestBody Map<String, Object> feedbackData, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        try {
            // 获取反馈数据
            String type = (String) feedbackData.get("type");
            String content = (String) feedbackData.get("content");
            String contact = (String) feedbackData.get("contact");

            // 记录反馈信息（这里可以保存到数据库）
            System.out.println("收到用户反馈 - 用户ID: " + currentUser.getId() +
                    ", 类型: " + type +
                    ", 内容: " + content +
                    ", 联系方式: " + contact);

            return Result.success("反馈提交成功");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("反馈提交失败");
        }
    }
}
