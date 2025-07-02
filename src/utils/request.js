// API请求配置
import config from '../config/index.js'

const BASE_URL = config.baseURL

// 全局请求拦截器 - 小程序专用
const request = (options) => {
  return new Promise((resolve, reject) => {
    // 设置请求头
    const headers = {
      'Content-Type': 'application/json',
      ...options.header
    }
    
    // 获取并设置用户ID
    const userInfo = uni.getStorageSync('userInfo')
    if (userInfo && userInfo.id) {
      headers['X-User-Id'] = userInfo.id.toString()
      console.log('发送用户ID:', userInfo.id)
    }
    
    // 小程序请求配置
    const requestConfig = {
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data || {},
      header: headers,
      timeout: 10000,
      success: (res) => {
        console.log(`请求成功: ${options.url}`, res)
        
        if (res.statusCode === 200) {
          if (res.data && res.data.code === 200) {
            resolve(res.data)
          } else if (res.data && res.data.code === 401) {
            // 未登录 - 只有在登录、获取用户信息等核心接口时才跳转登录页
            console.log('401未登录，URL:', options.url)
            const shouldRedirectToLogin = [
              '/user/login',
              '/user/current',
              '/user/logout'
            ].some(path => options.url.includes(path))
            
            if (shouldRedirectToLogin) {
              console.log('核心接口401，清除用户信息并跳转登录页')
              uni.removeStorageSync('userInfo')
              uni.removeStorageSync('sessionId')
              uni.showToast({
                title: '登录已过期，请重新登录',
                icon: 'none'
              })
              setTimeout(() => {
                uni.reLaunch({
                  url: '/pages/login/login'
                })
              }, 1500)
            } else {
              console.log('非核心接口401，仅显示错误信息')
              uni.showToast({
                title: '请先登录',
                icon: 'none'
              })
            }
            reject(new Error('未登录'))
          } else {
            const message = (res.data && res.data.message) || '请求失败'
            reject(new Error(message))
          }
        } else if (res.statusCode === 401) {
          // HTTP状态码401 - 同样只在核心接口时跳转
          console.log('HTTP 401未登录，URL:', options.url)
          const shouldRedirectToLogin = [
            '/user/login',
            '/user/current',
            '/user/logout'
          ].some(path => options.url.includes(path))
          
          if (shouldRedirectToLogin) {
            console.log('核心接口HTTP 401，清除用户信息并跳转登录页')
            uni.removeStorageSync('userInfo')
            uni.removeStorageSync('sessionId')
            uni.showToast({
              title: '登录已过期，请重新登录',
              icon: 'none'
            })
            setTimeout(() => {
              uni.reLaunch({
                url: '/pages/login/login'
              })
            }, 1500)
          } else {
            console.log('非核心接口HTTP 401，仅显示错误信息')
            uni.showToast({
              title: '请先登录',
              icon: 'none'
            })
          }
          reject(new Error('未登录'))
        } else {
          const message = `网络错误 ${res.statusCode}`
          uni.showToast({
            title: message,
            icon: 'none'
          })
          reject(new Error(message))
        }
      },
      fail: (error) => {
        console.error('请求失败:', error)
        uni.showToast({
          title: '网络连接失败',
          icon: 'none'
        })
        reject(error)
      }
    }
    
    // 发起请求
    uni.request(requestConfig)
  })
}

