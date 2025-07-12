<template>
	 <div class="meeting-manage">
	    <el-card>
	      <template #header>
	        <div class="card-header">
	          <span>会议管理</span>
	          <div>
	            <el-button type="success" @click="exportMeetings">导出会议</el-button>
	            <el-button type="primary" @click="showAddDialog = true">创建会议</el-button>
	          </div>
	        </div>
	      </template>
	
	      <div class="search-bar">
	        <el-row :gutter="20">
	          <el-col :span="8">
	            <el-input
	              v-model="searchKeyword"
	              placeholder="请输入会议名称或创建人"
	              clearable
	              @keyup.enter="loadMeetings"
	            >
	              <template #append>
	                <el-button @click="loadMeetings">搜索</el-button>
	              </template>
	            </el-input>
	          </el-col>
	          <el-col :span="4">
	            <el-select v-model="statusFilter" placeholder="状态筛选" style="width: 100%" @change="loadMeetings">
	              <el-option label="全部" value="" />
	              <el-option label="待审核" value="0" />
	              <el-option label="已发布" value="1" />
	              <el-option label="已拒绝" value="2" />
	            </el-select>
	          </el-col>
	          <el-col :span="6">
	            <el-date-picker
	              v-model="createTimeRange"
	              type="daterange"
	              range-separator="至"
	              start-placeholder="开始日期"
	              end-placeholder="结束日期"
	              format="YYYY-MM-DD"
	              value-format="YYYY-MM-DD"
	              style="width: 100%"
	              @change="loadMeetings"
	            />
	          </el-col>
	          <el-col :span="6">
	            <el-button @click="resetFilters" style="margin-right: 10px">重置</el-button>
	            <el-button type="primary" @click="openNotifyDialog" v-if="isAdmin">发布通知</el-button>
	          </el-col>
	        </el-row>
	      </div>
	
	      <el-table :data="meetingList" style="width: 100%" v-loading="loading">
	        <template #empty>
	          <div class="empty-data">
	            <el-empty description="暂无会议数据" />
	          </div>
	        </template>
	        <el-table-column prop="meetingName" label="会议名称" width="180" show-overflow-tooltip />
	        <el-table-column label="封面" width="80">
	          <template #default="scope">
	            <img v-if="scope.row.coverImage" :src="getImageUrl(scope.row.coverImage)" style="width: 50px; height: 30px; object-fit: cover;" />
	            <span v-else>无</span>
	          </template>
	        </el-table-column>
	        <el-table-column prop="meetingTime" label="会议时间" width="160" />
	        <el-table-column prop="location" label="会议地点" width="150" />
	        <el-table-column prop="organizer" label="主办单位" width="120" />
	        <el-table-column prop="category" label="会议分类" width="120" />
	        <el-table-column prop="creator" label="创建人" width="100" />
	        <el-table-column prop="status" label="状态" width="100">
	          <template #default="scope">
	            <el-tag :type="getStatusType(scope.row.status)">
	              {{ getStatusText(scope.row.status) }}
	            </el-tag>
	          </template>
	        </el-table-column>
	        <el-table-column prop="createTime" label="创建时间" width="180" />
	        <el-table-column label="操作" width="250">
	          <template #default="scope">
	            <el-button 
	              size="small" 
	              @click="editMeeting(scope.row)" 
	              v-if="canEdit(scope.row)"
	            >
	              编辑
	            </el-button>
	            <el-button 
	              size="small" 
	              type="primary" 
	              @click="auditMeeting(scope.row)" 
	              v-if="canAudit(scope.row)"
	            >
	              审核
	            </el-button>
	            <el-button 
	              size="small" 
	              type="danger" 
	              @click="deleteMeeting(scope.row)" 
	              v-if="canDelete(scope.row)"
	            >
	              删除
	            </el-button>
	            <span v-if="!canEdit(scope.row) && !canAudit(scope.row) && !canDelete(scope.row)" style="color: #999;">
	              无操作权限
	            </span>
	          </template>
	        </el-table-column>
	      </el-table>
	
	      <div class="pagination">
	        <el-pagination
	          v-model:current-page="currentPage"
	          v-model:page-size="pageSize"
	          :total="total"
	          layout="total, sizes, prev, pager, next"
	          :page-sizes="[10, 20, 50, 100]"
	          @current-change="loadMeetings"
	          @size-change="handleSizeChange"
	        />
	      </div>
	    </el-card>
	
	    <!-- 创建/编辑会议对话框 -->
	    <el-dialog v-model="showAddDialog" :title="editingMeeting ? '编辑会议' : '创建会议'" width="600px">
	      <el-form :model="meetingForm" ref="meetingFormRef" label-width="100px">
	        <el-form-item label="会议名称">
	          <el-input v-model="meetingForm.meetingName" />
	        </el-form-item>
	        <el-form-item label="会议时间">
	          <el-date-picker
	            v-model="meetingForm.meetingTime"
	            type="datetime"
	            placeholder="选择会议时间"
	            style="width: 100%"
	          />
	        </el-form-item>
	        <el-form-item label="会议地点">
	          <el-input v-model="meetingForm.location" />
	        </el-form-item>
	        <el-form-item label="主办单位">
	          <el-input v-model="meetingForm.organizer" />
	        </el-form-item>
	        <el-form-item label="会议分类">
	          <el-select v-model="meetingForm.category" style="width: 100%">
	            <el-option label="研讨" value="研讨" />
	            <el-option label="标准定制" value="标准定制" />
	            <el-option label="技术培训" value="技术培训" />
	            <el-option label="工具研发" value="工具研发" />
	            <el-option label="公益行动" value="公益行动" />
	          </el-select>
	        </el-form-item>
	        <el-form-item label="会议内容">
	          <el-input v-model="meetingForm.meetingContent" type="textarea" :rows="6" />
	        </el-form-item>
	        <el-form-item label="会议封面">
	          <el-upload
	            class="upload-demo"
	            :action="uploadUrl"
	            :show-file-list="false"
	            :on-success="handleCoverSuccess"
	            :before-upload="beforeUpload"
	          >
	            <el-button size="small" type="primary">点击上传</el-button>
	          </el-upload>
	          <div v-if="meetingForm.coverImage" style="margin-top: 10px;">
	            <img :src="getImageUrl(meetingForm.coverImage)" style="width: 100px; height: 60px; object-fit: cover;" />
	            <el-button size="small" type="danger" @click="meetingForm.coverImage = ''" style="margin-left: 10px;">删除</el-button>
	          </div>
	        </el-form-item>
	      </el-form>
	      <template #footer>
	        <el-button @click="showAddDialog = false">取消</el-button>
	        <el-button type="primary" @click="saveMeeting">保存</el-button>
	      </template>
	    </el-dialog>
	
	    <!-- 审核对话框 -->
	    <el-dialog v-model="showAuditDialog" title="审核会议" width="400px">
	      <div style="margin-bottom: 20px;">
	        <strong>会议名称：</strong>{{ auditingMeeting && auditingMeeting.meetingName }}
	      </div>
	      <el-radio-group v-model="auditStatus">
	        <el-radio :label="1">通过</el-radio>
	        <el-radio :label="2">拒绝</el-radio>
	      </el-radio-group>
	      <template #footer>
	        <el-button @click="showAuditDialog = false">取消</el-button>
	        <el-button type="primary" @click="submitAudit">确定</el-button>
	      </template>
	    </el-dialog>
	
	    <!-- 发布通知对话框 -->
	    <el-dialog v-model="showNotifyDialog" title="发布会议通知" width="600px">
	      <el-form :model="notifyForm" ref="notifyFormRef" label-width="100px">
	        <el-form-item label="通知标题" required>
	          <el-input v-model="notifyForm.title" placeholder="请输入通知标题" />
	        </el-form-item>
	        <el-form-item label="通知内容" required>
	          <el-input 
	            v-model="notifyForm.content" 
	            type="textarea" 
	            :rows="8"
	            placeholder="请输入通知内容"
	          />
	        </el-form-item>
	        <el-form-item label="关联会议">
	          <el-select v-model="notifyForm.meetingId" placeholder="选择关联会议（可选）" style="width: 100%">
	            <el-option 
	              v-for="meeting in publishedMeetings" 
	              :key="meeting.id" 
	              :label="meeting.meetingName" 
	              :value="meeting.id" 
	            />
	          </el-select>
	        </el-form-item>
	      </el-form>
	      <template #footer>
	        <el-button @click="showNotifyDialog = false">取消</el-button>
	        <el-button type="primary" @click="publishNotify">发布</el-button>
	      </template>
	    </el-dialog>
	  </div>
