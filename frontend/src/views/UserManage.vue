<template>
  <div class="user-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <div>
            <el-button type="info" @click="loadUsers" :loading="loading">
              <el-icon><Refresh /></el-icon>
              刷新
            </el-button>
            <el-button 
              type="danger" 
              @click="batchDelete" 
              :disabled="selectedUsers.length === 0"
              v-permission="'user:delete'"
            >
              批量删除
            </el-button>
            <el-button 
              type="success" 
              @click="exportUsers"
              v-permission="'user:export'"
            >
              导出用户
            </el-button>
            <el-button 
              type="primary" 
              @click="showAddDialog = true"
              v-permission="'user:add'"
            >
              <el-icon><Plus /></el-icon>
              新增用户
            </el-button>
          </div>
        </div>
      </template>

      <!-- 高级搜索栏 -->
      <div class="search-bar">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-input
              v-model="searchParams.keyword"
              placeholder="用户名/昵称/手机号/邮箱"
              clearable
              @keyup.enter="handleSearch"
            />
          </el-col>
          <el-col :span="4">
            <el-select 
              v-model="searchParams.role" 
              placeholder="角色筛选" 
              clearable
              style="width: 100%"
            >
              <el-option label="全部" value="" />
              <el-option label="管理员" value="ADMIN" />
              <el-option label="普通用户" value="USER" />
            </el-select>
          </el-col>
          <el-col :span="4">
            <el-select 
              v-model="searchParams.status" 
              placeholder="状态筛选" 
              clearable
              style="width: 100%"
            >
              <el-option label="全部" value="" />
              <el-option label="启用" :value="1" />
              <el-option label="禁用" :value="0" />
            </el-select>
          </el-col>
          <el-col :span="8">
            <el-date-picker
              v-model="searchParams.dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="注册开始日期"
              end-placeholder="注册结束日期"
              style="width: 100%"
              value-format="YYYY-MM-DD"
            />
          </el-col>
          <el-col :span="2">
            <el-button type="primary" @click="handleSearch">
              <el-icon><Search /></el-icon>
              搜索
            </el-button>
          </el-col>
        </el-row>
      </div>

      <!-- 用户表格 -->
      <el-table 
        :data="users" 
        style="width: 100%" 
        v-loading="loading"
        @selection-change="handleSelectionChange"
        :row-key="row => row.id"
      >
        <template #empty>
          <el-empty description="暂无用户数据" />
        </template>
        <el-table-column type="selection" width="55" />
        <el-table-column label="头像" width="80">
          <template #default="scope">
            <el-avatar :size="40" :src="getAvatarUrl(scope.row.avatar)">
              {{ scope.row.nickname?.charAt(0) || scope.row.username?.charAt(0) }}
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户名" width="120" sortable />
        <el-table-column prop="nickname" label="昵称" width="120" />
        <el-table-column prop="phone" label="手机号" width="130" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="department" label="部门" width="120" />
        <el-table-column prop="role" label="角色" width="100" sortable>
          <template #default="scope">
            <el-tag :type="scope.row.role === 'ADMIN' ? 'danger' : scope.row.role === 'MANAGER' ? 'warning' : 'primary'">
              {{ roleMap[scope.row.role] || scope.row.role }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              :active-value="1"
              :inactive-value="0"
              @change="handleStatusChange(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="注册时间" width="180" sortable />
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="scope">
            <el-button 
              size="small" 
              @click="viewUserDetail(scope.row)"
              v-permission="'user:view'"
            >
              详情
            </el-button>
            <el-button 
              size="small" 
              @click="editUser(scope.row)"
              v-permission="'user:edit'"
            >
              编辑
            </el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="deleteUser(scope.row)"
              v-permission="'user:delete'"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 用户表单对话框 -->
    <el-dialog 
      v-model="showAddDialog" 
      :title="dialogTitle" 
      width="600px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form 
        :model="userForm" 
        ref="userFormRef" 
        label-width="100px"
        :rules="formRules"
      >
        <el-form-item label="用户名" prop="username">
          <el-input 
            v-model="userForm.username" 
            placeholder="请输入用户名"
            :disabled="!!editingUser"
          />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!editingUser">
          <el-input 
            v-model="userForm.password" 
            type="password" 
            placeholder="请输入密码"
            show-password
          />
        </el-form-item>
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="userForm.nickname" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="userForm.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="userForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="部门" prop="department">
          <el-cascader
            v-model="userForm.department"
            :options="departmentOptions"
            :props="{ checkStrictly: true }"
            placeholder="请选择部门"
            style="width: 100%"
            clearable
          />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select 
            v-model="userForm.role" 
            placeholder="请选择角色" 
            style="width: 100%"
          >
            <el-option 
              v-for="role in roleOptions" 
              :key="role.value" 
              :label="role.label" 
              :value="role.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="userForm.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="头像">
          <el-upload
            class="avatar-uploader"
            :action="uploadUrl"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <img v-if="userForm.avatar" :src="getAvatarUrl(userForm.avatar)" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitForm">保存</el-button>
      </template>
    </el-dialog>

    <!-- 用户详情对话框 -->
    <el-dialog 
      v-model="showDetailDialog" 
      title="用户详情" 
      width="700px"
      :close-on-click-modal="false"
    >
      <div v-if="currentUser" class="user-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="用户ID">{{ currentUser.id }}</el-descriptions-item>
          <el-descriptions-item label="用户名">{{ currentUser.username }}</el-descriptions-item>
          <el-descriptions-item label="昵称">{{ currentUser.nickname }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ currentUser.phone }}</el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ currentUser.email }}</el-descriptions-item>
          <el-descriptions-item label="部门">{{ currentUser.department }}</el-descriptions-item>
          <el-descriptions-item label="角色">
            <el-tag :type="currentUser.role === 'ADMIN' ? 'danger' : 'primary'">
              {{ roleMap[currentUser.role] || currentUser.role }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="currentUser.status === 1 ? 'success' : 'danger'">
              {{ currentUser.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="注册时间">{{ currentUser.createTime }}</el-descriptions-item>
          <el-descriptions-item label="最后登录时间">{{ currentUser.lastLoginTime || '未登录' }}</el-descriptions-item>
          <el-descriptions-item label="最后登录IP">{{ currentUser.lastLoginIp || '未登录' }}</el-descriptions-item>
          <el-descriptions-item label="头像" :span="2">
            <el-avatar :size="100" :src="getAvatarUrl(currentUser.avatar)" />
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <el-button @click="showDetailDialog = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Refresh, Plus, Search } from '@element-plus/icons-vue'
import request from '@/utils/request'
import { validatePhone, validateEmail } from '@/utils/validate'

// 数据状态
const users = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showDetailDialog = ref(false)
const editingUser = ref(null)
const currentUser = ref(null)
const selectedUsers = ref([])
const userFormRef = ref(null)

// 分页参数
const pagination = reactive({
  current: 1,
  size: 10,
  total: 0
})

// 搜索参数
const searchParams = reactive({
  keyword: '',
  role: '',
  status: '',
  dateRange: []
})

// 表单数据
const userForm = reactive({
  username: '',
  password: '',
  nickname: '',
  phone: '',
  email: '',
  department: '',
  role: 'USER',
  status: 1,
  avatar: ''
})

// 表单验证规则
const formRules = reactive({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 4, max: 20, message: '长度在4到20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '长度在6到20个字符', trigger: 'blur' }
  ],
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' },
    { max: 20, message: '长度不超过20个字符', trigger: 'blur' }
  ],
  phone: [
    { validator: validatePhone, trigger: 'blur' }
  ],
  email: [
    { validator: validateEmail, trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
})

// 选项数据
const departmentOptions = ref([
  {
    value: '技术部',
    label: '技术部',
    children: [
      { value: '前端组', label: '前端组' },
      { value: '后端组', label: '后端组' },
      { value: '测试组', label: '测试组' }
    ]
  },
  {
    value: '产品部',
    label: '产品部',
    children: [
      { value: '产品设计', label: '产品设计' },
      { value: '产品经理', label: '产品经理' }
    ]
  },
  {
    value: '市场部',
    label: '市场部'
  }
])

const roleOptions = ref([
  { value: 'ADMIN', label: '管理员' },
  { value: 'MANAGER', label: '经理' },
  { value: 'USER', label: '普通用户' }
])

const roleMap = {
  ADMIN: '管理员',
  MANAGER: '经理',
  USER: '普通用户'
}

// 计算属性
const dialogTitle = computed(() => {
  return editingUser.value ? '编辑用户' : '新增用户'
})

const uploadUrl = computed(() => {
  return `${import.meta.env.VITE_API_BASE_URL}/file/upload`
})

// 生命周期钩子
onMounted(() => {
  loadUsers()
})

// 方法
const loadUsers = async () => {
  loading.value = true
  try {
    const params = {
      current: pagination.current,
      size: pagination.size,
      ...searchParams,
      startDate: searchParams.dateRange?.[0],
      endDate: searchParams.dateRange?.[1]
    }
    
    const res = await request.get('/user/page', { params })
    users.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (error) {
    console.error('加载用户列表失败:', error)
    ElMessage.error('加载用户列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.current = 1
  loadUsers()
}

const resetSearch = () => {
  Object.assign(searchParams, {
    keyword: '',
    role: '',
    status: '',
    dateRange: []
  })
  handleSearch()
}

const handlePageChange = (page) => {
  pagination.current = page
  loadUsers()
}

const handleSizeChange = (size) => {
  pagination.size = size
  loadUsers()
}

const handleSelectionChange = (selection) => {
  selectedUsers.value = selection.map(item => item.id)
}

const viewUserDetail = (user) => {
  currentUser.value = user
  showDetailDialog.value = true
}

const editUser = (user) => {
  editingUser.value = user
  Object.assign(userForm, {
    ...user,
    department: user.departmentPath ? user.departmentPath.split(',') : []
  })
  showAddDialog.value = true
}

const submitForm = () => {
  userFormRef.value?.validate(async (valid) => {
    if (valid) {
      try {
        const data = {
          ...userForm,
          departmentPath: Array.isArray(userForm.department) ? userForm.department.join(',') : userForm.department
        }
        
        if (editingUser.value) {
          await request.put(`/user/${editingUser.value.id}`, data)
          ElMessage.success('用户更新成功')
        } else {
          await request.post('/user', data)
          ElMessage.success('用户创建成功')
        }
        
        showAddDialog.value = false
        loadUsers()
      } catch (error) {
        console.error('保存用户失败:', error)
        ElMessage.error(error.response?.data?.message || '保存用户失败')
      }
    }
  })
}

const deleteUser = async (user) => {
  try {
    await ElMessageBox.confirm(`确定要删除用户 "${user.username}" 吗?`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await request.delete(`/user/${user.id}`)
    ElMessage.success('用户删除成功')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除用户失败:', error)
      ElMessage.error('删除用户失败')
    }
  }
}

const batchDelete = async () => {
  try {
    await ElMessageBox.confirm(`确定要删除选中的 ${selectedUsers.value.length} 个用户吗?`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await request.delete('/user/batch', {
      data: { ids: selectedUsers.value }
    })
    
    ElMessage.success('批量删除成功')
    selectedUsers.value = []
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

const handleStatusChange = async (user) => {
  try {
    await request.patch(`/user/${user.id}/status`, {
      status: user.status
    })
    ElMessage.success('状态更新成功')
  } catch (error) {
    console.error('更新状态失败:', error)
    ElMessage.error('状态更新失败')
    // 恢复原状态
    user.status = user.status === 1 ? 0 : 1
  }
}

const exportUsers = async () => {
  try {
    loading.value = true
    const params = {
      ...searchParams,
      startDate: searchParams.dateRange?.[0],
      endDate: searchParams.dateRange?.[1]
    }
    
    const res = await request.get('/user/export', {
      params,
      responseType: 'blob'
    })
    
    const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `用户列表_${new Date().toISOString().slice(0, 10)}.xlsx`
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
  } catch (error) {
    console.error('导出用户失败:', error)
    ElMessage.error('导出用户失败')
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  editingUser.value = null
  userFormRef.value?.resetFields()
  Object.assign(userForm, {
    username: '',
    password: '',
    nickname: '',
    phone: '',
    email: '',
    department: '',
    role: 'USER',
    status: 1,
    avatar: ''
  })
}

const getAvatarUrl = (avatar) => {
  if (!avatar) return ''
  if (avatar.startsWith('http')) return avatar
  return `${import.meta.env.VITE_API_BASE_URL}${avatar}`
}

const handleAvatarSuccess = (response) => {
  if (response.code === 200) {
    userForm.avatar = response.data
    ElMessage.success('头像上传成功')
  } else {
    ElMessage.error(response.message || '头像上传失败')
  }
}

const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
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
</script>

<style scoped>
.user-manage {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-bar {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.user-detail {
  padding: 10px;
}

.avatar-uploader {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 100px;
  height: 100px;
}

.avatar-uploader:hover {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}

.avatar {
  width: 100px;
  height: 100px;
  display: block;
  object-fit: cover;
}
</style>