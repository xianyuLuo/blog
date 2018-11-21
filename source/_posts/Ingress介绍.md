---
title:
  - Ingress介绍
categories:
  - kubernetes
tags:
  - kubernetes
  - ingress
abbrlink: 7ef83387
date: 2018-11-09 18:29:30
---

# 概念

Ingress是kubernetes1.1之后官方提出的一个标准，按照这套标准它有多种实现，比如 nginx-ingress-controller、traefik-ingress-controller、kong-ingress-controller，这3中都是官方推荐的。Ingress的出现解决了Service的短板：只能在tcp层面做负载均衡。而ingress可以方便的做http/https层面的负载均衡。一个是在4层，一个在7层。ingress就是控制客户端从入口连接到k8s集群服务的规则的集合！

### ingress出现之前，服务暴露是这样的：

![image](http://dl-blog.laoxianyu.cn/image2018-8-10_14-6-49.png)


### ingress出现之后，服务暴露是这样的：
<!--more-->

![image](http://dl-blog.laoxianyu.cn/image2018-8-10_14-7-29.png)

可以给Ingress配置提供外部可访问的URL、负载均衡、SSL、基于名称的虚拟主机等。ingress-controller负责实现了ingress这套标准，一般使用的是负载均衡。


使用ingress之前，必须要先部署ingress-controller，不然把ingress部署起来也没用，它不会产生实际作用。

# Ingress格式
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        backend:
          serviceName: test
          servicePort: 80
```
每个Ingress都需要配置rules。

根据Ingress Spec配置的不同，Ingress可以分为以下几种类型：

### 单服务Ingress
单服务Ingress即该Ingress仅指定一个没有任何规则的后端服务。
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  backend:
    serviceName: testsvc
    servicePort: 80
```

### 路由到多服务的Ingress
路由到多服务的Ingress即根据请求路径的不同转发到不同的后端服务上，比如
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: s1
          servicePort: 80
      - path: /bar
        backend:
          serviceName: s2
          servicePort: 80
```
### 虚拟主机Ingress
虚拟主机Ingress即根据Host header的不同转发到不同的后端服务上，如下所示
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: test
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - backend:
          serviceName: s1
          servicePort: 80
  - host: bar.foo.com
    http:
      paths:
      - backend:
          serviceName: s2
          servicePort: 80
```
* 注：没有定义规则的后端服务称为默认后端服务，可以用来方便的处理404页面。



k8s官方ingress文档：https://kubernetes.io/docs/concepts/services-networking/ingress/

traefik-ingress-controller使用：https://laoxianyu.cn/archives/208297ce.html

<font color=#ff1201>技术交流可加QQ群：774332965</font>
