FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GCC_COMMIT=c94424b0ed786ec92b6904da69af8b5243b34fdc

WORKDIR /tmp

RUN apt-get update \
 && apt-get install --yes \
    bison \
    curl \
    file \
    flex \
    g++ \
    gcc \
    gnat \
    make \
    perl \
    texinfo \
 && rm -rf /var/lib/apt/lists/*

ADD https://github.com/gcc-mirror/gcc/archive/${GCC_COMMIT}.tar.gz .

RUN tar zxf ${GCC_COMMIT}.tar.gz \
 && cd gcc-${GCC_COMMIT} \
 && ./contrib/download_prerequisites \
 && cd .. \
 && mkdir gcc-build \
 && cd gcc-build \
 && ../gcc-${GCC_COMMIT}/configure --prefix=/usr/local/gcc --disable-multilib --enable-languages=c,c++,ada

RUN make -C gcc-build -j$(nproc)

RUN make -C gcc-build install


FROM ubuntu:20.04

ENV GCC_COMMIT=c94424b0ed786ec92b6904da69af8b5243b34fdc
ENV PATH=/usr/local/gcc/bin:$PATH

COPY --from=0 /usr/local/gcc         /usr/local/gcc
COPY --from=0 /tmp/gcc-${GCC_COMMIT} /usr/local/src/gcc

RUN ln -s /usr/local/gcc/bin/gcc /usr/local/gcc/bin/cc \
 && ln -s /usr/local/gcc/bin/gcc /usr/local/gcc/bin/gnatgcc \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    binutils \
    libc6-dev \
    make \
 && rm -rf /var/lib/apt/lists/*
