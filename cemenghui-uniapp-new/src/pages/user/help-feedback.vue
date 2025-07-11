<template>
  <view class="container">
    <view class="header">
      <text class="title">帮助与反馈</text>
    </view>
    
    <!-- 常见问题 -->
    <view class="help-section">
      <text class="section-title">常见问题</text>
      <view class="faq-list">
        <view class="faq-item" v-for="(faq, index) in faqs" :key="index" @click="toggleFaq(index)">
          <view class="faq-question">
            <text class="question-text">{{ faq.question }}</text>
            <text class="expand-icon" :class="{ expanded: faq.expanded }">></text>
          </view>
          <view v-if="faq.expanded" class="faq-answer">
            <text class="answer-text">{{ faq.answer }}</text>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 联系客服 -->
    <view class="contact-section">
      <text class="section-title">联系客服</text>
      <view class="contact-list">
        <view class="contact-item" @click="callService">
          <text class="contact-icon">📞</text>
          <view class="contact-content">
            <text class="contact-title">电话客服</text>
            <text class="contact-desc">400-123-4567 (工作日 9:00-18:00)</text>
          </view>
          <text class="arrow">></text>
        </view>
        <view class="contact-item" @click="openWechat">
          <text class="contact-icon">💬</text>
          <view class="contact-content">
            <text class="contact-title">微信客服</text>
            <text class="contact-desc">cemenghui_service</text>
          </view>
          <text class="arrow">></text>
        </view>
        <view class="contact-item" @click="sendEmail">
          <text class="contact-icon">📧</text>
          <view class="contact-content">
            <text class="contact-title">邮箱反馈</text>
            <text class="contact-desc">service@cemenghui.com</text>
          </view>
          <text class="arrow">></text>
        </view>
      </view>
    </view>
    
    <!-- 意见反馈 -->
    <view class="feedback-section">
      <text class="section-title">意见反馈</text>
      <view class="feedback-form">
        <view class="form-item">
          <text class="form-label">反馈类型</text>
          <picker @change="onTypeChange" :value="typeIndex" :range="feedbackTypes">
            <view class="picker-input">
              <text class="picker-text">{{ feedbackTypes[typeIndex] }}</text>
              <text class="picker-arrow">></text>
            </view>
          </picker>
        </view>
        
        <view class="form-item">
          <text class="form-label">问题描述</text>
          <textarea class="feedback-textarea" 
                    v-model="feedbackContent" 
                    placeholder="请详细描述您遇到的问题或建议..."
                    maxlength="500"></textarea>
          <text class="char-count">{{ feedbackContent.length }}/500</text>
        </view>
        
        <view class="form-item">
          <text class="form-label">联系方式</text>
          <input class="contact-input" 
                 v-model="contactInfo" 
                 placeholder="请留下您的手机号或邮箱，方便我们联系您" />
        </view>
        
        <view class="form-item">
          <text class="form-label">图片上传</text>
          <view class="image-upload">
            <view class="image-list">
              <view class="image-item" v-for="(image, index) in uploadedImages" :key="index">
                <image :src="image" class="uploaded-image" mode="aspectFill" @click="previewImage(index)"></image>
                <text class="delete-btn" @click="deleteImage(index)">×</text>
              </view>
              <view v-if="uploadedImages.length < 3" class="add-image" @click="chooseImage">
                <text class="add-icon">+</text>
                <text class="add-text">添加图片</text>
              </view>
            </view>
            <text class="upload-tip">最多上传3张图片，每张不超过5MB</text>
          </view>
        </view>
        
        <button class="submit-btn" @click="submitFeedback" :disabled="!canSubmit">提交反馈</button>
      </view>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'