// API接口
export const api = {
  // 用户相关
  login: (data) => request({ url: '/user/login', method: 'POST', data }),
  logout: () => request({ url: '/user/logout', method: 'POST' }),
  register: (data) => request({ url: '/user/register', method: 'POST', data }),
  resetPassword: (data) => request({ url: '/user/reset-password', method: 'POST', data }),
  getCurrentUser: () => request({ url: '/user/current' }),
  updateProfile: (data) => request({ url: '/user/profile', method: 'POST', data }),
  changePassword: (data) => request({ url: '/user/change-password', method: 'POST', data }),
  getUserStats: () => request({ url: '/user/stats' }),
  
  // 我的数据相关
  getMyCourses: () => request({ url: '/user/my-courses' }),
  getMyMeetings: () => request({ url: '/user/my-meetings' }),
  getMyFavorites: () => request({ url: '/user/my-favorites' }),
  
  // 反馈相关
  submitFeedback: (data) => request({ url: '/user/feedback/submit', method: 'POST', data }),
  
  // 管理员功能相关
  getBehaviorAnalytics: () => request({ url: '/user/behavior-analytics' }),
  
  // 新闻动态相关
  getNewsList: (params) => {
    // 构建查询参数 - 兼容小程序环境
    let queryString = ''
    if (params) {
      const queryPairs = []
      Object.keys(params).forEach(key => {
        if (params[key] !== undefined && params[key] !== null) {
          queryPairs.push(`${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
        }
      })
      queryString = queryPairs.join('&')
    }
    const url = queryString ? `/news/page?${queryString}` : '/news/page'
    return request({ url })
  },
  getNewsDetail: (id) => request({ url: `/news/${id}` }),
  
  // 课程相关
  getCourseList: (params) => {
    // 构建查询参数 - 兼容小程序环境
    let queryString = ''
    if (params) {
      const queryPairs = []
      Object.keys(params).forEach(key => {
        if (params[key] !== undefined && params[key] !== null) {
          queryPairs.push(`${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
        }
      })
      queryString = queryPairs.join('&')
    }
    const url = queryString ? `/course/page?${queryString}` : '/course/page'
    return request({ url })
  },
  getCourseDetail: (id) => request({ url: `/course/${id}` }),
  enrollCourse: (courseId) => request({ url: `/course/${courseId}/enroll`, method: 'POST' }),
  
  // 会议相关
  getMeetingList: (params) => {
    // 构建查询参数 - 兼容小程序环境
    let queryString = ''
    if (params) {
      const queryPairs = []
      Object.keys(params).forEach(key => {
        if (params[key] !== undefined && params[key] !== null) {
          queryPairs.push(`${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
        }
      })
      queryString = queryPairs.join('&')
    }
    const url = queryString ? `/meeting/page?${queryString}` : '/meeting/page'
    return request({ url })
  },
  getMeetingDetail: (id) => request({ url: `/meeting/${id}` }),
  registerMeeting: (meetingId) => request({ url: `/meeting/${meetingId}/register`, method: 'POST' }),
  
  // 文件上传
  uploadFile: (filePath) => {
    return new Promise((resolve, reject) => {
      console.log('开始上传文件:', filePath)
      
      uni.uploadFile({
        url: BASE_URL + '/file/upload',
        filePath: filePath,
        name: 'file',
        success: (res) => {
          console.log('文件上传响应:', res)
          try {
            const result = JSON.parse(res.data)
            if (result.code === 200) {
              console.log('文件上传成功:', result.data)
              resolve(result.data)
            } else {
              reject(new Error(result.message || '上传失败'))
            }
          } catch (error) {
            console.error('解析上传响应失败:', error)
            reject(new Error('上传响应解析失败'))
          }
        },
        fail: (error) => {
          console.error('文件上传失败:', error)
          reject(new Error('文件上传失败'))
        }
      })
    })
  },
  
  // 统计相关
  getStats: () => request({ url: '/stat/overview' }),
  
  // 收藏相关
  addFavorite: (type, id) => request({ url: '/favorite/add', method: 'POST', data: { type, id } }),
  removeFavorite: (type, id) => request({ url: '/favorite/remove', method: 'POST', data: { type, id } }),
  getFavoriteList: (params) => request({ url: '/favorite/list', data: params }),
  
  // 评论相关
  addComment: (data) => request({ url: '/comment/add', method: 'POST', data }),
  getCommentList: (params) => request({ url: '/comment/list', data: params }),
  
  // 搜索相关
  search: (params) => request({ url: '/search', data: params })
}

export default request 