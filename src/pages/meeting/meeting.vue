<template>
  <view class="container">
    <view class="header">
      <text class="title">合作会议</text>
    </view>
    
    <!-- 会议列表 -->
    <scroll-view v-if="meetingList.length > 0" scroll-y="true" class="meeting-list">
      <view class="meeting-item" v-for="item in meetingList" :key="item.id" @click="goToDetail(item.id)">
        <!-- 会议封面 -->
        <view class="meeting-image-container">
          <image v-if="item.coverImage" 
                 :src="getImageUrl(item.coverImage)" 
                 class="meeting-image" 
                 mode="aspectFill"
                 @error="onImageError"></image>
          <view v-else class="meeting-image-placeholder">
            <text class="placeholder-icon">🤝</text>
          </view>
        </view>
        
        <!-- 会议信息 -->
        <view class="meeting-content">
          <text class="meeting-title">{{ item.meetingName }}</text>
          
          <view class="meeting-meta">
            <text class="meeting-time" v-if="item.meetingTime">
              ⏰ {{ formatDateTime(item.meetingTime, 'MM-DD HH:mm') }}
            </text>
            <text class="meeting-location" v-if="item.location">
              📍 {{ item.location }}
            </text>
          </view>
          
          <view class="meeting-footer">
            <view class="meeting-info">
              <text class="meeting-organizer" v-if="item.organizer">主办方：{{ item.organizer }}</text>
              <text class="meeting-category" v-if="item.category">{{ item.category }}</text>
            </view>
            <view class="meeting-action">
              <text class="register-btn">立即报名</text>
            </view>
          </view>
        </view>
      </view>
      
      <!-- 加载更多 -->
      <view v-if="hasMore && !loading" class="load-more" @click="loadMore">
        <text class="load-more-text">点击加载更多会议</text>
      </view>
    </scroll-view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">🤝</text>
      <text class="empty-text">暂无合作会议</text>
      <text class="empty-desc">敬请期待精彩会议</text>
    </view>
    
    <!-- 加载状态 -->
    <view v-if="loading" class="loading">
      <text class="loading-text">加载中...</text>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { formatDateTime, getImageUrl } from '../../utils/common'

export default {
  data() {
    return {
      meetingList: [],
      loading: false,
      currentPage: 1,
      pageSize: 10,
      hasMore: true
    }
  },
  onLoad() {
    this.loadMeetings()
  },
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.loadMore()
    }
  },
  onPullDownRefresh() {
    this.currentPage = 1
    this.meetingList = []
    this.hasMore = true
    this.loadMeetings().then(() => {
      uni.stopPullDownRefresh()
    })
  },
  methods: {
    async loadMeetings() {
      if (this.loading) return
      
      this.loading = true
      try {
        console.log('加载会议列表，页码:', this.currentPage)
        
        const params = {
          current: this.currentPage,
          size: this.pageSize,
          status: 1  // 只获取已发布的会议 (status = 1)
        }
        
        const result = await api.getMeetingList(params)
        console.log('会议列表API响应:', result)
        
        const meetingsData = result && result.data && result.data.records ? result.data.records : []
        if (meetingsData.length > 0) {
          // 过滤确保只显示已发布的内容
          const publishedMeetings = meetingsData.filter(item => item.status === 1)
          
          if (this.currentPage === 1) {
            this.meetingList = publishedMeetings
          } else {
            this.meetingList = [...this.meetingList, ...publishedMeetings]
          }
          
          this.hasMore = publishedMeetings.length === this.pageSize && this.meetingList.length < (result.data.total || 0)
          
          console.log('已发布会议数量:', publishedMeetings.length)
          console.log('总会议数量:', this.meetingList.length)
        } else {
          this.meetingList = []
          this.hasMore = false
        }
      } catch (error) {
        console.error('加载会议列表失败:', error)
        uni.showToast({
          title: '加载失败，请重试',
          icon: 'none'
        })
        
        // 如果是第一页加载失败，设置空数组
        if (this.currentPage === 1) {
          this.meetingList = []
        }
        this.hasMore = false
      } finally {
        this.loading = false
      }
    },
    
    async loadMore() {
      if (this.loading || !this.hasMore) return
      this.currentPage++
      await this.loadMeetings()
    },
    
    goToDetail(id) {
      if (!id) {
        uni.showToast({
          title: '会议不存在',
          icon: 'none'
        })
        return
      }
      
      uni.navigateTo({
        url: `/pages/meeting/detail?id=${id}`
      })
    },
    
    async registerMeeting(id) {
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
        content: '确定要报名参加这个会议吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              const result = await api.registerMeeting(id)
              if (result) {
                uni.showToast({
                  title: '报名成功！',
                  icon: 'success'
                })
              }
            } catch (error) {
              console.error('会议报名失败:', error)
              uni.showToast({
                title: '报名失败，请重试',
                icon: 'none'
              })
            }
          }
        }
      })
    },
    
    formatDateTime(dateTimeStr, format = 'YYYY-MM-DD HH:mm') {
      return formatDateTime(dateTimeStr, format)
    },
    
    getImageUrl(imagePath) {
      return getImageUrl(imagePath)
    },
    
    onImageError(e) {
      console.log('会议封面加载失败:', e)
    },
    
    getStatusText(status) {
      const statusMap = {
        0: '待审核',
        1: '已发布',
        2: '已拒绝'
      }
      return statusMap[status] || '未知'
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
  margin-bottom: 30rpx;
  padding: 20rpx 0;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.meeting-list {
  height: calc(100vh - 200rpx);
}

.meeting-item {
  background-color: white;
  margin-bottom: 20rpx;
  border-radius: 12rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.meeting-item:active {
  transform: scale(0.98);
  background-color: #f9f9f9;
}

.meeting-image-container {
  width: 100%;
  height: 200rpx;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.meeting-image {
  width: 100%;
  height: 100%;
}

.meeting-image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f0f0;
}

.placeholder-icon {
  font-size: 60rpx;
  opacity: 0.5;
}

.meeting-content {
  padding: 30rpx;
}

.meeting-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  display: block;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.meeting-meta {
  margin-bottom: 20rpx;
}

.meeting-time {
  font-size: 26rpx;
  color: #666;
  display: block;
  margin-bottom: 8rpx;
}

.meeting-location {
  font-size: 26rpx;
  color: #666;
  display: block;
}

.meeting-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meeting-info {
  flex: 1;
}

.meeting-organizer {
  font-size: 24rpx;
  color: #999;
  display: block;
  margin-bottom: 6rpx;
}

.meeting-category {
  font-size: 22rpx;
  color: #007aff;
  background-color: #e6f3ff;
  padding: 4rpx 12rpx;
  border-radius: 12rpx;
  display: inline-block;
}

.meeting-action {
  display: flex;
  align-items: center;
}

.register-btn {
  font-size: 26rpx;
  color: #007aff;
  font-weight: bold;
}

.load-more {
  text-align: center;
  padding: 30rpx;
  margin: 20rpx 0;
}

.load-more-text {
  font-size: 28rpx;
  color: #007aff;
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
  display: block;
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