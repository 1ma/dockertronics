> [!WARNING]
> **This image is archived.** It is no longer built or published, and the existing tags on Docker Hub
> will not receive any updates. It was retired on 2025-12-28 because it was no longer needed and its `php:7.3`
> base image is long past end of life. The files are kept here for reference only and may not build anymore.

# 1maa/xhgui:latest

A `php:7.3-apache` image with [xhgui](https://github.com/perftools/xhgui) preinstalled.


### Sample Docker Compose file

```yaml
name: xhgui

services:
  xhgui:
    image: 1maa/xhgui:latest
    environment:
      - XHGUI_MONGO_HOSTNAME=mongo
    ports:
      - "127.0.0.1:8000:80"

  mongo:
    image: mongo:7.0
    environment:
      - MONGO_INITDB_DATABASE=xhprof
```
