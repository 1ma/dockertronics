FROM alpine:3.11

RUN apk add --no-cache \
    build-base \
    libstdc++ \
    ruby \
    ruby-bigdecimal \
    ruby-dev \
    ruby-json \
 && gem install \
    bundler \
    jekyll \
 && apk del \
    build-base \
    ruby-dev
