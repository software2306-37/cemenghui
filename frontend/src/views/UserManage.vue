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
            <el-button type="danger" @click="batchDelete" :disabled="selectedUsers.length === 0">批量删除</el-button>
            <el-button type="success" @click="exportUsers">导出用户</el-button>
            <el-button type="primary" @click="showAddDialog = true">新增用户</el-button>
          </div>
        </div>
      </template>

      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-row :gutter="20">
          <el-col :span="4">
            <el-input
              v-model="searchKeyword"
              placeholder="请输入用户名、昵称、手机号或邮箱"
              clearable
              @keyup.enter="loadUsers"
            />
          </el-col>
          <el-col :span="4">
            <el-select v-model="roleFilter" placeholder="角色筛选" clearable>
              <el-option label="全部" value="" />
              <el-option label="管理员" value="ADMIN" />
              <el-option label="企业用户" value="USER" />
            </el-select>
          </el-col>
          <el-col :span="4">
            <el-select v-model="statusFilter" placeholder="状态筛选" clearable>
              <el-option label="全部" value="" />
              <el-option label="启用" :value="1" />
              <el-option label="禁用" :value="0" />
            </el-select>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              @change="loadUsers"
            />
          </el-col>
          <el-col :span="4" style="margin-left: 40px">
            <el-button type="primary" @click="loadUsers">搜索</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-col>
        </el-row>
      </div>

      <!-- 用户表格 -->
      <el-table :data="users" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <template #empty>
          <div class="empty-data">
            <el-empty description="暂无用户数据" />
          </div>
        </template>
        <el-table-column type="selection" width="55" />
        <el-table-column label="头像" width="80">
          <template #default="scope">
            <el-avatar :size="40" :src="getImageUrl(scope.row.avatar)">
              {{ scope.row.nickname || scope.row.username }}
            </el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="nickname" label="昵称" width="120" />
        <el-table-column prop="phone" label="手机号" width="130" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="companyName" label="企业名称" width="150" />
        <el-table-column prop="role" label="角色" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.role === 'ADMIN' ? 'danger' : 'primary'">
              {{ scope.row.role === 'ADMIN' ? '管理员' : '企业用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="250">
          <template #default="scope">
            <el-button size="small" @click="viewUser(scope.row)">查看</el-button>
            <el-button size="small" @click="editUser(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteUser(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          layout="total, sizes, prev, pager, next"
          :page-sizes="[10, 20, 50, 100]"
          @current-change="loadUsers"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>

    <!-- 新增/编辑用户对话框 -->
    <el-dialog v-model="showAddDialog" title="用户信息" width="500px">
      <el-form :model="userForm" ref="userFormRef" label-width="100px">
        <el-form-item label="用户名">
          <el-input v-model="userForm.username" />
        </el-form-item>
        <el-form-item label="密码" v-if="!editingUser">
          <el-input v-model="userForm.password" type="password" />
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="userForm.nickname" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="userForm.phone" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="userForm.email" type="email" />
        </el-form-item>
        <el-form-item label="企业名称">
          <el-input v-model="userForm.companyName" />
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="userForm.role" style="width: 100%">
            <el-option label="企业用户" value="USER" />
            <el-option label="管理员" value="ADMIN" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="userForm.status" style="width: 100%">
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveUser">保存</el-button>
      </template>
    </el-dialog>

    <!-- 查看用户对话框 -->
    <el-dialog v-model="showViewDialog" title="查看用户信息" width="500px">
      <div v-if="viewingUser">
        <div class="view-item">
          <strong>头像：</strong><br/>
          <el-avatar :size="80" :src="getImageUrl(viewingUser.avatar)" style="margin-top: 10px;">
            {{ viewingUser.nickname || viewingUser.username }}
          </el-avatar>
        </div>
        <div class="view-item">
          <strong>用户名：</strong>{{ viewingUser.username }}
        </div>
        <div class="view-item">
          <strong>昵称：</strong>{{ viewingUser.nickname || '未设置' }}
        </div>
        <div class="view-item">
          <strong>手机号：</strong>{{ viewingUser.phone || '未设置' }}
        </div>
        <div class="view-item">
          <strong>邮箱：</strong>{{ viewingUser.email || '未设置' }}
        </div>
        <div class="view-item">
          <strong>企业名称：</strong>{{ viewingUser.companyName || '未设置' }}
        </div>
        <div class="view-item">
          <strong>角色：</strong>
          <el-tag :type="viewingUser.role === 'ADMIN' ? 'danger' : 'primary'">
            {{ viewingUser.role === 'ADMIN' ? '管理员' : '企业用户' }}
          </el-tag>
        </div>
        <div class="view-item">
          <strong>状态：</strong>
          <el-tag :type="viewingUser.status === 1 ? 'success' : 'danger'">
            {{ viewingUser.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </div>
        <div class="view-item">
          <strong>性别：</strong>{{ viewingUser.gender === 1 ? '男' : viewingUser.gender === 2 ? '女' : '未设置' }}
        </div>
        <div class="view-item">
          <strong>注册时间：</strong>{{ viewingUser.createTime }}
        </div>
      </div>
      <template #footer>
        <el-button @click="showViewDialog = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Refresh } from '@element-plus/icons-vue'
import request from '../utils/request'

const users = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showViewDialog = ref(false)
const editingUser = ref(null)
const viewingUser = ref(null)
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const selectedUsers = ref([])
const roleFilter = ref('')
const statusFilter = ref('')
const dateRange = ref([])

const userForm = reactive({
  username: '',
  password: '',
  nickname: '',
  phone: '',
  email: '',
  companyName: '',
  role: 'USER',
  status: 1
})

const userFormRef = ref()

onMounted(() => {
  loadUsers()
})

const loadUsers = async () => {
  loading.value = true
  try {
    const res = await request.get('/user/page', {
      params: {
        current: currentPage.value,
        size: pageSize.value,
        keyword: searchKeyword.value,
        role: roleFilter.value,
        status: statusFilter.value,
        startDate: dateRange.value[0] ? dateRange.value[0].toISOString().split('T')[0] : null,
        endDate: dateRange.value[1] ? dateRange.value[1].toISOString().split('T')[0] : null
      }
    })
    users.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载用户列表失败:', error)
    users.value = []
  } finally {
    loading.value = false
  }
}

const viewUser = (user) => {
  viewingUser.value = user
  showViewDialog.value = true
}

const editUser = (user) => {
  editingUser.value = user
  Object.assign(userForm, user)
  showAddDialog.value = true
}

const saveUser = async () => {
  try {
    if (editingUser.value) {
      await request.put(`/user/${editingUser.value.id}`, userForm)
      ElMessage.success('更新成功')
    } else {
      await request.post('/user', userForm)
      ElMessage.success('创建成功')
    }
    showAddDialog.value = false
    resetForm()
    loadUsers()
  } catch (error) {
    console.error('保存用户失败:', error)
  }
}

const deleteUser = async (user) => {
  try {
    await ElMessageBox.confirm('确定要删除这个用户吗？', '提示')
    await request.delete(`/user/${user.id}`)
    ElMessage.success('删除成功')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除用户失败:', error)
    }
  }
}

const resetForm = () => {
  editingUser.value = null
  Object.assign(userForm, {
    username: '',
    password: '',
    nickname: '',
    phone: '',
    email: '',
    companyName: '',
    role: 'USER',
    status: 1
  })
}

const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) return imagePath
  return `http://localhost:8080/api${imagePath}`
}

const exportUsers = async () => {
  try {
    const res = await request.get('/user/export', {
      params: {
        keyword: searchKeyword.value,
        role: roleFilter.value,
        status: statusFilter.value
      },
      responseType: 'blob'
    })
    
    const blob = new Blob([res], { type: 'text/csv;charset=utf-8' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `users_${new Date().toISOString().split('T')[0]}.csv`
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
  loadUsers()
}

const handleSelectionChange = (selection) => {
  selectedUsers.value = selection.map(user => user.id)
}

const batchDelete = async () => {
  try {
    await ElMessageBox.confirm('确定要删除选中的用户吗？', '提示')
    await request.delete('/user/batch', {
      data: {
        ids: selectedUsers.value
      }
    })
    ElMessage.success('删除成功')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
    }
  }
}

const resetSearch = () => {
  searchKeyword.value = ''
  roleFilter.value = ''
  statusFilter.value = ''
  dateRange.value = []
  loadUsers()
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

.pagination {
  margin-top: 20px;
  text-align: right;
}

.view-item {
  margin-bottom: 15px;
  line-height: 1.6;
}

.empty-data {
  padding: 40px 0;
}
</style> 