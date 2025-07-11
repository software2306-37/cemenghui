<template>
  <view class="container">
    <view class="grid">
      <view
        class="card"
        v-for="category in categories"
        :key="category.key"
        :style="{ background: category.gradient }"
        @click="goToCategory(category)"
      >
        <view class="card-title">{{ category.name }}</view>
        <view class="card-desc">{{ category.description }}</view>
        <view class="card-footer" v-if="category.time || category.organizer">
          <text v-if="category.time" class="card-time">📅 {{ category.time }}</text>
          <text v-if="category.organizer" class="card-org">{{ category.organizer }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      categories: [
        {
          key: '研讨',
          name: '会议研讨',
          description: '协会组织会员单位召开行业会议，研讨型技术与行业发展。',
          gradient: 'linear-gradient(135deg, #56ccf2 0%, #2f80ed 100%)',
          time: '2023.08.02',
          organizer: '云管用户计算委员会'
        },
        {
          key: '标准定制',
          name: '标准定制',
          description: '协会组织成员单位联合制定软件测试行业标准。',
          gradient: 'linear-gradient(135deg, #56ccf2 0%, #2f80ed 100%)',
          time: '',
          organizer: ''
        },
        {
          key: '技术培训',
          name: '技术培训',
          description: '协会组织会员单位开展软件测试认证、软件评估评估等培训。',
          gradient: 'linear-gradient(135deg, #56ccf2 0%, #2f80ed 100%)',
          time: '',
          organizer: ''
        },
        {
          key: '工具研发',
          name: '工具研发',
          description: '协会组织会员单位共同研发软件测试相关工具。',
          gradient: 'linear-gradient(135deg, #56ccf2 0%, #2f80ed 100%)',
          time: '',
          organizer: ''
        },
        {
          key: '公益行动',
          name: '公益行动',
          description: '会员单位组织参与多次公益达达区等青少年公益活动。',
          gradient: 'linear-gradient(135deg, #56ccf2 0%, #2f80ed 100%)',
          time: '',
          organizer: '云管联盟'
        }
      ]
    }
  },
  methods: {
    goToCategory(category) {
      uni.navigateTo({
        url: `/pages/meeting/category-list?category=${encodeURIComponent(category.key)}&name=${encodeURIComponent(category.name)}`
      })
    }
  }
}
</script>

<style scoped>
.container {
  padding: 32rpx 16rpx 0 16rpx;
  background: #f6f8fa;
  min-height: 100vh;
}
.grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}
.card {
  width: 48%;
  margin-bottom: 32rpx;
  border-radius: 20rpx;
  box-shadow: 0 6rpx 24rpx rgba(0,0,0,0.10);
  padding: 32rpx 24rpx 24rpx 24rpx;
  box-sizing: border-box;
  color: #fff;
  position: relative;
  min-height: 180rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  transition: transform 0.1s;
}
.card:active {
  transform: scale(0.97);
}
.card-title {
  font-size: 32rpx;
  font-weight: bold;
  text-align: center;
  margin-bottom: 18rpx;
  letter-spacing: 2rpx;
}
.card-desc {
  font-size: 24rpx;
  line-height: 1.5;
  text-align: left;
  color: #f5f5f5;
  margin-bottom: 18rpx;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: 60rpx;
}
.card-footer {
  display: flex;
  align-items: center;
  font-size: 20rpx;
  color: #e0e0e0;
  justify-content: space-between;
  margin-top: 8rpx;
}
.card-time {
  margin-right: 10rpx;
}
.card-org {
  font-size: 20rpx;
  color: #e0e0e0;
}
</style> 