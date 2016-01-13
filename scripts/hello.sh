#!/usr/bin/env bash

set -x

echo "Reading config...." >&2
source /vagrant/setup.rc

echo "=[apt-get update]====================================================================================="
apt-get update
apt-get install wget -y
apt-get install git -y
apt-get -y install git-core		# for lucid
apt-get install python-software-properties python-setuptools libtool autoconf automake -y
apt-get install build-essential curl libcurl4-openssl-dev apt-utils -y

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

cd /vagrant
dpkg -i hello_lucid.deb
export PATH=$PATH:/var/hello
# dpkg -l | grep hello

hello server
# open another terminal and run hello with client argument.
# $ vagrant ssh
# hello client
# it works! but,

# When you install hello_precise.deb in lucid, you'll get this error! 
# dpkg -i hello_precise.deb
# vagrant@hello:/vagrant$ hello server
# hello: /lib/libc.so.6: version `GLIBC_2.14' not found (required by hello)

exit 0


  