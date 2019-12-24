FROM hotio/base@sha256:e73b1dcb7b4ab2b78987f2b7c1744737768b6c6ecbb0732c56d1cd15a517800b

ARG DEBIAN_FRONTEND="noninteractive"

ENV SOURCE="/source" MOUNTPOINT="/mountpoint"

# https://github.com/hasse69/rar2fs/releases
# https://www.rarlab.com/rar_add.htm
ARG RAR2FS_VERSION=1.28.0
ARG UNRARSRC_VERSION=5.8.3

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        fuse \
        libfuse-dev autoconf automake build-essential && \
# install rar2fs
    tempdir="$(mktemp -d)" && \
    curl -fsSL "https://github.com/hasse69/rar2fs/archive/v${RAR2FS_VERSION}.tar.gz" | tar xzf - -C "${tempdir}" --strip-components=1 && \
    curl -fsSL "https://www.rarlab.com/rar/unrarsrc-${UNRARSRC_VERSION}.tar.gz" | tar xzf - -C "${tempdir}" && \
    cd "${tempdir}/unrar" && \
    make lib && make install-lib && \
    cd "${tempdir}" && \
    autoreconf -f -i && \
    ./configure && make && make install && \
    cd ~ && \
    rm -rf "${tempdir}" && \
# clean up
    apt purge -y libfuse-dev autoconf automake build-essential && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /
