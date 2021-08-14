FROM 1maa/gcc:6bebd55e as dependencies

ENV GPR_PROJECT_PATH=/opt/xmlada/share/gpr:/opt/libgpr/share/gpr

WORKDIR /tmp

RUN apt-get update \
 && apt-get install --yes \
    git \
    gprbuild \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/AdaCore/xmlada \
 && git clone https://github.com/AdaCore/gprbuild \
 && git clone https://github.com/AdaCore/gnatcoll-core

RUN cd xmlada \
 && ./configure --prefix=/opt/xmlada \
 && make all install

RUN cd gprbuild \
 && make prefix=/opt/libgpr setup \
 && make libgpr.build libgpr.install

RUN cd gnatcoll-core \
 && make prefix=/opt/libgnatcoll setup \
 && make all install


FROM 1maa/ocaml:latest as ocaml
FROM 1maa/gcc:6bebd55e

ENV DEBIAN_FRONTEND=noninteractive
ENV GPR_PROJECT_PATH=/opt/xmlada/share/gpr:/opt/libgpr/share/gpr:/opt/libgnatcoll/share/gpr
ENV SPARK_COMMIT=5da8c83bcdc679c21826b3acfd1616e750a4ca26

WORKDIR /tmp

COPY gnatvsn.adb /usr/local/src/gcc/gcc/ada/gnatvsn.adb

COPY --from=dependencies /opt /opt

COPY --from=ocaml /root/.opam /root/.opam

RUN apt-get update \
 && apt-get install --yes \
    curl \
    git \
    gprbuild \
    python3 \
    unzip \
    zlib1g-dev \
    nano \
    tree \
 && rm -rf /var/lib/apt/lists/* \
 && git clone --branch=fsf https://github.com/AdaCore/Spark2014

WORKDIR /tmp/Spark2014

RUN git checkout ${SPARK_COMMIT} \
 && git submodule init \
 && git submodule update \
 && ln -s /usr/local/src/gcc/gcc/ada gnat2why/gnat_src \
 && ln -s x86_64-linux src/common/x86_64-linux-gnu \
 && sed -i 's@x86_64-linux@x86_64-linux-gnu@' gnatprove.gpr \
 && . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null \
 && make setup \
 && make \
 && make install-all
