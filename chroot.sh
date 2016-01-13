#!/usr/bin/env bash

export APP=hello
export APP_DIR=`pwd`
export UBUNTU_VERSION=$1
export APP_VERSION=$2

if [[ $# -eq 0 ]];
 then
 UBUNTU_VERSION="precise"
 APP_VERSION="0.0.1"
fi

echo "=[build $UBUNTU_VERSION in ~/chroot/$UBUNTU_VERSION]==============================================================="
echo "APP_DIR: $APP_DIR"
echo "UBUNTU_VERSION: $UBUNTU_VERSION"
echo "APP_VERSION: $APP_VERSION"

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

echo "=[copy $APP]====================================================================================="
echo "rm -Rf ~/chroot/$UBUNTU_VERSION/$APP"
sudo rm -Rf ~/chroot/$UBUNTU_VERSION/$APP

sudo mkdir -p ~/chroot/$UBUNTU_VERSION/$APP
echo "sudo cp -Rf $APP_DIR/* ~/chroot/$UBUNTU_VERSION/$APP"
sudo cp -Rf $APP_DIR/* ~/chroot/$UBUNTU_VERSION/$APP

echo "sudo cp $APP_DIR/chroot_$APP.sh ~/chroot/$UBUNTU_VERSION/$APP"
sudo cp $APP_DIR/chroot_$APP.sh ~/chroot/$UBUNTU_VERSION/$APP

sudo chmod 777 ~/chroot/$UBUNTU_VERSION/$APP/chroot_$APP.sh

sudo cp /etc/hosts ~/chroot/$UBUNTU_VERSION/etc/hosts
sudo cp /etc/resolv.conf ~/chroot/$UBUNTU_VERSION/etc/resolv.conf

sudo chroot ~/chroot/$UBUNTU_VERSION /bin/bash -c "cd /$APP; bash chroot_$APP.sh $UBUNTU_VERSION $APP_VERSION"

echo "sudo chroot ~/chroot/$UBUNTU_VERSION"
sudo chroot ~/chroot/$UBUNTU_VERSION

cp ~/chroot/$UBUNTU_VERSION/$APP/builds/$APP_VERSION/$APP-$UBUNTU_VERSION-$APP_VERSION.deb .

exit 0





