#!/bin/bash

echo "=== 配置防火墙允许端口12080访问 ==="
echo ""

echo "请使用root权限执行以下命令："
echo ""

echo "# 检查防火墙状态"
echo "ufw status"
echo ""

echo "# 允许12080端口"
echo "ufw allow 12080/tcp"
echo ""

echo "# 如果防火墙未启用，可选择启用"
echo "# ufw enable"
echo ""

echo "# 重载防火墙规则"
echo "ufw reload"
echo ""

echo "# 验证规则生效"
echo "ufw status numbered"
echo ""

echo "=== iptables方式（如果不使用ufw） ==="
echo "iptables -A INPUT -p tcp --dport 12080 -j ACCEPT"
echo "iptables-save > /etc/iptables/rules.v4"
echo ""

echo "=== 当前应用状态 ==="
echo "✅ Flask应用运行在端口12080"
echo "✅ 本地测试正常"
echo "📝 需要配置防火墙允许外部访问"
echo ""

echo "配置完成后可以通过以下地址访问："
echo "http://139.162.52.158:12080"
echo "或"  
echo "http://meet.linapp.fun:12080"