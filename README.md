# 测盟汇系统

测盟汇系统是一个基于SpringBoot + Vue3 + MySQL + MyBatis Plus的企业级管理系统，包含Web管理端和小程序端。

## 技术栈

### 后端
- SpringBoot 2.7.14
- MySQL 8.0
- MyBatis Plus 3.5.3.1
- Maven 3.6+
- JDK 8+

### 前端
- Vue 3.3.4
- Element Plus 2.3.8
- Vue Router 4.2.4
- Axios 1.4.0
- Pinia 2.1.6

## 项目结构

```
测盟汇系统/
├── backend/                 # SpringBoot后端
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/cemenghui/
│   │       │       ├── CemenghuiApplication.java    # 主启动类
│   │       │       ├── common/                      # 通用类
│   │       │       ├── config/                      # 配置类
│   │       │       ├── controller/                  # 控制器
│   │       │       ├── entity/                      # 实体类
│   │       │       ├── mapper/                      # Mapper接口
│   │       │       └── service/                     # 服务层
│   │       └── resources/
│   │           ├── application.yml                  # 配置文件
│   │           └── static/uploads/                  # 文件上传目录
│   └── pom.xml                                      # Maven依赖
├── frontend/                # Vue3前端
│   ├── public/
│   ├── src/
│   │   ├── components/      # 组件
│   │   ├── router/          # 路由
│   │   ├── utils/           # 工具类
│   │   └── views/           # 页面
│   └── package.json         # 前端依赖
├── database/                # 数据库文件
│   └── cemenghui.sql        # 数据库脚本
└── README.md               # 项目说明
```

## 功能模块

### Web端管理系统
1. **用户管理** - 用户增删改查、权限管理
2. **动态管理** - 行业动态发布、审核、管理
3. **课程管理** - 课程发布、编辑、审核
4. **会议管理** - 会议创建、编辑、分类管理
5. **租户管理** - 企业租户信息管理
6. **个人中心** - 个人信息修改、密码修改

### 权限说明
- **超级管理员**: 拥有所有功能权限，可以管理用户、审核内容
- **企业用户**: 可以发布动态/课程/会议（需审核），管理个人信息


## API接口说明




### 用户相关
- `POST /api/user/login` - 用户登录
- `POST /api/user/register` - 用户注册
- `GET /api/user/current` - 获取当前用户信息
- `PUT /api/user/profile` - 更新个人信息
- `POST /api/user/changePassword` - 修改密码

### 动态管理
- `GET /api/news/page` - 分页查询动态
- `POST /api/news` - 发布动态
- `PUT /api/news/{id}` - 更新动态
- `DELETE /api/news/{id}` - 删除动态
- `POST /api/news/{id}/audit` - 审核动态

### 课程管理
- `GET /api/course/page` - 分页查询课程
- `POST /api/course` - 添加课程
- `PUT /api/course/{id}` - 更新课程
- `DELETE /api/course/{id}` - 删除课程

### 会议管理
- `GET /api/meeting/page` - 分页查询会议
- `POST /api/meeting` - 创建会议
- `PUT /api/meeting/{id}` - 更新会议
- `DELETE /api/meeting/{id}` - 删除会议

### 文件上传
- `POST /api/file/upload` - 单文件上传
- `POST /api/file/uploads` - 多文件上传









# 测盟汇系统部署指南

## 🚀 快速开始

### 环境要求

**开发环境:**
- JDK 8+
- Maven 3.6+
- Node.js 16+
- MySQL 8.0+

**生产环境:**
- Linux/Windows Server
- Nginx (可选)
- MySQL 8.0+

### 一键启动（开发环境）

**Windows:**
```bash
# 双击运行
start.bat
```

**Linux/Mac:**
```bash
# 添加执行权限
chmod +x start.sh
# 运行脚本
./start.sh
```

## 📋 手动部署步骤

### 1. 数据库配置

```sql
-- 创建数据库
CREATE DATABASE cemenghui DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 导入数据
mysql -u root -p cemenghui < database/cemenghui.sql
```

### 2. 后端部署

```bash
cd backend

# 修改配置文件
# 编辑 src/main/resources/application.yml
# 修改数据库连接信息

# 开发环境启动
mvn spring-boot:run

# 生产环境打包
mvn clean package
java -jar target/cemenghui-backend-1.0.0.jar
```

**配置文件示例 (application.yml):**
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/cemenghui?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
    username: root
    password: 你的数据库密码
```

### 3. 前端部署

```bash
cd frontend

# 安装依赖
npm install

# 开发环境启动
npm run serve

# 生产环境打包
npm run build
```

**生产环境Nginx配置:**
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # 前端静态文件
    location / {
        root /path/to/frontend/dist;
        try_files $uri $uri/ /index.html;
    }
    
    # API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. 小程序部署

```bash
cd uniapp

