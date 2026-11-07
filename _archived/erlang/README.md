> [!WARNING]
> **This image is archived.** It is no longer built or published, and the existing tags on Docker Hub
> will not receive any updates. It was retired on 2026-11-07 because it was no longer needed.
> The files are kept here for reference only and may not build anymore.

# Erlang development image

### Description

The latest and greatest Erlang/OTP built from source with an open TCP port
to be able to expose a web service, and rebar3 with a few plugins:

* rebar_cmd -> ability to define custom tasks in rebar.config
* rebar3_auto -> automatically compile & reload modified source files
* rebar3_hex -> hex.pm integration
