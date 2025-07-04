<template>
	 <div class="dashboard">
	    <el-row :gutter="20">
	      <el-col :span="6">
	        <el-card class="stat-card">
	          <div class="stat-content">
	            <div class="stat-icon user-icon">
	              <el-icon><User /></el-icon>
	            </div>
	            <div class="stat-info">
	              <div class="stat-title">用户总数</div>
	              <div class="stat-number">{{ stats.userCount }}</div>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="6">
	        <el-card class="stat-card">
	          <div class="stat-content">
	            <div class="stat-icon news-icon">
	              <el-icon><Document /></el-icon>
	            </div>
	            <div class="stat-info">
	              <div class="stat-title">动态总数</div>
	              <div class="stat-number">{{ stats.newsCount }}</div>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="6">
	        <el-card class="stat-card">
	          <div class="stat-content">
	            <div class="stat-icon course-icon">
	              <el-icon><VideoPlay /></el-icon>
	            </div>
	            <div class="stat-info">
	              <div class="stat-title">课程总数</div>
	              <div class="stat-number">{{ stats.courseCount }}</div>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="6">
	        <el-card class="stat-card">
	          <div class="stat-content">
	            <div class="stat-icon meeting-icon">
	              <el-icon><Calendar /></el-icon>
	            </div>
	            <div class="stat-info">
	              <div class="stat-title">会议总数</div>
	              <div class="stat-number">{{ stats.meetingCount }}</div>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	    </el-row>
	
	    <el-row :gutter="20" style="margin-top: 20px;">
	      <el-col :span="12">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>最新动态</span>
	            </div>
	          </template>
	          <el-table :data="recentNews" style="width: 100%" max-height="300">
	            <el-table-column prop="title" label="标题" show-overflow-tooltip />
	            <el-table-column prop="author" label="作者" width="120" />
	            <el-table-column prop="createTime" label="发布时间" width="180" />
	          </el-table>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="12">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>最新课程</span>
	            </div>
	          </template>
	          <el-table :data="recentCourses" style="width: 100%" max-height="300">
	            <el-table-column prop="title" label="课程名称" show-overflow-tooltip />
	            <el-table-column prop="author" label="作者" width="120" />
	            <el-table-column prop="createTime" label="创建时间" width="180" />
	          </el-table>
	        </el-card>
	      </el-col>
	    </el-row>
	
	    <!-- 快捷操作 -->
	    <el-row :gutter="20" style="margin-top: 20px;">
	      <el-col :span="24">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>快捷操作</span>
	            </div>
	          </template>
	          <div class="quick-actions">
	            <el-button type="primary" @click="$router.push('/users')">
	              <el-icon><User /></el-icon>
	              用户管理
	            </el-button>
	            <el-button type="success" @click="$router.push('/news')">
	              <el-icon><Document /></el-icon>
	              发布动态
	            </el-button>
	            <el-button type="warning" @click="$router.push('/courses')">
	              <el-icon><VideoPlay /></el-icon>
	              添加课程
	            </el-button>
	            <el-button type="info" @click="$router.push('/meetings')">
	              <el-icon><Calendar /></el-icon>
	              创建会议
	            </el-button>
	            <el-button type="primary" @click="$router.push('/tenants')">
	              <el-icon><OfficeBuilding /></el-icon>
	              租户管理
	            </el-button>
	          </div>
	        </el-card>
	      </el-col>
	    </el-row>
	
	    <!-- 数据概览 -->
	    <el-row :gutter="20" style="margin-top: 20px;">
	      <el-col :span="8">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>今日数据</span>
	            </div>
	          </template>
	          <div class="today-stats">
	            <div class="today-item">
	              <span class="today-label">新增用户</span>
	              <span class="today-value">{{ todayStats.newUsers }}</span>
	            </div>
	            <div class="today-item">
	              <span class="today-label">新增动态</span>
	              <span class="today-value">{{ todayStats.newNews }}</span>
	            </div>
	            <div class="today-item">
	              <span class="today-label">新增课程</span>
	              <span class="today-value">{{ todayStats.newCourses }}</span>
	            </div>
	            <div class="today-item">
	              <span class="today-label">新增会议</span>
	              <span class="today-value">{{ todayStats.newMeetings }}</span>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="8">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>待处理事项</span>
	            </div>
	          </template>
	          <div class="pending-items">
	            <div class="pending-item" @click="$router.push('/news')">
	              <span class="pending-label">待审核动态</span>
	              <span class="pending-value">{{ pendingStats.pendingNews }}</span>
	            </div>
	            <div class="pending-item" @click="$router.push('/courses')">
	              <span class="pending-label">待审核课程</span>
	              <span class="pending-value">{{ pendingStats.pendingCourses }}</span>
	            </div>
	            <div class="pending-item" @click="$router.push('/meetings')">
	              <span class="pending-label">待审核会议</span>
	              <span class="pending-value">{{ pendingStats.pendingMeetings }}</span>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	      
	      <el-col :span="8">
	        <el-card>
	          <template #header>
	            <div class="card-header">
	              <span>系统状态</span>
	            </div>
	          </template>
	          <div class="system-status">
	            <div class="status-item">
	              <span class="status-label">系统运行时间</span>
	              <span class="status-value">{{ systemInfo.uptime }}</span>
	            </div>
	            <div class="status-item">
	              <span class="status-label">数据库状态</span>
	              <span class="status-value status-good">正常</span>
	            </div>
	            <div class="status-item">
	              <span class="status-label">存储空间</span>
	              <span class="status-value">{{ systemInfo.storage }}</span>
	            </div>
	          </div>
	        </el-card>
	      </el-col>
	    </el-row>
	  </div>
