FROM alpine:3.9

ADD https://s3.amazonaws.com/rebar3/rebar3 /usr/local/bin/rebar3

RUN chmod +x /usr/local/bin/rebar3


FROM erlang:22-alpine

RUN apk add --no-cache inotify-tools

COPY          rebar.config          /root/.config/rebar3/
COPY --from=0 /usr/local/bin/rebar3 /usr/local/bin/

EXPOSE 8080
