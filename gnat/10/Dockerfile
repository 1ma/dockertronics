FROM 1maa/alpine:3.14 AS alire

ENV ALIRE_VERSION v1.0.1

WORKDIR /tmp

RUN apk add --no-cache \
    binutils \
    gcc-gnat \
    git \
    gprbuild@edge-testing \
    libc-dev \
 && git clone --depth 1 --branch ${ALIRE_VERSION} --recurse-submodules https://github.com/alire-project/alire.git \
 && gprbuild -j$(nproc) -XALIRE_BUILD_MODE=release -P alire/alr_env \
 && strip --strip-all alire/bin/alr


FROM 1maa/alpine:3.14

COPY --from=alire /tmp/alire/bin/alr /usr/local/bin/alr

RUN apk add --no-cache \
    curl \
    gcc-gnat \
    git \
    gprbuild@edge-testing \
    libc-dev
