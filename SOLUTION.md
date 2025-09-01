# 🎯 meet.linapp.fun 完整解决方案

## 当前状态诊断

✅ **Flask应用正常**: 运行在 127.0.0.1:8000  
✅ **域名解析正确**: meet.linapp.fun → 139.162.52.158  
❌ **nginx配置缺失**: meet.linapp.fun配置未生效  
❌ **看到Vite错误**: 可能被其他配置拦截

## 🚀 立即解决步骤

### 1. 创建nginx配置（需要sudo）

```bash
echo "server {
    listen 80;
    server_name meet.linapp.fun;
    
    # 静态文件
    location /static/ {
        alias /home/meet/meeting-room-booking/static/;
        expires 30d;
    }
    
    # 代理到Flask应用
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" | sudo tee /etc/nginx/sites-available/meet.linapp.fun
```

### 2. 启用配置

```bash
sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/
```

### 3. 测试并重载nginx

```bash
sudo nginx -t && sudo systemctl reload nginx
```

### 4. 验证结果

```bash
curl -I http://meet.linapp.fun/
```

## 🔍 如果仍有问题

### 检查nginx配置冲突

```bash
# 查看所有启用的站点
ls -la /etc/nginx/sites-enabled/

# 检查是否有其他站点拦截
sudo nginx -T | grep "server_name.*linapp.fun"
```

### 检查端口占用

```bash
ss -tlnp | grep :8000
ps aux | grep gunicorn
```

### 强制重启服务

```bash
# 重启nginx
sudo systemctl restart nginx

# 重启应用
pkill -f gunicorn
/home/meet/.local/bin/gunicorn --bind 127.0.0.1:8000 --workers 2 --daemon app:app
```

## 🎯 预期结果

执行完成后，访问 **http://meet.linapp.fun** 应该看到：

- **标题**: "Akamai深圳办公室会议室预订系统"
- **页面内容**: 两个会议室选择卡片
- **功能**: 完整的预订系统界面

## 📋 故障排除命令

```bash
# 检查Flask应用
curl http://127.0.0.1:8000/

# 检查nginx状态  
sudo systemctl status nginx

# 查看nginx错误日志
sudo tail -f /var/log/nginx/error.log

# 检查完整配置
sudo nginx -T | grep -A 20 "server_name meet.linapp.fun"
```

立即执行上述步骤，问题应该解决！