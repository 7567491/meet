# 快速部署 meet.linapp.fun

Akamai深圳办公室会议室预订系统已准备部署到 `meet.linapp.fun`

## 当前状态

✅ **已完成**：
- Gunicorn已安装并测试成功 (端口8000)
- Nginx配置文件已创建
- Systemd服务文件已创建  
- 管理脚本已创建
- 应用程序正常运行

## 🚀 快速部署命令

只需要执行以下命令完成部署：

```bash
# 1. 配置nginx (需要sudo权限)
sudo cp /home/meet/meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun
sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# 2. 安装systemd服务
sudo cp /home/meet/meet-app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable meet-app
sudo systemctl start meet-app

# 3. 检查状态
./manage.sh status
```

## 🔧 管理命令

使用 `./manage.sh` 脚本进行日常管理：

```bash
./manage.sh start          # 启动服务
./manage.sh stop           # 停止服务  
./manage.sh restart        # 重启服务
./manage.sh status         # 查看状态
./manage.sh logs           # 查看日志
./manage.sh nginx-reload   # 重载nginx配置
```

## 📁 重要文件路径

- **应用目录**: `/home/meet/meeting-room-booking/`
- **Nginx配置**: `/etc/nginx/sites-available/meet.linapp.fun`
- **Systemd服务**: `/etc/systemd/system/meet-app.service`
- **日志目录**: `/home/meet/meeting-room-booking/logs/`
- **管理脚本**: `/home/meet/manage.sh`

## 🌐 访问地址

部署完成后访问：**http://meet.linapp.fun**

## 🔍 故障排除

### 检查服务状态
```bash
sudo systemctl status meet-app
sudo systemctl status nginx
```

### 查看日志
```bash
# 应用日志
sudo journalctl -u meet-app -f

# Nginx日志
sudo tail -f /var/log/nginx/meet.linapp.fun.access.log
sudo tail -f /var/log/nginx/meet.linapp.fun.error.log
```

### 测试端口连通性
```bash
# 测试后端应用
curl http://127.0.0.1:8000/

# 测试API
curl http://127.0.0.1:8000/api/bookings/1
```

## 🔒 安全配置

已配置的安全特性：
- Nginx反向代理隐藏后端端口
- 安全响应头
- Gzip压缩优化
- 静态文件缓存
- 进程权限隔离

## 📊 性能配置

- **Workers**: 根据CPU核心数自动配置
- **连接超时**: 30秒
- **静态文件缓存**: 30天
- **Gzip压缩**: 自动启用

系统已完全准备就绪，执行上述命令即可完成部署！