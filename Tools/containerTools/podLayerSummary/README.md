# Not implemented yet!!
# podLayerSummary.sh
  
This is a tool that allows you to briefly check the data paths, PID information of Pod containers related to the container layer:)

---

### Usage:  
```bash
git clone https://github.com/k8s-ho/k8s_Kubernetes    
cd k8s_Kubernetes/Tools/containerTools/podLayerSummary
chmod +x setup_podLayerSummary.sh
./setup_podLayerSummary.sh 
./podLayerSummary.sh


<options> default: Show all information
 -f     : Only filtered containers are shown  ex) ./podLayerSummary.sh -f [Container ID]
 -h     : Show this message
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
