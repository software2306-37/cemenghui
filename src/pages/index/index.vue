<template>
	<view class="container">
		<!-- 顶部轮播图 -->
		<swiper class="banner" indicator-dots autoplay circular interval="3000" duration="500">
			<swiper-item v-for="(banner, index) in banners" :key="index" @click="onBannerClick(banner)">
				<view class="banner-item" :style="{ backgroundImage: banner.image ? `url(${banner.image})` : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' }">
					<view class="banner-overlay">
						<view class="banner-content">
							<text class="banner-title">{{ banner.title }}</text>
							<text class="banner-desc" v-if="banner.description">{{ banner.description }}</text>
						</view>
					</view>
				</view>
			</swiper-item>
		</swiper>
		
		<!-- 功能导航 -->
		<view class="nav-section">
			<view class="nav-item" @click="goToNews">
				<view class="nav-icon">📰</view>
				<text class="nav-text">行业动态</text>
			</view>
			<view class="nav-item" @click="goToCourse">
				<view class="nav-icon">📚</view>
				<text class="nav-text">技术课程</text>
			</view>
			<view class="nav-item" @click="goToMeeting">
				<view class="nav-icon">🤝</view>
				<text class="nav-text">合作会议</text>
			</view>
			<view class="nav-item" @click="goToUser">
				<view class="nav-icon">👤</view>
				<text class="nav-text">个人中心</text>
			</view>
		</view>
		
		<!-- 协会简介 -->
		<view class="section association-section">
			<view class="section-header">
				<text class="section-title">关于协会</text>
			</view>
			<view class="association-card">
				<view class="association-header">
					<view class="association-logo">
						<text class="logo-text">🏛️</text>
					</view>
					<view class="association-title">
						<text class="title-main">中国电子质量管理协会</text>
						<text class="title-sub">China Electronics Quality Management Association</text>
					</view>
				</view>
				<view class="association-content">
					<text class="association-desc">
						中国电子质量管理协会成立于1985年，是经国家民政部批准注册的全国性社会团体，业务主管单位为工业和信息化部。协会致力于推动电子信息产业质量管理水平提升，促进行业技术交流与合作，为企业提供专业的质量管理服务和技术支持。
					</text>
					<view class="association-stats">
						<view class="stat-item">
							<text class="stat-number">38</text>
							<text class="stat-label">年历史</text>
						</view>
						<view class="stat-item">
							<text class="stat-number">1000+</text>
							<text class="stat-label">会员企业</text>
						</view>
						<view class="stat-item">
							<text class="stat-number">500+</text>
							<text class="stat-label">专家团队</text>
						</view>
					</view>
				</view>
			</view>
		</view>
		
		<!-- 测盟汇成员信息 -->
		<view class="section members-section">
			<view class="section-header">
				<text class="section-title">测盟汇成员</text>
				<text class="section-more" @click="showAllMembers">查看全部 ></text>
			</view>
			<view class="members-grid">
				<view class="member-card" v-for="member in memberList" :key="member.id" @click="showMemberDetail(member)">
					<view class="member-avatar">
						<image v-if="member.avatar" :src="getImageUrl(member.avatar)" class="avatar-image" mode="aspectFill"></image>
						<view v-else class="avatar-placeholder">
							<text class="avatar-text">{{ member.name.charAt(0) }}</text>
						</view>
					</view>
					<view class="member-info">
						<text class="member-name">{{ member.name }}</text>
						<text class="member-title">{{ member.title }}</text>
						<text class="member-company" v-if="member.company">{{ member.company }}</text>
						<view class="member-tags">
							<text class="member-tag" v-for="tag in member.tags" :key="tag">{{ tag }}</text>
						</view>
					</view>
				</view>
			</view>
		</view>
		
		<!-- 最新动态 -->
		<view class="section">
			<view class="section-header">
				<text class="section-title">最新动态</text>
				<text class="section-more" @click="goToNews">更多 ></text>
			</view>
			<view v-if="newsList.length > 0" class="news-list">
				<view class="news-item" v-for="news in newsList" :key="news.id" @click="goToNewsDetail(news.id)">
					<view class="news-content">
						<text class="news-title">{{ news.title }}</text>
						<text class="news-summary" v-if="news.summary">{{ news.summary }}</text>
						<view class="news-meta">
							<text class="news-time">{{ formatDate(news.createTime) }}</text>
							<text class="news-views">{{ news.viewCount || 0 }}次浏览</text>
						</view>
					</view>
					<view class="news-image-container">
						<image v-if="news.coverImage" :src="getImageUrl(news.coverImage)" class="news-image" mode="aspectFill" @error="onImageError"></image>
						<view v-else class="news-image-placeholder">
							<text class="placeholder-text">📰</text>
						</view>
					</view>
				</view>
			</view>
			<view v-else class="empty-state">
				<text class="empty-icon">📰</text>
				<text class="empty-text">暂无最新动态</text>
				<text class="empty-desc">敬请期待精彩内容</text>
			</view>
		</view>
		
		<!-- 热门课程 -->
		<view class="section">
			<view class="section-header">
				<text class="section-title">热门课程</text>
				<text class="section-more" @click="goToCourse">更多 ></text>
			</view>
			<scroll-view v-if="courseList.length > 0" scroll-x="true" class="course-scroll">
				<view class="course-item" v-for="course in courseList" :key="course.id" @click="goToCourseDetail(course.id)">
					<view class="course-image-container">
						<image v-if="course.coverImage" :src="getImageUrl(course.coverImage)" class="course-image" mode="aspectFill" @error="onImageError"></image>
						<view v-else class="course-image-placeholder">
							<text class="placeholder-text">📚</text>
						</view>
					</view>
					<view class="course-info">
						<text class="course-title">{{ course.title || course.courseName }}</text>
						<text class="course-author" v-if="course.author">讲师：{{ course.author }}</text>
						<view class="course-meta">
							<text class="course-views">{{ course.viewCount || 0 }}人学习</text>
							<text class="course-status">{{ getStatusText(course.status) }}</text>
						</view>
					</view>
				</view>
			</scroll-view>
			<view v-else class="empty-state">
				<text class="empty-icon">📚</text>
				<text class="empty-text">暂无热门课程</text>
				<text class="empty-desc">敬请期待精彩课程</text>
			</view>
		</view>
		
		<!-- 即将开始的会议 -->
		<view class="section">
			<view class="section-header">
				<text class="section-title">即将开始</text>
				<text class="section-more" @click="goToMeeting">更多 ></text>
			</view>
			<view v-if="meetingList.length > 0" class="meeting-list">
				<view class="meeting-item" v-for="meeting in meetingList" :key="meeting.id" @click="goToMeetingDetail(meeting.id)">
					<view class="meeting-image-container">
						<image v-if="meeting.coverImage" :src="getImageUrl(meeting.coverImage)" class="meeting-image" mode="aspectFill" @error="onImageError"></image>
						<view v-else class="meeting-image-placeholder">
							<text class="placeholder-text">🤝</text>
						</view>
					</view>
					<view class="meeting-info">
						<text class="meeting-title">{{ meeting.meetingName }}</text>
						<view class="meeting-meta">
							<text class="meeting-time" v-if="meeting.meetingTime">{{ formatDateTime(meeting.meetingTime) }}</text>
							<text class="meeting-location" v-if="meeting.location">{{ meeting.location }}</text>
							<text class="meeting-organizer" v-if="meeting.organizer">主办：{{ meeting.organizer }}</text>
						</view>
					</view>
				</view>
			</view>
			<view v-else class="empty-state">
				<text class="empty-icon">🤝</text>
				<text class="empty-text">暂无即将开始的会议</text>
				<text class="empty-desc">敬请期待精彩会议</text>
			</view>
		</view>
		
		<!-- 加载状态 -->
		<view v-if="loading" class="loading-state">
			<text class="loading-text">加载中...</text>
		</view>
	</view>
