---
title: Deploy manual for RP release
date: 2016-12-20 15:18:37
tags:
  - RP
  - D03
  - D05
categories:
  - Estuary
  - Documents
---

<div style="color:red;" >
Updated:
2017-02-08: 补充download_files.sh脚本文件内容。
</div>

参考：  
<https://github.com/Linaro/documentation/blob/master/Reference-Platform/EECommon/Install-CentOS-7.md>  
<https://github.com/Linaro/documentation/blob/master/Reference-Platform/EECommon/Install-Debian-Jessie.md>

### PXE服务器环境

BoardServer1 / BoardServer2: `192.168.1.107`  
TFTP根目录: `/home/hisilicon/ftp`
<!--more-->

### 下载RP相应版本的映像文件

使用{% asset_link download.sh %}脚本进行文件下载
```bash
$ cd
$ wget http://192.168.1.107/download.sh
$ chmod +x download.sh
$ ./download.sh
```
`download.sh`脚本内容如下(以`latest`版本为例):
```bash
TFTP_ROOT=~/tftp
TREE_DIR=${TFTP_ROOT}/erp

UEFI_VERSION=latest
CENTOS_INSTALLER_VERSION=latest
DEBIAN_INSTALLER_VERSION=latest

mkdir -p ${TREE_DIR}
cd ${TREE_DIR}

mkdir -p uefi/snapshots/${UEFI_VERSION}
mkdir -p centos-installer/snapshots/
mkdir -p debian-installer/snapshots/

# Get download script
if [ -e download_files.sh ]; then
	rm -f download_files.sh
fi
wget http://192.168.1.107/download_files.sh
chmod +x download_files.sh
export PATH=${PWD}:$PATH

# Download UEFI files
pushd uefi/snapshots/${UEFI_VERSION}
download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/uefi/${UEFI_VERSION}/debug/d03/
download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/uefi/${UEFI_VERSION}/debug/d05/
#download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/uefi/${UEFI_VERSION}/release/d03/
#download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/uefi/${UEFI_VERSION}/release/d05/
popd

# Download centos-installer files
pushd centos-installer/snapshots
download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/centos-installer/${CENTOS_INSTALLER_VERSION}/
popd

# Download debian-installer files
pushd debian-installer/snapshots
download_files.sh https://builds.96boards.org/snapshots/reference-platform/components/debian-installer/${DEBIAN_INSTALLER_VERSION}/
popd
```
具体的RP版本需要修改`UEFI_VERSION`、`CENTOS_INSTALLER_VERSION`、`DEBIAN_INSTALLER_VERSION`变量为相应的版本号。  
上述`download.sh`脚本执行完成之后，在`~/tftp/erp`目录下可以看到以下目录文件：
```bash
jarson@BoardServer2:~/tftp/erp$ ls
centos-installer  debian-installer  download_files.sh  uefi
```
进入相应目录，检查下载文件的完整性，例如检查`centos-installer`相关文件的完整性：
```bash
jarson@BoardServer2:~/tftp/erp$ cd centos-installer/snapshots/latest/
jarson@BoardServer2:~/tftp/erp/centos-installer/snapshots/latest$ ls
EFI  images  LiveOS  lorax.log  MD5SUMS.txt
jarson@BoardServer2:~/tftp/erp/centos-installer/snapshots/latest$ md5sum -c MD5SUMS.txt
.treeinfo: OK
images/efiboot.img: OK
images/pxeboot/vmlinuz: OK
images/pxeboot/initrd.img: OK
md5sum: images/boot.iso: No such file or directory
images/boot.iso: FAILED open or read
EFI/BOOT/fonts/unicode.pf2: OK
EFI/BOOT/BOOTAA64.EFI: OK
EFI/BOOT/grubaa64.efi: OK
EFI/BOOT/MokManager.efi: OK
EFI/BOOT/grub.cfg: OK
lorax.log: OK
LiveOS/squashfs.img: OK
.discinfo: OK
MD5SUMS.txt: FAILED
md5sum: WARNING: 1 listed file could not be read
md5sum: WARNING: 1 computed checksum did NOT match
jarson@BoardServer2:~/tftp/erp/centos-installer/snapshots/latest$
```
(网络安装部署不需要iso文件，因此文件下载时跳过以节省下载时间)

