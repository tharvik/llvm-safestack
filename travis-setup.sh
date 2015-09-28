#!/bin/sh

set +eux

# upgrade gcc version
add-apt-repository -y ppa:h-rayflood/gcc-upper
apt-get remove -y postgresql-9.[234] > /dev/null
apt-get update -qq
yes | apt-get -y -qq dist-upgrade
apt-get -y -qq install gcc-4.8 g++-4.8

# install newer cmake
wget http://www.cmake.org/files/v3.3/cmake-3.3.1.tar.gz
tar xf cmake-*.tar.gz
mv cmake-*/ cmake
cd cmake
./bootstrap --parallel=2 --prefix=root > /dev/null
make -j2
make install > /dev/null
cd ..
