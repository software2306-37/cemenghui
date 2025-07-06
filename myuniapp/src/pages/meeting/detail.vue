<template>
  <view class="container">
    <view v-if="meetingData" class="detail-content">
      <view class="meeting-header">
        <text class="title">{{ meetingData.meeting.meetingName }}</text>
        <view class="status-badge" :class="[getStatusClass(meetingData.meeting.status)]">
          <text class="status-text">{{ getStatusText(meetingData.meeting.status) }}</text>
        </view>
      </view>
      
      <!-- 报名状态提示 -->
      <view v-if="isLoggedIn && meetingData.isRegistered" class="registration-status">
        <text class="status-icon">✅</text>
        <text class="status-text">您已成功报名此会议</text>
        <button v-if="canCancelRegistration" class="cancel-btn" @click="cancelRegistration">取消报名</button>
      </view>
      
      <view class="meeting-info">
        <view class="info-item" v-if="meetingData.meeting.meetingTime">
          <text class="info-icon">🕒</text>
          <view class="info-content">
            <text class="info-label">会议时间</text>
            <text class="info-value">{{ formatDateTime(meetingData.meeting.meetingTime) }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingData.meeting.location">
          <text class="info-icon">📍</text>
          <view class="info-content">
            <text class="info-label">会议地点</text>
            <text class="info-value">{{ meetingData.meeting.location }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingData.meeting.organizer">
          <text class="info-icon">👥</text>
          <view class="info-content">
            <text class="info-label">主办方</text>
            <text class="info-value">{{ meetingData.meeting.organizer }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingData.meeting.category">
          <text class="info-icon">🏷️</text>
          <view class="info-content">
            <text class="info-label">会议类型</text>
            <text class="info-value">{{ meetingData.meeting.category }}</text>
          </view>
        </view>
        
        <view class="info-item" v-if="meetingDetail.maxParticipants">
          <text class="info-icon">👤</text>
          <view class="info-content">
            <text class="info-label">参会人数</text>
            <text class="info-value">{{ meetingDetail.currentParticipants || 0 }}/{{ meetingDetail.maxParticipants }}人</text>
          </view>
        </view>
      </view>
      
      <view class="meeting-content">
        <view class="section-title">会议详情</view>
        <view class="content">{{ formatContent(meetingData.meeting.meetingContent) }}</view>
      </view>
      
      <!-- 操作按钮区域 -->
      <view class="action-section">
        <!-- 未登录状态 -->
        <view v-if="!isLoggedIn" class="login-prompt">
          <text class="prompt-text">请先登录后参与会议</text>
          <button class="login-btn" @click="goToLogin">立即登录</button>
        </view>
        
        <!-- 已登录状态 -->
        <view v-else class="action-buttons">
          <!-- 可报名状态 -->
          <button v-if="canRegister" class="register-btn primary" @click="registerMeeting">
            立即报名
          </button>
          
          <!-- 已报名状态 -->
          <button v-else-if="meetingData.isRegistered && meetingStatus === 'upcoming'" class="registered-btn" disabled>
            已报名
          </button>
          
          <!-- 会议进行中 -->
          <button v-else-if="meetingData.isRegistered && meetingStatus === 'ongoing'" class="ongoing-btn" disabled>
            参会中
          </button>
          
          <!-- 会议已结束且可填写回执 -->
          <button v-if="canSubmitFeedback" 
                  class="feedback-btn primary" @click="openFeedbackModal">
            填写参会回执
          </button>
          
          <!-- 已提交回执 -->
          <button v-if="meetingData.hasSubmittedFeedback" 
                  class="view-feedback-btn" @click="goToFeedbackDetail">
            查看我的回执
          </button>
          
          <!-- 会议已结束但未报名 -->
          <button v-else-if="meetingStatus === 'ended' && !meetingData.isRegistered" 
                  class="ended-btn" disabled>
            会议已结束
          </button>
          
          <!-- 分享按钮 -->
          <button class="share-btn" @click="shareMeeting">分享会议</button>
        </view>
      </view>
    </view>
    
    <view v-if="loading" class="loading">
      <text>加载中...</text>
    </view>
    
    <view v-if="!meetingData && !loading" class="empty">
      <text>会议不存在</text>
    </view>
    
    <!-- 回执信息弹窗 -->
    <view v-if="showFeedbackModal" class="feedback-overlay" @click="closeFeedbackModal">
      <view class="feedback-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">我的参会回执</text>
          <text class="close-btn" @click="closeFeedbackModal">✕</text>
        </view>
        <scroll-view scroll-y="true" class="modal-content">
          <view class="form-item">
            <view class="form-label">单位</view>
            <input type="text" class="input" v-model="feedbackForm.companyName" placeholder="请输入单位名称" />
          </view>
          <view class="form-item">
            <view class="form-label">姓名</view>
            <input type="text" class="input" v-model="feedbackForm.userName" placeholder="请输入姓名" />
          </view>
          <view class="form-item">
            <view class="form-label">性别</view>
            <view class="radio-group">
              <label class="radio-item" @click="setGender('男')">
                <input type="radio" name="gender" value="男" v-model="feedbackForm.gender" />
                <span class="radio">男</span>
              </label>
              <label class="radio-item" @click="setGender('女')">
                <input type="radio" name="gender" value="女" v-model="feedbackForm.gender" />
                <span class="radio">女</span>
              </label>
            </view>
          </view>
          <view class="form-item">
            <view class="form-label">手机</view>
            <input type="text" class="input" v-model="feedbackForm.userPhone" placeholder="请输入手机号码" />
          </view>
          <view class="form-item">
            <view class="form-label">邮箱</view>
            <input type="text" class="input" v-model="feedbackForm.userEmail" placeholder="请输入邮箱" />
          </view>
          <view class="form-item">
            <view class="form-label">到达方式</view>
            <view class="radio-group">
              <label class="radio-item" @click="setArrivalMethod('自驾')">
                <input type="radio" name="arrivalMethod" value="自驾" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">自驾</span>
              </label>
              <label class="radio-item" @click="setArrivalMethod('公交')">
                <input type="radio" name="arrivalMethod" value="公交" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">公交</span>
              </label>
              <label class="radio-item" @click="setArrivalMethod('地铁')">
                <input type="radio" name="arrivalMethod" value="地铁" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">地铁</span>
              </label>
              <label class="radio-item" @click="setArrivalMethod('飞机')">
                <input type="radio" name="arrivalMethod" value="飞机" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">飞机</span>
              </label>
              <label class="radio-item" @click="setArrivalMethod('火车')">
                <input type="radio" name="arrivalMethod" value="火车" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">火车</span>
              </label>
              <label class="radio-item" @click="setArrivalMethod('其他')">
                <input type="radio" name="arrivalMethod" value="其他" v-model="feedbackForm.arrivalMethod" />
                <span class="radio">其他</span>
              </label>
            </view>
          </view>
          <view class="form-item" v-if="feedbackForm.arrivalMethod && feedbackForm.arrivalMethod !== '自驾' && feedbackForm.arrivalMethod !== '其他'">
            <view class="form-label">车次/航班</view>
            <input type="text" class="input" v-model="feedbackForm.arrivalInfo" placeholder="请输入车次或航班号" />
          </view>
          <view class="form-item">
            <view class="form-label">到达时间</view>
            <input type="time" class="input" v-model="feedbackForm.arrivalTime" />
          </view>
          <view class="rating-section">
            <view class="rating-item">
              <view class="rating-label">总体评分</view>
              <view class="rating-stars" :class="{ small: true }">
                <span class="star" @click="setRating(1)" :class="{ active: feedbackForm.rating >= 1 }">★</span>
                <span class="star" @click="setRating(2)" :class="{ active: feedbackForm.rating >= 2 }">★</span>
                <span class="star" @click="setRating(3)" :class="{ active: feedbackForm.rating >= 3 }">★</span>
                <span class="star" @click="setRating(4)" :class="{ active: feedbackForm.rating >= 4 }">★</span>
                <span class="star" @click="setRating(5)" :class="{ active: feedbackForm.rating >= 5 }">★</span>
              </view>
            </view>
            <view class="rating-item">
              <view class="rating-label">参会感受</view>
              <textarea class="textarea" v-model="feedbackForm.content" placeholder="请描述您的参会感受" />
            </view>
            <view class="rating-item">
              <view class="rating-label">改进建议</view>
              <textarea class="textarea" v-model="feedbackForm.suggestions" placeholder="请提出您的改进建议" />
            </view>
            <view class="rating-item">
              <view class="rating-label">组织安排</view>
              <view class="rating-stars" :class="{ small: true }">
                <span class="star" @click="setOrganizationRating(1)" :class="{ active: feedbackForm.organizationRating >= 1 }">★</span>
                <span class="star" @click="setOrganizationRating(2)" :class="{ active: feedbackForm.organizationRating >= 2 }">★</span>
                <span class="star" @click="setOrganizationRating(3)" :class="{ active: feedbackForm.organizationRating >= 3 }">★</span>
                <span class="star" @click="setOrganizationRating(4)" :class="{ active: feedbackForm.organizationRating >= 4 }">★</span>
                <span class="star" @click="setOrganizationRating(5)" :class="{ active: feedbackForm.organizationRating >= 5 }">★</span>
              </view>
            </view>
            <view class="rating-item">
              <view class="rating-label">内容质量</view>
              <view class="rating-stars" :class="{ small: true }">
                <span class="star" @click="setContentRating(1)" :class="{ active: feedbackForm.contentRating >= 1 }">★</span>
                <span class="star" @click="setContentRating(2)" :class="{ active: feedbackForm.contentRating >= 2 }">★</span>
                <span class="star" @click="setContentRating(3)" :class="{ active: feedbackForm.contentRating >= 3 }">★</span>
                <span class="star" @click="setContentRating(4)" :class="{ active: feedbackForm.contentRating >= 4 }">★</span>
                <span class="star" @click="setContentRating(5)" :class="{ active: feedbackForm.contentRating >= 5 }">★</span>
              </view>
            </view>
            <view class="rating-item">
              <view class="rating-label">场地环境</view>
              <view class="rating-stars" :class="{ small: true }">
                <span class="star" @click="setVenueRating(1)" :class="{ active: feedbackForm.venueRating >= 1 }">★</span>
                <span class="star" @click="setVenueRating(2)" :class="{ active: feedbackForm.venueRating >= 2 }">★</span>
                <span class="star" @click="setVenueRating(3)" :class="{ active: feedbackForm.venueRating >= 3 }">★</span>
                <span class="star" @click="setVenueRating(4)" :class="{ active: feedbackForm.venueRating >= 4 }">★</span>
                <span class="star" @click="setVenueRating(5)" :class="{ active: feedbackForm.venueRating >= 5 }">★</span>
              </view>
            </view>
          </view>
        </scroll-view>
        <view class="modal-footer">
          <button class="modal-footer .cancel-btn" @click="closeFeedbackModal">取消</button>
          <button class="submit-btn" @click="submitFeedback" :disabled="!canSubmitFeedbackForm">提交</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { api } from '../../utils/request'

export default {
  data() {
    return {
      meetingData: null,
      loading: false,
      meetingId: null,
      isLoggedIn: false,
      showFeedbackModal: false,
      feedbackForm: {
        rating: 0,
        content: '',
        suggestions: '',
        organizationRating: 0,
        contentRating: 0,
        venueRating: 0,
        companyName: '',
        userName: '',
        gender: '',
        userPhone: '',
        userEmail: '',
        arrivalMethod: '',
        arrivalInfo: '',
        arrivalTime: ''
      },
      feedbackDetail: {},
    }
  },
      computed: {
    canRegister() {
      return this.isLoggedIn && 
             this.meetingData && 
             this.meetingData.meeting.status === 1 && 
             !this.meetingData.isRegistered &&
             this.isMeetingNotStarted()
    },
    canCancelRegistration() {
      return this.meetingData && 
             this.meetingData.isRegistered && 
             this.isMeetingNotStarted()
    },
    canSubmitFeedback() {
      return this.isLoggedIn &&
             this.meetingData && 
             this.meetingData.isRegistered &&
             this.isMeetingEnded() &&
             !this.meetingData.hasSubmittedFeedback
    },
    canSubmitFeedbackForm() {
      return this.feedbackForm.rating > 0 &&
             this.feedbackForm.companyName.trim() &&
             this.feedbackForm.userName.trim() &&
             this.feedbackForm.gender &&
             this.feedbackForm.userPhone.trim() &&
             this.feedbackForm.arrivalMethod
    },
    meetingStatus() {
      if (!this.meetingData || !this.meetingData.meeting.meetingTime) {
        return 'unknown'
      }
      
      const now = new Date()
      const meetingTime = new Date(this.meetingData.meeting.meetingTime)
      const endTime = new Date(meetingTime.getTime() + 2 * 60 * 60 * 1000) // 假设会议持续2小时
      
      if (now < meetingTime) {
        return 'upcoming'
      } else if (now >= meetingTime && now <= endTime) {
        return 'ongoing'
      } else {
        return 'ended'
      }
    }
  },
  onLoad(options) {
    console.log('会议详情页面接收到的参数:', options)
    if (options.id) {
      this.meetingId = options.id
      this.checkLoginStatus()
      this.loadMeetingDetail()
    } else {
      uni.showToast({
        title: '会议ID缺失',
        icon: 'none'
      })
    }
  },
  onShow() {
    this.checkLoginStatus()
  },
  methods: {
    checkLoginStatus() {
      const userInfo = uni.getStorageSync('userInfo')
      this.isLoggedIn = !!(userInfo && userInfo.id)
    },
    
    async loadMeetingDetail() {
      this.loading = true
      try {
        const response = await api.getMeetingDetail(this.meetingId)
        console.log('会议详情API响应:', response)
        
        if (response && response.data) {
          this.meetingData = response.data
          console.log('会议数据:', this.meetingData)
          // 查询回执详情
          if (this.meetingData.hasSubmittedFeedback) {
            const feedbackRes = await api.getUserFeedback(this.meetingId)
            this.feedbackDetail = feedbackRes && feedbackRes.data ? feedbackRes.data : {}
          } else {
            this.feedbackDetail = {}
          }
        } else {
          uni.showToast({
            title: '会议不存在',
            icon: 'none'
          })
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      } catch (error) {
        console.error('获取会议详情失败:', error)
        uni.showToast({
          title: '加载失败',
          icon: 'none'
        })
      } finally {
        this.loading = false
      }
    },
    
    getStatusText(status) {
      const statusMap = {
        0: '待审核',
        1: '报名中',
        2: '已拒绝'
      }
      return statusMap[status] || '未知'
    },
    
    getStatusClass(status) {
      switch (status) {
        case 1:
          return 'status-active'
        case 0:
          return 'status-pending'
        case 2:
          return 'status-rejected'
        default:
          return 'status-default'
      }
    },
    
    async registerMeeting() {
      if (!this.isLoggedIn) {
        this.goToLogin()
        return
      }
      
      uni.showModal({
        title: '确认报名',
        content: `确定要报名参加《${this.meetingData.meeting.meetingName}》吗？`,
        success: async (res) => {
          if (res.confirm) {
            try {
              uni.showLoading({ title: '报名中...' })
              const result = await api.registerMeeting(this.meetingId)
              uni.hideLoading()
              
              if (result && result.code === 200) {
                uni.showToast({
                  title: '报名成功！',
                  icon: 'success'
                })
                // 重新加载会议详情以更新状态
                setTimeout(() => {
                  this.loadMeetingDetail()
                }, 1000)
              } else {
                uni.showToast({
                  title: result?.message || '报名失败',
                  icon: 'none'
                })
              }
            } catch (error) {
              uni.hideLoading()
              console.error('报名失败:', error)
              uni.showToast({
                title: '报名失败',
                icon: 'none'
              })
            }
          }
        }
      })
    },
    
    async cancelRegistration() {
      uni.showModal({
        title: '取消报名',
        content: '确定要取消报名吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              uni.showLoading({ title: '处理中...' })
              const result = await api.cancelMeetingRegistration(this.meetingId)
              uni.hideLoading()
              
              if (result && result.code === 200) {
                uni.showToast({
                  title: '已取消报名',
                  icon: 'success'
                })
                this.loadMeetingDetail()
              } else {
                uni.showToast({
                  title: result?.message || '取消失败',
                  icon: 'none'
                })
              }
            } catch (error) {
              uni.hideLoading()
              console.error('取消报名失败:', error)
              uni.showToast({
                title: '取消失败',
                icon: 'none'
              })
            }
          }
        }
      })
    },
    
    openFeedbackModal() {
      this.showFeedbackModal = true
      this.resetFeedbackForm()
    },
    
    closeFeedbackModal() {
      this.showFeedbackModal = false
    },
    
    resetFeedbackForm() {
      this.feedbackForm = {
        rating: 0,
        content: '',
        suggestions: '',
        organizationRating: 0,
        contentRating: 0,
        venueRating: 0
      }
    },
    
    setRating(rating) {
      this.feedbackForm.rating = rating
    },
    
    setOrganizationRating(rating) {
      this.feedbackForm.organizationRating = rating
    },
    
    setContentRating(rating) {
      this.feedbackForm.contentRating = rating
    },
    
    setVenueRating(rating) {
      this.feedbackForm.venueRating = rating
    },
    
    async submitFeedback() {
      if (!this.feedbackForm.rating) {
        uni.showToast({
          title: '请先评分',
          icon: 'none'
        })
        return
      }
      
      if (!this.isLoggedIn) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        })
        this.goToLogin()
        return
      }
      
      try {
        uni.showLoading({ title: '提交中...' })
        console.log('提交回执数据:', this.feedbackForm)
        console.log('会议ID:', this.meetingId)
        
        const submitData = {
          meetingId: this.meetingId,
          ...this.feedbackForm
        }
        const result = await api.submitMeetingFeedback(submitData)
        console.log('回执提交结果:', result)
        uni.hideLoading()
        
        if (result && result.code === 200) {
          uni.showToast({
            title: '回执提交成功',
            icon: 'success'
          })
          this.closeFeedbackModal()
          this.loadMeetingDetail()
        } else {
          uni.showToast({
            title: result?.message || '提交失败',
            icon: 'none'
          })
        }
      } catch (error) {
        uni.hideLoading()
        console.error('提交回执失败:', error)
        uni.showToast({
          title: error.message || '提交失败',
          icon: 'none'
        })
      }
    },
    
    async viewFeedback() {
      try {
        const result = await api.getUserFeedback(this.meetingId)
        if (result && result.data) {
          this.feedbackDetail = result.data
          this.showFeedbackModal = true // 使用 showFeedbackModal 替代 showFeedbackPopup
        }
      } catch (error) {
        console.error('获取回执失败:', error)
        uni.showToast({
          title: '获取回执失败',
          icon: 'none'
        })
      }
    },
    
    goToLogin() {
      uni.navigateTo({
        url: '/pages/login/login'
      })
    },
    
    shareMeeting() {
      uni.showActionSheet({
        itemList: ['分享到微信', '分享到朋友圈', '复制链接'],
        success: (res) => {
          const actions = ['微信好友', '朋友圈', '复制链接']
          uni.showToast({
            title: `已分享到${actions[res.tapIndex]}`,
            icon: 'success'
          })
        }
      })
    },
    
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return ''
      const date = new Date(dateTimeStr)
      return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
    },
    
    formatContent(content) {
      if (!content) return ''
      return content.replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>')
    },
    
    isMeetingNotStarted() {
      if (!this.meetingData || !this.meetingData.meeting.meetingTime) {
        return true // 如果没有时间信息，默认可以报名
      }
      const meetingTime = new Date(this.meetingData.meeting.meetingTime)
      const now = new Date()
      return now < meetingTime
    },
    
    isMeetingEnded() {
      if (!this.meetingData || !this.meetingData.meeting.meetingTime) {
        return false
      }
      const meetingTime = new Date(this.meetingData.meeting.meetingTime)
      const endTime = new Date(meetingTime.getTime() + 2 * 60 * 60 * 1000) // 假设会议持续2小时
      const now = new Date()
      return now > endTime
    },
    
    setGender(gender) {
      this.feedbackForm.gender = gender
    },
    
    setArrivalMethod(method) {
      this.feedbackForm.arrivalMethod = method
      // 如果选择自驾或其他，清空车次信息
      if (method === '自驾' || method === '其他') {
        this.feedbackForm.arrivalInfo = ''
      }
    },
    
    setRating(rating) {
      this.feedbackForm.rating = rating
    },
    
    setOrganizationRating(rating) {
      this.feedbackForm.organizationRating = rating
    },
    
    setContentRating(rating) {
      this.feedbackForm.contentRating = rating
    },
    
    setVenueRating(rating) {
      this.feedbackForm.venueRating = rating
    },
    
    async submitFeedback() {
      if (!this.feedbackForm.rating) {
        uni.showToast({
          title: '请先评分',
          icon: 'none'
        })
        return
      }
      
      try {
        const submitData = {
          meetingId: this.meetingId,
          ...this.feedbackForm
        }
        
        const result = await api.submitMeetingFeedback(submitData)
        if (result) {
          uni.showToast({
            title: '回执提交成功！',
            icon: 'success'
          })
          this.closeFeedbackModal()
          // 更新会议数据，标记已提交回执
          this.$set(this.meetingData, 'hasSubmittedFeedback', true)
        }
      } catch (error) {
        console.error('提交回执失败:', error)
        uni.showToast({
          title: '提交失败，请重试',
          icon: 'none'
        })
      }
    },
    
    async viewFeedback() {
      try {
        const result = await api.getUserFeedback(this.meetingId)
        if (result && result.data) {
          // 显示用户的回执信息
          const feedback = result.data
          let content = `总体评分：${'★'.repeat(feedback.rating)}${'☆'.repeat(5-feedback.rating)}\n`
          
          if (feedback.content) {
            content += `\n参会感受：\n${feedback.content}\n`
          }
          
          if (feedback.suggestions) {
            content += `\n改进建议：\n${feedback.suggestions}\n`
          }
          
          if (feedback.organizationRating) {
            content += `\n组织安排：${'★'.repeat(feedback.organizationRating)}${'☆'.repeat(5-feedback.organizationRating)}`
          }
          
          if (feedback.contentRating) {
            content += `\n内容质量：${'★'.repeat(feedback.contentRating)}${'☆'.repeat(5-feedback.contentRating)}`
          }
          
          if (feedback.venueRating) {
            content += `\n场地环境：${'★'.repeat(feedback.venueRating)}${'☆'.repeat(5-feedback.venueRating)}`
          }
          
          uni.showModal({
            title: '我的参会回执',
            content: content,
            showCancel: false,
            confirmText: '确定'
          })
        }
      } catch (error) {
        console.error('获取回执失败:', error)
        uni.showToast({
          title: '获取回执失败',
          icon: 'none'
        })
      }
    },
    renderStars(val) {
      if (!val) return '-'
      return '★'.repeat(val) + '☆'.repeat(5-val)
    },
    goToFeedbackDetail() {
      uni.navigateTo({
        url: `/pages/meeting/feedback-detail?id=${this.meetingId}`
      })
    }
  }
}
</script>

