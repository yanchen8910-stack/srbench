#!/bin/bash
#install ellyn
rm -rf ellyn
git clone https://github.com/cavalab/ellyn
cd ellyn
git checkout cdff25b2851d942db1cdb2a6796ea61c41396c7c

# force-link boost headers and libs from package cache
BOOST_CPP_PKG=$(find /opt/conda/pkgs -maxdepth 1 -name "boost-cpp-1.74*" -type d | head -1)
BOOST_PY_PKG=$(find /opt/conda/pkgs -maxdepth 1 -name "boost-1.74*" -type d | head -1)

echo "boost-cpp pkg: $BOOST_CPP_PKG"
echo "boost-py pkg: $BOOST_PY_PKG"

cp -rn $BOOST_CPP_PKG/include/boost /opt/conda/include/ 2>/dev/null || true
cp -rn $BOOST_PY_PKG/include/boost /opt/conda/include/ 2>/dev/null || true
cp -n $BOOST_CPP_PKG/lib/libboost* /opt/conda/lib/ 2>/dev/null || true
cp -n $BOOST_PY_PKG/lib/libboost* /opt/conda/lib/ 2>/dev/null || true

echo "=== checking boost ===" 
ls /opt/conda/include/boost/python.hpp && echo "headers OK" || echo "headers NOT FOUND"
ls /opt/conda/lib/libboost_python39* && echo "libs OK" || echo "libs NOT FOUND"

source /opt/conda/etc/profile.d/mamba.sh
micromamba activate base

/opt/conda/bin/python setup.py install