</template>

<script>
import { api } from '../../utils/request'
import { getImageUrl, formatDateTime } from '../../utils/common'

export default {
	data() {
		return {
			banners: [],
			newsList: [],
			courseList: [],
			meetingList: [],
			memberList: [],
			loading: false,
			isLoggedIn: false,
			username: '用户'
		}
	},
	async onLoad() {
		// 检查登录状态
		const userInfo = uni.getStorageSync('userInfo')
		if (userInfo) {
			this.isLoggedIn = true
			this.username = userInfo.username || userInfo.name || '用户'
		}
		
		await this.loadHomeData()
		this.initMemberData()
	},
	onShow() {
		this.loadHomeData()
	},
	methods: {
		async loadHomeData() {
			this.loading = true
			try {
				console.log('开始加载首页数据...')
				
				// 并行加载所有数据，只获取已发布的内容
				const [newsResult, coursesResult, meetingsResult] = await Promise.all([
					api.getNewsList({ current: 1, size: 5, status: 1 }).catch(err => {
						console.error('加载新闻失败:', err)
						return { records: [] }
					}),
					api.getCourseList({ current: 1, size: 5, status: 1 }).catch(err => {
						console.error('加载课程失败:', err)
						return { records: [] }
					}),
					api.getMeetingList({ current: 1, size: 5, status: 1 }).catch(err => {
						console.error('加载会议失败:', err)
						return { records: [] }
					})
				])
				
				console.log('数据加载结果:', { newsResult, coursesResult, meetingsResult })
				
				// 处理新闻数据 - 确保只显示已发布内容
				const newsData = newsResult && newsResult.data && newsResult.data.records ? newsResult.data.records : []
				if (newsData.length > 0) {
					// 双重过滤确保只显示已发布的新闻
					const publishedNews = newsData.filter(item => item.status === 1)
					this.newsList = publishedNews
					
					// 使用已发布的新闻数据创建轮播图
					if (publishedNews.length > 0) {
						this.banners = publishedNews.slice(0, 3).map(item => ({
							id: item.id,
							title: item.title,
							description: item.summary,
							image: this.getImageUrl(item.coverImage),
							url: `/pages/news/detail?id=${item.id}`
						}))
					} else {
						// 没有已发布新闻时的默认轮播图
						this.banners = [
							{
								id: 'default',
								title: '欢迎来到测盟汇',
								description: '专业的测试交流平台',
								image: null,
								url: '/pages/news/news'
							}
						]
					}
				} else {
					this.newsList = []
					// 设置默认轮播图
					this.banners = [
						{
							id: 'default',
							title: '欢迎来到测盟汇',
							description: '专业的测试交流平台',
							image: null,
							url: '/pages/news/news'
						}
					]
				}
				
				// 处理课程数据 - 确保只显示已发布内容
				const coursesData = coursesResult && coursesResult.data && coursesResult.data.records ? coursesResult.data.records : []
				console.log('课程原始数据:', coursesData)
				if (coursesData.length > 0) {
					// 双重过滤确保只显示已发布的课程
					const publishedCourses = coursesData.filter(item => item.status === 1)
					console.log('已发布课程:', publishedCourses)
					this.courseList = publishedCourses
				} else {
					this.courseList = []
				}
				
				// 处理会议数据 - 确保只显示已发布内容
				const meetingsData = meetingsResult && meetingsResult.data && meetingsResult.data.records ? meetingsResult.data.records : []
				console.log('会议原始数据:', meetingsData)
				if (meetingsData.length > 0) {
					// 双重过滤确保只显示已发布的会议
					const publishedMeetings = meetingsData.filter(item => item.status === 1)
					console.log('已发布会议:', publishedMeetings)
					this.meetingList = publishedMeetings
				} else {
					this.meetingList = []
				}
				
				console.log('首页数据加载完成:', {
					banners: this.banners.length,
					news: this.newsList.length,
					courses: this.courseList.length,
					meetings: this.meetingList.length
				})
				
			} catch (error) {
				console.error('加载首页数据失败:', error)
				
				// 设置默认数据
				this.banners = [
					{
						id: 'error',
						title: '测盟汇',
						description: '数据加载中，请稍后再试',
						image: null,
						url: '/pages/news/news'
					}
				]
				this.newsList = []
				this.courseList = []
				this.meetingList = []
				
				uni.showToast({
					title: '数据加载失败',
					icon: 'none',
					duration: 2000
				})
			} finally {
				this.loading = false
			}
		},
		
		// 轮播图点击事件
		onBannerClick(banner) {
			if (banner.url) {
				if (banner.url.includes('/detail?id=')) {
					uni.navigateTo({
						url: banner.url
					})
				} else {
					uni.switchTab({
						url: banner.url
					})
				}
			}
		},
		
		// 图片加载失败处理
		onImageError(e) {
			console.log('图片加载失败:', e)
		},
		
		// 导航方法
		goToNews() {
			uni.switchTab({
				url: '/pages/news/news'
			})
		},
		goToCourse() {
			uni.switchTab({
				url: '/pages/course/course'
			})
		},
		goToMeeting() {
			uni.switchTab({
				url: '/pages/meeting/meeting'
			})
		},
		goToUser() {
			uni.switchTab({
				url: '/pages/user/user'
			})
		},
		
		// 详情页导航
		goToNewsDetail(id) {
			if (!id) {
				uni.showToast({
					title: '内容不存在',
					icon: 'none'
				})
				return
			}
			uni.navigateTo({
				url: `/pages/news/detail?id=${id}`
			})
		},
		goToCourseDetail(id) {
			if (!id) {
				uni.showToast({
					title: '课程不存在',
					icon: 'none'
				})
				return
			}
			uni.navigateTo({
				url: `/pages/course/detail?id=${id}`
			})
		},
		goToMeetingDetail(id) {
			if (!id) {
				uni.showToast({
					title: '会议不存在',
					icon: 'none'
				})
				return
			}
			uni.navigateTo({
				url: `/pages/meeting/detail?id=${id}`
			})
		},
		
		// 工具方法
		formatDateTime(dateTimeStr) {
			if (!dateTimeStr) return ''
			return formatDateTime(dateTimeStr, 'MM-DD HH:mm')
		},
		formatDate(dateStr) {
			if (!dateStr) return ''
			const date = new Date(dateStr)
			return `${date.getMonth() + 1}-${date.getDate()}`
		},
		getImageUrl(imagePath) {
			return getImageUrl(imagePath)
		},
		getStatusText(status) {
			const statusMap = {
				0: '待审核',
				1: '已发布',
				2: '已拒绝'
			}
			return statusMap[status] || '未知'
		},
		
		// 初始化成员数据
		initMemberData() {
			this.memberList = [
				{
					id: 1,
					name: '张工程师',
					title: '高级测试专家',
					company: '华为技术有限公司',
					avatar: null,
					tags: ['自动化测试', '性能测试']
				},
				{
					id: 2,
					name: '李经理',
					title: '质量管理总监',
					company: '腾讯科技',
					avatar: null,
					tags: ['质量管理', '流程优化']
				},
				{
					id: 3,
					name: '王博士',
					title: '测试技术专家',
					company: '阿里巴巴',
					avatar: null,
					tags: ['AI测试', '区块链测试']
				},
				{
					id: 4,
					name: '陈主任',
					title: '测试部门负责人',
					company: '百度',
					avatar: null,
					tags: ['团队管理', '测试策略']
				},
				{
					id: 5,
					name: '刘专家',
					title: '资深测试工程师',
					company: '京东',
					avatar: null,
					tags: ['移动测试', '接口测试']
				},
				{
					id: 6,
					name: '赵顾问',
					title: '测试咨询顾问',
					company: '字节跳动',
					avatar: null,
					tags: ['测试咨询', '技术培训']
				}
			]
		},
		
		// 显示所有成员
		showAllMembers() {
			uni.showToast({
				title: '成员列表功能开发中',
				icon: 'none'
			})
		},
		
		// 显示成员详情
		showMemberDetail(member) {
			uni.showModal({
				title: member.name,
				content: `职位：${member.title}\n公司：${member.company}\n专长：${member.tags.join('、')}`,
				showCancel: false,
				confirmText: '知道了'
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

	/* 轮播图样式 */
	.banner {
		height: 400rpx;
	}

	.banner-item {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		position: relative;
		background-size: cover;
		background-position: center;
		background-repeat: no-repeat;
	}

	.banner-overlay {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background: rgba(0, 0, 0, 0.3);
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.banner-content {
		text-align: center;
		padding: 0 40rpx;
	}

	.banner-title {
		color: white;
		font-size: 36rpx;
		font-weight: bold;
		display: block;
		margin-bottom: 10rpx;
		text-shadow: 0 2rpx 4rpx rgba(0,0,0,0.5);
	}

	.banner-desc {
		color: rgba(255,255,255,0.9);
		font-size: 28rpx;
		display: block;
		text-shadow: 0 1rpx 2rpx rgba(0,0,0,0.5);
	}

	/* 导航样式 */
	.nav-section {
		background-color: white;
		display: flex;
		padding: 40rpx 0;
		margin-bottom: 20rpx;
	}

	.nav-item {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.nav-icon {
		font-size: 60rpx;
		margin-bottom: 15rpx;
	}

	.nav-text {
		font-size: 26rpx;
		color: #333;
	}

	/* 通用section样式 */
	.section {
		background-color: white;
		margin-bottom: 20rpx;
		padding: 30rpx;
	}

	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 30rpx;
	}

	.section-title {
		font-size: 32rpx;
		font-weight: bold;
		color: #333;
	}

	.section-more {
		font-size: 26rpx;
		color: #007aff;
	}

	/* 空状态样式 */
	.empty-state {
		text-align: center;
		padding: 60rpx 40rpx;
	}

	.empty-icon {
		font-size: 80rpx;
		display: block;
		margin-bottom: 20rpx;
		opacity: 0.6;
	}

	.empty-text {
		font-size: 28rpx;
		color: #666;
		display: block;
		margin-bottom: 10rpx;
	}

	.empty-desc {
		font-size: 24rpx;
		color: #999;
		display: block;
	}

	/* 新闻列表样式 */
	.news-item {
		display: flex;
		padding: 20rpx 0;
		border-bottom: 1rpx solid #f0f0f0;
	}

	.news-item:last-child {
		border-bottom: none;
	}

	.news-content {
		flex: 1;
		margin-right: 20rpx;
	}

	.news-title {
		font-size: 30rpx;
		color: #333;
		font-weight: bold;
		display: block;
		margin-bottom: 10rpx;
		line-height: 1.4;
	}

	.news-summary {
		font-size: 26rpx;
		color: #666;
		line-height: 1.4;
		display: block;
		margin-bottom: 10rpx;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}

	.news-meta {
		font-size: 24rpx;
		color: #999;
		display: flex;
		justify-content: space-between;
	}

	.news-image-container {
		width: 160rpx;
		height: 120rpx;
		border-radius: 8rpx;
		overflow: hidden;
		background-color: #f5f5f5;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.news-image {
		width: 100%;
		height: 100%;
	}

	.news-image-placeholder {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: #f8f8f8;
	}

	.placeholder-text {
		font-size: 40rpx;
		opacity: 0.5;
	}

	/* 课程滚动样式 */
	.course-scroll {
		white-space: nowrap;
	}

	.course-item {
		display: inline-block;
		width: 280rpx;
		background-color: #f8f8f8;
		border-radius: 10rpx;
		overflow: hidden;
		margin-right: 20rpx;
	}

	.course-image-container {
		width: 100%;
		height: 180rpx;
		background-color: #f5f5f5;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.course-image {
		width: 100%;
		height: 100%;
	}

	.course-image-placeholder {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: #f8f8f8;
	}

	.course-info {
		padding: 20rpx;
	}

	.course-title {
		font-size: 28rpx;
		color: #333;
		display: block;
		margin-bottom: 10rpx;
		font-weight: bold;
		line-height: 1.4;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.course-author {
		font-size: 24rpx;
		color: #666;
		display: block;
		margin-bottom: 10rpx;
	}

	.course-meta {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.course-views {
		font-size: 24rpx;
		color: #999;
	}

	.course-status {
		font-size: 22rpx;
		color: #007aff;
		background-color: #e6f3ff;
		padding: 4rpx 8rpx;
		border-radius: 10rpx;
	}

	/* 会议列表样式 */
	.meeting-item {
		display: flex;
		align-items: flex-start;
		padding: 25rpx 0;
		border-bottom: 1rpx solid #f0f0f0;
	}

	.meeting-item:last-child {
		border-bottom: none;
	}

	.meeting-image-container {
		width: 160rpx;
		height: 120rpx;
		border-radius: 8rpx;
		overflow: hidden;
		margin-right: 20rpx;
		background-color: #f5f5f5;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.meeting-image {
		width: 100%;
		height: 100%;
	}

	.meeting-image-placeholder {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: #f8f8f8;
	}

	.meeting-info {
		flex: 1;
	}

	.meeting-title {
		font-size: 30rpx;
		color: #333;
		font-weight: bold;
		display: block;
		margin-bottom: 15rpx;
		line-height: 1.4;
	}

	.meeting-meta {
		font-size: 24rpx;
		color: #666;
	}

	.meeting-time {
		display: block;
		margin-bottom: 8rpx;
	}

	.meeting-location {
		display: block;
		margin-bottom: 8rpx;
		color: #999;
	}

	.meeting-organizer {
		display: block;
		color: #666;
	}

	/* 加载状态 */
	.loading-state {
		text-align: center;
		padding: 40rpx;
	}

	.loading-text {
		font-size: 28rpx;
		color: #999;
	}

	/* 协会简介样式 */
	.association-section {
		margin-bottom: 30rpx;
	}

	.association-card {
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		border-radius: 16rpx;
		padding: 30rpx;
		color: white;
	}

	.association-header {
		display: flex;
		align-items: center;
		margin-bottom: 25rpx;
	}

	.association-logo {
		width: 80rpx;
		height: 80rpx;
		background-color: rgba(255, 255, 255, 0.2);
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		margin-right: 20rpx;
	}

	.logo-text {
		font-size: 40rpx;
	}

	.association-title {
		flex: 1;
	}

	.title-main {
		font-size: 32rpx;
		font-weight: bold;
		display: block;
		margin-bottom: 5rpx;
	}

	.title-sub {
		font-size: 24rpx;
		opacity: 0.8;
		display: block;
	}

	.association-content {
		margin-top: 20rpx;
	}

	.association-desc {
		font-size: 28rpx;
		line-height: 1.6;
		margin-bottom: 25rpx;
		opacity: 0.9;
		display: block;
	}

	.association-stats {
		display: flex;
		justify-content: space-around;
	}

	.stat-item {
		text-align: center;
	}

	.stat-number {
		font-size: 36rpx;
		font-weight: bold;
		display: block;
		margin-bottom: 5rpx;
	}

	.stat-label {
		font-size: 24rpx;
		opacity: 0.8;
		display: block;
	}

	/* 成员信息样式 */
	.members-section {
		margin-bottom: 30rpx;
	}

	.members-grid {
		display: grid;
		grid-template-columns: repeat(2, 1fr);
		gap: 20rpx;
	}

	.member-card {
		background-color: #f8f8f8;
		border-radius: 12rpx;
		padding: 25rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		text-align: center;
		transition: all 0.3s ease;
	}

	.member-card:active {
		transform: scale(0.98);
		background-color: #f0f0f0;
	}

	.member-avatar {
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		margin-bottom: 15rpx;
		overflow: hidden;
	}

	.avatar-image {
		width: 100%;
		height: 100%;
	}

	.avatar-placeholder {
		width: 100%;
		height: 100%;
		background: linear-gradient(135deg, #667eea, #764ba2);
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.avatar-text {
		color: white;
		font-size: 32rpx;
		font-weight: bold;
	}

	.member-info {
		width: 100%;
	}

	.member-name {
		font-size: 28rpx;
		font-weight: bold;
		color: #333;
		display: block;
		margin-bottom: 8rpx;
	}

	.member-title {
		font-size: 24rpx;
		color: #666;
		display: block;
		margin-bottom: 8rpx;
	}

	.member-company {
		font-size: 22rpx;
		color: #999;
		display: block;
		margin-bottom: 12rpx;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.member-tags {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 8rpx;
	}

	.member-tag {
		font-size: 20rpx;
		color: #007aff;
		background-color: #e6f3ff;
		padding: 4rpx 8rpx;
		border-radius: 8rpx;
		white-space: nowrap;
	}
</style>