{% asset_link download_files.sh %} 脚本内容如下：
```bash
#!/bin/bash

usage() {
	echo "Usage: $0 <url>"
	exit 0
}

if [ $# -lt 1 ]; then
	usage
fi

URL=${1%/}
ROOT_DIR=${URL##*/}
MD5SUMS_FILE="MD5SUMS.txt"

mkdir -p $ROOT_DIR && cd $ROOT_DIR
wget -c $URL/$MD5SUMS_FILE

if [ ! -e $MD5SUMS_FILE ]; then
	echo -e "\e[31mDownload $MD5SUMS_FILE failed!\e[0m"
	exit 1
fi

declare -A file_list
file_list=$(cat $MD5SUMS_FILE | awk '{print $2}')

for file in $file_list; do
	ret=$(echo $file | grep -E "*.iso")
	if [ -n "$ret" ]; then
		echo "Skip file: $file"
		continue
	fi
	file_dir=$(dirname $file)
	mkdir -p $file_dir
	wget -c $URL/$file -O $file
done

echo -e "\e[32mDownloaded files:\e[0m\n$file_list"
tree $PWD

echo -e "\e[32mMD5SUM check:\e[0m"
md5sum -c $MD5SUMS_FILE
```

### 更新`grubaa64.efi`文件 (Centos)
```bash
$ export TFTP_ROOT=/home/hisilicon/ftp
$ cd ${TFTP_ROOT}
$ mv grubaa64.efi grubaa64.efi.bak
$ pushd ~/tftp/erp/centos-installer/snapshots/latest
$ cp EFI/BOOT/grubaa64.efi ${TFTP_ROOT}
$ popd
```

### 更新UEFI

以D03为例(D05类似)，文件准备：
```bash
$ pusd ~/tftp/erp/uefi/snapshots/latest
$ cp d03/D03.fd ~/
$ popd
```
重启单板至UEFI菜单，选择"Boot Manager" -> "Embedded Boot Loader (EBL)"进入"Embedded Boot Loader (EBL)"模式，命令窗口中使用`biosupdate`命令更新UEFI。
```bash
SmiGraphicsOutputQueryMode +
SmiGraphicsOutputQueryMode -
Booting Embedded Boot Loader (EBL)
add-symbol-file /home/g00179230/edk2/Build/D03Source/RELEASE_GCC49/AARCH64/HwPkg/Override/EmbeddedPkg/Ebl/Ebl/DEBUG/Ebl.dll 0x3105F240
Loading driver at 0x0003105F000 EntryPoint=0x0003105F240 Ebl.efi
Embedded Boot Loader (EBL) prototype. Built at 16:07:53 on Aug 12 2016
THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN 'AS IS' BASIS,
WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
Please send feedback to edk2-devel@lists.sourceforge.net
D03 >biosupdate -?
biosupdate format: provision [serverip] -u [username] -p [password] -f [filename] [master or slave]
D03 >biosupdate 192.168.1.107 -u jarson -p xxxxxxxx -f D03.fd master
Please select the NIC:
Interface 1: Mac Address: C0-A8-02-D8-00-00
Interface 2: Mac Address: C0-A8-02-D8-00-01
Interface 3: Mac Address: C0-A8-02-D8-00-04
Interface 4: Mac Address: C0-A8-02-D8-00-05
Input the index: 3


 Wait for a moment to get a IP Address
 ASSERT [DxeCore] /home/buildslave/workspace/96boards-reference-uefi/142/edk2/MdeModulePkg/Core/Dxe/Mem/Pool.c(574): Tail->Signature == ((('p') | ('t' << 8)) | ((('a') | ('l' << 8)) << 16))
 ASSERT [DxeCore] /home/buildslave/workspace/96boards-reference-uefi/142/edk2/MdeModulePkg/Core/Dxe/Mem/Pool.c(575): Head->Size == Tail->Size
 Connected to the ftp server.
 Download file D03.fd from server.
 D03.fd: 300000 bytes.
 Download file D03.fd succ!
 Length is 0x300000
 BiosSpiFlashUpdate..............................Begin
 Updateing Bios: 100% (3145728/3145728)
 BiosSpiFlashUpdate..............................Ok
 Update BIOS Succ!
 D03 >
```

