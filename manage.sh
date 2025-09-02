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
    health)
        echo "健康检查:"
        python3 monitor_service.py status
        ;;
    monitor-start)
        echo "启动监控服务:"
        python3 monitor_service.py start &
        echo "监控服务已在后台启动"
        ;;
    monitor-install)
        echo "安装监控服务到systemd:"
        sudo cp meet-monitor.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable meet-monitor
        echo "监控服务已安装，使用 'sudo systemctl start meet-monitor' 启动"
        ;;
    deploy-full)
        echo "完整部署（应用 + 监控）:"
        echo "1. 部署应用服务..."
        sudo cp meet-app.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable meet-app
        sudo systemctl start meet-app
        
        echo "2. 配置Nginx..."
        sudo cp meet.linapp.fun.conf /etc/nginx/sites-available/meet.linapp.fun
        sudo ln -sf /etc/nginx/sites-available/meet.linapp.fun /etc/nginx/sites-enabled/
        sudo nginx -t && sudo systemctl reload nginx
        
        echo "3. 安装监控服务..."
        sudo cp meet-monitor.service /etc/systemd/system/
        sudo systemctl daemon-reload  
        sudo systemctl enable meet-monitor
        sudo systemctl start meet-monitor
        
        echo "部署完成！运行 '$0 health' 检查状态"
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|logs|nginx-reload|health|monitor-start|monitor-install|deploy-full}"
        exit 1
        ;;
esac
