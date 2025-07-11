<template>
  <view class="container">
    <view class="header">
      <text class="title">系统设置</text>
    </view>
    
    <!-- 通知设置 -->
    <view class="setting-section">
      <text class="section-title">通知设置</text>
      <view class="setting-item">
        <text class="setting-label">新闻推送</text>
        <switch :checked="settings.newsNotification" @change="onNewsNotificationChange" />
      </view>
      <view class="setting-item">
        <text class="setting-label">课程更新</text>
        <switch :checked="settings.courseNotification" @change="onCourseNotificationChange" />
      </view>
      <view class="setting-item">
        <text class="setting-label">会议提醒</text>
        <switch :checked="settings.meetingNotification" @change="onMeetingNotificationChange" />
      </view>
    </view>
    
    <!-- 显示设置 -->
    <view class="setting-section">
      <text class="section-title">显示设置</text>
      <view class="setting-item" @click="showFontSizePicker">
        <text class="setting-label">字体大小</text>
        <view class="setting-value">
          <text class="value-text">{{ getFontSizeText() }}</text>
          <text class="arrow">></text>
        </view>
      </view>
      <view class="setting-item">
        <text class="setting-label">夜间模式</text>
        <switch :checked="settings.darkMode" @change="onDarkModeChange" />
      </view>
    </view>
    
    <!-- 隐私设置 -->
    <view class="setting-section">
      <text class="section-title">隐私设置</text>
      <view class="setting-item">
        <text class="setting-label">允许数据统计</text>
        <switch :checked="settings.dataAnalytics" @change="onDataAnalyticsChange" />
      </view>
      <view class="setting-item">
        <text class="setting-label">个人信息保护</text>
        <switch :checked="settings.privacyProtection" @change="onPrivacyProtectionChange" />
      </view>
    </view>
    
    <!-- 缓存设置 -->
    <view class="setting-section">
      <text class="section-title">存储管理</text>
      <view class="setting-item" @click="showCacheInfo">
        <text class="setting-label">缓存大小</text>
        <view class="setting-value">
          <text class="value-text">{{ cacheSize }}</text>
          <text class="arrow">></text>
        </view>
      </view>
      <view class="setting-item" @click="clearCache">
        <text class="setting-label">清理缓存</text>
        <view class="setting-value">
          <text class="clear-text">清理</text>
        </view>
      </view>
    </view>
    
    <!-- 其他设置 -->
    <view class="setting-section">
      <text class="section-title">其他</text>
      <view class="setting-item" @click="checkUpdate">
        <text class="setting-label">检查更新</text>
        <view class="setting-value">
          <text class="value-text">v1.0.0</text>
          <text class="arrow">></text>
        </view>
      </view>
      <view class="setting-item" @click="showLanguagePicker">
        <text class="setting-label">语言设置</text>
        <view class="setting-value">
          <text class="value-text">简体中文</text>
          <text class="arrow">></text>
        </view>
      </view>
    </view>
    
    <!-- 字体大小选择器 -->
    <picker-view v-if="showFontPicker" 
                 class="font-picker" 
                 :value="[fontSizeIndex]" 
                 @change="onFontSizeChange">
      <picker-view-column>
        <view v-for="(size, index) in fontSizes" :key="index" class="picker-item">
          {{ size.label }}
        </view>
      </picker-view-column>
    </picker-view>
    
    <!-- 遮罩层 -->
    <view v-if="showFontPicker" class="picker-mask" @click="hideFontSizePicker"></view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      settings: {
        newsNotification: true,
        courseNotification: true,
        meetingNotification: true,
        darkMode: false,
        dataAnalytics: true,
        privacyProtection: true,
        fontSize: 'medium'
      },
      cacheSize: '12.5MB',
      showFontPicker: false,
      fontSizes: [
        { value: 'small', label: '小' },
        { value: 'medium', label: '中' },
        { value: 'large', label: '大' }
      ],
      fontSizeIndex: 1
    }
  },
  onLoad() {
    this.loadSettings()
  },
  methods: {
    loadSettings() {
      // 从本地存储加载设置
      const savedSettings = uni.getStorageSync('appSettings')
      if (savedSettings) {
        this.settings = { ...this.settings, ...savedSettings }
      }
      
      // 设置字体大小索引
      const fontIndex = this.fontSizes.findIndex(size => size.value === this.settings.fontSize)
      this.fontSizeIndex = fontIndex > -1 ? fontIndex : 1
    },
    
    saveSettings() {
      // 保存设置到本地存储
      uni.setStorageSync('appSettings', this.settings)
      uni.showToast({
        title: '设置已保存',
        icon: 'success',
        duration: 1500
      })
    },
    
    onNewsNotificationChange(e) {
      this.settings.newsNotification = e.detail.value
      this.saveSettings()
    },
    
    onCourseNotificationChange(e) {
      this.settings.courseNotification = e.detail.value
      this.saveSettings()
    },
    
    onMeetingNotificationChange(e) {
      this.settings.meetingNotification = e.detail.value
      this.saveSettings()
    },
    
    onDarkModeChange(e) {
      this.settings.darkMode = e.detail.value
      this.saveSettings()
      
      // 这里可以添加切换主题的逻辑
      if (e.detail.value) {
        uni.showToast({
          title: '夜间模式功能开发中',
          icon: 'none'
        })
      }
    },
    
    onDataAnalyticsChange(e) {
      this.settings.dataAnalytics = e.detail.value
      this.saveSettings()
    },
    
    onPrivacyProtectionChange(e) {
      this.settings.privacyProtection = e.detail.value
      this.saveSettings()
    },
    
    showFontSizePicker() {
      this.showFontPicker = true
    },
    
    hideFontSizePicker() {
      this.showFontPicker = false
    },
    
    onFontSizeChange(e) {
      this.fontSizeIndex = e.detail.value[0]
      this.settings.fontSize = this.fontSizes[this.fontSizeIndex].value
      this.saveSettings()
      this.hideFontSizePicker()
    },
    
    getFontSizeText() {
      const fontSize = this.fontSizes.find(size => size.value === this.settings.fontSize)
      return fontSize ? fontSize.label : '中'
    },
    
    showCacheInfo() {
      uni.showModal({
        title: '缓存信息',
        content: `当前缓存大小：${this.cacheSize}\n\n包括图片缓存、数据缓存等`,
        showCancel: false,
        confirmText: '确定'
      })
    },
    
    clearCache() {
      uni.showModal({
        title: '清理缓存',
        content: '确定要清理所有缓存数据吗？这将删除已下载的图片和临时数据。',
        success: (res) => {
          if (res.confirm) {
            // 模拟清理缓存
            uni.showLoading({
              title: '清理中...'
            })
            
            setTimeout(() => {
              uni.hideLoading()
              this.cacheSize = '0.8MB'
              uni.showToast({
                title: '缓存清理完成',
                icon: 'success'
              })
            }, 2000)
          }
        }
      })
    },
    
    checkUpdate() {
      uni.showLoading({
        title: '检查更新中...'
      })
      
      setTimeout(() => {
        uni.hideLoading()
        uni.showModal({
          title: '检查更新',
          content: '当前已是最新版本 v1.0.0',
          showCancel: false,
          confirmText: '确定'
        })
      }, 1500)
    },
    
    showLanguagePicker() {
      uni.showActionSheet({
        itemList: ['简体中文', 'English'],
        success: (res) => {
          if (res.tapIndex === 1) {
            uni.showToast({
              title: '英文版本开发中',
              icon: 'none'
            })
          }
        }
      })
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

.setting-section {
  background-color: white;
  border-radius: 12rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
}

.section-title {
  font-size: 26rpx;
  color: #666;
  padding: 30rpx 30rpx 20rpx;
  display: block;
  font-weight: bold;
}

.setting-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.setting-item:last-child {
  border-bottom: none;
}

.setting-label {
  font-size: 28rpx;
  color: #333;
}

.setting-value {
  display: flex;
  align-items: center;
}

.value-text {
  font-size: 26rpx;
  color: #666;
  margin-right: 10rpx;
}

.clear-text {
  font-size: 26rpx;
  color: #007aff;
}

.arrow {
  font-size: 24rpx;
  color: #ccc;
}

.font-picker {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 400rpx;
  background-color: white;
  z-index: 1000;
  border-top: 1rpx solid #e0e0e0;
}

.picker-item {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 80rpx;
  font-size: 28rpx;
  color: #333;
}

.picker-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}
</style> 