<template>
  <view class="container">
    <view v-if="courseDetail" class="detail-content">
      <!-- 课程封面 -->
      <view class="image-container">
        <image v-if="courseDetail.coverImage" :src="getImageUrl(courseDetail.coverImage)" class="course-image" mode="aspectFill" @error="onImageError"></image>
        <view v-else class="image-placeholder">
          <text class="placeholder-icon">📚</text>
          <text class="placeholder-text">暂无课程封面</text>
        </view>
      </view>
      
      <view class="course-info">
        <text class="title">{{ courseDetail.title || courseDetail.courseName }}</text>
        <text class="description" v-if="courseDetail.description || courseDetail.courseSummary">{{ courseDetail.description || courseDetail.courseSummary }}</text>
        <text class="no-description" v-else>暂无课程描述</text>
        
        <view class="meta-info">
          <view class="meta-item" v-if="courseDetail.author">
            <text class="meta-label">讲师：</text>
            <text class="meta-value">{{ courseDetail.author }}</text>
          </view>
          <view class="meta-item">
            <text class="meta-label">浏览量：</text>
            <text class="meta-value">{{ courseDetail.viewCount || 0 }}次</text>
          </view>
          <view class="meta-item">
            <text class="meta-label">状态：</text>
            <text class="meta-value">{{ getStatusText(courseDetail.status) }}</text>
          </view>
          <view class="meta-item" v-if="courseDetail.createTime">
            <text class="meta-label">发布时间：</text>
            <text class="meta-value">{{ formatDateTime(courseDetail.createTime) }}</text>
          </view>
        </view>
      </view>
      
      <!-- 课程内容 -->
      <view class="course-content">
        <view class="section-title">课程详情</view>
        <view v-if="courseDetail.content || courseDetail.description || courseDetail.courseSummary" class="content">
          <rich-text :nodes="formatContent(courseDetail.content || courseDetail.description || courseDetail.courseSummary)"></rich-text>
        </view>
        <view v-else class="no-content">
          <text class="no-content-text">暂无详细内容</text>
        </view>
      </view>
      
      <!-- 视频播放区域 -->
      <view class="video-section">
        <view class="section-title">课程视频</view>
        <view v-if="courseDetail.videoUrl" class="video-container">
          <video :src="getVideoUrl(courseDetail.videoUrl)" class="preview-video" controls @error="onVideoError"></video>
        </view>
        <view v-else class="video-placeholder">
          <text class="placeholder-icon">🎥</text>
          <text class="placeholder-text">暂无课程视频</text>
        </view>
      </view>
      
      <!-- 操作按钮 -->
      <view class="action-section">
        <button class="enroll-btn" @click="enrollCourse">开始学习</button>
        <button class="favorite-btn" @click="toggleFavorite">{{ isFavorite ? '取消收藏' : '收藏课程' }}</button>
      </view>
    </view>
    
    <view v-if="loading" class="loading">
      <text class="loading-text">加载中...</text>
    </view>
    
    <view v-if="!courseDetail && !loading" class="empty">
      <text class="empty-icon">📚</text>
      <text class="empty-text">课程不存在或已被删除</text>
      <button class="back-btn" @click="goBack">返回列表</button>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { getImageUrl, formatDateTime } from '../../utils/common'

