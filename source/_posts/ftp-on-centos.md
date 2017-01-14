---
title: FTP on Centos 7
date: 2016-09-20 14:46:04
tags:
  - FTP
  - CentOS
categories:
  - Estuary
  - Documents
---

In this article, we will learn how to configure FTP server on CentOs 7 using `vsftpd`. `vsftpd` (Very Secure File Transport Protocol Daemon) is a secure and very fast FTP server on Linux systems.

## Install vsftpd

All commands should be run with `root` user. Run the following command in terminal to install `vsftpd` package:
```bash
yum install vsftpd ftp -y
```

<!--more-->

## Configure vsftpd

We needed to edit the configuration file `/etc/vsftpd/vsftpd.conf` for securing the FTP server since, by default it will allow anonymous users to login and use the server.
```bash
cp /etc/vsftpd/vsftpd.conf{,.bak}
vi /etc/vsftpd/vsftpd.conf
```
We have to disallow anonymous, unidentified users to access files via FTP; change the anonymous_enable setting to NO:
```
anonymous_enable=NO
```
Allow local users to login by changing the local_enable setting to YES:
```
local_enable=YES
```
If you want to allow the local users to be able to write to a directory, then change the write_enable setting in the configuration file to YES:
```
write_enable=YES
```
Local users will be ‘chroot jailed’ and they will be denied access the local users to any other part of the server; change the chroot_local_user setting in the configuration file to YES:
```
chroot_local_user=YES
```
Below is the simple configuration file for your reference:
```
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
#listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES
```

## Enable and restart  the vsftpd service

We needed to restart the `vsftpd` services so that the configuration changes has applied.
```bash
systemctl restart vsftpd
```
We will set the `vsftpd` service to start at boot time, below is the command to enable the `vsftpd` to start.
```bash
systemctl enable vsftpd
```

## Allowing the vsftpd Through the Firewall

Allow the ftp service and port **21** via firewall.
```bash
firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --permanent --add-service=ftp
```
Restart firewall:
```bash
firewall-cmd --reload
```

## Create FTP users

By default, root user is not allowed to login to ftp server for security purpose. So, let us create a normal testing user called “`ftpuser`” with password “centos”.
```bash
useradd ftpuser
passwd ftpuser
```

## Connecting to FTP server

Now, try to connect to FTP server itself with user “`ftpuser`”:
```bash
ftp 192.168.3.157
```
Enter the ftp user name and password.  
Note: change `192.168.3.157` with your own FTP server address.

Sample Output:
```bash
onnected to 192.168.3.157.
220 (vsFTPd 3.0.2)
Name (192.168.3.157:jarson): ftpuser
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
```
Congratulations! you will be able to login to FTP server without any problems.

## Reference

\[1]: <http://www.tutorialspoint.com/articles/how-to-install-and-configuration-ftp-server-in-centos-7>
\[2]: <https://www.unixmen.com/install-configure-ftp-server-centos-7/>
