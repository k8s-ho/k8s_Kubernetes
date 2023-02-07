#!/bin/bash

# option description
usage()
{
  echo "<options> default: Show all information"
  echo "    -f     : Only filtered containers are shown  ex) ./podLayerSummary.sh -f [Container ID]"
  echo "    -h     : Show this message."
  exit 100
}

# print information
print_data(){
    crictl inspect $(crictl ps --id $1 -q) | jq -r '"[POD NAME] " + .info.runtimeSpec.annotations."io.kubernetes.cri.sandbox-name", "[Container NAME] " + .info.runtimeSpec.annotations."io.kubernetes.cri.container-name", "[Container PID] " + (.info.pid | tostring)'
    echo "[Container ID] $(crictl ps --id $1 -q)"
    echo "[Container Data Path] /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/snapshots"
    echo "[+] Container Data list"
    cat /proc/$(crictl inspect $(crictl ps --id $1 -q) | jq '.info.pid')/mounts | grep -i overlay | sed 's/:/\n/g' | sed 's/,/\n/g' | sed 's/\/var\/lib\/containerd\/io.containerd.snapshotter.v1.overlayfs\/snapshots\///g'
    echo " "
    echo "==============================================================="
}

# filter option
filter(){
  # container (-q) id data parsing
  VAL=$(crictl ps -q | cut -c 1-13)
  array=($VAL)
  NUM=0

  # Check the existence of the entered container ID 
  for var in "${array[@]}"
  do
    if [ ${var} == $1 ];then
      ((NUM++))
    fi
  done

  # Proceed if container id exists
  if [ ${NUM} -ge 1 ];then
    print_data $1
  else
    echo "[-] This container does not exist :("
  fi
  exit 100
}

# Run option 
while getopts f:h opts; do
        case $opts in
        f) filter $OPTARG
                ;;
        h) usage
                ;;
        *) echo "[-] Undefined option or invalid usage :(" 
           exit 100
                ;;
        esac
done

# Default: Show all
VAR=$(crictl ps -q)
array=($VAR)
for var in "${array[@]}"
do
  print_data $var
done