export default {
  data() {
    return {
      faqs: [
        {
          question: '如何注册账号？',
          answer: '点击登录页面的"注册"按钮，填写手机号、验证码和密码即可完成注册。',
          expanded: false
        },
        {
          question: '忘记密码怎么办？',
          answer: '在登录页面点击"忘记密码"，输入注册时的手机号，通过短信验证码重置密码。',
          expanded: false
        },
        {
          question: '如何报名课程？',
          answer: '浏览课程详情页面，点击"立即学习"或"报名"按钮即可报名参加课程。',
          expanded: false
        },
        {
          question: '会议报名后如何取消？',
          answer: '在"我的会议"页面找到对应会议，点击"取消报名"按钮即可取消。',
          expanded: false
        },
        {
          question: '如何修改个人信息？',
          answer: '进入"我的"页面，点击"个人资料"即可修改昵称、邮箱等个人信息。',
          expanded: false
        }
      ],
      feedbackTypes: ['功能建议', '问题反馈', '界面优化', '性能问题', '其他'],
      typeIndex: 0,
      feedbackContent: '',
      contactInfo: '',
      uploadedImages: []
    }
  },
  computed: {
    canSubmit() {
      return this.feedbackContent.trim().length > 10
    }
  },
  methods: {
    toggleFaq(index) {
      this.faqs[index].expanded = !this.faqs[index].expanded
    },
    
    callService() {
      uni.makePhoneCall({
        phoneNumber: '400-123-4567',
        fail: () => {
          uni.showToast({
            title: '拨号失败',
            icon: 'none'
          })
        }
      })
    },
    
    openWechat() {
      uni.setClipboardData({
        data: 'cemenghui_service',
        success: () => {
          uni.showToast({
            title: '微信号已复制',
            icon: 'success'
          })
        }
      })
    },
    
    sendEmail() {
      uni.setClipboardData({
        data: 'service@cemenghui.com',
        success: () => {
          uni.showToast({
            title: '邮箱地址已复制',
            icon: 'success'
          })
        }
      })
    },
    
    onTypeChange(e) {
      this.typeIndex = e.detail.value
    },
    
    chooseImage() {
      uni.chooseImage({
        count: 3 - this.uploadedImages.length,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res) => {
          this.uploadedImages.push(...res.tempFilePaths)
        }
      })
    },
    
    previewImage(index) {
      uni.previewImage({
        urls: this.uploadedImages,
        current: index
      })
    },
    
    deleteImage(index) {
      this.uploadedImages.splice(index, 1)
    },
    
    async submitFeedback() {
      if (!this.canSubmit) {
        uni.showToast({
          title: '请填写详细的问题描述',
          icon: 'none'
        })
        return
      }
      
      try {
        uni.showLoading({
          title: '提交中...'
        })
        
        const feedbackData = {
          type: this.feedbackTypes[this.typeIndex],
          content: this.feedbackContent,
          contact: this.contactInfo,
          images: this.uploadedImages
        }
        
        console.log('提交反馈数据:', feedbackData)
        
        const response = await api.submitFeedback(feedbackData)
        console.log('反馈提交响应:', response)
        
        if (response.code === 200) {
          uni.hideLoading()
          uni.showModal({
            title: '提交成功',
            content: '感谢您的反馈！我们会在24小时内处理您的问题。',
            showCancel: false,
            success: () => {
              // 清空表单
              this.feedbackContent = ''
              this.contactInfo = ''
              this.uploadedImages = []
              this.typeIndex = 0
            }
          })
        } else {
          uni.hideLoading()
          uni.showToast({
            title: response.message || '提交失败',
            icon: 'none'
          })
        }
        
      } catch (error) {
        uni.hideLoading()
        console.error('提交反馈失败:', error)
        uni.showToast({
          title: error.message || '提交失败，请重试',
          icon: 'none'
        })
      }
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
  padding: 20rpx 0 30rpx;
}

.title {
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
}

.help-section, .contact-section, .feedback-section {
  margin-bottom: 30rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  display: block;
}

.faq-list, .contact-list {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
}

.faq-item {
  border-bottom: 1rpx solid #f0f0f0;
}

.faq-item:last-child {
  border-bottom: none;
}

.faq-question {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 30rpx;
}

.question-text {
  font-size: 28rpx;
  color: #333;
  flex: 1;
}

.expand-icon {
  font-size: 24rpx;
  color: #666;
  transform: rotate(0deg);
  transition: transform 0.3s ease;
}

.expand-icon.expanded {
  transform: rotate(90deg);
}

.faq-answer {
  padding: 0 30rpx 30rpx;
  border-top: 1rpx solid #f8f8f8;
}

.answer-text {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
}

.contact-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.contact-item:last-child {
  border-bottom: none;
}

.contact-icon {
  font-size: 40rpx;
  margin-right: 20rpx;
}

.contact-content {
  flex: 1;
}

.contact-title {
  font-size: 28rpx;
  color: #333;
  display: block;
  margin-bottom: 6rpx;
}

.contact-desc {
  font-size: 24rpx;
  color: #666;
  display: block;
}

.arrow {
  font-size: 24rpx;
  color: #ccc;
}

.feedback-form {
  background-color: white;
  border-radius: 12rpx;
  padding: 30rpx;
}

.form-item {
  margin-bottom: 30rpx;
}

.form-item:last-child {
  margin-bottom: 0;
}

.form-label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 15rpx;
  display: block;
}

.picker-input {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx;
  border: 1rpx solid #e0e0e0;
  border-radius: 8rpx;
  background-color: #fafafa;
}

.picker-text {
  font-size: 26rpx;
  color: #333;
}

.picker-arrow {
  font-size: 24rpx;
  color: #ccc;
}

.feedback-textarea {
  width: 100%;
  min-height: 200rpx;
  padding: 20rpx;
  border: 1rpx solid #e0e0e0;
  border-radius: 8rpx;
  font-size: 26rpx;
  color: #333;
  line-height: 1.6;
  box-sizing: border-box;
}

.char-count {
  font-size: 22rpx;
  color: #999;
  text-align: right;
  margin-top: 10rpx;
  display: block;
}

.contact-input {
  width: 100%;
  padding: 20rpx;
  border: 1rpx solid #e0e0e0;
  border-radius: 8rpx;
  font-size: 26rpx;
  color: #333;
  box-sizing: border-box;
}

.image-upload {
  margin-top: 15rpx;
}

.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
}

.image-item {
  position: relative;
  width: 150rpx;
  height: 150rpx;
}

.uploaded-image {
  width: 100%;
  height: 100%;
  border-radius: 8rpx;
}

.delete-btn {
  position: absolute;
  top: -10rpx;
  right: -10rpx;
  width: 40rpx;
  height: 40rpx;
  background-color: #ff4757;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24rpx;
  font-weight: bold;
}

.add-image {
  width: 150rpx;
  height: 150rpx;
  border: 2rpx dashed #ddd;
  border-radius: 8rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #fafafa;
}

.add-icon {
  font-size: 40rpx;
  color: #999;
  margin-bottom: 10rpx;
  display: block;
}

.add-text {
  font-size: 22rpx;
  color: #999;
}

.upload-tip {
  font-size: 22rpx;
  color: #999;
  margin-top: 15rpx;
  display: block;
}

.submit-btn {
  width: 100%;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 32rpx;
  border: none;
  border-radius: 40rpx;
  margin-top: 40rpx;
}

.submit-btn:disabled {
  background-color: #ccc;
  color: #999;
}
</style> 