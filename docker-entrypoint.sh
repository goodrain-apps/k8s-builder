#!/bin/bash

[[ $DEBUG ]] && set -x

kubes=( kubectl kubelet kube-apiserver kube-controller-manager kube-scheduler )

function compress(){
  [[ $COMPRESS ]] && upx --best ./_output/local/bin/linux/amd64/$@
}

case $1 in
clean)
  make clean;;
kubectl)
  make $1 && compress $1
  ;;
kubelet)
  make $1 && compress $1
  ;;
kube-apiserver)
  make $1 && compress $1
  ;;
kube-controller-manager)
  make $1 && compress $1
  ;;
kube-scheduler)
  make $1 && compress $1
all)
  for m in ${kubes[*]}
  do
    make $1 && compress $1
  done
"*")
  echo "Please input kubenetes component name <kubectl|kubelet|kube-apiserver|kube-controller-manager|kube-scheduler> or <all>"
  ;;
esac
