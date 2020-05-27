#!/bin/sh
####### Update etcd version here
ETCD_VER=v3.4.3

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

apk update
apk add curl
mkdir /etc/certs
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /usr/local/bin --strip-components=1 etcd-${ETCD_VER}-linux-amd64/etcd etcd-${ETCD_VER}-linux-amd64/etcdctl 
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
