<template>
  <div class="news-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>动态管理</span>
          <div>
            <el-button 
              type="warning" 
              @click="batchAudit" 
              :disabled="selectedNews.length === 0" 
              v-if="user.role === 'ADMIN'"
            >
              批量审核
            </el-button>
            <el-button 
              type="danger" 
              @click="batchDelete" 
              :disabled="selectedNews.length === 0"
            >
              批量删除
            </el-button>
            <el-button type="success" @click="exportNews">导出动态</el-button>
            <el-button type="primary" @click="openAddDialog">发布动态</el-button>
            <el-button 
              type="info" 
              @click="batchAiAudit" 
              :disabled="selectedNews.length === 0" 
              v-if="user.role === 'ADMIN'"
            >
              一键AI审核
            </el-button>
          </div>
        </div>
      </template>

      <div class="search-bar">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-input
              v-model="searchKeyword"
              placeholder="请输入标题、作者或简介进行模糊搜索"
              clearable
              @keyup.enter="loadNews"
            >
              <template #append>
                <el-button @click="loadNews">搜索</el-button>
              </template>
            </el-input>
          </el-col>
          <el-col :span="4">
            <el-select v-model="statusFilter" placeholder="状态筛选" style="width: 100%" @change="loadNews">
              <el-option label="全部状态" value="" />
              <el-option label="待审核" value="0" />
              <el-option label="已发布" value="1" />
              <el-option label="已拒绝" value="2" />
            </el-select>
          </el-col>
          <el-col :span="3">
            <el-select v-model="categoryFilter" placeholder="分类筛选" style="width: 100%" @change="loadNews">
              <el-option label="全部分类" value="" />
              <el-option label="行业动态" value="行业动态" />
              <el-option label="会议通知" value="会议通知" />
              <el-option label="技术分享" value="技术分享" />
              <el-option label="公司新闻" value="公司新闻" />
            </el-select>
          </el-col>
          <el-col :span="3">
            <el-select v-model="authorFilter" placeholder="作者筛选" style="width: 100%" @change="loadNews">
              <el-option label="全部动态" value="" />
              <el-option label="我的动态" value="mine" />
            </el-select>
          </el-col>
          <el-col :span="6">
            <el-date-picker
              v-model="createTimeRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              style="width: 100%"
              @change="loadNews"
            />
          </el-col>
          <el-col :span="2">
            <el-button @click="resetFilters">重置</el-button>
          </el-col>
        </el-row>
      </div>

      <el-table :data="newsList" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <template #empty>
          <div class="empty-data">
            <el-empty description="暂无动态数据" />
          </div>
        </template>
        <el-table-column type="selection" width="55" :selectable="canSelect" />
        <el-table-column prop="title" label="标题" width="180" show-overflow-tooltip />
        <el-table-column label="封面" width="80">
          <template #default="scope">
            <img v-if="scope.row.coverImage" :src="getImageUrl(scope.row.coverImage)" style="width: 50px; height: 30px; object-fit: cover;" />
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column prop="summary" label="简介" width="150" show-overflow-tooltip />
        <el-table-column prop="category" label="分类" width="100" />
        <el-table-column prop="author" label="作者" width="120">
          <template #default="scope">
            <span :style="{ color: scope.row.authorId === user.id ? '#409EFF' : '' }">
              {{ scope.row.author }}
              <el-tag v-if="scope.row.authorId === user.id" size="small" type="primary">我的</el-tag>
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览量" width="100" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="220">
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
              type="primary" 
              @click="auditNews(scope.row)" 
              v-if="canAudit(scope.row)"
            >
              审核
            </el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="deleteNews(scope.row)" 
              v-if="canDelete(scope.row)"
            >
              删除
            </el-button>
            <span 
              v-if="!canEdit(scope.row) && !canAudit(scope.row) && !canDelete(scope.row) && scope.row.authorId !== user.id" 
              style="color: #999; font-size: 12px;"
            >
              仅查看
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
          @current-change="loadNews"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>

    <!-- 发布/编辑动态对话框 -->
    <el-dialog v-model="showAddDialog" :title="editingNews ? '编辑动态' : '发布动态'" width="800px">
      <el-form :model="newsForm" ref="newsFormRef" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="newsForm.title" />
        </el-form-item>
        <el-form-item label="简介">
          <el-input v-model="newsForm.summary" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="newsForm.category" placeholder="请选择分类" style="width: 100%">
            <el-option label="行业动态" value="行业动态" />
            <el-option label="技术分享" value="技术分享" />
            <el-option label="公司新闻" value="公司新闻" />
            <el-option label="其他" value="其他" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="newsForm.content" type="textarea" :rows="10" />
        </el-form-item>
        <el-form-item label="封面图片">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="false"
            :on-success="handleCoverSuccess"
            :before-upload="beforeImageUpload"
            accept="image/*"
          >
            <el-button size="small" type="primary">点击上传封面图片</el-button>
          </el-upload>
          <div v-if="newsForm.coverImage" style="margin-top: 10px;">
            <img :src="getImageUrl(newsForm.coverImage)" style="width: 100px; height: 60px; object-fit: cover;" />
            <el-button size="small" type="danger" @click="newsForm.coverImage = ''" style="margin-left: 10px;">删除</el-button>
          </div>
        </el-form-item>
        
        <el-form-item label="内容图片">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="true"
            :on-success="handleContentImageSuccess"
            :before-upload="beforeImageUpload"
            accept="image/*"
            multiple
          >
            <el-button size="small" type="primary">上传内容图片</el-button>
          </el-upload>
          <div class="upload-tip">支持多张图片上传，可插入到内容中</div>
        </el-form-item>
        
        <el-form-item label="视频文件">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="true"
            :on-success="handleVideoSuccess"
            :before-upload="beforeVideoUpload"
            accept="video/*"
          >
            <el-button size="small" type="primary">上传视频</el-button>
          </el-upload>
          <div class="upload-tip">支持mp4、avi、mov等格式，大小不超过50MB</div>
        </el-form-item>
        
        <el-form-item label="附件文件">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="true"
            :on-success="handleAttachmentSuccess"
            :before-upload="beforeAttachmentUpload"
            multiple
          >
            <el-button size="small" type="primary">上传附件</el-button>
          </el-upload>
          <div class="upload-tip">支持文档、压缩包等格式，单个文件不超过10MB</div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveNews">保存</el-button>
      </template>
    </el-dialog>

    <!-- 审核对话框 -->
    <el-dialog v-model="showAuditDialog" title="审核动态" width="400px">
      <div style="margin-bottom: 20px;">
        <strong>标题：</strong>{{ auditingNews && auditingNews.title }}
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

    <!-- 查看对话框 -->
    <el-dialog v-model="showViewDialog" title="查看动态" width="800px">
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
          <strong>简介：</strong>{{ viewingNews.summary }}
        </div>
        <div class="view-item" v-if="viewingNews.coverImage">
          <strong>封面图片：</strong><br/>
          <img :src="getImageUrl(viewingNews.coverImage)" style="max-width: 300px; max-height: 200px; object-fit: cover;" />
        </div>
        <div class="view-item" v-if="viewingNews.contentImages && JSON.parse(viewingNews.contentImages || '[]').length > 0">
          <strong>内容图片：</strong><br/>
          <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <img 
              v-for="(img, index) in JSON.parse(viewingNews.contentImages)" 
              :key="index"
              :src="getImageUrl(img)" 
              style="width: 100px; height: 100px; object-fit: cover; border-radius: 4px;" 
            />
          </div>
        </div>
        <div class="view-item" v-if="viewingNews.videos && JSON.parse(viewingNews.videos || '[]').length > 0">
          <strong>视频文件：</strong><br/>
          <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <video 
              v-for="(video, index) in JSON.parse(viewingNews.videos)" 
              :key="index"
              :src="getImageUrl(video)" 
              controls
              style="width: 200px; height: 150px; border-radius: 4px;" 
            />
          </div>
        </div>
        <div class="view-item" v-if="viewingNews.attachments && JSON.parse(viewingNews.attachments || '[]').length > 0">
          <strong>附件文件：</strong><br/>
          <div style="display: flex; flex-wrap: wrap; gap: 10px;">
            <a 
              v-for="(attachment, index) in JSON.parse(viewingNews.attachments)" 
              :key="index"
              :href="getImageUrl(attachment)" 
              target="_blank"
              style="display: inline-block; padding: 5px 10px; background: #f0f0f0; border-radius: 4px; text-decoration: none; color: #333;"
            >
              📎 附件{{ index + 1 }}
            </a>
          </div>
        </div>
        <div class="view-item">
          <strong>内容：</strong>
          <div class="content-box" v-html="viewingNews.content"></div>
        </div>
        <div class="view-item">
          <strong>浏览量：</strong>{{ viewingNews.viewCount || 0 }}
        </div>
        <div class="view-item">
          <strong>创建时间：</strong>{{ viewingNews.createTime }}
        </div>
      </div>
      <template #footer>
        <el-button @click="showViewDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- AI审核详情对话框 -->
    <el-dialog v-model="showAiDialog" title="AI审核详情" width="700px" :modal="false" draggable :close-on-click-modal="false">
      <div v-if="aiLoading" style="color:#aaa;">正在思考...</div>
      <div v-else>
        <div style="white-space:pre-line;word-break:break-all;">
          <div v-if="aiMainContentArr.length">
            <div v-for="(item, idx) in aiMainContentArr" :key="item.label" style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
              <div style="flex:1;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                {{ item.label }}：
                <template v-if="item.result==='v'">
                  <span style="color:#67c23a;">通过</span>
                </template>
                <template v-else>
                  <span style="color:#f56c6c;">不通过</span>
                  <span v-if="item.reason && item.reason!=='无'" style="color:#c00;margin-left:8px;">，理由：{{ item.reason }}</span>
                </template>
              </div>
              <div style="flex-shrink:0;">
                <el-button size="small" type="primary" @click="acceptAudit(idx)" :disabled="item.accepting || item.accepted">接受审核</el-button>
                <el-button size="small" @click="viewNews(selectedNews[idx])">查看</el-button>
              </div>
            </div>
          </div>
          <div v-if="aiThoughtContent">
            <span class="ai-thought-toggle" @click="aiShowThought = !aiShowThought" style="cursor:pointer;font-size:12px;color:#aaa;margin-left:8px;user-select:none;">
              [{{ aiShowThought ? '收起思考' : '展开思考' }}]
            </span>
            <div v-show="aiShowThought" style="font-size:12px;color:#bbb;background:#f7f7f7;padding:6px 10px;border-radius:4px;margin:4px 0;white-space:pre-line;">
              {{ aiThoughtContent }}
            </div>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button type="success" @click="acceptAllAudits" :disabled="aiMainContentArr.every(item => item.accepted || item.accepting)">接受全部</el-button>
        <el-button @click="showAiDialog = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../utils/request'

