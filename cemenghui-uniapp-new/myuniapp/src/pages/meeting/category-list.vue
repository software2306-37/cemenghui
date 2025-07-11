<template>
  <view class="container">
    <view class="header">
      <view class="search-container">
        <view class="search-box">
          <input 
            v-model="searchKeyword" 
            placeholder="搜索会议标题、地点..." 
            class="search-input"
            confirm-type="search"
            @confirm="onSearch"
            @input="onSearchInput"
          />
          <text class="search-icon" @click="onSearch">🔍</text>
        </view>
        <view v-if="searchKeyword" class="search-actions">
          <text class="clear-search" @click="clearSearch">清除</text>
        </view>
      </view>
    </view>
    
    <!-- 会议列表 -->
    <scroll-view v-if="meetingList.length > 0" scroll-y="true" class="meeting-list">
      <view class="meeting-card" v-for="item in meetingList" :key="item.id" @click="goToDetail(item.id)">
        <view class="meeting-cover-wrap">
          <image v-if="item.coverImage" 
                 :src="getImageUrl(item.coverImage)" 
                 class="meeting-cover" 
                 mode="aspectFill"
                 @error="onImageError"></image>
          <view v-else class="meeting-cover-placeholder">
            <text class="placeholder-icon">🤝</text>
          </view>
        </view>
        <view class="meeting-info">
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
            <text class="meeting-organizer" v-if="item.organizer">主办方：{{ item.organizer }}</text>
            <text class="meeting-category" v-if="item.category">{{ item.category }}</text>
          </view>
        </view>
      </view>
      <view v-if="hasMore && !loading" class="load-more" @click="loadMore">
        <text class="load-more-text">点击加载更多会议</text>
      </view>
    </scroll-view>
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">🤝</text>
      <text class="empty-text">暂无{{ categoryName }}</text>
      <text class="empty-desc">敬请期待精彩会议</text>
    </view>
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
      hasMore: true,
      searchKeyword: '',
      searchTimer: null,
      refreshing: false,
      isLoggedIn: false,
      category: '',
      categoryName: ''
    }
  },
  onLoad(options) {
    if (options.category) {
      this.category = decodeURIComponent(options.category)
    }
    if (options.name) {
      this.categoryName = decodeURIComponent(options.name)
    }
    
    // 设置页面标题
    uni.setNavigationBarTitle({
      title: this.categoryName
    })
    
    this.checkLoginStatus()
    this.loadMeetings()
  },
  onShow() {
    this.checkLoginStatus()
    // 如果登录状态发生变化，重新检查报名状态
    if (this.meetingList.length > 0) {
      this.checkRegistrationStatus()
    }
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
    checkLoginStatus() {
      const userInfo = uni.getStorageSync('userInfo')
      this.isLoggedIn = !!(userInfo && userInfo.id)
    },
    
    async checkRegistrationStatus() {
      if (!this.isLoggedIn || this.meetingList.length === 0) {
        // 未登录或无会议列表，设置所有会议为未报名
        this.meetingList.forEach(meeting => {
          this.$set(meeting, 'isRegistered', false)
        })
        return
      }
      
      try {
        const meetingIds = this.meetingList.map(meeting => meeting.id)
        const result = await api.batchCheckMeetingRegistration(meetingIds)
        
        if (result && result.data) {
          this.meetingList.forEach(meeting => {
            const isRegistered = result.data[meeting.id] || false
            this.$set(meeting, 'isRegistered', isRegistered)
          })
        }
      } catch (error) {
        console.error('检查报名状态失败:', error)
        // 失败时设置为未报名状态
        this.meetingList.forEach(meeting => {
          this.$set(meeting, 'isRegistered', false)
        })
      }
    },
    
    async loadMeetings() {
      if (this.loading) return
      
      this.loading = true
      try {
        console.log('加载会议列表，页码:', this.currentPage, '分类:', this.category)
        
        const params = {
          current: this.currentPage,
          size: this.pageSize,
          status: 1,  // 只获取已发布的会议 (status = 1)
          keyword: this.searchKeyword || undefined  // 添加搜索关键词
        }
        
        // 如果不是全部会议，添加分类筛选
        if (this.category && this.category !== 'all') {
          params.category = this.category
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
          
          // 检查报名状态
          this.checkRegistrationStatus()
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

    // 搜索相关方法
    onSearchInput() {
      // 防抖处理，用户停止输入500ms后自动搜索
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
      }
      this.searchTimer = setTimeout(() => {
        this.onSearch()
      }, 500)
    },

    onSearch() {
      console.log('执行会议搜索，关键词:', this.searchKeyword)
      this.refreshData()
    },

    clearSearch() {
      this.searchKeyword = ''
      this.refreshData()
    },

    // 刷新相关方法
    async refreshData() {
      this.currentPage = 1
      this.meetingList = []
      this.hasMore = true
      this.refreshing = true
      
      try {
        await this.loadMeetings()
      } finally {
        this.refreshing = false
        uni.stopPullDownRefresh()
      }
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
    },
    
    getMeetingActionText(meeting) {
      const now = new Date()
      const meetingTime = new Date(meeting.meetingTime)
      const endTime = new Date(meetingTime.getTime() + 2 * 60 * 60 * 1000) // 假设会议持续2小时
      
      // 会议已结束
      if (now > endTime) {
        if (meeting.isRegistered) {
          return '已结束'
        } else {
          return '会议已结束'
        }
      }
      
      // 会议进行中
      if (now >= meetingTime && now <= endTime) {
        if (meeting.isRegistered) {
          return '参会中'
        } else {
          return '会议进行中'
        }
      }
      
      // 会议未开始
      if (meeting.isRegistered) {
        return '已报名'
      } else {
        return '立即报名'
      }
    },
    
    getMeetingActionClass(meeting) {
      const now = new Date()
      const meetingTime = new Date(meeting.meetingTime)
      const endTime = new Date(meetingTime.getTime() + 2 * 60 * 60 * 1000) // 假设会议持续2小时
      
      // 会议已结束
      if (now > endTime) {
        return 'ended'
      }
      
      // 会议进行中
      if (now >= meetingTime && now <= endTime) {
        return 'ongoing'
      }
      
      // 会议未开始
      if (meeting.isRegistered) {
        return 'registered'
      } else {
        return 'can-register'
      }
    }
  }
}
</script>

<style scoped>
.container {
  padding: 20rpx 10rpx 0 10rpx;
  background: #f6f8fa;
  min-height: 100vh;
}
.header {
  margin-bottom: 20rpx;
  padding: 20rpx 10rpx 0 10rpx;
}

.search-container {
  display: flex;
  align-items: center;
  gap: 15rpx;
}

.search-box {
  flex: 1;
  position: relative;
  background: #fff;
  border-radius: 25rpx;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1);
  overflow: hidden;
}

