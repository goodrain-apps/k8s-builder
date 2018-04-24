FROM golang:1.7.3
MAINTAINER root@goodrain.com

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install rsync -y \
    && rm -rf /var/lib/apt/lists/*
    
COPY upx /usr/local/bin/
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
