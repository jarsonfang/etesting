---
title: Armor test
date: 2017-01-18 10:33:21
distribution:
  - Debian
  - ubuntu
  - fedoar
  - opensuse
  - Centos
  - D03
  - D05
  - armor

categories:
  - Estuary
  - Documents

---

**Author:** Ma Hongxin

### 测试命令

登录目标系统，进入`/usr/local/armor/test_scripts`目录并执行`auto_test_armot_tool.sh`脚本:
```bash
cd /usr/local/armor/test_scripts
chmod +x auto_test_armor_tool.sh
./auto_test_armor_tool.sh > armor_test.log 2>&1
```
`auto_test_armor_tool.sh`脚本执行的 *标准输出* 与 *标准错误* 信息将重定向到`armor_test.log`文件。

### 测试结果分析

1. 查询未安装的armor工具
   ```bash
   grep "not found" armor_test.log
   ```

2. 查询测试失败的armor工具
   ```bash
   grep "failed" armor_test.log
   ```

<!--more-->

### 对比系统升级前后的测试结果

目标系统升级完成后，继续执行上述测试命令，并对比系统升级前后的测试结果。

#### 系统升级命令

CentOS
```bash
yum update
yum upgrade
```
Fedora
```bash
dnf update
dnf upgrade
```

OpenSuse
```bash
zypper update
zypper upgrade
```

Debian & Ubuntu
```bash
apt-get update
apt-get upgrade
```
