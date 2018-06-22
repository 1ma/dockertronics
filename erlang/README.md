# Erlang development image

### Description

A simple extension of the `erlang:21-alpine` image with rebar3, an open TCP
port (8080) to be able to expose a web service and a few global plugins:

* rebar_cmd -> ability to define custom tasks in rebar.config
* rebar3_auto -> automatically compile & reload modified source files
* rebar3_hex -> hex.pm integration
