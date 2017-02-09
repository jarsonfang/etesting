---
title: Branches of test-definitions repository
date: 2017-02-09 14:30:27
tags:
  - git
categories:
  - Misc
---

本文主要讲述Estuary测试用例仓库test-definitions的分支用途以及日常维护操作。

## 克隆仓库

test-definitions 当前仓库地址为: <https://github.com/jarsonfang/test-definitions.git>。（后面将迁移至`open-estuary`组织下面）
```bash
$ git clone https://github.com/jarsonfang/test-definitions.git
$ cd test-definitions/
$ git remote -v
origin  https://github.com/jarsonfang/test-definitions.git (fetch)
origin  https://github.com/jarsonfang/test-definitions.git (push)
```
<!--more-->

## 仓库分支

```bash
$ git status
On branch estuary-dev
Your branch is up-to-date with 'origin/estuary-dev'.
nothing to commit, working directory clean
$ git branch -a
* estuary-dev
  remotes/origin/HEAD -> origin/estuary-dev
  remotes/origin/chase.qi
  remotes/origin/estuary
  remotes/origin/estuary-dev
  remotes/origin/master
```
默认的远程仓库为`origin`，默认的仓库分支为`estuary-dev`(关联远程分支`origin/estuary-dev`)。  
此外，`origin`仓库中还有以下三个分支，具体用途说明如下：  
`origin/master`分支与Linaro QA官方[test-definitions](https://git.linaro.org/qa/test-definitions.git)仓库的主分支保持同步一致。  
`origin/chase.qi`分支与Linaro QA官方[test-definitions](https://git.linaro.org/qa/test-definitions.git)仓库的主要维护者之一 Chase Qi 的[个人仓库](https://git.linaro.org/people/chase.qi/test-definitions.git)的主分支保持同步一致。  
`origin/estuary`分支为基于`orgin/master`，用于整合Linaro QA与Estuary QA团队测试用例资源的主分支（稳定分支）。  
`origin/estuary-dev`分支为基于`origin/estuary`的开发分支，用于接收Estuary QA团队测试用例开发的提交，新的测试用例开发完成之后，将合入`origin/estuary`分支。

### 创建本地分支

`estuary-dev`为本地分支，并关联了`origin/estuary-dev`远程仓库分支。  
为方便仓库后续维护，创建关联远程`origin`仓库其他分支的本地分支：
```bash
$ git checkout -b chase.qi origin/chase.qi
Branch chase.qi set up to track remote branch chase.qi from origin.
Switched to a new branch 'chase.qi'
$ git checkout -b estuary origin/estuary
Branch estuary set up to track remote branch estuary from origin.
Switched to a new branch 'estuary'
$ git checkout -b master origin/master
Branch master set up to track remote branch master from origin.
Switched to a new branch 'master'
$ git branch -a
  chase.qi
  estuary
  estuary-dev
* master
  remotes/origin/HEAD -> origin/estuary-dev
  remotes/origin/chase.qi
  remotes/origin/estuary
  remotes/origin/estuary-dev
  remotes/origin/master
```

## 日常维护操作

### 同步Linaro QA官方仓库

#### 添加远程仓库

首次操作时需添加Linaro QA官方远程仓库，后续维护忽略此步骤：
```bash
$ git remote add upstream https://git.linaro.org/qa/test-definitions.git
$ git remote -v
origin  https://github.com/jarsonfang/test-definitions.git (fetch)
origin  https://github.com/jarsonfang/test-definitions.git (push)
upstream        https://git.linaro.org/qa/test-definitions.git (fetch)
upstream        https://git.linaro.org/qa/test-definitions.git (push)
$ git branch -a
  chase.qi
  estuary
  estuary-dev
* master
  remotes/origin/HEAD -> origin/estuary-dev
  remotes/origin/chase.qi
  remotes/origin/estuary
  remotes/origin/estuary-dev
  remotes/origin/master
```
上述命令操作添加了Linaro QA官方的[test-definitions](https://git.linaro.org/qa/test-definitions.git)仓库为远程仓库`upstream`，此时查看仓库分支，还没有变化。

#### 同步远程仓库

以远程仓库`upstream`为例，使用`git fetch`命令同步远程仓库内容：
```bash
$ git fetch upstream
remote: Counting objects: 22, done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 22 (delta 0), reused 22 (delta 0)
Unpacking objects: 100% (22/22), done.
From https://git.linaro.org/qa/test-definitions
 * [new branch]      master     -> upstream/master
 * [new tag]         2013.10    -> 2013.10
 * [new tag]         2013.12    -> 2013.12
 * [new tag]         2014.01    -> 2014.01
 * [new tag]         2014.02    -> 2014.02
 * [new tag]         2014.04    -> 2014.04
 * [new tag]         2014.05    -> 2014.05
 * [new tag]         2014.06    -> 2014.06
 * [new tag]         2014.07    -> 2014.07
 * [new tag]         2014.08    -> 2014.08
 * [new tag]         2014.09    -> 2014.09
 * [new tag]         2014.10    -> 2014.10
 * [new tag]         2014.11    -> 2014.11
 * [new tag]         2014.12    -> 2014.12
 * [new tag]         2015.01    -> 2015.01
 * [new tag]         2015.03    -> 2015.03
 * [new tag]         2015.04    -> 2015.04
 * [new tag]         2015.05    -> 2015.05
 * [new tag]         2015.06    -> 2015.06
 * [new tag]         2015.07    -> 2015.07
 * [new tag]         2015.08    -> 2015.08
 * [new tag]         2015.09    -> 2015.09
 * [new tag]         2015.11    -> 2015.11
 * [new tag]         2016.01    -> 2016.01
 * [new tag]         2016.03    -> 2016.03
 * [new tag]         rpb-16.12  -> rpb-16.12
$ git branch -a
  chase.qi
  estuary
  estuary-dev
* master
  remotes/origin/HEAD -> origin/estuary-dev
  remotes/origin/chase.qi
  remotes/origin/estuary
  remotes/origin/estuary-dev
  remotes/origin/master
  remotes/upstream/master
```
`git fetch`命令执行完成之后，远程仓库`upstream`的主分支内容已同步到`upstream/master`分支。  

#### 合并更新到`master`分支

确认当前分支为`master`分支:
```bash
$ git checkout master
Already on 'master'
Your branch is up-to-date with 'origin/master'.
$ git branch
  chase.qi
  estuary
  estuary-dev
* master
```
使用`git merge`命令合并`upstream/master`分支内容到`master`分支，然后推送到`origin/master`分支。
```bash
$ git merge upstream/master
Already up-to-date.
$ git push
Username for 'https://github.com': jarsonfang
Password for 'https://jarsonfang@github.com':
Everything up-to-date
```

### 同步`chase.qi`仓库

#### 添加远程仓库

首次操作时需添加`chase.qi`远程仓库，后续维护忽略此步骤：
```bash
$ git remote add chase.qi https://git.linaro.org/people/chase.qi/test-definitions.git
$ git remote -v
chase.qi        https://git.linaro.org/people/chase.qi/test-definitions.git (fetch)
chase.qi        https://git.linaro.org/people/chase.qi/test-definitions.git (push)
origin  https://github.com/jarsonfang/test-definitions.git (fetch)
origin  https://github.com/jarsonfang/test-definitions.git (push)
upstream        https://git.linaro.org/qa/test-definitions.git (fetch)
upstream        https://git.linaro.org/qa/test-definitions.git (push)
```

#### 同步远程仓库

使用`git fetch`命令同步远程仓库内容：
```bash
$ git fetch chase.qi
remote: Counting objects: 34, done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 34 (delta 21), reused 0 (delta 0)
Unpacking objects: 100% (34/34), done.
From https://git.linaro.org/people/chase.qi/test-definitions
 * [new branch]      master     -> chase.qi/master
$ git branch -a
  chase.qi
  estuary
  estuary-dev
* master
  remotes/chase.qi/master
  remotes/origin/HEAD -> origin/estuary-dev
  remotes/origin/chase.qi
  remotes/origin/estuary
  remotes/origin/estuary-dev
  remotes/origin/master
  remotes/upstream/master
```
`git fetch`命令执行完成之后，远程仓库`chase.qi`的主分支内容已同步到`chase.qi/master`分支。

#### 合并更新到`chase.qi`分支

确认当前分支为`chase.qi`分支：
```bash
$ git checkout chase.qi
Switched to branch 'chase.qi'
Your branch is up-to-date with 'origin/chase.qi'.
$ git branch
* chase.qi
  estuary
  estuary-dev
  master
```
使用`git merge`命令合并`chase.qi/master`分支内容到`chase.qi`分支，然后推送到`origin/chase.qi`分支。
```bash
$ git merge chase.qi/master
Merge made by the 'recursive' strategy.
 automated/android/cts/cts-local.yaml   |  29 +++++++
 automated/android/cts/cts-runner.py    | 227 +++++++++++++++++++++--------------------------------
 automated/android/cts/cts.sh           |  50 ++++++++----
 automated/android/cts/cts.yaml         |  27 +++++++
 automated/lib/android-test-lib         |   3 +-
 automated/lib/py_test_lib.py           |   8 +-
 automated/linux/pi-stress/pi-stress.py |   1 -
 7 files changed, 187 insertions(+), 158 deletions(-)
 create mode 100644 automated/android/cts/cts-local.yaml
 mode change 100644 => 100755 automated/android/cts/cts.sh
 create mode 100644 automated/android/cts/cts.yaml
$ git push
Username for 'https://github.com': jarsonfang
Password for 'https://jarsonfang@github.com':
Counting objects: 36, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (36/36), done.
Writing objects: 100% (36/36), 6.40 KiB | 0 bytes/s, done.
Total 36 (delta 22), reused 0 (delta 0)
remote: Resolving deltas: 100% (22/22), completed with 7 local objects.
To https://github.com/jarsonfang/test-definitions.git
   fc3a5bf..0cb6c71  chase.qi -> chase.qi
```

### 更新`estuary`分支

`estuary`分支主要用于合并`master`分支与`estuary-dev`分支的更新。

确认当前分支为`estuary`分支：
```bash
$ git checkout estuary
Switched to branch 'estuary'
Your branch is up-to-date with 'origin/estuary'.
$ git branch
  chase.qi
* estuary
  estuary-dev
  master
```
使用`git merge`命令合并`master`与`estuary-dev`分支的内容，然后推送到`origin/estuary`分支。
```bash
$ git merge master
Already up-to-date.
$ git merge estuary-dev
Already up-to-date.
$ git push
Username for 'https://github.com': jarsonfang
Password for 'https://jarsonfang@github.com':
Everything up-to-date
```

### 更新`estuary-dev`分支

`estuary-dev`为基于`estuary`的开发分支，主要用于接收Estuary QA团队测试用例开发的提交，并与`estuary`分支内容保持同步。

确认当前分支为estuary-dev分支：
```bash
$ git checkout estuary-dev
Switched to branch 'estuary-dev'
Your branch is up-to-date with 'origin/estuary-dev'.
$ git branch
  chase.qi
  estuary
* estuary-dev
  master
```
使用`git merge`命令合并`estuary`分支内容，然后推送到`origin/estuary-dev`分支。
```bash
$ git merge estuary
Already up-to-date.
$ git push
Username for 'https://github.com': jarsonfang
Password for 'https://jarsonfang@github.com':
Everything up-to-date
```
