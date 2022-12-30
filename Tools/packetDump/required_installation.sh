#!/bin/bash
apt update && apt-get update && apt-get install libpcap-dev -y && apt-get install make -y && apt-get install g++ -y && make
echo "[+] packetDump installation is complete!! @IMyoungho"
echo "[+] Usage: ./packetDump [interface name] "
ls
