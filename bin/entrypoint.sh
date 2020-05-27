#!/bin/sh

IP=$(ip -o r g 1| sed -r 's/.*src[ ]*([0-9.]*).*/\1/')
echo $IP

if [ -f /data/node-id.txt ]
then
    ETCD_NAME=$(cat /data/node-id.txt)
else
    ETCD_NAME=etcd-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10 ; echo '')
    echo -n ${ETCD_NAME} > /data/node-id.txt
    mkdir /data/etcd
    if [ -z "$DISCOVERY_URL" ]
    then
        echo "Running without discovery"
        EXTRA_OPTS="--initial-advertise-peer-urls https://${IP}:2380"
    else
        echo "Running external etcd discovery"
        EXTRA_OPTS="--initial-advertise-peer-urls https://${IP}:2380 --discovery $DISCOVERY_URL"
    fi
fi

exec /usr/local/bin/etcd --name ${ETCD_NAME} --data-dir /data/etcd \
     --listen-peer-urls https://${IP}:2380 \
     --listen-client-urls https://${IP}:2379,https://127.0.0.1:2379 \
     --advertise-client-urls https://${IP}:2379 \
     --trusted-ca-file=/etc/certs/ca.pem \
     --cert-file=/etc/certs/backend.pem \
     --key-file=/etc/certs/backend-key.pem \
     --client-cert-auth \
     --peer-trusted-ca-file=/etc/certs/ca.pem \
     --peer-cert-file=/etc/certs/backend.pem \
     --peer-key-file=/etc/certs/backend-key.pem \
     --peer-client-cert-auth \
     --auto-compaction-mode revision \
     --auto-compaction-retention 2 \
     $EXTRA_OPTS
