<template>
  <view class="container">
    <view class="header">
      <text class="title">我的课程</text>
    </view>
    
    <!-- 统计信息 -->
    <view class="stats">
      <view class="stat-item">
        <text class="stat-number">{{ stats.enrolled }}</text>
        <text class="stat-label">已报名</text>
      </view>
      <view class="stat-item">
        <text class="stat-number">{{ stats.completed }}</text>
        <text class="stat-label">已完成</text>
      </view>
      <view class="stat-item">
        <text class="stat-number">{{ stats.inProgress }}</text>
        <text class="stat-label">学习中</text>
      </view>
    </view>
    
    <!-- 课程列表 -->
    <view v-if="courseList.length > 0" class="course-list">
      <view class="course-item" v-for="course in courseList" :key="course.id" @click="goToCourseDetail(course)">
        <view class="course-image-container">
          <image v-if="course.coverImage" :src="getCoverUrl(course.coverImage)" class="course-image" mode="aspectFill"></image>
          <view v-if="!course.coverImage" class="course-image-placeholder">
            <text class="placeholder-icon">📚</text>
          </view>
          <view class="progress-overlay" v-if="course.progress !== undefined">
            <text class="progress-text">{{ course.progress }}%</text>
          </view>
        </view>
        
        <view class="course-content">
          <text class="course-title">{{ course.title || course.courseName }}</text>
          <text class="course-author" v-if="course.instructor">讲师：{{ course.instructor }}</text>
          
          <view class="course-meta">
            <text class="enroll-time">报名时间：{{ formatDate(course.enrollTime) }}</text>
            <text class="study-status" :class="'status-' + (course.learningStatus || 'unknown')">
              {{ course.learningStatus || '未知状态' }}
            </text>
          </view>
          
          <!-- 进度条 -->
          <view class="progress-bar" v-if="course.progress !== undefined">
            <view class="progress-track">
              <view class="progress-fill" :style="{ width: course.progress + '%' }"></view>
            </view>
            <text class="progress-label">学习进度 {{ course.progress }}%</text>
          </view>
          
          <view class="course-actions">
            <button class="continue-btn" v-if="course.learningStatus === '学习中'" @click.stop="continueLearning(course)">
              继续学习
            </button>
            <button class="start-btn" v-else-if="course.learningStatus === '未开始'" @click.stop="startLearning(course)">
              开始学习
            </button>
            <button class="review-btn" v-else-if="course.learningStatus === '已完成'" @click.stop="reviewCourse(course)">
              复习课程
            </button>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">📚</text>
      <text class="empty-text">还没有报名任何课程</text>
      <text class="empty-desc">去发现更多精彩课程吧</text>
      <button class="explore-btn" @click="goToCourses">浏览课程</button>
    </view>
    
    <!-- 加载状态 -->
    <view v-if="loading" class="loading">
      <text class="loading-text">加载中...</text>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { getAvatarUrl } from '../../utils/common'

