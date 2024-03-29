# imageChecker.sh
  
I made it because I wanted to integrate and check the Kubernetes cluster's pod information, container image information and download the image file.
You can also check container images where vulnerabilities exist :)

---

### Usage:  
```bash
git clone https://github.com/k8s-ho/k8s_Kubernetes    
cd k8s_Kubernetes/Tools/imageChecker/  
chmod +x setup_imageChecker.sh    
./setup_imageChecker.sh    
./imageChecker.sh 
```

---
  
# setup_imageChecker.sh  
### [Debian] Preview the installation package:   
__Update:__     
```bash
apt update   
```
__Install Docker:__    
```bash
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin   
```
__Install Trivy:__  
```bash
apt-get install wget apt-transport-https gnupg lsb-release -y    
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -     
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list    
apt update && apt-get install trivy. 
```   
__Install Whaler:__   
```bash
wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz   
tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz   
export PATH=$PATH:/usr/local/go/bin      
go get -u github.com/P3GLEG/Whaler   
cd ~/go/src/github.com/P3GLEG/Whaler   
go build   
```