const newsList = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showAuditDialog = ref(false)
const showViewDialog = ref(false)
const showAiDialog = ref(false)
const editingNews = ref(null)
const auditingNews = ref(null)
const viewingNews = ref(null)
const searchKeyword = ref('')
const statusFilter = ref('')
const categoryFilter = ref('')
const authorFilter = ref('')
const createTimeRange = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const auditStatus = ref(1)
const uploadUrl = ref('/api/file/upload')
const selectedNews = ref([])
const aiMainContent = ref('')
const aiMainContentArr = ref([]) // [{label, result, reason, accepted}]
const aiThoughtContent = ref('')
const aiShowThought = ref(false)
const aiLoading = ref(false)

const user = computed(() => {
  const userStr = localStorage.getItem('user')
  return userStr ? JSON.parse(userStr) : {}
})

const newsForm = reactive({
  title: '',
  summary: '',
  content: '',
  category: '',
  coverImage: '',
  contentImages: [],
  videos: [],
  attachments: []
})

const newsFormRef = ref()

onMounted(() => {
  loadNews()
})

const loadNews = async () => {
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
    
    // 添加分类筛选
    if (categoryFilter.value !== '') {
      params.category = categoryFilter.value
    }
    
    // 添加创建时间筛选
    if (createTimeRange.value && createTimeRange.value.length === 2) {
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
    
    // 添加作者筛选
    if (authorFilter.value === 'mine') {
      params.authorId = user.value.id
    }

    const res = await request.get('/news/page', { params })
    newsList.value = res.data.records || []
    total.value = res.data.total || 0
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
  return user.value.role === 'ADMIN' || news.authorId === user.value.id
}

const canAudit = (news) => {
  return user.value.role === 'ADMIN' && news.status === 0
}

const canDelete = (news) => {
  return user.value.role === 'ADMIN' || news.authorId === user.value.id
}

const canSelect = (row) => {
  // 管理员可以选择所有动态，普通用户只能选择自己的动态
  return user.value.role === 'ADMIN' || row.authorId === user.value.id
}

const viewNews = (news) => {
  viewingNews.value = news
  showViewDialog.value = true
}

const editNews = (news) => {
  editingNews.value = news;
  
  // 只设置必要字段，避免后端不需要的字段
  newsForm.title = news.title;
  newsForm.summary = news.summary;
  newsForm.content = news.content;
  newsForm.category = news.category;
  newsForm.coverImage = news.coverImage;
  newsForm.contentImages = news.contentImages ? JSON.parse(news.contentImages) : [];
  newsForm.videos = news.videos ? JSON.parse(news.videos) : [];
  newsForm.attachments = news.attachments ? JSON.parse(news.attachments) : [];
  
  showAddDialog.value = true;
}
// 将日期格式化为 yyyy-MM-dd HH:mm:ss
const formatDateTime = (date) => {
  if (!date) return '';
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  const seconds = String(d.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

const convertIfDate = (value) => {
    return value instanceof Date ? formatDateTime(value) : value;
};

const saveNews = async () => {
  try {
    // 验证必填字段
    if (!newsForm.title.trim()) {
      ElMessage.error('请输入标题')
      return
    }
    if (!newsForm.content.trim()) {
      ElMessage.error('请输入内容')
      return
    }
    if (!newsForm.category) {
      ElMessage.error('请选择分类')
      return
    }
// 格式化时间字段
    if (newsForm.createTime) {
      newsForm.createTime = formatDateTime(newsForm.createTime);
    }
    if (newsForm.updateTime) {
      newsForm.updateTime = formatDateTime(newsForm.updateTime);
    }
    if (newsForm.auditTime) {
      newsForm.auditTime = formatDateTime(newsForm.auditTime);
    }

    // 准备提交数据
    const formData = {
      ...newsForm,
      contentImages: JSON.stringify(newsForm.contentImages),
      videos: JSON.stringify(newsForm.videos),
      attachments: JSON.stringify(newsForm.attachments)
    }
    
    if (editingNews.value) {
      await request.put(`/news/${editingNews.value.id}`, formData)
      ElMessage.success('更新成功')
    } else {
      await request.post('/news', formData)
      ElMessage.success('发布成功')
    }
    showAddDialog.value = false
    resetForm()
    loadNews()
  } catch (error) {
    console.error('保存动态失败:', error)
    ElMessage.error('保存失败')
  }
}

const auditNews = (news) => {
  auditingNews.value = news
  auditStatus.value = 1
  showAuditDialog.value = true
}

const submitAudit = async () => {
  try {
    await request.post(`/news/${auditingNews.value.id}/audit`, {
      status: auditStatus.value
    })
    ElMessage.success('审核成功')
    showAuditDialog.value = false
    loadNews()
  } catch (error) {
    console.error('审核失败:', error)
  }
}

const deleteNews = async (news) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除动态"${news.title}"吗？删除后不可恢复！`, 
      '确认删除', 
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      }
    )
    await request.delete(`/news/${news.id}`)
    ElMessage.success('删除成功')
    loadNews()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除动态失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

const resetForm = () => {
  editingNews.value = null
  Object.assign(newsForm, {
    title: '',
    summary: '',
    content: '',
    category: '',
    coverImage: '',
    contentImages: [],
    videos: [],
    attachments: []
  })
}

// 重置筛选条件
const resetFilters = () => {
  searchKeyword.value = ''
  statusFilter.value = ''
  categoryFilter.value = ''
  authorFilter.value = ''
  createTimeRange.value = []
  currentPage.value = 1
  loadNews()
}

// 打开发布对话框
const openAddDialog = () => {
  resetForm()
  showAddDialog.value = true
}

const handleCoverSuccess = (response) => {
  if (response.code === 200) {
    newsForm.coverImage = response.data
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error('图片上传失败')
  }
}

const beforeImageUpload = (file) => {
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

const beforeVideoUpload = (file) => {
  const isVideo = file.type.indexOf('video/') === 0
  const isLt50M = file.size / 1024 / 1024 < 50

  if (!isVideo) {
    ElMessage.error('只能上传视频文件!')
    return false
  }
  if (!isLt50M) {
    ElMessage.error('视频大小不能超过 50MB!')
    return false
  }
  return true
}

const beforeAttachmentUpload = (file) => {
  const isLt10M = file.size / 1024 / 1024 < 10

  if (!isLt10M) {
    ElMessage.error('附件大小不能超过 10MB!')
    return false
  }
  return true
}

const handleContentImageSuccess = (response) => {
  if (response.code === 200) {
    newsForm.contentImages.push(response.data)
    ElMessage.success('内容图片上传成功，可复制链接插入到内容中：' + getImageUrl(response.data))
  } else {
    ElMessage.error('图片上传失败')
  }
}

const handleVideoSuccess = (response) => {
  if (response.code === 200) {
    newsForm.videos.push(response.data)
    ElMessage.success('视频上传成功')
  } else {
    ElMessage.error('视频上传失败')
  }
}

const handleAttachmentSuccess = (response) => {
  if (response.code === 200) {
    newsForm.attachments.push(response.data)
    ElMessage.success('附件上传成功')
  } else {
    ElMessage.error('附件上传失败')
  }
}

const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) return imagePath
  return `http://localhost:8080/api${imagePath}`
}

const exportNews = async () => {
  try {
    const params = {
      keyword: searchKeyword.value
    }
    
    if (statusFilter.value !== '') {
      params.status = statusFilter.value
    }
    
    if (categoryFilter.value !== '') {
      params.category = categoryFilter.value
    }
    
    if (authorFilter.value === 'mine') {
      params.authorId = user.value.id
    }
    
    const res = await request.get('/news/export', {
      params,
      responseType: 'blob'
    })
    
    const blob = new Blob([res], { type: 'text/csv;charset=utf-8' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `news_${new Date().toISOString().split('T')[0]}.csv`
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
  loadNews()
}

const handleSelectionChange = (selected) => {
  selectedNews.value = selected
}

const batchAudit = async () => {
  try {
    // 检查权限：只有管理员可以批量审核
    if (user.value.role !== 'ADMIN') {
      ElMessage.error('只有管理员可以批量审核')
      return
    }
    
    await ElMessageBox.confirm('确定要批量审核选中的动态吗？', '提示')
    const ids = selectedNews.value.map(news => news.id)
    await request.post('/news/batch/audit', {
      ids,
      status: 1
    })
    ElMessage.success('批量审核成功')
    selectedNews.value = []
    loadNews()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量审核失败:', error)
      ElMessage.error('批量审核失败')
    }
  }
}

const batchDelete = async () => {
  try {
    // 检查权限：普通用户只能删除自己的动态
    const unauthorizedNews = selectedNews.value.filter(news => 
      user.value.role !== 'ADMIN' && news.authorId !== user.value.id
    )
    
    if (unauthorizedNews.length > 0) {
      ElMessage.error(`选中的动态中有${unauthorizedNews.length}条不是您创建的，无法删除`)
      return
    }
    
    await ElMessageBox.confirm(
      `确定要删除选中的${selectedNews.value.length}条动态吗？删除后不可恢复！`, 
      '确认批量删除', 
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      }
    )
    const ids = selectedNews.value.map(news => news.id)
    await request.delete('/news/batch', {
      data: { ids }
    })
    ElMessage.success('批量删除成功')
    selectedNews.value = []
    loadNews()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

// 新增AI审核相关逻辑
function parseAiResult(str) {
  // 兼容中英文分号和有无空格
  return str.split(/[；;]\s*/).map(s => s.trim()).filter(Boolean).map((item, idx) => {
    // 动态1:x,理由 或 动态1:v,无
    const m = item.match(/^(动态\d+):(v|x),(.+)$/)
    if (m) {
      return { label: m[1], result: m[2], reason: m[3], accepted: false }
    } else {
      // 容错
      return { label: `动态${idx+1}`, result: 'x', reason: '解析失败', accepted: false }
    }
  })
}
const batchAiAudit = async () => {
  if (selectedNews.value.length === 0) {
    ElMessage.warning('请先选择要审核的动态')
    return
  }
  const auditObj = {}
  selectedNews.value.forEach((item, idx) => {
    auditObj[`动态${idx + 1}`] = item.summary || item.content || item.title || ''
  })
  const query = JSON.stringify(auditObj)
  const chatRequest = {
    query: query,
    response_mode: 'streaming',
    user: user.value.username || 'admin'
  }
  ElMessage.info('AI审核中，请稍候...')
  showAiDialog.value = true
  aiMainContent.value = ''
  aiMainContentArr.value = []
  aiThoughtContent.value = ''
  aiShowThought.value = false
  aiLoading.value = true

  const response = await fetch('/api/LLM/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(chatRequest)
  })
  if (!response.body) {
    ElMessage.error('AI接口无响应')
    aiLoading.value = false
    return
  }
  const reader = response.body.getReader()
  const decoder = new TextDecoder('utf-8')
  let done = false
  let buffer = ''
  let lastStreamId = -1
  const TempId = ref(-1);
  let isThinking = false
  let mainStream = ''
  let thoughtStream = ''
  while (!done) {
    const { value, done: readerDone } = await reader.read()
    done = readerDone
    if (value) {
      buffer += decoder.decode(value, { stream: true })
      // 匹配所有 {...} 片段
      const regex = /({.*?})/gs
      let match
      while ((match = regex.exec(buffer)) !== null) {
        let cleanedJson = match[1].replace(/\n\ndata:/, '').trim()
        try {
          const obj = JSON.parse(cleanedJson)
          if (Number(obj.stream_id) <= Number(TempId.value)) continue;
          TempId.value = obj.stream_id;
          if (typeof obj.stream_id === 'number' && obj.stream_id <= lastStreamId) continue
          lastStreamId = obj.stream_id
          if (typeof obj.answer === 'string') {
            let answer = obj.answer
            // 逐行处理流内容，分离思考和正文，流式显示
            let i = 0
            while (i < answer.length) {
              // 检查<think>标签
              if (answer.startsWith('<think>', i)) {
                isThinking = true
                i += 7
                continue
              }
              if (answer.startsWith('</think>', i)) {
                isThinking = false
                i += 8
                continue
              }
              // 跳过“正文部分”字样
              if (answer.startsWith('正文部分', i)) {
                i += 4
                continue
              }
              // 流式追加
              if (isThinking) {
                thoughtStream += answer[i]
                aiThoughtContent.value = thoughtStream
              } else {
                mainStream += answer[i]
                aiMainContent.value = mainStream
              }
              i++
            }
          }
        } catch (e) {
          // JSON解析失败
        }
        break;
      }
      // 只保留最后一个未完整匹配的片段
      const lastDataIdx = buffer.lastIndexOf('data:')
      if (lastDataIdx !== -1) {
        buffer = buffer.slice(lastDataIdx)
      } else {
        buffer = ''
      }
    }
  }
  aiLoading.value = false
  // 处理AI返回内容，适配“动态1:x,理由； 动态2:v,无...”格式
  let resultStr = aiMainContent.value.trim()
  if (!resultStr) {
    ElMessage.error('AI返回内容为空')
    return
  }
  // 过滤掉所有<think>标签和“正文部分”
  resultStr = resultStr.replace(/<think>/g, '').replace(/<\/think>/g, '').replace(/正文部分/g, '')
  aiMainContentArr.value = parseAiResult(resultStr)
}
// 用户点击“接受审核”按钮
function acceptAudit(idx) {
  const item = aiMainContentArr.value[idx]
  if (item.accepted || item.accepting) return
  const news = selectedNews.value[idx]
  if (!news) return
  item.accepting = true
  const status = item.result === 'v' ? 1 : 2
  request.post(`/news/${news.id}/audit`, { status }).then(() => {
    item.accepted = true
    item.accepting = false
    ElMessage.success(`${item.label}审核结果已应用`)
    loadNews()
  }).catch(() => {
    item.accepting = false
    ElMessage.error(`${item.label}审核应用失败`)
  })
}

function acceptAllAudits() {
  const promises = []
  aiMainContentArr.value.forEach((item, idx) => {
    if (!item.accepted && !item.accepting) {
      item.accepting = true
      const news = selectedNews.value[idx]
      if (!news) {
        item.accepting = false
        return
      }
      const status = item.result === 'v' ? 1 : 2
      promises.push(
        request.post(`/news/${news.id}/audit`, { status }).then(() => {
          item.accepted = true
          item.accepting = false
        }).catch(() => {
          item.accepting = false
        })
      )
    }
  })
  if (promises.length > 0) {
    Promise.all(promises).then(() => {
      ElMessage.success('全部审核结果已应用')
      loadNews()
    }).catch(() => {
      ElMessage.error('部分审核应用失败')
    })
  }
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

.upload-tip {
  color: #999;
  font-size: 12px;
  margin-top: 5px;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}

.empty-data {
  padding: 40px 0;
}

.view-item {
  margin-bottom: 15px;
}

.content-box {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  padding: 10px;
  background-color: #f5f7fa;
  max-height: 300px;
  overflow-y: auto;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}

.view-item {
  margin-bottom: 15px;
  line-height: 1.6;
}

.content-box {
  margin-top: 10px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
  white-space: pre-wrap;
  max-height: 300px;
  overflow-y: auto;
}

.empty-data {
  padding: 40px 0;
}
</style> 