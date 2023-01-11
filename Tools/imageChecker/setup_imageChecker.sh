#/bin/bash
apt update && apt-get install docker-ce docker-ce-cli docker-compose-plugin -y
apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt update && apt-get install trivy
systemctl restart docker
chmod +x imageChecker.sh
wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go get -u github.com/P3GLEG/Whaler
cd ~/go/src/github.com/P3GLEG/Whaler
go build
clear
echo "[*] imageChecker setup installation is complete!! @IMyoungho"
echo "[?] Usage: ./imageChecker.sh"
ls