</template>

<script setup>
	import { ref, reactive, onMounted, computed } from 'vue'
	import { ElMessage, ElMessageBox } from 'element-plus'
	import request from '../utils/request'
	
	const meetingList = ref([])
	const loading = ref(false)
	const showAddDialog = ref(false)
	const showAuditDialog = ref(false)
	const showNotifyDialog = ref(false)
	const editingMeeting = ref(null)
	const auditingMeeting = ref(null)
	const searchKeyword = ref('')
	const statusFilter = ref('')
	const createTimeRange = ref([])
	const currentPage = ref(1)
	const pageSize = ref(10)
	const total = ref(0)
	const uploadUrl = ref('/api/file/upload')
	const auditStatus = ref(1)
	const publishedMeetings = ref([])
	
	const user = computed(() => {
	  const userStr = localStorage.getItem('user')
	  return userStr ? JSON.parse(userStr) : {}
	})
	
	const isAdmin = computed(() => {
	  return user.value.role === 'ADMIN'
	})
	
	const meetingForm = reactive({
	  meetingName: '',
	  meetingTime: '',
	  location: '',
	  organizer: '',
	  category: '',
	  meetingContent: '',
	  coverImage: ''
	})
	
	const notifyForm = reactive({
	  title: '',
	  content: '',
	  meetingId: null
	})
	
	const meetingFormRef = ref()
	
	onMounted(() => {
	  loadMeetings()
	  loadPublishedMeetings()
	})
	
	const loadMeetings = async () => {
	  loading.value = true
	  try {
	    const params = {
	      current: currentPage.value,
	      size: pageSize.value,
	      keyword: searchKeyword.value
	    }
	    
	    // 添加状态筛选
	    if (statusFilter.value !== '') {
	      params.status = statusFilter.value
	    }
	    
	    // 添加创建时间筛选
	    if (createTimeRange.value && createTimeRange.value.length === 2) {
	      // 确保日期格式正确
	      const startDate = createTimeRange.value[0]
	      const endDate = createTimeRange.value[1]
	      
	      if (startDate instanceof Date) {
	        params.startDate = startDate.toISOString().split('T')[0]
	      } else {
	        params.startDate = startDate
	      }
	      
	      if (endDate instanceof Date) {
	        params.endDate = endDate.toISOString().split('T')[0]
	      } else {
	        params.endDate = endDate
	      }
	    }
	    
	    const res = await request.get('/meeting/page', { params })
	    meetingList.value = res.data.records || []
	    total.value = res.data.total || 0
	  } catch (error) {
	    console.error('加载会议列表失败:', error)
	    meetingList.value = []
	  } finally {
	    loading.value = false
	  }
	}
	
	const getStatusType = (status) => {
	  const types = { 0: 'warning', 1: 'success', 2: 'danger' }
	  return types[status] || 'info'
	}
	
	const getStatusText = (status) => {
	  const texts = { 0: '待审核', 1: '已发布', 2: '已拒绝' }
	  return texts[status] || '未知'
	}
	
	const editMeeting = (meeting) => {
	  editingMeeting.value = meeting
	  Object.assign(meetingForm, meeting)
	  showAddDialog.value = true
	}
	
	const saveMeeting = async () => {
	  try {
	    const formData = { ...meetingForm }
	    
	    // 格式化会议时间
	    if (formData.meetingTime) {
	      if (formData.meetingTime instanceof Date) {
	        formData.meetingTime = formData.meetingTime.toISOString().slice(0, 19).replace('T', ' ')
	      }
	    }
	    
	    if (editingMeeting.value) {
	      await request.put(`/meeting/${editingMeeting.value.id}`, formData)
	      ElMessage.success('更新成功')
	    } else {
	      await request.post('/meeting', formData)
	      ElMessage.success('创建成功')
	    }
	    showAddDialog.value = false
	    resetForm()
	    loadMeetings()
	  } catch (error) {
	    console.error('保存会议失败:', error)
	  }
	}
	
	const deleteMeeting = async (meeting) => {
	  try {
	    await ElMessageBox.confirm('确定要删除这个会议吗？', '提示')
	    await request.delete(`/meeting/${meeting.id}`)
	    ElMessage.success('删除成功')
	    loadMeetings()
	  } catch (error) {
	    if (error !== 'cancel') {
	      console.error('删除会议失败:', error)
	    }
	  }
	}
	
	const resetForm = () => {
	  editingMeeting.value = null
	  Object.assign(meetingForm, {
	    meetingName: '',
	    meetingTime: '',
	    location: '',
	    organizer: '',
	    category: '',
	    meetingContent: '',
	    coverImage: ''
	  })
	}
	
	const handleCoverSuccess = (response) => {
	  if (response.code === 200) {
	    meetingForm.coverImage = response.data
	    ElMessage.success('封面上传成功')
	  } else {
	    ElMessage.error('封面上传失败')
	  }
	}
	
	const beforeUpload = (file) => {
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
	
	const canEdit = (meeting) => {
	  // 只有管理员或创建者本人可以编辑
	  if (!user.value || !user.value.id || !meeting) {
	    return false
	  }
	  
	  // 管理员可以编辑所有会议
	  if (user.value.role === 'ADMIN') {
	    return true
	  }
	  
	  // 创建者本人可以编辑自己的会议
	  return meeting.creatorId === user.value.id
	}
	
	const canDelete = (meeting) => {
	  // 只有管理员或创建者本人可以删除
	  if (!user.value || !user.value.id || !meeting) {
	    return false
	  }
	  
	  // 管理员可以删除所有会议
	  if (user.value.role === 'ADMIN') {
	    return true
	  }
	  
	  // 创建者本人可以删除自己的会议
	  return meeting.creatorId === user.value.id
	}
	
	const canAudit = (meeting) => {
	  return user.value.role === 'ADMIN' && meeting.status === 0
	}
	
	const auditMeeting = (meeting) => {
	  auditingMeeting.value = meeting
	  auditStatus.value = 1
	  showAuditDialog.value = true
	}
	
	const submitAudit = async () => {
	  try {
	    await request.post(`/meeting/${auditingMeeting.value.id}/audit?status=${auditStatus.value}`)
	    ElMessage.success('审核成功')
	    showAuditDialog.value = false
	    loadMeetings()
	  } catch (error) {
	    console.error('审核失败:', error)
	  }
	}
	
	const getImageUrl = (imagePath) => {
	  if (!imagePath) return ''
	  if (imagePath.startsWith('http')) return imagePath
	  return `http://localhost:8080/api${imagePath}`
	}
	
	const exportMeetings = async () => {
	  try {
	    const res = await request.get('/meeting/export', {
	      params: {
	        keyword: searchKeyword.value
	      },
	      responseType: 'blob'
	    })
	    
	    const blob = new Blob([res], { type: 'text/csv;charset=utf-8' })
	    const url = window.URL.createObjectURL(blob)
	    const a = document.createElement('a')
	    a.href = url
	    a.download = `meetings_${new Date().toISOString().split('T')[0]}.csv`
	    document.body.appendChild(a)
	    a.click()
	    document.body.removeChild(a)
	    window.URL.revokeObjectURL(url)
	    
	    ElMessage.success('导出成功')
	  } catch (error) {
	    console.error('导出失败:', error)
	    ElMessage.error('导出失败')
	  }
	}
	
	const handleSizeChange = (size) => {
	  pageSize.value = size
	  currentPage.value = 1
	  loadMeetings()
	}
	
	// 重置筛选条件
	const resetFilters = () => {
	  searchKeyword.value = ''
	  statusFilter.value = ''
	  createTimeRange.value = []
	  currentPage.value = 1
	  loadMeetings()
	}
	
	// 加载已发布的会议列表
	const loadPublishedMeetings = async () => {
	  try {
	    const res = await request.get('/meeting/page', {
	      params: {
	        current: 1,
	        size: 100,
	        status: 1
	      }
	    })
	    publishedMeetings.value = res.data.records || []
	  } catch (error) {
	    console.error('加载已发布会议列表失败:', error)
	  }
	}
	
	// 发布通知
	const publishNotify = async () => {
	  if (!notifyForm.title.trim()) {
	    ElMessage.error('请输入通知标题')
	    return
	  }
	  if (!notifyForm.content.trim()) {
	    ElMessage.error('请输入通知内容')
	    return
	  }
	  
	  try {
	    // 如果选择了关联会议，在标题和内容中体现
	    let title = notifyForm.title
	    let content = notifyForm.content
	    
	    if (notifyForm.meetingId) {
	      const selectedMeeting = publishedMeetings.value.find(m => m.id === notifyForm.meetingId)
	      if (selectedMeeting) {
	        title = `【会议通知】${notifyForm.title}`
	        content = `关于"${selectedMeeting.meetingName}"会议的通知：\n\n${notifyForm.content}`
	      }
	    } else {
	      title = `【会议通知】${notifyForm.title}`
	    }
	    
	    await request.post('/news', {
	      title: title,
	      content: content,
	      summary: content.substring(0, 200) + (content.length > 200 ? '...' : ''),
	      category: '会议通知',
	      status: 1
	    })
	    ElMessage.success('通知发布成功')
	    showNotifyDialog.value = false
	    resetNotifyForm()
	  } catch (error) {
	    console.error('发布通知失败:', error)
	    ElMessage.error('发布通知失败')
	  }
	}
	
	// 打开通知对话框
	const openNotifyDialog = () => {
	  resetNotifyForm()
	  showNotifyDialog.value = true
	}
	
	// 重置通知表单
	const resetNotifyForm = () => {
	  notifyForm.title = ''
	  notifyForm.content = ''
	  notifyForm.meetingId = null
	}
</script>

<style scoped>
	.card-header {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	}
	
	.search-bar {
	  margin-bottom: 20px;
	}
	
	.search-bar .el-row {
	  align-items: center;
	}
	
	.pagination {
	  margin-top: 20px;
	  text-align: right;
	}
	
	.empty-data {
	  padding: 40px 0;
	}
</style>