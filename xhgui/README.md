# 1maa/xhgui:latest

A `php:7.3-apache` image with [xhgui](https://github.com/perftools/xhgui) preinstalled.


### Sample Docker Compose file

```yaml
version: "3"

services:
  xhgui:
    image: 1maa/xhgui:latest
    environment:
      - XHGUI_MONGO_HOSTNAME=mongo
    ports:
      - "127.0.0.1:8000:80"

  mongo:
    image: mongo:4.1
    environment:
      - MONGO_INITDB_DATABASE=xhprof
```
