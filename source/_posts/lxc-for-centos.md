---
title: lxc for centos
date: 2017-01-12
tags:
  - lxc
  - CentOS
categories:
  - Estuary
  - Documents
---
<first add lxc testing steps for centos>

### centos下下载lxc源码

`git clone git://github.com/lxc/lxc -b master`

### 安装依赖的包

`yum install bridge-utils libcap-devel libtool  cloud-utils -y`

### 运行README文档中提示的脚本进行编译安装

`./autogen.sh && ./configure && make && sudo make install`

### 安装完成后使用`lxc-checkconfig`查看内核丢失了哪些选项，使用`make menuconfig`打开丢失的项, 编译完成后替换原来的image，然后再用`lxc-checkconfig`验证

### 创建网桥

`cd /etc/sysconfig/network-scripts`  
`vi ifcfg-lxcbr0`  
```bash
DEVICE="lxcbr0"
BOOTPROTO="static"
IPADDR="xxx.xxx.xxx.xxx"
NETMASK="255.255.255.xxx"
ONBOOT="yes"
TYPE="Bridge"
NM_CONTROLLED="no"
```
### 更改完之后 重启网络服务

`systemctl restart network.service`

### 更改`/usr/local/share/lxc/templates/lxc-ubuntu-cloud`, 注释掉这一行:`type ubuntu-cloudimg-query`

### 拉镜像

`lxc-create -n ubuntu -t ubuntu-cloud -- -r vivid -T http://cloud-images.ubuntu.com/releases/vivid/release-20160203/ubuntu-15.04-server-cloudimg-arm64-root.tar.gz`

如果你在Lab2上的话可以使用：`lxc-create -n ubuntu -t ubuntu-cloud -- -r vivid -T http://192.168.1.107/ubuntu-15.04-server-cloudimg-arm64-root.tar.gz`

### 启动lxc

`lxc-start -n ubuntu -F`

### 参考网站

https://wiki.linaro.org/LEG/Engineering/LXC 化哥提交

http://17173ops.com/2013/11/14/linux-lxc-install-guide.shtml#toc37 lxc指令集

https://www.stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/  关于缺失ubuntu-cloudimg-query 命令的解决办法

http://www.thegeekstuff.com/2016/01/install-lxc-linux-containers/ 利用源代码安装及配置lxc的方法

https://bbs.archlinux.org/viewtopic.php?id=167253 不使用debootstrap创建lxc镜像（centos下暂时没有实验利用debootstrap创建镜像的方法）

http://cloud-images.ubuntu.com/releases/vivid/release/ ubuntu官方云镜像仓库

