FROM alpine:3.12 as builder

# install
RUN apk add --no-cache autoconf automake fuse-dev g++ make

# https://www.rarlab.com/rar_add.htm
ARG RAR2FS_VERSION
ARG UNRARSRC_VERSION=5.9.2

# install packages
RUN tempdir="/rar2fs" && \
    mkdir "${tempdir}" && \
    wget -O - "https://github.com/hasse69/rar2fs/archive/v${RAR2FS_VERSION}.tar.gz" | tar xzf - -C "${tempdir}" --strip-components=1 && \
    wget -O - "https://www.rarlab.com/rar/unrarsrc-${UNRARSRC_VERSION}.tar.gz" | tar xzf - -C "${tempdir}" && \
    cd "${tempdir}/unrar" && \
    make lib && \
    cd "${tempdir}" && \
    autoreconf -f -i && \
    ./configure && make


FROM alpine@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c
LABEL maintainer="hotio"
ENV FUSE_THREAD_STACK=2048000
ENTRYPOINT ["rar2fs", "-f", "-o", "auto_unmount"]
RUN apk add --no-cache fuse libstdc++
COPY --from=builder /rar2fs/src/rar2fs /usr/local/bin/rar2fs

ARG LABEL_CREATED
LABEL org.opencontainers.image.created=$LABEL_CREATED
ARG LABEL_TITLE
LABEL org.opencontainers.image.title=$LABEL_TITLE
ARG LABEL_REVISION
LABEL org.opencontainers.image.revision=$LABEL_REVISION
ARG LABEL_SOURCE
LABEL org.opencontainers.image.source=$LABEL_SOURCE
ARG LABEL_VENDOR
LABEL org.opencontainers.image.vendor=$LABEL_VENDOR
ARG LABEL_URL
LABEL org.opencontainers.image.url=$LABEL_URL
ARG LABEL_VERSION
LABEL org.opencontainers.image.version=$LABEL_VERSION
