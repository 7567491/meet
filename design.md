# Akamai深圳办公室会议室预订系统设计

## 系统概述

本系统为Akamai深圳办公室21名员工提供会议室预订服务，采用HTML+Python+SQLite极简架构，支持Web访问和桌面直达。系统管理大会议室（5座位）和小会议室（4座位）两个资源，预订时间限制在工作日9:00-18:00，预订时长以半小时为单位，最短半小时，最长4小时。

## 技术架构

系统采用三层架构设计。前端使用响应式HTML5和CSS3实现，采用Akamai品牌配色：主色调为天蓝色渐变（#87CEEB至#3498DB），辅助色为深海军蓝（#2C3E50），背景使用纯白色（#FFFFFF），确保移动端和桌面端的一致体验。后端使用Python Flask轻量级框架，提供RESTful API接口处理预订逻辑和时间冲突检测。数据层采用SQLite嵌入式数据库，存储用户信息、会议室配置、预订记录和时间段状态。

## 核心功能模块

• **员工选择模块**：提供21名员工的下拉菜单选择，同时支持手动输入新员工姓名并自动添加到系统中，无需登录认证
• **会议室展示模块**：实时显示两个会议室当前周和未来两周的预订状态，使用日历视图
• **预订管理模块**：处理新预订请求，自动检测时间冲突，支持半小时至4小时的时间段选择
• **预订查询模块**：按员工姓名查询、修改、取消预订记录

## 数据模型

设计三个核心表：users（用户基础信息）、rooms（会议室配置信息）、bookings（预订记录，包含时间段、用户ID、会议室ID、议程等字段）。通过时间索引优化查询性能，确保并发预订时的数据一致性。

## 员工清单

系统预置21名员工信息（employee.csv）：Cheng Chen, Xin Ting Chen, Patrick Deng, Zhiwen Hu, Manyi Huang, Hyson Li, Linc Li, Ji Jun Liao, Martin Ma, Gary Peng, Peter Peng, James Qian, Jianwei Tang, Zhijun Wu, Zhizhen Xiao, Jintang Yuan, Bing Jie Zhao, Colin Zheng, Jack Zhang, Leo Liu, Mandison Li。预订时可从下拉菜单选择现有员工，或手动输入新员工姓名。

系统部署简单，只需Python环境和SQLite支持，可快速在办公网络环境中启动服务。