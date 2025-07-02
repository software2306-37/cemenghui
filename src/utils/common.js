// 通用工具函数

/**
 * 格式化日期时间
 * @param {string|Date} dateTime 日期时间
 * @param {string} format 格式 'YYYY-MM-DD' | 'YYYY-MM-DD HH:mm' | 'MM-DD HH:mm'
 */
export function formatDateTime(dateTime, format = 'YYYY-MM-DD HH:mm') {
  if (!dateTime) return ''
  
  const date = new Date(dateTime)
  if (isNaN(date.getTime())) return ''
  
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  
  switch (format) {
    case 'YYYY-MM-DD':
      return `${year}-${month}-${day}`
    case 'YYYY-MM-DD HH:mm':
      return `${year}-${month}-${day} ${hours}:${minutes}`
    case 'MM-DD HH:mm':
      return `${month}-${day} ${hours}:${minutes}`
    case 'HH:mm':
      return `${hours}:${minutes}`
    default:
      return `${year}-${month}-${day} ${hours}:${minutes}`
  }
}

/**
 * 格式化文件大小
 * @param {number} bytes 字节数
 */
export function formatFileSize(bytes) {
  if (bytes === 0) return '0 B'
  
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

/**
 * 防抖函数
 * @param {Function} func 要防抖的函数
 * @param {number} wait 等待时间
 */
export function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

/**
 * 节流函数
 * @param {Function} func 要节流的函数
 * @param {number} limit 时间限制
 */
export function throttle(func, limit) {
  let inThrottle
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => inThrottle = false, limit)
    }
  }
}

/**
 * 深拷贝
 * @param {any} obj 要拷贝的对象
 */
export function deepClone(obj) {
  if (obj === null || typeof obj !== 'object') return obj
  if (obj instanceof Date) return new Date(obj.getTime())
  if (obj instanceof Array) return obj.map(item => deepClone(item))
  if (typeof obj === 'object') {
    const copy = {}
    Object.keys(obj).forEach(key => {
      copy[key] = deepClone(obj[key])
    })
    return copy
  }
}

/**
 * 获取文件扩展名
 * @param {string} filename 文件名
 */
export function getFileExtension(filename) {
  return filename.slice((filename.lastIndexOf('.') - 1 >>> 0) + 2)
}

/**
 * 验证邮箱格式
 * @param {string} email 邮箱地址
 */
export function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

/**
 * 验证手机号格式
 * @param {string} phone 手机号
 */
export function validatePhone(phone) {
  const re = /^1[3-9]\d{9}$/
  return re.test(phone)
}

/**
 * 生成随机字符串
 * @param {number} length 长度
 */
export function generateRandomString(length = 8) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  let result = ''
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return result
}

/**
 * 截断文本
 * @param {string} text 文本
 * @param {number} maxLength 最大长度
 * @param {string} suffix 后缀
 */
export function truncateText(text, maxLength = 50, suffix = '...') {
  if (!text || text.length <= maxLength) return text
  return text.substring(0, maxLength) + suffix
}

/**
 * 存储用户信息到本地
 * @param {object} userInfo 用户信息
 */
export function setUserInfo(userInfo) {
  uni.setStorageSync('userInfo', userInfo)
}

/**
 * 从本地获取用户信息
 */
export function getUserInfo() {
  return uni.getStorageSync('userInfo') || null
}

/**
 * 清除用户信息
 */
export function clearUserInfo() {
  uni.removeStorageSync('userInfo')
}

/**
 * 检查是否已登录
 */
export function isLoggedIn() {
  const userInfo = getUserInfo()
  return userInfo && userInfo.username
}

/**
 * 获取完整的图片URL
 * @param {string} imagePath 图片路径
 */
export function getImageUrl(imagePath) {
  if (!imagePath) {
    return '/static/default-image.png' // 默认图片
  }
  
  // 如果已经是完整URL，直接返回
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath
  }
  
  // 如果是相对路径，拼接基础URL
  if (imagePath.startsWith('/uploads/')) {
    return 'http://localhost:8080/api' + imagePath
  }
  
  // 其他情况，假设是相对路径
  return 'http://localhost:8080/api/uploads/' + imagePath
}

/**
 * 获取头像URL
 * @param {string} avatar 头像路径
 */
export function getAvatarUrl(avatar) {
  if (!avatar) {
    return '/static/default-avatar.png' // 默认头像
  }
  return getImageUrl(avatar)
}

export default {
  formatDateTime,
  formatFileSize,
  debounce,
  throttle,
  deepClone,
  getFileExtension,
  validateEmail,
  validatePhone,
  generateRandomString,
  truncateText,
  setUserInfo,
  getUserInfo,
  clearUserInfo,
  isLoggedIn,
  getImageUrl,
  getAvatarUrl
} 