### 配置`grub.cfg`

修改`~/grub.cfg`，按如下{% asset_link grub.cfg 参考配置 %}进行修改：
```bash
menuentry 'Install CentOS Linux 7 for D03 --network' --id d03_erp_centos {
    set root=(tftp,192.168.1.107)
    echo 'Loading kernel...'
    linux /jarson/erp/centos-installer/snapshots/latest/images/pxeboot/vmlinuz ip=eth0:dhcp \
        console=ttyS0,115200 earlycon=hisilpcuart,mmio,0xa01b0000,0,0x2f8 pcie_aspm=off \
        inst.stage2=nfs:192.168.1.107:/home/hisilicon/ftp/jarson/erp/centos-installer/snapshots/latest \
        inst.ks=http://192.168.1.107/ks.cfg
    echo 'Loading initrd...'
    initrd /jarson/erp/centos-installer/snapshots/latest/images/pxeboot/initrd.img
}

menuentry "Install Debian Jessie 8.5 for D03 --network" --id d03_erp_debian {
    set background_color=black
    linux /jarson/erp/debian-installer/snapshots/latest/debian-installer/arm64/linux \
        console=ttyS0,115200 earlycon=hisilpcuart,mmio,0xa01b0000,0,0x2f8 pcie_aspm=off \
        ip=dhcp interface=eth0 auto=true priority=critical \
        url=http://192.168.1.107/d03_preseed.cfg
    initrd /jarson/erp/debian-installer/snapshots/latest/debian-installer/arm64/initrd.gz
}

menuentry "Install CentOS Linux 7 for D05 --network" --id d05_erp_centos {
    set root=(tftp,192.168.1.107)
    echo 'Loading kernel...'
    linux /jarson/erp/centos-installer/snapshots/latest/images/pxeboot/vmlinuz ip=eth0:dhcp pcie_aspm=off \
        inst.stage2=nfs:192.168.1.107:/home/hisilicon/ftp/jarson/erp/centos-installer/snapshots/latest \
        inst.ks=http://192.168.1.107/ks.cfg
    echo 'Loading initrd...'
    initrd /jarson/erp/centos-installer/snapshots/latest/images/pxeboot/initrd.img
}

menuentry "Install Debian Jessie 8.5 for D05 --network" --id d05_erp_debian {
    set background_color=black
    linux /jarson/erp/debian-installer/snapshots/latest/debian-installer/arm64/linux pcie_aspm=off \
        ip=dhcp interface=eth0 auto=true priority=critical \
        url=http://192.168.1.107/d05_preseed.cfg
    initrd /jarson/erp/debian-installer/snapshots/latest/debian-installer/arm64/initrd.gz
}
```
(注：修改`jarson`为当前用户名，修改`latest`为具体的版本号)

### PXE方式安装系统

1. 重启单板至UEFI主菜单，在“Boot Manager”菜单中选择从“EFI Network 2”启动。
2. 启动至Grub菜单，选择相应的安装启动项，例如“Install CentOS Linux 7 D03 --network”。
3. 系统将实现自动安装。

系统初始用户名 / 密码：  
Centos: root / injab0xn  
Centos: linaro / linaro  
Debian: root / root  
Debian: linaro / linaro
