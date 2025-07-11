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
          <view class="meta-item" v-if="courseDetail.status !== undefined && courseDetail.status !== null">
            <text class="meta-label">状态：</text>
            <text class="meta-value">{{ statusText }}</text>
          </view>
          <view class="meta-item" v-if="courseDetail.createTime">
            <text class="meta-label">发布时间：</text>
            <text class="meta-value">{{ formatTime }}</text>
          </view>
        </view>
      </view>
      
      <!-- 课程内容 -->
      <view class="course-content">
        <view class="section-title">课程详情</view>
        <view v-if="courseDetail.content || courseDetail.description || courseDetail.courseSummary" class="content">
          <rich-text :nodes="formattedContent"></rich-text>
        </view>
        <view v-else class="no-content">
          <text class="no-content-text">暂无详细内容</text>
        </view>
      </view>
      
      <!-- 视频列表 -->
      <view class="video-section">
        <view class="section-title">课程视频</view>
        <view v-if="courseVideos.length > 0" class="video-list">
          <view v-for="(video, index) in courseVideos" :key="video.id" class="video-item" @click="playVideo(video, index)">
            <view class="video-info">
              <text class="video-title">{{ video.title }}</text>
              <view class="video-meta">
                <text class="video-duration">{{ video.formattedDuration }}</text>
                <text v-if="video.isFree" class="video-free">免费</text>
                <text v-else class="video-paid">付费</text>
                <text v-if="video.isCompleted" class="video-completed">已完成</text>
                <text v-else-if="video.watchPercentage > 0" class="video-progress">{{ Math.round(video.watchPercentage) }}%</text>
              </view>
              <view v-if="video.description" class="video-description">{{ video.description }}</view>
            </view>
            <view class="video-play-icon">▶</view>
          </view>
        </view>
        <view v-else class="video-placeholder">
          <text class="placeholder-icon">🎥</text>
          <text class="placeholder-text">暂无课程视频</text>
        </view>
      </view>
      
      <!-- 学习进度 -->
      <view v-if="enrollmentInfo && enrollmentInfo.isEnrolled" class="progress-section">
        <view class="section-title">学习进度</view>
        <view class="progress-bar">
          <view class="progress-fill" :style="{width: (enrollmentInfo.progress || 0) + '%'}"></view>
        </view>
        <text class="progress-text">{{ enrollmentInfo.progress || 0 }}%</text>
      </view>

      <!-- 操作按钮 -->
      <view class="action-section">
        <button 
          :class="'enroll-btn ' + actionButtonClass"
          @click="handleMainAction"
          :disabled="isActionLoading">
          {{ actionButtonText }}
        </button>
        <button 
          :class="'favorite-btn' + (favoriteStatus ? ' favorited' : '')"
          @click="toggleFavorite"
          :disabled="isActionLoading">
          {{ favoriteButtonText }}
        </button>
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
      courseVideos: [],
      loading: false,
      courseId: null,
      enrollmentInfo: null,
      isActionLoading: false
    }
  },
  
  computed: {
    actionButtonText() {
      if (!this.enrollmentInfo) {
        return '报名学习'
      }
      
      if (!this.enrollmentInfo.isEnrolled) {
        return '报名学习'
      }
      
      switch (this.enrollmentInfo.learningStatus) {
        case 0:
          return '开始学习'
        case 1:
          return '继续学习'
        case 2:
          return '重新学习'
        default:
          return '开始学习'
      }
    },
    
    actionButtonClass() {
      if (!this.enrollmentInfo || !this.enrollmentInfo.isEnrolled) {
        return 'enroll'
      }
      
      switch (this.enrollmentInfo.learningStatus) {
        case 0:
          return 'start'
        case 1:
          return 'continue'
        case 2:
          return 'restart'
        default:
          return 'start'
      }
    },
    
    favoriteStatus() {
      return this.enrollmentInfo && this.enrollmentInfo.isFavorited
    },
    
    favoriteButtonText() {
      if (this.enrollmentInfo && this.enrollmentInfo.isFavorited) {
        return '已收藏'
      }
      return '收藏课程'
    },
    
    statusText() {
      if (!this.courseDetail || this.courseDetail.status === undefined || this.courseDetail.status === null) {
        return '未知'
      }
      const statusMap = {
        0: '待审核',
        1: '已发布',
        2: '已拒绝'
      }
      return statusMap[this.courseDetail.status] || '未知'
    },
    
    formatTime() {
      if (!this.courseDetail || !this.courseDetail.createTime) {
        return '未知时间'
      }
      return formatDateTime(this.courseDetail.createTime, 'YYYY-MM-DD')
    },
    
    formattedContent() {
      if (!this.courseDetail) return ''
      const content = this.courseDetail.content || this.courseDetail.description || this.courseDetail.courseSummary
      if (!content) return ''
      // 如果content是纯文本，转换为简单的HTML
      if (typeof content === 'string' && !content.includes('<')) {
        return content.split('\n').map(line => `<p>${line}</p>`).join('')
      }
      return content
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
  
  onShow() {
    // 页面显示时重新加载数据，确保状态同步
    if (this.courseId) {
      console.log('页面重新显示，刷新课程详情')
      this.loadCourseDetail()
    }
  },
  methods: {
    async loadCourseDetail() {
      this.loading = true
      try {
        console.log('加载课程详情，ID:', this.courseId)
        
        // 先尝试获取带学习状态的课程详情，如果失败则获取基础详情
        let result;
        try {
          result = await api.getCourseDetailWithStatus(this.courseId)
        } catch (statusError) {
          console.warn('获取学习状态失败，使用基础详情:', statusError)
          result = await api.getCourseDetail(this.courseId)
        }
        
        console.log('课程详情API响应:', result)
        
        if (result && result.data) {
          // 处理带学习状态的响应
          if (result.data.course) {
            this.courseDetail = result.data.course
            this.enrollmentInfo = {
              isEnrolled: result.data.isEnrolled || false,
              progress: result.data.progress || 0,
              learningStatus: result.data.learningStatus || -1,
              isFavorited: result.data.isFavorited || false,
              enrollment: result.data.enrollment
            }
          } else {
            // 处理基础课程详情响应
            this.courseDetail = result.data
            this.enrollmentInfo = {
              isEnrolled: false,
              progress: 0,
              learningStatus: -1,
              isFavorited: false,
              enrollment: null
            }
          }
          console.log('课程详情数据:', this.courseDetail)
          console.log('学习状态数据:', this.enrollmentInfo)
        } else if (result) {
          // 直接返回课程数据的情况
          this.courseDetail = result
          this.enrollmentInfo = {
            isEnrolled: false,
            progress: 0,
            learningStatus: -1,
            isFavorited: false,
            enrollment: null
          }
          console.log('课程详情数据（直接）:', this.courseDetail)
        } else {
          console.log('课程详情为空，显示错误')
          this.courseDetail = null
          this.enrollmentInfo = null
        }
        
        // 加载课程视频列表
        if (this.courseDetail) {
          await this.loadCourseVideos()
          // 重新计算视频权限
          this.updateVideoPermissions()
        }
      } catch (error) {
        console.error('获取课程详情失败:', error)
        this.courseDetail = null
        this.enrollmentInfo = null
        uni.showToast({
          title: '加载失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    async handleMainAction() {
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
      
      if (this.isActionLoading) return
      
      this.isActionLoading = true
      
      try {
        if (!this.enrollmentInfo || !this.enrollmentInfo.isEnrolled) {
          // 未报名 - 进行报名
          await this.enrollCourse()
        } else if (this.enrollmentInfo.learningStatus === 0) {
          // 已报名但未开始 - 开始学习
          await this.startLearning()
        } else if (this.enrollmentInfo.learningStatus === 1) {
          // 学习中 - 继续学习
          await this.continueLearning()
        } else if (this.enrollmentInfo.learningStatus === 2) {
          // 已完成 - 重新学习
          await this.restartLearning()
        }
      } catch (error) {
        console.error('操作失败:', error)
      } finally {
        this.isActionLoading = false
      }
    },
    
    async enrollCourse() {
      try {
        const result = await api.enrollCourse(this.courseId)
        if (result.code === 200) {
          uni.showToast({
            title: '报名成功',
            icon: 'success'
          })
          // 重新加载课程详情，这会自动更新视频权限
          await this.loadCourseDetail()
        } else {
          uni.showToast({
            title: result.message || '报名失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('报名失败:', error)
        uni.showToast({
          title: '报名失败，请重试',
          icon: 'none'
        })
      }
    },
    
    async startLearning() {
      try {
        const result = await api.startLearning(this.courseId)
        if (result.code === 200) {
          uni.showToast({
            title: '开始学习',
            icon: 'success'
          })
          // 模拟学习进度
          await this.simulateLearning()
          // 重新加载课程详情
          await this.loadCourseDetail()
        } else {
          uni.showToast({
            title: result.message || '开始学习失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('开始学习失败:', error)
        uni.showToast({
          title: '开始学习失败，请重试',
          icon: 'none'
        })
      }
    },
    
    async continueLearning() {
      uni.showToast({
        title: '继续学习中...',
        icon: 'loading'
      })
      
      // 模拟学习进度
      await this.simulateLearning()
      
      // 重新加载课程详情
      await this.loadCourseDetail()
    },
    
    async restartLearning() {
      uni.showModal({
        title: '重新学习',
        content: '您已完成该课程，是否重新开始学习？',
        success: async (res) => {
          if (res.confirm) {
            await this.simulateLearning()
            await this.loadCourseDetail()
          }
        }
      })
    },
    
    async simulateLearning() {
      // 模拟学习进度（增加10-30%）
      const currentProgress = this.enrollmentInfo ? this.enrollmentInfo.progress : 0
      const increment = Math.floor(Math.random() * 21) + 10 // 10-30%
      const newProgress = Math.min(100, currentProgress + increment)
      
      try {
        await api.updateProgress(this.courseId, newProgress)
        uni.showToast({
          title: `学习进度：${newProgress}%`,
          icon: 'success'
        })
      } catch (error) {
        console.error('更新进度失败:', error)
      }
    },
    
    async toggleFavorite() {
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
      
      if (this.isActionLoading) return
      
      this.isActionLoading = true
      
      try {
        // 确保enrollmentInfo存在
        if (!this.enrollmentInfo) {
          this.enrollmentInfo = {
            isEnrolled: false,
            progress: 0,
            learningStatus: -1,
            isFavorited: false,
            enrollment: null
          }
        }
        
        if (this.enrollmentInfo.isFavorited) {
          // 取消收藏
          const result = await api.removeFromFavorite(this.courseId)
          console.log('取消收藏结果:', result)
          if (result && (result.code === 200 || result.code === 0)) {
            uni.showToast({
              title: '已取消收藏',
              icon: 'success'
            })
            this.enrollmentInfo.isFavorited = false
          } else {
            uni.showToast({
              title: result.message || '取消收藏失败',
              icon: 'none'
            })
          }
        } else {
          // 添加收藏
          const result = await api.addToFavorite(this.courseId)
          console.log('添加收藏结果:', result)
          if (result && (result.code === 200 || result.code === 0)) {
            uni.showToast({
              title: '收藏成功',
              icon: 'success'
            })
            this.enrollmentInfo.isFavorited = true
          } else {
            uni.showToast({
              title: result.message || '收藏失败',
              icon: 'none'
            })
          }
        }
      } catch (error) {
        console.error('收藏操作失败:', error)
        uni.showToast({
          title: '操作失败，请重试',
          icon: 'none'
        })
      } finally {
        this.isActionLoading = false
      }
    },
    


    
    getImageUrl(imagePath) {
      return getImageUrl(imagePath)
    },
    
    onImageError(e) {
      console.log('图片加载失败:', e)
    },
    
    async loadCourseVideos() {
      try {
        console.log('加载课程视频列表，课程ID:', this.courseId)
        const result = await api.getCourseVideos(this.courseId)
        console.log('课程视频API响应:', result)
        
        if (result && (result.data || result.code === 200)) {
          const videoData = result.data || result
          const videos = Array.isArray(videoData) ? videoData : []
          
          this.courseVideos = videos.map(video => ({
            ...video,
            id: video.id,
            title: video.title || video.videoTitle,
            duration: parseInt(video.duration || video.videoDuration) || 0,
            description: video.description || video.videoDescription,
            videoUrl: video.videoUrl,
            formattedDuration: this.formatDuration(parseInt(video.duration || video.videoDuration) || 0),
            canWatch: this.calculateCanWatch(video),
            isFree: video.isFree === 1 || video.isFree === true,
            isCompleted: video.isCompleted === 1 || video.isCompleted === true,
            watchPercentage: video.watchPercentage || 0
          }))
          console.log('处理后的课程视频列表:', this.courseVideos)
        } else {
          this.courseVideos = []
          console.log('没有找到课程视频数据')
        }
      } catch (error) {
        console.error('加载课程视频失败:', error)
        this.courseVideos = []
      }
    },
    
    formatDuration(seconds) {
      const duration = parseInt(seconds) || 0
      if (duration <= 0) return '00:00'
      const minutes = Math.floor(duration / 60)
      const remainingSeconds = Math.floor(duration % 60)
      return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`
    },

    calculateCanWatch(video) {
      // 首先检查用户是否登录
      const userInfo = uni.getStorageSync('userInfo')
      if (!userInfo || !userInfo.id) {
        return false // 未登录不能观看任何视频
      }

      // 如果是免费视频，登录用户可以观看
      if (video.isFree === 1 || video.isFree === true) {
        return true
      }

      // 付费视频需要检查是否已报名
      return this.enrollmentInfo && this.enrollmentInfo.isEnrolled
    },

    updateVideoPermissions() {
      // 重新计算所有视频的观看权限
      this.courseVideos = this.courseVideos.map(video => ({
        ...video,
        canWatch: this.calculateCanWatch(video)
      }))
      console.log('更新后的视频权限:', this.courseVideos.map(v => ({ id: v.id, title: v.title, isFree: v.isFree, canWatch: v.canWatch })))
    },
    
    playVideo(video, index) {
      console.log('播放视频:', video)
      
      // 首先检查用户是否登录
      const userInfo = uni.getStorageSync('userInfo')
      if (!userInfo || !userInfo.id) {
        uni.showModal({
          title: '提示',
          content: '请先登录才能观看视频',
          showCancel: false,
          success: () => {
            uni.navigateTo({
              url: '/pages/login/login'
            })
          }
        })
        return
      }
      
      // 检查是否可以观看
      if (!video.canWatch) {
        if (video.isFree) {
          uni.showToast({
            title: '视频暂不可用',
            icon: 'none'
          })
        } else {
          uni.showModal({
            title: '提示',
            content: '该视频为付费内容，请先报名课程后观看',
            showCancel: true,
            cancelText: '取消',
            confirmText: '去报名',
            success: (result) => {
              if (result.confirm) {
                this.handleMainAction()
              }
            }
          })
        }
        return
      }
      
      // 跳转到视频播放页面
      const videoUrl = this.getVideoUrl(video.videoUrl)
      uni.navigateTo({
        url: `/pages/course/video-player?videoId=${video.id}&courseId=${this.courseId}&videoUrl=${encodeURIComponent(videoUrl)}&title=${encodeURIComponent(video.title)}`
      })
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
      
      if (videoPath.startsWith('/')) {
        return 'http://localhost:8080/api' + videoPath
      }
      
      return 'http://localhost:8080/api/uploads/' + videoPath
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
}

.progress-section {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.progress-bar {
  width: 100%;
  height: 12rpx;
  background-color: #e0e0e0;
  border-radius: 6rpx;
  margin: 20rpx 0;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #4CAF50, #8BC34A);
  border-radius: 6rpx;
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 26rpx;
  color: #4CAF50;
  font-weight: bold;
  text-align: center;
  display: block;
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

.video-list {
  margin-top: 20rpx;
}

.video-item {
  display: flex;
  align-items: center;
  padding: 25rpx 20rpx;
  border: 2rpx solid #f0f0f0;
  border-radius: 12rpx;
  margin-bottom: 20rpx;
  background-color: #fafafa;
  transition: all 0.3s ease;
}

.video-item:active {
  background-color: #e8f4fd;
  border-color: #409eff;
}

.video-info {
  flex: 1;
  margin-right: 20rpx;
}

.video-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 10rpx;
  display: block;
  line-height: 1.4;
}

.video-meta {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
}

.video-duration {
  font-size: 24rpx;
  color: #666;
  margin-right: 20rpx;
}

.video-free {
  font-size: 22rpx;
  color: #67c23a;
  background-color: #f0f9ff;
  padding: 4rpx 8rpx;
  border-radius: 8rpx;
  margin-right: 15rpx;
}

.video-paid {
  font-size: 22rpx;
  color: #e6a23c;
  background-color: #fdf6ec;
  padding: 4rpx 8rpx;
  border-radius: 8rpx;
  margin-right: 15rpx;
}

.video-completed {
  font-size: 22rpx;
  color: #67c23a;
  background-color: #f0f9ff;
  padding: 4rpx 8rpx;
  border-radius: 8rpx;
  margin-right: 15rpx;
}

.video-progress {
  font-size: 22rpx;
  color: #409eff;
  background-color: #ecf5ff;
  padding: 4rpx 8rpx;
  border-radius: 8rpx;
  margin-right: 15rpx;
}

.video-description {
  font-size: 26rpx;
  color: #999;
  line-height: 1.4;
  margin-top: 8rpx;
}

.video-play-icon {
  font-size: 48rpx;
  color: #409eff;
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background-color: #ecf5ff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 20rpx;
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
  transition: all 0.3s ease;
}

.enroll-btn:disabled {
  opacity: 0.6;
}

.enroll-btn.start {
  background-color: #4CAF50;
}

.enroll-btn.continue {
  background-color: #FF9800;
}

.enroll-btn.restart {
  background-color: #9C27B0;
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
  transition: all 0.3s ease;
}

.favorite-btn:disabled {
  opacity: 0.6;
}

.favorite-btn.favorited {
  background-color: #FF6B6B;
  color: white;
  border-color: #FF6B6B;
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