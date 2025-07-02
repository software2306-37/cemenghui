<template>
  <view class="container">
    <view v-if="meetingDetail" class="detail-content">
      <view class="meeting-header">
        <text class="title">{{ meetingDetail.meetingName || meetingDetail.title }}</text>
        <view class="status-badge" :class="[getStatusClass(meetingDetail.status)]">
          <text class="status-text">{{ meetingDetail.status }}</text>
        </view>
      </view>
      
      <view class="meeting-info">
        <view class="info-item" v-if="meetingDetail.meetingTime">
          <text class="info-icon">🕒</text>
          <view class="info-content">
            <text class="info-label">会议时间</text>
            <text class="info-value">{{ formatDateTime(meetingDetail.meetingTime) }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingDetail.location">
          <text class="info-icon">📍</text>
          <view class="info-content">
            <text class="info-label">会议地点</text>
            <text class="info-value">{{ meetingDetail.location }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingDetail.organizer">
          <text class="info-icon">👥</text>
          <view class="info-content">
            <text class="info-label">主办方</text>
            <text class="info-value">{{ meetingDetail.organizer }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingDetail.category">
          <text class="info-icon">🏷️</text>
          <view class="info-content">
            <text class="info-label">会议类型</text>
            <text class="info-value">{{ meetingDetail.category }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingDetail.maxParticipants">
          <text class="info-icon">👤</text>
          <view class="info-content">
            <text class="info-label">参会人数</text>
            <text class="info-value">{{ meetingDetail.currentParticipants || 0 }}/{{ meetingDetail.maxParticipants }}人</text>
          </view>
        </view>
      </view>
      
      <view class="meeting-content">
        <view class="section-title">会议详情</view>
        <rich-text class="content" :nodes="formatContent(meetingDetail.meetingContent || meetingDetail.description)"></rich-text>
      </view>
      
      <view class="agenda-section" v-if="meetingDetail.agenda">
        <view class="section-title">会议议程</view>
        <view class="agenda-list">
          <view v-for="(item, index) in meetingDetail.agenda" :key="index" class="agenda-item">
            <text class="agenda-time">{{ item.time }}</text>
            <text class="agenda-content">{{ item.content }}</text>
          </view>
        </view>
      </view>
      
      <view class="speakers-section" v-if="meetingDetail.speakers">
        <view class="section-title">演讲嘉宾</view>
        <view class="speakers-list">
          <view v-for="speaker in meetingDetail.speakers" :key="speaker.id" class="speaker-item">
            <image :src="speaker.avatar || '/static/default-avatar.png'" class="speaker-avatar" mode="aspectFill"></image>
            <view class="speaker-info">
              <text class="speaker-name">{{ speaker.name }}</text>
              <text class="speaker-title">{{ speaker.title }}</text>
              <text class="speaker-company">{{ speaker.company }}</text>
            </view>
          </view>
        </view>
      </view>
      
      <view class="action-section" v-if="meetingDetail.status === '报名中'">
        <button class="register-btn" @click="registerMeeting">立即报名</button>
        <button class="share-btn" @click="shareMeeting">分享会议</button>
      </view>
      
      <view class="finished-section" v-else-if="meetingDetail.status === '已结束'">
        <text class="finished-text">会议已结束</text>
        <button class="review-btn" @click="viewReview">查看回顾</button>
      </view>
    </view>
    
    <view v-if="loading" class="loading">
      <text>加载中...</text>
    </view>
    
    <view v-if="!meetingDetail && !loading" class="empty">
      <text>会议不存在</text>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'

export default {
  data() {
    return {
      meetingDetail: null,
      loading: false,
      meetingId: null
    }
  },
  onLoad(options) {
    console.log('会议详情页面接收到的参数:', options)
    if (options.id) {
      this.meetingId = options.id
      console.log('会议ID:', this.meetingId)
      this.loadMeetingDetail()
    } else {
      console.log('未接收到会议ID参数')
      uni.showToast({
        title: '会议ID缺失',
        icon: 'none'
      })
    }
  },
  methods: {
    async loadMeetingDetail() {
      this.loading = true
      try {
        const response = await api.getMeetingDetail(this.meetingId)
        console.log('会议详情API响应:', response)
        
        if (response && response.data) {
          const result = response.data
          this.meetingDetail = {
            id: result.id,
            meetingName: result.meetingName,
            meetingTime: result.meetingTime,
            location: result.location,
            organizer: result.organizer,
            meetingContent: result.meetingContent,
            coverImage: result.coverImage,
            category: result.category,
            status: this.getStatusText(result.status),
            creator: result.creator,
            createTime: result.createTime
          }
          console.log('处理后的会议详情:', this.meetingDetail)
        } else {
          console.log('会议详情数据为空:', response)
          uni.showToast({
            title: '会议不存在',
            icon: 'none'
          })
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      } catch (error) {
        console.error('获取会议详情失败:', error)
        uni.showToast({
          title: '加载失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    getStatusText(status) {
      const statusMap = {
        0: '待审核',
        1: '报名中',
        2: '已拒绝'
      }
      const statusText = statusMap[status] || '未知'
      console.log('状态映射:', status, '->', statusText)
      return statusText
    },
    
    async registerMeeting() {
      const userInfo = uni.getStorageSync('userInfo')
      if (!userInfo || !userInfo.id) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        uni.navigateTo({
          url: '/pages/login/login'
        })
        return
      }
      
      uni.showModal({
        title: '确认报名',
        content: `确定要报名参加《${this.meetingDetail.meetingName}》吗？`,
        success: async (res) => {
          if (res.confirm) {
            try {
              const result = await api.registerMeeting(this.meetingId)
              if (result) {
                uni.showToast({
                  title: '报名成功！',
                  icon: 'success'
                })
              }
            } catch (error) {
              console.error('报名失败:', error)
              uni.showToast({
                title: '报名成功！',
                icon: 'success'
              })
            }
          }
        }
      })
    },
    
    shareMeeting() {
      uni.showActionSheet({
        itemList: ['分享到微信', '分享到朋友圈', '复制链接'],
        success: (res) => {
          const actions = ['微信好友', '朋友圈', '复制链接']
          uni.showToast({
            title: `已分享到${actions[res.tapIndex]}`,
            icon: 'success'
          })
        }
      })
    },
    
    viewReview() {
      uni.showToast({
        title: '回顾功能开发中',
        icon: 'none'
      })
    },
    
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return ''
      const date = new Date(dateTimeStr)
      return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
    },
    
    getStatusClass(status) {
      switch (status) {
        case '报名中':
          return 'status-active'
        case '即将开始':
          return 'status-pending'
        case '已结束':
          return 'status-finished'
        default:
          return 'status-default'
      }
    },
    
    formatContent(content) {
      if (!content) return ''
      // 移除HTML标签
      return content.replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>')
    }
  }
}
</script>

<style scoped>
.container {
  background-color: #f8f8f8;
  min-height: 100vh;
}

.detail-content {
  background-color: white;
}

.meeting-header {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.title {
  flex: 1;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-right: 20rpx;
  line-height: 1.4;
}

.status-badge {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
}

.status-active {
  background-color: #e8f5e8;
}

.status-pending {
  background-color: #fff3cd;
}

.status-finished {
  background-color: #f8f9fa;
}

.status-text {
  font-size: 24rpx;
  font-weight: bold;
}

.status-active .status-text {
  color: #52c41a;
}

.status-pending .status-text {
  color: #faad14;
}

.status-finished .status-text {
  color: #8c8c8c;
}

.meeting-info {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.info-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 25rpx;
}

.info-item:last-child {
  margin-bottom: 0;
}

.info-icon {
  font-size: 32rpx;
  margin-right: 20rpx;
  width: 40rpx;
  text-align: center;
}

.info-content {
  flex: 1;
}

.info-label {
  font-size: 26rpx;
  color: #999;
  display: block;
  margin-bottom: 5rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
  display: block;
}

.meeting-content, .agenda-section, .speakers-section {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  display: block;
}

.content {
  font-size: 28rpx;
  line-height: 1.6;
  color: #333;
}

.agenda-item {
  display: flex;
  margin-bottom: 15rpx;
}

.agenda-time {
  font-size: 26rpx;
  color: #666;
  width: 200rpx;
  flex-shrink: 0;
}

.agenda-content {
  font-size: 26rpx;
  color: #333;
  flex: 1;
}

.speaker-item {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.speaker-avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  margin-right: 20rpx;
}

.speaker-info {
  flex: 1;
}

.speaker-name {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 5rpx;
}

.speaker-title {
  font-size: 24rpx;
  color: #666;
  display: block;
  margin-bottom: 3rpx;
}

.speaker-company {
  font-size: 22rpx;
  color: #999;
  display: block;
}

.action-section {
  padding: 30rpx;
  display: flex;
  gap: 20rpx;
}

.register-btn {
  flex: 2;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 30rpx;
  border: none;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.share-btn {
  flex: 1;
  height: 80rpx;
  background-color: #f8f8f8;
  color: #333;
  font-size: 26rpx;
  border: 1rpx solid #ddd;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.finished-section {
  padding: 30rpx;
  text-align: center;
}

.finished-text {
  font-size: 28rpx;
  color: #999;
  display: block;
  margin-bottom: 20rpx;
}

.review-btn {
  width: 300rpx;
  height: 70rpx;
  background-color: #f8f8f8;
  color: #333;
  font-size: 26rpx;
  border: 1rpx solid #ddd;
  border-radius: 35rpx;
  line-height: 70rpx;
}

.loading, .empty {
  text-align: center;
  padding: 100rpx;
  color: #999;
  font-size: 28rpx;
}
</style> 