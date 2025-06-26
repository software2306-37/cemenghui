import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建axios实例
const request = axios.create({
  baseURL: 'http://localhost:8080/api',
  timeout: 10000,
  withCredentials: true // 允许携带cookie
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    // 如果是blob类型的响应（文件下载），直接返回
    if (response.config.responseType === 'blob') {
      return response.data
    }
    
    const res = response.data
    if (res.code === 200) {
      return res
    } else if (res.code === 401) {
      ElMessage.error('请先登录')
      localStorage.removeItem('user')
      window.location.href = '/login'
      return Promise.reject(new Error(res.message))
    } else {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message))
    }
  },
  error => {
    console.error('请求错误:', error)
    if (error.response) {
      const status = error.response.status
      if (status === 401) {
        ElMessage.error('请先登录')
        localStorage.removeItem('user')
        window.location.href = '/login'
      } else if (status === 500) {
        ElMessage.error('服务器内部错误')
      } else {
        ElMessage.error((error.response.data && error.response.data.message) || '请求失败')
      }
    } else {
      ElMessage.error('网络连接失败')
    }
    return Promise.reject(error)
  }
)

export default request 