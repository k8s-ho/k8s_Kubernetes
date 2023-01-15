# layerSummary.sh
  
This is a tool that allows you to briefly check the files, paths, and low-level information of containers and images related to the container layer :)

---

### Usage:  
```bash
git clone https://github.com/k8s-ho/k8s_Kubernetes    
cd k8s_Kubernetes/Tools/containerTools  
chmod +x setup_layerSummary.sh
./setup_layerSummary.sh 
./layerSummary.sh
```

---

# setup_layerSummary.sh  
### [Debian] Preview the installation package:   
__Update:__     
```bash
apt update   
```
__Install Docker:__    
```bash
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin   
```
__Install jq:__  
```bash
apt install jq
```   

---
