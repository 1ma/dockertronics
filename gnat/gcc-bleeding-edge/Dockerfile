FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV GCC_COMMIT=6bebd55e12375b397ed187630bb57d58611dfc5f

WORKDIR /tmp

ADD https://github.com/gcc-mirror/gcc/archive/${GCC_COMMIT}.tar.gz gcc.tar.gz

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
 && tar zxf gcc.tar.gz \
 && cp -r gcc-${GCC_COMMIT} gcc-src \
 && cd gcc-${GCC_COMMIT} \
 && ./contrib/download_prerequisites

RUN mkdir gcc-build \
 && cd gcc-build \
 && ../gcc-${GCC_COMMIT}/configure --prefix=/usr/local/gcc --disable-multilib --enable-languages=c,c++,ada

RUN make -C gcc-build -j$(nproc)

RUN make -C gcc-build install


FROM ubuntu:20.04

ENV PATH=/usr/local/gcc/bin:$PATH

COPY --from=0 /usr/local/gcc /usr/local/gcc
COPY --from=0 /tmp/gcc-src   /usr/local/src/gcc

RUN ln -s /usr/local/gcc/bin/gcc /usr/local/gcc/bin/cc \
 && ln -s /usr/local/gcc/bin/gcc /usr/local/gcc/bin/gnatgcc \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    binutils \
    libc6-dev \
    make \
 && rm -rf /var/lib/apt/lists/*
