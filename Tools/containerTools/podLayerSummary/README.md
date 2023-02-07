# podLayerSummary.sh
  
This is a tool that allows you to briefly check the data paths, PID information of Pod containers related to the container layer:)  
You can see at a glance which directory in the overlay path is related to which container in which Pod.
```bash    
/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots
```
<img width="651" alt="스크린샷 2023-02-07 오후 2 38 59" src="https://user-images.githubusercontent.com/118821939/217158030-c394dcf7-2fdf-4f68-9519-930d437eb7e4.png">



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