.search-input {
  width: 100%;
  height: 70rpx;
  padding: 0 60rpx 0 30rpx;
  border: none;
  background: transparent;
  font-size: 28rpx;
  color: #333;
  box-sizing: border-box;
}

.search-icon {
  position: absolute;
  right: 20rpx;
  top: 50%;
  transform: translateY(-50%);
  font-size: 32rpx;
  color: #666;
  cursor: pointer;
}

.search-actions {
  display: flex;
  align-items: center;
}

.clear-search {
  font-size: 26rpx;
  color: #007aff;
  padding: 10rpx 15rpx;
  background: #f0f8ff;
  border-radius: 15rpx;
  cursor: pointer;
}
.meeting-list {
  padding-bottom: 30rpx;
}
.meeting-card {
  background: linear-gradient(135deg, #6dd5fa 0%, #2980b9 100%);
  border-radius: 20rpx;
  box-shadow: 0 6rpx 24rpx rgba(0,0,0,0.10);
  margin-bottom: 28rpx;
  padding: 0;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  transition: transform 0.1s;
  min-height: 200rpx;
}
.meeting-card:active {
  transform: scale(0.97);
}
.meeting-cover-wrap {
  width: 280rpx;
  height: 200rpx;
  border-radius: 18rpx 0 0 18rpx;
  overflow: hidden;
  background: #eaf6fb;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.08);
}
.meeting-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 18rpx 0 0 18rpx;
  display: block;
}
.meeting-cover-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #eaf6fb;
}
.placeholder-icon {
  font-size: 60rpx;
  color: #b0c4de;
}
.meeting-info {
  flex: 1;
  padding: 30rpx 25rpx 25rpx 25rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.meeting-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #fff;
  margin-bottom: 15rpx;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}
.meeting-meta {
  font-size: 24rpx;
  color: #e0e0e0;
  margin-bottom: 12rpx;
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}
.meeting-footer {
  font-size: 22rpx;
  color: #e0e0e0;
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}
.meeting-organizer {
  color: #e0e0e0;
}
.meeting-category {
  color: #e0e0e0;
}
.load-more {
  text-align: center;
  padding: 30rpx 0 0 0;
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