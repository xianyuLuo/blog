---
title: arp协议
tags: TCP/IP
abbrlink: b3d20160
date: 2016-11-21 23:48:12
categories: [网络]
---

#### 什么是ARP协议？
	协议都是电脑之间先约定好的一些规则而已！

#### ARP协议是干嘛的？
	将IP地址转换为MAC地址！

#### 为什么需要ARP协议？
<!-- more -->
	首先，我们的清楚，电脑之间进行的通信是依靠MAC地址来通信的。就说你必须知道对方主机的MAC地址（MAC地址才是唯一的），然后你才能给它发送信息，然后它的网卡收到信息过后才能进行处理。但是我们一般都不记MAC地址，退而求其次，我们记得是IP地址；再退一步我们就是记得 域名 了，比如说 www.google.com。
	域名---->IP地址---->MAC地址，域名到IP地址我们是通过DNS来完成的（不明白DNS的可以参考
[xianyuLuo的这篇文章](http://laoxianyu.cn/2016/11/20/DNS%E8%A7%A3%E6%9E%90/ "xianyuLuo_DNS解析")。而从IP地址到MAC地址，我们用的就是arp。

__ARP协议的工作过程__

当主机要发送一个IP包的时候，会首先查一下自己的ARP高速缓存（就是一个IP-MAC地址对应表缓存），如果查询的IP－MAC值对不存在，那么主机就向网络发送一个ARP协议广播包，这个广播包里面就有待查询的IP地址，而直接收到这份广播的包的所有主机都会查询自己的IP地址，如果收到广播包的某一个主机发现自己符合条件，那么就准备好一个包含自己的MAC地址的ARP包传送给发送ARP广播的主机，而广播主机拿到ARP包后会更新自己的ARP缓存（就是存放IP-MAC对应表的地方）。发送广播的主机就会用新的ARP缓存数据准备好数据链路层的的数据包发送工作。

__arp缓存表例子__

windows下执行"arp -a"命令：
![arp-a_windows](http://dl-blog.laoxianyu.cn/arp-a_windows.png)

linux下执行"arp -a"命令：
![arp-a_linux](http://dl-blog.laoxianyu.cn/arp-a_linux.png)


<font color=#ff1201>技术交流可加QQ群：**774332965**<br></font>

<font color=#ff1201>微信订阅号同步：**IT运维那点儿事**</font>

![weixin](http://dl-blog.laoxianyu.cn/weixindy.jpg)
