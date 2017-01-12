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
