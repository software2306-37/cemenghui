<template>
  <view class="container">
    <!-- 页面头部 -->
    <view class="header">
      <text class="title">用户行为分析</text>
      <text class="subtitle">实时监控用户活动和平台数据</text>
    </view>
    
    <!-- 数据加载状态 -->
    <view v-if="loading" class="loading">
      <text class="loading-text">数据加载中...</text>
    </view>
    
    <!-- 主要数据面板 -->
    <view v-else class="data-container">
      <!-- 用户统计概览 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">👥 用户统计</text>
        </view>
                 <view class="stats-grid">
           <view class="stat-item">
             <text class="stat-number">{{ (analyticsData.userStats && analyticsData.userStats.total) || 0 }}</text>
             <text class="stat-label">总用户数</text>
           </view>
           <view class="stat-item">
             <text class="stat-number">{{ (analyticsData.userStats && analyticsData.userStats.active) || 0 }}</text>
             <text class="stat-label">活跃用户</text>
           </view>
           <view class="stat-item">
             <text class="stat-number">{{ (analyticsData.userStats && analyticsData.userStats.newUsersThisMonth) || 0 }}</text>
             <text class="stat-label">本月新增</text>
           </view>
           <view class="stat-item">
             <text class="stat-number">{{ (analyticsData.userStats && analyticsData.userStats.inactive) || 0 }}</text>
             <text class="stat-label">非活跃用户</text>
           </view>
         </view>
      </view>
      
      <!-- 内容统计 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">📊 内容统计</text>
        </view>
        <view class="content-stats">
                     <view class="content-item">
             <text class="content-type">📰 新闻动态</text>
             <view class="content-numbers">
               <text class="content-total">总数: {{ (analyticsData.contentStats && analyticsData.contentStats.news && analyticsData.contentStats.news.total) || 0 }}</text>
               <text class="content-published">已发布: {{ (analyticsData.contentStats && analyticsData.contentStats.news && analyticsData.contentStats.news.published) || 0 }}</text>
             </view>
           </view>
           <view class="content-item">
             <text class="content-type">📚 培训课程</text>
             <view class="content-numbers">
               <text class="content-total">总数: {{ (analyticsData.contentStats && analyticsData.contentStats.courses && analyticsData.contentStats.courses.total) || 0 }}</text>
               <text class="content-published">已发布: {{ (analyticsData.contentStats && analyticsData.contentStats.courses && analyticsData.contentStats.courses.published) || 0 }}</text>
             </view>
           </view>
           <view class="content-item">
             <text class="content-type">🤝 技术会议</text>
             <view class="content-numbers">
               <text class="content-total">总数: {{ (analyticsData.contentStats && analyticsData.contentStats.meetings && analyticsData.contentStats.meetings.total) || 0 }}</text>
               <text class="content-published">已发布: {{ (analyticsData.contentStats && analyticsData.contentStats.meetings && analyticsData.contentStats.meetings.published) || 0 }}</text>
             </view>
           </view>
        </view>
      </view>
      
      <!-- 用户行为数据 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">🔥 用户行为</text>
        </view>
                 <view class="behavior-stats">
           <view class="behavior-item">
             <text class="behavior-label">页面总浏览量</text>
             <text class="behavior-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.totalPageViews && analyticsData.behaviorStats.totalPageViews.totalViews) || 0 }}</text>
           </view>
           <view class="behavior-item">
             <text class="behavior-label">今日浏览量</text>
             <text class="behavior-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.totalPageViews && analyticsData.behaviorStats.totalPageViews.todayViews) || 0 }}</text>
           </view>
           <view class="behavior-item">
             <text class="behavior-label">平均浏览时长</text>
             <text class="behavior-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.totalPageViews && analyticsData.behaviorStats.totalPageViews.averageViewTime) || '0分钟' }}</text>
           </view>
           <view class="behavior-item">
             <text class="behavior-label">用户互动总数</text>
             <text class="behavior-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userInteractions && analyticsData.behaviorStats.userInteractions.totalClicks) || 0 }}</text>
           </view>
         </view>
      </view>
      
      <!-- 页面浏览分类 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">📈 页面浏览分布</text>
        </view>
                 <view class="page-views">
           <view 
             v-for="(views, pageType) in (analyticsData.behaviorStats && analyticsData.behaviorStats.totalPageViews && analyticsData.behaviorStats.totalPageViews.byPageType) || {}" 
             :key="pageType" 
             class="page-view-item"
           >
            <text class="page-type">{{ getPageTypeLabel(pageType) }}</text>
            <view class="progress-bar">
              <view class="progress-fill" :style="{ width: getProgressWidth(views) }"></view>
            </view>
            <text class="page-views-count">{{ views }}</text>
          </view>
        </view>
      </view>
      
      <!-- 热门内容 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">🎯 热门内容</text>
        </view>
                 <view class="popular-content">
           <view 
             v-for="(content, index) in (analyticsData.behaviorStats && analyticsData.behaviorStats.popularContent) || []" 
             :key="index" 
             class="popular-item"
           >
            <view class="popular-rank">{{ index + 1 }}</view>
            <view class="popular-info">
              <text class="popular-title">{{ content.title }}</text>
              <text class="popular-meta">{{ getContentTypeLabel(content.type) }} • {{ content.views }} 次浏览</text>
            </view>
          </view>
        </view>
      </view>
      
      <!-- 用户活跃度 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">⚡ 用户活跃度</text>
        </view>
                 <view class="activity-stats">
           <view class="activity-row">
             <text class="activity-label">日活跃用户</text>
             <text class="activity-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userActivity && analyticsData.behaviorStats.userActivity.dailyActiveUsers) || 0 }}</text>
           </view>
           <view class="activity-row">
             <text class="activity-label">周活跃用户</text>
             <text class="activity-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userActivity && analyticsData.behaviorStats.userActivity.weeklyActiveUsers) || 0 }}</text>
           </view>
           <view class="activity-row">
             <text class="activity-label">月活跃用户</text>
             <text class="activity-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userActivity && analyticsData.behaviorStats.userActivity.monthlyActiveUsers) || 0 }}</text>
           </view>
           <view class="activity-row">
             <text class="activity-label">平均会话时长</text>
             <text class="activity-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userActivity && analyticsData.behaviorStats.userActivity.averageSessionTime) || '0分钟' }}</text>
           </view>
           <view class="activity-row">
             <text class="activity-label">跳出率</text>
             <text class="activity-value">{{ (analyticsData.behaviorStats && analyticsData.behaviorStats.userActivity && analyticsData.behaviorStats.userActivity.bounceRate) || '0%' }}</text>
           </view>
         </view>
      </view>
      
      <!-- 增长趋势 -->
      <view class="card">
        <view class="card-header">
          <text class="card-title">📊 增长趋势</text>
        </view>
                 <view class="trends">
           <view class="trend-item">
             <text class="trend-label">用户增长</text>
             <text class="trend-value positive">{{ (analyticsData.timeStats && analyticsData.timeStats.weeklyTrends && analyticsData.timeStats.weeklyTrends.userGrowth) || '+0%' }}</text>
           </view>
           <view class="trend-item">
             <text class="trend-label">内容增长</text>
             <text class="trend-value positive">{{ (analyticsData.timeStats && analyticsData.timeStats.weeklyTrends && analyticsData.timeStats.weeklyTrends.contentGrowth) || '+0%' }}</text>
           </view>
           <view class="trend-item">
             <text class="trend-label">互动增长</text>
             <text class="trend-value positive">{{ (analyticsData.timeStats && analyticsData.timeStats.weeklyTrends && analyticsData.timeStats.weeklyTrends.engagementGrowth) || '+0%' }}</text>
           </view>
           <view class="trend-item">
             <text class="trend-label">活跃度增长</text>
             <text class="trend-value positive">{{ (analyticsData.timeStats && analyticsData.timeStats.weeklyTrends && analyticsData.timeStats.weeklyTrends.activeUserGrowth) || '+0%' }}</text>
           </view>
         </view>
      </view>
      
      <!-- 数据更新时间 -->
      <view class="footer">
        <text class="update-time">
          数据更新时间: {{ formatDateTime(analyticsData.generatedAt) }}
        </text>
      </view>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { formatDateTime } from '../../utils/common'

