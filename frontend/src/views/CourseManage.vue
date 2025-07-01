<template>
  <div class="course-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>课程管理</span>
          <div>
            <el-button type="warning" @click="batchAudit" :disabled="selectedCourses.length === 0" v-if="user.role === 'ADMIN'">批量审核</el-button>
            <el-button type="danger" @click="batchDelete" :disabled="selectedCourses.length === 0">批量删除</el-button>
            <el-button type="success" @click="exportCourses">导出课程</el-button>
            <el-button type="primary" @click="showAddDialog = true">添加课程</el-button>
          </div>
        </div>
      </template>

      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="请输入课程名称或作者"
          style="width: 300px"
          clearable
          @keyup.enter="loadCourses"
        >
          <template #append>
            <el-button @click="loadCourses">搜索</el-button>
          </template>
        </el-input>
        <el-select v-model="statusFilter" placeholder="状态筛选" style="margin-left: 10px; width: 120px" @change="loadCourses">
          <el-option label="全部" value="" />
          <el-option label="待审核" value="0" />
          <el-option label="已发布" value="1" />
          <el-option label="已拒绝" value="2" />
        </el-select>
      </div>

      <el-table :data="courseList" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <template #empty>
          <div class="empty-data">
            <el-empty description="暂无课程数据" />
          </div>
        </template>
        <el-table-column type="selection" width="55" />
        <el-table-column prop="title" label="课程名称" width="180" show-overflow-tooltip />
        <el-table-column label="封面" width="80">
          <template #default="scope">
            <img v-if="scope.row.coverImage" :src="getImageUrl(scope.row.coverImage)" style="width: 50px; height: 30px; object-fit: cover;" />
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="课程简介" width="180" show-overflow-tooltip />
        <el-table-column prop="author" label="作者" width="120" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览量" width="100" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="250">
          <template #default="scope">
            <el-button size="small" @click="viewCourse(scope.row)">查看</el-button>
            <el-button size="small" @click="editCourse(scope.row)">编辑</el-button>
            <el-button size="small" type="primary" @click="auditCourse(scope.row)" v-if="canAudit(scope.row)">审核</el-button>
            <el-button size="small" type="danger" @click="deleteCourse(scope.row)">删除</el-button>
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
          @current-change="loadCourses"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>

    <!-- 添加/编辑课程对话框 -->
    <el-dialog v-model="showAddDialog" :title="editingCourse ? '编辑课程' : '添加课程'" width="600px">
      <el-form :model="courseForm" ref="courseFormRef" label-width="100px">
        <el-form-item label="课程名称">
          <el-input v-model="courseForm.title" />
        </el-form-item>
        <el-form-item label="课程简介">
          <el-input v-model="courseForm.description" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="课程封面">
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="false"
            :on-success="handleCoverSuccess"
            :before-upload="beforeImageUpload"
          >
            <el-button size="small" type="primary">点击上传</el-button>
          </el-upload>
          <div v-if="courseForm.coverImage" style="margin-top: 10px;">
            <img :src="getImageUrl(courseForm.coverImage)" style="width: 100px; height: 60px; object-fit: cover;" />
            <el-button size="small" type="danger" @click="courseForm.coverImage = ''" style="margin-left: 10px;">删除</el-button>
          </div>
        </el-form-item>
        <el-form-item label="课程视频">
          <div class="video-upload-section">
            <div class="video-list" v-if="courseVideos.length > 0">
              <div v-for="(video, index) in courseVideos" :key="video.id || index" class="video-item">
                <div class="video-preview" v-if="video.videoUrl">
                  <video :src="getVideoUrl(video.videoUrl)" style="width: 120px; height: 80px; object-fit: cover;" muted>
                    您的浏览器不支持视频播放
                  </video>
                </div>
                <div class="video-info">
                  <div class="video-title">{{ video.videoTitle }}</div>
                  <div class="video-meta">
                    <span>时长: {{ video.formattedDuration || formatDuration(video.videoDuration) || '00:00' }}</span>
                    <span>{{ video.isFree ? '免费' : '付费' }}</span>
                    <span>排序: {{ video.sortOrder }}</span>
                  </div>
                  <div class="video-description" v-if="video.videoDescription">
                    {{ video.videoDescription }}
                  </div>
                </div>
                <div class="video-actions">
                  <el-button size="small" @click="previewVideo(video)">预览</el-button>
                  <el-button size="small" @click="editVideo(video, index)">编辑</el-button>
                  <el-button size="small" type="danger" @click="removeVideo(index)">删除</el-button>
                </div>
              </div>
            </div>
            <el-button type="primary" @click="showVideoDialog = true">添加视频</el-button>
          </div>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="courseForm.sortOrder" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveCourse">保存</el-button>
      </template>
    </el-dialog>

    <!-- 审核对话框 -->
    <el-dialog v-model="showAuditDialog" title="审核课程" width="400px">
      <div style="margin-bottom: 20px;">
        <strong>课程名称：</strong>{{ auditingCourse && auditingCourse.title }}
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
    <el-dialog v-model="showViewDialog" title="查看课程" width="800px">
      <div v-if="viewingCourse">
        <div class="view-item">
          <strong>课程名称：</strong>{{ viewingCourse.title }}
        </div>
        <div class="view-item">
          <strong>作者：</strong>{{ viewingCourse.author }}
        </div>
        <div class="view-item">
          <strong>状态：</strong>
          <el-tag :type="getStatusType(viewingCourse.status)">
            {{ getStatusText(viewingCourse.status) }}
          </el-tag>
        </div>
        <div class="view-item">
          <strong>课程简介：</strong>{{ viewingCourse.description }}
        </div>
        <div class="view-item" v-if="viewingCourse.coverImage">
          <strong>课程封面：</strong><br/>
          <img :src="getImageUrl(viewingCourse.coverImage)" style="max-width: 300px; max-height: 200px; object-fit: cover;" />
        </div>
        <div class="view-item" v-if="viewingCourse.videoUrl">
          <strong>课程视频：</strong><br/>
          <video :src="getImageUrl(viewingCourse.videoUrl)" controls style="max-width: 400px; max-height: 300px;"></video>
        </div>
        <div class="view-item">
          <strong>排序：</strong>{{ viewingCourse.sortOrder }}
        </div>
        <div class="view-item">
          <strong>浏览量：</strong>{{ viewingCourse.viewCount || 0 }}
        </div>
        <div class="view-item">
          <strong>创建时间：</strong>{{ viewingCourse.createTime }}
        </div>
      </div>
      <template #footer>
        <el-button @click="showViewDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 视频预览对话框 -->
    <el-dialog v-model="showVideoPreviewDialog" title="视频预览" width="800px">
      <div v-if="previewingVideo">
        <div style="text-align: center; margin-bottom: 20px;">
          <video :src="getVideoUrl(previewingVideo.videoUrl)" controls style="width: 100%; max-width: 600px; height: 400px;">
            您的浏览器不支持视频播放
          </video>
        </div>
        <div class="preview-info">
          <div class="preview-item">
            <strong>视频标题：</strong>{{ previewingVideo.videoTitle }}
          </div>
          <div class="preview-item">
            <strong>视频时长：</strong>{{ formatDuration(previewingVideo.videoDuration) }}
          </div>
          <div class="preview-item">
            <strong>视频描述：</strong>{{ previewingVideo.videoDescription || '无描述' }}
          </div>
          <div class="preview-item">
            <strong>是否免费：</strong>{{ previewingVideo.isFree ? '免费' : '付费' }}
          </div>
          <div class="preview-item">
            <strong>排序：</strong>{{ previewingVideo.sortOrder }}
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="showVideoPreviewDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 视频管理对话框 -->
    <el-dialog v-model="showVideoDialog" :title="editingVideoIndex >= 0 ? '编辑视频' : '添加视频'" width="600px">
      <el-form :model="videoForm" ref="videoFormRef" label-width="100px">
        <el-form-item label="视频标题" required>
          <el-input v-model="videoForm.videoTitle" placeholder="请输入视频标题" />
        </el-form-item>
        <el-form-item label="视频文件" required>
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :show-file-list="false"
            :on-success="handleVideoFileSuccess"
            :before-upload="beforeVideoUpload"
          >
            <el-button size="small" type="primary">点击上传视频</el-button>
          </el-upload>
          <div v-if="videoForm.videoUrl" style="margin-top: 10px;">
            <div style="margin-bottom: 10px;">
              <video :src="getVideoUrl(videoForm.videoUrl)" controls style="width: 100%; max-width: 400px; height: 200px;">
                您的浏览器不支持视频播放
              </video>
            </div>
            <div style="margin-bottom: 10px;">
              <span style="color: #666; font-size: 12px;">{{ videoForm.videoUrl }}</span>
            </div>
            <el-button size="small" type="danger" @click="clearVideoFile">删除视频</el-button>
          </div>
        </el-form-item>
        <el-form-item label="视频描述">
          <el-input v-model="videoForm.videoDescription" type="textarea" :rows="3" placeholder="请输入视频描述" />
        </el-form-item>
        <el-form-item label="视频时长">
          <el-input-number v-model="videoForm.videoDuration" :min="0" placeholder="秒" />
          <span style="margin-left: 10px; color: #999;">秒（可选，系统会自动检测）</span>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="videoForm.sortOrder" :min="1" />
        </el-form-item>
        <el-form-item label="是否免费">
          <el-radio-group v-model="videoForm.isFree">
            <el-radio :label="1">免费</el-radio>
            <el-radio :label="0">付费</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="videoForm.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showVideoDialog = false">取消</el-button>
        <el-button type="primary" @click="saveVideo">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const courseList = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const showViewDialog = ref(false)
