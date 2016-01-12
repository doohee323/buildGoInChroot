#!/usr/bin/env bash

export BASEDIR=`pwd`
export UBUNTU_VERSION=$1
export BUILD=$2

if [[ $# -eq 0 ]];
 then
 UBUNTU_VERSION="precise"
 BUILD="0.0.1"
fi

echo "=[build $UBUNTU_VERSION in ~/chroot/$UBUNTU_VERSION]==============================================================="
echo "BASEDIR: $BASEDIR"
echo "UBUNTU_VERSION: $UBUNTU_VERSION"
echo "BUILD: $BUILD"

sudo umount ~/chroot/$UBUNTU_VERSION/proc
sudo umount ~/chroot/$UBUNTU_VERSION/sys
#sudo umount ~/chroot/$UBUNTU_VERSION/dev
#sudo umount ~/chroot/$UBUNTU_VERSION/dev/shm

sudo rm -Rf ~/chroot/$UBUNTU_VERSION
sudo mkdir -p ~/chroot/$UBUNTU_VERSION

sudo debootstrap --variant=buildd --arch amd64 $UBUNTU_VERSION ~/chroot/$UBUNTU_VERSION http://archive.ubuntu.com/ubuntu

sudo mount -o bind /proc ~/chroot/$UBUNTU_VERSION/proc
sudo mount -o bind /sys ~/chroot/$UBUNTU_VERSION/sys
#sudo mount -o bind /dev ~/chroot/$UBUNTU_VERSION/dev
#sudo mount -o bind /dev/shm ~/chroot/$UBUNTU_VERSION/dev/shm

echo "=[copy hello]====================================================================================="
echo "rm -Rf ~/chroot/$UBUNTU_VERSION/hello"
sudo rm -Rf ~/chroot/$UBUNTU_VERSION/hello

sudo mkdir -p ~/chroot/$UBUNTU_VERSION/hello
echo "sudo cp -Rf $BASEDIR/* ~/chroot/$UBUNTU_VERSION/hello"
sudo cp -Rf $BASEDIR/* ~/chroot/$UBUNTU_VERSION/hello

echo "sudo cp $BASEDIR/chroot_hello.sh ~/chroot/$UBUNTU_VERSION/hello"
sudo cp $BASEDIR/chroot_hello.sh ~/chroot/$UBUNTU_VERSION/hello

sudo chmod 777 ~/chroot/$UBUNTU_VERSION/hello/chroot_hello.sh

sudo cp /etc/hosts ~/chroot/$UBUNTU_VERSION/etc/hosts
sudo cp /etc/resolv.conf ~/chroot/$UBUNTU_VERSION/etc/resolv.conf

echo "sudo chroot ~/chroot/$UBUNTU_VERSION"
sudo chroot ~/chroot/$UBUNTU_VERSION /bin/bash -c "cd /hello; bash chroot_hello.sh $UBUNTU_VERSION $BUILD"

exit 0




