---
title: How to install pip
date: 2016-12-22 11:46:05
tags:
  - CentOS
  - Ubuntu
categories:
  - Estuary
  - Documents
---

Reference: <https://pip.pypa.io/en/stable/installing/>

**For Centos:**
```bash
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

**For Ubuntu:**  
use the same commands as for Centos, or use the following commad:
```bash
sudo apt-get install python-pip
```
**Verify The Installation:**  
View a list of helpful commands:
```bash
pip --help
```
Check the version of Pip that is installed:
```bash
pip -V
```
Which should yield something similar to:
```
pip 8.1.1 from /usr/lib/python2.7/dist-packages (python 2.7)
```