export default {
  data() {
    return {
      loading: true,
      analyticsData: {},
      maxPageViews: 0 // 用于计算进度条
    }
  },
  onLoad() {
    this.loadAnalyticsData()
  },
  onPullDownRefresh() {
    this.loadAnalyticsData().then(() => {
      uni.stopPullDownRefresh()
    })
  },
  methods: {
    async loadAnalyticsData() {
      this.loading = true
      try {
        const response = await api.getBehaviorAnalytics()
        console.log('行为分析数据响应:', response)
        
        if (response && response.code === 200 && response.data) {
          this.analyticsData = response.data
          this.calculateMaxPageViews()
          console.log('设置分析数据:', this.analyticsData)
        } else {
          uni.showToast({
            title: response?.message || '获取数据失败',
            icon: 'none'
          })
        }
      } catch (error) {
        console.error('获取行为分析数据失败:', error)
        if (error.message === '权限不足，仅管理员可访问此功能') {
          uni.showModal({
            title: '权限不足',
            content: '此功能仅限管理员使用，请使用管理员账号登录。',
            showCancel: false,
            success: () => {
              uni.navigateBack()
            }
          })
        } else {
          uni.showToast({
            title: error.message || '获取数据失败',
            icon: 'none'
          })
        }
      } finally {
        this.loading = false
      }
    },
    
         calculateMaxPageViews() {
       const pageViews = (this.analyticsData.behaviorStats && this.analyticsData.behaviorStats.totalPageViews && this.analyticsData.behaviorStats.totalPageViews.byPageType) || {}
       this.maxPageViews = Math.max(...Object.values(pageViews), 1)
     },
    
    getProgressWidth(views) {
      return `${(views / this.maxPageViews) * 100}%`
    },
    
    getPageTypeLabel(pageType) {
      const labels = {
        'news': '新闻动态',
        'courses': '培训课程',
        'meetings': '技术会议',
        'userCenter': '个人中心'
      }
      return labels[pageType] || pageType
    },
    
    getContentTypeLabel(type) {
      const labels = {
        'news': '新闻',
        'course': '课程',
        'meeting': '会议'
      }
      return labels[type] || type
    },
    
    formatDateTime(dateTime) {
      if (!dateTime) return '未知'
      return formatDateTime(dateTime, 'YYYY-MM-DD HH:mm:ss')
    }
  }
}
</script>

