<template>
	<div class="tenant-manage">
	    <el-card>
	      <template #header>
	        <div class="card-header">
	          <span>租户管理</span>
	          <div>
	            <el-button type="success" @click="exportTenants">导出租户</el-button>
	            <el-button type="primary" @click="showAddDialog = true">新增租户</el-button>
	          </div>
	        </div>
	      </template>
	
	      <div class="search-bar">
	        <el-input
	          v-model="searchKeyword"
	          placeholder="请输入租户标识、名称、联系人或电话"
	          style="width: 300px"
	          clearable
	          @keyup.enter="loadTenants"
	        >
	          <template #append>
	            <el-button @click="loadTenants">搜索</el-button>
	          </template>
	        </el-input>
	      </div>
	
	      <el-table :data="tenantList" style="width: 100%" v-loading="loading">
	        <template #empty>
	          <div class="empty-data">
	            <el-empty description="暂无租户数据" />
	          </div>
	        </template>
	        <el-table-column prop="tenantCode" label="租户标识" width="150" />
	        <el-table-column prop="tenantName" label="租户名称" width="200" />
	        <el-table-column prop="contactPerson" label="联系人" width="120" />
	        <el-table-column prop="contactPhone" label="联系电话" width="150" />
	        <el-table-column prop="status" label="状态" width="100">
	          <template #default="scope">
	            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
	              {{ scope.row.status === 1 ? '启用' : '禁用' }}
	            </el-tag>
	          </template>
	        </el-table-column>
	        <el-table-column prop="createTime" label="创建时间" width="180" />
	        <el-table-column label="操作" width="200">
	          <template #default="scope">
	            <el-button size="small" @click="editTenant(scope.row)">编辑</el-button>
	            <el-button size="small" type="danger" @click="deleteTenant(scope.row)">删除</el-button>
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
	          @current-change="loadTenants"
	          @size-change="handleSizeChange"
	        />
	      </div>
	    </el-card>
	
	    <!-- 新增/编辑租户对话框 -->
	    <el-dialog v-model="showAddDialog" :title="editingTenant ? '编辑租户' : '新增租户'" width="500px">
	      <el-form :model="tenantForm" ref="tenantFormRef" label-width="100px">
	        <el-form-item label="租户标识">
	          <el-input v-model="tenantForm.tenantCode" />
	        </el-form-item>
	        <el-form-item label="租户名称">
	          <el-input v-model="tenantForm.tenantName" />
	        </el-form-item>
	        <el-form-item label="联系人">
	          <el-input v-model="tenantForm.contactPerson" />
	        </el-form-item>
	        <el-form-item label="联系电话">
	          <el-input v-model="tenantForm.contactPhone" />
	        </el-form-item>
	        <el-form-item label="状态">
	          <el-select v-model="tenantForm.status" style="width: 100%">
	            <el-option label="启用" :value="1" />
	            <el-option label="禁用" :value="0" />
	          </el-select>
	        </el-form-item>
	      </el-form>
	      <template #footer>
	        <el-button @click="showAddDialog = false">取消</el-button>
	        <el-button type="primary" @click="saveTenant">保存</el-button>
	      </template>
	    </el-dialog>
	  </div>
</template>

<script setup>
	import { ref, reactive, onMounted } from 'vue'
	import { ElMessage, ElMessageBox } from 'element-plus'
	import request from '../utils/request'
	
	const tenantList = ref([])
	const loading = ref(false)
	const showAddDialog = ref(false)
	const editingTenant = ref(null)
	const searchKeyword = ref('')
	const currentPage = ref(1)
	const pageSize = ref(10)
	const total = ref(0)
	
	const tenantForm = reactive({
	  tenantCode: '',
	  tenantName: '',
	  contactPerson: '',
	  contactPhone: '',
	  status: 1
	})
	
	const tenantFormRef = ref()
	
	onMounted(() => {
	  loadTenants()
	})
	
	const loadTenants = async () => {
	  loading.value = true
	  try {
	    const res = await request.get('/tenant/page', {
	      params: {
	        current: currentPage.value,
	        size: pageSize.value,
	        keyword: searchKeyword.value
	      }
	    })
	    tenantList.value = res.data.records || []
	    total.value = res.data.total || 0
	  } catch (error) {
	    console.error('加载租户列表失败:', error)
	    tenantList.value = []
	  } finally {
	    loading.value = false
	  }
	}
	
	const editTenant = (tenant) => {
	  editingTenant.value = tenant
	  Object.assign(tenantForm, tenant)
	  showAddDialog.value = true
	}
	
	const saveTenant = async () => {
	  try {
	    if (editingTenant.value) {
	      await request.put(`/tenant/${editingTenant.value.id}`, tenantForm)
	      ElMessage.success('更新成功')
	    } else {
	      await request.post('/tenant', tenantForm)
	      ElMessage.success('创建成功')
	    }
	    showAddDialog.value = false
	    resetForm()
	    loadTenants()
	  } catch (error) {
	    console.error('保存租户失败:', error)
	  }
	}
	
	const deleteTenant = async (tenant) => {
	  try {
	    await ElMessageBox.confirm('确定要删除这个租户吗？', '提示')
	    await request.delete(`/tenant/${tenant.id}`)
	    ElMessage.success('删除成功')
	    loadTenants()
	  } catch (error) {
	    if (error !== 'cancel') {
	      console.error('删除租户失败:', error)
	    }
	  }
	}
	
	const resetForm = () => {
	  editingTenant.value = null
	  Object.assign(tenantForm, {
	    tenantCode: '',
	    tenantName: '',
	    contactPerson: '',
	    contactPhone: '',
	    status: 1
	  })
	}
	
	const exportTenants = async () => {
	  try {
	    const res = await request.get('/tenant/export', {
	      params: {
	        keyword: searchKeyword.value
	      },
	      responseType: 'blob'
	    })
	    
	    const blob = new Blob([res], { type: 'text/csv;charset=utf-8' })
	    const url = window.URL.createObjectURL(blob)
	    const a = document.createElement('a')
	    a.href = url
	    a.download = `tenants_${new Date().toISOString().split('T')[0]}.csv`
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
	  loadTenants()
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
	
	.empty-data {
	  padding: 40px 0;
	}
</style>