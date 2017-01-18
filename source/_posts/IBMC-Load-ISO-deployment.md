---
title: IBMC Load ISO 部署
date: 2017-01-18 17:34:23
tags:
  - D03
  - D05
categories:
  - Estuary
  - Documents
---

**Author:** Fang Yuanzheng

打开浏览器，输入目标单板的ip地址，进入ibmc登录界面，默认账号：`root`，密码：`Huawei12#$`
{% asset_img login.png %}

<!--more-->

登录之后，点击`Remote`项，选择`Remote Virtual Console (Share Mode)`
{% asset_img remote.png %}

正常情况下应该可以看到下面界面，如果没有看到，是由于没有安装java虚拟机，请安装java虚拟机。
{% asset_img console-1.png %}

选择虚拟控制台 光驱->镜像文件->浏览按钮找到 ISO 镜像文件后选择 连接。
{% asset_img console-2.png %}

在返回到 BMC 的网页，选择配置->系统启动项中的光驱启动，最后点击保存。
{% asset_img boot-option.png %}

系统启动项中的修改只有本次重启有效，下次开机如果还想从光驱启动，必须重新在 BMC 中重新修改系统启动项。  
通过虚拟控制台中的强制重启，选择`Power`，点击`Forced System Reset`，让目标单板重启。
{% asset_img power.png %}

正常情况下，系统 起来后就会将 ISO 文件中的内容写到硬盘中。
