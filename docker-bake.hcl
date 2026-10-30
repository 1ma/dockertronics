variable "RUNNER_ARCH" {
  type = string
  default = "X64"
  description = "The architecture of the runner executing the job"
  validation {
    condition = contains(["ARM64", "X64"], RUNNER_ARCH)
    error_message = "Invalid value for 'RUNNER_ARCH' variable"
  }
}

variable "VERSION" {
  type = string
  default = "0.0.0"
  description = "Version of the software to build"
}

variable "VERSION_MAJOR" {
  type = string
  default = split(".", VERSION)[0]
  description = "Major software version for caching tags"
}

variable "PHP_MAJOR" {
  type = string
  default = format("%s.%s", split(".", VERSION)[0], split(".", VERSION)[1])
  description = "Major software version for caching tags (1maa/php only)"
}

variable "PUBLIC_ALPINE_IMAGE" {
  type = string
  default = "sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a" # alpine:3.24
}

variable "PUBLIC_CADDY_IMAGE" {
  type = string
  default = "sha256:e70b164da81ef698b3ad19af799ea6086ce6d9e48ed4079eb9fe26f6fbf14ee5" # caddy:alpine
}

variable "PUBLIC_DEBIAN_IMAGE" {
  type = string
  default = "sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4" # debian:trixie-slim
}

variable "PUBLIC_ECLIPSE_TEMURIN_IMAGE" {
  type = string
  default = "sha256:83f4a7fc27df94dcc7b8de04d14cbbba8da14406f921e966969c3b09000aa507" # eclipse-temurin:25
}

variable "PUBLIC_GOLANG_IMAGE" {
  type = string
  default = "sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb" # golang:alpine
}

variable "PUBLIC_GOLANG_DEBIAN_IMAGE" {
  type = string
  default = "sha256:c65ecfe613b539ac74c62a4c3b2c27e8f8a6076384c8f27e8a3c0f3be17cc385" # golang:trixie
}

variable "PUBLIC_NODE_IMAGE" {
  type = string
  default = "sha256:c6ad9e9c1d80f6eb607c26b4b0a132ff7a2344fad1c78ea3baa2a7d4c8de6d94" # node:26-alpine
}

target "php-86" {
  args = {
    PHP_VERSION = "8.6.0RC4"
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "php"
  dockerfile = "Dockerfile.86"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/php:8.6-RC"
  }]
  tags = ["1maa/php:8.6-RC"]
}

group "default" {
  description = "Dependency-free images that can be easily built concurrently"
  targets = [
    "frigate",
    "lnd",
    "protoc",
    "selfsig",
    "sftp",
    "sleepy"
  ]
}

target "electrs" {
  args = {
    PUBLIC_DEBIAN_IMAGE = PUBLIC_DEBIAN_IMAGE
  }
  context = "electrs"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/electrs:latest-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/electrs:latest-${RUNNER_ARCH}"]
}

target "erlang" {
  args = {
    ERLANG_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "erlang"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER_ARCH}"]
}

target "frigate" {
  args = {
    PUBLIC_DEBIAN_IMAGE = PUBLIC_DEBIAN_IMAGE
    PUBLIC_ECLIPSE_TEMURIN_IMAGE = PUBLIC_ECLIPSE_TEMURIN_IMAGE
  }
  context = "frigate"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/frigate:latest"
  }]
  tags = [
    "1maa/frigate:latest"
  ]
}

target "gearmand" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "gearmand"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/gearmand:latest-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/gearmand:latest-${RUNNER_ARCH}"]
}

target "haproxy" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/haproxy:latest-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/haproxy:latest-${RUNNER_ARCH}"]
}

target "lnd" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
    PUBLIC_GOLANG_IMAGE = PUBLIC_GOLANG_IMAGE
  }
  context = "lnd"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/lnd:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/lnd:latest"]
}

target "mempool-guide-backend" {
  args = {
    PUBLIC_NODE_IMAGE = PUBLIC_NODE_IMAGE
  }
  context = "mempool.guide/backend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:backend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:backend-${RUNNER_ARCH}"]
}

target "mempool-guide-frontend" {
  args = {
    PUBLIC_CADDY_IMAGE = PUBLIC_CADDY_IMAGE
    PUBLIC_NODE_IMAGE = PUBLIC_NODE_IMAGE
  }
  context = "mempool.guide/frontend"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/mempool.guide:frontend-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/mempool.guide:frontend-${RUNNER_ARCH}"]
}

target "php" {
  args = {
    PHP_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "php"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER_ARCH}"]
}

target "postgres" {
  args = {
    POSTGRES_VERSION = VERSION
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "postgres"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/postgres:${VERSION_MAJOR}-alpine-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/postgres:${VERSION_MAJOR}-alpine-${RUNNER_ARCH}"]
}

target "protoc" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
    PUBLIC_GOLANG_IMAGE = PUBLIC_GOLANG_IMAGE
  }
  context = "protoc"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/protoc:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/protoc:latest"]
}

target "selfsig" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "selfsig"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/selfsig:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/selfsig:latest"]
}

target "sftp" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "sftp"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sftp:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/sftp:latest"]
}

target "sleepy" {
  args = {
    PUBLIC_GOLANG_IMAGE = PUBLIC_GOLANG_IMAGE
  }
  context = "sleepy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/sleepy:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/sleepy:latest"]
}

target "sqlite" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "sqlite"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/sqlite:latest-${RUNNER_ARCH}"
  }]
  tags = ["ghcr.io/1ma/sqlite:latest-${RUNNER_ARCH}"]
}
