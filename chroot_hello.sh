#!/bin/bash

#colors
export red='\033[0;31m'
export green='\033[0;32m'
export NC='\033[0m' # No Color

set -x 

echo "=[build hello]====================================================================================="
#gcc -v

export PATH=/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/sbin:/sbin:.:
locale-gen en_US.UTF-8
dpkg-reconfigure locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
alias ll='ls -a'

cd /hello

export BASEDIR=`pwd`
export UBUNTU_VERSION=$1
export BUILD=$2

echo "= $BASEDIR ====================================================================================="
echo "UBUNTU_VERSION: $UBUNTU_VERSION"
echo "BUILD: $BUILD"

export DEBIAN_FRONTEND=noninteractive 

echo "=[apt-get update]====================================================================================="
apt-get update
apt-get install wget -y
apt-get install git -y
apt-get install python-software-properties python-setuptools libtool autoconf automake -y
apt-get install build-essential curl libcurl4-openssl-dev apt-utils -y

echo "=[golang]====================================================================================="
wget https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz
rm go1.4.linux-amd64.tar.gz

echo "=[set env]====================================================================================="
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/repo
mkdir -p $GOPATH

echo "=[go repo]====================================================================================="
cd $GOPATH
go get -u github.com/andelf/go-curl
go get -u github.com/op/go-logging
go get -u github.com/golang/glog

cd $BASEDIR/src/hello

#what .deb we want to build
export BASE=hello

#test
cd $BASEDIR/src/$BASE
#go test 

#now we build
echo "=[build]====================================================================================="
echo go build -o $BASEDIR/bin/$BASE -ldflags "-X main.Build $BUILD" $BASEDIR/src/$BASE/$BASE.go
go build -o $BASEDIR/bin/$BASE -ldflags "-X main.Build $BUILD" $BASEDIR/src/$BASE/$BASE.go 

#now we build .deb package
rm -rf $BASEDIR/builds/$BUILD/$BASE
mkdir -p $BASEDIR/builds/$BUILD/$BASE
mkdir -p $BASEDIR/builds/$BUILD/$BASE/var/hello
mkdir -p $BASEDIR/builds/$BUILD/$BASE/etc/hello
mkdir -p $BASEDIR/builds/$BUILD/$BASE/etc/init
mkdir -p $BASEDIR/builds/$BUILD/$BASE/var/log/hello
mkdir -p $BASEDIR/builds/$BUILD/$BASE/DEBIAN/

echo "Package: $BASE" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Architecture: amd64" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Maintainer: Doohee Hong" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Depends: debconf (>= 0.5.00)" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Priority: optional" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Version: $BUILD" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
echo "Description: $BASE" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/control
 
echo "/etc/hello/$BASE.cfg" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/conffiles
echo "/etc/init/$BASE.conf" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/conffiles

echo "set -e" >> $BASEDIR/builds/$BUILD/$BASE/DEBIAN/preinst

#copy files where they need to be
cp $BASEDIR/bin/$BASE  $BASEDIR/builds/$BUILD/$BASE/var/hello/$BASE
cp $BASEDIR/etc/hello/$BASE.cfg  $BASEDIR/builds/$BUILD/$BASE/etc/hello/$BASE.cfg
cp $BASEDIR/etc/init/$BASE.conf  $BASEDIR/builds/$BUILD/$BASE/etc/init/$BASE.conf

chmod 775 $BASEDIR/builds/$BUILD/$BASE/DEBIAN/preinst

dpkg-deb --build $BASEDIR/builds/$BUILD/$BASE

ls -al $BASEDIR/builds/$BUILD

exit 0