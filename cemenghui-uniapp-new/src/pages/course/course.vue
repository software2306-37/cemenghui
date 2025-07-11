<template>
  <view class="container">
    <view class="header">
      <text class="title">技术课程</text>
    </view>
    
    <!-- 课程列表 -->
    <scroll-view v-if="courseList.length > 0" scroll-y="true" class="course-list">
      <view class="course-item" v-for="item in courseList" :key="item.id" @click="goToDetail(item.id)">
        <!-- 课程封面 -->
        <view class="course-image-container">
          <image v-if="item.coverImage" 
                 :src="getImageUrl(item.coverImage)" 
                 class="course-image" 
                 mode="aspectFill"
                 @error="onImageError"></image>
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
      
      <!-- 加载更多 -->
      <view v-if="hasMore && !loading" class="load-more" @click="loadMore">
        <text class="load-more-text">点击加载更多课程</text>
      </view>
    </scroll-view>
    
    <!-- 空状态 -->
    <view v-else-if="!loading" class="empty-state">
      <text class="empty-icon">📚</text>
      <text class="empty-text">暂无技术课程</text>
      <text class="empty-desc">敬请期待精彩课程</text>
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
      courseList: [],
      loading: false,
      currentPage: 1,
      pageSize: 10,
      hasMore: true
    }
  },
  onLoad() {
    this.loadCourses()
  },
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.loadMore()
    }
  },
  onPullDownRefresh() {
    this.currentPage = 1
    this.courseList = []
    this.hasMore = true
    this.loadCourses().then(() => {
      uni.stopPullDownRefresh()
    })
  },
  methods: {
    async loadCourses() {
      if (this.loading) return
      
      this.loading = true
      try {
        console.log('加载课程列表，页码:', this.currentPage)
        
        const params = {
          current: this.currentPage,
          size: this.pageSize,
          status: 1  // 只获取已发布的课程 (status = 1)
        }
        
        const result = await api.getCourseList(params)
        console.log('课程列表API响应:', result)
        
        const coursesData = result && result.data && result.data.records ? result.data.records : []
        if (coursesData.length > 0) {
          // 过滤确保只显示已发布的内容
          const publishedCourses = coursesData.filter(item => item.status === 1)
          
          if (this.currentPage === 1) {
            this.courseList = publishedCourses
          } else {
            this.courseList = [...this.courseList, ...publishedCourses]
          }
          
          this.hasMore = publishedCourses.length === this.pageSize && this.courseList.length < (result.data.total || 0)
          
          console.log('已发布课程数量:', publishedCourses.length)
          console.log('总课程数量:', this.courseList.length)
        } else {
          this.courseList = []
          this.hasMore = false
        }
      } catch (error) {
        console.error('加载课程失败:', error)
        uni.showToast({
          title: '加载失败，请重试',
          icon: 'none'
        })
        
        // 如果是第一页加载失败，设置空数组
        if (this.currentPage === 1) {
          this.courseList = []
        }
        this.hasMore = false
      } finally {
        this.loading = false
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
  width: 100%;
  height: 200rpx;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
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
</style> 