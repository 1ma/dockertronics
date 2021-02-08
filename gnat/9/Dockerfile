FROM ubuntu:20.04

ENV ALIRE_VERSION v1.0.0-rc1
ENV DEBIAN_FRONTEND noninteractive
ENV GCC_VERSION 9.3.0

WORKDIR /tmp

ADD https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz .

# https://gcc.gnu.org/install/prerequisites.html
RUN apt-get update && apt-get install -y \
    file \
    g++ \
    gcc \
    gnat \
    make \
    texinfo \
    unzip \
    wget \
    xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && tar xf gcc-${GCC_VERSION}.tar.xz \
 && cd gcc-${GCC_VERSION} \
 && ./contrib/download_prerequisites

# https://gcc.gnu.org/install/configure.html
RUN mkdir build \
 && cd build \
 && ./../gcc-${GCC_VERSION}/configure \
     --disable-multilib \
     --enable-languages=ada,c,c++ \
     --prefix=/usr/local/gnat

# https://gcc.gnu.org/install/build.html
RUN make -C build -j$(nproc)

# https://gcc.gnu.org/install/finalinstall.html
RUN make -C build install-strip

RUN wget https://github.com/alire-project/alire/releases/download/v${ALIRE_VERSION}/alr-${ALIRE_VERSION}-bin-linux.zip \
 && unzip alr-${ALIRE_VERSION}-bin-linux.zip


FROM ubuntu:20.04

COPY --from=0 /tmp/bin/alr    /usr/local/bin/alr
COPY --from=0 /usr/local/gnat /usr/local

RUN apt-get update && apt-get install -y \
    binutils \
    libc6-dev \
 && rm -rf /var/lib/apt/lists/*
