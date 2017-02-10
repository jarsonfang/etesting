---
title: Deploy/Upgrade Estuary OS with USB
date: 2017-01-18 17:34:23
tags:
  - D05
categories:
  - Estuary
  - Documents
---

**Author:** Tian Jiaoling

## Preparation work

The doc is applied for deploying the target board with Estuary OS by USB disk or upgrading any release version of Estuary OS by USB disk.

We will introduce two methods to make USB install disk, one is to make during building Estuary open souce code, the other is making install disk with a script name mkdeploydisk.sh.

1. Please prepare a USB disk with 32G capacity.

2. Prepare a ubuntu pc.

3. Download and build Estuary souce code: http://open-estuary.org/getting-started/
<!--more-->

## Make USB installation disk(option 1)

1. Please download Estuary source code on your local pc firstly, and connect a USB disk to your local pc.

2. Modify `estuarycfg.json` located in `open-estuary/estuary`. Make sure the platform(D05), distros(CentOS or other distributions) are filled with "yes".

   {% asset_img centos.png %}

3. Change the value of "install" to "yes" in object "setup" for usb and the value "device" to your USB install disk.  
<span style="color:red">Note: if the specified usb device does not exist, the first detected usb device will be selected by default.</span>

   {% asset_img selectusb.png %}

4. Use build.sh to create the usb install disk.
   e.g.:
   ```bash
   sudo ./estuary/build.sh -f estuary/estuarycfg.json
   ```
5. The USB disk is ok when the building finished.

## Make USB installation disk(option 2)

“Curl” is suggested to install on your pc (Ubuntu system is suggested to use ). To see whether “curl” has been installed by command “which curl”. If curl is not installed, type `sudo apt-get install curl` command to install.

1. Download mkdeploydisk.sh

   Connect usb disk to the your local pc, open an terminal, type the following command to download mkdeploydisk.sh
   ```bash
   wget -c https://github.com/open-estuary/estuary/blob/master/deploy/mkdeploydisk.sh
   ```
2. Execute the following command with sudo permission to make usb installation disk.

   Please specify your disk with `--target=/dev/sdx` when more than one USB disk connected to your computer. If not specified, the first detected usb device will be used.  
   ```bash
   sudo ./mkdeploydisk.sh
   ```
   or
   ```bash
   sudo ./mkdeploydisk.sh --target=/dev/sdb
   ```
   We offered multiple Estuary versions for you to choose. Please select the version in your need.

   {% asset_img version.png %}

3. Wait until the installation is finished.

## Use USB installation disk to deploy D05

1. Connect the usb installation disk to the usb port of D05
   Reboot the board, press any key except “enter” key to enter UEFI menu when the screen echo Press any other key in 10 seconds to stop automatically booting

   {% asset_img 10.png %}

2. Select “Boot Manager”and press “enter” key , then choose “EFI USB DEVICE” and type “enter” key

   {% asset_img usb.png %}

3. The system will enter grub menu as follow and show “Install D05 estuary”, press “enter” key to start install.

   {% asset_img grub.png %}

4. The usb installation disk is deploying the system if you see the following log.

   {% asset_img deploy.png %}

5. After all the deployments have done, the system will reboot and enter the Estuary OS automatically without any manual operations. 
