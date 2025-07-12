-- 课程学习和收藏功能所需的数据库表结构
-- 请在数据库中执行这些SQL语句以支持新功能

-- 课程报名/学习记录表
CREATE TABLE IF NOT EXISTS `course_enrollment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '用户姓名',
  `user_email` varchar(100) DEFAULT NULL COMMENT '用户邮箱',
  `user_phone` varchar(20) DEFAULT NULL COMMENT '用户电话',
  `progress` int(11) DEFAULT '0' COMMENT '学习进度 0-100',
  `status` int(11) DEFAULT '0' COMMENT '状态 0:已报名 1:学习中 2:已完成 3:已取消',
  `enrollment_time` datetime DEFAULT NULL COMMENT '报名时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始学习时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_user_id` (`user_id`),
  UNIQUE KEY `uk_course_user` (`course_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程报名/学习记录表';

-- 用户收藏表
CREATE TABLE IF NOT EXISTS `user_favorite` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `favorite_type` varchar(20) NOT NULL COMMENT '收藏类型 course:课程 meeting:会议 news:新闻',
  `favorite_id` bigint(20) NOT NULL COMMENT '被收藏内容的ID',
  `favorite_title` varchar(200) DEFAULT NULL COMMENT '被收藏内容的标题',
  `favorite_summary` text DEFAULT NULL COMMENT '被收藏内容的摘要',
  `favorite_cover` varchar(500) DEFAULT NULL COMMENT '被收藏内容的封面',
  `favorite_author` varchar(50) DEFAULT NULL COMMENT '被收藏内容的作者',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_favorite_type` (`favorite_type`),
  KEY `idx_favorite_id` (`favorite_id`),
  UNIQUE KEY `uk_user_favorite` (`user_id`, `favorite_type`, `favorite_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收藏表'; 