<style scoped>
.container {
  background-color: #f8f8f8;
  min-height: 100vh;
}

.detail-content {
  background-color: white;
}

.meeting-header {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.title {
  flex: 1;
  font-size: 36rpx;
  font-weight: bold;
  color: #333;
  margin-right: 20rpx;
  line-height: 1.4;
}

.status-badge {
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
}

.status-active {
  background-color: #e8f5e8;
}

.status-pending {
  background-color: #fff3cd;
}

.status-rejected {
  background-color: #ffebee;
}

.status-text {
  font-size: 24rpx;
  font-weight: bold;
}

.status-active .status-text {
  color: #52c41a;
}

.status-pending .status-text {
  color: #faad14;
}

.status-rejected .status-text {
  color: #f44336;
}

.registration-status {
  margin: 20rpx;
  padding: 20rpx;
  background-color: #e8f5e8;
  border-radius: 10rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.status-icon {
  font-size: 32rpx;
  margin-right: 15rpx;
}

.registration-status .status-text {
  flex: 1;
  color: #52c41a;
  font-size: 28rpx;
}

.cancel-btn {
  padding: 10rpx 20rpx;
  background-color: #ff4d4f;
  color: white;
  border: none;
  border-radius: 15rpx;
  font-size: 24rpx;
}

.meeting-info {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.info-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 25rpx;
}

.info-item:last-child {
  margin-bottom: 0;
}

.info-icon {
  font-size: 32rpx;
  margin-right: 20rpx;
  width: 40rpx;
  text-align: center;
}

.info-content {
  flex: 1;
}

.info-label {
  font-size: 26rpx;
  color: #999;
  display: block;
  margin-bottom: 5rpx;
}

.info-value {
  font-size: 28rpx;
  color: #333;
  display: block;
}

.meeting-content, .agenda-section, .speakers-section {
  padding: 30rpx;
  border-bottom: 20rpx solid #f8f8f8;
}

.section-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  display: block;
}

.content {
  font-size: 28rpx;
  line-height: 1.6;
  color: #333;
}

.agenda-item {
  display: flex;
  margin-bottom: 15rpx;
}

.agenda-time {
  font-size: 26rpx;
  color: #666;
  width: 200rpx;
  flex-shrink: 0;
}

.agenda-content {
  font-size: 26rpx;
  color: #333;
  flex: 1;
}

.speaker-item {
  display: flex;
  align-items: center;
  margin-bottom: 20rpx;
}

.speaker-avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 40rpx;
  margin-right: 20rpx;
}

