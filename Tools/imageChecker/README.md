# imageChecker.sh
  
I made it because I wanted to integrate and check the Kubernetes cluster's pod information, container image information and download the image file :)

---

### Usage: 
systemctl start docker
git clone https://github.com/k8s-ho/k8s_Kubernetes  
cd k8s_Kubernetes/Tools/imaegChecker/   
chmod +x imageChecker.sh  
./imageChecker.sh 

### [Debian] Preview the installation package:   
__Update:__ apt update  
__Install Docker:__ apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin 
