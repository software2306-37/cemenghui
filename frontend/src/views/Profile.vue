<template>
	<div class="profile">
	    <el-row :gutter="20">
	      <el-col :span="8">
	        <el-card>
	          <template #header>
	            <span>个人信息</span>
	          </template>
	          <div class="user-info">
	            <el-avatar :size="80" :src="getImageUrl(user.avatar)">
	              {{ user.nickname || user.username }}
	            </el-avatar>
	            <el-upload
	              class="avatar-uploader"
	              :action="uploadUrl"
	              :show-file-list="false"
	              :on-success="handleAvatarSuccess"
	              :before-upload="beforeAvatarUpload"
	            >
	              <el-button size="small" type="text">更换头像</el-button>
	            </el-upload>
	            <h3>{{ user.nickname || user.username }}</h3>
	            <p>{{ user.role === 'ADMIN' ? '超级管理员' : '企业用户' }}</p>
	            <p>{{ user.companyName }}</p>
	            <p>注册时间：{{ user.createTime }}</p>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="16">
	        <el-card>
	          <template #header>
	            <span>修改资料</span>
	          </template>
	          <el-form :model="profileForm" ref="profileFormRef" label-width="100px">
	            <el-form-item label="用户名">
	              <el-input v-model="profileForm.username" disabled />
	            </el-form-item>
	            <el-form-item label="昵称">
	              <el-input v-model="profileForm.nickname" placeholder="请输入昵称" />
	            </el-form-item>
	            <el-form-item label="手机号">
	              <el-input v-model="profileForm.phone" />
	            </el-form-item>
	            <el-form-item label="邮箱">
	              <el-input v-model="profileForm.email" />
	            </el-form-item>
	            <el-form-item label="性别">
	              <el-select v-model="profileForm.gender" style="width: 200px">
	                <el-option label="未知" :value="0" />
	                <el-option label="男" :value="1" />
	                <el-option label="女" :value="2" />
	              </el-select>
	            </el-form-item>
	            <el-form-item label="企业名称">
	              <el-input v-model="profileForm.companyName" />
	            </el-form-item>
	            <el-form-item>
	              <el-button type="primary" @click="updateProfile" :loading="updating">保存修改</el-button>
	            </el-form-item>
	          </el-form>
	        </el-card>
	
	        <el-card style="margin-top: 20px;">
	          <template #header>
	            <span>修改密码</span>
	          </template>
	          <el-form :model="passwordForm" ref="passwordFormRef" label-width="100px">
	            <el-form-item label="原密码">
	              <el-input v-model="passwordForm.oldPassword" type="password" show-password />
	            </el-form-item>
	            <el-form-item label="新密码">
	              <el-input v-model="passwordForm.newPassword" type="password" show-password />
	            </el-form-item>
	            <el-form-item label="确认密码">
	              <el-input v-model="passwordForm.confirmPassword" type="password" show-password />
	            </el-form-item>
	            <el-form-item>
	              <el-button type="primary" @click="changePassword" :loading="changingPassword">修改密码</el-button>
	            </el-form-item>
	          </el-form>
	        </el-card>
	      </el-col>
	    </el-row>
	  </div>
</template>

