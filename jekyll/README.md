# 1maa/jekyll:latest

An alpine-based image with Ruby, Bundler and the latest Jekyll preinstalled.

It is not able to build gem extensions, as I just need the minimum amount of tools required to build [my static blog](https://blog.1mahq.com).
Therefore, it is not meant for general use.

Note: `ruby-bigdecimal` and `ruby-json` are two *implicit* dependencies of Jekyll.
Apparently they are usually packaged in the default Ruby installation, but not in Alpine.
