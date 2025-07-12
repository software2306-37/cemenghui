# 测盟汇系统

测盟汇系统是一个基于SpringBoot + Vue3 + MySQL + MyBatis Plus的企业级管理系统，包含Web管理端和小程序端。

**github代码：main包含了项目整合后的整体结构，详细的的commit记录在其他分支当中**

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

	项目使用金仓数据库，源代码使用cemenghui_now.sql

	 环境准备
		安装金仓数据库：按照金仓数据库的官方文档，在服务器上完成数据库的安装和配置。
		创建数据库实例：根据项目需求，创建相应的数据库实例，并进行必要的参数调整。
		
	 数据迁移
		数据结构迁移：手动将 MySQL数据库中的表结构、索引、视图等对象在金仓数据库中重新创建。在迁移过程中，需要注意金仓数据库与 MySQL在数据类型、语法等方面的差异。
		数据导入：使用金仓数据库提供的数据导入工具KingbaseDTS，将MySQL数据库中的数据导出为SQL文件，然后导入到金仓数据库中。


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

## 5. AI部署

	#确保设备有ollama、docker、docker compose环境
	
	#部署Dify：下载源码[](https://github.com/langgenius/dify)
	#进入路径：dify-main\dify-main\docker，打开cmd，运行 docker -compose
	
	本地部署大模型：
		bash< ollama run deepseek-r1:8b
	访问dify：localhost:/80/install
	
	创建智能体，使用ollama，deepseek-r1:8b
	
	输入提示词：“
		请根据以下规则对输入内容中的动态进行违禁词检测：
		1. 输入的规范是严格的，有以下形式：
		{动态1：”动态内容1“，动态2：”动态内容2“，动态3：”动态内容3“......}
		识别并提取输入内容中的每一个动态条目，其格式为“动态n:”开头的内容段落。
		2. 对于每个动态条目，请检查其内容是否包含任何违禁词汇的含义。如果发现任何与违禁词相关或相近的含义，则将该动态标记为 'x'；否则，将其标记为 'v'。（请注意：Result只能是”v“或”x“，不能是任何其他内容！如果你不确定，请标记为‘v’）
		3. 输出结果必须严格按照指定格式：动态1:Result1,Reason1; 动态2:Result2,Reason2; 
		4.请将理由精简到10个字以内，如果判定为通过则不需要任何理由，理由直接为”无“
		5. 严格确保输出中不包含任何 XML 标签或其他无关信息，输出格式的分隔符必须严格按照规范（动态1:Result,Reason; 动态2:Result,Reason; ）
		6.注意！注意！注意！千万不要有任何其他符号（包括换行符）！
		输入示例：
		{动态1:"这是测试内容", 动态2:"这个内容包含敏感词汇"}
		输出示例（基于上述规则）：
		动态1:v,无; 动态2:x,理由; 
	”
	
	点击发布-发布大模型
	点击发布-访问api：复制API-key，并粘贴到后端application.yml的dify配置下的“api-key：”后面


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
