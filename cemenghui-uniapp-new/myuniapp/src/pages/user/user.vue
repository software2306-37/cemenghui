<template>
  <view class="container">
    <view class="user-header">
      <view class="avatar-section">
        <image class="avatar" :src="getAvatarUrl(userInfo.avatar)" mode="aspectFill"></image>
      </view>
      <view class="user-info">
        <text class="username">{{ userInfo.username || '未登录' }}</text>
        <text class="email">{{ userInfo.email || '请先登录' }}</text>
        <text class="role" v-if="userInfo.role">{{ getRoleText(userInfo.role) }}</text>
      </view>
      <button v-if="!userInfo.id" class="login-btn" @click="goToLogin">登录</button>
      <button v-else class="edit-btn" @click="goToProfile">编辑资料</button>
    </view>
    
    <view class="stats-section" v-if="userInfo.id">
      <view class="stat-item" @click="goToMyCourses">
        <text class="stat-number">{{ userStats.courseCount || 0 }}</text>
        <text class="stat-label">我的课程</text>
      </view>
      <view class="stat-item" @click="goToMyMeetings">
        <text class="stat-number">{{ userStats.meetingCount || 0 }}</text>
        <text class="stat-label">参与会议</text>
      </view>
      <view class="stat-item" @click="goToMyFavorites">
        <text class="stat-number">{{ userStats.favoriteCount || 0 }}</text>
        <text class="stat-label">收藏内容</text>
      </view>
    </view>
    
    <view class="menu-section">
      <view class="menu-item" @click="goToProfile">
        <text class="menu-icon">👤</text>
        <text class="menu-text">个人资料</text>
        <text class="menu-arrow">></text>
      </view>
      <view class="menu-item" @click="goToMyCourses">
        <text class="menu-icon">📚</text>
        <text class="menu-text">我的课程</text>
        <text class="menu-arrow">></text>
      </view>
      <view class="menu-item" @click="goToMyMeetings">
        <text class="menu-icon">🤝</text>
        <text class="menu-text">我的会议</text>
        <text class="menu-arrow">></text>
      </view>
      <view class="menu-item" @click="goToMyFavorites">
        <text class="menu-icon">❤️</text>
        <text class="menu-text">我的收藏</text>
        <text class="menu-arrow">></text>
      </view>
    </view>
    
    <view class="menu-section">
      <view class="menu-item" @click="goToSettings">
        <text class="menu-icon">⚙️</text>
        <text class="menu-text">系统设置</text>
        <text class="menu-arrow">></text>
      </view>
      <view class="menu-item" @click="goToHelpFeedback">
        <text class="menu-icon">❓</text>
        <text class="menu-text">帮助与反馈</text>
        <text class="menu-arrow">></text>
      </view>
      <view class="menu-item" @click="showAbout">
        <text class="menu-icon">ℹ️</text>
        <text class="menu-text">关于我们</text>
        <text class="menu-arrow">></text>
      </view>
    </view>
    
    <view v-if="userInfo.id" class="logout-section">
      <button class="logout-btn" @click="logout">退出登录</button>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { getUserInfo, setUserInfo, clearUserInfo, getAvatarUrl } from '../../utils/common'

