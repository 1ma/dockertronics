variable "RUNNER" {
  type = string
  default = "ubuntu-24.04"
  description = "Runner that built the image"
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
  default = "sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11" # :3.23
}

variable "PUBLIC_CADDY_IMAGE" {
  default = "sha256:834468128c7696cec0ceea6172f7d692daf645ae51983ca76e39da54a97c570d" # :alpine
}

variable "PUBLIC_DEBIAN_IMAGE" {
  default = "sha256:cedb1ef40439206b673ee8b33a46a03a0c9fa90bf3732f54704f99cb061d2c5a" # :trixie-slim
}

variable "PUBLIC_GOLANG_IMAGE" {
  default = "sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1" # :alpine
}

variable "PUBLIC_GOLANG_DEBIAN_IMAGE" {
  default = "sha256:4a7137ea573f79c86ae451ff05817ed762ef5597fcf732259e97abeb3108d873" # :trixie
}

variable "PUBLIC_NODE_IMAGE" {
  default = "sha256:bdf2cca6fe3dabd014ea60163eca3f0f7015fbd5c7ee1b0e9ccb4ced6eb02ef4" # :25-alpine
}

group "default" {
  description = "Dependency-free images that can be easily built concurrently"
  targets = [
    "haproxy",
    "lnd",
    "protoc",
    "selfsig",
    "sftp",
    "sleepy"
  ]
}

group "rust-build" {
  description = "Images involving cumbersome Rust builds"
  targets = [
    "cln-alpine",
    "cln-debian",
    "electrs",
    "mempool-guide-backend",
    "mempool-guide-frontend"
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
    ref = "1maa/core-lightning:alpine"
  }]
  dockerfile = "alpine/Dockerfile"
  tags = [
    "1maa/core-lightning:alpine",
    "1maa/core-lightning:latest"
  ]
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
    ref = "1maa/core-lightning:debian"
  }]
  dockerfile = "debian/Dockerfile"
  tags = ["1maa/core-lightning:debian"]
}

target "electrs" {
  args = {
    PUBLIC_DEBIAN_IMAGE = PUBLIC_DEBIAN_IMAGE
  }
  context = "electrs"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/electrs:latest"
  }]
  tags = ["1maa/electrs:latest"]
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
    ref = "ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/erlang:${VERSION_MAJOR}-${RUNNER}"]
}

target "haproxy" {
  args = {
    PUBLIC_ALPINE_IMAGE = PUBLIC_ALPINE_IMAGE
  }
  context = "haproxy"
  cache-to = [{type = "inline"}]
  cache-from = [{
    type = "registry"
    ref = "1maa/haproxy:3.2"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "1maa/haproxy:3.2",
    "1maa/haproxy:latest"
  ]
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
    ref = "1maa/mempool.guide:backend"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/mempool.guide:backend"]
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
    ref = "1maa/mempool.guide:frontend"
  }]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["1maa/mempool.guide:frontend"]
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
    ref = "ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/php:${PHP_MAJOR}-${RUNNER}"]
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
    ref = "ghcr.io/1ma/postgres:${VERSION_MAJOR}-${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/postgres:${VERSION_MAJOR}-${RUNNER}"]
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
    ref = "ghcr.io/1ma/sqlite:${RUNNER}"
  }]
  tags = ["ghcr.io/1ma/sqlite:${RUNNER}"]
}
