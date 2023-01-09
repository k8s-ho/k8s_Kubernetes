#!/bin/sh
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
kubectl get pod -A -o jsonpath='{range .items[*]}Namespace: {.metadata.namespace} | Pod: {.metadata.name} | Container: {.spec.containers[*].name} | Image: {.spec.containers[*].image}{"\n"}{end}'
echo " "
echo "---------------------------------------------"
echo "[+] Namespace List "
kubectl get namespace -o jsonpath='{.items[*].metadata.name}' | sed 's/ /\n/g' | sort
echo " "
echo "---------------------------------------------"
echo " => Enter the Namespace: "
read NS
echo "[+] The namespace you chose is $NS !!"

CHECK=$(kubectl get pod -n $NS -o jsonpath='{.items[*].status.containerStatuses[*].image}' | wc -w)
if [ $CHECK -le 0 ]; then
	echo "[!] ERROR: namespace with no or no pods in the namespace."
	exit 100
fi

CHECK2=$(systemctl status docker | wc -l)
if [ $CHECK2 -eq 0 ]; then
	echo "[!] ERROR: You need docker installation!! Run the following command"
	echo "[+] apt update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin"
	echo "[+] systemctl start docker"
	exit 100
fi

mkdir download_image
cd download_image

kubectl get pod -n $NS -o jsonpath='{.items[*].spec.containers[*].image}' | sed 's/ /\n/g' | sort | uniq > image.txt
while read LINE; do
	echo "[+] Start image pull: [$LINE]"
	docker pull $LINE
done < image.txt

while read LINE; do
	echo "[+] Save the image in tar format: [$LINE]"
	docker save $LINE -o $LINE.tar
done < image.txt
rm -rf image.txt
