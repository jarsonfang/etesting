---
title: Samba on Centos 7
date: 2016-09-20 14:16:21
tags:
  - Samba
  - CentOS
categories:
  - Estuary
  - Documents
---

## Installation

```bash
yum install samba samba-client
```

<!--more-->

## Configuration

Now to configure samba, make the backup of original file as `/etc/samba/smb.conf.bak` before editing the file `/etc/samba/smb.conf`.

```bash
cp /etc/samba/smb.conf{,.bak}
```

### Anonymous samba sharing

Further give the entries like this:
```bash
cat << EOF >> /etc/samba/smb.conf
[share]
    comment = Anonymous share
    path = /srv/samba/share
    public = yes
    browsable =yes
    writable = yes
    guest ok = yes
    read only = no
EOF
```
Create the folder with the name `share` in the `/srv/samba` and give the permissions like this:
```bash
mkdir -p /srv/samba/share
cd /srv/samba
chmod -R 0755 share/
chown -R nobody:nobody share/
```
Restart samba service:
```bash
systemctl enable smb.service
systemctl restart smb.service
```
Further, CentOS 7.0 Firewall-cmd will block the samba access, to get rid of that we will run:
```bash
firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload
```

### Secured samba server

Therefore, create a group `smbgrp` & user `smb` to access the samba server with proper authentication.
```bash
groupadd smbgrp
useradd smb -G smbgrp
```
```bash
[root@cent-est samba]# smbpasswd -a smb
New SMB password:<--yoursambapassword
Retype new SMB password:<--yoursambapassword
Added user smb.
[root@cent-est samba]#
```
Now create the folder with the name `secured` in the `/samba` folder and give permissions like this:
```bash
mkdir -p /srv/samba/secured
cd /srv/samba
chmod -R 0777 secured/
chown -R smb:smbgrp secured/
```
Again edit the configuration file as:
```bash
cat << EOF >> /etc/samba/smb.conf
[secured]
    comment = Secured share
    path = /srv/samba/secured
    valid users = @smbgrp
    guest ok = no
    writable = yes
    browsable = yes
EOF
```
Restart samba service:
```bash
systemctl restart smb.service
```
### Check the settings as follows:
```bash
[root@cent-est ~]# testparm
Load smb config files from /etc/samba/smb.conf
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
Processing section "[homes]"
Processing section "[printers]"
Processing section "[share]"
Processing section "[secured]"
Loaded services file OK.
Server role: ROLE_STANDALONE

Press enter to see a dump of your service definitions

# Global parameters
[global]
        workgroup = MYGROUP
        server string = Samba Server Version %v
        security = USER
        log file = /var/log/samba/log.%m
        max log size = 50
        idmap config * : backend = tdb
        cups options = raw


[homes]
        comment = Home Directories
        read only = No
        browseable = No


[printers]
        comment = All Printers
        path = /var/spool/samba
        printable = Yes
        print ok = Yes
        browseable = No


[share]
        comment = Anonymous share
        path = /srv/samba/share
        read only = No
        guest ok = Yes


[secured]
        comment = Secured share
        path = /srv/samba/secured
        valid users = @smbgrp
        read only = No
[root@cent-est ~]#
```

## Test with smbclient

```
[root@cent-est ~]# smbclient //localhost/share -U user
Enter user's password:<--Enter
Anonymous login successful
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.2.10]
smb: \> ls
  .                                   D        0  Thu Sep 29 15:06:51 2016
  ..                                  D        0  Thu Sep 29 14:25:32 2016
  hello.txt                           N        0  Thu Sep 29 15:06:51 2016

                51475068 blocks of size 1024. 37599412 blocks available
smb: \> exit
[root@cent-est ~]#
[root@cent-est ~]# smbclient //localhost/secured -U user
Enter user's password:<--Enter
Anonymous login successful
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.2.10]
tree connect failed: NT_STATUS_ACCESS_DENIED
[root@cent-est ~]#
[root@cent-est ~]# smbclient //localhost/secured -U smb
Enter smb's password:
Domain=[MYGROUP] OS=[Windows 6.1] Server=[Samba 4.2.10]
smb: \> ls
  .                                   D        0  Thu Sep 29 15:06:42 2016
  ..                                  D        0  Thu Sep 29 14:25:32 2016
  file.txt                            N        0  Thu Sep 29 15:06:42 2016

                51475068 blocks of size 1024. 37599408 blocks available
smb: \> exit
[root@cent-est ~]#
```

## Reference

\[1]: <https://www.howtoforge.com/samba-server-installation-and-configuration-on-centos-7>  
\[2]: <https://www.samba.org/samba/docs/man/Samba-HOWTO-Collection/>