# 使用HBuilderX打开项目
# 或使用uni-app CLI
npm install -g @vue/cli @dcloudio/uvm
uvm use --alpha
npm install

# 编译到微信小程序
npm run dev:mp-weixin
```

## 🔧 系统配置

### 默认账号

- **超级管理员**: admin / 123456
- **企业用户**: company1 / 123456

### 端口配置

- **后端服务**: http://localhost:8080
- **前端服务**: http://localhost:8081
- **数据库**: 3306

### 文件上传

文件默认存储在 `backend/src/main/resources/static/uploads/` 目录下。

生产环境建议：
1. 修改为绝对路径
2. 使用云存储服务
3. 配置CDN加速

## 📊 功能模块

### Web管理端

1. **用户管理** - 用户增删改查、权限控制
2. **动态管理** - 行业动态发布、审核
3. **课程管理** - 课程发布、编辑、审核
4. **会议管理** - 会议创建、编辑、分类
5. **租户管理** - 企业租户信息管理
6. **个人中心** - 个人信息、密码修改

### 小程序端

1. **首页** - 轮播图、导航、最新动态
2. **动态模块** - 浏览行业动态
3. **技术模块** - 课程学习
4. **合作模块** - 会议信息、参会回执
5. **用户中心** - 登录、个人信息

## 🔐 权限说明

### 角色权限

**超级管理员 (ADMIN):**
- 所有功能权限
- 用户管理
- 内容审核
- 租户管理

**企业用户 (USER):**
- 发布内容（需审核）
- 管理个人内容
- 参会回执

### 审核机制

- 企业用户发布的动态、课程、会议需要管理员审核
- 管理员发布的内容直接通过
- 审核状态：0-待审核，1-已发布，2-已拒绝

## 🛠️ 开发说明

### 技术架构

**后端技术栈:**
- SpringBoot 2.7.14
- MyBatis Plus 3.5.3.1
- MySQL 8.0
- BCrypt密码加密
- Session会话管理

**前端技术栈:**
- Vue 3.3.4
- Element Plus 2.3.8
- Vue Router 4.2.4
- Axios 1.4.0

**小程序技术栈:**
- UniApp
- Vue 3

### 项目结构

```
测盟汇系统/
├── backend/                 # SpringBoot后端
│   ├── src/main/java/
│   │   └── com/cemenghui/
│   │       ├── controller/  # 控制器
│   │       ├── service/     # 服务层
│   │       ├── mapper/      # 数据访问层
│   │       ├── entity/      # 实体类
│   │       ├── common/      # 通用类
│   │       └── config/      # 配置类
│   └── src/main/resources/
│       ├── application.yml  # 配置文件
│       └── static/uploads/  # 文件上传目录
├── frontend/                # Vue3前端
│   ├── src/
│   │   ├── views/          # 页面组件
│   │   ├── router/         # 路由配置
│   │   └── utils/          # 工具类
│   └── package.json
├── uniapp/                  # UniApp小程序
│   ├── pages/              # 页面
│   ├── static/             # 静态资源
│   ├── pages.json          # 页面配置
│   └── manifest.json       # 应用配置
├── database/               # 数据库文件
│   └── cemenghui.sql       # 数据库脚本
├── start.bat               # Windows启动脚本
├── start.sh                # Linux/Mac启动脚本
└── README.md               # 项目说明
```

### API接口

**用户接口:**
- POST /api/user/login - 用户登录
- POST /api/user/register - 用户注册
- GET /api/user/current - 获取当前用户
- GET /api/user/page - 分页查询用户

**动态接口:**
- GET /api/news/page - 分页查询动态
- POST /api/news - 发布动态
- PUT /api/news/{id} - 更新动态
- DELETE /api/news/{id} - 删除动态
- POST /api/news/{id}/audit - 审核动态

**课程接口:**
- GET /api/course/page - 分页查询课程
- POST /api/course - 添加课程
- PUT /api/course/{id} - 更新课程
- DELETE /api/course/{id} - 删除课程

**会议接口:**
- GET /api/meeting/page - 分页查询会议
- POST /api/meeting - 创建会议
- PUT /api/meeting/{id} - 更新会议
- DELETE /api/meeting/{id} - 删除会议

**文件接口:**
- POST /api/file/upload - 文件上传

## 🐛 常见问题

### 1. 数据库连接失败
- 检查MySQL服务是否启动
- 确认数据库用户名密码正确
- 检查数据库是否已创建

### 2. 前端跨域问题
- 后端已配置CORS
- 确认请求地址正确
- 检查withCredentials设置

### 3. 文件上传失败
- 检查上传目录权限
- 确认文件大小限制
- 检查磁盘空间

### 4. 小程序无法访问接口
- 确认后端服务已启动
- 检查小程序域名配置
- 确认网络连接正常

## 📞 技术支持

如有问题，请联系开发团队或提交Issue。

---

测盟汇系统 v1.0.0 
