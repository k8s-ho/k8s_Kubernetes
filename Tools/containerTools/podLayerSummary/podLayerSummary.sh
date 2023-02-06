#!/bin/bash

# option description
usage()
{
  echo "<options> default: Show all information"
  echo "    -f     : Only filtered containers are shown  ex) ./podLayerSummary.sh -f [Container ID]"
  echo "    -h     : Show this message."
  exit 100
}

# Run option 
while getopts ah opts; do
        case $opts in
        f) filter
                ;;
        h) usage
                ;;
        esac
done

filter(){

}

# Default: Show all
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