const editingCourse = ref(null)
const viewingCourse = ref(null)
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const uploadUrl = ref('/api/file/upload')

const courseForm = reactive({
  title: '',
  description: '',
  coverImage: ''
})

onMounted(() => {
  loadCourses()
})

const loadCourses = async () => {
  loading.value = true
  try {
    // 这里应该是实际的API调用
    const mockData = {
      data: {
        records: [
          {
            id: 1,
            title: 'Vue3入门教程',
            description: '从零开始学习Vue3框架',
            coverImage: '/images/course1.jpg',
            author: '张老师',
            status: 1,
            createTime: '2023-05-15 10:00:00'
          },
          {
            id: 2,
            title: 'React高级课程',
            description: '深入理解React原理',
            coverImage: '/images/course2.jpg',
            author: '李老师',
            status: 0,
            createTime: '2023-05-10 14:30:00'
          }
        ],
        total: 2
      }
    }
    courseList.value = mockData.data.records
    total.value = mockData.data.total
  } catch (error) {
    console.error('加载课程列表失败:', error)
    courseList.value = []
  } finally {
    loading.value = false
  }
}

const viewCourse = (course) => {
  viewingCourse.value = course
  showViewDialog.value = true
}

const editCourse = (course) => {
  editingCourse.value = course
  Object.assign(courseForm, {
    title: course.title,
    description: course.description,
    coverImage: course.coverImage
  })
  showAddDialog.value = true
}

const saveCourse = async () => {
  if (!courseForm.title) {
    ElMessage.error('请输入课程名称')
    return
  }
  
  try {
    if (editingCourse.value) {
      // 更新API调用
      ElMessage.success('更新成功')
    } else {
      // 创建API调用
      ElMessage.success('添加成功')
    }
    showAddDialog.value = false
    resetForm()
    loadCourses()
  } catch (error) {
    console.error('保存课程失败:', error)
  }
}

const deleteCourse = async (course) => {
  try {
    await ElMessageBox.confirm('确定要删除这个课程吗？', '提示')
    // 删除API调用
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
    coverImage: ''
  })
}

const handleCoverSuccess = (response) => {
  if (response.code === 200) {
    courseForm.coverImage = response.data
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error('封面上传失败')
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

const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) return imagePath
  return `http://localhost:8080/api${imagePath}`
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
</style>