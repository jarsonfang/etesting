---
title: kvm
date: 2017-01-16 10:44:19
tags:
	- D05
	- D03
	- Ubuntu
	- CentOS
categories:
	- Estuary
	- Documents
---
#KVM PROFILE
KVM and QEMU profiles, please refer to:
qemu :[https://zh.wikipedia.org/wiki/QEMU](https://zh.wikipedia.org/wiki/QEMU)
kvm :[https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)
#Install
##Ubuntu
###Option 1 :ubuntu-package-install
```bash
apt-get -y install qemu qemu-kvm libvirt-bin bridge-utils
```
---
###Option 2:ubuntu-compile-install
####Install depended-upon package
```bash
apt-get install -y gcc zlib1g-dev libperl-dev libgtk2.0-dev libfdt-dev bridge-utils
```
####compile
First get the newest qemu code from estuary repository,then enter the QEMU code root directory and execute the following command step by step.
```bash
mkdir build
cd build
../configure --target-list=aarch64-softmmu --enable-fdt --enable-kvm --disable-werror
make -j5
make install
```
---
##Centos
###Option 1 :centos-package-install
CentOS official source of QEMU(aarch64) support is not good, you need to add linaro source
```
[root@CentOS-D05 qemu]# cat /etc/yum.repos.d/Linaro-overlay.repo 
[linaro-overlay]
name = Linaro Overlay packages for CentOS 7
baseurl = http://repo.linaro.org/rpm/linaro-overlay/centos-7/repo
enable = 1
```
During the installation if there is an error because of the network,please repeat.
Some of the linaro packages have not been verified by GPG,so close the gpg check.
```
sed -i "/^gpgcheck/s/1/0/g" /etc/yum.conf
```

```bash
yum install qemu qemu-kvm libvirt libcanberra-gtk2 qemu-kvm qemu-kvm-tools libvirt-cim libvirt-client libvirt-java.noarch  libvirt-python libiscsi-1.7.0-5.el6  dbus-devel  virt-clone tunctl virt-manager libvirt libvirt-python python-virtinst bridge-utils -y
```
---
###Option 2 :centos-compile-install
####Install depended-upon package
```
yum groups mark convert
yum groups mark install "Development Tool"
yum group install "Development tools" -y
yum install glib2-devel zlibrary zlib-devel pixman pixman-devel libfdt-devel libfdt -y
```
####compile
First get the newest qemu code from estuary repository,then enter the QEMU code root directory and execute the following command step by step.
```bash
mkdir build
cd build
../configure --target-list=aarch64-softmmu --enable-fdt --enable-kvm --disable-werror
make -j5
make install
```
---
#Enable virtual bridge and get the necessary binary
Build the estuary project with qemu option,then you will find a *.img file in open-estuary/workspace/distro/
copy the *.img file and Image to current directory.
In order to enable virtual bridge,execute the following command:
```bash
brctl addbr br0
ip addr add 192.168.2.1/24 dev br0
# add route
ip link set br0 up
ip route add 192.168.2.0/24 via 192.168.2.1 dev br0
```
#Verification
there are two scripts that will be used when starting QEMU.Put them into current directory.
```
[root@CentOS ~]# cat qemu-ifup.sh 
#!/bin/bash
switch=br0
    if [ -n "$1"  ]; then
    #create a tap interface
    ip tuntap add $1 mode tap
    sleep 1
    #start up the tap interface
    ip link set $1 up
    sleep 1
    #add tap interface to the bridge
    brctl addif ${switch} $1
    exit 0
else
    echo "error: no interface specified"
    exit 1
fi
```
```
[root@CentOS ~]# cat qemu-ifdown.sh 
#!/bin/bash
switch=br0
if [ -n "$1"  ]; then
    #delete the specified interface
    ip tuntap del mode tap $1
    #rlease tap interface from bridge
    brctl delif $(switch) $1
    #shutdown the tap interface
    ip link set $1 down
    exit 0
else
    echo "error: no interface specified"
    exit 1
fi
[root@CentOS ~]# 
```
Start qemu execute the following command:
```bash
qemu-system-aarch64 -machine virt,gic_version=3 -cpu host -kernel Image -drive if=none,file=ubuntu.img,id=fs -device virtio-blk-device,drive=fs -append "console=ttyAMA0 root=/dev/vda1 rw rootwait" -device virtio-net-device,netdev=net0 -netdev tap,id=net0,script=qemu-ifup.sh,downscript=qemu-ifdown.sh -nographic -D -d -enable-kvm
```
Verify network capabilities,execute the following command in qemu
```bash
ip addr add 192.168.2.3/24 dev eth0
ping 192.168.2.1 -c 3
```

Verify the function of the virtual hard disk,Follow these steps:

1. create a dir in qemu

    >```bash
    >mkdir hello-world
    >```

2. restart the qemu

    >   colse qemu: send CTRL+a,c to qemu,then input "quit"

3. Confirm whether the newly created directory exists
