# 🚨 紧急修复 meet.linapp.fun 访问问题

## 问题诊断
浏览器看到nginx默认页面，说明：
1. nginx配置文件还没有复制到正确位置
2. nginx默认站点拦截了所有请求

## ⚡ 立即修复步骤

### 1. 手动执行配置命令 (需要sudo权限)

```bash
# 复制nginx配置
sudo cp /home/meet/meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun

# 启用站点配置
sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/

# 禁用默认站点（重要！）
sudo rm /etc/nginx/sites-enabled/default

# 测试配置
sudo nginx -t

# 重载nginx
sudo systemctl reload nginx
```

### 2. 启动应用服务

```bash
# 启动Gunicorn后端
sudo cp /home/meet/meet-app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable meet-app
sudo systemctl start meet-app

# 检查服务状态
sudo systemctl status meet-app
```

### 3. 验证修复

```bash
# 检查后端应用
curl http://127.0.0.1:8000/

# 检查完整流程
curl http://meet.linapp.fun/
```

## 🔍 故障排除

如果仍有问题，检查以下内容：

### DNS检查
```bash
nslookup meet.linapp.fun
```

### Nginx配置检查
```bash
sudo nginx -t
sudo systemctl status nginx
```

### 端口检查
```bash
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :8000
```

### 日志检查
```bash
sudo tail -f /var/log/nginx/error.log
sudo journalctl -u meet-app -f
```

## 📋 关键文件位置

- **配置源文件**: `/home/meet/meet.linapp.fun.conf`
- **nginx配置**: `/etc/nginx/sites-available/meet.linapp.fun`
- **服务配置**: `/home/meet/meet-app.service`

## 🎯 预期结果

修复完成后访问 **http://meet.linapp.fun** 应该看到：
- Akamai品牌的会议室预订系统界面
- 两个会议室选择卡片
- 完整的预订功能

执行上述步骤后问题应该立即解决！