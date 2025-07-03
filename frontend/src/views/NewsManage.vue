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
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../utils/request'

const courseList = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showAuditDialog = ref(false)
const showViewDialog = ref(false)
const showVideoDialog = ref(false)
const showVideoPreviewDialog = ref(false)
const editingCourse = ref(null)
const auditingCourse = ref(null)
const viewingCourse = ref(null)
const previewingVideo = ref(null)
const searchKeyword = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const uploadUrl = ref('/api/file/upload')
const auditStatus = ref(1)
const selectedCourses = ref([])
const courseVideos = ref([])
const editingVideoIndex = ref(-1)

const user = computed(() => {
  const userStr = localStorage.getItem('user')
  return userStr ? JSON.parse(userStr) : {}
})

const courseForm = reactive({
  title: '',
  description: '',
  coverImage: '',
  videoUrl: '',
  sortOrder: 0
})

const videoForm = reactive({
  videoTitle: '',
  videoUrl: '',
  videoDescription: '',
  videoDuration: 0,
  sortOrder: 1,
  isFree: 0,
  status: 1
})

const courseFormRef = ref()

onMounted(() => {
  loadCourses()
})

const loadCourses = async () => {
  loading.value = true
  try {
    const params = {
      current: currentPage.value,
      size: pageSize.value,
      keyword: searchKeyword.value
    }
    
    if (statusFilter.value !== '') {
      params.status = statusFilter.value
    }
    
    const res = await request.get('/course/page', { params })
    courseList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载课程列表失败:', error)
    courseList.value = []
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

const viewCourse = (course) => {
  viewingCourse.value = course
  showViewDialog.value = true
}

const editCourse = async (course) => {
  editingCourse.value = course
  Object.assign(courseForm, {
    title: course.title,
    description: course.description,
    coverImage: course.coverImage,
    videoUrl: course.videoUrl,
    sortOrder: course.sortOrder
  })
  await loadCourseVideos(course.id)
  showAddDialog.value = true
}

const saveCourse = async () => {
  if (!courseForm.title) {
    ElMessage.error('请输入课程名称')
    return
  }
  if (!courseForm.description) {
    ElMessage.error('请输入课程描述')
    return
  }
  
  try {
    if (editingCourse.value) {
      // 更新课程基本信息
      await request.put(`/course/${editingCourse.value.id}`, courseForm)
      
      // 保存视频数据
      if (courseVideos.value.length > 0) {
        console.log('需要保存的视频数量:', courseVideos.value.length)
        let videoSaveCount = 0
        let videoFailCount = 0
        
        for (const video of courseVideos.value) {
          const videoData = {
            title: video.videoTitle || video.title,
            videoUrl: video.videoUrl,
            description: video.videoDescription || video.description,
            duration: video.videoDuration || video.duration || 0,
            sortOrder: video.sortOrder || 1,
            isFree: video.isFree !== undefined ? video.isFree : 0,
            status: video.status !== undefined ? video.status : 1
          }
          
          console.log('保存视频数据:', videoData)
          
          try {
            if (video.id && !String(video.id).startsWith('temp_')) {
              // 更新现有视频
              await request.put(`/course/${editingCourse.value.id}/videos/${video.id}`, videoData)
              console.log('视频更新成功:', video.id)
            } else {
              // 添加新视频
              const videoRes = await request.post(`/course/${editingCourse.value.id}/videos`, videoData)
              console.log('视频添加成功:', videoRes)
            }
            videoSaveCount++
          } catch (videoError) {
            console.error('保存视频失败:', videoError)
            videoFailCount++
            ElMessage.error(`保存视频 "${videoData.title}" 失败`)
          }
        }
        
        if (videoFailCount > 0) {
          ElMessage.warning(`${videoSaveCount} 个视频保存成功，${videoFailCount} 个视频保存失败`)
        }
      }
      ElMessage.success('更新成功')
    } else {
      // 创建新课程
      const courseRes = await request.post('/course', courseForm)
      const newCourseId = courseRes.data.id
      
      console.log('创建课程成功，课程ID:', newCourseId)
      console.log('需要保存的视频数量:', courseVideos.value.length)
      
      // 保存视频数据
      if (courseVideos.value.length > 0 && newCourseId) {
        let videoSaveCount = 0
        let videoFailCount = 0
        
        for (const video of courseVideos.value) {
          const videoData = {
            title: video.videoTitle || video.title,
            videoUrl: video.videoUrl,
            description: video.videoDescription || video.description,
            duration: video.videoDuration || video.duration || 0,
            sortOrder: video.sortOrder || 1,
            isFree: video.isFree !== undefined ? video.isFree : 0,
            status: video.status !== undefined ? video.status : 1
          }
          
          console.log('新课程保存视频数据:', videoData)
          console.log('保存视频到课程ID:', newCourseId)
          
          try {
            const videoRes = await request.post(`/course/${newCourseId}/videos`, videoData)
            console.log('视频保存成功:', videoRes)
            videoSaveCount++
          } catch (videoError) {
            console.error('保存视频失败:', videoError)
            videoFailCount++
            ElMessage.error(`保存视频 "${videoData.title}" 失败`)
          }
        }
        
        if (videoFailCount > 0) {
          ElMessage.warning(`课程创建成功，${videoSaveCount} 个视频保存成功，${videoFailCount} 个视频保存失败`)
        } else if (videoSaveCount > 0) {
          ElMessage.success(`课程和 ${videoSaveCount} 个视频创建成功`)
        }
      } else if (courseVideos.value.length === 0) {
        ElMessage.success('课程创建成功')
      }
    }
    showAddDialog.value = false
    resetForm()
    loadCourses()
  } catch (error) {
    console.error('保存课程失败:', error)
    ElMessage.error('保存课程失败')
  }
}

const deleteCourse = async (course) => {
  try {
    await ElMessageBox.confirm('确定要删除这个课程吗？', '提示')
    await request.delete(`/course/${course.id}`)
    ElMessage.success('删除成功')
    loadCourses()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除课程失败:', error)
    }
  }
}

const resetForm = () => {
  editingCourse.value = null
  Object.assign(courseForm, {
    title: '',
    description: '',
    coverImage: '',
    videoUrl: '',
    sortOrder: 0
  })
  courseVideos.value = []
}

const resetVideoForm = () => {
  editingVideoIndex.value = -1
  Object.assign(videoForm, {
    videoTitle: '',
    videoUrl: '',
    videoDescription: '',
    videoDuration: 0,
    sortOrder: courseVideos.value.length + 1,
    isFree: 0,
    status: 1
  })
}

// 视频管理相关方法
const loadCourseVideos = async (courseId) => {
  if (!courseId) {
    courseVideos.value = []
    return
  }
  
  try {
    // 添加admin=true参数，获取所有视频（管理端）
    const res = await request.get(`/course/${courseId}/videos?admin=true`)
    console.log('加载课程视频列表:', res.data)
    courseVideos.value = res.data || []
  } catch (error) {
    console.error('加载课程视频失败:', error)
    courseVideos.value = []
  }
}

const editVideo = (video, index) => {
  editingVideoIndex.value = index
  Object.assign(videoForm, {
    videoTitle: video.videoTitle || video.title,
    videoUrl: video.videoUrl,
    videoDescription: video.videoDescription || video.description,
    videoDuration: video.videoDuration || video.duration || 0,
    sortOrder: video.sortOrder || 1,
    isFree: (video.isFree !== undefined ? video.isFree : 0),
    status: video.status !== undefined ? video.status : 1
  })
  showVideoDialog.value = true
}

const removeVideo = async (index) => {
  const video = courseVideos.value[index]
  
  try {
    await ElMessageBox.confirm('确定要删除这个视频吗？', '提示')
    
    // 如果是已存在的视频，需要调用后端API删除
    if (video.id && !String(video.id).startsWith('temp_') && editingCourse.value) {
      await request.delete(`/course/${editingCourse.value.id}/videos/${video.id}`)
      ElMessage.success('删除视频成功')
    }
    
    // 从前端数组中删除
    courseVideos.value.splice(index, 1)
    
    // 如果是新添加的视频，只需从数组中删除即可
    if (!video.id || String(video.id).startsWith('temp_')) {
      ElMessage.success('删除视频成功')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除视频失败:', error)
      ElMessage.error('删除视频失败')
    }
  }
}

const previewVideo = (video) => {
  previewingVideo.value = video
  showVideoPreviewDialog.value = true
}

const clearVideoFile = () => {
  videoForm.videoUrl = ''
  videoForm.videoDuration = 0
}

const getVideoUrl = (videoPath) => {
  if (!videoPath) return ''
  if (videoPath.startsWith('http://') || videoPath.startsWith('https://')) {
    return videoPath
  }
  return `http://localhost:8080/api${videoPath}`
}

const saveVideo = () => {
  if (!videoForm.videoTitle) {
    ElMessage.error('请输入视频标题')
    return
  }
  if (!videoForm.videoUrl) {
    ElMessage.error('请上传视频文件')
    return
  }
  
  const videoData = {
    videoTitle: videoForm.videoTitle,
    videoUrl: videoForm.videoUrl,
    videoDescription: videoForm.videoDescription,
    videoDuration: videoForm.videoDuration,
    sortOrder: videoForm.sortOrder,
    isFree: videoForm.isFree,
    status: videoForm.status,
    formattedDuration: formatDuration(videoForm.videoDuration)
  }
  
  if (editingVideoIndex.value >= 0) {
    // 编辑现有视频
    courseVideos.value[editingVideoIndex.value] = { ...courseVideos.value[editingVideoIndex.value], ...videoData }
  } else {
    // 添加新视频，使用临时ID
    courseVideos.value.push({ id: 'temp_' + Date.now(), ...videoData })
  }
  
  showVideoDialog.value = false
  resetVideoForm()
  ElMessage.success(editingVideoIndex.value >= 0 ? '更新视频成功' : '添加视频成功')
}

const handleVideoFileSuccess = (response, file) => {
  if (response.code === 200) {
    videoForm.videoUrl = response.data
    // 自动检测视频时长
    detectVideoDuration(response.data, file.raw)
    ElMessage.success('视频上传成功')
  } else {
    ElMessage.error('视频上传失败')
  }
}

const detectVideoDuration = (videoUrl, file) => {
  // 创建一个临时的video元素来检测时长
  const video = document.createElement('video')
  video.preload = 'metadata'
  
  video.onloadedmetadata = () => {
    if (video.duration && !isNaN(video.duration)) {
      videoForm.videoDuration = Math.round(video.duration)
      console.log('检测到视频时长:', videoForm.videoDuration, '秒')
    }
    // 清理资源
    video.remove()
  }
  
  video.onerror = () => {
    console.warn('无法检测视频时长')
    video.remove()
  }
  
  // 如果有文件对象，直接使用
  if (file) {
    const url = URL.createObjectURL(file)
    video.src = url
    video.onloadedmetadata = () => {
      if (video.duration && !isNaN(video.duration)) {
        videoForm.videoDuration = Math.round(video.duration)
        console.log('检测到视频时长:', videoForm.videoDuration, '秒')
      }
      URL.revokeObjectURL(url)
      video.remove()
    }
  } else {
    // 使用服务器URL
    const fullUrl = `http://localhost:8080/api${videoUrl}`
    video.src = fullUrl
  }
}

const formatDuration = (seconds) => {
  if (!seconds || seconds <= 0) return '00:00'
  const minutes = Math.floor(seconds / 60)
  const remainingSeconds = seconds % 60
  return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`
}

const handleCoverSuccess = (response) => {
  if (response.code === 200) {
    courseForm.coverImage = response.data
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error('封面上传失败')
  }
}

const handleVideoSuccess = (response, file) => {
  if (response.code === 200) {
    courseForm.videoUrl = response.data
    // 自动检测视频时长
    detectCourseVideoDuration(response.data, file.raw)
    ElMessage.success('视频上传成功')
  } else {
    ElMessage.error('视频上传失败')
  }
}

const detectCourseVideoDuration = (videoUrl, file) => {
  // 为课程视频创建时长检测（与视频列表的检测类似）
  const video = document.createElement('video')
  video.preload = 'metadata'
  
  video.onloadedmetadata = () => {
    if (video.duration && !isNaN(video.duration)) {
      console.log('检测到课程视频时长:', Math.round(video.duration), '秒')
    }
    video.remove()
  }
  
  video.onerror = () => {
    console.warn('无法检测课程视频时长')
    video.remove()
  }
  
  if (file) {
    const url = URL.createObjectURL(file)
    video.src = url
    video.onloadedmetadata = () => {
      if (video.duration && !isNaN(video.duration)) {
        console.log('检测到课程视频时长:', Math.round(video.duration), '秒')
      }
      URL.revokeObjectURL(url)
      video.remove()
    }
  } else {
    const fullUrl = `http://localhost:8080/api${videoUrl}`
    video.src = fullUrl
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
  // 支持的视频格式
  const allowedTypes = [
    'video/mp4',
    'video/avi',
    'video/mov',
    'video/wmv',
    'video/flv',
    'video/webm',
    'video/mkv',
    'video/3gp',
    'video/m4v'
  ]
  
  const isVideo = allowedTypes.includes(file.type) || file.type.indexOf('video/') === 0
  const isLt100M = file.size / 1024 / 1024 < 100

  if (!isVideo) {
    ElMessage.error('只能上传视频文件！支持格式：MP4、AVI、MOV、WMV、FLV、WebM、MKV、3GP、M4V')
    return false
  }
  if (!isLt100M) {
    ElMessage.error('视频大小不能超过 100MB!')
    return false
  }
  return true
}

const canAudit = (course) => {
  return user.value.role === 'ADMIN' && course.status === 0
}

const auditCourse = (course) => {
  auditingCourse.value = course
  auditStatus.value = 1
  showAuditDialog.value = true
}

const submitAudit = async () => {
  try {
    await request.post(`/course/${auditingCourse.value.id}/audit`, {
      status: auditStatus.value
    })
    ElMessage.success('审核成功')
    showAuditDialog.value = false
    loadCourses()
  } catch (error) {
    console.error('审核失败:', error)
  }
}

const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) return imagePath
  return `http://localhost:8080/api${imagePath}`
}

const exportCourses = async () => {
  try {
    const res = await request.get('/course/export', {
      params: {
        keyword: searchKeyword.value
      },
      responseType: 'blob'
    })
    
    const blob = new Blob([res], { type: 'text/csv;charset=utf-8' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `courses_${new Date().toISOString().split('T')[0]}.csv`
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
  loadCourses()
}

const handleSelectionChange = (selected) => {
  selectedCourses.value = selected.map(course => course.id)
}

const batchAudit = async () => {
  try {
    await request.post('/course/batch/audit', {
      ids: selectedCourses.value
    })
    ElMessage.success('批量审核成功')
    selectedCourses.value = []
    loadCourses()
  } catch (error) {
    console.error('批量审核失败:', error)
  }
}

const batchDelete = async () => {
  try {
    await ElMessageBox.confirm('确定要删除选中的课程吗？', '提示')
    await request.delete('/course/batch', {
      data: {
        ids: selectedCourses.value
      }
    })
    ElMessage.success('批量删除成功')
    selectedCourses.value = []
    loadCourses()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
    }
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