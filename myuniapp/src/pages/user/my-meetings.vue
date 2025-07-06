<template>
  <view class="container">
    <view class="header">
      <text class="title">我的会议</text>
    </view>
    
    <!-- 统计信息 -->
    <view class="stats">
      <view class="stat-item">
        <text class="stat-number">{{ stats.registered }}</text>
        <text class="stat-label">已报名</text>
      </view>
      <view class="stat-item">
        <text class="stat-number">{{ stats.upcoming }}</text>
        <text class="stat-label">即将开始</text>
      </view>
      <view class="stat-item">
        <text class="stat-number">{{ stats.attended }}</text>
        <text class="stat-label">已参加</text>
      </view>
    </view>
    
    <!-- 会议列表 -->
    <view v-if="meetingList.length > 0" class="meeting-list">
      <view class="meeting-item" v-for="meeting in meetingList" :key="meeting.id" @click="goToMeetingDetail(meeting)">
        <view class="meeting-image-container">
          <image v-if="meeting.coverImage" :src="getCoverUrl(meeting.coverImage)" class="meeting-image" mode="aspectFill"></image>
          <view v-else class="meeting-image-placeholder">
            <text class="placeholder-icon">🤝</text>
          </view>
          <view class="status-overlay" :class="'status-' + (meeting.meetingStatus || 'unknown')">
            <text class="status-text">{{ meeting.meetingStatus || '未知' }}</text>
          </view>
        </view>
        
        <view class="meeting-content">
          <text class="meeting-title">{{ meeting.title }}</text>
          <text class="meeting-organizer" v-if="meeting.organizer">主办方：{{ meeting.organizer }}</text>
          
          <view class="meeting-meta">
            <text class="meeting-time" v-if="meeting.startTime">
              ⏰ {{ formatTime(meeting.startTime) }}
            </text>
            <text class="meeting-location" v-if="meeting.location">
              📍 {{ meeting.location }}
            </text>
          </view>
          
          <view class="registration-info">
            <text class="register-time">报名时间：{{ formatDate(meeting.enrollTime) }}</text>
            <text class="attendance-status" :class="'attendance-' + (meeting.participationStatus || 'unknown')">
              {{ meeting.participationStatus || '未知状态' }}
            </text>
          </view>
          
          <view class="meeting-actions">
            <button class="checkin-btn" v-if="meeting.meetingStatus === '进行中'" @click.stop="checkIn(meeting)">
              签到
            </button>
            <button class="cancel-btn" v-else-if="meeting.meetingStatus === '即将开始'" @click.stop="cancelRegistration(meeting)">
              取消报名
            </button>
            <button class="review-btn" v-else-if="meeting.meetingStatus === '已结束'" @click.stop="viewReview(meeting)">
              查看回顾
            </button>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">🤝</text>
      <text class="empty-text">还没有报名任何会议</text>
      <text class="empty-desc">去发现更多精彩会议吧</text>
      <button class="explore-btn" @click="goToMeetings">浏览会议</button>
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
      meetingList: [],
      stats: {
        registered: 0,
        upcoming: 0,
        attended: 0
      }
    }
  },
  
  onLoad() {
    this.loadMeetings()
  },
  
  onShow() {
    this.loadMeetings()
  },
  
  methods: {
    async loadMeetings() {
      this.loading = true
      try {
        console.log('开始加载我的会议列表')
        const response = await api.getMyMeetings()
        console.log('我的会议数据响应:', response)
        
        if (response && response.code === 200 && response.data) {
          const meetingData = Array.isArray(response.data) ? response.data : (response.data.records || [])
          this.meetingList = meetingData
          console.log('成功加载会议列表，数量:', this.meetingList.length)
          this.calculateStats()
        } else {
          console.log('会议数据格式不正确或为空:', response)
          this.meetingList = []
        }
      } catch (error) {
        console.error('获取会议列表失败:', error)
        // 如果是未登录错误，不显示错误提示，让request.js处理
        if (error.message !== '未登录') {
          uni.showToast({
            title: '获取会议列表失败',
            icon: 'none'
          })
        }
        this.meetingList = []
      } finally {
        this.loading = false
      }
    },
    
    calculateStats() {
      const stats = {
        registered: this.meetingList.length,
        upcoming: 0,
        attended: 0
      }
      
      this.meetingList.forEach(meeting => {
        if (meeting.meetingStatus === '即将开始') {
          stats.upcoming++
        } else if (meeting.participationStatus === '已参加') {
          stats.attended++
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
    
    formatTime(dateTime) {
      if (!dateTime) return ''
      const date = new Date(dateTime)
      return `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
    },
    
    goToMeetingDetail(meeting) {
      uni.navigateTo({
        url: `/pages/meeting/detail?id=${meeting.id}`
      })
    },
    
    checkIn(meeting) {
      uni.showModal({
        title: '签到确认',
        content: `确定要为会议《${meeting.title}》签到吗？`,
        success: (res) => {
          if (res.confirm) {
            uni.showToast({
              title: '签到成功',
              icon: 'success'
            })
            // 更新会议状态
            meeting.participationStatus = '已参加'
          }
        }
      })
    },
    
    cancelRegistration(meeting) {
      uni.showModal({
        title: '取消报名',
        content: `确定要取消《${meeting.title}》的报名吗？`,
        success: (res) => {
          if (res.confirm) {
            uni.showToast({
              title: '已取消报名',
              icon: 'success'
            })
            // 从列表中移除
            const index = this.meetingList.findIndex(m => m.id === meeting.id)
            if (index > -1) {
              this.meetingList.splice(index, 1)
              this.calculateStats()
            }
          }
        }
      })
    },
    
    viewReview(meeting) {
      uni.showToast({
        title: '查看会议回顾',
        icon: 'none'
      })
      this.goToMeetingDetail(meeting)
    },
    
    goToMeetings() {
      uni.switchTab({
        url: '/pages/meeting/meeting'
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

.meeting-list {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
}

.meeting-item {
  display: flex;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.meeting-item:last-child {
  border-bottom: none;
}

.meeting-image-container {
  position: relative;
  width: 120rpx;
  height: 120rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.meeting-image {
  width: 100%;
  height: 100%;
  border-radius: 8rpx;
}

.meeting-image-placeholder {
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

.status-overlay {
  position: absolute;
  top: 0;
  right: 0;
  padding: 4rpx 8rpx;
  border-radius: 0 8rpx 0 8rpx;
}

.status-upcoming {
  background-color: #fa8c16;
}

.status-ongoing {
  background-color: #52c41a;
}

.status-completed {
  background-color: #999;
}

.status-text {
  font-size: 20rpx;
  color: white;
}

.meeting-content {
  flex: 1;
}

.meeting-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
  line-height: 1.4;
}

.meeting-organizer {
  font-size: 24rpx;
  color: #666;
  margin-bottom: 15rpx;
  display: block;
}

.meeting-meta {
  margin-bottom: 15rpx;
}

.meeting-time {
  font-size: 24rpx;
  color: #666;
  display: block;
  margin-bottom: 6rpx;
}

.meeting-location {
  font-size: 24rpx;
  color: #666;
  display: block;
}

.registration-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
}

.register-time {
  font-size: 22rpx;
  color: #999;
}

.attendance-status {
  font-size: 22rpx;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
}

.attendance-registered {
  background-color: #e6f3ff;
  color: #007aff;
}

.attendance-attended {
  background-color: #e8f5e8;
  color: #52c41a;
}

.attendance-absent {
  background-color: #fff2e8;
  color: #fa8c16;
}

.meeting-actions {
  display: flex;
  justify-content: flex-end;
}

.checkin-btn, .cancel-btn, .review-btn {
  padding: 12rpx 24rpx;
  font-size: 24rpx;
  border-radius: 20rpx;
  border: none;
}

.checkin-btn {
  background-color: #52c41a;
  color: white;
}

.cancel-btn {
  background-color: #ff4757;
  color: white;
}

.review-btn {
  background-color: #007aff;
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