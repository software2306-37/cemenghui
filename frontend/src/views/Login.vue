<template>
	 <div class="login-container">
	    <div class="login-box">
	      <h2>测盟汇管理系统</h2>
	      <el-form :model="loginForm" :rules="rules" ref="loginFormRef" class="login-form">
	        <el-form-item prop="username">
	          <el-input
	            v-model="loginForm.username"
	            placeholder="请输入用户名"
	            prefix-icon="User"
	            size="large"
	          />
	        </el-form-item>
	        <el-form-item prop="password">
	          <el-input
	            v-model="loginForm.password"
	            type="password"
	            placeholder="请输入密码"
	            prefix-icon="Lock"
	            size="large"
	            @keyup.enter="handleLogin"
	            show-password
	          />
	        </el-form-item>
	        <el-form-item prop="captcha">
	          <div class="captcha-container">
	            <el-input
	              v-model="loginForm.captcha"
	              placeholder="请输入验证码"
	              size="large"
	              style="flex: 1; margin-right: 10px;"
	              @keyup.enter="handleLogin"
	            />
	            <div class="captcha-image" @click="refreshCaptcha">
	              <canvas ref="captchaCanvas" width="120" height="40"></canvas>
	            </div>
	          </div>
	        </el-form-item>
	        <el-form-item>
	          <div class="login-options">
	            <el-checkbox v-model="rememberPassword">记住密码</el-checkbox>
	            <el-button type="text" @click="showForgotPassword = true" class="forgot-password-btn">忘记密码？</el-button>
	          </div>
	        </el-form-item>
	        <el-form-item>
	          <el-button
	            type="primary"
	            size="large"
	            style="width: 100%"
	            :loading="loading"
	            @click="handleLogin"
	          >
	            登录
	          </el-button>
	        </el-form-item>
	      </el-form>
	      <div class="register-link">
	        <span>还没有账号？</span>
	        <el-button type="text" @click="showRegister = true">立即注册</el-button>
	      </div>
	    </div>
	
	    <!-- 注册对话框 -->
	    <el-dialog v-model="showRegister" title="用户注册" width="450px">
	      <el-form :model="registerForm" :rules="registerRules" ref="registerFormRef" label-width="80px">
	        <el-form-item label="用户名" prop="username">
	          <el-input v-model="registerForm.username" />
	        </el-form-item>
	        <el-form-item label="密码" prop="password">
	          <el-input v-model="registerForm.password" type="password" show-password />
	        </el-form-item>
	        <el-form-item label="确认密码" prop="confirmPassword">
	          <el-input v-model="registerForm.confirmPassword" type="password" show-password />
	        </el-form-item>
	        <el-form-item label="企业名称" prop="companyName">
	          <el-input v-model="registerForm.companyName" />
	        </el-form-item>
	        <el-form-item label="手机号" prop="phone">
	          <el-input v-model="registerForm.phone" />
	        </el-form-item>
	        <el-form-item label="邮箱" prop="email">
	          <el-input v-model="registerForm.email" />
	        </el-form-item>
	        <el-form-item label="验证码" prop="captcha">
	          <div class="captcha-container">
	            <el-input
	              v-model="registerForm.captcha"
	              placeholder="请输入验证码"
	              style="flex: 1; margin-right: 10px;"
	            />
	            <div class="captcha-image" @click="refreshRegisterCaptcha">
	              <canvas ref="registerCaptchaCanvas" width="120" height="40"></canvas>
	            </div>
	          </div>
	        </el-form-item>
	      </el-form>
	      <template #footer>
	        <el-button @click="showRegister = false">取消</el-button>
	        <el-button type="primary" @click="handleRegister" :loading="registerLoading">注册</el-button>
	      </template>
	    </el-dialog>
		</div>

</template>

