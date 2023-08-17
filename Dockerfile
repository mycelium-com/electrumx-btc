FROM python:3.11-alpine

ADD . /electrumx

RUN apk add --no-cache build-base openssl && \
    apk add --no-cache --repository https://nl.alpinelinux.org/alpine/latest-stable/community leveldb-dev

# https://github.com/wbolster/plyvel/issues/114#issuecomment-1595934986
RUN cd /electrumx && \
    CFLAGS=-fno-rtti pip install --force-reinstall --no-cache-dir plyvel && \
    pip install .[ujson,uvloop] && \
    apk del build-base && rm -rf /tmp/*

ENV ALLOW_ROOT 1
ENV DB_DIRECTORY /data
ENV HOME /data
ENV HOST ""
ENV SERVICES tcp://:50001,ws://:50002,rpc://127.0.0.1

WORKDIR /data
VOLUME /data
EXPOSE 50001/tcp 50002/tcp

CMD /electrumx/electrumx_server; /electrumx/electrumx_compact_history

LABEL org.opencontainers.image.source=https://github.com/mycelium-com/electrumx-btc