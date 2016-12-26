#!/bin/bash

VERSION=$1

BIN_DIR=~/bin
if [ ! -e $BIN_DIR ]; then
	mkdir -p $BIN_DIR
fi

if [ ! -e ${BIN_DIR}/repo ]; then
	wget -c http://www.open-estuary.com/EstuaryDownloads/tools/repo -O ${BIN_DIR}/repo
	chmod +x ${BIN_DIR}/repo
fi

export PATH=${BIN_DIR}:$PATH

ESTUARY_DIR=~/open-estuary
if [ ! -e $ESTUARY_DIR ]; then
	mkdir -p $ESTUARY_DIR
	cd $ESTUARY_DIR
else
	cd $ESTUARY_DIR
	repo forall -c git reset --hard
	repo forall -c git clean -dxf
fi

if [ x"$VERSION" != x"" ]; then
	repo init -u "https://github.com/open-estuary/estuary.git" -b refs/tags/$VERSION --no-repo-verify --repo-url=git://android.git.linaro.org/tools/repo
else
	repo init -u "https://github.com/open-estuary/estuary.git" -b master --no-repo-verify --repo-url=git://android.git.linaro.org/tools/repo
fi

#false; while [ $? -ne 0 ]; do repo sync --force-sync --fetch-submodules; done
false; while [ $? -ne 0 ]; do repo sync --force-sync; done
repo status
