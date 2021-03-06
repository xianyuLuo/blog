---
title: tcp交互数据和块数据处理
tags: TCP/IP
abbrlink: d8cfbc13
date: 2017-11-29 20:41:05
categories: [网络]
---
## 前言
目前建立在TCP协议上的网络协议特别多，有telnet，ssh，有ftp，有http等等。这些协议又可以根据数据吞吐量来大致分成两大类：
+ (1)交互数据类型
例如telnet，ssh，这种类型的协议在大多数情况下只是做小流量的数据交换，比如说按一下键盘，回显一些文字等等。
+ (2)数据成块类型
例如ftp，这种类型的协议要求TCP能尽量的运载数据，把数据的吞吐量做到最大，并尽可能的提高效率。针对这两种情况，TCP给出了两种不同的策略来进行数据传输。

<!-- more -->
## TCP的交互数据流

对于交互性要求比较高的应用，TCP给出两个策略来提高发送效率和减低网络负担：
- (1)捎带ACK
- (2)Nagle算法（一次尽量多的发数据）

#### 捎带ACK的发送方式

&ensp;&ensp;&ensp;&ensp;当主机收到远程主机的TCP数据报之后，通常不马上发送ACK数据报，而是等上一个短暂的时间，如果这段时间里面主机还有发送到远程主机的TCP数据报，那么就把这个ACK数据报“捎带”着发送出去，把本来两个TCP数据报整合成一个发送。一般的，这个时间是200ms。可以明显地看到这个策略可以把TCP数据报的利用率提高很多。

#### Nagle算法

&ensp;&ensp;&ensp;&ensp;Nagle算法是说，当主机A给主机B发送了一个TCP数据报并进入等待主机B的ACK数据报的状态时，TCP的输出缓冲区里面只能有一个TCP数据报，并且，这个数据报不断地收集后来的数据，整合成一个大的数据报，等到B主机的ACK包一到，就把这些数据“一股脑”的发送出去。这样可以较少交互，减轻压力。


## TCP的成块数据流

&ensp;&ensp;&ensp;&ensp;对于FTP这样对于数据吞吐量有较高要求的要求，将总是希望每次尽量多的发送数据到对方主机，就算是有点延迟也无所谓。TCP也提供了一整套的策略来支持这样的需求。TCP协议中有16个bit表示“窗口”的大小，这是策略的核心。
![tcp_chuangkou1](http://dl-blog.laoxianyu.cn/tcp%E7%AA%97%E5%8F%A31.png)

#### 传输数据时ACK的问题

&ensp;&ensp;&ensp;&ensp;在解释滑动窗口前，需要看看ACK的应答策略，一般来说，发送端发送一个TCP数据报，那么接收端就应该发送一个ACK数据报。但是事实上却不是这样，发送端将会连续发送数据尽量填满接受方的缓冲区，而接受方对这些数据只要发送一个ACK报文来回应就可以了，这就是ACK的累积特性，这个特性大大减少了发送端和接收端的负担。

#### 滑动窗口

&ensp;&ensp;&ensp;&ensp;滑动窗口本质上是描述接受方的TCP数据报缓冲区大小的数据，发送方根据这个数据来计算自己最多能发送多长的数据。如果发送方收到接受方的窗口大小为0的TCP数据报，那么发送方将停止发送数据，等到接受方发送窗口大小不为0的数据报的到来。关于滑动窗口协议，还有三个术语，分别是：
* 窗口合拢：当窗口从左边向右边靠近的时候，这种现象发生在数据被发送和确认的时候。
* 窗口张开：当窗口的右边沿向右边移动的时候，这种现象发生在接受端处理了数据以后。
* 窗口收缩：当窗口的右边沿向左边移动的时候，这种现象不常发生。

TCP就是用这个窗口，慢慢的从数据的左边移动到右边，把处于窗口范围内的数据发送出去（但不用发送所有，只是处于窗口内的数据可以发送。）。这就是窗口的意义。
![tcp_chuangkou2](http://dl-blog.laoxianyu.cn/tcp%E7%AA%97%E5%8F%A32.png)

#### 数据拥塞

&ensp;&ensp;&ensp;&ensp;上面的策略用于局域网内传输还可以，但是用在广域网中就可能会出现问题，最大的问题就是当传输时出现了瓶颈所产生的大量数据拥塞问题，为了解决这个问题，TCP发送方需要确认连接双方的线路的数据最大吞吐量是多少。这就是所谓的拥塞窗口。
&ensp;&ensp;&ensp;&ensp;拥塞窗口的原理很简单，TCP发送方首先发送一个数据报，然后等待对方的回应，得到回应后就把这个窗口的大小加倍，然后连续发送两个数据报，等到对方回应以后，再把这个窗口加倍（先是2的指数倍，到一定程度后就变成线行增长，这就是所谓的TCP慢启动），发送更多的数据报，直到出现超时错误，这样，发送端就了解到了通信双方的线路承载能力，也就确定了拥塞窗口的大小，发送方就用这个拥塞窗口的大小发送数据。
平时在下载电影的时候，仔细观察应该不难发现，速度先从几十K到100K，然后到200K，再到400K，后面慢慢变的稳定，这个速度就是拥塞窗口的大小。

<font color=#ff1201>技术交流可加QQ群：**774332965**<br></font>

<font color=#ff1201>微信订阅号同步：**IT运维那点儿事**</font>

![weixin](http://dl-blog.laoxianyu.cn/weixindy.jpg)

