#!/bin/bash

if [ "$1" == "bash" ];then
    exec /bin/bash
elif [ "$1" == "version" ];then
    exec /usr/bin/kube-apiserver version
else
    exec /usr/bin/kube-apiserver $@
fi