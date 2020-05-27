FROM alpine:3.11

COPY bin/entrypoint.sh /entrypoint.sh
COPY build/etcd.sh /build-etcd.sh
RUN sh /build-etcd.sh
COPY certs/* /etc/certs/
ENTRYPOINT ["/entrypoint.sh"]
