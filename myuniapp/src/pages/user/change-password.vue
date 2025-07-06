<template>
  <view class="container">
    <view class="header">
      <text class="title">修改密码</text>
    </view>
    
    <view class="form">
      <view class="form-item">
        <text class="label">当前密码</text>
        <input class="input" v-model="formData.oldPassword" placeholder="请输入当前密码" type="password" />
      </view>
      
      <view class="form-item">
        <text class="label">新密码</text>
        <input class="input" v-model="formData.newPassword" placeholder="请输入新密码" type="password" />
      </view>
      
      <view class="form-item">
        <text class="label">确认密码</text>
        <input class="input" v-model="formData.confirmPassword" placeholder="请再次输入新密码" type="password" />
      </view>
    </view>
    
    <view class="tips">
      <text class="tip-text">密码要求：</text>
      <text class="tip-text">• 长度6-20位</text>
      <text class="tip-text">• 建议包含字母、数字和特殊字符</text>
    </view>
    
    <view class="actions">
      <button class="submit-btn" @click="changePassword">确认修改</button>
      <button class="cancel-btn" @click="goBack">取消</button>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'

export default {
  data() {
    return {
      formData: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
    }
  },
  methods: {
    async changePassword() {
      if (!this.validateForm()) {
        return
      }
      
      try {
        uni.showLoading({
          title: '修改中...'
        })
        
        const response = await api.changePassword({
          oldPassword: this.formData.oldPassword,
          newPassword: this.formData.newPassword
        })
        
        console.log('修改密码响应:', response)
        
        if (response && response.code === 200) {
          uni.hideLoading()
          uni.showToast({
            title: '密码修改成功',
            icon: 'success'
          })
          
          // 延迟返回上一页
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        } else {
          uni.hideLoading()
          uni.showToast({
            title: (response && response.message) || '密码修改失败',
            icon: 'none'
          })
        }
        
      } catch (error) {
        uni.hideLoading()
        console.error('修改密码失败:', error)
        uni.showToast({
          title: error.message || '修改密码失败，请重试',
          icon: 'none'
        })
      }
    },
    
    validateForm() {
      const { oldPassword, newPassword, confirmPassword } = this.formData
      
      if (!oldPassword) {
        uni.showToast({
          title: '请输入当前密码',
          icon: 'none'
        })
        return false
      }
      
      if (!newPassword) {
        uni.showToast({
          title: '请输入新密码',
          icon: 'none'
        })
        return false
      }
      
      if (newPassword.length < 6 || newPassword.length > 20) {
        uni.showToast({
          title: '密码长度为6-20位',
          icon: 'none'
        })
        return false
      }
      
      if (newPassword !== confirmPassword) {
        uni.showToast({
          title: '两次密码输入不一致',
          icon: 'none'
        })
        return false
      }
      
      if (oldPassword === newPassword) {
        uni.showToast({
          title: '新密码不能与当前密码相同',
          icon: 'none'
        })
        return false
      }
      
      return true
    },
    
    goBack() {
      uni.navigateBack()
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
  padding: 20rpx 0 40rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.form {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
  margin-bottom: 30rpx;
}

.form-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.form-item:last-child {
  border-bottom: none;
}

.label {
  width: 160rpx;
  font-size: 28rpx;
  color: #333;
  flex-shrink: 0;
}

.input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  text-align: right;
}

.tips {
  background-color: white;
  border-radius: 12rpx;
  padding: 30rpx;
  margin-bottom: 40rpx;
}

.tip-text {
  display: block;
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
  margin-bottom: 10rpx;
}

.actions {
  padding: 0 30rpx;
}

.submit-btn {
  width: 100%;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 32rpx;
  border: none;
  border-radius: 40rpx;
  margin-bottom: 20rpx;
}

.cancel-btn {
  width: 100%;
  height: 80rpx;
  background-color: white;
  color: #666;
  font-size: 32rpx;
  border: 2rpx solid #ddd;
  border-radius: 40rpx;
}
</style> 