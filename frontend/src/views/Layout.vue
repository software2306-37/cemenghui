<template>
  <div class="layout-container">
    <el-container>
      <!-- 侧边栏 -->
      <el-aside width="200px" class="sidebar">
        <div class="logo">
          <h3>测盟汇系统</h3>
        </div>
        <el-menu
          :default-active="$route.path"
          router
          background-color="#545c64"
          text-color="#fff"
          active-text-color="#ffd04b"
        >
          <el-menu-item index="/dashboard">
            <el-icon><House /></el-icon>
            <span>首页</span>
          </el-menu-item>
          
          <el-menu-item v-if="user.role === 'ADMIN'" index="/users">
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </el-menu-item>
          
          <el-menu-item index="/news">
            <el-icon><Document /></el-icon>
            <span>动态管理</span>
          </el-menu-item>
          
          <el-menu-item index="/courses">
            <el-icon><VideoPlay /></el-icon>
            <span>课程管理</span>
          </el-menu-item>
          
          <el-menu-item index="/meetings">
            <el-icon><Calendar /></el-icon>
            <span>会议管理</span>
          </el-menu-item>
          
          <el-menu-item v-if="user.role === 'ADMIN'" index="/tenants">
            <el-icon><OfficeBuilding /></el-icon>
            <span>租户管理</span>
          </el-menu-item>
          
          <el-menu-item index="/profile">
            <el-icon><Setting /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <!-- 主内容区域 -->
      <el-container>
        <!-- 头部 -->
        <el-header class="header">
          <div class="header-left">
            <span class="page-title">{{ $route.meta.title || '首页' }}</span>
          </div>
          <div class="header-right">
            <el-dropdown @command="handleCommand">
              <span class="user-info">
                <el-avatar :size="32" :src="getImageUrl(user.avatar)">
                  {{ user.nickname || user.username }}
                </el-avatar>
                <span class="username">{{ user.nickname || user.username }}</span>
                <el-icon><ArrowDown /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                  <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-header>

        <!-- 主内容 -->
        <el-main class="main-content">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../utils/request'

const router = useRouter()

const user = ref({})
let userUpdateHandler = null

onMounted(async () => {
  // 优先从服务器获取最新用户信息
  try {
    const userRes = await request.get('/user/current')
    if (userRes.code === 200) {
      user.value = userRes.data
      localStorage.setItem('user', JSON.stringify(userRes.data))
    }
  } catch (error) {
    // 如果服务器请求失败，则从本地存储获取
    console.error('获取用户信息失败，使用本地缓存:', error)
    const userStr = localStorage.getItem('user')
    if (userStr) {
      user.value = JSON.parse(userStr)
    }
  }
  
  // 监听用户信息更新事件
  userUpdateHandler = (event) => {
    user.value = event.detail
  }
  window.addEventListener('userUpdated', userUpdateHandler)
})

onUnmounted(() => {
  if (userUpdateHandler) {
    window.removeEventListener('userUpdated', userUpdateHandler)
  }
})

const handleCommand = async (command) => {
  if (command === 'profile') {
    router.push('/profile')
  } else if (command === 'logout') {
    try {
      await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      
      await request.post('/user/logout')
      localStorage.removeItem('user')
      ElMessage.success('退出成功')
      router.push('/login')
    } catch (error) {
      if (error !== 'cancel') {
        console.error('退出失败:', error)
      }
    }
  }
}

const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) return imagePath
  return `http://localhost:8080/api${imagePath}`
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
  display: flex;
}

.sidebar {
  width: 200px;
  background-color: #545c64;
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden; /* 关键点1：防止外部滚动 */
}

.logo {
  height: 60px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  border-bottom: 1px solid #434a50;
}

.el-menu {
  flex: 1;
  overflow-y: auto;
  border-right: none !important;
  background-color: inherit !important; /* 关键点2：继承背景色 */
}

/* 滚动条样式定制 */
.el-menu::-webkit-scrollbar {
  width: 6px;
}

.el-menu::-webkit-scrollbar-thumb {
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.el-menu::-webkit-scrollbar-track {
  background-color: #545c64; /* 关键点3：轨道颜色与侧边栏一致 */
}

.header {
  background-color: white;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.page-title {
  font-size: 18px;
  font-weight: 500;
  color: #333;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 5px 10px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background-color: #f5f5f5;
}

.username {
  margin: 0 8px;
  color: #333;
}

.main-content {
  background-color: #f5f5f5;
  padding: 20px;
}
</style>