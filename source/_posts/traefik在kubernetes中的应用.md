---
title: traefik在kubernetes中的应用
tags:
  - kubernetes
  - ingress
  - traefik
abbrlink: 208297ce
date: 2018-09-10 22:08:46
categories: [kubernetes]
---
# 目的：
通过本篇文章，能够简单了解和掌握Traefik在Kubernetes中的应用

如果不了解ingress和ingress-controller概念，请先看前一篇文章。http://km.oa.dragonest.com/x/RoFf

# traefik介绍：
开源的微服务网关服务，支持Mesos、Docker、Rancher、Kubernetes等等，也支持直接部署在物理服务器。能够实现负载均衡、HTTPS、自动更新Ingerss配置等等

<!-- more -->
# traefik部署：
## traefik-deployment部署
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: traefik-ingress-controller
  namespace: traefik
  labels:
    k8s-app: traefik-ingress-lb
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: traefik-ingress-lb
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      nodeSelector:
        traefik-controller-qa: "yes"
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      volumes:
      - name: ssl
        secret:
          secretName: traefik-cert
      - name: config
        configMap:
          name: traefik-conf
      containers:
      - image: traefik
        name: traefik-ingress-lb
        volumeMounts:
        - mountPath: "/ssl"
          name: "ssl"
        - mountPath: "/config"
          name: "config"
        ports:
        - name: http
          containerPort: 80
        - name: admin
          containerPort: 8080
        - name: https
          containerPort: 443
        args:
        - --configFile=/config/traefik.toml
        - --web
        - --kubernetes
        - --logLevel=INFO
```

## traefik-svc部署
``` yaml
apiVersion: v1
kind: Service
metadata:
  name: traefik-ingress-service
  namespace: traefik
spec:
  selector:
    k8s-app: traefik-ingress-lb
  ports:
    - protocol: TCP
      port: 80
      name: web
    - protocol: TCP
      port: 8080
      name: admin
    - protocol: TCP
      port: 443
      name: https
  type: LoadBalancer
```
其他证书、secret、configmap、rbac编排请见文章末尾链接！

# 实例应用：
该案例中使用website的一个demo站点做为测试，站点内容见： http://website-dev-demo.dragonest.com

案例效果：通过定义一个website-test-ingress来实现自动跳转至https和http basic认证。测试域名使用 mcm.hifiveai.com

## website-test-ingress部署

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: website-test-ingress
  namespace: website-dev
  annotations:
    kubernetes.io/ingress.class: traefik
    traefik.ingress.kubernetes.io/redirect-entry-point: https
    ingress.kubernetes.io/auth-type: basic
    ingress.kubernetes.io/auth-secret: website-test-secret
spec:
  rules:
  - host: mcm.hifiveai.com
    http:
      paths:
      - path: /
        backend:
          serviceName: website-demo-svc
          servicePort: http
  tls:
    - secretName: website-test-secret-ssl
```

## website-test-secret部署
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: website-test-secret
  namespace: website-dev
type: Opaque
data:
  auth: xxx
```
xxx为账号密码的base64编码，在 linux 中使用 htpasswd 命令可以生成。如：
![image2018-8-10_11-47-35.png](http://dl-blog.laoxianyu.cn/image2018-8-10_11-47-35.png)

## website-test-secret-ssl部署
``` yaml
apiVersion: v1
kind: Secret
metadata:
  name: website-test-secret-ssl
  namespace: website-dev
type: Opaque
data:
  tls.crt: xxx
  tls.key: xxx
```
xxx为mcm.hifiveai.com域名证书的base64编码

# 实际效果：
![image2018-8-10_11-52-47.png](http://dl-blog.laoxianyu.cn/image2018-8-10_11-52-47.png)
![image2018-8-10_11-53-33.png](http://dl-blog.laoxianyu.cn/image2018-8-10_11-53-33.png)



# Traefik常用ingress注解(annotaions)：

注解 | 作用
---|---
traefik.ingress.kubernetes.io/redirect-entry-point: https |跳转至 Https   302
ingress.kubernetes.io/ssl-redirect: "true" |跳转至 Https   301
ingress.kubernetes.io/ssl-temporary-redirect:"true" | 跳转至 Https   302 
traefik.ingress.kubernetes.io/redirect-regex:^http://localhost/(.*) \n traefik.ingress.kubernetes.io/redirect-replacement: http://mydomain/$1 | 重定向到其他域名
traefik.backend.loadbalancer.sticky: "true" |长连接（弃用）
traefik.ingress.kubernetes.io/affinity: "true" | 长连接
traefik.ingress.kubernetes.io/load-balancer-method: drr | 负载均衡算法  wrr / drr
ingress.kubernetes.io/custom-request-headers: EXPR \n ingress.kubernetes.io/custom-response-headers: EXP | 定制头部 HEADER:value||HEADER2:value2
ingress.kubernetes.io/allowed-hosts: EXPR | 访问控制  Host1,Host2
ingress.kubernetes.io/auth-type: basic | 认证方法，只有basic
ingress.kubernetes.io/auth-secret: website-test-secret | 认证secret。可用 htpasswd 生成


traefik部署编排：https://gitlab.ilongyuan.cn/ops/k8s-compose/tree/master/website/traefik

traefik测试实例编排：https://gitlab.ilongyuan.cn/ops/k8s-compose/tree/master/website/test

traefik官网：https://docs.traefik.io/


<font color=#ff1201>技术交流可加QQ群：774332965</font>
