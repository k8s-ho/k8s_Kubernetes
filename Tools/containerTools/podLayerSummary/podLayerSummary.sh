#!/bin/bash

# option description
usage()
{
  echo "<options>"
  echo "    -a     : Show all information."
  echo "    -f     : Filter and Show. ./podLayerSummary.sh -f [Container ID]"
  echo "    -h     : Show this message."
  exit 100
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

VAR=$(crictl ps -q)
array=($VAR)
for var in "${array[@]}"
do
  crictl inspect $(crictl ps --id $var -q) | jq -r '"[POD NAME] " + .info.runtimeSpec.annotations."io.kubernetes.cri.sandbox-name", "[Container NAME] " + .info.runtimeSpec.annotations."io.kubernetes.cri.container-name", "[Container PID] " + (.info.pid | tostring)'
  echo "[Container ID] $var"
  echo "[Container Data Path] /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots"
  echo "[+] Container Data list"
  cat /proc/$(crictl inspect $(crictl ps --id $var -q) | jq '.info.pid')/mounts | grep -i overlay | sed 's/:/\n/g' | sed 's/,/\n/g' | sed 's/\/var\/lib\/containerd\/io.containerd.snapshotter.v1.overlayfs\/snapshots\///g'
  echo " "
  echo "==============================================================="
done
