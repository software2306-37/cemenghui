<template>
  <view class="container">
    <view v-if="newsDetail" class="detail-content">
      <text class="title">{{ newsDetail.title }}</text>
      <view class="meta-info">
        <text class="author">作者：{{ newsDetail.author || '佚名' }}</text>
        <text class="date">{{ formatDate(newsDetail.createTime) }}</text>
        <text class="views">{{ newsDetail.viewCount || 0 }}次浏览</text>
      </view>
      
      <!-- 封面图片 -->
      <view v-if="newsDetail.coverImage" class="image-container">
        <image :src="getImageUrl(newsDetail.coverImage)" class="main-image" mode="widthFix" @error="onImageError"></image>
      </view>
      <view v-else class="image-placeholder">
        <text class="placeholder-icon">📰</text>
        <text class="placeholder-text">暂无封面图片</text>
      </view>
      
      <!-- 摘要 -->
      <view v-if="newsDetail.summary" class="summary-section">
        <text class="summary-title">摘要</text>
        <text class="summary-content">{{ newsDetail.summary }}</text>
      </view>
      
      <!-- 正文内容 -->
      <view class="content-section">
        <text class="content-title">正文</text>
        <view v-if="newsDetail.content" class="content">
          <rich-text :nodes="formatContent(newsDetail.content)"></rich-text>
        </view>
        <view v-else class="no-content">
          <text class="no-content-text">暂无详细内容</text>
        </view>
      </view>
      
      <!-- 状态信息 -->
      <view class="status-section">
        <text class="status-label">状态：</text>
        <text class="status-value">{{ getStatusText(newsDetail.status) }}</text>
      </view>
    </view>
    
    <view v-if="loading" class="loading">
      <text class="loading-text">加载中...</text>
    </view>
    
    <view v-if="!newsDetail && !loading" class="empty">
      <text class="empty-icon">📰</text>
      <text class="empty-text">内容不存在或已被删除</text>
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
      newsDetail: null,
      loading: false,
      newsId: null
    }
  },
  onLoad(options) {
    console.log('新闻详情页参数:', options)
    if (options.id) {
      this.newsId = options.id
      this.loadNewsDetail()
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
    async loadNewsDetail() {
      this.loading = true
      try {
        console.log('加载新闻详情，ID:', this.newsId)
        const result = await api.getNewsDetail(this.newsId)
        
        console.log('新闻详情API响应:', result)
        
        if (result && result.data) {
          this.newsDetail = result.data
          console.log('新闻详情数据:', this.newsDetail)
        } else if (result) {
          // 有些API直接返回数据，没有包装在data中
          this.newsDetail = result
          console.log('新闻详情数据（直接）:', this.newsDetail)
        } else {
          console.log('新闻详情为空，显示错误')
          this.newsDetail = null
        }
      } catch (error) {
        console.error('加载新闻详情失败:', error)
        this.newsDetail = null
        uni.showToast({
          title: '加载失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    formatDate(dateStr) {
      if (!dateStr) return '未知时间'
      return formatDateTime(dateStr, 'YYYY-MM-DD HH:mm')
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
  margin: 20rpx;
  border-radius: 10rpx;
  overflow: hidden;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  line-height: 1.4;
  padding: 30rpx 30rpx 20rpx;
  display: block;
}

.meta-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 30rpx 20rpx;
  margin-bottom: 20rpx;
  border-bottom: 1rpx solid #eee;
  flex-wrap: wrap;
  gap: 10rpx;
}

.author, .date, .views {
  font-size: 24rpx;
  color: #999;
}

.image-container {
  padding: 0 30rpx 20rpx;
}

.main-image {
  width: 100%;
  border-radius: 8rpx;
}

.image-placeholder {
  padding: 60rpx 30rpx;
  text-align: center;
  background-color: #f8f8f8;
  margin: 0 30rpx 20rpx;
  border-radius: 8rpx;
}

.placeholder-icon {
  font-size: 60rpx;
  display: block;
  margin-bottom: 10rpx;
  opacity: 0.5;
}

.placeholder-text {
  font-size: 24rpx;
  color: #999;
}

.summary-section, .content-section {
  padding: 20rpx 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.summary-title, .content-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 15rpx;
  display: block;
}

.summary-content {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
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

.status-section {
  padding: 20rpx 30rpx;
  display: flex;
  align-items: center;
}

.status-label {
  font-size: 26rpx;
  color: #666;
}

.status-value {
  font-size: 26rpx;
  color: #007aff;
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