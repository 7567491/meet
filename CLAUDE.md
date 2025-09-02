# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

请用中文和我对话

## 项目概述

此代码库包含Akamai深圳办公室会议室预订系统，一个基于Flask+SQLite的Web应用。系统已完成开发并可部署到生产环境。

## 开发和测试命令

### 启动开发服务器
```bash
cd meeting-room-booking
python3 run_app.py
```
访问 http://localhost:5000

### 运行测试
```bash
# 进入应用目录
cd meeting-room-booking

# 基础单元测试
python3 simple_test.py

# API功能测试
python3 test_api_simple.py

# 完整集成测试
python3 test_integration.py

# 健康监控测试
python3 test_health_monitor.py
```

### 安装依赖
```bash
pip3 install flask gunicorn requests
```

## 项目架构

### 核心文件结构
```
meeting-room-booking/
├── app.py                    # Flask主应用，包含所有路由和业务逻辑
├── run_app.py               # 开发服务器启动脚本
├── templates/index.html     # 单页面应用模板
├── static/css/style.css     # Akamai品牌样式
├── static/js/app.js         # 前端JavaScript逻辑
└── meeting_rooms.db         # SQLite数据库文件
```

### 技术栈
- **前端**: HTML5 + CSS3 + JavaScript (无框架)
- **后端**: Python Flask + RESTful API
- **数据库**: SQLite嵌入式数据库
- **架构**: 传统三层架构 (展示层 + 业务逻辑层 + 数据访问层)

### 数据模型
- **rooms**: 会议室信息 (id, name, capacity, description)
- **employees**: 员工信息 (id, name)
- **bookings**: 预订记录 (id, room_id, employee_name, start_time, end_time, agenda, created_at)

## 生产部署

### 快速部署到 meet.linapp.fun
```bash
# 配置nginx
sudo cp /home/meet/meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun
sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# 安装systemd服务
sudo cp /home/meet/meet-app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable meet-app
sudo systemctl start meet-app
```

### 服务管理
使用管理脚本 `/home/meet/manage.sh`:
```bash
./manage.sh start|stop|restart|status|logs|nginx-reload|health|monitor-start|monitor-install|deploy-full
```

### 监控和健康检查
```bash
# 快速健康检查
./manage.sh health

# 启动后台监控服务
./manage.sh monitor-start

# 安装监控服务到systemd
./manage.sh monitor-install

# 完整部署（应用+监控）
./manage.sh deploy-full
```

### 生产环境配置
- **Web服务器**: Nginx (反向代理)
- **应用服务器**: Gunicorn (配置文件: gunicorn.conf.py)
- **进程管理**: systemd服务
- **健康监控**: 自动检测和重启功能
- **日志路径**: `/home/meet/meeting-room-booking/logs/`

### 监控系统架构
- **health_monitor.py**: 核心监控模块，提供HTTP、数据库、进程检查
- **monitor_service.py**: 监控服务管理器，支持命令行操作
- **monitor_config.json**: 监控配置文件（检查间隔、告警设置等）
- **meet-monitor.service**: 监控systemd服务文件
- **自动重启**: 连续3次检查失败时自动重启应用

## API接口

### 主要端点
- `GET /` - 主页面
- `GET /api/bookings/{room_id}` - 获取会议室预订列表
- `POST /api/book` - 创建新预订
- `DELETE /api/cancel/{booking_id}` - 取消预订

### 业务规则
- **工作时间**: 周一至周五 9:00-18:00
- **预订时长**: 30分钟至4小时，30分钟递增
- **会议室**: 大会议室(5座)，小会议室(4座)
- **员工管理**: 21名预设员工，支持动态添加新员工
- **冲突检测**: 自动检测时间重叠，防止重复预订

## 品牌设计

**Akamai配色方案**:
- 主色调: 天蓝色渐变 (#87CEEB 至 #3498DB)
- 辅助色: 深海军蓝 (#2C3E50)
- 背景色: 白色 (#FFFFFF)

## 关键文件
- `employee.csv` - 21名员工名册，系统启动时自动导入
- `design.md` - 原始系统设计规范
- `deploy.sh` - 自动化部署脚本
- `quick-deploy.md` - 快速部署指南