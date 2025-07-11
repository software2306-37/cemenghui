<script>
	export default {
		onLaunch: function() {
			console.log('App Launch')
			this.initApp()
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		},
		methods: {
			initApp() {
				// 检查网络状态
				this.checkNetworkStatus()
				
				// 检查版本更新
				this.checkUpdate()
				
				// 初始化全局错误处理
				this.initErrorHandler()
			},
			
			checkNetworkStatus() {
				uni.getNetworkType({
					success: (res) => {
						if (res.networkType === 'none') {
							uni.showToast({
								title: '网络连接异常',
								icon: 'none'
							})
						}
					}
				})
				
				// 监听网络状态变化
				uni.onNetworkStatusChange((res) => {
					if (!res.isConnected) {
						uni.showToast({
							title: '网络连接断开',
							icon: 'none'
						})
					}
				})
			},
			
			checkUpdate() {
				// #ifdef MP-WEIXIN
				const updateManager = uni.getUpdateManager()
				
				updateManager.onCheckForUpdate((res) => {
					if (res.hasUpdate) {
						uni.showModal({
							title: '更新提示',
							content: '新版本已经准备好，是否重启应用？',
							success: (res) => {
								if (res.confirm) {
									updateManager.applyUpdate()
								}
							}
						})
					}
				})
				
				updateManager.onUpdateReady(() => {
					uni.showModal({
						title: '更新提示',
						content: '新版本已经准备好，是否重启应用？',
						success: (res) => {
							if (res.confirm) {
								updateManager.applyUpdate()
							}
						}
					})
				})
				
				updateManager.onUpdateFailed(() => {
					uni.showToast({
						title: '更新失败',
						icon: 'none'
					})
				})
				// #endif
			},
			
			initErrorHandler() {
				// 全局错误处理
				uni.onError((error) => {
					console.error('全局错误:', error)
					uni.showToast({
						title: '系统异常，请稍后重试',
						icon: 'none'
					})
				})
			}
		}
	}
</script>

<style>
	/*每个页面公共css */
	page {
		background-color: #f8f8f8;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
		line-height: 1.6;
	}
	
	/* 全局按钮样式 */
	button {
		border: none;
		outline: none;
		box-sizing: border-box;
	}
	
	button::after {
		border: none;
	}
	
	/* 全局文本样式 */
	text, view {
		box-sizing: border-box;
	}
	
	/* 滚动条样式 */
	::-webkit-scrollbar {
		display: none;
	}
	
	/* 全局loading样式 */
	.loading {
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 40rpx;
		color: #999;
		font-size: 28rpx;
	}
	
	/* 全局空状态样式 */
	.empty {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		padding: 80rpx 40rpx;
		color: #999;
		font-size: 28rpx;
	}
	
	.empty-icon {
		font-size: 80rpx;
		margin-bottom: 20rpx;
	}
	
	/* 全局错误样式 */
	.error {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		padding: 80rpx 40rpx;
		color: #ff4757;
		font-size: 28rpx;
	}
	
	.error-icon {
		font-size: 80rpx;
		margin-bottom: 20rpx;
	}
	
	/* 全局动画 */
	.fade-in {
		animation: fadeIn 0.3s ease-in-out;
	}
	
	@keyframes fadeIn {
		from {
			opacity: 0;
		}
		to {
			opacity: 1;
		}
	}
	
	.slide-up {
		animation: slideUp 0.3s ease-out;
	}
	
	@keyframes slideUp {
		from {
			transform: translateY(100rpx);
			opacity: 0;
		}
		to {
			transform: translateY(0);
			opacity: 1;
		}
	}
</style>
