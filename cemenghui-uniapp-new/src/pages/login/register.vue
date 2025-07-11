<template>
  <view class="container">
    <view class="register-header">
      <text class="title">注册账号</text>
      <text class="subtitle">加入测盟汇，开启测试之旅</text>
    </view>
    
    <view class="register-form">
      <view class="form-item">
        <input 
          class="input" 
          v-model="form.username" 
          placeholder="请输入用户名"
          @focus="clearError"
        />
      </view>
      
      <view class="form-item">
        <input 
          class="input" 
          v-model="form.email" 
          placeholder="请输入邮箱"
          @focus="clearError"
        />
      </view>
      
      <view class="form-item">
        <input 
          class="input" 
          v-model="form.password" 
          placeholder="请输入密码（至少6位）"
          password
          @focus="clearError"
        />
      </view>
      
      <view class="form-item">
        <input 
          class="input" 
          v-model="form.confirmPassword" 
          placeholder="请确认密码"
          password
          @focus="clearError"
        />
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
              canvas-id="registerCaptchaCanvas" 
              class="captcha-canvas"
            ></canvas>
          </view>
        </view>
      </view>
      
      <view v-if="errorMessage" class="error-message">
        <text>{{ errorMessage }}</text>
      </view>
      
      <button class="register-btn" @click="handleRegister" :disabled="loading">
        <text v-if="loading">注册中...</text>
        <text v-else>注册</text>
      </button>
      
      <view class="login-link">
        <text @click="goToLogin">已有账号？立即登录</text>
      </view>
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
        email: '',
        password: '',
        confirmPassword: '',
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
      const ctx = uni.createCanvasContext('registerCaptchaCanvas', this)
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
    
    async handleRegister() {
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
        const result = await api.register({
          username: this.form.username,
          email: this.form.email,
          password: this.form.password
        })
        
        if (result) {
          uni.showToast({
            title: '注册成功！',
            icon: 'success'
          })
          
          // 延迟跳转到登录页
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      } catch (error) {
        console.error('注册失败:', error)
        uni.showToast({
          title: error.message || '注册失败',
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
        this.errorMessage = '请输入用户名'
        return false
      }
      
      if (this.form.username.length < 3) {
        this.errorMessage = '用户名至少3个字符'
        return false
      }
      
      if (!this.form.email.trim()) {
        this.errorMessage = '请输入邮箱'
        return false
      }
      
      if (!validateEmail(this.form.email)) {
        this.errorMessage = '邮箱格式不正确'
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
      
      if (this.form.password !== this.form.confirmPassword) {
        this.errorMessage = '两次输入的密码不一致'
        return false
      }
      
      if (!this.form.captcha.trim()) {
        this.errorMessage = '请输入验证码'
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
  padding: 40rpx 20rpx;
  box-sizing: border-box;
}

.register-header {
  text-align: center;
  margin-bottom: 40rpx;
  padding-top: 20rpx;
}

.title {
  font-size: 40rpx;
  font-weight: bold;
  color: white;
  display: block;
  margin-bottom: 10rpx;
  text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.2);
}

.subtitle {
  font-size: 26rpx;
  color: rgba(255, 255, 255, 0.9);
  display: block;
}

.register-form {
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20rpx);
  border-radius: 25rpx;
  padding: 40rpx 25rpx;
  box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.1);
  margin: 0 5rpx;
  box-sizing: border-box;
}

.form-item {
  margin-bottom: 25rpx;
}

.captcha-form-item {
  margin-bottom: 30rpx;
}

.input {
  width: 100%;
  height: 75rpx;
  padding: 0 20rpx;
  border: 2rpx solid #e9ecef;
  border-radius: 25rpx;
  font-size: 26rpx;
  background-color: #f8f9fa;
  color: #333;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.input:focus {
  border-color: #007aff;
  background-color: white;
  box-shadow: 0 0 0 4rpx rgba(0, 122, 255, 0.1);
}

/* 验证码样式 */
.captcha-row {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.captcha-input {
  flex: 1;
  height: 75rpx;
  padding: 0 20rpx;
  background: rgba(255, 255, 255, 0.9);
  border: 2rpx solid #e0e0e0;
  border-radius: 25rpx;
  font-size: 26rpx;
  color: #333;
  box-sizing: border-box;
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
  border-color: #007aff;
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
  background-color: rgba(255, 77, 79, 0.1);
  color: #ff4d4f;
  padding: 15rpx 20rpx;
  border-radius: 12rpx;
  margin-bottom: 25rpx;
  border-left: 4rpx solid #ff4d4f;
  font-size: 26rpx;
}

.register-btn {
  width: 100%;
  height: 75rpx;
  background: linear-gradient(135deg, #007aff, #00c6ff);
  color: white;
  border: none;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: bold;
  margin-bottom: 25rpx;
  box-shadow: 0 8rpx 20rpx rgba(0, 122, 255, 0.3);
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.register-btn:active {
  transform: translateY(2rpx);
  box-shadow: 0 6rpx 15rpx rgba(0, 122, 255, 0.4);
}

.register-btn[disabled] {
  opacity: 0.6;
  transform: none;
}

.login-link {
  text-align: center;
  color: #007aff;
  font-size: 26rpx;
}

.login-link text:active {
  opacity: 0.7;
}
</style> 