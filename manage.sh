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
