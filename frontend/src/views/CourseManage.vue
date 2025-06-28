<template>
  <div class="course-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>课程管理</span>
          <div>
            <el-button type="primary" @click="showAddDialog = true">添加课程</el-button>
          </div>
        </div>
      </template>

      <!-- 简化搜索栏 -->
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="请输入课程名称"
          clearable
          style="width: 300px; margin-right: 10px"
          @keyup.enter="loadCourses"
        />
        <el-button type="primary" @click="loadCourses">搜索</el-button>
      </div>

      <!-- 简化表格 -->
      <el-table :data="courseList" style="width: 100%" v-loading="loading">
        <el-table-column prop="title" label="课程名称" width="180" />
        <el-table-column label="封面" width="100">
          <template #default="scope">
            <img v-if="scope.row.coverImage" :src="getImageUrl(scope.row.coverImage)" style="width: 60px; height: 40px; object-fit: cover;" />
          </template>
        </el-table-column>
        <el-table-column prop="description" label="课程简介" width="200" />
        <el-table-column prop="author" label="作者" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '已发布' : '未发布' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button size="small" @click="viewCourse(scope.row)">查看</el-button>
            <el-button size="small" @click="editCourse(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteCourse(scope.row)">删除</el-button>
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
          @current-change="loadCourses"
        />
      </div>
    </el-card>

    <!-- 简化添加/编辑对话框 -->
    <el-dialog v-model="showAddDialog" :title="editingCourse ? '编辑课程' : '添加课程'" width="500px">
      <el-form :model="courseForm" label-width="80px">
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
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveCourse">保存</el-button>
      </template>
    </el-dialog>

    <!-- 简化查看对话框 -->
    <el-dialog v-model="showViewDialog" title="查看课程" width="600px">
      <div v-if="viewingCourse">
        <div class="view-item">
          <strong>课程名称：</strong>{{ viewingCourse.title }}
        </div>
        <div class="view-item">
          <strong>作者：</strong>{{ viewingCourse.author }}
        </div>
        <div class="view-item">
          <strong>状态：</strong>
          <el-tag :type="viewingCourse.status === 1 ? 'success' : 'danger'">
            {{ viewingCourse.status === 1 ? '已发布' : '未发布' }}
          </el-tag>
        </div>
        <div class="view-item">
          <strong>课程简介：</strong>{{ viewingCourse.description }}
        </div>
        <div class="view-item" v-if="viewingCourse.coverImage">
          <strong>课程封面：</strong><br/>
          <img :src="getImageUrl(viewingCourse.coverImage)" style="max-width: 300px; max-height: 200px; object-fit: cover;" />
        </div>
        <div class="view-item">
          <strong>创建时间：</strong>{{ viewingCourse.createTime }}
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