ARG BRANCH
FROM hotio/base:${BRANCH}

ARG DEBIAN_FRONTEND="noninteractive"

ENV INPUT_DIR="/input" OUTPUT_DIR="/output"

COPY root/ /
