<template>
  <view class="container">
    <!-- 背景装饰 -->
    <view class="bg-decoration">
      <view class="circle circle-1"></view>
      <view class="circle circle-2"></view>
      <view class="circle circle-3"></view>
    </view>
    
    <!-- 头部区域 -->
    <view class="login-header">
      <view class="logo-container">
        <view class="logo">
          <text class="logo-icon">🏛️</text>
        </view>
        <text class="title">测盟汇</text>
        <text class="subtitle">中国电子质量管理协会</text>
      </view>
      <text class="welcome">欢迎登录</text>
    </view>
    
    <!-- 登录表单 -->
    <view class="login-form">
      <view class="form-title">
        <text class="form-title-text">账号登录</text>
      </view>
      
      <view class="form-item">
        <view class="input-wrapper">
          <text class="input-icon">👤</text>
          <input 
            v-model="form.username" 
            placeholder="请输入用户名或邮箱" 
            class="input"
            @input="clearError"
          />
        </view>
      </view>
      
      <view class="form-item">
        <view class="input-wrapper">
          <text class="input-icon">🔒</text>
          <input 
            v-model="form.password" 
            placeholder="请输入密码" 
            password 
            class="input"
            @input="clearError"
          />
        </view>
      </view>
      
      <view class="form-item">
        <view class="captcha-row">
          <input 
            class="captcha-input" 
            v-model="form.captcha" 
            placeholder="验证码"
            @focus="clearError"
          />
          <view class="captcha-container" @tap="refreshCaptcha">
            <canvas 
              canvas-id="captchaCanvas" 
              class="captcha-canvas"
            ></canvas>
          </view>
        </view>
      </view>
      
      <view v-if="errorMessage" class="error-message">
        <text class="error-text">{{ errorMessage }}</text>
      </view>
      
      <button class="login-btn" @click="handleLogin" :disabled="loading">
        <view class="btn-content">
          <text v-if="loading" class="btn-text">登录中...</text>
          <text v-else class="btn-text">立即登录</text>
        </view>
      </button>
      
      <view class="login-options">
        <text class="option-text" @click="showRegister">还没有账号？立即注册</text>
        <text class="option-text" @click="showForgetPassword">忘记密码？</text>
      </view>
    </view>
    
    <!-- 底部信息 -->
    <view class="footer">
      <text class="footer-text">专业的测试技术交流平台</text>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { validateEmail, setUserInfo } from '../../utils/common'

export default {
  data() {
    return {
      form: {
        username: '',
        password: '',
        captcha: ''
      },
      loading: false,
      errorMessage: '',
      captchaCode: ''
    }
  },
  onReady() {
    this.refreshCaptcha()
  },
  methods: {
    // 生成验证码
    generateCaptcha() {
      const chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678'
      let result = ''
      for (let i = 0; i < 4; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      return result
    },
    
    // 刷新验证码
    refreshCaptcha() {
      this.captchaCode = this.generateCaptcha()
      this.$nextTick(() => {
        this.drawCaptcha()
      })
    },
    
    // 绘制验证码
    drawCaptcha() {
      const ctx = uni.createCanvasContext('captchaCanvas', this)
      const width = 160
      const height = 50
      
      // 清空画布
      ctx.clearRect(0, 0, width, height)
      
      // 设置背景 - 使用纯白色背景
      ctx.setFillStyle('#ffffff')
      ctx.fillRect(0, 0, width, height)
      
      // 绘制边框 - 使用深色边框
      ctx.setStrokeStyle('#333333')
      ctx.setLineWidth(1)
      ctx.strokeRect(0, 0, width, height)
      
      // 绘制验证码文字
      ctx.setFillStyle('#000000')
      ctx.setFontSize(18)
      ctx.setTextAlign('left')
      ctx.setTextBaseline('top')
      
              // 计算字符间距和起始位置，字符间距设置为12px
        const charWidth = 12
        const startX = 20
        const startY = 12
      
      for (let i = 0; i < this.captchaCode.length; i++) {
        const char = this.captchaCode.charAt(i)
        const x = startX + i * charWidth
        const y = startY
        
        ctx.fillText(char, x, y)
      }
      
      ctx.draw()
    },
    
    async handleLogin() {
      if (!this.validateForm()) {
        return
      }
      
      // 验证码校验
      if (this.form.captcha.toLowerCase() !== this.captchaCode.toLowerCase()) {
        this.errorMessage = '验证码错误'
        this.refreshCaptcha()
        this.form.captcha = ''
        return
      }
      
      this.loading = true
      try {
        const response = await api.login({
          username: this.form.username,
          password: this.form.password
        })
        
        console.log('登录API响应:', response)
        
        if (response && response.code === 200 && response.data) {
          const result = response.data
          // 保存用户信息
          const userInfo = {
            id: result.id,
            username: result.username,
            nickname: result.nickname,
            email: result.email,
            phone: result.phone,
            avatar: result.avatar,
            role: result.role,
            status: result.status,
            companyName: result.companyName,
            gender: result.gender,
            createTime: result.createTime,
            updateTime: result.updateTime
          }
          
          console.log('保存的用户信息:', userInfo)
          uni.setStorageSync('userInfo', userInfo)
          setUserInfo(userInfo)
          
          uni.showToast({
            title: '登录成功',
            icon: 'success'
          })
          
          // 延迟跳转到首页
          setTimeout(() => {
            uni.switchTab({
              url: '/pages/index/index'
            })
          }, 1500)
        }
      } catch (error) {
        console.error('登录失败:', error)
        uni.showToast({
          title: error.message || '登录失败',
          icon: 'none'
        })
        this.refreshCaptcha()
        this.form.captcha = ''
      } finally {
        this.loading = false
      }
    },
    
    validateForm() {
      if (!this.form.username.trim()) {
        this.errorMessage = '请输入用户名或邮箱'
        return false
      }
      
      if (!this.form.password.trim()) {
        this.errorMessage = '请输入密码'
        return false
      }
      
      if (this.form.password.length < 6) {
        this.errorMessage = '密码长度不能少于6位'
        return false
      }
      
      if (!this.form.captcha.trim()) {
        this.errorMessage = '请输入验证码'
        return false
      }
      
      // 如果输入的是邮箱格式，验证邮箱
      if (this.form.username.includes('@') && !validateEmail(this.form.username)) {
        this.errorMessage = '邮箱格式不正确'
        return false
      }
      
      return true
    },
    
    clearError() {
      this.errorMessage = ''
    },
    
    showRegister() {
      uni.navigateTo({
        url: '/pages/login/register'
      })
    },
    
    showForgetPassword() {
      uni.navigateTo({
        url: '/pages/login/forgot-password'
      })
    }
  }
}
</script>

<style scoped>
.container {
  position: relative;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  padding: 40rpx;
  overflow: hidden;
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10rpx);
}