</template>

<script setup>
	import { ref, onMounted } from 'vue'
	import { User, Document, VideoPlay, Calendar, OfficeBuilding } from '@element-plus/icons-vue'
	import request from '../utils/request'
	
	const stats = ref({
	  userCount: 0,
	  newsCount: 0,
	  courseCount: 0,
	  meetingCount: 0
	})
	
	const recentNews = ref([])
	const recentCourses = ref([])
	const todayStats = ref({
	  newUsers: 0,
	  newNews: 0,
	  newCourses: 0,
	  newMeetings: 0
	})
	const pendingStats = ref({
	  pendingNews: 0,
	  pendingCourses: 0,
	  pendingMeetings: 0
	})
	const systemInfo = ref({
	  uptime: '0天',
	  storage: '0GB'
	})
	
	onMounted(async () => {
	  await loadStats()
	  await loadRecentData()
	  await loadTodayStats()
	  await loadPendingStats()
	  await loadSystemInfo()
	})
	
	const loadStats = async () => {
	  try {
	    const res = await request.get('/stats')
	    stats.value = res.data
	  } catch (error) {
	    console.error('加载统计数据失败:', error)
	    // 失败时使用默认值
	    stats.value = {
	      userCount: 0,
	      newsCount: 0,
	      courseCount: 0,
	      meetingCount: 0
	    }
	  }
	}
	
	const loadRecentData = async () => {
	  try {
	    // 获取最新动态
	    const newsRes = await request.get('/news/page?current=1&size=5&status=1')
	    recentNews.value = newsRes.data.records || []
	    
	    // 获取最新课程
	    const courseRes = await request.get('/course/page?current=1&size=5&status=1')
	    recentCourses.value = courseRes.data.records || []
	  } catch (error) {
	    console.error('加载最新数据失败:', error)
	  }
	}
	
	const loadTodayStats = async () => {
	  try {
	    const res = await request.get('/stats/today')
	    todayStats.value = res.data
	  } catch (error) {
	    console.error('加载今日统计失败:', error)
	    todayStats.value = {
	      newUsers: 0,
	      newNews: 0,
	      newCourses: 0,
	      newMeetings: 0
	    }
	  }
	}
	
	const loadPendingStats = async () => {
	  try {
	    const res = await request.get('/stats/pending')
	    pendingStats.value = res.data
	  } catch (error) {
	    console.error('加载待处理统计失败:', error)
	    pendingStats.value = {
	      pendingNews: 0,
	      pendingCourses: 0,
	      pendingMeetings: 0
	    }
	  }
	}
	
	const loadSystemInfo = async () => {
	  try {
	    const res = await request.get('/stats/system')
	    systemInfo.value = res.data
	  } catch (error) {
	    console.error('加载系统信息失败:', error)
	    systemInfo.value = {
	      uptime: '0天',
	      storage: '0GB'
	    }
	  }
	}
</script>

<style scoped>
	.dashboard {
	  padding: 20px;
	}
	
	.stat-card {
	  height: 120px;
	}
	
	.stat-content {
	  display: flex;
	  align-items: center;
	  height: 100%;
	}
	
	.stat-icon {
	  width: 60px;
	  height: 60px;
	  border-radius: 50%;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  margin-right: 15px;
	  font-size: 24px;
	  color: white;
	}
	
	.user-icon {
	  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	}
	
	.news-icon {
	  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
	}
	
	.course-icon {
	  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
	}
	
	.meeting-icon {
	  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
	}
	
	.stat-info {
	  flex: 1;
	}
	
	.stat-title {
	  font-size: 14px;
	  color: #999;
	  margin-bottom: 8px;
	}
	
	.stat-number {
	  font-size: 28px;
	  font-weight: bold;
	  color: #333;
	}
	
	.quick-actions {
	  display: flex;
	  gap: 15px;
	  flex-wrap: wrap;
	}
	
	.quick-actions .el-button {
	  display: flex;
	  align-items: center;
	  gap: 5px;
	}
	
	.today-stats, .pending-items, .system-status {
	  padding: 10px 0;
	}
	
	.today-item, .pending-item, .status-item {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  padding: 8px 0;
	  border-bottom: 1px solid #f0f0f0;
	}
	
	.today-item:last-child, .pending-item:last-child, .status-item:last-child {
	  border-bottom: none;
	}
	
	.today-label, .pending-label, .status-label {
	  color: #666;
	  font-size: 14px;
	}
	
	.today-value, .pending-value, .status-value {
	  font-weight: bold;
	  color: #333;
	}
	
	.pending-item {
	  cursor: pointer;
	  transition: background-color 0.2s;
	}
	
	.pending-item:hover {
	  background-color: #f5f5f5;
	}
	
	.pending-value {
	  background: #ff4d4f;
	  color: white;
	  padding: 2px 8px;
	  border-radius: 12px;
	  font-size: 12px;
	  min-width: 20px;
	  text-align: center;
	}
	
	.status-good {
	  color: #52c41a;
	}
	
	.card-header {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	}
</style>