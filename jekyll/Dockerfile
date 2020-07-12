FROM alpine:3.12

RUN apk add --no-cache \
    build-base \
    git \
    libstdc++ \
    ruby \
    ruby-bigdecimal \
    ruby-dev \
    ruby-json \
    tree \
 && gem install \
    bundler \
    jekyll \
 && apk del \
    build-base \
    ruby-dev