<script setup>
	import { ref, reactive, onMounted, nextTick } from 'vue'
	import { useRouter } from 'vue-router'
	import { ElMessage } from 'element-plus'
	import { CircleCheck } from '@element-plus/icons-vue'
	import request from '../utils/request'
	
	const router = useRouter()
	
	const loginForm = reactive({
	  username: '',
	  password: '',
	  captcha: ''
	})
	
	const registerForm = reactive({
	  username: '',
	  password: '',
	  confirmPassword: '',
	  companyName: '',
	  phone: '',
	  email: '',
	  captcha: ''
	})
	
	const rules = {
	  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
	  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
	  captcha: [{ required: true, message: '请输入验证码', trigger: 'blur' }]
	}
	
	const registerRules = {
	  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
	  password: [
	    { required: true, message: '请输入密码', trigger: 'blur' },
	    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
	  ],
	  confirmPassword: [
	    { required: true, message: '请确认密码', trigger: 'blur' },
	    {
	      validator: (rule, value, callback) => {
	        if (value !== registerForm.password) {
	          callback(new Error('两次输入密码不一致'))
	        } else {
	          callback()
	        }
	      },
	      trigger: 'blur'
	    }
	  ],
	  companyName: [{ required: true, message: '请输入企业名称', trigger: 'blur' }],
	  phone: [
	    { required: true, message: '请输入手机号', trigger: 'blur' },
	    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
	  ],
	  email: [
	    { required: true, message: '请输入邮箱', trigger: 'blur' },
	    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
	  ],
	  captcha: [{ required: true, message: '请输入验证码', trigger: 'blur' }]
	}
	const loading = ref(false)
	const registerLoading = ref(false)
	const forgotPasswordLoading = ref(false)
	const showRegister = ref(false)
	const showForgotPassword = ref(false)
	const forgotPasswordStep = ref(0)
	const rememberPassword = ref(false)
	const loginFormRef = ref()
	const registerFormRef = ref()
	const forgotPasswordFormRef = ref()
	const resetPasswordFormRef = ref()
	const captchaCanvas = ref()
	const registerCaptchaCanvas = ref()
	const forgotPasswordCaptchaCanvas = ref()
	
	// 验证码相关
	const captchaCode = ref('')
	const registerCaptchaCode = ref('')
	const forgotPasswordCaptchaCode = ref('')
	
	// 生成随机验证码
	const generateCaptcha = () => {
	  const chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678'
	  let result = ''
	  for (let i = 0; i < 4; i++) {
	    result += chars.charAt(Math.floor(Math.random() * chars.length))
	  }
	  return result
	}
	
	// 绘制验证码
	const drawCaptcha = (canvas, code) => {
	  if (!canvas) return
	  
	  const ctx = canvas.getContext('2d')
	  const width = canvas.width
	  const height = canvas.height
	  
	  // 清空画布
	  ctx.clearRect(0, 0, width, height)
	  
	  // 设置背景
	  ctx.fillStyle = '#f5f5f5'
	  ctx.fillRect(0, 0, width, height)
	  
	  // 绘制干扰线
	  for (let i = 0; i < 3; i++) {
	    ctx.strokeStyle = `hsl(${Math.random() * 360}, 50%, 50%)`
	    ctx.lineWidth = 1
	    ctx.beginPath()
	    ctx.moveTo(Math.random() * width, Math.random() * height)
	    ctx.lineTo(Math.random() * width, Math.random() * height)
	    ctx.stroke()
	  }
	  
	  // 绘制验证码文字
	  const fontSize = 24
	  ctx.font = `${fontSize}px Arial`
	  ctx.textAlign = 'center'
	  ctx.textBaseline = 'middle'
	  
	  for (let i = 0; i < code.length; i++) {
	    const x = (width / code.length) * i + (width / code.length) / 2
	    const y = height / 2 + (Math.random() - 0.5) * 10
	    const angle = (Math.random() - 0.5) * 0.3
	    
	    ctx.save()
	    ctx.translate(x, y)
	    ctx.rotate(angle)
	    ctx.fillStyle = `hsl(${Math.random() * 360}, 70%, 40%)`
	    ctx.fillText(code[i], 0, 0)
	    ctx.restore()
	  }
	  
	  // 绘制干扰点
	  for (let i = 0; i < 20; i++) {
	    ctx.fillStyle = `hsl(${Math.random() * 360}, 50%, 50%)`
	    ctx.beginPath()
	    ctx.arc(Math.random() * width, Math.random() * height, 1, 0, 2 * Math.PI)
	    ctx.fill()
	  }
	}
	
	// 刷新登录验证码
	const refreshCaptcha = () => {
	  captchaCode.value = generateCaptcha()
	  nextTick(() => {
	    drawCaptcha(captchaCanvas.value, captchaCode.value)
	  })
	}
	
	// 刷新注册验证码
	const refreshRegisterCaptcha = () => {
	  registerCaptchaCode.value = generateCaptcha()
	  nextTick(() => {
	    drawCaptcha(registerCaptchaCanvas.value, registerCaptchaCode.value)
	  })
	}
	onMounted(() => {
	  // 读取记住的用户名和密码
	  const savedUsername = localStorage.getItem('savedUsername')
	  const savedPassword = localStorage.getItem('savedPassword')
	  if (savedUsername && savedPassword) {
	    loginForm.username = savedUsername
	    loginForm.password = savedPassword
	    rememberPassword.value = true
	  }
	  
	  // 初始化验证码
	  refreshCaptcha()
	})
	
	const handleLogin = async () => {
	  if (!loginFormRef.value) return
	  
	  await loginFormRef.value.validate(async (valid) => {
	    if (valid) {
	      // 验证码校验
	      if (loginForm.captcha.toLowerCase() !== captchaCode.value.toLowerCase()) {
	        ElMessage.error('验证码错误')
	        refreshCaptcha()
	        loginForm.captcha = ''
	        return
	      }
	      
	      loading.value = true
	      try {
	        const res = await request.post('/user/login', loginForm)
	        localStorage.setItem('user', JSON.stringify(res.data))
	        
	        // 处理记住密码
	        if (rememberPassword.value) {
	          localStorage.setItem('savedUsername', loginForm.username)
	          localStorage.setItem('savedPassword', loginForm.password)
	        } else {
	          localStorage.removeItem('savedUsername')
	          localStorage.removeItem('savedPassword')
	        }
	        
	        ElMessage.success('登录成功')
	        router.push('/')
	      } catch (error) {
	        console.error('登录失败:', error)
	        refreshCaptcha()
	        loginForm.captcha = ''
	      } finally {
	        loading.value = false
	      }
	    }
	  })
	}
	
	const handleRegister = async () => {
	  if (!registerFormRef.value) return
	  
	  await registerFormRef.value.validate(async (valid) => {
	    if (valid) {
	      // 验证码校验
	      if (registerForm.captcha.toLowerCase() !== registerCaptchaCode.value.toLowerCase()) {
	        ElMessage.error('验证码错误')
	        refreshRegisterCaptcha()
	        registerForm.captcha = ''
	        return
	      }
	      
	      registerLoading.value = true
	      try {
	        await request.post('/user/register', registerForm)
	        ElMessage.success('注册成功，请登录')
	        showRegister.value = false
	        // 清空注册表单
	        Object.keys(registerForm).forEach(key => {
	          registerForm[key] = ''
	        })
	      } catch (error) {
	        console.error('注册失败:', error)
	        refreshRegisterCaptcha()
	        registerForm.captcha = ''
	      } finally {
	        registerLoading.value = false
	      }
	    }
	  })
	}
	
	// 监听注册对话框显示状态
	const handleRegisterDialogOpen = () => {
	  nextTick(() => {
	    refreshRegisterCaptcha()
	  })
	}
// 监听showRegister变化
import { watch } from 'vue'
watch(showRegister, (newVal) => {
  if (newVal) {
    handleRegisterDialogOpen()
  }
})
</script>

<style scoped>
	</style> 
