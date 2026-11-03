> [!WARNING]
> **This image is archived.** It is no longer built or published, and the existing tags on Docker Hub
> will not receive any updates. It was retired on 2021-10-13 because it was no longer needed.
> The files are kept here for reference only and may not build anymore.

# 1maa/jekyll:latest

An alpine-based image with Ruby, Bundler and the latest Jekyll preinstalled.

It is not able to build gem extensions, as I just need the minimum amount of tools required to build [my static blog](https://blog.1mahq.com).
Therefore, it is not meant for general use.

Note: `ruby-bigdecimal` and `ruby-json` are two *implicit* dependencies of Jekyll.
Apparently they are usually packaged in the default Ruby installation, but not in Alpine.
