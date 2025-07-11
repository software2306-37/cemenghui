<template>
  <view class="container">
    <view class="forgot-header">
      <text class="title">忘记密码</text>
      <text class="subtitle">请输入邮箱，我们将发送重置链接</text>
    </view>
    
    <view class="forgot-form">
      <view class="form-item">
        <input 
          class="input" 
          v-model="form.email" 
          placeholder="请输入注册邮箱"
          @focus="clearError"
        />
      </view>
      
      <view v-if="errorMessage" class="error-message">
        <text>{{ errorMessage }}</text>
      </view>
      
      <button class="reset-btn" @click="handleReset" :disabled="loading">
        <text v-if="loading">发送中...</text>
        <text v-else>发送重置邮件</text>
      </button>
      
      <view class="login-link">
        <text @click="goToLogin">返回登录</text>
      </view>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { validateEmail } from '../../utils/common'

export default {
  data() {
    return {
      form: {
        email: ''
      },
      loading: false,
      errorMessage: ''
    }
  },
  methods: {
    async handleReset() {
      if (!this.validateForm()) {
        return
      }
      
      this.loading = true
      try {
        const result = await api.resetPassword({
          email: this.form.email
        })
        
        if (result) {
          uni.showModal({
            title: '邮件已发送',
            content: '重置密码邮件已发送到您的邮箱，请查收并按照邮件指引重置密码。',
            showCancel: false,
            success: () => {
              uni.navigateBack()
            }
          })
        }
      } catch (error) {
        console.error('发送失败:', error)
        uni.showToast({
          title: error.message || '发送失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    validateForm() {
      if (!this.form.email.trim()) {
        this.errorMessage = '请输入邮箱'
        return false
      }
      
      if (!validateEmail(this.form.email)) {
        this.errorMessage = '邮箱格式不正确'
        return false
      }
      
      return true
    },
    
    clearError() {
      this.errorMessage = ''
    },
    
    goToLogin() {
      uni.navigateBack()
    }
  }
}
</script>

<style scoped>
.container {
  background: linear-gradient(135deg, #007aff, #00c6ff);
  min-height: 100vh;
  padding: 60rpx 40rpx;
}

.forgot-header {
  text-align: center;
  margin-bottom: 80rpx;
}

.title {
  font-size: 48rpx;
  font-weight: bold;
  color: white;
  display: block;
  margin-bottom: 20rpx;
}

.subtitle {
  font-size: 32rpx;
  color: rgba(255, 255, 255, 0.8);
  display: block;
}

.forgot-form {
  background-color: white;
  border-radius: 20rpx;
  padding: 60rpx 40rpx;
}

.form-item {
  margin-bottom: 40rpx;
}

.input {
  width: 100%;
  height: 80rpx;
  padding: 0 20rpx;
  border: 2rpx solid #e0e0e0;
  border-radius: 40rpx;
  font-size: 28rpx;
  background-color: #f8f8f8;
}

.input:focus {
  border-color: #007aff;
  background-color: white;
}

.error-message {
  margin-bottom: 20rpx;
  text-align: center;
}

.error-message text {
  color: #ff4757;
  font-size: 26rpx;
}

.reset-btn {
  width: 100%;
  height: 80rpx;
  background: linear-gradient(135deg, #007aff, #00c6ff);
  color: white;
  font-size: 32rpx;
  border: none;
  border-radius: 40rpx;
  margin-bottom: 40rpx;
}

.login-link {
  text-align: center;
}

.login-link text {
  color: #007aff;
  font-size: 28rpx;
}
</style> 