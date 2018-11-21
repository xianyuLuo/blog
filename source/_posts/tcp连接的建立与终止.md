---
title: tcp连接的建立与终止
tags: TCP/IP
abbrlink: 684012cf
date: 2017-11-29 19:25:14
categories: [网络]
---

## TCP三次握手
	TCP三次握手；简单来说就是通信的双方建立可靠的连接之前必须要做的事情，就是在通信之前要做的事情。而我们常见的双方就是指的 客户端 ---- 服务器。

**建立连接过程**
![tcp_lianjie](http://dl-blog.laoxianyu.cn/tcp%E8%BF%9E%E6%8E%A5.png)
    首先client端发送连接请求报文，server段接受连接后回复ack报文，并为这次连接分配资源。client端接收到ack报文后也向server段发生ack报文，并分配资源，这样tcp连接就建立了。
<!-- more -->
建立连接过后干嘛呢？那就是该干嘛干嘛呀，就可以传输数据了。

## TCP四次挥手
	TCP四次挥手：由于TCP协议的可靠性，所以它再结束通信之前也会有一个流程来确认数据已经传输完成，在网络线路当中没有残留的数据包。

**断开连接过程**
![tcp_duankai](http://dl-blog.laoxianyu.cn/tcp%E6%8C%A5%E6%89%8B.png)
    中断连接端可以是Client端，也可以是Server端。假设Client端发起中断连接请求，也就是发送FIN报文。Server端接到FIN报文后，意思是说"我Client端没有数据要发给你了"（此时的Client是处于FIN_WAIT状态），但是如果你还有数据没有发送完成，则不必急着关闭Socket，可以继续发送数据。所以你先发送ACK，"告诉Client端，你的请求我收到了，但是我还没准备好，请继续你等我的消息"。这个时候Client端就进入FIN_WAIT状态，继续等待Server端的FIN报文。当Server端确定数据已发送完成，则向Client端发送FIN报文，"告诉Client端，好了，我这边数据发完了，准备好关闭连接了"。Client端收到FIN报文后，"就知道可以关闭连接了，但是他还是不相信网络，怕Server端不知道要关闭，所以发送ACK后进入TIME_WAIT状态，如果Server端没有收到ACK则可以重传。“，Server端收到ACK后，"就知道可以断开连接了"。Client端等待了2MSL后依然没有收到回复，则证明Server端已正常关闭，那好，我Client端也可以关闭连接了。Ok，TCP连接就这样关闭了！

## 什么是MSL
    MSL是一个时间概念，指的是数据包在链路中的最大生存时间，如果超过这个时间，数据包就会被丢掉。主动发起断开连接的一方会在TIME_WAIT时等待2MSL，因为包要一个来回。所以有时候也称TIME_WAIT状态为2MSL状态。

## 什么时候哪一方会出现TIME_WAIT
	TCP四次挥手的时候主动发起FIN报文的一方会处于TIME_WAIT状态。

## TIME_WAIT的好和坏
	TIME_WAIT这个东西有没有好处呢？那有没有坏处呢？
	答案是都有的。好处就是它保证了在断开连接之前数据传输的完整性；那坏处是什么呢？想象一下，如果是服务器主动发起的FIN报文，那它就会处于TIME_WAIT状态，那肯定就会占用一定系统资源。想象一下，如果并发量超级大的时候，那服务器岂不是会崩溃了。

<font color=#ff1201>技术交流可加QQ群：**774332965**<br></font>

<font color=#ff1201>微信订阅号同步：**IT运维那点儿事**</font>

![weixin](http://dl-blog.laoxianyu.cn/weixindy.jpg)

