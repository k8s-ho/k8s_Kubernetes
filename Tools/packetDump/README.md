# required_installation.sh
  
I made it because I wanted to dump packets in kubernetes:)

---

### Usage: 
git clone https://github.com/k8s-ho/k8s_Kubernetes  
cd k8s_Kubernetes/Tools/packetDump/   
chmod +x required_installation.sh  
./required_installation.sh && make  
./packetDump [interface]  

### Make file usage:
__Compile & Build:__ make  
__Delete OBJ file:__ make clean  

---

### [Debian] Preview the installation package:   
__Update:__ apt update  
__Install Libpcap:__ apt-get install libpcap-dev  
__Install Make:__ apt-get install make  
__Install g++:__ apt-get install g++   
  