.circle-1 {
  width: 200rpx;
  height: 200rpx;
  top: 100rpx;
  right: -100rpx;
  animation: float 6s ease-in-out infinite;
}

.circle-2 {
  width: 150rpx;
  height: 150rpx;
  bottom: 200rpx;
  left: -75rpx;
  animation: float 8s ease-in-out infinite reverse;
}

.circle-3 {
  width: 100rpx;
  height: 100rpx;
  top: 50%;
  left: 50rpx;
  animation: float 7s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20rpx); }
}

/* 头部区域 */
.login-header {
  position: relative;
  z-index: 1;
  text-align: center;
  margin-bottom: 60rpx;
  padding-top: 80rpx;
}

.logo-container {
  margin-bottom: 30rpx;
}

.logo {
  display: inline-block;
  margin-bottom: 15rpx;
}

.logo-icon {
  font-size: 70rpx;
  color: white;
  text-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.2);
}

.title {
  display: block;
  font-size: 50rpx;
  font-weight: bold;
  color: white;
  margin-bottom: 8rpx;
  text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.2);
}

.subtitle {
  display: block;
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 15rpx;
}

.welcome {
  font-size: 36rpx;
  color: white;
  font-weight: 300;
  text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.2);
}

/* 登录表单 */
.login-form {
  position: relative;
  z-index: 1;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20rpx);
  border-radius: 30rpx;
  padding: 50rpx 30rpx;
  margin: 0 10rpx;
  box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.1);
}

.form-title {
  text-align: center;
  margin-bottom: 50rpx;
}

.form-title-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.form-item {
  margin-bottom: 35rpx;
}

.captcha-form-item {
  margin-bottom: 40rpx;
}

.input-wrapper {
  display: flex;
  align-items: center;
  background: #f8f9fa;
  border-radius: 20rpx;
  padding: 0 25rpx;
  height: 90rpx;
  border: 2rpx solid transparent;
  transition: all 0.3s ease;
}

.input-wrapper:focus-within {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 4rpx rgba(102, 126, 234, 0.1);
}

.input-icon {
  font-size: 28rpx;
  margin-right: 15rpx;
  color: #666;
}

.input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  border: none;
  background: transparent;
}

/* 验证码样式 */
.captcha-row {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.captcha-input {
  flex: 1;
  height: 80rpx;
  padding: 0 30rpx;
  background: rgba(255, 255, 255, 0.9);
  border: 2rpx solid rgba(255, 255, 255, 0.3);
  border-radius: 25rpx;
  font-size: 28rpx;
  color: #333;
  backdrop-filter: blur(10rpx);
}

.captcha-container {
  width: 160rpx;
  height: 50rpx;
  border: 1rpx solid #333333;
  border-radius: 4rpx;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.captcha-container:active {
  transform: scale(0.95);
  border-color: rgba(102, 126, 234, 0.8);
}

.captcha-canvas {
  width: 160rpx;
  height: 50rpx;
  border-radius: 4rpx;
}

.captcha-hint {
  position: absolute;
  bottom: -25rpx;
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
}

.captcha-hint-text {
  font-size: 18rpx;
  color: #999;
  text-align: center;
  display: block;
}

.error-message {
  margin-bottom: 20rpx;
  padding: 15rpx 20rpx;
  background: rgba(255, 77, 79, 0.1);
  border-radius: 15rpx;
  border-left: 4rpx solid #ff4d4f;
}

.error-text {
  color: #ff4d4f;
  font-size: 26rpx;
}

.login-btn {
  width: 100%;
  height: 90rpx;
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  border-radius: 45rpx;
  margin-bottom: 35rpx;
  box-shadow: 0 8rpx 25rpx rgba(102, 126, 234, 0.3);
  transition: all 0.3s ease;
}

.login-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 6rpx 20rpx rgba(102, 126, 234, 0.4);
}

.login-btn[disabled] {
  opacity: 0.6;
  transform: none;
}

.btn-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
}

.btn-text {
  color: white;
  font-size: 30rpx;
  font-weight: bold;
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.option-text {
  color: #667eea;
  font-size: 26rpx;
  padding: 8rpx;
}

.option-text:active {
  opacity: 0.7;
}

/* 底部信息 */
.footer {
  position: relative;
  z-index: 1;
  text-align: center;
  margin-top: 50rpx;
}

.footer-text {
  color: rgba(255, 255, 255, 0.8);
  font-size: 22rpx;
}
</style> 