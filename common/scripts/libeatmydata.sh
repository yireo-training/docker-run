#!/bin/bash
apt-get update
apt-get install wget make gcc strace

wget https://www.flamingspork.com/projects/libeatmydata/libeatmydata-105.tar.gz
tar -xzvf libeatmydata-105.tar.gz
cd libeatmydata-105

./configure
make
make check
make install
