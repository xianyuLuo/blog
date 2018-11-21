---
title: 使用let's encript申请通配符证书
tags: https
abbrlink: bfd9c176
date: 2018-11-07 22:42:59
categories: [网络]
---
# 什么是 Let’s Encrypt
Let’s Encrypt 是国外一个公共的免费 SSL 项目，由 Linux 基金会托管。它的来头不小，由 Mozilla、思科、Akamai、IdenTrust 和 EFF 等组织发起，目的就是向网站自动签发和管理免费证书。以便加速互联网由 HTTP 过渡到 HTTPS，目前 Facebook 等大公司开始加入赞助行列。

Let’s Encrypt 已经得了 IdenTrust 的交叉签名，这意味着其证书现在已经可以被 Mozilla、Google、Microsoft 和 Apple 等主流的浏览器所信任。用户只需要在 Web 服务器证书链中配置交叉签名，浏览器客户端会自动处理好其它的一切，Let’s Encrypt 安装简单，使用非常方便。

<!-- more -->

本文将会详细介绍如何免费申请 Let’s Encrypt 通配符证书。

# 什么是通配符证书
域名通配符证书类似 DNS 解析的泛域名概念，通配符证书就是证书中可以包含一个通配符。主域名签发的通配符证书可以在所有子域名中使用，比如 ×.baidu.com，*.laoxianyu.cn。

# 申请通配符证书
Let’s Encrypt 上的证书申请是通过 ACME 协议来完成的。ACME协议规范化了证书申请、更新、撤销流程，实现了 Let’s Encrypt CA 自动化操作。解决了传统的 CA 机构是人工手动处理证书申请、证书更新、证书撤销的效率和成本问题。

ACME v2 是 ACME 协议的更新版本，通配符证书只能通过 ACME v2 获得。要使用 ACME v2 协议申请通配符证书，只需一个支持该协议的客户端就可以了，官方推荐的客户端是 Certbot。

## 获取 Certbot 客户端
```
# 下载 Certbot 客户端
$ wget https://dl.eff.org/certbot-auto

# 设为可执行权限
$ chmod a+x certbot-auto
```
* 注：Certbot 从 0.22.0 版本开始支持 ACME v2，如果你之前已安装旧版本客户端程序需更新到新版本。  

更详细的安装可参考官方文档：https://certbot.eff.org/

## 申请通配符证书
客户在申请 Let’s Encrypt 证书的时候，需要校验域名的所有权，证明操作者有权利为该域名申请证书，目前支持三种验证方式：

- dns-01：给域名添加一个 DNS TXT 记录。
- http-01：在域名对应的 Web 服务器下放置一个 HTTP well-known URL 资源文件。
- tls-sni-01：在域名对应的 Web 服务器下放置一个 HTTPS well-known URL 资源文件。

使用 Certbot 客户端申请证书方法非常的简单，只需如下一行命令就搞定了。
```
$ ./certbot-auto certonly  -d "*.laoxianyu.cn" --manual --preferred-challenges dns-01  --server https://acme-v02.api.letsencrypt.org/directory
```
*1.申请通配符证书，只能使用 dns-01 的方式。*

*2.laoxianyu.com 请根据自己的域名自行更改。*

相关参数说明：

certonly 表示插件，Certbot 有很多插件。不同的插件都可以申请证书，用户可以根据需要自行选择。

* -d 为哪些主机申请证书。如果是通配符，输入*.laoxianyu.com (根据实际情况替换为你自己的域名)。
* --preferred-challenges dns-01，使用 DNS 方式校验域名所有权。
* --server，Let's Encrypt ACME v2版本使用的服务器不同于 v1 版本，需要显示指定。

执行完这一步之后，就是命令行的输出，请根据提示输入相应
![le_ssl_01.png](http://dl-blog.laoxianyu.cn/le_ssl_01.png)

**执行到上图最后一步时，先暂时不要回车。申请通配符证书是要经过 DNS认证的，接下来需要按照提示在域名后台添加对应的 DNS TXT记录。**
添加完成后，先输入以下命令确认 TXT 记录是否生效：
```
dig  -t txt _acme-challenge.laoxianyu.cn
```
确认生效后，回车继续执行，最后会输出如下内容：
```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/xxx.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/xxx.com/privkey.pem
   Your cert will expire on 2018-06-12. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```
到了这一步后，恭喜您，证书申请成功。证书和密钥保存在下列目录：
* /etc/letsencrypt/live/laoxainyu.cn/

现在可以尽情的享用通配证书了！！！

<font color=#ff1201>技术交流可加QQ群：**774332965**<br></font>

<font color=#ff1201>微信订阅号同步：**IT运维那点儿事**</font>

![weixin](http://dl-blog.laoxianyu.cn/weixindy.jpg)

