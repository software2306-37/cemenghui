import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login,
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {})

export default router 