<script setup>
	import { ref, reactive, onMounted } from 'vue'
	import { ElMessage } from 'element-plus'
	import request from '../utils/request'
	
	const user = ref({})
	const updating = ref(false)
	const changingPassword = ref(false)
	const uploadUrl = ref('/api/file/upload')
	
	const profileForm = reactive({
	  username: '',
	  nickname: '',
	  phone: '',
	  email: '',
	  gender: 0,
	  companyName: ''
	})
	
	const passwordForm = reactive({
	  oldPassword: '',
	  newPassword: '',
	  confirmPassword: ''
	})
	
	const profileFormRef = ref()
	const passwordFormRef = ref()
	
	onMounted(() => {
	  loadUserInfo()
	})
	
	const loadUserInfo = async () => {
	  try {
	    // 优先从服务器获取最新用户信息
	    const userRes = await request.get('/user/current')
	    if (userRes.code === 200) {
	      user.value = userRes.data
	      localStorage.setItem('user', JSON.stringify(userRes.data))
	      Object.assign(profileForm, userRes.data)
	    }
	  } catch (error) {
	    // 如果服务器请求失败，则从本地存储获取
	    console.error('获取用户信息失败，使用本地缓存:', error)
	    const userStr = localStorage.getItem('user')
	    if (userStr) {
	      user.value = JSON.parse(userStr)
	      Object.assign(profileForm, user.value)
	    }
	  }
	}
	
	const updateProfile = async () => {
	  updating.value = true
	  try {
	    await request.put('/user/profile', profileForm)
	    ElMessage.success('更新成功')
	    // 重新获取用户信息以确保数据同步
	    const userRes = await request.get('/user/current')
	    if (userRes.code === 200) {
	      user.value = userRes.data
	      localStorage.setItem('user', JSON.stringify(userRes.data))
	      Object.assign(profileForm, userRes.data)
	      // 触发全局事件通知其他组件更新用户信息
	      window.dispatchEvent(new CustomEvent('userUpdated', { detail: userRes.data }))
	    }
	  } catch (error) {
	    console.error('更新个人信息失败:', error)
	  } finally {
	    updating.value = false
	  }
	}
	
	const changePassword = async () => {
	  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
	    ElMessage.error('两次输入的密码不一致')
	    return
	  }
	  
	  if (passwordForm.newPassword.length < 6) {
	    ElMessage.error('密码长度不能少于6位')
	    return
	  }
	
	  changingPassword.value = true
	  try {
	    await request.post('/user/changePassword', {
	      oldPassword: passwordForm.oldPassword,
	      newPassword: passwordForm.newPassword
	    })
	    ElMessage.success('密码修改成功')
	    // 清空密码表单
	    Object.assign(passwordForm, {
	      oldPassword: '',
	      newPassword: '',
	      confirmPassword: ''
	    })
	  } catch (error) {
	    console.error('修改密码失败:', error)
	  } finally {
	    changingPassword.value = false
	  }
	}
	
	const handleAvatarSuccess = async (response) => {
	  if (response.code === 200) {
	    // 更新头像
	    try {
	      await request.put('/user/profile', { avatar: response.data })
	      // 重新获取用户信息以确保数据同步
	      const userRes = await request.get('/user/current')
	      if (userRes.code === 200) {
	        user.value = userRes.data
	        localStorage.setItem('user', JSON.stringify(userRes.data))
	        // 触发全局事件通知其他组件更新用户信息
	        window.dispatchEvent(new CustomEvent('userUpdated', { detail: userRes.data }))
	      }
	      ElMessage.success('头像更新成功')
	    } catch (error) {
	      console.error('更新头像失败:', error)
	    }
	  } else {
	    ElMessage.error('头像上传失败')
	  }
	}
	
	const beforeAvatarUpload = (file) => {
	  const isImage = file.type.indexOf('image/') === 0
	  const isLt2M = file.size / 1024 / 1024 < 2
	
	  if (!isImage) {
	    ElMessage.error('只能上传图片文件!')
	    return false
	  }
	  if (!isLt2M) {
	    ElMessage.error('图片大小不能超过 2MB!')
	    return false
	  }
	  return true
	}
	
	const getImageUrl = (imagePath) => {
	  if (!imagePath) return ''
	  if (imagePath.startsWith('http')) return imagePath
	  return `http://localhost:8080/api${imagePath}`
	}
</script>

<style scoped>
	.user-info {
	  text-align: center;
	  padding: 20px;
	}
	
	.user-info h3 {
	  margin: 15px 0 5px 0;
	  color: #333;
	}
	
	.user-info p {
	  margin: 5px 0;
	  color: #666;
	}
	
	.avatar-uploader {
	  margin: 10px 0;
	}
</style>