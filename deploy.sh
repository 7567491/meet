#!/bin/bash

echo "=== Akamai会议室预订系统部署脚本 ==="
echo "部署到 meet.linapp.fun"
echo ""

# 检查必要工具
echo "1. 检查依赖..."
if ! command -v nginx &> /dev/null; then
    echo "❌ nginx未安装"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ python3未安装"
    exit 1
fi

echo "✅ 依赖检查完成"

# 安装Python依赖
echo "2. 安装Python依赖..."
pip3 install flask gunicorn
echo "✅ Python依赖安装完成"

# 配置nginx
echo "3. 配置nginx..."
echo "请手动执行以下命令（需要sudo权限）："
echo ""
echo "sudo cp /home/meet/meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun"
echo "sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/"
echo "sudo nginx -t"
echo "sudo systemctl reload nginx"
echo ""

# 创建Gunicorn配置
echo "4. 创建Gunicorn配置..."
cat > /home/meet/meeting-room-booking/gunicorn.conf.py << 'EOF'
# Gunicorn配置文件
import multiprocessing

# 服务器配置
bind = "127.0.0.1:8000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 50
preload_app = True
timeout = 30
keepalive = 2

# 进程名称
proc_name = "akamai-meeting-room"

# 日志配置
accesslog = "/home/meet/meeting-room-booking/logs/access.log"
errorlog = "/home/meet/meeting-room-booking/logs/error.log"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# 安全
user = "meet"
group = "meet"
tmp_upload_dir = None

# 性能
worker_tmp_dir = "/dev/shm"
EOF

# 创建日志目录
mkdir -p /home/meet/meeting-room-booking/logs

echo "✅ Gunicorn配置完成"

# 创建systemd服务
echo "5. 创建systemd服务..."
cat > /home/meet/meet-app.service << 'EOF'
[Unit]
Description=Akamai Meeting Room Booking System
After=network.target

[Service]
Type=exec
User=meet
Group=meet
WorkingDirectory=/home/meet/meeting-room-booking
ExecStart=/usr/local/bin/gunicorn -c gunicorn.conf.py app:app
ExecReload=/bin/kill -s HUP $MAINPID
Restart=always
RestartSec=5
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true

# 环境变量
Environment=FLASK_ENV=production
Environment=PYTHONPATH=/home/meet/meeting-room-booking

[Install]
WantedBy=multi-user.target
EOF

echo "请手动执行以下命令来安装systemd服务："
echo ""
echo "sudo cp /home/meet/meet-app.service /etc/systemd/system/"
echo "sudo systemctl daemon-reload"
echo "sudo systemctl enable meet-app"
echo "sudo systemctl start meet-app"
echo ""

# 创建管理脚本
echo "6. 创建管理脚本..."
cat > /home/meet/manage.sh << 'EOF'
#!/bin/bash

case "$1" in
    start)
        echo "启动服务..."
        sudo systemctl start meet-app
        ;;
    stop)
        echo "停止服务..."
        sudo systemctl stop meet-app
        ;;
    restart)
        echo "重启服务..."
        sudo systemctl restart meet-app
        ;;
    status)
        echo "服务状态:"
        sudo systemctl status meet-app
        ;;
    logs)
        echo "查看日志:"
        sudo journalctl -u meet-app -f
        ;;
    nginx-reload)
        echo "重载nginx配置:"
        sudo nginx -t && sudo systemctl reload nginx
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|logs|nginx-reload}"
        exit 1
        ;;
esac
EOF

chmod +x /home/meet/manage.sh

echo "✅ 管理脚本创建完成"

echo ""
echo "=== 部署准备完成！==="
echo ""
echo "请按顺序执行以下命令完成部署："
echo ""
echo "1. 配置nginx:"
echo "   sudo cp /home/meet/meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun"
echo "   sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/"
echo "   sudo nginx -t"
echo "   sudo systemctl reload nginx"
echo ""
echo "2. 安装并启动服务:"
echo "   sudo cp /home/meet/meet-app.service /etc/systemd/system/"
echo "   sudo systemctl daemon-reload"
echo "   sudo systemctl enable meet-app"
echo "   sudo systemctl start meet-app"
echo ""
echo "3. 检查状态:"
echo "   ./manage.sh status"
echo ""
echo "4. 访问网站:"
echo "   http://meet.linapp.fun"
echo ""
echo "管理命令:"
echo "   ./manage.sh {start|stop|restart|status|logs|nginx-reload}"
echo ""
EOF