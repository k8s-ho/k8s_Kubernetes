#!/bin/bash
ls /var/lib/docker/image/overlay2/layerdb/sha256/ > layerdb.txt

parse(){
	CHK=$(ls | grep $1.txt | wc -l)
	if [ $CHK -eq 1 ]; then
		rm -rf $1.txt
	fi 

	while read LINE; do
		cat /var/lib/docker/image/overlay2/layerdb/sha256/$LINE/$1 >> $1.txt; echo " " >> $1.txt
	done < layerdb.txt

	echo "[+] layerdb.$1 " 
	echo "[>] Path: /var/lib/docker/image/overlay2/layerdb/sha256/*/$1"
	echo "------------------------------------------------------"
	cat /root/$1.txt | sort
	echo " "
	echo " "
}

echo "[+] Real Data" 
echo "[>] Path: /var/lib/docker/overlay2/*"
echo "------------------------------------------------------"
cd /var/lib/docker/overlay2/; ls | sort
cd /root/
echo " "
echo " "

parse cache-id
parse diff

echo "[+] docker inspect RootFS info - mapping images"
echo "------------------------------------------------------"
data=$(docker inspect $(docker images -q))
for row in $(echo "${data}" | jq -r '.[] | @base64'); do
	parse2(){
		echo "${row}" | base64 -d | jq -r "${1}"
	}
	ID=$(parse2 ".Id")
	IMG=$(parse2 ".RepoTags" | tr -d " ") 
	ROOTFS=$(parse2 ".RootFS.Layers")
	echo "* ID: $ID"
  echo "* Image: $IMG" | tr -d "[]\"\n"
	echo "* RootFS Layer $ROOTFS" | tr -d "[]\"\," | sort
	echo "-----"
	echo ""
done
