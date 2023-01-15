#!/bin/bash
# option description
usage()
{
	echo "<options>"
	echo "    -a     : Show all information"
	echo "    -h     : Show this message."
	exit 100
}

# show all data
showAll(){
	parse(){
		while read LINE; do
			cat /var/lib/docker/image/overlay2/layerdb/sha256/$LINE/$1 >> ./result_file/$1.txt; echo " " >> ./result_file/$1.txt
		done < ./result_file/layerdb.txt
	
		echo "[+] layerdb.$1 " 
		echo "[>] Path: /var/lib/docker/image/overlay2/layerdb/sha256/*/$1"
		echo "------------------------------------------------------"
		cat ./result_file/$1.txt | sort
		echo " "
		echo " "
	}
	
	echo "[+] Real Data" 
	echo "[>] Path: /var/lib/docker/overlay2/*"
	echo "------------------------------------------------------"
	ls /var/lib/docker/overlay2 | sort
	echo " "
	echo " "
	
	parse cache-id
	parse diff
}

# Run option 
while getopts ah opts; do
        case $opts in
        a) showAll
                ;;
        h) usage
                ;;
        esac
done

# chekcing docker image & result_file exist
PROC_CHK=$(docker images | wc -l)
if [ $PROC_CHK -le 1 ]; then
	echo "[!] Error: Check if the docker image exists"
	exit 100
fi 
CHK=$(ls | grep -i result_file | wc -l)
if [ $CHK -eq 1 ]; then
	rm -rf result_file
fi 

# Extract layer from docker inspect
mkdir result_file
ls /var/lib/docker/image/overlay2/layerdb/sha256/ > ./result_file/layerdb.txt
echo " "
echo "[+] docker layers infomation - mapping images"
echo "------------------------------------------------------"
data=$(docker inspect $(docker images -q))
for row in $(echo "${data}" | jq -r '.[] | @base64'); do
	parse2(){
		echo "${row}" | base64 -d | jq -r "${1}"
	}
	ID=$(parse2 ".Id")
	IMG=$(parse2 ".RepoTags" | tr -d " ") 
	ROOTFS=$(parse2 ".RootFS.Layers")
	LOWER=$(parse2 ".GraphDriver.Data.LowerDir")
	UPPER=$(parse2 ".GraphDriver.Data.UpperDir")
	MERGE=$(parse2 ".GraphDriver.Data.MergedDir")
 
  echo "* Image: $IMG" | tr -d "[]\""
	echo "* Image ID: $ID" | tr -d "\n"
	echo "* RootFS Layer $ROOTFS" | tr -d "[]\"\," | sort
	echo " "
	echo "* LowerDir "
	echo "$LOWER" | sed 's/\:/\n/g' | sort | tr -d '"' 
	echo " "
	echo "* UpperDir "
	echo "$UPPER" | tr -d '"' 
	echo " "
	echo "* MergedDir"
	echo "$MERGE" | tr -d '"' 
	echo "-----"
done
