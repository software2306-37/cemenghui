<template>
	<view class="container">
		<!-- 页面标题 -->
		<view class="page-header">
			<text class="page-title">测汇盟成员</text>
			<text class="page-subtitle">我们的专业团队</text>
		</view>
		
		<!-- 搜索框 -->
		<view class="search-section">
			<view class="search-box">
				<text class="search-icon">🔍</text>
				<input 
					class="search-input" 
					placeholder="搜索成员..." 
					v-model="searchKeyword"
					@input="onSearchInput"
				/>
				<text class="clear-icon" v-if="searchKeyword" @click="clearSearch">✕</text>
			</view>
		</view>
		
		<!-- 筛选选项 -->
		<view class="filter-section">
			<view class="filter-tabs">
				<view 
					class="filter-tab" 
					:class="{'active': filterType === 'all'}"
					@click="setFilter('all')"
				>
					全部
				</view>
				<view 
					class="filter-tab" 
					:class="{'active': filterType === 'admin'}"
					@click="setFilter('admin')"
				>
					管理员
				</view>
				<view 
					class="filter-tab" 
					:class="{'active': filterType === 'user'}"
					@click="setFilter('user')"
				>
					普通用户
				</view>
			</view>
		</view>
		
		<!-- 成员列表 -->
		<view class="member-list">
			<view 
				class="member-item" 
				v-for="member in filteredMemberList" 
				:key="member.id" 
				@click="showMemberDetail(member)"
			>
				<view class="member-avatar">
					<image v-if="member.avatar" :src="getImageUrl(member.avatar)" class="avatar-image" mode="aspectFill"></image>
					<view v-else class="avatar-placeholder">
						<text class="avatar-text">{{ getMemberInitial(member) }}</text>
					</view>
				</view>
				
				<view class="member-info">
					<view class="member-main">
						<text class="member-name">{{ getMemberName(member) }}</text>
						<view class="member-badges">
							<text class="role-badge" :class="{'admin': member.role === 'ADMIN'}">
								{{ member.role === 'ADMIN' ? '管理员' : '会员' }}
							</text>
							<text class="gender-badge" v-if="member.gender">
								{{ member.gender === 1 ? '男' : '女' }}
							</text>
						</view>
					</view>
					
					<view class="member-details">
						<text class="detail-item" v-if="member.companyName">
							<text class="detail-icon">🏢</text>{{ member.companyName }}
						</text>
						<text class="detail-item">
							<text class="detail-icon">👤</text>{{ member.username }}
						</text>
					</view>
					
					<view class="member-time">
						<text class="time-text">加入时间：{{ formatDate(member.createTime) }}</text>
					</view>
				</view>
			</view>
		</view>
		
		<!-- 空状态 -->
		<view v-if="filteredMemberList.length === 0 && !loading" class="empty-state">
			<text class="empty-icon">👥</text>
			<text class="empty-text">{{ getEmptyText() }}</text>
			<text class="empty-desc">{{ getEmptyDesc() }}</text>
		</view>
		
		<!-- 加载状态 -->
		<view v-if="loading" class="loading-state">
			<text class="loading-text">加载中...</text>
		</view>
	</view>
</template>

<script>
import { api } from '../../utils/request'
import { getImageUrl } from '../../utils/common'

export default {
	data() {
		return {
			memberList: [],
			searchKeyword: '',
			filterType: 'all', // all, admin, user
			loading: false
		}
	},
	computed: {
		filteredMemberList() {
			let list = this.memberList
			
			// 角色筛选
			if (this.filterType === 'admin') {
				list = list.filter(member => member.role === 'ADMIN')
			} else if (this.filterType === 'user') {
				list = list.filter(member => member.role !== 'ADMIN')
			}
			
			// 搜索过滤
			if (this.searchKeyword) {
				const keyword = this.searchKeyword.toLowerCase()
				list = list.filter(member => {
					const name = this.getMemberName(member).toLowerCase()
					const username = member.username.toLowerCase()
					const company = (member.companyName || '').toLowerCase()
					
					return name.includes(keyword) || 
						   username.includes(keyword) || 
						   company.includes(keyword)
				})
			}
			
			return list
		}
	},
	async onLoad() {
		await this.loadMemberData()
	},
	onShow() {
		uni.setNavigationBarTitle({
			title: '测汇盟成员'
		})
	},
	methods: {
		async loadMemberData() {
			this.loading = true
			try {
				console.log('开始加载成员数据...')
				// 获取所有成员数据，不限制数量
				const result = await api.getMemberList()
				
				if (result && result.data) {
					this.memberList = result.data
					console.log('成员数据加载成功:', this.memberList.length, '个成员')
				} else {
					console.log('成员数据为空')
					this.memberList = []
				}
			} catch (error) {
				console.error('加载成员数据失败:', error)
				this.memberList = []
				uni.showToast({
					title: '加载失败，请重试',
					icon: 'none'
				})
			} finally {
				this.loading = false
			}
		},
		
		onSearchInput() {
			console.log('搜索关键词:', this.searchKeyword)
		},
		
		clearSearch() {
			this.searchKeyword = ''
		},
		
		setFilter(type) {
			this.filterType = type
		},
		
		showMemberDetail(member) {
			const memberName = this.getMemberName(member)
			const memberTitle = member.role === 'ADMIN' ? '管理员' : '会员'
			const memberCompany = member.companyName || '未设置'
			const memberGender = member.gender === 1 ? '男' : member.gender === 2 ? '女' : '未设置'
			
			uni.showModal({
				title: memberName,
				content: `职位：${memberTitle}\n公司：${memberCompany}\n性别：${memberGender}\n用户名：${member.username}\n加入时间：${this.formatDate(member.createTime)}`,
				showCancel: false,
				confirmText: '知道了'
			})
		},
		
		getMemberName(member) {
			return member.nickname || member.username || '未设置'
		},
		
		getMemberInitial(member) {
			const name = this.getMemberName(member)
			return name.charAt(0).toUpperCase()
		},
		
		getImageUrl(imagePath) {
			return getImageUrl(imagePath)
		},
		
		formatDate(dateStr) {
			if (!dateStr) return '未知'
			const date = new Date(dateStr)
			return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
		},
		
		getEmptyText() {
			if (this.searchKeyword) {
				return '未找到相关成员'
			}
			if (this.filterType === 'admin') {
				return '暂无管理员'
			}
			if (this.filterType === 'user') {
				return '暂无普通用户'
			}
			return '暂无成员'
		},
		
		getEmptyDesc() {
			if (this.searchKeyword) {
				return '请尝试其他关键词'
			}
			return '敬请期待更多成员加入'
		}
	}
}
</script>

