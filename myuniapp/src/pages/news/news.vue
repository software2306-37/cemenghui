<template>
  <view class="container">
    <view class="header">
      <!-- 搜索框 -->
      <view class="search-container">
        <view class="search-box">
          <input 
            v-model="searchKeyword" 
            placeholder="搜索动态标题、简介、作者..." 
            class="search-input"
            confirm-type="search"
            @confirm="onSearch"
          />
          <view class="search-btn" @click="onSearch">
            <text>搜索</text>
          </view>
        </view>
        <view v-if="searchKeyword" class="search-actions">
          <text class="clear-search" @click="clearSearch">清除搜索</text>
        </view>
      </view>
    </view>
    
    <!-- 新闻列表 -->
    <scroll-view 
      v-if="newsList.length > 0" 
      scroll-y="true" 
      class="news-list"
      refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onReachBottom"
      lower-threshold="100"
    >
      <view class="news-item" v-for="item in newsList" :key="item.id" @click="goToDetail(item.id)">
        <!-- 新闻图片区域 -->
        <view class="news-image-container">
          <image v-if="item.coverImage" 
                 :src="getImageUrl(item.coverImage)" 
                 class="news-image" 
                 mode="aspectFill"
                 @error="onImageError"
                 @load="onImageLoad"></image>
          <view v-else class="news-image-placeholder">
            <text class="placeholder-icon">📰</text>
          </view>
        </view>
        
        <!-- 新闻内容区域 -->
        <view class="news-content">
          <text class="news-title">{{ item.title }}</text>
          <text class="news-summary" v-if="item.summary">{{ item.summary }}</text>
          <text class="news-summary no-summary" v-else>暂无摘要</text>
          
          <view class="news-meta">
            <text class="news-author" v-if="item.author">{{ item.author }}</text>
            <text class="news-author" v-else>佚名</text>
            <text v-if="item.publisherCompany" class="news-publisher">{{ item.publisherCompany }}</text>
            <text class="news-time">{{ formatDateTime(item.createTime, 'MM-DD HH:mm') }}</text>
            <text class="news-views">{{ item.viewCount || 0 }}次浏览</text>
          </view>
          
          <!-- 发布状态标识 -->
          <view class="news-status">
            <text class="status-tag published">已发布</text>
          </view>
        </view>
      </view>
      
      <!-- 加载更多 -->
      <view v-if="hasMore && !loading" class="load-more" @click="loadMore">
        <text class="load-more-text">点击加载更多</text>
      </view>
    </scroll-view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">📰</text>
      <text class="empty-text">暂无已发布的动态</text>
      <text class="empty-desc">敬请期待精彩内容</text>
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
      newsList: [],
      loading: false,
      currentPage: 1,
      pageSize: 10,
      hasMore: true,
      searchKeyword: '',
      searchTimer: null,
      refreshing: false
    }
  },
  onLoad() {
    this.loadNews()
  },
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.loadMore()
    }
  },
  onPullDownRefresh() {
    this.refreshData()
  },
  methods: {
    async loadNews() {
      if (this.loading) return
      
      this.loading = true
      try {
        console.log('加载新闻列表，页码:', this.currentPage)
        
        const params = {
          current: this.currentPage,
          size: this.pageSize,
          status: 1,  // 只获取已发布的新闻 (status = 1)
          keyword: this.searchKeyword || undefined  // 添加搜索关键词
        }
        
        const result = await api.getNewsList(params)
        console.log('新闻列表API响应:', result)
        
        const newsData = result && result.data && result.data.records ? result.data.records : []
        if (newsData.length > 0) {
          // 过滤确保只显示已发布的内容
          const publishedNews = newsData.filter(item => item.status === 1)
          
          if (this.currentPage === 1) {
            this.newsList = publishedNews
          } else {
            this.newsList = [...this.newsList, ...publishedNews]
          }
          
          this.hasMore = publishedNews.length === this.pageSize && this.newsList.length < (result.data.total || 0)
          
          console.log('已发布新闻数量:', publishedNews.length)
          console.log('总新闻数量:', this.newsList.length)
        } else {
          this.newsList = []
          this.hasMore = false
        }
      } catch (error) {
        console.error('加载新闻失败:', error)
        uni.showToast({
          title: '加载失败，请重试',
          icon: 'none'
        })
        
        // 如果是第一页加载失败，设置空数组
        if (this.currentPage === 1) {
          this.newsList = []
        }
        this.hasMore = false
      } finally {
        this.loading = false
      }
    },
    
    async loadMore() {
      if (this.loading || !this.hasMore) return
      this.currentPage++
      await this.loadNews()
    },
    
    goToDetail(id) {
      if (!id) {
        uni.showToast({
          title: '内容不存在',
          icon: 'none'
        })
        return
      }
      
      uni.navigateTo({
        url: `/pages/news/detail?id=${id}`
      })
    },
    
    formatDateTime(dateStr, format) {
      if (!dateStr) return '未知时间'
      return formatDateTime(dateStr, format || 'YYYY-MM-DD HH:mm')
    },
    
    getImageUrl(coverImage) {
      return getImageUrl(coverImage)
    },
    
    onImageError(e) {
      console.log('图片加载失败:', e)
      // 可以在这里添加更多的错误处理逻辑
    },
    
    onImageLoad(e) {
      console.log('图片加载成功:', e)
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
      console.log('执行搜索，关键词:', this.searchKeyword)
      this.refreshData()
    },

    clearSearch() {
      this.searchKeyword = ''
      this.refreshData()
    },

    // 刷新相关方法
    async refreshData() {
      this.currentPage = 1
      this.newsList = []
      this.hasMore = true
      this.refreshing = true
      
      try {
        await this.loadNews()
      } finally {
        this.refreshing = false
        uni.stopPullDownRefresh()
      }
    },

    async onRefresh() {
      await this.refreshData()
    },

    onReachBottom() {
      if (this.hasMore && !this.loading) {
        this.loadMore()
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
  margin-bottom: 30rpx;
  padding: 20rpx 0;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.search-container {
  margin: 16rpx 0 24rpx 0;
  padding: 0 20rpx;
}

.search-box {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 30rpx;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.08);
  border: 1rpx solid #e0e0e0;
  padding: 0 18rpx;
  height: 60rpx;
}

.search-input {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 28rpx;
  color: #333;
  height: 60rpx;
  line-height: 60rpx;
  outline: none;
}

.search-icon {
  font-size: 32rpx;
  color: #999;
  margin-left: 10rpx;
  cursor: pointer;
}

.search-btn {
  width: auto;
  min-width: 100rpx;
  height: 48rpx;
  margin-left: 10rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #2f80ed;
  border-radius: 32rpx;
  color: #fff;
  font-size: 30rpx;
  font-weight: bold;
  padding: 0 36rpx;
  cursor: pointer;
  transition: background 0.2s;
}
.search-btn:active {
  background: #1761c6;
}

.search-actions {
  display: flex;
  justify-content: center;
  margin-bottom: 10rpx;
}

.clear-search {
  font-size: 24rpx;
  color: #007aff;
  padding: 5rpx 10rpx;
  cursor: pointer;
}

.news-list {
  height: calc(100vh - 200rpx);
}

.news-item {
  background-color: white;
  margin-bottom: 20rpx;
  padding: 30rpx;
  border-radius: 12rpx;
  display: flex;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.news-item:active {
  transform: scale(0.98);
  background-color: #f9f9f9;
}

.news-image-container {
  width: 150rpx;
  height: 120rpx;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.news-image {
  width: 100%;
  height: 100%;
  border-radius: 8rpx;
}

.news-image-placeholder {
  width: 100%;
  height: 100%;
  background-color: #f5f5f5;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-icon {
  font-size: 40rpx;
  opacity: 0.5;
}

.news-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.news-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  margin-bottom: 10rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.news-summary {
  font-size: 26rpx;
  color: #666;
  line-height: 1.5;
  margin-bottom: 15rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.news-summary.no-summary {
  color: #999;
  font-style: italic;
}

.news-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 8rpx;
  margin-bottom: 10rpx;
}

.news-author {
  font-size: 24rpx;
  color: #666;
}

.news-publisher {
  font-size: 24rpx;
  color: #007aff;
  font-weight: 500;
}

.news-time {
  font-size: 24rpx;
  color: #999;
}

.news-views {
  font-size: 24rpx;
  color: #999;
}

.news-status {
  display: flex;
  justify-content: flex-end;
}

.status-tag {
  font-size: 20rpx;
  padding: 4rpx 8rpx;
  border-radius: 10rpx;
  color: white;
}

.status-tag.published {
  background-color: #52c41a;
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