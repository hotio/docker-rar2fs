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


FROM alpine@sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01
LABEL maintainer="hotio"

ENTRYPOINT ["rar2fs", "-f", "-o", "auto_unmount"]

# install packages
RUN apk add --no-cache fuse libstdc++

COPY --from=builder /rar2fs/src/rar2fs /usr/local/bin/rar2fs
