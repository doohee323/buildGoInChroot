#!/bin/bash

export PATH=/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/usr/sbin:/sbin:.:
locale-gen en_US.UTF-8
dpkg-reconfigure locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
alias ll='ls -a'

export APP=hello
export APP_DIR=`pwd`
export UBUNTU_VERSION=$1
export APP_VERSION=$2

echo "=[build $APP]====================================================================================="
#gcc -v

cd /$APP

echo "= $APP_DIR ====================================================================================="
echo "UBUNTU_VERSION: $UBUNTU_VERSION"
echo "APP_VERSION: $APP_VERSION"

export DEBIAN_FRONTEND=noninteractive 

echo "=[apt-get update]====================================================================================="
apt-get update
apt-get install wget -y
apt-get install git -y
apt-get -y install git-core		# for lucid
apt-get install python-software-properties python-setuptools libtool autoconf automake -y
apt-get install build-essential curl libcurl4-openssl-dev apt-utils -y

echo "=[golang]====================================================================================="
wget https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz --no-check-certificate
tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz
rm go1.4.linux-amd64.tar.gz

echo "=[zeromq]====================================================================================="
wget http://download.zeromq.org/zeromq-3.2.5.tar.gz
tar -zxvf zeromq-3.2.5.tar.gz
rm zeromq-3.2.5.tar.gz
cd zeromq-3.2.5
./configure
make
make install
ldconfig
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

echo "=[set env]====================================================================================="
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/repo
mkdir -p $GOPATH

echo "=[go repo]====================================================================================="
cd $GOPATH
go get -u github.com/andelf/go-curl
go get -u github.com/op/go-logging
go get -u github.com/golang/glog
go get -tags zmq_3_x github.com/alecthomas/gozmq

cd $APP_DIR/src/$APP

#test
cd $APP_DIR/src/$APP
#go test 

#now we build
echo "=[build]====================================================================================="
echo go build -o $APP_DIR/bin/$APP -ldflags "-X main.Build $APP_VERSION" $APP_DIR/src/$APP/$APP.go
go build -o $APP_DIR/bin/$APP -ldflags "-X main.Build $APP_VERSION" $APP_DIR/src/$APP/$APP.go 

#now we build .deb package
rm -rf $APP_DIR/builds/$APP_VERSION/$APP
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP/var/$APP
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP/etc/$APP
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP/etc/init
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP/var/log/$APP
mkdir -p $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/

echo "Package: $APP" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Architecture: amd64" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Maintainer: Doohee Hong" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Depends: debconf (>= 0.5.00)" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Priority: optional" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Version: $APP_VERSION" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
echo "Description: $APP" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/control
 
echo "/etc/$APP/$APP.cfg" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/conffiles
echo "/etc/init/$APP.conf" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/conffiles

echo "#!/bin/sh" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst
echo "set -e" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst

# preinstall stop break chef updates
#make sure you restart instead
echo "if [ \"\$(pidof $APP)\" ] " >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst
echo "then" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst
echo " echo \"stoping $APP \"" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst
echo " /sbin/stop $APP" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst
echo "fi" >> $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst

#copy files where they need to be
cp $APP_DIR/bin/$APP  $APP_DIR/builds/$APP_VERSION/$APP/var/$APP/$APP
cp $APP_DIR/etc/$APP/$APP.cfg  $APP_DIR/builds/$APP_VERSION/$APP/etc/$APP/$APP.cfg
cp $APP_DIR/etc/init/$APP.conf  $APP_DIR/builds/$APP_VERSION/$APP/etc/init/$APP.conf

chmod 775 $APP_DIR/builds/$APP_VERSION/$APP/DEBIAN/preinst

dpkg-deb --build $APP_DIR/builds/$APP_VERSION/$APP
mv $APP_DIR/builds/$APP_VERSION/$APP.deb $APP_DIR/builds/$APP_VERSION/$APP-$UBUNTU_VERSION-$APP_VERSION.deb

ls -al $APP_DIR/builds/$APP_VERSION

exit 0