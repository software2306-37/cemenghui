<template>
	<div class="not-found">
	    <div class="not-found-content">
	      <div class="error-code">404</div>
	      <div class="error-message">页面未找到</div>
	      <div class="error-description">抱歉，您访问的页面不存在</div>
	      <el-button type="primary" @click="goHome" size="large">返回首页</el-button>
	    </div>
	  </div>
</template>

<script setup>
	import { useRouter } from 'vue-router'
	
	const router = useRouter()
	
	const goHome = () => {
	  router.push('/')
	}
</script>

<style scoped>
	.not-found {
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  height: 100vh;
	  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	}
	
	.not-found-content {
	  text-align: center;
	  color: white;
	}
	
	.error-code {
	  font-size: 120px;
	  font-weight: bold;
	  margin-bottom: 20px;
	}
	
	.error-message {
	  font-size: 32px;
	  margin-bottom: 10px;
	}
	
	.error-description {
	  font-size: 18px;
	  margin-bottom: 30px;
	  opacity: 0.8;
	}
</style>