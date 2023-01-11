#!/bin/bash
POD_COUNT=$(kubectl get pod -A -o jsonpath='{.items[*].metadata.name}' | sed 's/ /\n/g' | wc -w) # Pod의 갯수 변수저장 -> Pod 명을 같을 수 없음
N_IMAGE_COUNT=$(kubectl get pod -A -o jsonpath='{.items[*].spec.containers[*].image}' | sed 's/ /\n/g' | sort | uniq | wc -w) # Image의 갯수 변수 저장 -> 중복이 있을 수 있으니 제거
D_IMAGE_COUNT=$(kubectl get pod -A -o jsonpath='{.items[*].status.containerStatuses[*].imageID}' | sed 's/ /\n/g' | sort | uniq | wc -w) # Image의 갯수 변수 저장 -> 중복이 있을 수 있으니 제거


echo "[+] Pod name List / Total: $POD_COUNT" # Pod 리스트와 Pod 갯수 출력
kubectl get pod -A -o jsonpath='{.items[*].metadata.name}' | sed 's/ /\n/g' | sort
echo " "
echo "---------------------------------------------"
echo "[+] Image Name List / Total(No duplicate): $N_IMAGE_COUNT" # Image 리스트와 Image 갯수 출력
kubectl get pod -A -o jsonpath='{.items[*].spec.containers[*].image}' | sed 's/ /\n/g' | sort | uniq
echo " "
echo "---------------------------------------------"
echo "[+] Image Digest List / Total(No Duplicate): $D_IMAGE_COUNT" # Image 리스트와 Image 갯수 출력
kubectl get pod -A -o jsonpath='{.items[*].status.containerStatuses[*].imageID}' | sed 's/ /\n/g' | sort | uniq
echo " "
echo "---------------------------------------------"
echo "[+] Image & Digest List(Duplicate) " # Image와 Image Digest
kubectl get pod -A -o jsonpath='{range .items[*]}Image: {.status.containerStatuses[*].image}{"\n"}Digest: {.status.containerStatuses[*].imageID}{"\n\n"}{end}' | sed 's/ /\n/g'
echo " "
echo "---------------------------------------------"
echo "[+] Detail "
kubectl get pod -A -o jsonpath='{range .items[*]}Node: {.spec.nodeName} | Namespace: {.metadata.namespace} | Pod: {.metadata.name} | Container: {.spec.containers[*].name} | Image: {.spec.containers[*].image}{"\n"}{end}'
echo " "
echo "---------------------------------------------"
echo "[+] Namespace List "
kubectl get namespace -o jsonpath='{.items[*].metadata.name}' | sed 's/ /\n/g' | sort
echo " "
echo "---------------------------------------------"
echo " => Please enter your namespace [ If you want to enter all namespaces, plz enter "all" ]"
read NS
echo "[+] The namespace you chose is $NS !!"

image_func()
{
	if [ $(ls -al | grep result_file | wc -l) -eq 1 ]; then
		echo "[-] Remove the result_file directory"
		rm -rf result_file
	fi
	
	mkdir result_file
	cd result_file

	if [ $1 == "namespace" ]; then
		kubectl get pod -n $NS -o jsonpath='{.items[*].spec.containers[*].image}' | sed 's/ /\n/g' | sort | uniq > image.txt
	elif [ $1 == "all" ]; then
		kubectl get pod -A -o jsonpath='{.items[*].spec.containers[*].image}' | sed 's/ /\n/g' | sort | uniq > image.txt
	fi
	
	while read LINE; do
		echo "[+] Start image pull: [$LINE]"
		docker pull -q $LINE
	done < image.txt
	echo " "
	echo " "
	
	# using docker save
	mkdir save_image
	while read LINE; do
		echo "[+] Save the image in tar format: [$LINE]"
		docker save $LINE > save_image/$(echo $LINE | sed 's/\//_/g' | sed 's/\./_/g' | sed 's/\:/-/g' ).tar # tar error by name
	done < image.txt
	echo "[*] Storing image file at 'result_file/save_image/'"
	echo " "
	echo " "
	
	# using Trivy
	while read LINE; do
		echo "[+] Storing image vulnerability information summary using trivy: [$LINE]"
		trivy image -q $LINE | grep Total: -B3 >> img_vuln_info.txt
		echo "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"  >> img_vuln_info.txt
	done < image.txt
	echo "[*] Storing image at 'result_file/img_vuln_info.txt'"
	
	echo " "
	echo " "
	
	# using Whaler
	mkdir dockerfile_dir
	while read LINE; do
	echo "[+] Using 'whaler' to guess the Dockerfile of the image and save it: [$LINE]"
	whaler $LINE > dockerfile_dir/$(echo $LINE | sed 's/\//_/g' | sed 's/\./_/g' | sed 's/\:/-/g' )
	done < image.txt
	echo "[*] Storing Dockerfile at 'result_file/dockerfile_dir/'"
	echo " "
	echo " "
	rm -rf image.txt
}

CHECK=$(systemctl status docker | wc -l)
if [ $CHECK -eq 0 ]; then
	echo "[!] ERROR: You need docker installation!! Run the following command"
	echo "[+] apt update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin"
	echo "[+] systemctl start docker"
	exit 100
fi

if [ $NS == "all" ] || [ $NS == "ALL" ] || [ $NS == "All" ] || [ $NS == "aLL" ]; then
	image_func "all"
else
	CHECK2=$(kubectl get pod -n $NS -o jsonpath='{.items[*].status.containerStatuses[*].image}' | wc -w)
	if [ $CHECK2 -le 0 ]; then
		echo "[!] ERROR: namespace with no or no pods in the namespace."
		exit 100
	fi
	image_func "namespace"
fi
