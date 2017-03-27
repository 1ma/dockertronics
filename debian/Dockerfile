FROM debian:jessie

# the main process is managed with the Tini init process in order to properly deal with zombie subprocesses
ADD https://github.com/krallin/tini/releases/download/v0.14.0/tini /tini

# Installing the 'apt-utils' package gets rid of the 'debconf: delaying package configuration, since apt-utils is not installed'
# error message when installing any other package with the apt-get package manager.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-utils \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
 && rm -rf /var/lib/apt/lists/* \
 && echo "\nexport TERM=xterm" >> /etc/bash.bashrc \
 && chmod +x /tini

ENTRYPOINT ["/tini", "--"]
