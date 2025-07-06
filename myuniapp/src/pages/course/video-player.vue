<template>
  <view class="video-player-container">
    <!-- 视频播放器 -->
    <view class="video-wrapper">
      <video 
        :src="videoInfo.videoUrl" 
        :poster="videoInfo.poster"
        controls
        :duration="videoInfo.duration"
        :current-time="currentTime"
        @timeupdate="onTimeUpdate"
        @ended="onVideoEnded"
        @loadedmetadata="onVideoLoaded"
        @error="onVideoError"
        @play="onVideoPlay"
        @pause="onVideoPause"
        class="video-player"
        show-center-play-btn
        show-progress
        show-fullscreen-btn
      >
        <view slot="danmu-btn">
          <text>弹幕</text>
        </view>
      </video>
    </view>

    <!-- 视频信息 -->
    <view class="video-info">
      <view class="video-title">{{ videoInfo.title }}</view>
      <view class="video-meta">
        <text class="duration">时长: {{ formatDuration(videoInfo.duration) }}</text>
        <text class="progress-text">学习进度: {{ Math.round(progress * 100) }}%</text>
      </view>
      <view class="progress-bar">
        <view class="progress-fill" :style="{ width: progress * 100 + '%' }"></view>
      </view>
    </view>

    <!-- 视频描述 -->
    <view class="video-description" v-if="videoInfo.description">
      <view class="section-title">视频介绍</view>
      <view class="description-content">{{ videoInfo.description }}</view>
    </view>

    <!-- 课程其他视频列表 -->
    <view class="course-videos" v-if="courseVideos.length > 1">
      <view class="section-title">课程目录</view>
      <view class="video-list">
        <view 
          v-for="(video, index) in courseVideos" 
          :key="video.id"
          class="video-item"
          :class="{ 'current': video.id == currentVideoId, 'completed': video.isCompleted }"
          @click="switchVideo(video)"
        >
          <view class="video-item-content">
            <view class="video-item-title">{{ video.title }}</view>
            <view class="video-item-meta">
              <text class="video-duration">{{ formatDuration(video.duration) }}</text>
              <text v-if="video.isFree" class="free-tag">免费</text>
              <text v-if="video.isCompleted" class="completed-tag">已完成</text>
            </view>
          </view>
          <view class="video-item-icon">
            <text v-if="video.isCompleted" class="icon-completed">✓</text>
            <text v-else-if="video.id == currentVideoId" class="icon-playing">▶</text>
            <text v-else class="icon-play">▷</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 学习记录 -->
    <view class="study-record">
      <view class="section-title">学习记录</view>
      <view class="record-item" v-if="studyTime > 0">
        <text>本次学习时长：{{ formatStudyTime(studyTime) }}</text>
      </view>
      <view class="record-item" v-if="totalStudyTime > 0">
        <text>总学习时长：{{ formatStudyTime(totalStudyTime) }}</text>
      </view>
      <view class="record-item" v-if="studyTime === 0 && totalStudyTime === 0">
        <text style="color: #999;">点击播放按钮开始观看视频，系统将记录学习时长</text>
      </view>
    </view>
  </view>
</template>

<script>
import { getVideoDetail, updateVideoProgress, getCourseVideos, api } from '@/utils/request.js'

