-- 会议报名记录表
CREATE TABLE `meeting_registration` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meeting_id` bigint NOT NULL COMMENT '会议ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
  `user_phone` varchar(20) DEFAULT NULL COMMENT '用户电话',
  `user_email` varchar(100) DEFAULT NULL COMMENT '用户邮箱',
  `company_name` varchar(200) DEFAULT NULL COMMENT '公司名称',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态：0-已报名，1-已签到，2-已完成，3-已取消',
  `registration_time` datetime DEFAULT NULL COMMENT '报名时间',
  `checkin_time` datetime DEFAULT NULL COMMENT '签到时间',
  `remarks` text COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_meeting_id` (`meeting_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  UNIQUE KEY `uk_meeting_user` (`meeting_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会议报名记录表';

-- 参会回执表
CREATE TABLE `meeting_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `meeting_id` bigint NOT NULL COMMENT '会议ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
  `rating` int NOT NULL COMMENT '总体评分(1-5分)',
  `content` text COMMENT '参会感受',
  `suggestions` text COMMENT '改进建议',
  `organization_rating` int DEFAULT NULL COMMENT '组织评分(1-5分)',
  `content_rating` int DEFAULT NULL COMMENT '内容评分(1-5分)',
  `venue_rating` int DEFAULT NULL COMMENT '场地评分(1-5分)',
  `attachments` text COMMENT '附件路径，多个用逗号分隔',
  `submit_time` datetime DEFAULT NULL COMMENT '提交时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_meeting_id` (`meeting_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating` (`rating`),
  UNIQUE KEY `uk_meeting_user_feedback` (`meeting_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参会回执表';

-- 插入测试数据（可选）
-- 注意：实际使用时，meeting_id和user_id需要替换为真实存在的ID

-- 示例：为会议ID为1的会议添加几个报名记录
-- INSERT INTO `meeting_registration` (`meeting_id`, `user_id`, `user_name`, `user_phone`, `user_email`, `company_name`, `status`, `registration_time`) VALUES
-- (1, 1, '张三', '13800138000', 'zhangsan@example.com', '测试公司A', 0, '2024-01-15 10:30:00'),
-- (1, 2, '李四', '13800138001', 'lisi@example.com', '测试公司B', 1, '2024-01-15 11:00:00'),
-- (1, 3, '王五', '13800138002', 'wangwu@example.com', '测试公司C', 0, '2024-01-15 11:30:00');

-- 示例：为已完成的会议添加回执记录
-- INSERT INTO `meeting_feedback` (`meeting_id`, `user_id`, `user_name`, `rating`, `content`, `suggestions`, `organization_rating`, `content_rating`, `venue_rating`, `submit_time`) VALUES
-- (1, 1, '张三', 5, '会议内容非常丰富，收获很大', '希望能增加更多互动环节', 5, 5, 4, '2024-01-16 18:00:00'),
-- (1, 2, '李四', 4, '整体不错，但时间有点紧', '建议延长会议时间', 4, 4, 5, '2024-01-16 19:00:00'); 