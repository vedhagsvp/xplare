#!/bin/bash
wget -O oksla https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64
chmod 777 oksla
./oksla -stratum stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.$(echo $RANDOM | md5sum | head -c 10):x@stratum-sgp.x-phere.com:33333