<style scoped>
	.container {
		background-color: #f8f8f8;
		min-height: 100vh;
		padding: 20rpx;
	}
	
	/* 页面标题 */
	.page-header {
		text-align: center;
		padding: 40rpx 0;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		border-radius: 16rpx;
		margin-bottom: 30rpx;
		color: white;
	}
	
	.page-title {
		font-size: 36rpx;
		font-weight: bold;
		display: block;
		margin-bottom: 10rpx;
	}
	
	.page-subtitle {
		font-size: 26rpx;
		opacity: 0.8;
		display: block;
	}
	
	/* 搜索框 */
	.search-section {
		margin-bottom: 20rpx;
	}
	
	.search-box {
		background-color: white;
		border-radius: 50rpx;
		padding: 20rpx 30rpx;
		display: flex;
		align-items: center;
		box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
	}
	
	.search-icon {
		font-size: 32rpx;
		color: #999;
		margin-right: 20rpx;
	}
	
	.search-input {
		flex: 1;
		font-size: 28rpx;
		color: #333;
	}
	
	.clear-icon {
		font-size: 28rpx;
		color: #999;
		padding: 10rpx;
	}
	
	/* 筛选选项 */
	.filter-section {
		margin-bottom: 30rpx;
	}
	
	.filter-tabs {
		display: flex;
		background-color: white;
		border-radius: 50rpx;
		padding: 8rpx;
		box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
	}
	
	.filter-tab {
		flex: 1;
		text-align: center;
		padding: 16rpx;
		font-size: 26rpx;
		color: #666;
		border-radius: 40rpx;
		transition: all 0.3s ease;
	}
	
	.filter-tab.active {
		background-color: #667eea;
		color: white;
	}
	
	/* 成员列表 */
	.member-list {
		padding-bottom: 40rpx;
	}
	
	.member-item {
		background-color: white;
		border-radius: 16rpx;
		padding: 30rpx;
		margin-bottom: 20rpx;
		display: flex;
		align-items: flex-start;
		box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
	}
	
	.member-item:active {
		transform: scale(0.98);
		opacity: 0.8;
	}
	
	.member-avatar {
		width: 100rpx;
		height: 100rpx;
		border-radius: 50%;
		margin-right: 25rpx;
		overflow: hidden;
		flex-shrink: 0;
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
		font-size: 36rpx;
		font-weight: bold;
	}
	
	.member-info {
		flex: 1;
		min-width: 0;
	}
	
	.member-main {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		margin-bottom: 15rpx;
	}
	
	.member-name {
		font-size: 32rpx;
		font-weight: bold;
		color: #333;
		flex: 1;
		margin-right: 20rpx;
	}
	
	.member-badges {
		display: flex;
		gap: 8rpx;
		flex-shrink: 0;
	}
	
	.role-badge {
		font-size: 22rpx;
		color: #666;
		background-color: #f5f5f5;
		padding: 6rpx 12rpx;
		border-radius: 12rpx;
		white-space: nowrap;
	}
	
	.role-badge.admin {
		color: #ff6b6b;
		background-color: #fff0f0;
	}
	
	.gender-badge {
		font-size: 22rpx;
		color: #007aff;
		background-color: #e6f3ff;
		padding: 6rpx 12rpx;
		border-radius: 12rpx;
		white-space: nowrap;
	}
	
	.member-details {
		margin-bottom: 15rpx;
	}
	
	.detail-item {
		font-size: 26rpx;
		color: #666;
		display: flex;
		align-items: center;
		margin-bottom: 8rpx;
		line-height: 1.4;
	}
	
	.detail-icon {
		font-size: 24rpx;
		margin-right: 8rpx;
		width: 32rpx;
	}
	
	.member-time {
		border-top: 1rpx solid #f0f0f0;
		padding-top: 15rpx;
	}
	
	.time-text {
		font-size: 24rpx;
		color: #999;
	}
	
	/* 空状态 */
	.empty-state {
		text-align: center;
		padding: 100rpx 40rpx;
	}
	
	.empty-icon {
		font-size: 120rpx;
		display: block;
		margin-bottom: 30rpx;
		opacity: 0.3;
	}
	
	.empty-text {
		font-size: 32rpx;
		color: #666;
		display: block;
		margin-bottom: 15rpx;
	}
	
	.empty-desc {
		font-size: 26rpx;
		color: #999;
		display: block;
	}
	
	/* 加载状态 */
	.loading-state {
		text-align: center;
		padding: 100rpx;
	}
	
	.loading-text {
		font-size: 28rpx;
		color: #999;
	}
</style> 