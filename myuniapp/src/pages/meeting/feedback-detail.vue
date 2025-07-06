<template>
  <view class="container">
    <view class="header">
      <text class="title">会议回执详情</text>
    </view>
    <view v-if="loading" class="loading">加载中...</view>
    <view v-else-if="!feedback" class="empty">暂无回执信息</view>
    <view v-else class="feedback-detail-block">
      <view class="feedback-group"><view class="feedback-label">单位</view><view class="feedback-value">{{ feedback.companyName || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">姓名</view><view class="feedback-value">{{ feedback.userName || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">性别</view><view class="feedback-value">{{ feedback.gender || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">手机</view><view class="feedback-value">{{ feedback.userPhone || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">邮箱</view><view class="feedback-value">{{ feedback.userEmail || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">到达方式</view><view class="feedback-value">{{ feedback.arrivalMethod || '-' }}</view></view>
      <view class="feedback-group" v-if="feedback.arrivalMethod && feedback.arrivalMethod !== '自驾' && feedback.arrivalMethod !== '其他'">
        <view class="feedback-label">车次/航班</view><view class="feedback-value">{{ feedback.arrivalInfo || '-' }}</view>
      </view>
      <view class="feedback-group"><view class="feedback-label">到达时间</view><view class="feedback-value">{{ feedback.arrivalTime || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">总体评分</view><view class="feedback-value star">{{ renderStars(feedback.rating) }}</view></view>
      <view class="feedback-group"><view class="feedback-label">参会感受</view><view class="feedback-value">{{ feedback.content || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">改进建议</view><view class="feedback-value">{{ feedback.suggestions || '-' }}</view></view>
      <view class="feedback-group"><view class="feedback-label">组织安排</view><view class="feedback-value star">{{ renderStars(feedback.organizationRating) }}</view></view>
      <view class="feedback-group"><view class="feedback-label">内容质量</view><view class="feedback-value star">{{ renderStars(feedback.contentRating) }}</view></view>
      <view class="feedback-group"><view class="feedback-label">场地环境</view><view class="feedback-value star">{{ renderStars(feedback.venueRating) }}</view></view>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
export default {
  data() {
    return {
      feedback: null,
      loading: true
    }
  },
  onLoad(options) {
    if (options.id) {
      this.loadFeedback(options.id)
    } else {
      this.loading = false
    }
  },
  methods: {
    async loadFeedback(meetingId) {
      this.loading = true
      try {
        const res = await api.getUserFeedback(meetingId)
        this.feedback = res && res.data ? res.data : null
      } catch (e) {
        this.feedback = null
      } finally {
        this.loading = false
      }
    },
    renderStars(val) {
      if (!val) return '☆☆☆☆☆'
      return '★'.repeat(val) + '☆'.repeat(5 - val)
    }
  }
}
</script>

<style scoped>
.container { padding: 30rpx; background: #f6f8fa; min-height: 100vh; }
.header { text-align: center; margin-bottom: 30rpx; }
.title { font-size: 36rpx; font-weight: bold; color: #2f80ed; }
.loading, .empty { text-align: center; color: #888; margin: 60rpx 0; }
.feedback-detail-block { background: #fff; border-radius: 18rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.08); padding: 32rpx 24rpx 24rpx 24rpx; }
.feedback-group { display: flex; margin-bottom: 18rpx; }
.feedback-label { width: 140rpx; color: #888; font-size: 26rpx; flex-shrink: 0; }
.feedback-value { color: #333; font-size: 26rpx; word-break: break-all; }
.feedback-value.star { color: #faad14; font-size: 28rpx; }
</style> 