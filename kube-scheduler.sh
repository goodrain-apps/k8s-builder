#!/bin/bash

if [ "$1" == "bash" ];then
    exec /bin/bash
elif [ "$1" == "bash" ];then
    exec /usr/bin/kube-scheduler --version
else
    exec /usr/bin/kube-scheduler $@
fi