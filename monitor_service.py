#!/usr/bin/env python3
"""
会议室预订系统监控服务启动脚本
提供后台监控和Web仪表板
"""

import sys
import os
import argparse
import signal
import time
from pathlib import Path

# 添加应用目录到Python路径
app_dir = Path(__file__).parent / "meeting-room-booking"
sys.path.insert(0, str(app_dir))

from health_monitor import HealthMonitor, HealthStatus

class MonitorService:
    """监控服务管理器"""
    
    def __init__(self):
        self.monitor = None
        self.running = False
        
    def start_monitor(self):
        """启动监控"""
        print("启动会议室预订系统健康监控...")
        
        try:
            # 切换到应用目录
            os.chdir(str(app_dir))
            
            # 创建监控器实例
            self.monitor = HealthMonitor()
            self.running = True
            
            # 注册信号处理器
            signal.signal(signal.SIGTERM, self._signal_handler)
            signal.signal(signal.SIGINT, self._signal_handler)
            
            # 运行监控循环
            self.monitor.monitor_loop()
            
        except Exception as e:
            print(f"监控启动失败: {e}")
            sys.exit(1)
    
    def _signal_handler(self, signum, frame):
        """信号处理器"""
        print(f"\n接收到信号 {signum}，正在停止监控...")
        self.running = False
        sys.exit(0)
    
    def status(self):
        """检查监控状态"""
        try:
            os.chdir(str(app_dir))
            monitor = HealthMonitor()
            
            print("执行健康检查...")
            results = monitor.run_full_health_check()
            overall_status = monitor.get_overall_status(results)
            
            print(f"\n整体状态: {overall_status.value}")
            print("-" * 50)
            
            for check_name, result in results.items():
                status_symbol = {
                    HealthStatus.HEALTHY: "✅",
                    HealthStatus.WARNING: "⚠️",
                    HealthStatus.CRITICAL: "❌",
                    HealthStatus.UNKNOWN: "❓"
                }.get(result.status, "❓")
                
                print(f"{status_symbol} {check_name}: {result.message}")
                if result.response_time:
                    print(f"   响应时间: {result.response_time:.2f}s")
                
        except Exception as e:
            print(f"状态检查失败: {e}")
            sys.exit(1)
    
    def test(self):
        """运行监控模块测试"""
        print("运行健康监控模块测试...")
        
        try:
            os.chdir(str(app_dir))
            os.system("python3 test_health_monitor.py")
        except Exception as e:
            print(f"测试失败: {e}")
            sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="会议室预订系统监控服务")
    parser.add_argument('command', 
                       choices=['start', 'status', 'test'],
                       help='监控命令')
    
    args = parser.parse_args()
    service = MonitorService()
    
    if args.command == 'start':
        service.start_monitor()
    elif args.command == 'status':
        service.status()
    elif args.command == 'test':
        service.test()


if __name__ == "__main__":
    main()