.speaker-info {
  flex: 1;
}

.speaker-name {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 5rpx;
}

.speaker-title {
  font-size: 24rpx;
  color: #666;
  display: block;
  margin-bottom: 3rpx;
}

.speaker-company {
  font-size: 22rpx;
  color: #999;
  display: block;
}

.action-section {
  padding: 30rpx;
}

.login-prompt {
  text-align: center;
}

.prompt-text {
  font-size: 28rpx;
  color: #999;
  display: block;
  margin-bottom: 20rpx;
}

.login-btn {
  width: 300rpx;
  height: 80rpx;
  background-color: #007aff;
  color: white;
  font-size: 30rpx;
  border: none;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.register-btn, .registered-btn, .ongoing-btn, .ended-btn, .feedback-btn, .view-feedback-btn {
  height: 80rpx;
  font-size: 30rpx;
  border: none;
  border-radius: 40rpx;
  line-height: 80rpx;
}

.primary {
  background-color: #007aff;
  color: white;
}

.registered-btn {
  background-color: #52c41a;
  color: white;
}

.ongoing-btn {
  background-color: #ff9500;
  color: white;
}

.ended-btn {
  background-color: #999;
  color: white;
}

.feedback-btn {
  background-color: #fa8c16;
  color: white;
}

.view-feedback-btn {
  background-color: #1890ff;
  color: white;
}

.share-btn {
  height: 70rpx;
  background-color: #f8f8f8;
  color: #333;
  font-size: 26rpx;
  border: 1rpx solid #ddd;
  border-radius: 35rpx;
  line-height: 70rpx;
}

.loading, .empty {
  text-align: center;
  padding: 100rpx;
  color: #999;
  font-size: 28rpx;
}

/* 回执弹窗样式 */
.feedback-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.feedback-modal {
  width: 680rpx;
  max-height: 80vh;
  background-color: white;
  border-radius: 20rpx;
  overflow: hidden;
}

.modal-header {
  padding: 30rpx;
  border-bottom: 1rpx solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.close-btn {
  font-size: 50rpx;
  color: #999;
  line-height: 1;
}

.modal-content {
  max-height: 500rpx;
  padding: 30rpx;
}

.form-item {
  margin-bottom: 30rpx;
}

.form-label {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 15rpx;
  display: block;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
  margin: 30rpx 0 20rpx 0;
  padding-bottom: 10rpx;
  border-bottom: 2rpx solid #f0f0f0;
}

.input {
  width: 100%;
  height: 80rpx;
  padding: 0 20rpx;
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  font-size: 26rpx;
  box-sizing: border-box;
}

.radio-group {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
}

.radio-item {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.radio {
  font-size: 32rpx;
  color: #ddd;
  margin-right: 10rpx;
  transition: color 0.3s;
}

.radio.checked {
  color: #007aff;
}

.rating-stars {
  display: flex;
  gap: 10rpx;
}

.rating-stars.small {
  gap: 5rpx;
}

.star {
  font-size: 40rpx;
  color: #ddd;
  cursor: pointer;
}

.rating-stars.small .star {
  font-size: 30rpx;
}

.star.active {
  color: #faad14;
}

.textarea {
  width: 100%;
  min-height: 120rpx;
  padding: 20rpx;
  border: 1rpx solid #ddd;
  border-radius: 10rpx;
  font-size: 26rpx;
  line-height: 1.4;
  box-sizing: border-box;
}

.rating-section {
  margin-top: 30rpx;
}

.rating-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.rating-label {
  font-size: 26rpx;
  color: #333;
}

.modal-footer {
  padding: 30rpx;
  border-top: 1rpx solid #eee;
  display: flex;
  gap: 20rpx;
}

.modal-footer .cancel-btn {
  flex: 1;
  height: 70rpx;
  background-color: #f8f8f8;
  color: #333;
  border: 1rpx solid #ddd;
  border-radius: 35rpx;
  font-size: 28rpx;
  line-height: 70rpx;
}

.submit-btn {
  flex: 2;
  height: 70rpx;
  background-color: #007aff;
  color: white;
  border: none;
  border-radius: 35rpx;
  font-size: 28rpx;
  line-height: 70rpx;
}

.submit-btn:disabled {
  background-color: #ccc;
}

.my-feedback-block {
  background: #fff;
  border-radius: 18rpx;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.08);
  margin: 40rpx 0 0 0;
  padding: 32rpx 24rpx 24rpx 24rpx;
}
.feedback-section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #2f80ed;
  margin-bottom: 24rpx;
}
.feedback-group {
  display: flex;
  margin-bottom: 16rpx;
}
.feedback-label {
  width: 140rpx;
  color: #888;
  font-size: 26rpx;
  flex-shrink: 0;
}
.feedback-value {
  color: #333;
  font-size: 26rpx;
  word-break: break-all;
}
.feedback-value.star {
  color: #faad14;
  font-size: 28rpx;
}

/* 回执弹窗样式 */
.feedback-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.feedback-popup {
  width: 600rpx;
  max-height: 80vh;
  background-color: white;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.3);
}

.popup-header {
  padding: 30rpx;
  border-bottom: 1rpx solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #6dd5fa 0%, #2980b9 100%);
}

.popup-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #fff;
}

.popup-close {
  font-size: 40rpx;
  color: #fff;
  line-height: 1;
  cursor: pointer;
}

.popup-content {
  max-height: 60vh;
  padding: 30rpx;
}

.popup-content .feedback-group {
  display: flex;
  margin-bottom: 20rpx;
  padding-bottom: 15rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.popup-content .feedback-label {
  width: 140rpx;
  color: #666;
  font-size: 26rpx;
  flex-shrink: 0;
  font-weight: 500;
}

.popup-content .feedback-value {
  color: #333;
  font-size: 26rpx;
  word-break: break-all;
  line-height: 1.4;
}

.popup-content .feedback-value.star {
  color: #faad14;
  font-size: 28rpx;
}
</style> 