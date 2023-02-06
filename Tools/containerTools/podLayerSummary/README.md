# Not implemented yet!!
# podLayerSummary.sh
  
This is a tool that allows you to briefly check the files, paths, Data and low-level information of Pod containers and images related to the container layer:)

---

### Usage:  
```bash
git clone https://github.com/k8s-ho/k8s_Kubernetes    
cd k8s_Kubernetes/Tools/podLayerSummary
chmod +x setup_podLayerSummary.sh
./setup_podLayerSummary.sh 
./podLayerSummary.sh

<options>
 -a     : Show all information  ex) ./podLayerSummery.sh -a
```

---

# setup_podLayerSummary.sh  
### [Debian] Preview the installation package:   
__Update:__     
```bash
apt update   
```
__Install Docker:__    
```bash
sudo apt-get -y containerd.io
```
__Install jq:__  
```bash
apt install jq
```   

---
