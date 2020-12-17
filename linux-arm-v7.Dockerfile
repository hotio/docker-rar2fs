FROM alpine:3.12 as builder

# install
RUN apk add --no-cache autoconf automake fuse-dev g++ make

# https://www.rarlab.com/rar_add.htm
ARG VERSION
ARG UNRARSRC_VERSION=5.9.2

# install packages
RUN tempdir="/rar2fs" && \
    mkdir "${tempdir}" && \
    wget -O - "https://github.com/hasse69/rar2fs/archive/v${VERSION}.tar.gz" | tar xzf - -C "${tempdir}" --strip-components=1 && \
    wget -O - "https://www.rarlab.com/rar/unrarsrc-${UNRARSRC_VERSION}.tar.gz" | tar xzf - -C "${tempdir}" && \
    cd "${tempdir}/unrar" && \
    make lib && \
    cd "${tempdir}" && \
    autoreconf -f -i && \
    ./configure && make


FROM alpine@sha256:299294be8699c1b323c137f972fd0aa5eaa4b95489c213091dcf46ef39b6c810
LABEL maintainer="hotio"
ENV FUSE_THREAD_STACK=2048000
ENTRYPOINT ["rar2fs", "-f", "-o", "auto_unmount"]
RUN apk add --no-cache fuse libstdc++
COPY --from=builder /rar2fs/src/rar2fs /usr/local/bin/rar2fs
