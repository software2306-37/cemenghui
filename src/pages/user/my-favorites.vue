<template>
  <view class="container">
    <view class="header">
      <text class="title">我的收藏</text>
    </view>
    
    <!-- 分类标签 -->
    <view class="category-tabs">
      <view class="tab-item" 
            v-for="(tab, index) in tabs" 
            :key="index"
            :class="{ active: activeTab === index }"
            @click="switchTab(index)">
        <text class="tab-text">{{ tab.label }}</text>
        <text class="tab-count">({{ tab.count }})</text>
      </view>
    </view>
    
    <!-- 收藏列表 -->
    <view v-if="currentList.length > 0" class="favorite-list">
      <view class="favorite-item" v-for="item in currentList" :key="item.id" @click="goToDetail(item)">
        <view class="item-image-container">
          <image v-if="item.coverImage" :src="getImageUrl(item.coverImage)" class="item-image" mode="aspectFill"></image>
          <view v-else class="item-image-placeholder">
            <text class="placeholder-icon">{{ getTypeIcon(item.type) }}</text>
          </view>
          <view class="type-tag" :class="'type-' + item.type">
            <text class="type-text">{{ getTypeText(item.type) }}</text>
          </view>
        </view>
        
        <view class="item-content">
          <text class="item-title">{{ item.title }}</text>
          <text class="item-author" v-if="item.author">作者：{{ item.author }}</text>
          <text class="item-summary" v-if="item.summary">{{ item.summary }}</text>
          
          <view class="item-meta">
            <text class="favorite-time">收藏时间：{{ formatDate(item.favoriteTime) }}</text>
            <text class="view-count" v-if="item.viewCount">{{ item.viewCount }}次浏览</text>
          </view>
          
          <view class="item-actions">
            <button class="unfavorite-btn" @click.stop="unfavorite(item)">取消收藏</button>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">{{ getEmptyIcon() }}</text>
      <text class="empty-text">{{ getEmptyText() }}</text>
      <text class="empty-desc">{{ getEmptyDesc() }}</text>
      <button class="explore-btn" @click="goToExplore">去发现内容</button>
    </view>
    
    <!-- 加载状态 -->
    <view v-if="loading" class="loading">
      <text class="loading-text">加载中...</text>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { getImageUrl, formatDateTime, getAvatarUrl } from '../../utils/common'

