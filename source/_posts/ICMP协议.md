---
title: ICMP
tags: TCP/IP
abbrlink: 9b389b8e
date: 2016-11-23 22:42:02
categories: [网络]
---

#### 什么是ICMP？
	ICMP是（Internet Control Message Protocol）Internet控制报文协议。

#### ICMP协议有什么用？
	它是TCP/IP协议族的一个子协议，用于在IP主机、路由器之间传递控制消息。控制消息是指网络通不通、主机是否可达、路由是否可用、端口是否可达等网络本身的消息。
<!-- more -->
	这些控制消息虽然并不传输用户数据，但是对于用户数据的传递起着重要的作用。也就是说每次在传输IP数据包之前，都会利用ICMP去检测一番，然后再决定是否传输IP数据包。

#### ICMP协议类型
![icmp](http://dl-blog.laoxianyu.cn/icmp_2.png)
其中有 0：回显应答 
       8：回显请求
Ping命令就是利用这两种类型的ICMP数据包。
一台主机向一个节点发送一个Type=8的ICMP报文，如果途中没有异常（例如被路由器丢弃、目标不回应ICMP或传输失败），则目标返回Type=0的ICMP报文，说明这台主机存在，更详细的traceroute通过计算ICMP报文通过的节点来确定主机与目标之间的网络距离。
（在上一篇中说道Tracroute利用了TTL，同时traceroute也利用了ICMP）


<font color=#ff1201>技术交流可加QQ群：774332965</font>
