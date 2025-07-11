<template>
  <view class="error-boundary" v-if="hasError">
    <view class="error-content">
      <text class="error-icon">⚠️</text>
      <text class="error-title">出现了一些问题</text>
      <text class="error-message">{{ errorMessage }}</text>
      <button class="retry-btn" @click="retry">重试</button>
    </view>
  </view>
  <slot v-else></slot>
</template>

<script>
export default {
  name: 'ErrorBoundary',
  data() {
    return {
      hasError: false,
      errorMessage: ''
    }
  },
  methods: {
    handleError(error) {
      this.hasError = true
      this.errorMessage = error.message || '未知错误'
      console.error('ErrorBoundary caught an error:', error)
    },
    
    retry() {
      this.hasError = false
      this.errorMessage = ''
      this.$emit('retry')
    }
  },
  
  errorCaptured(err, vm, info) {
    this.handleError(err)
    return false
  }
}
</script>

<style scoped>
.error-boundary {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400rpx;
  padding: 40rpx;
}

.error-content {
  text-align: center;
}

.error-icon {
  font-size: 80rpx;
  display: block;
  margin-bottom: 20rpx;
}

.error-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 15rpx;
}

.error-message {
  font-size: 28rpx;
  color: #666;
  display: block;
  margin-bottom: 30rpx;
}

.retry-btn {
  width: 200rpx;
  height: 70rpx;
  background-color: #007aff;
  color: white;
  font-size: 28rpx;
  border: none;
  border-radius: 35rpx;
  line-height: 70rpx;
}
</style> 