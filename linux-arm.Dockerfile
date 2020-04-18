FROM hotio/base@sha256:9c7833cc31199260454fff82e03c29eea7211ae2bb128b3ba4b620c0d5c2b018

ARG DEBIAN_FRONTEND="noninteractive"

ENV SOURCE="/source" MOUNTPOINT="/mountpoint"

# https://www.rarlab.com/rar_add.htm
ARG RAR2FS_VERSION
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
