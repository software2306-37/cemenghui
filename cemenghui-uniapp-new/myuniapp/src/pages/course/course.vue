<template>
  <view class="container">
    <view class="search-container">
      <view class="search-box">
        <input v-model="searchKeyword" class="search-input" placeholder="搜索课程标题、描述..." @confirm="onSearch" />
        <view class="search-btn" @click="onSearch">
          <text>搜索</text>
        </view>
      </view>
    </view>
    <scroll-view
      scroll-y
      style="height: 100vh;"
      refresher-enabled
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresherRefresh"
      @scrolltolower="onReachBottom"
    >
      <!-- 课程列表渲染区域 -->
      <view v-for="item in courseList" :key="item.id" class="course-item" @click="goToDetail(item.id)">
        <!-- 课程封面 -->
        <view class="course-image-container">
          <image v-if="item.coverImage" :src="getImageUrl(item.coverImage)" class="cover-img" mode="aspectFill" @error="onImageError" />
          <view v-else class="course-image-placeholder">
            <text class="placeholder-icon">📚</text>
          </view>
        </view>
        <!-- 课程信息 -->
        <view class="course-content">
          <text class="course-title">{{ item.title || item.courseName }}</text>
          <view class="course-meta">
            <text class="course-author" v-if="item.author">讲师：{{ item.author }}</text>
            <text class="course-author" v-else>讲师：专业讲师</text>
            <text class="course-views">{{ item.viewCount || 0 }}次学习</text>
          </view>
          <view class="course-footer">
            <view class="course-status">
              <text class="status-tag published">精品课程</text>
            </view>
            <view class="course-action">
              <text class="learn-btn">立即学习</text>
            </view>
          </view>
        </view>
      </view>
      <view v-if="loading" class="loading">加载中...</view>
      <view v-if="!hasMore && courseList.length > 0" class="no-more">没有更多了</view>
      <view v-if="!loading && courseList.length === 0" class="empty-state">
        <text class="empty-icon">📚</text>
        <text class="empty-text">暂无技术课程</text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { formatDateTime, getImageUrl } from '../../utils/common'

export default {
  data() {
    return {
      courseList: [],
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
    this.currentPage = 1
    this.hasMore = true
    this.loadCourses()
  },
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.currentPage++
      this.loadCourses()
    }
  },
  onPullDownRefresh() {
    this.currentPage = 1
    this.hasMore = true
    this.loadCourses().then(() => {
      uni.stopPullDownRefresh()
    })
  },
  methods: {
    async loadCourses(isRefresh = false) {
      if (isRefresh) {
        this.currentPage = 1
        this.hasMore = true
      }
      this.loading = true
      try {
        const result = await api.getCourseList({
          current: this.currentPage,
          size: this.pageSize,
          keyword: this.searchKeyword || undefined
        })
        let list = result && result.data && result.data.records ? result.data.records : []
        // 只展示已发布课程
        list = list.filter(item => item.status === 1)
        if (this.currentPage === 1) {
          this.courseList = list
        } else {
          this.courseList = [...this.courseList, ...list]
        }
        // 修正分页逻辑：只要累计已加载数量 < total 就继续加载
        const total = result && result.data && result.data.total ? result.data.total : 0
        this.hasMore = this.courseList.length < total
      } catch (e) {
        this.hasMore = false
      } finally {
        this.loading = false
        if (this.refreshing) {
          this.refreshing = false
        }
      }
    },
    
    async loadMore() {
      if (this.loading || !this.hasMore) return
      this.currentPage++
      await this.loadCourses()
    },
    
    goToDetail(id) {
      if (!id) {
        uni.showToast({
          title: '课程不存在',
          icon: 'none'
        })
        return
      }
      
      uni.navigateTo({
        url: `/pages/course/detail?id=${id}`
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
      this.currentPage = 1
      this.hasMore = true
      this.loadCourses()
    },

    clearSearch() {
      this.searchKeyword = ''
      this.refreshData()
    },

    // 刷新相关方法
    async refreshData() {
      this.currentPage = 1
      this.courseList = []
      this.hasMore = true
      this.refreshing = true
      
      try {
        await this.loadCourses()
      } finally {
        this.refreshing = false
        uni.stopPullDownRefresh()
      }
    },
    
    getImageUrl(imageUrl) {
      return getImageUrl(imageUrl)
    },
    
    onImageError(e) {
      console.log('课程封面加载失败:', e)
    },
    
    getStatusText(status) {
      const statusMap = {
        0: '待审核',
        1: '已发布',
        2: '已拒绝'
      }
      return statusMap[status] || '未知'
    },

    onRefresherRefresh() {
      this.refreshing = true
      this.loadCourses(true)
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

.course-list {
  height: calc(100vh - 200rpx);
}

.course-item {
  background-color: white;
  margin-bottom: 20rpx;
  border-radius: 12rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.course-item:active {
  transform: scale(0.98);
  background-color: #f9f9f9;
}

.course-image-container {
  /* 不要overflow:hidden，避免图片被裁剪 */
  padding: 0;
  margin: 0;
  background: none;
}

.course-image {
  width: 100%;
  height: 100%;
}

.course-image-placeholder {
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

.course-content {
  padding: 30rpx;
}

.course-title {
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

.course-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.course-author {
  font-size: 26rpx;
  color: #666;
}

.course-views {
  font-size: 24rpx;
  color: #999;
}

.course-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.course-status {
  display: flex;
  align-items: center;
}

.status-tag {
  font-size: 22rpx;
  padding: 6rpx 12rpx;
  border-radius: 12rpx;
  color: white;
}

.status-tag.published {
  background-color: #52c41a;
}

.course-action {
  display: flex;
  align-items: center;
}

.learn-btn {
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

.cover-img {
  width: 100%;
  height: 320rpx;
  border-radius: 48rpx;
  object-fit: contain;
  background: #f6f8fa;
  display: block;
}
</style> 