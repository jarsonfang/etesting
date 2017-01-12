---
title: How to mirror a CentOS source repo
date: 2017-01-12 11:12:21
tags:
  - CentOS
categories:
  - Misc
---

### rsync.sh

使用{% asset_link rsync.sh %}脚本进行源同步
```bash
#!/bin/bash

# New AltArch mirror [US]
# HTTP: http://ftp.osuosl.org/pub/centos-altarch/
# http://centos-altarch.osuosl.org/
# FTP: ftp://ftp.osuosl.org/pub/centos-altarch
# RSYNC: rsync://rsync.osuosl.org/centos-altarch

usage()
{
	echo "$0: <os_version>"
	exit 0
}

if [ $# -lt 1 ]; then
	usage
fi

os_version=$1
rsync -av --delete rsync://rsync.osuosl.org/centos-altarch/${os_version} ./
```
注：如果使用不同的软件源地址，则相应替换脚本中的软件源地址。

<!--more-->

### 使用说明

`rsync.sh`脚本需要传入一个关于系统版本的参数`os_version`，登录待同步源的官网(例如<http://ftp.osuosl.org/pub/centos-altarch/>)查看`os_version`参数的可选值。  
示例：以下命令将在当前工作目录下同步`7.2.1603`版本的CentOS软件源。
```bash
./rsync.sh 7.2.1603
```
为方便使用多个版本的软件源，可以创建一个到指定版本的软件源的软链接，例如：
```bash
ln -s 7.2.1603 centos-7
```
