<template>
  <view class="container">
    <view class="header">
      <text class="title">个人资料</text>
    </view>
    
    <view class="profile-form">
      <!-- 头像 -->
      <view class="form-item">
        <text class="label">头像</text>
        <view class="avatar-section" @click="changeAvatar">
          <image class="avatar" :src="getAvatarUrl(userInfo.avatar)" mode="aspectFill"></image>
          <view class="change-avatar-hint">
            <text class="change-text">点击更换</text>
          </view>
        </view>
      </view>
      
      <!-- 用户名 -->
      <view class="form-item">
        <text class="label">用户名</text>
        <input class="input" v-model="userInfo.username" placeholder="请输入用户名" disabled />
      </view>
      
      <!-- 昵称 -->
      <view class="form-item">
        <text class="label">昵称</text>
        <input class="input" v-model="userInfo.nickname" placeholder="请输入昵称" />
      </view>
      
      <!-- 邮箱 -->
      <view class="form-item">
        <text class="label">邮箱</text>
        <input class="input" v-model="userInfo.email" placeholder="请输入邮箱" type="email" />
      </view>
      
      <!-- 手机号 -->
      <view class="form-item">
        <text class="label">手机号</text>
        <input class="input" v-model="userInfo.phone" placeholder="请输入手机号" type="number" />
      </view>
      
      <!-- 性别 -->
      <view class="form-item">
        <text class="label">性别</text>
        <picker @change="onGenderChange" :value="genderIndex" :range="genderOptions">
          <view class="picker">
            {{ genderOptions[genderIndex] }}
          </view>
        </picker>
      </view>
      
      <!-- 公司名称 -->
      <view class="form-item">
        <text class="label">公司名称</text>
        <input class="input" v-model="userInfo.companyName" placeholder="请输入公司名称" />
      </view>
      
      <!-- 角色 -->
      <view class="form-item">
        <text class="label">账户类型</text>
        <input class="input" :value="getRoleText(userInfo.role)" disabled />
      </view>
      
      <!-- 注册时间 -->
      <view class="form-item">
        <text class="label">注册时间</text>
        <input class="input" :value="formatDateTime(userInfo.createTime)" disabled />
      </view>
    </view>
    
    <!-- 操作按钮 -->
    <view class="actions">
      <button class="save-btn" @click="saveProfile">保存修改</button>
      <button class="password-btn" @click="changePassword">修改密码</button>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'
import { getAvatarUrl, formatDateTime, setUserInfo } from '../../utils/common'

export default {
  data() {
    return {
      userInfo: {},
      genderOptions: ['未设置', '男', '女'],
      genderIndex: 0
    }
  },
  onLoad() {
    this.loadUserInfo()
  },
  methods: {
    loadUserInfo() {
      const userInfo = uni.getStorageSync('userInfo')
      if (userInfo && userInfo.id) {
        this.userInfo = { ...userInfo }
        // 设置性别选择器
        if (userInfo.gender === 1) {
          this.genderIndex = 1
        } else if (userInfo.gender === 2) {
          this.genderIndex = 2
        } else {
          this.genderIndex = 0
        }
      } else {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        setTimeout(() => {
          uni.navigateBack()
        }, 1500)
      }
    },
    
    onGenderChange(e) {
      this.genderIndex = e.detail.value
      this.userInfo.gender = parseInt(e.detail.value)
    },
    
    async saveProfile() {
      try {
        // 验证必填字段
        if (!this.userInfo.nickname || !this.userInfo.email) {
          uni.showToast({
            title: '请填写昵称和邮箱',
            icon: 'none'
          })
          return
        }
        
        // 验证邮箱格式
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(this.userInfo.email)) {
          uni.showToast({
            title: '邮箱格式不正确',
            icon: 'none'
          })
          return
        }
        
        uni.showLoading({
          title: '保存中...'
        })
        
        const response = await api.updateProfile(this.userInfo)
        console.log('个人资料更新响应:', response)
        
        uni.hideLoading()
        
        if (response && response.code === 200) {
          // 使用后端返回的用户信息更新本地存储
          if (response.data) {
            this.userInfo = { ...response.data }
            uni.setStorageSync('userInfo', response.data)
            setUserInfo(response.data)
          }
          
          uni.showToast({
            title: '保存成功',
            icon: 'success',
            duration: 2000
          })
          
          // 延迟返回上一页
          setTimeout(() => {
            uni.navigateBack()
          }, 2000)
        } else {
          uni.showToast({
            title: (response && response.message) || '保存失败',
            icon: 'none'
          })
        }
        
      } catch (error) {
        uni.hideLoading()
        console.error('保存个人资料失败:', error)
        
        // 如果是登录相关错误，不在这里处理，让request.js处理
        if (error.message === '未登录') {
          return
        }
        
        uni.showToast({
          title: '保存失败，请重试',
          icon: 'none'
        })
      }
    },
    
    changePassword() {
      uni.navigateTo({
        url: '/pages/user/change-password'
      })
    },
    
    changeAvatar() {
      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res) => {
          const tempFilePath = res.tempFilePaths[0]
          this.uploadAvatar(tempFilePath)
        }
      })
    },
    
    async uploadAvatar(filePath) {
      try {
        uni.showLoading({
          title: '上传中...'
        })
        
        const uploadResult = await api.uploadFile(filePath)
        console.log('头像上传结果:', uploadResult)
        
        // 更新头像URL
        this.userInfo.avatar = uploadResult
        
        // 立即保存到后端
        const response = await api.updateProfile(this.userInfo)
        console.log('保存头像响应:', response)
        
        if (response && response.code === 200) {
          // 使用后端返回的用户信息更新本地存储
          if (response.data) {
            this.userInfo = { ...response.data }
            uni.setStorageSync('userInfo', response.data)
            setUserInfo(response.data)
          }
          
          uni.hideLoading()
          uni.showToast({
            title: '头像更新成功',
            icon: 'success'
          })
        } else {
          uni.hideLoading()
          uni.showToast({
            title: (response && response.message) || '头像保存失败',
            icon: 'none'
          })
        }
        
      } catch (error) {
        uni.hideLoading()
        console.error('上传头像失败:', error)
        uni.showToast({
          title: error.message || '上传失败，请重试',
          icon: 'none'
        })
      }
    },
    
    getAvatarUrl(avatar) {
      return getAvatarUrl(avatar)
    },
    
    formatDateTime(dateTime) {
      return formatDateTime(dateTime, 'YYYY-MM-DD')
    },
    
    getRoleText(role) {
      const roleMap = {
        'ADMIN': '管理员',
        'USER': '普通用户',
        'TENANT': '企业用户'
      }
      return roleMap[role] || '未知'
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

.profile-form {
  background-color: white;
  border-radius: 12rpx;
  overflow: hidden;
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

.picker {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  text-align: right;
}

.avatar-section {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  cursor: pointer;
  padding: 10rpx;
  border-radius: 8rpx;
  transition: background-color 0.3s;
}

.avatar-section:active {
  background-color: #f0f0f0;
}

.avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  margin-right: 20rpx;
}

.change-avatar-hint {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.change-text {
  font-size: 26rpx;
  color: #007aff;
}

.actions {
  margin-top: 40rpx;
  padding: 0 30rpx;
}

.save-btn {
  width: 100%;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 32rpx;
  border: none;
  border-radius: 40rpx;
  margin-bottom: 20rpx;
}

.password-btn {
  width: 100%;
  height: 80rpx;
  background-color: white;
  color: #007aff;
  font-size: 32rpx;
  border: 2rpx solid #007aff;
  border-radius: 40rpx;
}
</style> 