<style scoped>
.container {
  background-color: #f8f8f8;
  min-height: 100vh;
  padding-bottom: 20rpx;
}

.header {
  background-color: white;
  padding: 40rpx 30rpx;
  color: #333;
  text-align: center;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  display: block;
  margin-bottom: 10rpx;
}

.subtitle {
  font-size: 28rpx;
  opacity: 0.9;
  display: block;
}

.loading {
  text-align: center;
  padding: 100rpx 0;
}

.loading-text {
  font-size: 28rpx;
  color: #666;
}

.data-container {
  padding: 20rpx;
}

.card {
  background-color: white;
  border-radius: 12rpx;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
}

.card-header {
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.card-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

/* 用户统计样式 */
.stats-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 20rpx;
}

.stat-item {
  width: 50%;
  text-align: center;
  padding: 20rpx;
}

.stat-number {
  font-size: 40rpx;
  font-weight: bold;
  color: #007aff;
  display: block;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #666;
  display: block;
}

/* 内容统计样式 */
.content-stats {
  padding: 20rpx 30rpx 30rpx;
}

.content-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.content-item:last-child {
  border-bottom: none;
}

.content-type {
  font-size: 28rpx;
  color: #333;
  font-weight: 500;
}

.content-numbers {
  text-align: right;
}

.content-total, .content-published {
  font-size: 24rpx;
  color: #666;
  display: block;
  line-height: 1.4;
}

.content-published {
  color: #007aff;
}

/* 行为统计样式 */
.behavior-stats {
  padding: 20rpx 30rpx 30rpx;
}

.behavior-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.behavior-item:last-child {
  border-bottom: none;
}

.behavior-label {
  font-size: 28rpx;
  color: #333;
}

.behavior-value {
  font-size: 28rpx;
  color: #007aff;
  font-weight: bold;
}

/* 页面浏览分布样式 */
.page-views {
  padding: 20rpx 30rpx 30rpx;
}

.page-view-item {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.page-type {
  width: 120rpx;
  font-size: 26rpx;
  color: #333;
  flex-shrink: 0;
}

.progress-bar {
  flex: 1;
  height: 16rpx;
  background-color: #f0f0f0;
  border-radius: 8rpx;
  margin: 0 20rpx;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #007aff, #00c6ff);
  border-radius: 8rpx;
  transition: width 0.3s ease;
}

.page-views-count {
  width: 80rpx;
  text-align: right;
  font-size: 26rpx;
  color: #007aff;
  font-weight: bold;
}

/* 热门内容样式 */
.popular-content {
  padding: 20rpx 30rpx 30rpx;
}

.popular-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.popular-item:last-child {
  border-bottom: none;
}

.popular-rank {
  width: 60rpx;
  height: 60rpx;
  border-radius: 30rpx;
  background-color: #007aff;
  color: white;
  text-align: center;
  line-height: 60rpx;
  font-size: 24rpx;
  font-weight: bold;
  margin-right: 20rpx;
  flex-shrink: 0;
}

.popular-info {
  flex: 1;
}

.popular-title {
  font-size: 28rpx;
  color: #333;
  display: block;
  margin-bottom: 8rpx;
  font-weight: 500;
}

.popular-meta {
  font-size: 24rpx;
  color: #666;
  display: block;
}

/* 活跃度样式 */
.activity-stats {
  padding: 20rpx 30rpx 30rpx;
}

.activity-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.activity-row:last-child {
  border-bottom: none;
}

.activity-label {
  font-size: 28rpx;
  color: #333;
}

.activity-value {
  font-size: 28rpx;
  color: #007aff;
  font-weight: bold;
}

/* 趋势样式 */
.trends {
  display: flex;
  flex-wrap: wrap;
  padding: 20rpx;
}

.trend-item {
  width: 50%;
  text-align: center;
  padding: 20rpx;
}

.trend-label {
  font-size: 26rpx;
  color: #666;
  display: block;
  margin-bottom: 10rpx;
}

.trend-value {
  font-size: 32rpx;
  font-weight: bold;
  display: block;
}

.trend-value.positive {
  color: #4cd964;
}

.trend-value.negative {
  color: #ff4757;
}

/* 页脚样式 */
.footer {
  text-align: center;
  padding: 30rpx;
}

.update-time {
  font-size: 24rpx;
  color: #999;
}
</style> 