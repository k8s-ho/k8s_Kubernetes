# imageChecker.sh
  
I made it because I wanted to integrate and check the Kubernetes cluster's pod information, container image information and download the image file.
You can also check container images where vulnerabilities exist :)

---

### Usage:  
git clone https://github.com/k8s-ho/k8s_Kubernetes    
cd k8s_Kubernetes/Tools/imaegChecker/   
chmod +x imageChecker.sh, setup_imageChecker.sh    
./setup_imageChecker.sh    
./imageChecker.sh 
  
---
  
# setup_imageChecker.sh  
### [Debian] Preview the installation package:   
__Update:__     
apt update   

__Install Docker:__      
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin   

__Install Trivy:__   
apt-get install wget apt-transport-https gnupg lsb-release -y    
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -     
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list    
apt update && apt-get install trivy. 
