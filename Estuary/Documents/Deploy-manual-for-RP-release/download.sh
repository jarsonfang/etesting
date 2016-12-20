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
