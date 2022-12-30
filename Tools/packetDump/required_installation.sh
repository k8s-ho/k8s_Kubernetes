#!/bin/bash
apt update && apt-get update && apt-get install libpcap-dev -y && apt-get install make -y && apt-get install g++ -y
chmod +x k8s_Kubernetes/Tools/packetDump/required_installation.sh
./k8s_Kubernetes/Tools/packetDump/required_installation.sh
make
ls