export default {
  data() {
    return {
      loading: false,
      activeTab: 0,
      favoriteList: []
    }
  },
  computed: {
    tabs() {
      return [
        { label: '全部', count: this.favoriteList.length, type: 'all' },
        { label: '新闻', count: this.favoriteList.filter(item => item.type === 'news').length, type: 'news' },
        { label: '课程', count: this.favoriteList.filter(item => item.type === 'course').length, type: 'course' },
        { label: '会议', count: this.favoriteList.filter(item => item.type === 'meeting').length, type: 'meeting' }
      ]
    },
    currentList() {
      if (this.activeTab === 0) {
        return this.favoriteList
      } else {
        const currentType = this.tabs[this.activeTab].type
        return this.favoriteList.filter(item => item.type === currentType)
      }
    }
  },
  onLoad() {
    this.loadFavorites()
  },
  onShow() {
    this.loadFavorites()
  },
  methods: {
    async loadFavorites() {
      this.loading = true
      try {
        console.log('开始加载我的收藏列表')
        const response = await api.getMyFavorites()
        console.log('我的收藏数据响应:', response)
        
        if (response && response.code === 200 && response.data) {
          const favoriteData = Array.isArray(response.data) ? response.data : (response.data.records || [])
          this.favoriteList = favoriteData
          console.log('成功加载收藏列表，数量:', this.favoriteList.length)
        } else {
          console.log('收藏数据格式不正确或为空:', response)
          this.favoriteList = []
        }
      } catch (error) {
        console.error('获取收藏列表失败:', error)
        // 如果是未登录错误，不显示错误提示，让request.js处理
        if (error.message !== '未登录') {
          uni.showToast({
            title: '获取收藏列表失败',
            icon: 'none'
          })
        }
        this.favoriteList = []
      } finally {
        this.loading = false
      }
    },
    
    switchTab(tabIndex) {
      this.activeTab = tabIndex
      console.log('切换到标签:', tabIndex, this.tabs[tabIndex])
    },
    
    getImageUrl(coverImage) {
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
    
    getTypeText(type) {
      const typeMap = {
        'news': '新闻',
        'course': '课程',
        'meeting': '会议'
      }
      return typeMap[type] || '未知'
    },
    
    getTypeIcon(type) {
      const iconMap = {
        'news': '📰',
        'course': '📚',
        'meeting': '🤝'
      }
      return iconMap[type] || '📄'
    },
    
    goToDetail(item) {
      let url = ''
      switch (item.type) {
        case 'news':
          url = `/pages/news/detail?id=${item.id}`
          break
        case 'course':
          url = `/pages/course/detail?id=${item.id}`
          break
        case 'meeting':
          url = `/pages/meeting/detail?id=${item.id}`
          break
        default:
          uni.showToast({
            title: '未知类型',
            icon: 'none'
          })
          return
      }
      
      uni.navigateTo({
        url: url
      })
    },
    
    unfavorite(item) {
      uni.showModal({
        title: '取消收藏',
        content: `确定要取消收藏《${item.title}》吗？`,
        success: (res) => {
          if (res.confirm) {
            // 从列表中移除
            const index = this.favoriteList.findIndex(f => f.id === item.id && f.type === item.type)
            if (index > -1) {
              this.favoriteList.splice(index, 1)
              uni.showToast({
                title: '已取消收藏',
                icon: 'success'
              })
            }
          }
        }
      })
    },
    
    getEmptyIcon() {
      if (this.activeTab === 0) return '❤️'
      const currentType = this.tabs[this.activeTab].type
      return this.getTypeIcon(currentType)
    },
    
    getEmptyText() {
      if (this.activeTab === 0) return '还没有收藏任何内容'
      const currentType = this.tabs[this.activeTab].type
      const typeMap = {
        'news': '还没有收藏任何新闻',
        'course': '还没有收藏任何课程',
        'meeting': '还没有收藏任何会议'
      }
      return typeMap[currentType] || '暂无收藏内容'
    },
    
    getEmptyDesc() {
      if (this.activeTab === 0) return '去发现更多精彩内容吧'
      const currentType = this.tabs[this.activeTab].type
      const typeMap = {
        'news': '去浏览更多新闻动态',
        'course': '去发现更多精彩课程',
        'meeting': '去参加更多精彩会议'
      }
      return typeMap[currentType] || '去发现更多内容'
    },
    
    goToExplore() {
      if (this.activeTab === 0) {
        uni.switchTab({
          url: '/pages/index/index'
        })
      } else {
        const currentType = this.tabs[this.activeTab].type
        const urlMap = {
          'news': '/pages/news/news',
          'course': '/pages/course/course',
          'meeting': '/pages/meeting/meeting'
        }
        const targetUrl = urlMap[currentType]
        if (targetUrl) {
          uni.switchTab({
            url: targetUrl
          })
        }
      }
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

.category-tabs {
  display: flex;
  background-color: white;
  border-radius: 12rpx;
  padding: 10rpx;
  margin-bottom: 30rpx;
}

.tab-item {
  flex: 1;
  text-align: center;
  padding: 20rpx 10rpx;
  border-radius: 8rpx;
  transition: all 0.3s ease;
}

.tab-item.active {
  background-color: #007aff;
}

.tab-text {
  font-size: 28rpx;
  color: #666;
  display: block;
  margin-bottom: 4rpx;
}

.tab-item.active .tab-text {
  color: white;
}

.tab-count {
  font-size: 22rpx;
  color: #999;
}

.tab-item.active .tab-count {
  color: rgba(255, 255, 255, 0.8);
}

.favorite-list {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
}

.favorite-item {
  display: flex;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.favorite-item:last-child {
  border-bottom: none;
}

.item-image-container {
  position: relative;
  width: 120rpx;
  height: 120rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.item-image {
  width: 100%;
  height: 100%;
  border-radius: 8rpx;
}

.item-image-placeholder {
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

.type-tag {
  position: absolute;
  top: 0;
  right: 0;
  padding: 4rpx 8rpx;
  border-radius: 0 8rpx 0 8rpx;
}

.type-news {
  background-color: #fa8c16;
}

.type-course {
  background-color: #52c41a;
}

.type-meeting {
  background-color: #007aff;
}

.type-text {
  font-size: 20rpx;
  color: white;
}

.item-content {
  flex: 1;
}

.item-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
  line-height: 1.4;
}

.item-author {
  font-size: 24rpx;
  color: #666;
  margin-bottom: 10rpx;
  display: block;
}

.item-summary {
  font-size: 26rpx;
  color: #999;
  line-height: 1.4;
  margin-bottom: 15rpx;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.item-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15rpx;
}

.favorite-time {
  font-size: 22rpx;
  color: #999;
}

.view-count {
  font-size: 22rpx;
  color: #999;
}

.item-actions {
  display: flex;
  justify-content: flex-end;
}

.unfavorite-btn {
  padding: 12rpx 24rpx;
  font-size: 24rpx;
  border-radius: 20rpx;
  border: 2rpx solid #ff4757;
  background-color: white;
  color: #ff4757;
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