FROM alpine:3.11

RUN apk add --no-cache \
    build-base \
    libstdc++ \
    ruby \
    ruby-dev \
 && gem install \
    bigdecimal \
    bundler \
    jekyll \
    json \
 && apk del \
    build-base \
    ruby-dev