export default {
  data() {
    return {
      loading: false,
      courseList: [],
      stats: {
        enrolled: 0,
        completed: 0,
        inProgress: 0
      }
    }
  },
  
  onLoad() {
    this.loadCourses()
  },
  
  onShow() {
    this.loadCourses()
  },
  
  methods: {
    async loadCourses() {
      this.loading = true
      try {
        console.log('开始加载我的课程列表')
        const response = await api.getMyCourses()
        console.log('我的课程数据响应:', response)
        
        if (response && response.code === 200 && response.data) {
          const courseData = Array.isArray(response.data) ? response.data : (response.data.records || [])
          this.courseList = courseData
          console.log('成功加载课程列表，数量:', this.courseList.length)
          this.calculateStats()
        } else {
          console.log('课程数据格式不正确或为空:', response)
          this.courseList = []
        }
      } catch (error) {
        console.error('获取课程列表失败:', error)
        // 如果是未登录错误，不显示错误提示，让request.js处理
        if (error.message !== '未登录') {
          uni.showToast({
            title: '获取课程列表失败',
            icon: 'none'
          })
        }
        this.courseList = []
      } finally {
        this.loading = false
      }
    },
    
    calculateStats() {
      const stats = {
        enrolled: this.courseList.length,
        completed: 0,
        inProgress: 0
      }
      
      this.courseList.forEach(course => {
        if (course.learningStatus === '已完成') {
          stats.completed++
        } else if (course.learningStatus === '学习中') {
          stats.inProgress++
        }
      })
      
      this.stats = stats
    },
    
    getCoverUrl(coverImage) {
      if (!coverImage) {
        return '/static/logo.png'
      }
      return getAvatarUrl(coverImage)
    },
    
    formatDate(dateTime) {
      if (!dateTime) return ''
      const date = new Date(dateTime)
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
    },
    
    goToCourseDetail(course) {
      uni.navigateTo({
        url: `/pages/course/detail?id=${course.id}`
      })
    },
    
    startLearning(course) {
      this.goToCourseDetail(course)
    },
    
    continueLearning(course) {
      this.goToCourseDetail(course)
    },
    
    reviewCourse(course) {
      this.goToCourseDetail(course)
    },
    
    goToCourses() {
      uni.switchTab({
        url: '/pages/course/course'
      })
    }
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx;
  background-color: #f8f8f8;
  min-height: 100vh;
}

.header {
  text-align: center;
  padding: 20rpx 0 30rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.stats {
  background-color: white;
  border-radius: 12rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  display: flex;
}

.stat-item {
  flex: 1;
  text-align: center;
}

.stat-number {
  font-size: 32rpx;
  font-weight: bold;
  color: #007aff;
  display: block;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #666;
  display: block;
}

.course-list {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
}

.course-item {
  display: flex;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.course-item:last-child {
  border-bottom: none;
}

.course-image-container {
  position: relative;
  width: 120rpx;
  height: 120rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.course-image {
  width: 100%;
  height: 100%;
  border-radius: 8rpx;
}

.course-image-placeholder {
  width: 100%;
  height: 100%;
  background-color: #f0f0f0;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-icon {
  font-size: 40rpx;
  opacity: 0.5;
}

.progress-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.7);
  border-radius: 0 0 8rpx 8rpx;
  padding: 4rpx;
}

.progress-text {
  font-size: 20rpx;
  color: white;
  text-align: center;
  display: block;
}

.course-content {
  flex: 1;
}

.course-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
  line-height: 1.4;
}

.course-author {
  font-size: 24rpx;
  color: #666;
  margin-bottom: 15rpx;
  display: block;
}

.course-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
}

.enroll-time {
  font-size: 22rpx;
  color: #999;
}

.study-status {
  font-size: 22rpx;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
}

.status-not_started {
  background-color: #f0f0f0;
  color: #666;
}

.status-studying {
  background-color: #e6f3ff;
  color: #007aff;
}

.status-completed {
  background-color: #e8f5e8;
  color: #52c41a;
}

.progress-bar {
  margin-bottom: 15rpx;
}

.progress-track {
  height: 6rpx;
  background-color: #f0f0f0;
  border-radius: 3rpx;
  margin-bottom: 8rpx;
}

.progress-fill {
  height: 100%;
  background-color: #007aff;
  border-radius: 3rpx;
  transition: width 0.3s ease;
}

.progress-label {
  font-size: 22rpx;
  color: #666;
}

.course-actions {
  display: flex;
  justify-content: flex-end;
}

.continue-btn, .start-btn, .review-btn {
  padding: 12rpx 24rpx;
  font-size: 24rpx;
  border-radius: 20rpx;
  border: none;
}

.continue-btn {
  background-color: #007aff;
  color: white;
}

.start-btn {
  background-color: #52c41a;
  color: white;
}

.review-btn {
  background-color: #fa8c16;
  color: white;
}

.empty-state {
  text-align: center;
  padding: 100rpx 40rpx;
  margin-top: 100rpx;
}

.empty-icon {
  font-size: 80rpx;
  display: block;
  margin-bottom: 20rpx;
  opacity: 0.5;
}

.empty-text {
  font-size: 32rpx;
  color: #666;
  margin-bottom: 10rpx;
  display: block;
}

.empty-desc {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 30rpx;
  display: block;
}

.explore-btn {
  width: 200rpx;
  height: 60rpx;
  background-color: #007aff;
  color: white;
  font-size: 26rpx;
  border: none;
  border-radius: 30rpx;
  line-height: 60rpx;
}

.loading {
  text-align: center;
  padding: 60rpx;
  margin-top: 100rpx;
}

.loading-text {
  font-size: 28rpx;
  color: #999;
}
</style> 