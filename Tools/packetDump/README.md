# packetDump
  
I made it because I wanted to dump packets in kubernetes:)

---

### Usage: 
```bash
git clone https://github.com/k8s-ho/k8s_Kubernetes  
cd k8s_Kubernetes/Tools/packetDump/   
chmod +x setup_packetDump.sh  
./setup_packetDump.sh && make  
./packetDump [interface]  
```

### Make file usage:
__Compile & Build:__ 
```bash
make
```
__Delete OBJ file:__ 
```bash
make clean  
```
---
# setup_packetDump.sh
### [Debian] Preview the installation package:   
__Update:__ 
```bash
apt update  
```
__Install Libpcap:__ 
```bash
apt-get install libpcap-dev  
```
__Install Make:__ 
```bash
apt-get install make  
```
__Install g++:__ 
```bash
apt-get install g++  
```
  


