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
  default = "sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f" # debian:trixie-slim
}

variable "PUBLIC_ECLIPSE_TEMURIN_IMAGE" {
  type = string
  default = "sha256:2d5d5e9b533342a565907c84f47a2ec298c40cde7b13a3ca85d4950fa456a641" # eclipse-temurin:25
}

variable "PUBLIC_GOLANG_IMAGE" {
  type = string
  default = "sha256:d200d2dd76b03a99b52651fd1325aff7dcd35422c35c01bac56571b0507f3deb" # golang:alpine
}

variable "PUBLIC_GOLANG_DEBIAN_IMAGE" {
  type = string
  default = "sha256:47667934874913a449b96faa7ef4777fa285d9ec29126ee80ed61c45b7cccf0e" # golang:trixie
}

variable "PUBLIC_NODE_IMAGE" {
  type = string
  default = "sha256:6f08a523443ddedf52941874c203475b0ad503e859ad70cb26ab8be9a517dbd5" # node:26-alpine
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
