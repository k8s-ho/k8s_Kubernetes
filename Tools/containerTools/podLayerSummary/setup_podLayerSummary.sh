#!/bin/bash
sudo apt-get update
sudo apt-get -y containerd.io
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml 
sudo systemctl restart containerd

cat <<EOF > /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock 
EOF


sudo apt install jq
sudo systemctl restart docker
sudo chmod +x podLayerSummary.sh
clear
echo "[*] podLayerSummary setup installation is complete!! @IMyoungho"
echo "[?] Usage: ./podLayerSummary.sh"
echo "<options>"
echo "    -a     : Show all information"
echo "    -f     : Filter and Show. ./podLayerSummary.sh -f [Container ID]"
echo "    -h     : Show this message."
echo "------------------------------------------------------------"
ls
