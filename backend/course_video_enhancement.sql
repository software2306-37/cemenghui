-- 课程视频表 - 支持多个视频的课程学习功能
-- 创建时间: 2025-01-07

-- 创建课程视频表
DROP TABLE IF EXISTS `course_video`;
CREATE TABLE `course_video` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '视频ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `video_title` varchar(200) NOT NULL COMMENT '视频标题',
  `video_url` varchar(500) NOT NULL COMMENT '视频URL',
  `video_duration` int DEFAULT 0 COMMENT '视频时长(秒)',
  `video_size` bigint DEFAULT 0 COMMENT '视频大小(字节)',
  `video_description` text COMMENT '视频描述',
  `sort_order` int DEFAULT 0 COMMENT '排序号',
  `is_free` tinyint DEFAULT 0 COMMENT '是否免费 0-收费 1-免费',
  `status` tinyint DEFAULT 1 COMMENT '状态 0-禁用 1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_course_video_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='课程视频表';

-- 创建用户视频学习记录表
DROP TABLE IF EXISTS `user_video_progress`;
CREATE TABLE `user_video_progress` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `video_id` bigint NOT NULL COMMENT '视频ID',
  `watch_progress` int DEFAULT 0 COMMENT '观看进度(秒)',
  `watch_percentage` decimal(5,2) DEFAULT 0.00 COMMENT '观看百分比',
  `is_completed` tinyint DEFAULT 0 COMMENT '是否完成 0-未完成 1-已完成',
  `last_watch_time` datetime DEFAULT NULL COMMENT '最后观看时间',
  `total_watch_time` int DEFAULT 0 COMMENT '总观看时长(秒)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_video` (`user_id`, `video_id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_user_course` (`user_id`, `course_id`),
  CONSTRAINT `fk_user_video_progress_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_video_progress_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_video_progress_video` FOREIGN KEY (`video_id`) REFERENCES `course_video` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户视频学习进度表';

-- 插入示例数据
INSERT INTO `course_video` (`course_id`, `video_title`, `video_url`, `video_duration`, `video_description`, `sort_order`, `is_free`) VALUES
(1, '第1章：软件测试基础概念', '/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4', 1800, '介绍软件测试的基本概念、目的和重要性', 1, 1),
(1, '第2章：测试方法与分类', '/uploads/video1_2.mp4', 2100, '详细讲解黑盒测试、白盒测试、灰盒测试等测试方法', 2, 0),
(1, '第3章：测试用例设计', '/uploads/video1_3.mp4', 2400, '学习如何设计有效的测试用例', 3, 0),
(1, '第4章：缺陷管理', '/uploads/video1_4.mp4', 1950, '缺陷的发现、记录、跟踪和管理流程', 4, 0),

(2, '第1章：Selenium环境搭建', '/uploads/video2_1.mp4', 1200, 'Selenium WebDriver环境配置和基本使用', 1, 1),
(2, '第2章：元素定位策略', '/uploads/video2_2.mp4', 1800, '掌握各种元素定位方法和最佳实践', 2, 0),
(2, '第3章：页面对象模式', '/uploads/video2_3.mp4', 2200, '学习POM设计模式提高代码可维护性', 3, 0),
(2, '第4章：数据驱动测试', '/uploads/video2_4.mp4', 2000, '实现数据驱动的自动化测试框架', 4, 0),
(2, '第5章：测试报告生成', '/uploads/video2_5.mp4', 1500, '生成详细的测试报告和结果分析', 5, 0),

(3, '第1章：性能测试理论基础', '/uploads/video3_1.mp4', 1600, '性能测试的基本概念和理论知识', 1, 1),
(3, '第2章：JMeter工具使用', '/uploads/video3_2.mp4', 2500, 'JMeter工具的详细使用教程', 2, 0),
(3, '第3章：性能测试脚本编写', '/uploads/video3_3.mp4', 2800, '编写复杂的性能测试脚本', 3, 0),
(3, '第4章：性能监控与分析', '/uploads/video3_4.mp4', 2200, '性能监控指标分析和瓶颈定位', 4, 0),

(4, '第1章：移动测试概述', '/uploads/video4_1.mp4', 1400, '移动应用测试的特点和挑战', 1, 1),
(4, '第2章：Android测试工具', '/uploads/video4_2.mp4', 2000, 'Android应用测试工具和方法', 2, 0),
(4, '第3章：iOS测试实践', '/uploads/video4_3.mp4', 1900, 'iOS应用测试的实践经验', 3, 0),
(4, '第4章：兼容性测试', '/uploads/video4_4.mp4', 2300, '移动设备兼容性测试策略', 4, 0),

(5, '第1章：API测试基础', '/uploads/video5_1.mp4', 1300, 'API接口测试的基本知识', 1, 1),
(5, '第2章：Postman实战', '/uploads/video5_2.mp4', 1700, 'Postman工具的高级使用技巧', 2, 0),
(5, '第3章：自动化接口测试', '/uploads/video5_3.mp4', 2100, '使用Python进行API自动化测试', 3, 0),
(5, '第4章：接口测试框架', '/uploads/video5_4.mp4', 2400, '构建完整的接口测试框架', 4, 0); 