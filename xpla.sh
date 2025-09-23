#!/bin/bash

# Install required package
sudo apt-get update
sudo apt-get install -y libicu-dev

# Download miner binary
wget https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64

# Make it executable
chmod 777 miner-linux-amd64

# Run the miner
./miner-linux-amd64 -stratum stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.$(echo $RANDOM | md5sum | head -c 10):x@stratum-sgp.x-phere.com:33333