export default {
  data() {
    return {
      courseDetail: null,
      loading: false,
      courseId: null,
      isFavorite: false
    }
  },
  onLoad(options) {
    console.log('课程详情页参数:', options)
    if (options.id) {
      this.courseId = options.id
      this.loadCourseDetail()
    } else {
      uni.showToast({
        title: '参数错误',
        icon: 'none'
      })
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    }
  },
  methods: {
    async loadCourseDetail() {
      this.loading = true
      try {
        console.log('加载课程详情，ID:', this.courseId)
        const result = await api.getCourseDetail(this.courseId)
        
        console.log('课程详情API响应:', result)
        
        if (result && result.data) {
          this.courseDetail = result.data
          console.log('课程详情数据:', this.courseDetail)
        } else if (result) {
          // 有些API直接返回数据，没有包装在data中
          this.courseDetail = result
          console.log('课程详情数据（直接）:', this.courseDetail)
        } else {
          console.log('课程详情为空，显示错误')
          this.courseDetail = null
        }
      } catch (error) {
        console.error('获取课程详情失败:', error)
        this.courseDetail = null
        uni.showToast({
          title: '加载失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    async enrollCourse() {
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
        title: '开始学习',
        content: `确定要开始学习课程"${this.courseDetail.title || this.courseDetail.courseName}"吗？`,
        success: (res) => {
          if (res.confirm) {
            uni.showToast({
              title: '开始学习！',
              icon: 'success'
            })
            // 这里可以跳转到学习页面或播放视频
          }
        }
      })
    },
    
    async toggleFavorite() {
      const userInfo = uni.getStorageSync('userInfo')
      if (!userInfo || !userInfo.id) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        return
      }
      
      // 切换收藏状态
      this.isFavorite = !this.isFavorite
      
      uni.showToast({
        title: this.isFavorite ? '收藏成功' : '已取消收藏',
        icon: 'success'
      })
    },
    
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '未知时间'
      return formatDateTime(dateTimeStr, 'YYYY-MM-DD')
    },
    
    formatContent(content) {
      if (!content) return ''
      // 如果content是纯文本，转换为简单的HTML
      if (typeof content === 'string' && !content.includes('<')) {
        return content.split('\n').map(line => `<p>${line}</p>`).join('')
      }
      return content
    },
    
    getImageUrl(imagePath) {
      return getImageUrl(imagePath)
    },
    
    getVideoUrl(videoPath) {
      if (!videoPath) return ''
      
      // 如果已经是完整URL，直接返回
      if (videoPath.startsWith('http://') || videoPath.startsWith('https://')) {
        return videoPath
      }
      
      // 拼接基础URL
      if (videoPath.startsWith('/uploads/')) {
        return 'http://localhost:8080/api' + videoPath
      }
      
      return 'http://localhost:8080/api/uploads/' + videoPath
    },
    
    getStatusText(status) {
      const statusMap = {
        0: '待审核',
        1: '已发布',
        2: '已拒绝'
      }
      return statusMap[status] || '未知'
    },
    
    onImageError(e) {
      console.log('图片加载失败:', e)
    },
    
    onVideoError(e) {
      console.log('视频加载失败:', e)
      uni.showToast({
        title: '视频加载失败',
        icon: 'none'
      })
    },
    
    goBack() {
      uni.navigateBack()
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

.image-container {
  width: 100%;
  height: 400rpx;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.course-image {
  width: 100%;
  height: 100%;
}

.image-placeholder {
  text-align: center;
}

.placeholder-icon {
  font-size: 80rpx;
  display: block;
  margin-bottom: 10rpx;
  opacity: 0.5;
}

.placeholder-text {
  font-size: 24rpx;
  color: #999;
}

.course-info {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 15rpx;
  display: block;
  line-height: 1.4;
}

.description {
  font-size: 28rpx;
  color: #666;
  line-height: 1.5;
  margin-bottom: 25rpx;
  display: block;
}

.no-description {
  font-size: 26rpx;
  color: #999;
  margin-bottom: 25rpx;
  display: block;
  font-style: italic;
}

.meta-info {
  margin-bottom: 25rpx;
}

.meta-item {
  display: flex;
  margin-bottom: 10rpx;
  align-items: center;
}

.meta-label {
  font-size: 26rpx;
  color: #999;
  width: 140rpx;
  flex-shrink: 0;
}

.meta-value {
  font-size: 26rpx;
  color: #333;
  flex: 1;
}

.course-content, .video-section {
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

.no-content {
  text-align: center;
  padding: 40rpx;
}

.no-content-text {
  font-size: 26rpx;
  color: #999;
}

.video-container {
  width: 100%;
}

.preview-video {
  width: 100%;
  height: 400rpx;
  border-radius: 8rpx;
}

.video-placeholder {
  text-align: center;
  padding: 80rpx 40rpx;
  background-color: #f8f8f8;
  border-radius: 8rpx;
}

.action-section {
  padding: 30rpx;
  display: flex;
  gap: 20rpx;
}

.enroll-btn {
  flex: 2;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 30rpx;
  border: none;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.favorite-btn {
  flex: 1;
  height: 80rpx;
  background-color: #f8f8f8;
  color: #333;
  font-size: 26rpx;
  border: 1rpx solid #ddd;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.loading {
  text-align: center;
  padding: 100rpx;
}

.loading-text {
  font-size: 28rpx;
  color: #999;
}

.empty {
  text-align: center;
  padding: 100rpx 40rpx;
}

.empty-icon {
  font-size: 80rpx;
  display: block;
  margin-bottom: 20rpx;
  opacity: 0.5;
}

.empty-text {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 40rpx;
  display: block;
}

.back-btn {
  width: 200rpx;
  height: 60rpx;
  background-color: #007aff;
  color: white;
  font-size: 26rpx;
  border: none;
  border-radius: 30rpx;
  line-height: 60rpx;
}
</style> 