#!/bin/bash
VAR=$(crictl ps -q)
array=($VAR)
for var in "${array[@]}"
do
  crictl inspect $(crictl ps --id $var -q) | jq -r '"[POD NAME] " + .status.metadata.name, "[POD PID] " + (.info.pid | tostring)'
  echo "[+] Container ID= $var"
  echo "[+] Container data base path = /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots/"
  cat /proc/$(crictl inspect $(crictl ps --id $var -q) | jq '.info.pid')/mounts | grep -i overlay | sed 's/:/\n/g' | sed 's/,/\n/g' | sed 's/\/var\/lib\/containerd\/io.containerd.snapshotter.v1.overlayfs\/snapshots\///g'
  echo " "
  echo "==============================================================="
done
