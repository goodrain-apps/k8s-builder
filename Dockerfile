FROM golang:1.7.3
MAINTAINER root@goodrain.com

RUN apt-get update \
    && apt-get install rsync -y \
    && rm -rf /var/lib/apt/lists/*
    
ADD upx /usr/local/bin/