export default {
  data() {
    return {
      userInfo: {},
      userStats: {
        courseCount: 0,
        meetingCount: 0,
        newsCount: 0,
        favoriteCount: 0
      }
    }
  },
  onLoad() {
    this.loadUserInfo()
  },
  onShow() {
    this.loadUserInfo()
  },
  methods: {
    async loadUserInfo() {
      const userInfo = uni.getStorageSync('userInfo')
      console.log('加载用户信息:', userInfo)
      
      if (userInfo && userInfo.id) {
        this.userInfo = userInfo
        // 加载用户统计数据
        await this.loadUserStats()
      } else {
        this.userInfo = {}
        this.userStats = {
          courseCount: 0,
          meetingCount: 0,
          newsCount: 0,
          favoriteCount: 0
        }
      }
    },
    
    async loadUserStats() {
      try {
        // 检查用户是否已登录
        if (!this.userInfo || !this.userInfo.id) {
          console.log('用户未登录，跳过统计数据加载')
          this.userStats = {
            courseCount: 0,
            meetingCount: 0,
            newsCount: 0,
            favoriteCount: 0
          }
          return
        }
        
        const response = await api.getUserStats()
        console.log('用户统计数据响应:', response)
        if (response && response.code === 200 && response.data) {
          this.userStats = response.data
          console.log('设置统计数据:', this.userStats)
        } else {
          console.log('获取统计数据失败:', response?.message || '无响应数据')
          this.userStats = {
            courseCount: 0,
            meetingCount: 0,
            newsCount: 0,
            favoriteCount: 0
          }
        }
      } catch (error) {
        console.error('获取用户统计失败:', error)
        
        // 如果是登录相关错误，不在这里处理，让request.js统一处理
        if (error.message === '未登录') {
          console.log('统计接口返回未登录，但不跳转登录页')
          return
        }
        
        // 保持默认值
        this.userStats = {
          courseCount: 0,
          meetingCount: 0,
          newsCount: 0,
          favoriteCount: 0
        }
      }
    },
    
    goToLogin() {
      uni.navigateTo({
        url: '/pages/login/login'
      })
    },
    
    async logout() {
      try {
        await api.logout()
      } catch (error) {
        console.error('退出登录失败:', error)
      } finally {
        // 清除本地存储
        uni.removeStorageSync('userInfo')
        uni.removeStorageSync('sessionId')
        clearUserInfo()
        
        uni.showToast({
          title: '已退出登录',
          icon: 'success'
        })
        
        // 跳转到登录页
        setTimeout(() => {
          uni.navigateTo({
            url: '/pages/login/login'
          })
        }, 1500)
      }
    },
    
    goToProfile() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/profile'
      })
    },
    
    getRoleText(role) {
      const roleMap = {
        'ADMIN': '管理员',
        'USER': '普通用户'
      }
      return roleMap[role] || '未知'
    },
    
    getAvatarUrl(avatar) {
      return getAvatarUrl(avatar)
    },
    
    goToMyCourses() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/my-courses'
      })
    },
    
    goToMyMeetings() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/my-meetings'
      })
    },
    
    goToMyFavorites() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/my-favorites'
      })
    },
    
    goToSettings() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/settings'
      })
    },
    
    goToHelpFeedback() {
      if (!this.checkLogin()) return
      uni.navigateTo({
        url: '/pages/user/help-feedback'
      })
    },
    
    checkLogin() {
      if (!this.userInfo || !this.userInfo.id) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        this.goToLogin()
        return false
      }
      return true
    },
    
    showAbout() {
      uni.showModal({
        title: '关于测盟汇',
        content: '测盟汇是专业的测试技术交流平台，致力于为测试工程师提供优质的学习资源和交流机会。\n\n版本：v1.0.0\n联系我们：support@cemenghui.com',
        showCancel: false,
        confirmText: '知道了'
      })
    }
  }
}
</script>

<style scoped>
.container {
  background-color: #f8f8f8;
  min-height: 100vh;
}

.user-header {
  background-color: white;
  padding: 40rpx 30rpx;
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.avatar-section {
  width: 120rpx;
  height: 120rpx;
  border-radius: 60rpx;
  margin-right: 30rpx;
  pointer-events: none;
}

.avatar {
  width: 100%;
  height: 100%;
  border-radius: 60rpx;
  pointer-events: none;
}

.user-info {
  flex: 1;
}

.username {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 10rpx;
}

.email {
  font-size: 26rpx;
  color: #666;
  display: block;
}

.role {
  font-size: 26rpx;
  color: #666;
  display: block;
}

.login-btn {
  width: 120rpx;
  height: 60rpx;
  background-color: #007aff;
  color: white;
  font-size: 26rpx;
  border: none;
  border-radius: 30rpx;
  line-height: 60rpx;
}

.edit-btn {
  width: 120rpx;
  height: 60rpx;
  background-color: #007aff;
  color: white;
  font-size: 26rpx;
  border: none;
  border-radius: 30rpx;
  line-height: 60rpx;
  margin-left: 20rpx;
}

.stats-section {
  background-color: white;
  padding: 30rpx;
  margin-bottom: 20rpx;
  display: flex;
}

.stat-item {
  flex: 1;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.stat-item:active {
  transform: scale(0.95);
  background-color: rgba(0, 122, 255, 0.1);
  border-radius: 10rpx;
}

.stat-number {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 10rpx;
}

.stat-label {
  font-size: 26rpx;
  color: #666;
  display: block;
}

.menu-section {
  background-color: white;
  margin-bottom: 20rpx;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-icon {
  font-size: 32rpx;
  margin-right: 20rpx;
  width: 50rpx;
}

.menu-text {
  flex: 1;
  font-size: 30rpx;
  color: #333;
}

.menu-arrow {
  font-size: 28rpx;
  color: #ccc;
}

.logout-section {
  padding: 30rpx;
}

.logout-btn {
  width: 100%;
  height: 80rpx;
  background-color: #ff4757;
  color: white;
  font-size: 30rpx;
  border: none;
  border-radius: 40rpx;
  line-height: 80rpx;
}
</style> 