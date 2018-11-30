#!/bin/bash

if [ "$1" == "bash" ];then
    exec /bin/bash
elif [ "$1" == "version" ];then
    exec /usr/bin/hyperkube kubelet --version
else
    exec /usr/bin/hyperkube $@
fi