---
title: SRE附录F~生产环境会议记录示范
tags:
  - sre
abbrlink: 1566daae
date: 2019-03-10 12:09:02
categories:
---
### 日期
2015-10-23

### 参与者
agoogler、clarac、docbrown、jennifer和martym

### 公告
+ 大型事故（#465），造成错误预算耗尽

### 之前的待办事项评审
+ 确保山羊传送器可以用于传送牛奶

  ——质子加速中的非线性特质可以预知了，应该可以在几天内解决准确性问题

### 事故回顾
+ 新韵文的发现（事故465）

  —— 12.1亿个请求在连锁故障与潜伏先bug的共同作用下丢失，索引中不存在新的韵文和未预料的流量

  —— 文件描述符的bug以修复，已经部署到生产环境

  —— 调研使用flux
capacitor进行负载均衡，利用负责抛弃来预防再发生

  —— 错误预算已经耗尽，生产环境的更新将会停止一个月。除非docbrown能够以该极为罕见、不可预知为理由获得管理层批准

+ AnnotataionConsistencyTooEventual：本周告警5次，可能是由于bigtabale跨区域的复制延迟导致

  —— 调查仍在进行，见bug 4898200

  —— 最近不会有修复，会提高阈值以减少无效告警的次数

### 非紧急告警回顾
+ 没有

### 监控系统修改/静音
+ AnnotataionConsistencyTooEventual，可以接受的延迟阈值从60s提高到180s

### 资源
+ 处于新韵文事故时借用了一些资源，会在下周下线多余的容量以退还容量
+ 目前的利用率是 CPU 60%、RAM 75%、DISK 44%

### 关键服务指标
+ OK 99 百分比延迟：88ms < 100ms SLO目标（过去30天）
+ BAD 可用性：86.95% < 99.99 SLO目标 （过去30天）

### 讨论/项目更新
+ 项目Molere下两周发布

### 新的代办事项
+ TODO （martym）：提高AnnotataionConsistencyTooEventual的阈值
+ TODO（docbrown）：将实例数量复原，退还资源

