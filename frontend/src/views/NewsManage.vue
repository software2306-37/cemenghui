<template>
  <div class="news-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>动态管理</span>
          <div>
            <el-button type="primary" @click="openAddDialog">发布动态</el-button>
          </div>
        </div>
      </template>

      <!-- 简化搜索栏 -->
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="请输入标题或内容搜索"
          clearable
          style="width: 300px; margin-right: 10px"
          @keyup.enter="loadNews"
        />
        <el-button type="primary" @click="loadNews">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </div>

      <!-- 简化表格 -->
      <el-table :data="newsList" style="width: 100%" v-loading="loading">
        <el-table-column prop="title" label="标题" width="180" />
        <el-table-column prop="author" label="作者" width="120" />
        <el-table-column prop="category" label="分类" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button size="small" @click="viewNews(scope.row)">查看</el-button>
            <el-button 
              size="small" 
              @click="editNews(scope.row)" 
              v-if="canEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="deleteNews(scope.row)" 
              v-if="canDelete(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 简化分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="loadNews"
        />
      </div>
    </el-card>

    <!-- 简化发布/编辑对话框 -->
    <el-dialog v-model="showAddDialog" :title="editingNews ? '编辑动态' : '发布动态'" width="600px">
      <el-form :model="newsForm" label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="newsForm.title" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="newsForm.category" placeholder="请选择分类">
            <el-option label="行业动态" value="行业动态" />
            <el-option label="技术分享" value="技术分享" />
            <el-option label="公司新闻" value="公司新闻" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="newsForm.content" type="textarea" :rows="10" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveNews">保存</el-button>
      </template>
    </el-dialog>

    <!-- 简化查看对话框 -->
    <el-dialog v-model="showViewDialog" title="查看动态" width="600px">
      <div v-if="viewingNews">
        <div class="view-item">
          <strong>标题：</strong>{{ viewingNews.title }}
        </div>
        <div class="view-item">
          <strong>作者：</strong>{{ viewingNews.author }}
        </div>
        <div class="view-item">
          <strong>状态：</strong>
          <el-tag :type="getStatusType(viewingNews.status)">
            {{ getStatusText(viewingNews.status) }}
          </el-tag>
        </div>
        <div class="view-item">
          <strong>内容：</strong>
          <div class="content-box">{{ viewingNews.content }}</div>
        </div>
        <div class="view-item">
          <strong>创建时间：</strong>{{ viewingNews.createTime }}
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

const newsList = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showViewDialog = ref(false)
const editingNews = ref(null)
const viewingNews = ref(null)
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 模拟用户数据
const user = {
  id: 1,
  role: 'ADMIN' // 或 'USER'
}

const newsForm = reactive({
  title: '',
  content: '',
  category: ''
})

onMounted(() => {
  loadNews()
})

const loadNews = async () => {
  loading.value = true
  try {
    // 这里应该是实际的API调用
    const mockData = {
      data: {
        records: [
          {
            id: 1,
            title: '系统更新公告',
            content: '本次系统更新包含以下内容...',
            category: '公司新闻',
            author: '管理员',
            authorId: 1,
            status: 1,
            createTime: '2023-05-15 10:00:00'
          },
          {
            id: 2,
            title: '技术分享会通知',
            content: '本周五下午2点将举行技术分享会...',
            category: '技术分享',
            author: '技术部',
            authorId: 2,
            status: 0,
            createTime: '2023-05-10 14:30:00'
          }
        ],
        total: 2
      }
    }
    newsList.value = mockData.data.records
    total.value = mockData.data.total
  } catch (error) {
    console.error('加载动态列表失败:', error)
    newsList.value = []
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

const canEdit = (news) => {
  return user.role === 'ADMIN' || news.authorId === user.id
}

const canDelete = (news) => {
  return user.role === 'ADMIN' || news.authorId === user.id
}

const viewNews = (news) => {
  viewingNews.value = news
  showViewDialog.value = true
}

const editNews = (news) => {
  editingNews.value = news
  Object.assign(newsForm, news)
  showAddDialog.value = true
}

const saveNews = async () => {
  try {
    if (!newsForm.title.trim()) {
      ElMessage.error('请输入标题')
      return
    }
    if (!newsForm.content.trim()) {
      ElMessage.error('请输入内容')
      return
    }
    
    if (editingNews.value) {
      // 更新API调用
      ElMessage.success('更新成功')
    } else {
      // 创建API调用
      ElMessage.success('发布成功')
    }
    showAddDialog.value = false
    resetForm()
    loadNews()
  } catch (error) {
    console.error('保存动态失败:', error)
  }
}

const deleteNews = async (news) => {
  try {
    await ElMessageBox.confirm(`确定要删除动态"${news.title}"吗？`, '提示')
    // 删除API调用
    ElMessage.success('删除成功')
    loadNews()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除动态失败:', error)
    }
  }
}

const resetForm = () => {
  editingNews.value = null
  Object.assign(newsForm, {
    title: '',
    content: '',
    category: ''
  })
}

const resetSearch = () => {
  searchKeyword.value = ''
  loadNews()
}

const openAddDialog = () => {
  resetForm()
  showAddDialog.value = true
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
}

.content-box {
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}
</style>