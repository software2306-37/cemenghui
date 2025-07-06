<template>
	<view class="container">
		<!-- 页面标题 -->
		<view class="page-header">
			<text class="page-title">合作伙伴</text>
			<text class="page-subtitle">我们的合作企业</text>
		</view>
		
		<!-- 搜索框 -->
		<view class="search-section">
			<view class="search-box">
				<text class="search-icon">🔍</text>
				<input 
					class="search-input" 
					placeholder="搜索合作伙伴..." 
					v-model="searchKeyword"
					@input="onSearchInput"
				/>
				<text class="clear-icon" v-if="searchKeyword" @click="clearSearch">✕</text>
			</view>
		</view>
		
		<!-- 租户列表 -->
		<view class="tenant-list">
			<view 
				class="tenant-item" 
				v-for="tenant in filteredTenantList" 
				:key="tenant.id" 
				@click="showTenantDetail(tenant)"
			>
				<view class="tenant-main">
					<view class="tenant-info">
						<text class="tenant-name">{{ tenant.tenantName }}</text>
						<text class="tenant-code">{{ tenant.tenantCode }}</text>
					</view>
					<view class="tenant-status">
						<text class="status-badge" :class="{'active': tenant.status === 1}">
							{{ tenant.status === 1 ? '合作中' : '暂停' }}
						</text>
					</view>
				</view>
				
				<view class="tenant-details" v-if="tenant.contactPerson || tenant.contactPhone">
					<text class="detail-item" v-if="tenant.contactPerson">
						<text class="detail-label">联系人：</text>{{ tenant.contactPerson }}
					</text>
					<text class="detail-item" v-if="tenant.contactPhone">
						<text class="detail-label">电话：</text>{{ tenant.contactPhone }}
					</text>
				</view>
				
				<view class="tenant-time">
					<text class="time-text">合作时间：{{ formatDate(tenant.createTime) }}</text>
				</view>
			</view>
		</view>
		
		<!-- 空状态 -->
		<view v-if="filteredTenantList.length === 0 && !loading" class="empty-state">
			<text class="empty-icon">🏢</text>
			<text class="empty-text">{{ searchKeyword ? '未找到相关合作伙伴' : '暂无合作伙伴' }}</text>
			<text class="empty-desc">{{ searchKeyword ? '请尝试其他关键词' : '敬请期待更多合作企业' }}</text>
		</view>
		
		<!-- 加载状态 -->
		<view v-if="loading" class="loading-state">
			<text class="loading-text">加载中...</text>
		</view>
	</view>
</template>

<script>
import { api } from '../../utils/request'

export default {
	data() {
		return {
			tenantList: [],
			searchKeyword: '',
			loading: false
		}
	},
	computed: {
		filteredTenantList() {
			if (!this.searchKeyword) {
				return this.tenantList
			}
			
			const keyword = this.searchKeyword.toLowerCase()
			return this.tenantList.filter(tenant => {
				return (
					tenant.tenantName.toLowerCase().includes(keyword) ||
					tenant.tenantCode.toLowerCase().includes(keyword) ||
					(tenant.contactPerson && tenant.contactPerson.toLowerCase().includes(keyword))
				)
			})
		}
	},
	async onLoad() {
		await this.loadTenantData()
	},
	onShow() {
		uni.setNavigationBarTitle({
			title: '合作伙伴'
		})
	},
	methods: {
		async loadTenantData() {
			this.loading = true
			try {
				console.log('开始加载合作伙伴数据...')
				// 获取所有租户数据，不限制数量
				const result = await api.getTenantList()
				
				if (result && result.data) {
					this.tenantList = result.data
					console.log('合作伙伴数据加载成功:', this.tenantList.length, '个伙伴')
				} else {
					console.log('合作伙伴数据为空')
					this.tenantList = []
				}
			} catch (error) {
				console.error('加载合作伙伴数据失败:', error)
				this.tenantList = []
				uni.showToast({
					title: '加载失败，请重试',
					icon: 'none'
				})
			} finally {
				this.loading = false
			}
		},
		
		onSearchInput() {
			// 搜索输入处理
			console.log('搜索关键词:', this.searchKeyword)
		},
		
		clearSearch() {
			this.searchKeyword = ''
		},
		
		showTenantDetail(tenant) {
			uni.showModal({
				title: tenant.tenantName,
				content: `租户编码：${tenant.tenantCode}\n联系人：${tenant.contactPerson || '未设置'}\n联系电话：${tenant.contactPhone || '未设置'}\n合作状态：${tenant.status === 1 ? '合作中' : '暂停'}\n合作时间：${this.formatDate(tenant.createTime)}`,
				showCancel: false,
				confirmText: '知道了'
			})
		},
		
		formatDate(dateStr) {
			if (!dateStr) return '未知'
			const date = new Date(dateStr)
			return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
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
		margin-bottom: 30rpx;
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
	
	/* 租户列表 */
	.tenant-list {
		padding-bottom: 40rpx;
	}
	
	.tenant-item {
		background-color: white;
		border-radius: 16rpx;
		padding: 30rpx;
		margin-bottom: 20rpx;
		box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
		border-left: 6rpx solid #667eea;
	}
	
	.tenant-item:active {
		transform: scale(0.98);
		opacity: 0.8;
	}
	
	.tenant-main {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		margin-bottom: 20rpx;
	}
	
	.tenant-info {
		flex: 1;
	}
	
	.tenant-name {
		font-size: 32rpx;
		font-weight: bold;
		color: #333;
		display: block;
		margin-bottom: 8rpx;
		line-height: 1.4;
	}
	
	.tenant-code {
		font-size: 26rpx;
		color: #667eea;
		background-color: #f0f4ff;
		padding: 6rpx 12rpx;
		border-radius: 12rpx;
		width: fit-content;
		display: block;
	}
	
	.tenant-status {
		margin-left: 20rpx;
	}
	
	.status-badge {
		font-size: 24rpx;
		color: #999;
		background-color: #f5f5f5;
		padding: 8rpx 16rpx;
		border-radius: 20rpx;
		display: block;
	}
	
	.status-badge.active {
		color: #52c41a;
		background-color: #f6ffed;
	}
	
	.tenant-details {
		margin-bottom: 15rpx;
	}
	
	.detail-item {
		font-size: 26rpx;
		color: #666;
		display: block;
		margin-bottom: 8rpx;
		line-height: 1.4;
	}
	
	.detail-label {
		color: #999;
		font-size: 24rpx;
	}
	
	.tenant-time {
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