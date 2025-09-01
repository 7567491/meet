#!/bin/bash

echo "=== nginx配置测试命令 ==="
echo ""
echo "注意：meet.linapp.fun配置还没有生效，请执行以下命令："
echo ""

echo "1. 检查当前nginx状态："
echo "ls -la /etc/nginx/sites-enabled/"
echo ""

echo "2. 临时测试（手动执行）："
echo 'echo "server {
    listen 80;
    server_name meet.linapp.fun;
    
    location /static/ {
        alias /home/meet/meeting-room-booking/static/;
    }
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}" | sudo tee /etc/nginx/sites-available/meet.linapp.fun'
echo ""

echo "3. 启用配置："
echo "sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/"
echo ""

echo "4. 测试并重载："
echo "sudo nginx -t && sudo systemctl reload nginx"
echo ""

echo "5. 验证："
echo "curl -I http://meet.linapp.fun/"
echo ""

echo "当前应用状态："
echo "✅ Flask应用已在 127.0.0.1:8000 运行"
curl -s http://127.0.0.1:8000/ | grep -o '<title>.*</title>'