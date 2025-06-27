import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Layout from '../views/Layout.vue'
import Dashboard from '../views/Dashboard.vue'
import UserManage from '../views/UserManage.vue'
import NewsManage from '../views/NewsManage.vue'
import CourseManage from '../views/CourseManage.vue'
import MeetingManage from '../views/MeetingManage.vue'
import TenantManage from '../views/TenantManage.vue'
import Profile from '../views/Profile.vue'
import NotFound from '../views/NotFound.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard,
        meta: { title: '首页' }
      },
      {
        path: 'users',
        name: 'UserManage',
        component: UserManage,
        meta: { title: '用户管理', requiresAdmin: true }
      },
      {
        path: 'news',
        name: 'NewsManage',
        component: NewsManage,
        meta: { title: '动态管理' }
      },
      {
        path: 'courses',
        name: 'CourseManage',
        component: CourseManage,
        meta: { title: '课程管理' }
      },
      {
        path: 'meetings',
        name: 'MeetingManage',
        component: MeetingManage,
        meta: { title: '会议管理' }
      },
      {
        path: 'tenants',
        name: 'TenantManage',
        component: TenantManage,
        meta: { title: '租户管理', requiresAdmin: true }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: Profile,
        meta: { title: '个人中心' }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const user = localStorage.getItem('user')
  if (to.path !== '/login' && !user) {
    next('/login')
  } else if (to.path === '/login' && user) {
    next('/')
  } else {
    next()
  }
})

export default router 