# 直聘App - Flutter 前端

类似Boss直聘的求职招聘平台，Flutter 跨平台移动端。

## 启动

```bash
cd frontend
flutter pub get
flutter run
```

## 鸿蒙运行

需使用 Flutter-ohos SDK:
```bash
flutter config --enable-ohos
flutter create --platforms ohos .
flutter run -d ohos
```

## 项目结构

```
lib/
├── main.dart                    # 入口 + AppShell(底部导航)
├── config/
│   ├── api_config.dart          # API地址配置
│   └── theme.dart               # 主题色/样式
├── models/
│   ├── user.dart                # 用户模型
│   ├── job.dart                 # 职位模型
│   ├── education.dart           # 教育经历
│   └── work_experience.dart     # 工作经历
├── services/
│   └── api_service.dart         # Dio封装 + JWT拦截器
├── providers/
│   ├── auth_provider.dart       # 认证状态管理
│   ├── job_provider.dart        # 职位状态管理
│   ├── resume_provider.dart     # 简历状态管理
│   ├── favorite_provider.dart   # 收藏状态管理
│   └── application_provider.dart # 投递状态管理
├── screens/
│   ├── login_screen.dart        # 登录/注册
│   ├── home_screen.dart         # 首页职位列表
│   ├── search_screen.dart       # 搜索筛选
│   ├── job_detail_screen.dart   # 职位详情
│   ├── favorite_screen.dart     # 我的收藏
│   ├── application_screen.dart  # 投递记录
│   ├── profile_screen.dart      # 个人资料
│   └── resume_edit_screen.dart  # 简历编辑
└── widgets/
    └── job_card.dart            # 职位卡片组件
```
