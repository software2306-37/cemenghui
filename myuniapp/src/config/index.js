// 小程序配置文件
export const config = {
  // API基础URL
  baseURL: 'http://localhost:8080/api',
  
  // 文件上传配置
  upload: {
    url: 'http://localhost:8080/api/file/upload',
    maxSize: 5 * 1024 * 1024, // 5MB
    allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp'],
    videoMaxSize: 50 * 1024 * 1024, // 50MB
    videoAllowedTypes: ['video/mp4', 'video/avi', 'video/mov']
  },
  
  // 分页配置
  pagination: {
    defaultPageSize: 10,
    maxPageSize: 50
  },
  
  // 缓存配置
  cache: {
    userInfoKey: 'userInfo',
    tokenKey: 'token',
    cacheTime: 24 * 60 * 60 * 1000 // 24小时
  },
  
  // 应用信息
  app: {
    name: '测盟汇',
    version: '1.0.0',
    description: '专业的测试技术交流平台',
    author: '测盟汇团队'
  },
  
  // 默认图片
  defaultImages: {
    avatar: '/static/default-avatar.png',
    course: '/static/course-default.png',
    news: '/static/news-default.png',
    meeting: '/static/meeting-default.png'
  }
}

export default config 