export default {
  data() {
    return {
      videoInfo: {
        id: '',
        title: '',
        videoUrl: '',
        poster: '',
        duration: 0,
        description: ''
      },
      courseId: '',
      currentVideoId: '',
      courseVideos: [],
      currentTime: 0,
      progress: 0,
      studyTime: 0,
      totalStudyTime: 0,
      lastUpdateTime: 0,
      progressTimer: null,
      startTime: 0
    }
  },
  
  onLoad(options) {
    // 首先检查用户登录状态
    if (!this.checkUserLogin()) {
      return
    }
    
    if (options.videoId) {
      this.currentVideoId = options.videoId
    }
    if (options.courseId) {
      this.courseId = options.courseId
    }
    
    // 解码参数
    if (options.videoUrl) {
      const decodedUrl = decodeURIComponent(options.videoUrl)
      this.videoInfo.videoUrl = this.getVideoUrl(decodedUrl)
      console.log('初始化视频URL:', decodedUrl, '=>', this.videoInfo.videoUrl)
    }
    if (options.title) {
      this.videoInfo.title = decodeURIComponent(options.title)
    }
    
    this.loadVideoInfo()
    // 先不启动计时器，等用户实际播放视频时再启动
  },
  
    onUnload() {
    this.saveProgress()
    this.stopStudyTimer()
  },

  onHide() {
    this.saveProgress()
    this.stopStudyTimer()
  },

  onShow() {
    // 页面重新显示时仅重置学习时长，不自动启动计时器
    if (this.currentVideoId) {
      this.studyTime = 0  // 重置本次学习时长
    }
  },
  
    methods: {
    checkUserLogin() {
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
        return false
      }
      return true
    },

    async checkVideoPermission(video) {
      // 如果是免费视频，直接允许观看
      if (video.isFree) {
        return true
      }
      
      // 付费视频需要检查是否已报名课程
      try {
        const res = await api.getCourseDetailWithStatus(this.courseId)
        if (res.code === 200 && res.data.isEnrolled) {
          return true
        } else {
          uni.showModal({
            title: '提示',
            content: '该视频为付费内容，请先报名课程后观看',
            showCancel: true,
            cancelText: '取消',
            confirmText: '去报名',
            success: (result) => {
              if (result.confirm) {
                uni.navigateBack()
              }
            }
          })
          return false
        }
      } catch (error) {
        console.error('检查课程报名状态失败:', error)
        uni.showToast({
          title: '检查权限失败',
          icon: 'none'
        })
        return false
      }
    },

    async loadVideoInfo() {
      // 先加载课程视频列表，再从中找到当前视频
      await this.loadCourseVideos()
      
      if (this.currentVideoId && this.courseVideos.length > 0) {
        const currentVideo = this.courseVideos.find(v => v.id == this.currentVideoId)
        if (currentVideo) {
          // 检查视频观看权限
          const hasPermission = await this.checkVideoPermission(currentVideo)
          if (!hasPermission) {
            return
          }
          
          const videoUrl = this.getVideoUrl(currentVideo.videoUrl) || this.videoInfo.videoUrl
          console.log('设置视频URL:', currentVideo.videoUrl, '=>', videoUrl)
          
          this.videoInfo = {
            ...this.videoInfo,
            id: currentVideo.id,
            title: currentVideo.title || currentVideo.videoTitle,
            duration: parseInt(currentVideo.duration || currentVideo.videoDuration) || 0,
            description: currentVideo.description || currentVideo.videoDescription,
            videoUrl: videoUrl
          }
          
          // 获取学习进度
          this.loadVideoProgress()
        }
      }
      
      // 确保基础信息存在
      if (!this.videoInfo.id) {
        this.videoInfo.id = this.currentVideoId || Date.now()
      }
      if (!this.videoInfo.duration) {
        this.videoInfo.duration = 0
      }
    },

    async loadVideoProgress() {
      if (!this.courseId || !this.currentVideoId) return
      
      try {
        const res = await api.getVideoProgress(this.courseId, this.currentVideoId)
        if (res.code === 200 && res.data) {
          this.progress = res.data.watchProgress / 100 || 0
          this.totalStudyTime = res.data.totalWatchTime || 0
        }
      } catch (error) {
        console.error('加载学习进度失败:', error)
        // 忽略进度加载失败，不影响视频播放
      }
    },

    async loadCourseVideos() {
      if (!this.courseId) return
      
      try {
        const res = await getCourseVideos(this.courseId)
        if (res.code === 200) {
          this.courseVideos = (res.data || []).map(video => ({
            ...video,
            title: video.title || video.videoTitle,
            duration: parseInt(video.duration || video.videoDuration) || 0,
            description: video.description || video.videoDescription,
            isFree: video.isFree,
            isCompleted: video.isCompleted,
            videoUrl: video.videoUrl
          }))
        }
      } catch (error) {
        console.error('加载课程视频列表失败:', error)
      }
    },
    
    onTimeUpdate(e) {
      this.currentTime = e.detail.currentTime
      if (this.videoInfo.duration > 0) {
        this.progress = this.currentTime / this.videoInfo.duration
      }
      
      // 每30秒保存一次进度到后端（减少服务器压力）
      const now = Date.now()
      if (now - this.lastUpdateTime > 30000) {
        this.saveProgress()
        this.lastUpdateTime = now
      }
    },
    
    onVideoEnded() {
      this.progress = 1
      this.saveProgress(true)
      
      // 视频结束时停止计时器
      this.stopStudyTimer()
      
      uni.showToast({
        title: '视频学习完成',
        icon: 'success'
      })
    },
    
    onVideoLoaded(e) {
      if (e.detail.duration) {
        this.videoInfo.duration = e.detail.duration
      }
    },

    onVideoError(e) {
      console.error('视频加载失败:', e)
      uni.showToast({
        title: '视频加载失败，请检查网络连接',
        icon: 'none',
        duration: 3000
      })
    },

    onVideoPlay() {
      console.log('视频开始播放')
      // 只有在视频实际播放时才开始计时
      this.startTime = Date.now()
      this.startStudyTimer()
    },

    onVideoPause() {
      console.log('视频暂停播放')
      // 视频暂停时停止计时并保存进度
      this.stopStudyTimer()
      this.saveProgress()
    },
    
    startStudyTimer() {
      // 清除之前的计时器
      this.stopStudyTimer()
      
      // 每秒更新一次学习时长
      this.progressTimer = setInterval(() => {
        if (this.startTime) {
          this.studyTime = Math.floor((Date.now() - this.startTime) / 1000)
        }
      }, 1000)
    },

    stopStudyTimer() {
      if (this.progressTimer) {
        clearInterval(this.progressTimer)
        this.progressTimer = null
      }
    },

    async saveProgress(isCompleted = false) {
      if (!this.currentVideoId || !this.courseId) return
      
      // 确保学习时长是最新的
      this.studyTime = Math.floor((Date.now() - this.startTime) / 1000)
      
      try {
        await updateVideoProgress({
          courseId: this.courseId,
          videoId: this.currentVideoId,
          progress: this.progress,
          duration: this.videoInfo.duration,
          watchTime: this.studyTime,
          isCompleted: isCompleted || this.progress >= 0.9
        })
        
        // 重新获取最新的学习进度，包括总学习时长
        await this.loadVideoProgress()
        console.log('学习进度保存成功, 当前进度:', Math.round(this.progress * 100) + '%')
      } catch (error) {
        console.error('保存学习进度失败:', error)
        console.error('失败详情:', {
          courseId: this.courseId,
          videoId: this.currentVideoId,
          progress: this.progress,
          studyTime: this.studyTime
        })
        // 不显示错误提示，避免干扰用户观看
      }
    },
    
    switchVideo(video) {
      if (!video.isFree && !this.isEnrolled) {
        uni.showToast({
          title: '请先报名课程',
          icon: 'none'
        })
        return
      }
      
      // 保存当前视频的学习进度
      this.saveProgress()
      
      // 停止计时器
      this.stopStudyTimer()
      
      // 重新加载页面，切换到新视频
      const videoUrl = this.getVideoUrl(video.videoUrl)
      uni.redirectTo({
        url: `/pages/course/video-player?videoId=${video.id}&courseId=${this.courseId}&videoUrl=${encodeURIComponent(videoUrl)}&title=${encodeURIComponent(video.title)}`
      })
    },
    
    formatDuration(seconds) {
      const duration = parseInt(seconds) || 0
      if (duration <= 0) return '00:00'
      const minutes = Math.floor(duration / 60)
      const remainingSeconds = Math.floor(duration % 60)
      return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`
    },
    
    formatStudyTime(seconds) {
      if (seconds < 60) {
        return `${seconds}秒`
      } else if (seconds < 3600) {
        const minutes = Math.floor(seconds / 60)
        const remainingSeconds = seconds % 60
        return `${minutes}分${remainingSeconds}秒`
      } else {
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        return `${hours}小时${minutes}分钟`
      }
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
    }
  }
}
</script>

<style scoped>
.video-player-container {
  background-color: #f5f5f5;
  min-height: 100vh;
}

.video-wrapper {
  background-color: #000;
  position: relative;
}

.video-player {
  width: 100%;
  height: 210px;
}

.video-info {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 10px;
}

.video-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
  line-height: 1.4;
}

.video-meta {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.progress-bar {
  height: 4px;
  background-color: #e0e0e0;
  border-radius: 2px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background-color: #007aff;
  transition: width 0.3s ease;
}

.video-description {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 10px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
  padding-bottom: 5px;
  border-bottom: 2px solid #007aff;
}

.description-content {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}

.course-videos {
  background-color: #fff;
  padding: 15px;
  margin-bottom: 10px;
}

.video-list {
  margin-top: 10px;
}

.video-item {
  display: flex;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.video-item:last-child {
  border-bottom: none;
}

.video-item.current {
  background-color: #f0f8ff;
}

.video-item.completed .video-item-title {
  color: #999;
}

.video-item-content {
  flex: 1;
}

.video-item-title {
  font-size: 15px;
  color: #333;
  margin-bottom: 5px;
}

.video-item.current .video-item-title {
  color: #007aff;
  font-weight: bold;
}

.video-item-meta {
  display: flex;
  align-items: center;
  font-size: 12px;
  color: #999;
}

.video-duration {
  margin-right: 10px;
}

.free-tag {
  background-color: #52c41a;
  color: #fff;
  padding: 2px 6px;
  border-radius: 3px;
  margin-right: 5px;
}

.completed-tag {
  background-color: #1890ff;
  color: #fff;
  padding: 2px 6px;
  border-radius: 3px;
}

.video-item-icon {
  margin-left: 10px;
  font-size: 16px;
}

.icon-completed {
  color: #52c41a;
}

.icon-playing {
  color: #007aff;
}

.icon-play {
  color: #999;
}

.study-record {
  background-color: #fff;
  padding: 15px;
}

.record-item {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.record-item:last-child {
  margin-bottom: 0;
}
</style> 