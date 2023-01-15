#/bin/bash
apt update && apt-get install docker-ce docker-ce-cli docker-compose-plugin -y
apt install jq
systemctl restart docker
chmod +x layerSummary.sh
clear
echo "[*] layerSummary setup installation is complete!! @IMyoungho"
echo "[?] Usage: ./layerSummary.sh"
echo "<options>"
echo "    -a     : Show all information"
echo "    -h     : Show this message."
ls
