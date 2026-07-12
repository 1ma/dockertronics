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
  default = "sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b" # :3.24
}

variable "PUBLIC_CADDY_IMAGE" {
  type = string
  default = "sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648" # :alpine
}

variable "PUBLIC_DEBIAN_IMAGE" {
  type = string
  default = "sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2" # :trixie-slim
}

variable "PUBLIC_ECLIPSE_TEMURIN_IMAGE" {
  type = string
  default = "sha256:68868d04fa9cfd5f5c6abec0b5cef86d8de2bf9c62c37c7d3e4f0f80f5cfd7ff" # :25
}

variable "PUBLIC_GOLANG_IMAGE" {
  type = string
  default = "sha256:0178a641fbb4858c5f1b48e34bdaabe0350a330a1b1149aabd498d0699ff5fb2" # :alpine
}

variable "PUBLIC_GOLANG_DEBIAN_IMAGE" {
  type = string
  default = "sha256:116489021a0d8ca3facf79f84ee69052cff88733547150a644d45c5eaa91dc43" # :trixie
}

variable "PUBLIC_NODE_IMAGE" {
  type = string
  default = "sha256:e88a35be04478413b7c71c455cd9865de9b9360e1f43456be5951032d7ac1a66" # :26-alpine
}

group "default" {
  description = "Dependency-free images that can be easily built concurrently"
  targets = [
    "frigate",
    "haproxy",
    "lnd",
    "protoc",
    "selfsig",
    "sftp",
    "sleepy"
  ]
}

target "cln-alpine" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
    PUBLIC_GOLANG_IMAGE = PUBLIC_GOLANG_IMAGE
  }
  context = "core-lightning"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/core-lightning:alpine-${RUNNER_ARCH}"
  }]
  dockerfile = "alpine/Dockerfile"
  tags = ["ghcr.io/1ma/core-lightning:alpine-${RUNNER_ARCH}"]
}

target "cln-debian" {
  args = {
    PUBLIC_DEBIAN_IMAGE = PUBLIC_DEBIAN_IMAGE
    PUBLIC_GOLANG_IMAGE = PUBLIC_GOLANG_DEBIAN_IMAGE
  }
  context = "core-lightning"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "ghcr.io/1ma/core-lightning:debian-${RUNNER_ARCH}"
  }]
  dockerfile = "debian/Dockerfile"
  tags = ["ghcr.io/1ma/core-lightning:debian-${RUNNER_ARCH}"]
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
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "1maa/frigate:latest"
  ]
}

target "haproxy" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/haproxy:latest"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/haproxy:latest"]
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
